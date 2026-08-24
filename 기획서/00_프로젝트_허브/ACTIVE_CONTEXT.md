# Active Context

Last updated: `2026-08-24 KST`

이 문서는 **현재 상태·다음 실행 지점·미검증 경계**를 연결하는 resume locator다. fresh GitHub/Notion/actual runtime이 저장 snapshot보다 우선한다.

## Continuation State

```yaml
repository: alsdmlals4-eng/Switchy-Express-Cargo-Puzzle
default_branch: main
project_main_before_implementation: 4b37c154505ed1975735fc305a68b410877a40e0
sx_dec_059_merge_pr: 158
sx_dec_059_merge_main: 162e8a0a5e8ddc8472e74a6152e87dc12008e34c
implementation_branch: feat/sx-dec-059-first-session · HISTORICAL_MERGED
base_compatibility_pin: v9.4.3 · HISTORICAL_COMPATIBILITY
base_latest_observed: 2828a74f60c1ed09546171040f4178c8848ea686
base_latest_policy: ALWAYS_REFETCH_CURRENT_COMPLETED_MAIN
engine: Godot 4.7.1-stable
language: GDScript
work_instruction: v4.8 · 2026-08-24-r2 · SWITCHY_THIN_ADAPTER
work_instruction_source_sha256: 6f0541048e084746f6777223521361d0339dbfb2e223c70947f694f1c050f508
v4_8_authority_merge_pr: 164
v4_8_authority_merge_main: 98ed1c65d678bfc262c32084bbf0e59368093c2c
v4_7_adapter: HISTORICAL_ROLLBACK_EVIDENCE
product_baseline: GMB-002
current_decisions: SX-DEC-027~059
sx_dec_059_user_planning_complete: GRANTED · 2026-08-20 KST
sx_dec_059_phase_c: PASS · SX-AUD-064 · CLEAN_REVIEW_EXIT
sx_dec_059_repository_canon: MERGED_MAIN_VERIFIED
sx_dec_059_notion_sync: PASS · POST_PR_158_READBACK_COMPLETE
sx_dec_059_package_spec_dor: PASS
sx_dec_059_execution_preflight: PASS
sx_dec_059_codex_handoff: USER_REQUESTED_AND_EXECUTED
SX_DEC_059_IMPLEMENTATION: MERGED_MAIN_VERIFIED
sx_dec_059_build: PLAYABLE_VISUAL_UX_POC_AUTOMATED_AND_PACKAGE_GREEN
sx_dec_059_adversarial_review: FIVE_PASS_AND_INDEPENDENT_REVIEW_CLOSED · SX-AUD-066
playable_poc_pr: 166
playable_poc_pr_head: 159a3a741ef79b6207be290cc284bd63a5979e72
playable_poc_merge_main: 1bf798cedf28dffba9185edb62fb1c50c108fe90
playable_poc_tree: b3fa0ad93721d7f99614fb6f0bf594c7ce068127
playable_poc_audit: SX-AUD-069 · CLEAN_REVIEW_EXIT
playable_poc_visual_surface: BOARD_HUD_TITLE_LESSON_RESULT_APPROVED_ASSETS
sx_dec_055: MERGED_MAIN_VERIFIED · PR_151
sx_dec_056a: PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED
sx_dec_056b: BLOCKED_BY_AUTHORITATIVE_SCORE_COMBO_RUNTIME
sx_dec_057: PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED
sx_dec_058: PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED
semantic_assets: 73_TOTAL · PRODUCTION_COMPLETE · PLAYABLE_POC_CONSUMED
pr_154: CLOSED_UNMERGED · SUPERSEDED_BY_059
historical_candidate: SX59-ACCEPT-001 · SUPERSEDED_FOR_CURRENT_POC
current_candidate: SX59-POC-ACCEPT-002 · PREPARED · PENDING_DEVELOPER_SELF_RUN
acceptance_build: NOT_YET_DESIGNATED
developer_self_run: NOT_RUN
windows_physical_runtime: NOT_RUN
android_device: NOT_RUN
five_person_comprehension: NOT_RUN
player_experience: NOT_RUN
production_cutover: BLOCKED_DEFERRED
```

## Stable Phase-B / post-merge compatibility aliases

아래 key/literal은 `SX-AUD-025` 이후 post-merge freshness consumer가 사용하는 안정 locator다. **현재 059 상태를 과거로 되돌리는 값이 아니라, 이미 완료된 SX-DEC-055 Phase-B/merge 사실을 보존하는 compatibility aliases**다.

```yaml
user_planning_complete_gate: GRANTED
phase_b_final_planning_review: SX-AUD-047 · PASS
build_authority: AUTHORIZED_AFTER_PHASE_B_CANON_SYNC_MERGE
sx_dec_055_runtime_implementation: MERGED_MAIN_VERIFIED
runtime_integrated: true
sx_dec_055_merge_main: 534a7318b349cd3e784a3467125f9ebd23124d8a
canonical_freshness_audit: SX-AUD-025
latest_automated_verified_product_main: 1339a9467312d0ac680725894a9efb59746ec2cc
pc_local_route_and_mid_run_retest: RETEST_REQUIRED
```

059는 이 완료된 055 이력을 덮어쓰지 않고 이후 player-experience target을 추가한다.

## Stable acceptance compatibility anchors

아래 literal은 Android/device canonical-freshness consumer가 사용하는 안정 locator다. 059가 새 acceptance target을 추가해도 이름을 제거하거나 다른 표기로만 바꾸지 않는다.

```text
SX-DEC-055: MERGED_MAIN_VERIFIED
ANDROID DEVICE SMOKE: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
PRODUCTION CUTOVER: BLOCKED_DEFERRED
```

SX-DEC-055의 과거 패키지/자동화 증거와 SX-DEC-059의 미래 release-near acceptance evidence는 서로 다른 층이다.

## Current product promise

> 선로를 건설해 화물 조우 순서를 설계하고, 적재 선택으로 LIFO를 구성한 뒤, 운행 중 분기 판단으로 계획을 실행하고 결과를 보고 다시 설계하는 finite cargo puzzle.

## SX-DEC-059 · approved first-session

```text
T1 Track Connection
→ T2 Cargo/Station + manual pickup prerequisite
→ T3 LIFO/TOP reverse planning
→ T4 selective non-load + revisit
→ T5 Auto ON safe / OFF decision
→ T6 switch execution
→ existing VS_DEMO_01 Capstone
→ Result / Retry / Edit
```

### Content state

```yaml
new_tutorial_maps_implemented: 5
map_01: T1+T2_SHARED
map_02: T3_LIFO
map_03: T4_SELECTIVE_MANUAL
map_04: T5_LOAD_MODE_SWITCHING
map_05: T6_SWITCH
capstone: VS_DEMO_01_REUSE
map_bytes_authored: true
runtime_package_proof: PASS · 26_JSON_PARSED
```

Exact coordinates/map JSON/private witnesses are RED-first implementation outputs. `VS_DEMO_01` bytes remain unchanged. 기존 73 product PNG는 PR #166에서 player-visible POC surface에 실제 소비된다.

### Architecture state

```text
FirstSessionDefinition / FirstSessionStagePolicy / FirstSessionDirector / FirstSessionCopy
→ current ProductFiniteSlice presentation boundary
→ current finite session/domain authority
```

- onboarding metadata is sidecar data.
- `FiniteMapDefinition` schema v2 unchanged.
- StagePolicy gates visibility + command paths across UI/keyboard/touch/board/route controls.
- standalone demo keeps `first_session_enabled=false`; product main opts in.
- T1→T2 preserves the same product instance and layout signature.

### Result evidence state

059 baseline Debrief uses only current `FiniteRunSummary` truth:

```text
failure_reason: ROUTE_END | TIME_EXPIRED
remaining_map_cargo
stack_size
```

Station mismatch/actual trace is not guessed. PR #166은 이 existing outcome을 presentation-only SUCCESS/FAILURE approved result art에 연결하며 outcome authority를 이동시키지 않는다.

## Playable visual / UX POC state

PR #166은 first-session core를 유지하면서 실제 플레이 화면을 다음처럼 완성했다.

```text
board
→ approved train / straight / curve / switch / crossing / station / cargo textures
HUD
→ build tool product icons + 기존 text/shortcut cue
title / lesson
→ product-art vignette + 1 / 7 lesson progress
result
→ SUCCESS / FAILURE approved result art + Retry / Edit
```

- texture load 실패 시 procedural fallback 유지.
- cargo/station shape/text cue를 유지해 color-only 판별을 피한다.
- Objective/Rules는 stable 560px wrap width로 responsive overflow를 방지한다.
- 960×540 mobile landscape부터 2560×1080 ultrawide까지 기존 의미 보존 regression을 통과했다.
- visible touch minimum 48px와 Reduced Motion same-information identity를 유지한다.

### Exact-head/package evidence

```yaml
Project_Contract: PASS
Thin_Adapter: PASS
GUT_9_7_1: PASS
Godot_headless: 111_CASES_PASS
Windows_Demo_Export: PASS
Windows_packaged_runtime_json_proof: PASS
Android_packaged_runtime_json_proof: PASS
artifact_candidate: SX59-POC-ACCEPT-002
```

이 증거는 실제 사람이 게임을 플레이했다는 증거가 아니다.

## Visual / localization state

- E+D Hybrid / Neo-Arcade Readability.
- current 73 product PNG first; playable POC board/HUD/shell이 핵심 approved asset을 실제 consume한다.
- image generation: NOT_REQUESTED / NOT_RUN; 기존 승인 자산 재사용으로 POC를 완성했다.
- locales: ko / en / ja / zh-Hans.
- zh-Hant deferred until a release target requires it.
- player-facing raw localization key and text-in-PNG are forbidden.

## Playtest / evidence state

Use:
- `PLAYTEST_PLAN_V4_7_CURRENT.md`
- `SX_DEC_059_FIRST_SESSION_PLAYTEST_DELTA.md`
- `SX_DEC_059_POC_ACCEPTANCE_CANDIDATE_02.md`
- `SX_DEC_059_POC_DEVELOPER_SELF_RUN_RECORD_02.md`

```text
PLAYABLE POC AUTOMATED/PACKAGE: PASS · PR #166 MERGED_MAIN_VERIFIED · 1bf798cedf28dffba9185edb62fb1c50c108fe90
→ SX59-POC-ACCEPT-002 developer self-run / screen QA: NOT_RUN
→ exact acceptance build identity: NOT_YET_DESIGNATED
→ reviewed Windows physical smoke on same build: NOT_RUN
→ Android device smoke: NOT_RUN
→ Five-person first-contact comprehension: NOT_RUN
→ player-experience decision gate: NOT_RUN
```

Developer self-run or automated tests do not equal player-experience PASS.

## Tooling state

```yaml
godot: 4.7.1-stable
gut: 9.7.1
project_godot_ai_plugin_cfg: 3.1.4
upstream_godot_ai_3_1_4_version_bump: 96cc8b8c3d25ce487e24801d01d5214fea150349
upstream_godot_ai_main: 3.1.5 @ 09a1e3311015153d967710fbe6502ac519585a9b
prior_verified_release_basis: v3.1.3 @ 22678e5f9b038d7203d6b43b0aae20a5417c500e
project_3_1_4_exact_tree_parity: REVERIFY_REQUIRED_BEFORE_FUTURE_AUTHORING
local_tool_parity: NOT_RUN
```

The implementation used an isolated worktree and Godot 4.7.1. Future authoring must repeat fresh remote/PR/Notion recovery rather than treating this snapshot as live truth.

## Current concurrency boundary

### PR #154

`CLOSED_UNMERGED · SUPERSEDED_BY_SX_DEC_059`.

- no unmerged `game/reuse/*` absorption.
- do not reopen or re-vendor without a new approved need and fresh evidence.

### PR #155 / #156

`CLOSED_UNMERGED · HISTORICAL_ACCIDENT`.

## Protected boundaries

- GMB-002 core unchanged.
- no endless/fuel/BOOST/capacity-8/cargo-slowdown/pickup-respawn/switch-auto-reset.
- no 056/057/058 implementation absorption.
- no score/combo formula invention.
- no fast/cheap TrackPiece field invention.
- no player-facing solver.
- no Base repin.
- no generated visual without explicit user image request.
- no physical/human PASS inflation.

## Implementation package read order

1. `SX_DEC_059_CODEX_HANDOFF_PACKAGE.md`.
2. `SX_DEC_059_CODEX_HANDOFF_AMENDMENT_01.md`.
3. `SX_DEC_059_CODEX_HANDOFF_AMENDMENT_02.md`.
4. parent implementation plan.
5. implementation Amendment 01.
6. implementation Amendment 02.
7. actual current code/tests.
8. use the package as implementation history; do not restart Task 1.

## Resume read order

1. fresh Base completed `main` + Base root `AGENTS.md`.
2. fresh Project `main`, latest commit, all Open/Draft PR.
3. exact Project Notion Home.
4. `AGENTS.md`.
5. `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md`.
6. `FINITE_DELIVERY_PUZZLE_BASELINE.md`.
7. `CURRENT_CONFIRMED_DECISIONS.md`.
8. this `ACTIVE_CONTEXT.md`.
9. `SX_AUD_069_PLAYABLE_VISUAL_UX_POC.md`.
10. `SX_DEC_059_POC_ACCEPTANCE_CANDIDATE_02.md` + `SX_DEC_059_POC_DEVELOPER_SELF_RUN_RECORD_02.md` for current manual validation.
11. `DEVELOPMENT_GATES.md` + `ROADMAP.md`.
12. 059 content/UI/localization/visual/playtest owners.
13. implementation/handoff package only when historical execution evidence is needed.

Historical `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.7_SWITCHY_ADAPTER.md`는 provenance/rollback 확인이 필요할 때만 읽는다.

## Current next action

```text
SX59-POC-ACCEPT-002 developer self-run / screen QA
→ if clean, designate exact acceptance build
→ Windows physical smoke
→ Android device smoke as separate platform gate
→ Five-person first-contact comprehension on the same build
→ EXPAND / REWORK / REPEAT_SLICE / HOLD / STOP
```

**PR #166 playable visual/UX POC는 main `1bf798cedf28dffba9185edb62fb1c50c108fe90`에 병합됐고 automated/package proof는 PASS다. developer self-run / physical / device / human / player-experience validation은 여전히 NOT_RUN이다.**
