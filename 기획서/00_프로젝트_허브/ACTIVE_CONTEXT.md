# Active Context

Last updated: `2026-08-11 KST`

이 문서는 **현재 상태·읽기 순서·미완료 작업·검증 경계·다음 실행 지점**을 연결하는 재개용 locator다. 저장된 SHA/PR 값은 snapshot이며 현재 GitHub default branch, open PR, 실제 파일, configured Sheet가 항상 우선한다.

## Continuation State

```yaml
repository: alsdmlals4-eng/Switchy-Express-Cargo-Puzzle
default_branch: main
phase_b_baseline_main: 47df1c60866ae28f5c415cbe6b886d9ee9a87c7a
phase_b_merge_main: f9440b4724a347b3d1f49f4b22f3ddbb86365108
base_observed_at_phase_b: 315c66eea9614c284b9c11c4d522141065dfa4b0
base_pin: v9.4.3
base_main_is_reference_only: true
engine: Godot 4.7.1-stable
language: GDScript
primary_platform: Android landscape
configured_sheet: 1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo
product_baseline: GMB-002
current_decisions: SX-DEC-027~055
work_instruction: v4.5 r2 · 2026-08-11-r2
phase_a: COMPLETE
user_planning_complete_gate: GRANTED · 2026-08-11 KST
phase_b_final_planning_review: SX-AUD-047 · PASS
build_authority: AUTHORIZED_AFTER_PHASE_B_CANON_SYNC_MERGE
sx_dec_055: APPROVED · SPEC_APPROVED · PHASE_B_DOR_PASS
sx_dec_055_runtime_implementation: NOT_STARTED
semantic_assets: 73_TOTAL · PRODUCTION_COMPLETE
runtime_integrated: false
acceptance_build: UNASSIGNED
physical_device_human: NOT_RUN
production_cutover: BLOCKED_DEFERRED
phase_c_execution_choice: USER_TEMPORARILY_DEFERRED_FOR_CODEX_QUOTA
active_planning_evidence: SX-BMK-001 · ROUTE_PUZZLE_AND_MINIGAME_BENCHMARK · PROPOSED_ONLY
```

## Current user-directed planning window

사용자는 `2026-08-11 KST`에 Codex 사용량 제약 때문에 Phase C 구현을 당장 실행하지 않고, 노선·철도·물류 퍼즐과 관련 미니게임을 벤치마킹해 기획을 더 진행하도록 지시했다.

이 선택은 다음을 의미한다.

- Phase B `PASS`와 Build Authority `AUTHORIZED_AFTER_PHASE_B_CANON_SYNC_MERGE`는 취소되지 않는다.
- `SX-DEC-055` implementation은 계속 `NOT_STARTED`다.
- 이번 추가 기획은 새 제품 결정을 자동 승인하지 않는다.
- benchmark recommendation은 `BMK-Rxx · PROPOSED`로 유지한다.
- 사용자 승인 후에만 새 Decision ID로 승격한다.
- Codex/Phase C가 다시 가능해지면 기존 first RED 지점에서 재개한다.

현재 benchmark dossier:

`기획서/10_경험/SX_BMK_001_ROUTE_PUZZLE_AND_MINIGAME_BENCHMARK.md`

## What Phase B established

- current finite domain/presentation seams still match the approved `SX-DEC-055` architecture;
- the DoR closure commit → current main drift check found no changes to planned runtime `.gd/.tscn` target files;
- `FiniteGameplayInputState` already owns manual/auto truth; only read-only projection is missing;
- `RouteControlOverlay` already owns direction vectors, selected/locked state, cycle count, hit geometry, and input behavior; semantic art may only reinforce them;
- `ProductFiniteSlice` already exposes the delivery/route/terminal presentation seams needed by the POC;
- RUN/BUILD/VFX semantic sidecars remain immutable product-provenance inputs;
- combo must stay deferred if no pre-existing presentation-readable trigger exists;
- existing text/procedural presentation remains fallback/redundancy;
- no gameplay/product redesign is needed for the already-approved `SX-DEC-055` POC.

## Phase B P1 closures

```text
P1-A root README stale GMB-003 / SX-AUD-026-era routing
→ FIXED in Phase-B canon-sync package

P1-B DEVELOPMENT_GATES product authority labeled GMB-003
→ current authority is GMB-002; FIXED in same package

P1-C non-resource JSON export contract absent
→ PLANNING FIXED by SX-DEC-055 Phase B readiness amendment
→ Phase C must add narrow runtime JSON include filter + exported-pack proof
```

The JSON finding matters because the finite map loader and approved semantic catalog read JSON through `FileAccess`, while current export presets had an empty non-resource include filter. A successful export command alone is not enough evidence that those files exist in the PCK.

Companion plan delta:

`docs/superpowers/plans/2026-08-11-sx-dec-055-phase-b-readiness-amendment.md`

## Next legitimate Phase C execution point

Build Authority remains open even while the user intentionally spends the current work window on additional planning.

When Phase C resumes:

```text
SX-DEC-055
→ Task 1 / Step 1.1 RED
→ create tests/demo/test_semantic_asset_catalog.gd
→ register in tests/run_tests.gd
→ run the custom Godot suite
→ require RED specifically because SemanticAssetCatalog is missing
```

The original implementation plan remains authoritative:

`docs/superpowers/plans/2026-08-10-sx-dec-055-runtime-semantic-poc.md`

The readiness amendment adds only Task 9A packaging/export proof; it does not change the first RED step.

## Protected scope

Current approved product/runtime implementation scope:

- no new gameplay/domain rule without explicit approval;
- no LIFO/cargo eligibility/route topology/cycle/U-turn/lock/time/scoring/failure/save/ruleset/map-content change from benchmark proposals until approved;
- no new domain signal solely for VFX;
- no semantic meaning or atlas reinterpretation;
- no product PNG/semantic sidecar rewrite;
- do not flip historical `runtime_integrated=false` provenance;
- no Base repin;
- no `.asset-vault` untrack;
- no physical/device/human PASS inflation;
- no production cutover.

Historical endless/fuel/BOOST/capacity-8/cargo-slowdown/pickup-respawn/switch-auto-reset contracts remain non-current.

`SX-BMK-001` recommendations are planning evidence only and do not bypass this boundary.

## Validation ceiling

```text
FINITE CORE AUTOMATED: PASS
SX-DEC-055 RUNTIME POC: NOT_STARTED
HOSTED EXPORT: packaging evidence only
POST-POC ACCEPTANCE BUILD: UNASSIGNED
WINDOWS PHYSICAL RUNTIME/VISUAL/AUDIO/INPUT: NOT_RUN
ANDROID DEVICE SMOKE: NOT_RUN
CONNECTED PHYSICAL GODOT/HERA: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
BROADER HUMAN: NOT_RUN
PRODUCTION CUTOVER: BLOCKED_DEFERRED
```

## Read order on resume

1. `AGENTS.md`
2. r2 work instruction
3. fresh Base/project main + all open/draft PRs + latest commits
4. configured Sheet current rows
5. `기획서/00_프로젝트_허브/START_HERE.md`
6. `CURRENT_CONFIRMED_DECISIONS.md`
7. this `ACTIVE_CONTEXT.md`
8. `DEVELOPMENT_GATES.md`
9. `SX_AUD_047_PHASE_B_FINAL_PLANNING_REVIEW.md`
10. `기획서/10_경험/SX_BMK_001_ROUTE_PUZZLE_AND_MINIGAME_BENCHMARK.md`
11. `SX_DEC_055_RUNTIME_SEMANTIC_POC.md`
12. runtime semantic POC design spec
13. original implementation plan
14. Phase B readiness amendment
15. exact implementation files at current main before writing RED
