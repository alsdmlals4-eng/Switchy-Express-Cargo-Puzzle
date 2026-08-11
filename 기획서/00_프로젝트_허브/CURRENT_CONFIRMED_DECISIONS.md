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
latest_post_phase_b_scope_audit: SX-AUD-054
project_base_pin: v9.4.3
upstream_base_observed_latest: 069f0c9654a6cde7cea6f3343dd2fa81c6248d5d · REFERENCE_ONLY
phase_b_baseline_project_main: 47df1c60866ae28f5c415cbe6b886d9ee9a87c7a
configured_sheet: 1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo
phase_a_state: COMPLETE
user_planning_complete_gate: GRANTED · 2026-08-11 KST
phase_b_final_planning_review: PASS
build_authority: AUTHORIZED_AFTER_PHASE_B_CANON_SYNC_MERGE
build_authority_scope: SX-DEC-055_ONLY
sx_dec_055_runtime_implementation: MERGED_MAIN_VERIFIED
sx_dec_055_merge_pr: 151
sx_dec_055_merge_main: 534a7318b349cd3e784a3467125f9ebd23124d8a
runtime_integrated: true
sx_dec_055_export_json_proof: WINDOWS_AND_ANDROID_PRESET_PCK_PASS · 13_JSON_EACH
sx_dec_056a_planning: DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
sx_dec_056b_planning: BLOCKED_BY_AUTHORITATIVE_SCORE_COMBO_RUNTIME
sx_dec_057_planning: DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
sx_dec_057_attribute_content: BLOCKED_BY_STAGE8_TRACK_ATTRIBUTE_RUNTIME
sx_dec_058_planning: DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
benchmark_approved_planning: R01~R08 · DETAILED_PLANNING_CLOSED
benchmark_hold: BMK-R09/R10 · POST_VALIDATION_HOLD
semantic_product_assets: 73_TOTAL · PRODUCTION_COMPLETE
acceptance_build: UNASSIGNED
windows_physical_runtime: NOT_RUN
android_device: NOT_RUN
connected_physical_editor: NOT_RUN
five_person_comprehension: NOT_RUN
production_cutover: BLOCKED_DEFERRED
```

The project remains pinned to Base `v9.4.3`. Upstream Base current main is observation/reference evidence only and is not an implicit upgrade.

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
| SX-DEC-034 | 캠페인 | Tutorial 1~10 + 2-of-3 progression protected · APPROVED · NOT_STARTED |
| SX-DEC-035 | 반복 도전 | Daily/Weekly fixed seed · APPROVED · NOT_RUN |
| SX-DEC-036 | 공정성 | cosmetic-only, power progression 금지 · CURRENT |
| SX-DEC-037 | PC Vertical Slice | IMPLEMENTED · AUTOMATED_CORE_PASS · manual gates remain open |
| SX-DEC-038 | Demo Route Refinement | IMPLEMENTED · automated route/parity pass · physical gates open |
| SX-DEC-039 | Mid-Run Exit | IMPLEMENTED · feature-scoped user evidence; full local flow retest remains open |
| SX-DEC-040 | Station Color Parity | CURRENT · AUTOMATED_PARITY_PASS |
| SX-DEC-041 | Route-End Failure | MERGED_MAIN_VERIFIED · AUTOMATED_PASS |
| SX-DEC-042 | Switch Direction Arrows | MERGED_MAIN_VERIFIED · AUTOMATED_PASS |
| SX-DEC-043 | v4.3 Entry Gate | APPROVED_GOVERNANCE |
| SX-DEC-044 | GUT 9.7.1 Formal Authority | CURRENT_TEST_AUTHORITY |
| SX-DEC-045 | Single Godot Authoring Authority | CURRENT_AUTHORITY_BOUNDARY · connected physical authoring NOT_RUN |
| SX-DEC-046 | Focused Visual/Audio Component | route procedural arrow safety boundary · CURRENT |
| SX-DEC-047 | Validation Execution Fallback | SUPERSEDED by SX-DEC-048 |
| SX-DEC-048 | Standard Hosted Actions Authority | CURRENT_VALIDATION_EXECUTION_AUTHORITY |
| SX-DEC-049 | Cargo Pickup Marker Visibility | MERGED_MAIN_VERIFIED |
| SX-DEC-050 | Finite Visual Planning Package | PLANNING_PACKAGE_MERGED |
| SX-DEC-051 | E+D Hybrid Production Asset Pack | MERGED_MAIN_VERIFIED · candidates/provenance |
| SX-DEC-052 | Local Tooling & Asset-Vault Reconciliation | MERGED_MAIN_VERIFIED · vault untrack deferred |
| SX-DEC-053 | Final E+D Production Visual Direction | 39 product assets · 8 authoritative slices · CURRENT |
| SX-DEC-054 | Semantic Asset Completion Strategy | RUN 2A 20 + BUILD 2B 8 + VFX 2C 6 · 73 TOTAL · PRODUCTION_COMPLETE |
| SX-DEC-055 | Runtime Semantic POC | USER_APPROVED · IMPLEMENTED · PR #151 MERGED · runtime_integrated=true · AUTOMATED/EXPORT_PROOF_PASS · PHYSICAL/DEVICE/HUMAN NOT_RUN |
| SX-DEC-056 | Route Causality Learning and Result Feedback | USER_APPROVED · 056A DELTA_DOR_PASS_PLANNING / IMPLEMENTATION_NOT_AUTHORIZED · 056B DEPENDENCY BLOCKED |
| SX-DEC-057 | Yard Labs and Mastery Curriculum | USER_APPROVED · 12-LAB/MASTERY DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED · FAST/CHEAP DEPENDENCY GATED |
| SX-DEC-058 | Fixed-Seed Challenge Quality Policy | USER_APPROVED · DETERMINISM/WITNESS/QUALITY/PUBLICATION DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED |

## SX-DEC-055 implementation closure

PR #151 exact head: `63b0ed331e043db7d677ca097bdb209003bda4be`.
Merged main: `534a7318b349cd3e784a3467125f9ebd23124d8a`.

Implemented presentation/runtime scope:

- manifest-backed semantic asset catalog and state mapping;
- Stack/manual/auto/preflight HUD semantic reinforcement;
- BUILD ghost/preflight semantic reinforcement;
- route-control semantic state reinforcement;
- pickup/unload/route/result semantic event overlay;
- Reduced Motion same-information contract;
- narrow map + semantic JSON export inclusion and exported-pack proof.

Exact-head evidence:

```text
Project Contract #1242 PASS
GUT 9.7.1 #291 PASS
Godot Tests #1173 PASS
Thin Adapter #369 PASS
Windows Demo Export #241 PASS
custom suite 97 cases / 0 failed / 11923 assertions
Windows proof PCK parsed_json=13
Android Validation preset proof PCK parsed_json=13
review threads 0
```

No gameplay/scoring/map/ruleset/save authority was widened. Product PNGs and semantic manifests were not rewritten.

## Current execution boundary

The first Phase C RED step is historical execution evidence, not the next action. `SX-DEC-055` is merged.

Next acceptance sequence:

```text
post-merge canon + Sheet same-ID reconciliation
→ assign exact acceptance build when physical validation is prepared
→ Windows physical runtime/visual/audio/input smoke
→ Android device smoke
→ physical Reduced Motion/readability
→ Five-person comprehension on exact acceptance build
→ separate production cutover decision
```

`SX-DEC-056A/057/058` detailed planning does not inherit `SX-DEC-055` implementation authority. `SX-DEC-056B` and 057 fast/cheap content remain blocked by missing authoritative runtime capabilities.

## Benchmark-derived planning status

```text
BMK-R01~R08 → approved and detailed planning closed through SX-AUD-051/052/053
BMK-R09 Shareable Route Card → POST_VALIDATION_HOLD · NO_DECISION_ID
BMK-R10 Editor/UGC → POST_VALIDATION_HOLD · NO_DECISION_ID
```

## Historical product exclusions

Do not reactivate endless survival, fuel/fuel-zero, BOOST, cargo capacity 8, cargo-count slowdown, pickup respawn, or switch auto-reset. Current product authority remains GMB-002.
