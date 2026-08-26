#Requires -Version 5.1

[CmdletBinding()]
param(
    [switch]$ContractCheck,
    [switch]$NoLaunch,
    [switch]$NoOpenRecord,
    [string]$WorkDir = "",
    [switch]$HistoricalEvidenceOnly
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Historical evidence-only use (pre-SX-DEC-060 bytes only):
#   powershell -ExecutionPolicy Bypass -File .\RUN_SX59_POC_SELF_RUN.ps1 -HistoricalEvidenceOnly
# Historical contract verification:
#   powershell -ExecutionPolicy Bypass -File .\RUN_SX59_POC_SELF_RUN.ps1 -HistoricalEvidenceOnly -ContractCheck -NoLaunch -NoOpenRecord

$Repository = "alsdmlals4-eng/Switchy-Express-Cargo-Puzzle"
$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$PointerPath = Join-Path $RepoRoot "evidence\acceptance\current_poc_candidate.json"

if (-not $HistoricalEvidenceOnly) {
    throw "HISTORICAL_EVIDENCE_ONLY: this launcher is limited to pre-SX-DEC-060 Candidate 003 exact bytes. It is not a post-060 acceptance route. Use RUN_SX60_POC_SELF_RUN.ps1 for the current fail-closed post-060 candidate state."
}

function Assert-Equal {
    param(
        [Parameter(Mandatory = $true)]$Actual,
        [Parameter(Mandatory = $true)]$Expected,
        [Parameter(Mandatory = $true)][string]$Label
    )

    if ($Actual -ne $Expected) {
        throw "$Label mismatch. Expected=[$Expected] Actual=[$Actual]"
    }
}

function Assert-FileHash {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Expected,
        [Parameter(Mandatory = $true)][string]$Label
    )

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "$Label missing: $Path"
    }

    $Actual = (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToLowerInvariant()
    Assert-Equal -Actual $Actual -Expected $Expected.ToLowerInvariant() -Label "$Label SHA-256"
    Write-Host "$Label hash PASS - $Actual" -ForegroundColor Green
    return $Actual
}

function Resolve-UniqueFile {
    param(
        [Parameter(Mandatory = $true)][string]$Root,
        [Parameter(Mandatory = $true)][string]$Name
    )

    $Matches = @(Get-ChildItem -LiteralPath $Root -Recurse -File -Filter $Name)
    if ($Matches.Count -ne 1) {
        throw "Expected exactly one $Name under $Root, found $($Matches.Count)."
    }
    return $Matches[0].FullName
}

function Resolve-RepoRelativeFile {
    param(
        [Parameter(Mandatory = $true)][string]$RelativePath,
        [Parameter(Mandatory = $true)][string]$Label
    )

    if ([string]::IsNullOrWhiteSpace($RelativePath)) {
        throw "$Label is empty."
    }
    $RootFull = [System.IO.Path]::GetFullPath($RepoRoot).TrimEnd('\') + '\'
    $CandidateFull = [System.IO.Path]::GetFullPath((Join-Path $RepoRoot $RelativePath))
    if (-not $CandidateFull.StartsWith($RootFull, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "$Label escapes repository root: $RelativePath"
    }
    if (-not (Test-Path -LiteralPath $CandidateFull -PathType Leaf)) {
        throw "$Label file is missing: $CandidateFull"
    }
    return $CandidateFull
}

if (-not (Test-Path -LiteralPath $PointerPath -PathType Leaf)) {
    throw "Current candidate pointer is missing: $PointerPath"
}

$Pointer = Get-Content -LiteralPath $PointerPath -Raw -Encoding UTF8 | ConvertFrom-Json
Assert-Equal -Actual ([string]$Pointer.selection_policy) -Expected "EXPLICIT_FAIL_CLOSED_POINTER_NO_NEWEST_INFERENCE" -Label "selection policy"
$CandidateId = [string]$Pointer.current_candidate_id
if ([string]::IsNullOrWhiteSpace($CandidateId)) {
    throw "current_candidate_id is empty."
}

$EvidencePath = Resolve-RepoRelativeFile -RelativePath ([string]$Pointer.artifact_evidence_owner) -Label "artifact_evidence_owner"
$SelfRunRecordName = [string]$Pointer.self_run_record_name
if ([string]::IsNullOrWhiteSpace($SelfRunRecordName)) {
    throw "self_run_record_name is empty."
}
if ([System.IO.Path]::GetFileName($SelfRunRecordName) -ne $SelfRunRecordName) {
    throw "self_run_record_name must be a filename, not a path."
}
$SelfRunRecord = Resolve-UniqueFile -Root $RepoRoot -Name $SelfRunRecordName

$Evidence = Get-Content -LiteralPath $EvidencePath -Raw -Encoding UTF8 | ConvertFrom-Json
Assert-Equal -Actual ([string]$Evidence.candidate_id) -Expected $CandidateId -Label "candidate_id"
Assert-Equal -Actual ([bool]$Evidence.verification.artifact_api_digest_equals_downloaded_zip_sha256) -Expected $true -Label "artifact_api_digest_equals_downloaded_zip_sha256"
Assert-Equal -Actual ([string]$Evidence.package.identity_class) -Expected "IMMUTABLE_CONTENT_DIGESTS" -Label "package identity class"
Assert-Equal -Actual ([string]$Evidence.artifact.metadata_class) -Expected "EPHEMERAL_DELIVERY_METADATA" -Label "artifact metadata class"

if ([string]::IsNullOrWhiteSpace([string]$Evidence.package.windows_exe_sha256)) {
    throw "Canonical Windows EXE SHA-256 is empty."
}
if ([string]::IsNullOrWhiteSpace([string]$Evidence.package.windows_pck_sha256)) {
    throw "Canonical Windows PCK SHA-256 is empty."
}

if ($ContractCheck) {
    Write-Host "CANDIDATE_SELF_RUN_POWERSHELL_CONTRACT: PASS - $CandidateId" -ForegroundColor Green
    exit 0
}

if ($env:OS -ne "Windows_NT") {
    throw "Physical self-run launcher requires Windows. Current OS=[$($env:OS)]."
}

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    throw "GitHub CLI (gh) is required. Install gh, authenticate once, then rerun this script."
}

& gh auth status --hostname github.com *> $null
if ($LASTEXITCODE -ne 0) {
    throw "GitHub CLI is not authenticated for github.com. Run: gh auth login"
}

$ArtifactId = [string]$Evidence.artifact.id
$ArtifactEndpoint = "repos/$Repository/actions/artifacts/$ArtifactId"
$ArtifactJsonLines = @(& gh api $ArtifactEndpoint)
if ($LASTEXITCODE -ne 0) {
    throw "gh api failed while reading current candidate artifact metadata."
}
$Artifact = ($ArtifactJsonLines -join "`n") | ConvertFrom-Json

Assert-Equal -Actual ([string]$Artifact.id) -Expected ([string]$Evidence.artifact.id) -Label "artifact id"
Assert-Equal -Actual ([string]$Artifact.name) -Expected ([string]$Evidence.artifact.name) -Label "artifact name"
Assert-Equal -Actual ([string]$Artifact.workflow_run.id) -Expected ([string]$Evidence.artifact.workflow_run_id) -Label "workflow run id"

$LiveDigest = [string]$Artifact.digest
if ($LiveDigest.StartsWith("sha256:")) {
    $LiveDigest = $LiveDigest.Substring(7)
}
$LiveDigest = $LiveDigest.ToLowerInvariant()
Assert-Equal -Actual $LiveDigest -Expected ([string]$Evidence.artifact.api_digest_sha256).ToLowerInvariant() -Label "live artifact API digest"
Assert-Equal -Actual $LiveDigest -Expected ([string]$Evidence.package.zip_sha256).ToLowerInvariant() -Label "archive content identity"

if ([bool]$Artifact.expired) {
    throw "Current candidate artifact is expired/unavailable. Do not infer or fall back to another build. Update the explicit current candidate pointer only after preparing a new exact candidate."
}

if ([string]::IsNullOrWhiteSpace($WorkDir)) {
    if (-not [string]::IsNullOrWhiteSpace($env:LOCALAPPDATA)) {
        $ValidationRoot = Join-Path $env:LOCALAPPDATA "SwitchyExpress\Validation"
    } else {
        $ValidationRoot = Join-Path $env:TEMP "SwitchyExpress\Validation"
    }
    $WorkDir = Join-Path $ValidationRoot $CandidateId
}

$ArtifactDir = Join-Path $WorkDir "artifact"
if (Test-Path -LiteralPath $ArtifactDir) {
    Remove-Item -LiteralPath $ArtifactDir -Recurse -Force
}
New-Item -ItemType Directory -Path $ArtifactDir -Force | Out-Null

$RunId = [string]$Evidence.artifact.workflow_run_id
$ArtifactName = [string]$Evidence.artifact.name
Write-Host "Downloading exact $CandidateId artifact from workflow run $RunId..." -ForegroundColor Cyan
& gh run download $RunId -R $Repository -n $ArtifactName -D $ArtifactDir
if ($LASTEXITCODE -ne 0) {
    throw "gh run download failed. No fallback to another build is allowed."
}

$ExePath = Resolve-UniqueFile -Root $ArtifactDir -Name "SwitchyExpressVerticalSlice.exe"
$PckPath = Resolve-UniqueFile -Root $ArtifactDir -Name "SwitchyExpressVerticalSlice.pck"
$WindowsProofLog = Resolve-UniqueFile -Root $ArtifactDir -Name "windows-runtime-json-proof.log"
$AndroidProofLog = Resolve-UniqueFile -Root $ArtifactDir -Name "android-validation-runtime-json-proof.log"
$ShaSumsPath = Resolve-UniqueFile -Root $ArtifactDir -Name "SHA256SUMS.txt"

$ExeHash = Assert-FileHash -Path $ExePath -Expected ([string]$Evidence.package.windows_exe_sha256) -Label "Windows EXE"
$PckHash = Assert-FileHash -Path $PckPath -Expected ([string]$Evidence.package.windows_pck_sha256) -Label "Windows PCK"

$WindowsProof = Get-Content -LiteralPath $WindowsProofLog -Raw -Encoding UTF8
$AndroidProof = Get-Content -LiteralPath $AndroidProofLog -Raw -Encoding UTF8
if (-not $WindowsProof.Contains("RUNTIME_JSON_PACK_PROOF: PASS")) {
    throw "Windows packaged runtime JSON proof is missing PASS."
}
if (-not $AndroidProof.Contains("RUNTIME_JSON_PACK_PROOF: PASS")) {
    throw "Android packaged runtime JSON proof is missing PASS."
}

$ShaSums = Get-Content -LiteralPath $ShaSumsPath -Raw -Encoding UTF8
if (-not $ShaSums.ToLowerInvariant().Contains($ExeHash)) {
    throw "SHA256SUMS.txt does not contain the verified Windows EXE digest."
}
if (-not $ShaSums.ToLowerInvariant().Contains($PckHash)) {
    throw "SHA256SUMS.txt does not contain the verified Windows PCK digest."
}

Write-Host ""
Write-Host "$CandidateId PACKAGE VERIFICATION: PASS" -ForegroundColor Green
Write-Host "Artifact archive identity - $LiveDigest"
Write-Host "EXE - $ExeHash"
Write-Host "PCK - $PckHash"
Write-Host "Working directory - $ArtifactDir"
Write-Host "Physical/audio/human evidence is still fail-closed until actually observed on this exact candidate." -ForegroundColor Yellow

if (-not $NoOpenRecord) {
    Start-Process -FilePath "notepad.exe" -ArgumentList @($SelfRunRecord)
}

if ($NoLaunch) {
    Write-Host "NoLaunch requested; verified runtime was not started."
    exit 0
}

Write-Host "Launching verified SwitchyExpressVerticalSlice.exe for $CandidateId..." -ForegroundColor Cyan
Start-Process -FilePath $ExePath -WorkingDirectory (Split-Path -Parent $ExePath)
