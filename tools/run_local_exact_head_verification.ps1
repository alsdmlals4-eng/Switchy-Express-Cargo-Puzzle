[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$ExpectedHead,
    [Parameter(Mandatory = $true)][string]$GodotExecutable,
    [string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")),
    [string]$WindowsPyLauncher = "py",
    [string[]]$WindowsPythonVersions = @("3.11", "3.12", "3.13"),
    [string]$WslDistribution = "Ubuntu",
    [string]$WslPythonExecutable = "python3.12",
    [int]$MinimumGutTests = 6,
    [string]$ArtifactRoot = (Join-Path ([System.IO.Path]::GetTempPath()) "SwitchyExpress/local-exact-head")
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Invoke-CapturedNative {
    param(
        [Parameter(Mandatory = $true)][string]$Name,
        [Parameter(Mandatory = $true)][string]$FilePath,
        [Parameter(Mandatory = $true)][string[]]$ArgumentList,
        [Parameter(Mandatory = $true)][string]$LogPath
    )

    $Stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $OutputLines = & $FilePath @ArgumentList 2>&1
    $ExitCode = $LASTEXITCODE
    $Stopwatch.Stop()
    $OutputText = ($OutputLines | Out-String)
    $Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($LogPath, $OutputText, $Utf8NoBom)
    $OutputLines | ForEach-Object { Write-Host $_ }

    return [pscustomobject]@{
        Name = $Name
        ExitCode = $ExitCode
        DurationSeconds = [Math]::Round($Stopwatch.Elapsed.TotalSeconds, 3)
        OutputText = $OutputText
    }
}

function Get-MarkedValue {
    param(
        [Parameter(Mandatory = $true)][string]$Text,
        [Parameter(Mandatory = $true)][string]$Prefix
    )
    $Line = $Text -split "\r?\n" | Where-Object { $_.StartsWith($Prefix) } | Select-Object -First 1
    if (-not $Line) {
        throw "MARKED_OUTPUT_NOT_FOUND prefix=$Prefix"
    }
    return $Line.Substring($Prefix.Length).Trim()
}

if (-not (Test-Path -LiteralPath $RepoRoot -PathType Container)) {
    throw "Repository root does not exist: $RepoRoot"
}
if (-not (Test-Path -LiteralPath $GodotExecutable -PathType Leaf)) {
    throw "Godot executable does not exist: $GodotExecutable"
}
if ($ExpectedHead -notmatch '^[0-9a-fA-F]{40}$') {
    throw "ExpectedHead must be a full 40-character hexadecimal SHA."
}

$VerifierEntry = Join-Path $RepoRoot "tools/local_exact_head_verification_entry.py"
$MatrixValidator = Join-Path $RepoRoot "tools/local_python_matrix.py"
foreach ($RequiredTool in @($VerifierEntry, $MatrixValidator)) {
    if (-not (Test-Path -LiteralPath $RequiredTool -PathType Leaf)) {
        throw "Required verification tool does not exist: $RequiredTool"
    }
}

$ActualHeadOutput = (& git -C $RepoRoot rev-parse HEAD 2>&1 | Out-String)
$ActualHeadExitCode = $LASTEXITCODE
$ActualHead = $ActualHeadOutput.Trim()
if ($ActualHeadExitCode -ne 0 -or $ActualHead -ne $ExpectedHead) {
    throw "HEAD_MISMATCH expected=$ExpectedHead actual=$ActualHead"
}
$InitialStatus = (& git -C $RepoRoot status --porcelain=v1 | Out-String).Trim()
if ($LASTEXITCODE -ne 0 -or $InitialStatus) {
    throw "DIRTY_WORKTREE $InitialStatus"
}

$HeadLabel = $ExpectedHead.Substring(0, 12)
$ArtifactDir = Join-Path $ArtifactRoot $HeadLabel
$JunitOutput = Join-Path $ArtifactDir "gut-junit.xml"
$ManifestOutput = Join-Path $ArtifactDir "local-verification.json"
$MatrixManifestPath = Join-Path $ArtifactDir "python-matrix.json"
New-Item -ItemType Directory -Path $ArtifactDir -Force | Out-Null

$MatrixTargets = @()
foreach ($Version in $WindowsPythonVersions) {
    $TargetName = "windows-python-$Version"
    $VersionLog = Join-Path $ArtifactDir "$TargetName-version.log"
    $VersionResult = Invoke-CapturedNative `
        -Name "$TargetName-version" `
        -FilePath $WindowsPyLauncher `
        -ArgumentList @("-$Version", "-B", "-c", "import sys; print('SWITCHY_PYTHON_VERSION=' + sys.version.split()[0])") `
        -LogPath $VersionLog
    if ($VersionResult.ExitCode -ne 0) {
        throw "PYTHON_MATRIX_TARGET_FAILED $TargetName version exit=$($VersionResult.ExitCode)"
    }
    $PythonVersion = Get-MarkedValue -Text $VersionResult.OutputText -Prefix "SWITCHY_PYTHON_VERSION="

    $TestLog = Join-Path $ArtifactDir "$TargetName.log"
    $TestResult = Invoke-CapturedNative `
        -Name $TargetName `
        -FilePath $WindowsPyLauncher `
        -ArgumentList @("-$Version", "-B", "-m", "unittest", "discover", "-s", "tests/python", "-p", "test_*.py", "-v") `
        -LogPath $TestLog
    if ($TestResult.ExitCode -ne 0) {
        throw "PYTHON_MATRIX_TARGET_FAILED $TargetName exit=$($TestResult.ExitCode)"
    }
    $MatrixTargets += [ordered]@{
        target = $TargetName
        python_version = $PythonVersion
        exit_code = $TestResult.ExitCode
        duration_seconds = $TestResult.DurationSeconds
        log_file = [System.IO.Path]::GetFileName($TestLog)
    }
}

$WslPathResult = Invoke-CapturedNative `
    -Name "wslpath" `
    -FilePath "wsl.exe" `
    -ArgumentList @("-d", $WslDistribution, "--", "wslpath", "-a", $RepoRoot) `
    -LogPath (Join-Path $ArtifactDir "wslpath.log")
if ($WslPathResult.ExitCode -ne 0) {
    throw "WSL_PATH_RESOLUTION_FAILED exit=$($WslPathResult.ExitCode)"
}
$WslRepoRootLine = $WslPathResult.OutputText -split "\r?\n" | Where-Object { $_ -match '^/' } | Select-Object -First 1
if (-not $WslRepoRootLine) { throw "WSL_PATH_OUTPUT_INVALID" }
$WslRepoRoot = $WslRepoRootLine.Trim()

$WslHeadResult = Invoke-CapturedNative `
    -Name "wsl-git-head" `
    -FilePath "wsl.exe" `
    -ArgumentList @("-d", $WslDistribution, "--cd", $WslRepoRoot, "--", "git", "-c", "safe.directory=$WslRepoRoot", "rev-parse", "HEAD") `
    -LogPath (Join-Path $ArtifactDir "wsl-git-head.log")
$WslHeadLine = $WslHeadResult.OutputText -split "\r?\n" | Where-Object { $_ -match '^[0-9a-fA-F]{40}$' } | Select-Object -First 1
$WslHead = if ($WslHeadLine) { $WslHeadLine.Trim() } else { "" }
if ($WslHeadResult.ExitCode -ne 0 -or $WslHead -ne $ExpectedHead) {
    throw "WSL_HEAD_MISMATCH expected=$ExpectedHead actual=$WslHead"
}

$WslStatusResult = Invoke-CapturedNative `
    -Name "wsl-git-status" `
    -FilePath "wsl.exe" `
    -ArgumentList @("-d", $WslDistribution, "--cd", $WslRepoRoot, "--", "git", "-c", "safe.directory=$WslRepoRoot", "status", "--porcelain=v1") `
    -LogPath (Join-Path $ArtifactDir "wsl-git-status.log")
if ($WslStatusResult.ExitCode -ne 0 -or $WslStatusResult.OutputText.Trim()) {
    throw "WSL_DIRTY_WORKTREE $($WslStatusResult.OutputText.Trim())"
}

$WslTargetName = "wsl-ubuntu-python-3.12"
$WslVersionResult = Invoke-CapturedNative `
    -Name "$WslTargetName-version" `
    -FilePath "wsl.exe" `
    -ArgumentList @("-d", $WslDistribution, "--", $WslPythonExecutable, "-B", "-c", "import sys; print('SWITCHY_PYTHON_VERSION=' + sys.version.split()[0])") `
    -LogPath (Join-Path $ArtifactDir "$WslTargetName-version.log")
if ($WslVersionResult.ExitCode -ne 0) {
    throw "PYTHON_MATRIX_TARGET_FAILED $WslTargetName version exit=$($WslVersionResult.ExitCode)"
}
$WslPythonVersion = Get-MarkedValue -Text $WslVersionResult.OutputText -Prefix "SWITCHY_PYTHON_VERSION="

$WslTestLog = Join-Path $ArtifactDir "$WslTargetName.log"
$WslTestResult = Invoke-CapturedNative `
    -Name $WslTargetName `
    -FilePath "wsl.exe" `
    -ArgumentList @("-d", $WslDistribution, "--cd", $WslRepoRoot, "--", $WslPythonExecutable, "-B", "-m", "unittest", "discover", "-s", "tests/python", "-p", "test_*.py", "-v") `
    -LogPath $WslTestLog
if ($WslTestResult.ExitCode -ne 0) {
    throw "PYTHON_MATRIX_TARGET_FAILED $WslTargetName exit=$($WslTestResult.ExitCode)"
}
$MatrixTargets += [ordered]@{
    target = $WslTargetName
    python_version = $WslPythonVersion
    exit_code = $WslTestResult.ExitCode
    duration_seconds = $WslTestResult.DurationSeconds
    log_file = [System.IO.Path]::GetFileName($WslTestLog)
}

$MatrixManifest = [ordered]@{
    schema_version = 1
    status = "PASS"
    exact_head = $ExpectedHead
    generated_at = [DateTimeOffset]::Now.ToString("o")
    targets = $MatrixTargets
}
$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$MatrixJson = $MatrixManifest | ConvertTo-Json -Depth 6
[System.IO.File]::WriteAllText($MatrixManifestPath, $MatrixJson + [Environment]::NewLine, $Utf8NoBom)

$PostMatrixStatus = (& git -C $RepoRoot status --porcelain=v1 | Out-String).Trim()
if ($LASTEXITCODE -ne 0 -or $PostMatrixStatus) {
    throw "POST_MATRIX_DIRTY_WORKTREE $PostMatrixStatus"
}

$Python312ExecutableOutput = (& $WindowsPyLauncher -3.12 -B -c "import sys; print(sys.executable)" 2>&1 | Out-String)
$Python312ExitCode = $LASTEXITCODE
$Python312Executable = $Python312ExecutableOutput.Trim()
if ($Python312ExitCode -ne 0 -or -not $Python312Executable) {
    throw "WINDOWS_PYTHON_312_EXECUTABLE_NOT_FOUND"
}

$env:PYTHONDONTWRITEBYTECODE = "1"
& $Python312Executable -B $MatrixValidator --manifest $MatrixManifestPath --expected-head $ExpectedHead
if ($LASTEXITCODE -ne 0) {
    throw "PYTHON_MATRIX_VALIDATION_FAILED $MatrixManifestPath"
}

$Arguments = @(
    "-B",
    $VerifierEntry,
    "verify",
    "--repo-root", $RepoRoot,
    "--expected-head", $ExpectedHead,
    "--godot-executable", $GodotExecutable,
    "--python-executable", $Python312Executable,
    "--python-matrix-manifest", $MatrixManifestPath,
    "--artifact-dir", $ArtifactDir,
    "--output", $ManifestOutput,
    "--junit-output", $JunitOutput,
    "--minimum-gut-tests", $MinimumGutTests.ToString()
)

Push-Location $RepoRoot
try {
    & $Python312Executable @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "Local exact-HEAD verification failed with exit code $LASTEXITCODE. Evidence: $ManifestOutput"
    }
}
finally {
    Pop-Location
}

Write-Host "LOCAL_EXACT_HEAD_VERIFICATION_PASS $ExpectedHead"
Write-Host "PYTHON_MATRIX $MatrixManifestPath"
Write-Host "EVIDENCE_MANIFEST $ManifestOutput"
Write-Host "GUT_JUNIT $JunitOutput"
