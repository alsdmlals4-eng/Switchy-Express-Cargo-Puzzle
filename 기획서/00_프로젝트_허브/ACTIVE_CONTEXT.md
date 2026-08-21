# Active Context

Last updated: `2026-08-21 KST`

이 문서는 **현재 상태·다음 실행 지점·미검증 경계**를 연결하는 resume locator다. fresh GitHub/Notion/actual runtime이 저장 snapshot보다 우선한다.

## Continuation State

```yaml
repository: alsdmlals4-eng/Switchy-Express-Cargo-Puzzle
default_branch: main
project_main_before_implementation: 4b37c154505ed1975735fc305a68b410877a40e0
implementation_branch: feat/sx-dec-059-first-session
base_pin: v9.4.3
base_remote_latest_observed: ef0092256be25eaa70a296a76d02f7205934929e · REFERENCE_ONLY
engine: Godot 4.7.1-stable
language: GDScript
work_instruction: v4.7 · 2026-08-20-r1 · SWITCHY_THIN_ADAPTER
product_baseline: GMB-002
current_decisions: SX-DEC-027~059
sx_dec_059_user_planning_complete: GRANTED · 2026-08-20 KST
sx_dec_059_phase_c: PASS · SX-AUD-064 · CLEAN_REVIEW_EXIT
sx_dec_059_repository_canon: IMPLEMENTATION_CANON_AUTHORED
sx_dec_059_notion_sync: POST_MERGE_READBACK_REQUIRED
sx_dec_059_package_spec_dor: PASS
sx_dec_059_execution_preflight: PASS
sx_dec_059_codex_handoff: USER_REQUESTED_AND_EXECUTED
SX_DEC_059_IMPLEMENTATION: IMPLEMENTED_AUTOMATED
sx_dec_059_build: RELEASE_NEAR_VERTICAL_SLICE_AUTOMATED_GREEN
sx_dec_059_adversarial_review: FIVE_PASS_CLOSED · SX-AUD-066
sx_dec_055: MERGED_MAIN_VERIFIED · PR_151
sx_dec_056a: PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED
sx_dec_056b: BLOCKED_BY_AUTHORITATIVE_SCORE_COMBO_RUNTIME
sx_dec_057: PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED
sx_dec_058: PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED
semantic_assets: 73_TOTAL · PRODUCTION_COMPLETE
pr_154: "AUDITED · SUPERSEDED_UNMERGED_BY_059"
acceptance_build: UNASSIGNED
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

Exact coordinates/map JSON/private witnesses are RED-first implementation outputs. `VS_DEMO_01` bytes and the 73 product PNGs remain unchanged.

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

Station mismatch/actual trace is not guessed.

## Visual / localization state

- E+D Hybrid / Neo-Arcade Readability.
- current 73 product PNG first.
- image generation: NOT_REQUESTED / NOT_RUN.
- locales: ko / en / ja / zh-Hans.
- zh-Hant deferred until a release target requires it.
- player-facing raw localization key and text-in-PNG are forbidden.

## Playtest / evidence state

Use:
- `PLAYTEST_PLAN_V4_7_CURRENT.md`
- `SX_DEC_059_FIRST_SESSION_PLAYTEST_DELTA.md`

```text
AUTOMATED CONTRACT
→ developer self-run / screen QA
→ exact acceptance build + physical smoke
→ Five-person first-contact comprehension
→ decision gate
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
project_3_1_4_exact_tree_parity: REVERIFY_REQUIRED_BEFORE_BUILD
local_tool_parity: NOT_RUN
```

The implementation used an isolated worktree and Godot 4.7.1. Future work must repeat fresh remote/PR/Notion recovery rather than treating this snapshot as live truth.

## Current concurrency boundary

### PR #154

Audited in full and superseded by the product-owned SX-DEC-059 implementation.

- no unmerged `game/reuse/*` absorption.
- close unmerged after the replacement implementation is integrated.

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

1. fresh Base completed `main`.
2. fresh Project `main`, latest commit, all Open/Draft PR.
3. exact Project Notion Home.
4. `AGENTS.md`.
5. v4.7 Switchy adapter.
6. `FINITE_DELIVERY_PUZZLE_BASELINE.md`.
7. `CURRENT_CONFIRMED_DECISIONS.md`.
8. this `ACTIVE_CONTEXT.md`.
9. `DEVELOPMENT_GATES.md`.
10. 059 content/UI/localization/visual/playtest owners.
11. implementation/handoff package only when execution is requested.

## Current next action

```text
implementation PR exact-head CI + merge
→ close superseded PR #154 unmerged
→ Notion Project Home/core-system/handoff destination sync + readback
→ physical Windows/Android + five-person comprehension when authorized/prepared
```

**Automated implementation is complete; physical/device/human validation remains NOT_RUN.**
