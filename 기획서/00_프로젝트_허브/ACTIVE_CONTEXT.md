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
current_decisions: SX-DEC-027~058
work_instruction: v4.5 r2 · 2026-08-11-r2
phase_a: COMPLETE
user_planning_complete_gate: GRANTED · 2026-08-11 KST
phase_b_final_planning_review: SX-AUD-047 · PASS
build_authority: AUTHORIZED_AFTER_PHASE_B_CANON_SYNC_MERGE
build_authority_scope: SX-DEC-055_ONLY
sx_dec_055: APPROVED · SPEC_APPROVED · PHASE_B_DOR_PASS
sx_dec_055_runtime_implementation: NOT_STARTED
sx_dec_056a: USER_APPROVED · DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
sx_dec_056b: USER_APPROVED_DIRECTION · BLOCKED_BY_AUTHORITATIVE_SCORE_COMBO_RUNTIME
sx_dec_057: USER_APPROVED · PLANNING_CANON · DELTA_DOR_PENDING
sx_dec_058: USER_APPROVED · PLANNING_CANON · DELTA_DOR_PENDING
semantic_assets: 73_TOTAL · PRODUCTION_COMPLETE
runtime_integrated: false
acceptance_build: UNASSIGNED
physical_device_human: NOT_RUN
production_cutover: BLOCKED_DEFERRED
phase_c_execution_choice: USER_TEMPORARILY_DEFERRED_FOR_CODEX_QUOTA
benchmark_approval: BMK-R01~R08 APPROVED → SX-DEC-056~058
benchmark_hold: BMK-R09/R10 · POST_VALIDATION_HOLD · NO_DECISION_ID
latest_post_phase_b_audit: SX-AUD-051
```

## Current user-directed planning window

사용자는 `2026-08-11 KST`에 Codex 사용량 제약 때문에 Phase C 구현을 당장 실행하지 않고, 노선·철도·물류 퍼즐과 관련 미니게임을 벤치마킹해 기획을 더 진행하도록 지시했다. benchmark recommendation `R01~R08` 승인 후, 남은 기획을 계속 진행하도록 지시했다.

현재 승인 mapping:

```text
BMK-R01/R02/R03/R07 → SX-DEC-056 · Route Causality Learning and Result Feedback
BMK-R04/R05/R06     → SX-DEC-057 · Yard Labs and Mastery Curriculum
BMK-R08             → SX-DEC-058 · Fixed-Seed Challenge Quality Policy
BMK-R09/R10         → POST_VALIDATION_HOLD · NO_DECISION_ID
```

Current owners:

- `기획서/10_경험/SX_BMK_001_ROUTE_PUZZLE_AND_MINIGAME_BENCHMARK.md` — pre-approval benchmark snapshot;
- `기획서/10_경험/SX_BMK_001_APPROVAL_STATUS.md` — current approval overlay;
- `docs/decisions/SX_DEC_056_ROUTE_CAUSALITY_LEARNING_AND_RESULT_FEEDBACK.md`;
- `docs/superpowers/specs/2026-08-11-route-causality-learning-result-feedback-design.md`;
- `docs/superpowers/plans/2026-08-11-sx-dec-056-route-causality-delta.md`;
- `기획서/50_제작_검증/SX_AUD_051_SX_DEC_056_DELTA_DOR_FINAL_REVIEW.md`;
- `docs/decisions/SX_DEC_057_YARD_LABS_AND_MASTERY_CURRICULUM.md`;
- `docs/decisions/SX_DEC_058_FIXED_SEED_CHALLENGE_QUALITY_POLICY.md`.

Important implementation boundary:

- Phase B `PASS` and `build_authority: AUTHORIZED_AFTER_PHASE_B_CANON_SYNC_MERGE` remain valid for the exact `SX-DEC-055` package reviewed by `SX-AUD-047`.
- `SX-DEC-056~058` were approved after that review and do **not** inherit its BUILD authority.
- `SX-AUD-051` completes 056A implementation-ready planning only; it does not grant code authority.
- `SX-DEC-056B` cannot implement Highest Score or score/max-combo fingerprint until existing approved score/combo owners expose authoritative runtime metrics.
- `SX-DEC-057/058` still require their own scoped delta DoR/final planning reviews.
- Codex/Phase C remains temporarily deferred by user choice.

## What Phase B established

- current finite domain/presentation seams still match the approved `SX-DEC-055` architecture;
- the DoR closure commit → Phase-B main drift check found no changes to planned runtime `.gd/.tscn` target files;
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

## Post-Phase-B additive planning

### SX-DEC-056 · delta DoR reviewed

Approved scope:

- internal route-causality feature triage language;
- request-only BUILD Route Probe / Encounter Strip;
- actual-event-only Encounter Trace / Debrief;
- independent Fastest/Cheapest/Highest Score PB records;
- Route Fingerprint as explanatory metadata, not ranking authority.

`SX-AUD-051` fresh-read conclusions:

- Route Probe uses duplicate `MapDefinition + TrackLayout` → `FiniteTrackGraphBuilder` → existing `next_cell()` only;
- start cell is not counted as an encounter; first predicted encounter is the first actual next entered cell;
- LOOP is repeated directed `(previous,current)` traversal state; `next_cell == current` is DEAD_END; graph build failure is ROUTE_INVALID;
- Probe is spatial cell-step projection, not actual-event trace;
- station causal evidence comes from the existing single `Station.try_unload()` result, not a duplicated rule;
- route-control change is recorded only when existing `cycle_route_control()` returns true;
- Fastest/Cheapest PB and score-independent Fingerprint v1 have exact persistence/metric contracts;
- Highest Score remains blocked because current finite runtime exposes no authoritative score field;
- max-combo fingerprint remains blocked until an authoritative readable metric exists.

Current split:

```text
SX-DEC-056A
Route Probe + Trace/Debrief + Fastest/Cheapest + Fingerprint v1
→ DELTA_DOR_PASS_PLANNING
→ implementation plan written
→ IMPLEMENTATION_NOT_AUTHORIZED

SX-DEC-056B
Highest Score + score/max-combo fingerprint extension
→ BLOCKED_DEPENDENCY
→ no guessed formula allowed
```

Protected boundary: no solver/optimal route/unload answer/auto-build and no new gameplay/scoring rule.

### SX-DEC-057 · next planning lane

Approved scope:

- Stack Lab after Tutorial Stage 5 candidate unlock;
- Switch Lab after Stage 6;
- Builder Lab after Stage 8;
- Tutorial 1~10 exact order remains owned by SX-DEC-034;
- optional chapter Mastery Spur, never progression-required;
- difficulty tagged by Topology Complexity / Stack Entropy / Execution Branching.

Still to close in delta DoR:

- exact Lab content schema and allowed-rule whitelist;
- per-Lab actual puzzle set/learning objective/failure observation;
- unlock/skip/re-entry/progression state;
- Mastery Spur count/template/reward guardrails;
- numeric difficulty calibration and transfer-validation mapping.

Protected boundary: Labs/Mastery use existing rules only and grant no gameplay power.

### SX-DEC-058 · following planning lane

Approved scope:

- preserve Daily 1 / Weekly 1 fixed-seed procedural challenge lane;
- deterministic challenge identity;
- structural validation + minimum one legal success proof before publication;
- solver/witness remains offline/internal only;
- quality screening before publication;
- launch with base rules only.

Still to close in delta DoR:

- exact solver state/search algorithm boundary;
- deterministic seed/version identity;
- generation/per-seed performance budget;
- corpus size and calibration thresholds;
- degenerate/trivial/one-path rejection metrics;
- timeout/failure publication behavior;
- witness/runtime isolation proof.

Protected boundary: no authored substitution, hidden scoring, exclusive power, or challenge-only gameplay modifier without another Decision.

## Next legitimate Phase C execution point

Build Authority remains open for `SX-DEC-055` even while the user intentionally spends the current work window on additional planning.

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

Do not insert `SX-DEC-056~058` into that implementation plan. 056A has a separate plan but still requires explicit implementation authority.

## Protected scope

Current approved `SX-DEC-055` runtime implementation scope:

- no new gameplay/domain rule from SX-DEC-056~058 during the existing POC;
- no LIFO/cargo eligibility/route topology/cycle/U-turn/lock/time/scoring/failure/save/ruleset/map-content change;
- no new domain signal solely for VFX;
- no semantic meaning or atlas reinterpretation;
- no product PNG/semantic sidecar rewrite;
- do not flip historical `runtime_integrated=false` provenance;
- no Base repin;
- no `.asset-vault` untrack;
- no physical/device/human PASS inflation;
- no production cutover.

Historical endless/fuel/BOOST/capacity-8/cargo-slowdown/pickup-respawn/switch-auto-reset contracts remain non-current.

`BMK-R09/R10` remain hold-only and cannot be implemented or described as current product authority.

## Validation ceiling

```text
FINITE CORE AUTOMATED: PASS
SX-DEC-055 RUNTIME POC: NOT_STARTED
SX-DEC-056A: DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
SX-DEC-056B: BLOCKED_DEPENDENCY
SX-DEC-057/058: DELTA_DOR_PENDING
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
10. `기획서/10_경험/SX_BMK_001_APPROVAL_STATUS.md`
11. `SX_AUD_049_BENCHMARK_APPROVAL_AND_POST_PHASE_B_SCOPE_RECONCILIATION.md`
12. `SX_AUD_051_SX_DEC_056_DELTA_DOR_FINAL_REVIEW.md`
13. `SX_DEC_056_ROUTE_CAUSALITY_LEARNING_AND_RESULT_FEEDBACK.md`
14. 056 design spec + implementation plan
15. `SX_DEC_057_YARD_LABS_AND_MASTERY_CURRICULUM.md`
16. `SX_DEC_058_FIXED_SEED_CHALLENGE_QUALITY_POLICY.md`
17. `SX_DEC_055_RUNTIME_SEMANTIC_POC.md`
18. runtime semantic POC design/original plan/Phase B readiness amendment
