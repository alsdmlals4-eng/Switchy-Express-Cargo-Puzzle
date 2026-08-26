#Requires -Version 5.1

[CmdletBinding()]
param(
    [switch]$ContractCheck,
    [switch]$NoLaunch,
    [switch]$NoOpenRecord
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Current post-SX-DEC-060 use:
#   powershell -ExecutionPolicy Bypass -File .\RUN_SX60_POC_SELF_RUN.ps1
# CI / governance contract check:
#   powershell -ExecutionPolicy Bypass -File .\RUN_SX60_POC_SELF_RUN.ps1 -ContractCheck -NoLaunch -NoOpenRecord

$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$PointerPath = Join-Path $RepoRoot "evidence\acceptance\post_sx_dec_060_candidate.json"

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

if (-not (Test-Path -LiteralPath $PointerPath -PathType Leaf)) {
    throw "Post-SX-DEC-060 candidate pointer is missing: $PointerPath"
}

$Pointer = Get-Content -LiteralPath $PointerPath -Raw -Encoding UTF8 | ConvertFrom-Json
Assert-Equal -Actual ([string]$Pointer.decision_id) -Expected "SX-DEC-060" -Label "decision id"
Assert-Equal -Actual ([string]$Pointer.selection_policy) -Expected "EXPLICIT_FAIL_CLOSED_POINTER_NO_NEWEST_INFERENCE" -Label "selection policy"
Assert-Equal -Actual ([string]$Pointer.candidate_status) -Expected "NOT_CREATED" -Label "candidate status"

if ($null -ne $Pointer.current_candidate_id -and -not [string]::IsNullOrWhiteSpace([string]$Pointer.current_candidate_id)) {
    throw "POST_SX_DEC_060_CANDIDATE_NOT_CREATED violation: current_candidate_id must remain null until a post-060 package is minted."
}
if ([string]::IsNullOrWhiteSpace([string]$Pointer.historical_predecessor.pointer)) {
    throw "historical_predecessor.pointer is required for evidence provenance."
}
if ([string]$Pointer.historical_predecessor.role -ne "HISTORICAL_EXACT_BYTES_ONLY") {
    throw "historical_predecessor.role must preserve the exact-byte evidence boundary."
}

if ($ContractCheck) {
    Write-Host "POST_SX_DEC_060_CANDIDATE_NOT_CREATED: PASS - explicit fail-closed state" -ForegroundColor Green
    exit 0
}

throw "POST_SX_DEC_060_CANDIDATE_NOT_CREATED: no post-060 package candidate exists. Do not download, verify, or launch pre-060 Candidate 003 as acceptance evidence. Complete the Codex implementation and mint a new exact candidate first."
