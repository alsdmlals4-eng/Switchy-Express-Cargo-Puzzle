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
sx_dec_055: APPROVED · SPEC_APPROVED · PHASE_B_DOR_PASS · IMPLEMENTATION_NOT_STARTED
sx_dec_056a: DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
sx_dec_056b: BLOCKED_BY_AUTHORITATIVE_SCORE_COMBO_RUNTIME
sx_dec_057: DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
sx_dec_057_attribute_content: BLOCKED_BY_STAGE8_TRACK_ATTRIBUTE_RUNTIME
sx_dec_058: DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
benchmark_r01_r08: APPROVED · DETAILED_PLANNING_CLOSED
benchmark_r09_r10: POST_VALIDATION_HOLD · NO_DECISION_ID
semantic_assets: 73_TOTAL · PRODUCTION_COMPLETE
runtime_integrated: false
acceptance_build: UNASSIGNED
physical_device_human: NOT_RUN
production_cutover: BLOCKED_DEFERRED
phase_c_execution_choice: USER_TEMPORARILY_DEFERRED_FOR_CODEX_QUOTA
latest_post_phase_b_audit: SX-AUD-053
```

## Current user-directed planning result

사용자는 Codex 사용량 제약 동안 노선·철도·물류 퍼즐 벤치마크를 바탕으로 기획을 계속하도록 지시했고, `BMK-R01~R08`을 승인했다. 그 뒤 남은 세부 기획도 계속 진행하도록 지시했다.

현재 mapping과 상세 기획 상태:

```text
BMK-R01/R02/R03/R07 → SX-DEC-056 → SX-AUD-051
BMK-R04/R05/R06     → SX-DEC-057 → SX-AUD-052
BMK-R08             → SX-DEC-058 → SX-AUD-053
BMK-R09/R10         → POST_VALIDATION_HOLD · NO_DECISION_ID
```

`R01~R08`의 제품 방향 + 구현 직전 세부 contract는 현재 planning 기준으로 닫혔다. 남아 있는 것은 explicit implementation authority, dependency-gated upstream runtime capability, content production, runtime build, physical/device/human validation이다.

## SX-DEC-056 · Route Causality Learning / Result Feedback

Owners:

- `docs/decisions/SX_DEC_056_ROUTE_CAUSALITY_LEARNING_AND_RESULT_FEEDBACK.md`
- `docs/superpowers/specs/2026-08-11-route-causality-learning-result-feedback-design.md`
- `docs/superpowers/plans/2026-08-11-sx-dec-056-route-causality-delta.md`
- `기획서/50_제작_검증/SX_AUD_051_SX_DEC_056_DELTA_DOR_FINAL_REVIEW.md`

Current split:

```text
056A
Route Probe + Actual Trace/Debrief + Fastest/Cheapest PB + score-independent Fingerprint v1
→ DELTA_DOR_PASS_PLANNING
→ IMPLEMENTATION_NOT_AUTHORIZED

056B
Highest Score + score/max-combo Fingerprint extension
→ BLOCKED_BY_AUTHORITATIVE_SCORE_COMBO_RUNTIME
```

Exact key contracts:

- Probe consumes duplicate current MapDefinition + TrackLayout and current FiniteTrackGraph truth only.
- start cell itself is not a predicted encounter; first `next_cell()` entered cell is first step.
- repeated directed `(previous,current)` = LOOP; `next_cell == current` = DEAD_END; graph failure = ROUTE_INVALID.
- Probe is spatial cell-step prediction; Trace is actual temporal event history.
- station mismatch evidence comes from existing one `Station.try_unload()` result; no duplicate unload logic.
- route-control trace only records existing `cycle_route_control()` accepted=true changes.
- PB key = map_id + map_revision + ruleset_version; Fastest/Cheapest independent.
- no solver/recommended route/3-star solution/auto-build leakage.

## SX-DEC-057 · Yard Labs / Mastery Curriculum

Owners:

- `docs/decisions/SX_DEC_057_YARD_LABS_AND_MASTERY_CURRICULUM.md`
- `docs/superpowers/specs/2026-08-11-yard-labs-mastery-curriculum-design.md`
- `기획서/20_시스템_콘텐츠/YARD_LAB_AND_MASTERY_CONTENT_CATALOG_V1.md`
- `docs/superpowers/plans/2026-08-11-sx-dec-057-yard-labs-mastery-delta.md`
- `기획서/50_제작_검증/SX_AUD_052_SX_DEC_057_DELTA_DOR_FINAL_REVIEW.md`

Launch planning:

```text
Stage 5 clear → Stack Lab   SL-01~SL-04
Stage 6 clear → Switch Lab  SW-01~SW-04
Stage 8 clear → Builder Lab BL-01~BL-04
```

- 12 launch blueprints fixed.
- lane 내부는 01→04 순차, lane 자체는 optional.
- Lab clear/failure/skip never gates Tutorial/campaign.
- all 4 clear → completion mark only; no power/currency/XP/leaderboard.
- Mastery max 1/chapter.
- core clear count >=2 independently unlocks both next chapter and current Mastery; Mastery cannot block progression.
- internal difficulty rubric: Topology / Stack Entropy / Execution Branching each 0..3.
- request-only hints: rule family → relevant state/location → action class; no exact solution.
- FS-16/FS-17 only activate if exact acceptance build actually includes 057.

Runtime dependency:

- Stack/Switch/basic Builder content is READY_PLANNING.
- `BL-03 Fast vs Cheap` and `M-EXPRESS` are dependency-gated because current TrackPiece has no authoritative fast/cheap attribute field.
- 057 cannot invent that Stage 8 gameplay formula/runtime representation.

## SX-DEC-058 · Fixed-Seed Challenge Quality

Owners:

- `docs/decisions/SX_DEC_058_FIXED_SEED_CHALLENGE_QUALITY_POLICY.md`
- `docs/superpowers/specs/2026-08-11-fixed-seed-challenge-quality-design.md`
- `docs/superpowers/plans/2026-08-11-sx-dec-058-fixed-seed-quality-delta.md`
- `기획서/50_제작_검증/SX_AUD_053_SX_DEC_058_DELTA_DOR_FINAL_REVIEW.md`

Exact planning contract:

- Daily period key = UTC `YYYY-MM-DD`.
- Weekly period key = ISO `YYYY-Www`, Monday 00:00 UTC.
- explicit seed + generator/ruleset/content-profile/map-hash identity.
- deterministic entropy = `SHA256_COUNTER_V1` with named streams.
- solvability = `CONSTRUCTIVE_WITNESS_REPLAY_V1`: generator creates private legal witness, independent verifier replays through current finite authority to real SUCCESS.
- no optimal solver / player hint solver.
- operation bounds: placement<=64, alternatives 2..32, witness steps<=4096, route changes<=128, load/input changes<=256, candidate rejects<=256.
- both cadence profiles require >=2 cargo types, witness stack depth>=2, >=2 structural layout alternatives, witness PASS.
- Daily V1: exactly one T/S/E axis=2, others<=1, >=1 decision class.
- Weekly V1: >=2 axes>=2, >=2 decision classes.
- calibration per version: >=1000 Daily + >=1000 Weekly seeds, 100% regeneration hash parity, >=100 accepted each, first100 duplicate SHA=0, one quality signature <=20%.
- PUBLISHED identity immutable; emergency WITHDRAWN changes availability only.
- runtime receives published identity/manifest + map only.
- witness/alternate layouts/rejection reports must have negative proof of absence from Windows/Android packages.
- backend/transport is separate authority; missing official publication data cannot trigger client-local random replacement.

## Phase B / Phase C boundary

`SX-AUD-047` remains the only current Build Authority review.

```text
build_authority: AUTHORIZED_AFTER_PHASE_B_CANON_SYNC_MERGE
build_authority_scope: SX-DEC-055_ONLY
```

The benchmark-derived detailed planning does not silently expand this authority.

When Phase C resumes, the first legitimate build action is unchanged:

```text
SX-DEC-055
→ Task 1 / Step 1.1 RED
→ create tests/demo/test_semantic_asset_catalog.gd
→ register in tests/run_tests.gd
→ run custom Godot suite
→ require genuine RED because SemanticAssetCatalog is missing
```

Original implementation owner:
`docs/superpowers/plans/2026-08-10-sx-dec-055-runtime-semantic-poc.md`

Mandatory packaging amendment:
`docs/superpowers/plans/2026-08-11-sx-dec-055-phase-b-readiness-amendment.md`

Do not insert 056/057/058 tasks into that plan.

## Remaining planning vs non-planning work

### Planning closed now

- GMB-002 core direction;
- benchmark R01~R08 product direction;
- 056A exact route/trace/PB/fingerprint contract;
- 057 initial 12 Lab blueprints, progression, Mastery, difficulty/hints;
- 058 deterministic identity, witness proof, quality/corpus/publication boundary.

### Intentionally dependency-gated

- 056B Highest Score/score+max-combo until authoritative runtime metrics exist;
- 057 Fast/Cheap content until Stage 8 track attribute runtime exists.

These are not permission to invent substitute rules.

### Intentionally held until validation

- BMK-R09 Shareable Route Card;
- BMK-R10 Editor/UGC.

### Not planning-complete evidence

- runtime implementation;
- actual Lab/map production;
- actual generator/corpus run;
- Windows physical runtime;
- Android device smoke;
- connected physical editor;
- Five-person Comprehension;
- production cutover.

## Validation ceiling

```text
FINITE CORE AUTOMATED: PASS
SX-DEC-055 RUNTIME POC: NOT_STARTED · IMPLEMENTATION AUTHORIZED
SX-DEC-056A: DELTA_DOR_PASS_PLANNING · NOT_AUTHORIZED
SX-DEC-056B: BLOCKED_DEPENDENCY
SX-DEC-057: DELTA_DOR_PASS_PLANNING · NOT_AUTHORIZED
SX-DEC-057 FAST/CHEAP CONTENT: BLOCKED_DEPENDENCY
SX-DEC-058: DELTA_DOR_PASS_PLANNING · NOT_AUTHORIZED
POST-POC ACCEPTANCE BUILD: UNASSIGNED
WINDOWS PHYSICAL: NOT_RUN
ANDROID DEVICE SMOKE: NOT_RUN
CONNECTED PHYSICAL EDITOR: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
PRODUCTION CUTOVER: BLOCKED_DEFERRED
```

## Read order on resume

1. `AGENTS.md`
2. v4.5 r2 work instruction
3. fresh Base/project main + open/draft PRs + latest commits
4. configured Sheet current rows
5. `기획서/00_프로젝트_허브/START_HERE.md`
6. `CURRENT_CONFIRMED_DECISIONS.md`
7. this `ACTIVE_CONTEXT.md`
8. `SX_AUD_047_PHASE_B_FINAL_PLANNING_REVIEW.md`
9. `SX_AUD_051_SX_DEC_056_DELTA_DOR_FINAL_REVIEW.md`
10. `SX_AUD_052_SX_DEC_057_DELTA_DOR_FINAL_REVIEW.md`
11. `SX_AUD_053_SX_DEC_058_DELTA_DOR_FINAL_REVIEW.md`
12. 056/057/058 decision + spec + plan owners
13. SX-DEC-055 decision/spec/original implementation plan + readiness amendment

## Protected historical exclusions

Do not reactivate endless survival, fuel/fuel-zero, BOOST, capacity 8, cargo slowdown, pickup respawn, or switch auto-reset. Product baseline remains GMB-002.
