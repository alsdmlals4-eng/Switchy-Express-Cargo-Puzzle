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
latest_post_phase_b_scope_audit: SX-AUD-049
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
sx_dec_056_058_planning: USER_APPROVED · IMPLEMENTATION_NOT_AUTHORIZED_UNTIL_DELTA_DOR
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

Approved post-Phase-B planning strengthens how the player predicts, learns, practices, and compares routes without changing this core domain promise.

Hard constraints remain LIFO, cargo/station color+shape+text redundancy, save/ruleset identity discipline, and no unapproved core-product widening.

## Current Decision Registry

| Decision ID | 분야 | 현재 권위 / 상태 |
|---|---|---|
| SX-DEC-027 | 제품 핵심 | 유한 고정 화물 배송 퍼즐 · CURRENT |
| SX-DEC-028 | 건설 | 자유 선로 건설·비용·전액 환급·추천 비용 · CURRENT |
| SX-DEC-029 | 운행·판정 | 구조 검사·제한 시간·성공/실패·pause · CURRENT |
| SX-DEC-030 | 선로 | 직선·곡선·분기·교차 · CURRENT |
| SX-DEC-031 | 적재·LIFO | 수동 hold·auto toggle·무제한 stack·TOP 그룹 하역 · CURRENT |
| SX-DEC-032 | Combo | 하역 그룹 feedback · CURRENT; SX-DEC-055는 새 domain trigger를 만들지 않음 |
| SX-DEC-033 | 별·랭킹 | APPROVED · NOT_STARTED |
| SX-DEC-034 | 캠페인 | tutorial·theme chapter · APPROVED · NOT_STARTED |
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
| SX-DEC-056 | Route Causality Learning and Result Feedback | USER_APPROVED · PLANNING_CANON · IMPLEMENTATION_NOT_AUTHORIZED_UNTIL_DELTA_DOR |
| SX-DEC-057 | Yard Labs and Mastery Curriculum | USER_APPROVED · PLANNING_CANON · IMPLEMENTATION_NOT_AUTHORIZED_UNTIL_DELTA_DOR |
| SX-DEC-058 | Fixed-Seed Challenge Quality Policy | USER_APPROVED · PLANNING_CANON · IMPLEMENTATION_NOT_AUTHORIZED_UNTIL_DELTA_DOR |

## SX-DEC-055 current architecture

```text
SX-DEC-053/054 product manifests
→ presentation-owned SemanticAssetCatalog
→ existing presenter model / render snapshot / existing events
→ HUD + board + route + semantic event presentation
```

Approved representative proof:

- RUN Stack/load state from existing presentation/input truth;
- BUILD placement/preflight from existing snapshot/model data;
- route semantic reinforcement while procedural direction/cycle/hit/lock authority remains unchanged;
- pickup/unload/route-selection/terminal feedback from existing presentation seams;
- Reduced Motion uses the same information key/input with motion removed;
- combo asset resolves, but no new gameplay/domain signal may be invented solely to trigger it;
- existing Korean text/procedural presentation remains fallback/redundancy.

## Phase B readiness delta

`SX-AUD-047` found one implementation-readiness P1 not explicit in the original DoR: Godot non-resource JSON files are not covered by the current export presets' empty `include_filter`.

Companion amendment:

`docs/superpowers/plans/2026-08-11-sx-dec-055-phase-b-readiness-amendment.md`

Phase C must add the narrow runtime JSON export contract and exported-pack proof for `data/maps/*.json` and `art/product_assets/ed_hybrid_v1/*.json` before export packaging can satisfy the POC gate.

This is packaging correctness, not a product Decision change. Historical semantic manifests keep their original `runtime_integrated=false` provenance.

## Post-Phase-B approved planning

The user approved the `SX-BMK-001` recommendation set `BMK-R01~R08` on `2026-08-11 KST`.

Current mapping:

```text
BMK-R01/R02/R03/R07 → SX-DEC-056
BMK-R04/R05/R06     → SX-DEC-057
BMK-R08             → SX-DEC-058
BMK-R09/R10         → POST_VALIDATION_HOLD · NO_DECISION_ID
```

Owners:

- `docs/decisions/SX_DEC_056_ROUTE_CAUSALITY_LEARNING_AND_RESULT_FEEDBACK.md`
- `docs/decisions/SX_DEC_057_YARD_LABS_AND_MASTERY_CURRICULUM.md`
- `docs/decisions/SX_DEC_058_FIXED_SEED_CHALLENGE_QUALITY_POLICY.md`
- `기획서/10_경험/SX_BMK_001_APPROVAL_STATUS.md`
- `기획서/50_제작_검증/SX_AUD_049_BENCHMARK_APPROVAL_AND_POST_PHASE_B_SCOPE_RECONCILIATION.md`

These Decisions are additive planning authority. Because they were approved after `SX-AUD-047`, they do not inherit the already-completed Phase B implementation authorization. A scoped delta DoR/final planning review is required before their code/content implementation.

## Current execution authority

```text
1. Phase A planning evidence is complete.
2. The user explicitly declared "기획 완료" on 2026-08-11 KST.
3. SX-AUD-047 Phase B Final Planning Review is PASS.
4. BUILD authority remains active for the exact SX-DEC-055 package reviewed by Phase B.
5. The first Phase C action remains the existing SX-DEC-055 plan's Task 1 / Step 1.1 RED.
6. The Phase B readiness amendment is mandatory before final export/package acceptance.
7. SX-DEC-056~058 are USER_APPROVED planning/product canon but require a separate delta DoR before implementation.
8. BMK-R09/R10 remain POST_VALIDATION_HOLD and have no Decision ID.
9. No new gameplay/domain signal may be introduced solely for semantic presentation.
10. Product PNG/semantic sidecar bytes and historical provenance are protected.
11. Windows physical runtime, Android device, connected physical editor, and Five-person Comprehension remain separate NOT_RUN gates.
12. Post-POC acceptance build identity remains UNASSIGNED until implementation merge.
13. `.asset-vault` untrack remains deferred pending local preservation attestation.
14. Production cutover remains BLOCKED_DEFERRED.
```

## Historical product exclusions

The following remain historical/superseded and must not be reactivated by current implementation:

- endless survival;
- fuel / fuel-zero game over;
- player BOOST;
- cargo capacity 8;
- cargo-count slowdown;
- pickup respawn;
- switch auto-reset.

Current product authority is `GMB-002`, not the historical `GMB-003` route-end/switch implementation package.
