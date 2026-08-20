# Active Context

Last updated: `2026-08-20 KST`

이 문서는 **현재 상태·정본 읽기 순서·다음 실행 지점·미검증 경계**를 연결하는 resume locator다. 저장된 SHA/PR은 snapshot이며 fresh GitHub/Notion/actual runtime이 우선한다.

## Continuation State

```yaml
repository: alsdmlals4-eng/Switchy-Express-Cargo-Puzzle
default_branch: main
project_main_observed_at_planning_complete: 0a88f707e1e4131ae4372929f2871d2b8a3a74b7
planning_branch: planning/sx-dec-059-release-near-first-session-slice
base_pin: v9.4.3
base_remote_latest_observed: ef0092256be25eaa70a296a76d02f7205934929e
base_remote_role: REFERENCE_ONLY
engine: Godot 4.7.1-stable
language: GDScript
work_instruction: v4.7 · 2026-08-20-r1 · SWITCHY_THIN_ADAPTER
product_baseline: GMB-002
current_decisions: SX-DEC-027~059
sx_dec_059_user_planning_complete: GRANTED · 2026-08-20 KST
sx_dec_059_phase_c: FINAL_REVIEW_AND_PACKAGE_PREP
sx_dec_059_build: NOT_STARTED
sx_dec_059_codex_handoff: NOT_REQUESTED
sx_dec_055: MERGED_MAIN_VERIFIED · PR_151
sx_dec_056a: PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED
sx_dec_056b: BLOCKED_BY_AUTHORITATIVE_SCORE_COMBO_RUNTIME
sx_dec_057: PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED
sx_dec_058: PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED
semantic_assets: 73_TOTAL · PRODUCTION_COMPLETE
open_protected_pr: "#154 · READ_ONLY · other workstream"
acceptance_build: UNASSIGNED
windows_physical_runtime: NOT_RUN
android_device: NOT_RUN
five_person_comprehension: NOT_RUN
player_experience: NOT_RUN
production_cutover: BLOCKED_DEFERRED
```

## Current product promise

> 선로를 건설해 화물 조우 순서를 설계하고, 적재 선택으로 LIFO를 구성한 뒤, 운행 중 분기 판단으로 계획을 실행하고 결과를 보고 다시 설계하는 finite cargo puzzle.

## SX-DEC-059 · current approved first-session

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
new_tutorial_map_target: 5
map_01: T1+T2_SHARED
map_02: T3_LIFO
map_03: T4_SELECTIVE_MANUAL
map_04: T5_LOAD_MODE_SWITCHING
map_05: T6_SWITCH
capstone: VS_DEMO_01_REUSE
map_bytes_authored: false
```

Exact coordinates/map JSON/witness는 Codex BUILD에서 test-first로 작성한다. 계획 단계에서 검증하지 않은 좌표를 정본처럼 발명하지 않는다.

### Architecture state

```text
FirstSessionDirector / FirstSessionStagePolicy
→ current ProductFiniteSlice(map_path)
→ current finite session/domain authority
```

- onboarding metadata는 sidecar data.
- `FiniteMapDefinition` schema v2 unchanged.
- UI visibility와 keyboard/touch allowed-command를 동일 StagePolicy가 통제.
- ProductFiniteSlice standalone path는 보존.

### Result evidence state

059 baseline Debrief는 current `FiniteRunSummary`가 증명하는 정보만 사용한다.

```text
failure_reason: ROUTE_END | TIME_EXPIRED
remaining_map_cargo
stack_size
```

Station mismatch/actual encounter trace는 056A observation implementation 전에는 추측하지 않는다.

## Current visual / localization state

- E+D Hybrid / Neo-Arcade Readability 유지.
- current 73 product PNG first.
- VIS-SX-059-02 Capstone RUN brief ready.
- VIS-SX-059-03 Failure Result brief ready.
- image generation: NOT_REQUESTED / NOT_RUN.
- first-session localization copy matrix: ko/en/ja/zh-* ready.
- reusable PNG에 localized text baked-in 금지.

## Playtest / evidence state

`SX_DEC_059_FIRST_SESSION_PLAYTEST_DELTA.md`는 기존 `PLAYTEST_PLAN.md`를 확장한다.

```text
AUTOMATED CONTRACT
→ developer self-run / screen QA
→ exact acceptance build + physical smoke
→ Five-person first-contact comprehension
→ decision gate
```

Developer self-run이나 자동 테스트만으로 재미·이해를 PASS 처리하지 않는다.

## Tooling state

```yaml
godot: 4.7.1-stable
gut: 9.7.1
project_godot_ai_plugin_cfg: 3.1.4
upstream_godot_ai_main: 3.1.5 @ 09a1e3311015153d967710fbe6502ac519585a9b
prior_verified_release_basis: v3.1.3 @ 22678e5f9b038d7203d6b43b0aae20a5417c500e
project_3_1_4_provenance: REVERIFY_REQUIRED_BEFORE_BUILD
local_tool_parity: NOT_RUN
```

Fresh PowerShell/Codex handoff에서 local/repo exact tree parity를 확인한다.

## Current concurrency boundary

### PR #154

`feat: pilot reusable grid and semantic UI modules` is OPEN/DRAFT and protected by the current approved 059 work contract.

- read-only overlap evidence only.
- no update/rebase/close/merge.
- no selective copy/vendor of unmerged `game/reuse/*` into 059.
- if later completed/merged, reevaluate new main only.

### PR #155 / #156

Accidentally created during planning, immediately CLOSED_UNMERGED. Historical only; not a current workstream.

## Protected boundaries

- GMB-002 core remains current.
- no endless/fuel/BOOST/capacity-8/cargo-slowdown/pickup-respawn/switch-auto-reset.
- no 056/057/058 implementation absorption.
- no score/combo formula invention.
- no fast/cheap TrackPiece field invention.
- no player-facing solver.
- no Base repin.
- no generated visual without explicit user image request.
- no physical/human PASS inflation.

## Resume read order

1. fresh Base completed `main`.
2. fresh Project `main`, latest commit, all Open/Draft PR.
3. exact Project Notion Home.
4. `AGENTS.md`.
5. `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.7_SWITCHY_ADAPTER.md`.
6. `FINITE_DELIVERY_PUZZLE_BASELINE.md`.
7. `CURRENT_CONFIRMED_DECISIONS.md`.
8. this `ACTIVE_CONTEXT.md`.
9. `FIRST_SESSION_STAGE_CONTENT_SPEC_V1.md`.
10. `FIRST_SESSION_SCREEN_CONTENT_DATA_CONTRACT.md`.
11. `SX_DEC_059_FIRST_SESSION_PLAYTEST_DELTA.md`.
12. exact implementation package when Codex handoff is requested.

## Current next action

```text
finish fresh Phase-C final review
→ implementation package DoR
→ GitHub + Notion readback
→ wait for USER_REQUESTED_CODEX_HANDOFF
```

**PowerShell/Codex/Godot BUILD has not started.**
