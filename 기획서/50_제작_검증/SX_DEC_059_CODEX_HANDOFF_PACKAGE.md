# SX-DEC-059 · Codex Handoff Package

```yaml
owner_decision: SX-DEC-059
status: PREPARED_NOT_EXECUTED
user_planning_complete: GRANTED_2026_08_20
implementation_plan: docs/superpowers/plans/2026-08-20-sx-dec-059-first-session-vertical-slice-implementation.md
codex_handoff_policy: ON_DEMAND
codex_handoff_trigger: USER_REQUESTED_CODEX_HANDOFF
trigger_state: NOT_PRESENT
build_state: IMPLEMENTED_AUTOMATED
pr_154: "AUDITED · SUPERSEDED_UNMERGED_BY_059"
```

이 문서는 **사용자가 Codex 인계를 요청했을 때 사용할 실행 패키지**다. 현재 `기획완료`만으로 Codex를 실행하지 않는다.

## 1. Required read set for Codex

Codex는 편집 전 다음을 current checkout에서 다시 읽는다.

```text
AGENTS.md
PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.7_SWITCHY_ADAPTER.md
기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md
기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md
기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md
기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md
기획서/20_시스템_콘텐츠/FIRST_SESSION_STAGE_CONTENT_SPEC_V1.md
기획서/30_UI_UX/FIRST_SESSION_SCREEN_CONTENT_DATA_CONTRACT.md
기획서/30_UI_UX/FIRST_SESSION_LOCALIZATION_COPY_MATRIX_V1.md
기획서/40_표현/SX_DEC_059_VISUAL_REQUIREMENT_BRIEFS.md
기획서/50_제작_검증/SX_DEC_059_FIRST_SESSION_PLAYTEST_DELTA.md
docs/superpowers/plans/2026-08-20-sx-dec-059-first-session-vertical-slice-implementation.md
```

Then inspect actual relevant code/tests before editing.

## 2. Protected state

```text
PR #154: audited; do not absorb; superseded unmerged by the product-owned implementation
PR #155/#156: CLOSED_UNMERGED historical accidents
SX-DEC-056/057/058: no implementation absorption
VS_DEMO_01: keep bytes/semantic unchanged by default
73 semantic product PNGs: immutable unless separately authorized
GMB-002 domain authority: preserved
```

## 3. Location-first PowerShell block policy

The implementation plan contains an example repo path in its preflight section. **That path is not execution authority. This handoff package overrides the repo-location step.**

At actual handoff, locate the checkout by remote identity instead of assuming a folder.

```powershell
$ErrorActionPreference = 'Stop'
$RepoName = 'Switchy-Express-Cargo-Puzzle'
$RemoteNeedle = 'alsdmlals4-eng/Switchy-Express-Cargo-Puzzle'
$Roots = @(
  (Join-Path $env:USERPROFILE 'Documents'),
  (Join-Path $env:USERPROFILE 'Desktop'),
  (Join-Path $env:USERPROFILE 'source'),
  (Join-Path $env:USERPROFILE 'repos')
) | Where-Object { Test-Path $_ } | Select-Object -Unique

$Candidates = foreach ($root in $Roots) {
  Get-ChildItem -Path $root -Directory -Filter $RepoName -Recurse -Depth 5 -ErrorAction SilentlyContinue
}

$Matches = @()
foreach ($candidate in ($Candidates | Sort-Object FullName -Unique)) {
  $remote = (& git -C $candidate.FullName remote get-url origin 2>$null)
  if ($LASTEXITCODE -eq 0 -and $remote -match [regex]::Escape($RemoteNeedle)) {
    $Matches += $candidate.FullName
  }
}

if ($Matches.Count -ne 1) {
  Write-Host "[BLOCKED][REPO_LOCATION] expected exactly one checkout, found $($Matches.Count)"
  $Matches | ForEach-Object { Write-Host "  $_" }
  exit 30
}

$Repo = $Matches[0]
Write-Host "[PASS][REPO] $Repo"
```

If automatic lookup finds zero or multiple matching checkouts, stop. Do not clone a replacement or guess a path because that can bypass unpushed user state.

## 4. Isolation policy

Actual implementation should prefer an isolated worktree after the user requests handoff.

Before creating one:

```powershell
Set-Location $Repo
git fetch origin --prune
if (git status --porcelain) {
  Write-Host '[BLOCKED][SOURCE_DIRTY] Preserve user changes; do not reset.'
  exit 31
}
$SourceBranch = git branch --show-current
$GitDir = (git rev-parse --git-dir)
$GitCommon = (git rev-parse --git-common-dir)
Write-Host "source_branch=$SourceBranch"
Write-Host "git_dir=$GitDir"
Write-Host "git_common=$GitCommon"
```

If the execution environment already provides a native isolated worktree, use it. Otherwise, after explicit handoff, a separate external worktree under `$env:LOCALAPPDATA\SwitchyExpressWorktrees` is preferred so PR #154/current user checkout is not switched in place.

Do not delete or force-reset an existing worktree/branch with the same name. If found, inspect and resume only if it belongs to the same 059 workstream and is clean.

## 5. Tool preflight

Before Codex starts editing:

```text
Godot exact version → 4.7.1-stable
GUT vendor → 9.7.1 contract
project addon plugin.cfg → 3.1.4
local/repo godot-ai tree parity → VERIFY
project 3.1.4 provenance → VERIFY / do not guess official release identity
CODEX_HOME → report current value; do not silently replace credentials/config
HiGodot project profile/ports → inspect only if current project path actually consumes it
Hera → live QA only; tracked source delta after acceptance must be zero
custom baseline suite → GREEN before production edits
```

If baseline suite is red, do not start 059 production edits until the failure is classified as pre-existing or fixed in its own bounded task.

## 6. Exact Codex prompt

Use the following prompt after the handoff trigger and clean worktree preflight.

```text
You are implementing SX-DEC-059 for alsdmlals4-eng/Switchy-Express-Cargo-Puzzle.

Read AGENTS.md and the v4.7 Switchy adapter first, then CURRENT_CONFIRMED_DECISIONS.md, ACTIVE_CONTEXT.md, DEVELOPMENT_GATES.md, all SX-DEC-059 design/content/UI/localization/visual/playtest docs, and docs/superpowers/plans/2026-08-20-sx-dec-059-first-session-vertical-slice-implementation.md.

Direction anchor:
Build the approved release-near first session T1→T6→VS_DEMO_01 by adding a presentation/onboarding sidecar around the existing finite-delivery core. Preserve GMB-002 domain authority and existing standalone vertical_slice_demo behavior. The goal is not more features; it is a coherent first-session learning/transfer experience using current semantic assets and runtime truth.

Mandatory protection:
- PR #154 is another active workstream: read-only. Do not modify/rebase/update/close/merge or copy its unmerged game/reuse delta.
- Do not implement SX-DEC-056/057/058.
- Do not change LIFO/load eligibility/unload/route/time/failure/save/score/ruleset semantics.
- Do not revive endless/fuel/BOOST/capacity-8/cargo-slowdown/pickup-respawn/switch-auto-reset.
- Keep data/maps/vs_demo_01.json unchanged unless a failing approved contract proves a blocker; if so stop and report instead of silently changing it.
- Keep current 73 product PNGs/provenance unchanged.
- No new image generation.

Implementation:
Follow the implementation plan task-by-task. Every production behavior must use TDD: write the test, run it and verify the expected RED, implement only enough for GREEN, run focused and full regression, then commit. Do not write production code before its failing test.

Architecture:
- FirstSessionDefinition + FirstSessionStagePolicy + FirstSessionDirector + FirstSessionCopy are sidecar owners.
- Tutorial metadata stays outside FiniteMapDefinition schema v2.
- ProductFiniteSlice remains the command convergence boundary; enforce StagePolicy there so HUD/keyboard/board/route-control inputs cannot bypass hidden lessons.
- Add opt-in first_session_enabled=false to the existing demo shell; game/main/main.tscn enables it, standalone vertical_slice_demo.tscn remains old behavior.
- T1/T2 share one ProductFiniteSlice/map/layout; T1 completes on preflight PASS, T2 runs that same layout.
- New tutorial map target is 5. Author exact map bytes and private witnesses RED-first.
- Failure Result uses only FiniteRunSummary truth: ROUTE_END/TIME_EXPIRED + remaining_map_cargo + stack_size. No guessed station mismatch trace.
- Localization: ko/en/ja/zh-Hans, no raw key leak, no text in PNG.
- Reuse existing semantic HUD/VFX/audio/Reduced Motion paths.

Validation:
Run the custom headless suite and formal GUT exactly as current repository workflows require. Run package/export proof for new data. Do not claim Windows physical, Android device, human comprehension, or player-experience PASS unless those exact runs actually occur.

Completion:
Before opening an implementation PR, compare changed paths to the approved scope, confirm PR #154 untouched, confirm VS_DEMO_01 and 73 PNGs unchanged, run full regression, and write actual evidence with exact commands/results. If a blocker requires changing product core or scope, stop that local task and report the finding instead of expanding authority.
```

## 7. Codex command

v4.7 canonical command:

```powershell
codex.cmd -a never -s workspace-write $Prompt
```

Run it only after `USER_REQUESTED_CODEX_HANDOFF` and clean location/worktree/tooling preflight.

## 8. Current handoff verdict

```text
PLAN COMPLETE: YES
IMPLEMENTATION PLAN WRITTEN: YES
CANON SYNC: IMPLEMENTATION_CANON_AUTHORED
NOTION SYNC: POST_MERGE_READBACK_REQUIRED
CODEX HANDOFF REQUESTED: YES
CODEX EXECUTED: YES
GODOT BUILD: IMPLEMENTED_AUTOMATED
FIVE-PASS ADVERSARIAL REVIEW: CLOSED · SX-AUD-066
```

이 문서는 실행 재개 지시가 아니라 완료된 handoff의 감사/rollback 기록이다. 현재 상태는 `ACTIVE_CONTEXT.md`와 `SX_AUD_066_SX_DEC_059_IMPLEMENTATION_AND_FIVE_PASS_REVIEW.md`를 따른다.
