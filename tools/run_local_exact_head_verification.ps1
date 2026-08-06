[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$ExpectedHead,
    [Parameter(Mandatory = $true)][string]$GodotExecutable,
    [string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")),
    [string]$PythonExecutable = "python",
    [int]$MinimumGutTests = 6,
    [string]$ArtifactRoot = (Join-Path ([System.IO.Path]::GetTempPath()) "SwitchyExpress/local-exact-head")
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $RepoRoot -PathType Container)) {
    throw "Repository root does not exist: $RepoRoot"
}
if (-not (Test-Path -LiteralPath $GodotExecutable -PathType Leaf)) {
    throw "Godot executable does not exist: $GodotExecutable"
}

$Verifier = Join-Path $RepoRoot "tools/local_exact_head_verification.py"
if (-not (Test-Path -LiteralPath $Verifier -PathType Leaf)) {
    throw "Verifier script does not exist: $Verifier"
}

$HeadLabelLength = [Math]::Min(12, $ExpectedHead.Length)
$HeadLabel = $ExpectedHead.Substring(0, $HeadLabelLength)
$ArtifactDir = Join-Path $ArtifactRoot $HeadLabel
$JunitOutput = Join-Path $ArtifactDir "gut-junit.xml"
$ManifestOutput = Join-Path $ArtifactDir "local-verification.json"
New-Item -ItemType Directory -Path $ArtifactDir -Force | Out-Null

$Arguments = @(
    $Verifier,
    "verify",
    "--repo-root", $RepoRoot,
    "--expected-head", $ExpectedHead,
    "--godot-executable", $GodotExecutable,
    "--python-executable", $PythonExecutable,
    "--artifact-dir", $ArtifactDir,
    "--output", $ManifestOutput,
    "--junit-output", $JunitOutput,
    "--minimum-gut-tests", $MinimumGutTests.ToString()
)

Push-Location $RepoRoot
try {
    & $PythonExecutable @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "Local exact-HEAD verification failed with exit code $LASTEXITCODE. Evidence: $ManifestOutput"
    }
}
finally {
    Pop-Location
}

Write-Host "LOCAL_EXACT_HEAD_VERIFICATION_PASS $ExpectedHead"
Write-Host "EVIDENCE_MANIFEST $ManifestOutput"
Write-Host "GUT_JUNIT $JunitOutput"
