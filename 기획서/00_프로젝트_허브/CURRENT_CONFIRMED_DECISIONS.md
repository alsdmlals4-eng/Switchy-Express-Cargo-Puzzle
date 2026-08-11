# Current Confirmed Decisions

Last updated: `2026-08-11 KST`

This is the compact current-status registry for the finite delivery puzzle. Detailed rule text, provenance, historical CI evidence, and audit reasoning remain in each Decision/Audit owner and the configured Google Sheet.

## Current authority snapshot

```yaml
current_product_baseline: GMB-002 · FINITE_DELIVERY_PUZZLE_BASELINE
current_decision_span: SX-DEC-027~058
superseded_decision: SX-DEC-047 -> SX-DEC-048
latest_visual_asset_authority: SX-DEC-053
latest_visual_semantic_strategy: SX-DEC-054
latest_runtime_semantic_poc_authority: SX-DEC-055
latest_tooling_authority: SX-DEC-052
latest_route_learning_authority: SX-DEC-056
latest_curriculum_authority: SX-DEC-057
latest_challenge_quality_authority: SX-DEC-058
current_phase_b_audit: SX-AUD-047 · PASS
latest_post_phase_b_scope_audit: SX-AUD-053
project_base_pin: v9.4.3
upstream_base_observed_at_phase_b: 315c66eea9614c284b9c11c4d522141065dfa4b0 · REFERENCE_ONLY
phase_b_baseline_project_main: 47df1c60866ae28f5c415cbe6b886d9ee9a87c7a
configured_sheet: 1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo
phase_a_state: COMPLETE
user_planning_complete_gate: GRANTED · 2026-08-11 KST
phase_b_final_planning_review: PASS
build_authority: AUTHORIZED_AFTER_PHASE_B_CANON_SYNC_MERGE
build_authority_scope: SX-DEC-055_ONLY
sx_dec_055_runtime_implementation: NOT_STARTED
sx_dec_056a_planning: DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
sx_dec_056b_planning: BLOCKED_BY_AUTHORITATIVE_SCORE_COMBO_RUNTIME
sx_dec_057_planning: DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
sx_dec_057_attribute_content: BLOCKED_BY_STAGE8_TRACK_ATTRIBUTE_RUNTIME
sx_dec_058_planning: DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
benchmark_approved_planning: R01~R08 · DETAILED_PLANNING_CLOSED
benchmark_hold: BMK-R09/R10 · POST_VALIDATION_HOLD
semantic_product_assets: 73_TOTAL · PRODUCTION_COMPLETE
runtime_integrated: false
acceptance_build: UNASSIGNED
windows_physical_runtime: NOT_RUN
android_device: NOT_RUN
connected_physical_editor: NOT_RUN
five_person_comprehension: NOT_RUN
production_cutover: BLOCKED_DEFERRED
```

The project remains pinned to Base `v9.4.3`. The newer upstream Base main is observation/reference evidence only and is not an implicit upgrade.

## Current core promise

```text
선로 건설로 화물 조우 순서 설계
→ 수동/자동 적재로 unlimited LIFO 스택 구성
→ 운행 중 분기·교차 경로 전환
→ TOP 연속 동일 화물 하역
→ 제한 시간 안에 모든 필수 배송 완료
→ 배송 완료 전 이동 불가 시 ROUTE_END 실패
→ 결과를 보고 같은 sealed layout 재도전 또는 재설계
```

Approved post-Phase-B planning strengthens how the player predicts, learns, practices, compares routes, and receives fair generated challenges without changing this core domain promise.

## Current Decision Registry

| Decision ID | 분야 | 현재 권위 / 상태 |
|---|---|---|
| SX-DEC-027 | 제품 핵심 | 유한 고정 화물 배송 퍼즐 · CURRENT |
| SX-DEC-028 | 건설 | 자유 선로 건설·비용·전액 환급·추천 비용 · CURRENT |
| SX-DEC-029 | 운행·판정 | 구조 검사·제한 시간·성공/실패·pause · CURRENT |
| SX-DEC-030 | 선로 | 직선·곡선·분기·교차 · CURRENT |
| SX-DEC-031 | 적재·LIFO | 수동 hold·auto toggle·무제한 stack·TOP 그룹 하역 · CURRENT |
| SX-DEC-032 | Combo | 하역 그룹 feedback · CURRENT; readable max-combo runtime metric is not yet a 056 authority |
| SX-DEC-033 | 별·랭킹 | APPROVED · NOT_STARTED; authoritative finite score runtime field not currently exposed |
| SX-DEC-034 | 캠페인 | tutorial·theme chapter · APPROVED · NOT_STARTED; Tutorial 1~10 + 2-of-3 progression protected |
| SX-DEC-035 | 반복 도전 | daily/weekly fixed seed · APPROVED · NOT_RUN |
| SX-DEC-036 | 공정성 | cosmetic-only, power progression 금지 · CURRENT |
| SX-DEC-037 | PC Vertical Slice | IMPLEMENTED · AUTOMATED_CORE_PASS · manual gates remain open |
| SX-DEC-038 | Demo Route Refinement | IMPLEMENTED · automated route/parity pass · physical gates open |
| SX-DEC-039 | Mid-Run Exit | IMPLEMENTED · feature-scoped user evidence; full local flow retest remains open |
| SX-DEC-040 | Station Color Parity | CURRENT · AUTOMATED_PARITY_PASS |
| SX-DEC-041 | Route-End Failure | MERGED_MAIN_VERIFIED · AUTOMATED_PASS · user current-main evidence |
| SX-DEC-042 | Switch Direction Arrows | MERGED_MAIN_VERIFIED · AUTOMATED_PASS · user current-main evidence |
| SX-DEC-043 | v4.3 Entry Gate | APPROVED_GOVERNANCE |
| SX-DEC-044 | GUT 9.7.1 Formal Authority | CURRENT_TEST_AUTHORITY |
| SX-DEC-045 | Single Godot Authoring Authority | CURRENT_AUTHORITY_BOUNDARY · connected physical authoring NOT_RUN |
| SX-DEC-046 | Focused Visual/Audio Component | route procedural arrow safety boundary · CURRENT |
| SX-DEC-047 | Validation Execution Fallback | SUPERSEDED by SX-DEC-048 |
| SX-DEC-048 | Standard Hosted Actions Authority | CURRENT_VALIDATION_EXECUTION_AUTHORITY |
| SX-DEC-049 | Cargo Pickup Marker Visibility | MERGED_MAIN_VERIFIED · user pickup/retry evidence |
| SX-DEC-050 | Finite Visual Planning Package | PLANNING_PACKAGE_MERGED · runtime consumption governed by SX-DEC-055 |
| SX-DEC-051 | E+D Hybrid Production Asset Pack | MERGED_MAIN_VERIFIED · candidates/provenance · not runtime-integrated |
| SX-DEC-052 | Local Tooling & Asset-Vault Reconciliation | MERGED_MAIN_VERIFIED · vault untrack deferred |
| SX-DEC-053 | Final E+D Production Visual Direction | 39 product assets · 8 authoritative slices · runtime consumption governed by SX-DEC-055 |
| SX-DEC-054 | Semantic Asset Completion Strategy | RUN 2A 20 + BUILD 2B 8 + VFX 2C 6 · 73 TOTAL · PRODUCTION_COMPLETE |
| SX-DEC-055 | Runtime Semantic POC | USER_APPROVED · SPEC_APPROVED · DOCS_MERGED · PHASE_B_DOR_PASS · IMPLEMENTATION_AUTHORIZED_NOT_STARTED |
| SX-DEC-056 | Route Causality Learning and Result Feedback | USER_APPROVED · 056A DELTA_DOR_PASS_PLANNING / IMPLEMENTATION_NOT_AUTHORIZED · 056B SCORE/COMBO DEPENDENCY BLOCKED |
| SX-DEC-057 | Yard Labs and Mastery Curriculum | USER_APPROVED · 12-LAB/MASTERY DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED · FAST/CHEAP CONTENT DEPENDENCY GATED |
| SX-DEC-058 | Fixed-Seed Challenge Quality Policy | USER_APPROVED · DETERMINISM/WITNESS/QUALITY/PUBLICATION DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED |

## Phase B / current execution boundary

`SX-AUD-047` remains the Phase B authority for the exact `SX-DEC-055` runtime semantic POC package.

```text
Build authority = SX-DEC-055_ONLY
First executable Phase C action = SX-DEC-055 Task 1 / Step 1.1 RED
```

The Phase B readiness amendment still requires narrow JSON export inclusion/proof before package acceptance.

## Post-Phase-B planning closure

### SX-DEC-056 · SX-AUD-051

```text
056A
Route Probe + Actual Trace/Debrief + Fastest/Cheapest PB + score-independent Fingerprint v1
→ DELTA_DOR_PASS_PLANNING
→ implementation plan written
→ IMPLEMENTATION_NOT_AUTHORIZED

056B
Highest Score PB + score/max-combo fingerprint extension
→ BLOCKED until approved score/combo owners expose authoritative finite runtime metrics
```

### SX-DEC-057 · SX-AUD-052

Launch authoring set:

```text
SL-01~04 · Stack Lab · unlock after Tutorial 5
SW-01~04 · Switch Lab · unlock after Tutorial 6
BL-01~04 · Builder Lab · unlock after Tutorial 8
```

- 12 blueprints complete;
- Lab completion never gates campaign;
- completion mark only, no power/currency/leaderboard;
- Mastery max one per chapter;
- core clear count >=2 independently unlocks both next chapter and current Mastery;
- difficulty rubric T/S/E each 0..3;
- BL-03/M-EXPRESS speed/cheap content dependency-gated because current TrackPiece lacks authoritative attribute representation.

Owners:

- `docs/decisions/SX_DEC_057_YARD_LABS_AND_MASTERY_CURRICULUM.md`
- `docs/superpowers/specs/2026-08-11-yard-labs-mastery-curriculum-design.md`
- `기획서/20_시스템_콘텐츠/YARD_LAB_AND_MASTERY_CONTENT_CATALOG_V1.md`
- `docs/superpowers/plans/2026-08-11-sx-dec-057-yard-labs-mastery-delta.md`
- `기획서/50_제작_검증/SX_AUD_052_SX_DEC_057_DELTA_DOR_FINAL_REVIEW.md`

### SX-DEC-058 · SX-AUD-053

Implementation-ready publication-quality planning:

- canonical Daily UTC date / Weekly ISO week identity;
- `SHA256_COUNTER_V1` deterministic generation stream;
- `CONSTRUCTIVE_WITNESS_REPLAY_V1` existence proof through legal current finite actions;
- deterministic operation budgets;
- at least 2 structural layout alternatives;
- hard nontriviality gates for cargo types/stack depth/route alternatives;
- Daily one-primary-axis profile; Weekly multi-axis profile;
- per-version calibration corpus >=1000 Daily + >=1000 Weekly seeds;
- >=100 accepted per cadence, deterministic hash parity, duplicate/diversity gates;
- immutable PUBLISHED identity; optional WITHDRAWN availability state only;
- runtime receives manifest + map only;
- witness/generator/private quality artifacts require negative package proof;
- backend/transport remains separate authority.

Owners:

- `docs/decisions/SX_DEC_058_FIXED_SEED_CHALLENGE_QUALITY_POLICY.md`
- `docs/superpowers/specs/2026-08-11-fixed-seed-challenge-quality-design.md`
- `docs/superpowers/plans/2026-08-11-sx-dec-058-fixed-seed-quality-delta.md`
- `기획서/50_제작_검증/SX_AUD_053_SX_DEC_058_DELTA_DOR_FINAL_REVIEW.md`

## Benchmark-derived planning status

```text
BMK-R01~R08 → approved and detailed planning closed through SX-AUD-051/052/053
BMK-R09 Shareable Route Card → POST_VALIDATION_HOLD · NO_DECISION_ID
BMK-R10 Editor/UGC → POST_VALIDATION_HOLD · NO_DECISION_ID
```

Remaining work is implementation/production/validation or explicitly dependency-gated authority work, not another open R01~R08 product-design hole.

## Current execution authority

1. Phase A complete; user planning-complete gate granted.
2. Phase B PASS via SX-AUD-047.
3. SX-DEC-055 remains the only implementation-authorized package.
4. SX-DEC-056A/057/058 have implementation-ready planning but no implementation authority.
5. SX-DEC-056B and 057 fast/cheap content await authoritative runtime capabilities; they cannot invent formulas/fields.
6. BMK-R09/R10 remain held until post-validation approval.
7. Windows physical runtime, Android device, connected physical editor, Five-person Comprehension remain NOT_RUN.
8. Acceptance build remains UNASSIGNED.
9. Production cutover remains BLOCKED_DEFERRED.

## Historical product exclusions

Do not reactivate endless survival, fuel/fuel-zero, BOOST, cargo capacity 8, cargo-count slowdown, pickup respawn, or switch auto-reset. Current product authority remains GMB-002.
