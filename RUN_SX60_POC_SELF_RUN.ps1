#Requires -Version 5.1
[CmdletBinding()]
param([switch]$ContractCheck, [switch]$NoLaunch, [switch]$NoOpenRecord, [string]$WorkDir = "")
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$Repository = "alsdmlals4-eng/Switchy-Express-Cargo-Puzzle"
$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$PointerPath = Join-Path $RepoRoot "evidence\acceptance\post_sx_dec_060_candidate.json"
function Assert-Equal($Actual, $Expected, [string]$Label) { if ($Actual -ne $Expected) { throw "$Label mismatch. Expected=[$Expected] Actual=[$Actual]" } }
function Resolve-RepoFile([string]$RelativePath, [string]$Label) {
    $Root = [System.IO.Path]::GetFullPath($RepoRoot).TrimEnd('\') + '\'
    $Full = [System.IO.Path]::GetFullPath((Join-Path $RepoRoot $RelativePath))
    if (-not $Full.StartsWith($Root, [System.StringComparison]::OrdinalIgnoreCase)) { throw "$Label escapes repository root." }
    if (-not (Test-Path -LiteralPath $Full -PathType Leaf)) { throw "$Label missing: $Full" }
    return $Full
}
function Resolve-UniqueFile([string]$Root, [string]$Name) {
    $Matches = @(Get-ChildItem -LiteralPath $Root -Recurse -File -Filter $Name)
    if ($Matches.Count -ne 1) { throw "Expected exactly one $Name under $Root, found $($Matches.Count)." }
    return $Matches[0].FullName
}
function Assert-FileHash([string]$Path, [string]$Expected, [string]$Label) {
    $Actual = (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToLowerInvariant()
    Assert-Equal $Actual $Expected.ToLowerInvariant() "$Label SHA-256"
}
$Pointer = Get-Content -LiteralPath $PointerPath -Raw -Encoding UTF8 | ConvertFrom-Json
Assert-Equal ([string]$Pointer.decision_id) "SX-DEC-060" "decision id"
Assert-Equal ([string]$Pointer.selection_policy) "EXPLICIT_FAIL_CLOSED_POINTER_NO_NEWEST_INFERENCE" "selection policy"
if ([string]$Pointer.candidate_status -eq "NOT_CREATED") {
    if ($ContractCheck) {
        Write-Host "POST_SX_DEC_060_CANDIDATE_CONTRACT: NO_CURRENT_CANDIDATE_MINT_REQUIRED" -ForegroundColor Yellow
        exit 0
    }
    throw "POST_SX_DEC_060_CANDIDATE_CONTRACT: no current candidate. Mint a new exact package at minimum_product_source_main before physical, device, or human testing."
}
Assert-Equal ([string]$Pointer.candidate_status) "PREPARED_PACKAGE_VERIFIED" "candidate status"
$CandidateId = [string]$Pointer.current_candidate_id
if ([string]::IsNullOrWhiteSpace($CandidateId)) { throw "current_candidate_id is empty." }
$EvidencePath = Resolve-RepoFile ([string]$Pointer.artifact_evidence_owner) "artifact_evidence_owner"
$AuditPath = Resolve-RepoFile ([string]$Pointer.deep_pck_evidence_owner) "deep_pck_evidence_owner"
$Evidence = Get-Content -LiteralPath $EvidencePath -Raw -Encoding UTF8 | ConvertFrom-Json
$Audit = Get-Content -LiteralPath $AuditPath -Raw -Encoding UTF8 | ConvertFrom-Json
Assert-Equal ([string]$Evidence.candidate_id) $CandidateId "candidate id"
Assert-Equal ([string]$Audit.candidate_id) $CandidateId "audit candidate id"
Assert-Equal ([bool]$Evidence.verification.artifact_api_digest_equals_downloaded_zip_sha256) $true "artifact digest evidence"
Assert-Equal ([bool]$Audit.pck_integrity.integrity_pass) $true "PCK integrity evidence"
$MinimumSourceMain = [string]$Pointer.minimum_product_source_main
$CandidateSourceMain = [string]$Evidence.source_build.main_sha
Assert-Equal ([string]$Evidence.artifact.workflow_head_sha) $CandidateSourceMain "artifact evidence workflow head SHA"
Assert-Equal ([string]$Evidence.artifact.workflow_conclusion) "success" "artifact evidence workflow conclusion"
if ([string]::IsNullOrWhiteSpace($MinimumSourceMain)) { throw "minimum_product_source_main is empty." }
if ([string]::IsNullOrWhiteSpace($CandidateSourceMain)) { throw "candidate source_build.main_sha is empty." }
if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw "Git is required to verify candidate source ancestry." }
& git -C $RepoRoot cat-file -e "$MinimumSourceMain^{commit}"
if ($LASTEXITCODE -ne 0) { throw "CANDIDATE_SOURCE_MAIN_UNKNOWN: minimum_product_source_main=$MinimumSourceMain" }
& git -C $RepoRoot cat-file -e "$CandidateSourceMain^{commit}"
if ($LASTEXITCODE -ne 0) { throw "CANDIDATE_SOURCE_MAIN_UNKNOWN: candidate_source_main=$CandidateSourceMain" }
& git -C $RepoRoot merge-base --is-ancestor $MinimumSourceMain $CandidateSourceMain
if ($LASTEXITCODE -ne 0) { throw "CANDIDATE_SOURCE_MAIN_NOT_DESCENDANT: minimum=$MinimumSourceMain candidate=$CandidateSourceMain" }
if ($ContractCheck) { Write-Host "POST_SX_DEC_060_CANDIDATE_CONTRACT: PASS - $CandidateId" -ForegroundColor Green; exit 0 }
if ($env:OS -ne "Windows_NT") { throw "Physical self-run launcher requires Windows." }
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) { throw "GitHub CLI (gh) is required." }
& gh auth status --hostname github.com *> $null
if ($LASTEXITCODE -ne 0) { throw "GitHub CLI is not authenticated for github.com." }
$Artifact = (& gh api "repos/$Repository/actions/artifacts/$($Evidence.artifact.id)" | ConvertFrom-Json)
$WorkflowRun = (& gh api "repos/$Repository/actions/runs/$($Evidence.artifact.workflow_run_id)" | ConvertFrom-Json)
$Digest = ([string]$Artifact.digest).Replace("sha256:", "").ToLowerInvariant()
Assert-Equal ([string]$Artifact.id) ([string]$Evidence.artifact.id) "artifact id"
Assert-Equal $Digest ([string]$Evidence.package.zip_sha256) "live artifact archive digest"
Assert-Equal ([string]$WorkflowRun.head_sha) ([string]$Evidence.artifact.workflow_head_sha) "live workflow head SHA"
Assert-Equal ([string]$WorkflowRun.conclusion) ([string]$Evidence.artifact.workflow_conclusion) "live workflow conclusion"
if ([bool]$Artifact.expired) { throw "Exact candidate artifact is expired; no fallback is allowed." }
if ([string]::IsNullOrWhiteSpace($WorkDir)) { $WorkDir = Join-Path $env:TEMP $CandidateId }
$AllowedTempRoots = @()
foreach ($CandidateTempRoot in @($env:TEMP, $env:RUNNER_TEMP)) {
    if (-not [string]::IsNullOrWhiteSpace($CandidateTempRoot)) {
        $ResolvedTempRoot = [System.IO.Path]::GetFullPath($CandidateTempRoot).TrimEnd('\')
        if ($AllowedTempRoots -notcontains $ResolvedTempRoot) { $AllowedTempRoots += $ResolvedTempRoot }
    }
}
if ($AllowedTempRoots.Count -eq 0) { throw "No safe TEMP or RUNNER_TEMP root is configured." }
$WorkDir = [System.IO.Path]::GetFullPath($WorkDir).TrimEnd('\')
$WorkDirParent = [System.IO.Path]::GetDirectoryName($WorkDir)
$IsDirectAllowedTempChild = $false
foreach ($AllowedTempRoot in $AllowedTempRoots) {
    if ($WorkDirParent.Equals($AllowedTempRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
        $IsDirectAllowedTempChild = $true
        break
    }
}
if (-not $IsDirectAllowedTempChild) {
    throw "WorkDir must be a direct child of TEMP or RUNNER_TEMP; refusing unsafe target: $WorkDir"
}
$ArtifactDir = Join-Path $WorkDir "artifact"
if (Test-Path -LiteralPath $ArtifactDir) { Remove-Item -LiteralPath $ArtifactDir -Recurse -Force }
New-Item -ItemType Directory -Path $ArtifactDir -Force | Out-Null
& gh run download ([string]$Evidence.artifact.workflow_run_id) -R $Repository -n ([string]$Evidence.artifact.name) -D $ArtifactDir
if ($LASTEXITCODE -ne 0) { throw "Exact artifact download failed; no fallback is allowed." }
$Exe = Resolve-UniqueFile $ArtifactDir "SwitchyExpressVerticalSlice.exe"
$Pck = Resolve-UniqueFile $ArtifactDir "SwitchyExpressVerticalSlice.pck"
Assert-FileHash $Exe ([string]$Evidence.package.windows_exe_sha256) "Windows EXE"
Assert-FileHash $Pck ([string]$Evidence.package.windows_pck_sha256) "Windows PCK"
$WindowsLog = Get-Content -LiteralPath (Resolve-UniqueFile $ArtifactDir "windows-runtime-json-proof.log") -Raw -Encoding UTF8
$AndroidLog = Get-Content -LiteralPath (Resolve-UniqueFile $ArtifactDir "android-validation-runtime-json-proof.log") -Raw -Encoding UTF8
if (-not $WindowsLog.Contains("RUNTIME_JSON_PACK_PROOF: PASS")) { throw "Windows runtime JSON proof missing PASS." }
if (-not $AndroidLog.Contains("RUNTIME_JSON_PACK_PROOF: PASS")) { throw "Android runtime JSON proof missing PASS." }
if ($NoLaunch) { Write-Host "$CandidateId PACKAGE VERIFICATION: PASS (NoLaunch)" -ForegroundColor Green; exit 0 }
Start-Process -FilePath $Exe -WorkingDirectory (Split-Path -Parent $Exe)
