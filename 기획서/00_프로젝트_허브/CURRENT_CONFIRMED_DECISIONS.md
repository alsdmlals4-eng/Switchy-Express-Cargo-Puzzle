# Current Confirmed Decisions

Last updated: `2026-08-10 KST`

This is the compact current-status registry for the finite delivery puzzle. Detailed rule text, provenance, CI evidence, and audit reasoning remain in each registered owner document and the configured Google Sheet. `SX-AUD-035` remains the bounded registry-authority repair. This refresh records `SX-DEC-054` RUN Batch 2A, BUILD Batch 2B, and VFX Batch 2C as merged-main verified without widening runtime or physical-validation claims.

```yaml
current_product_baseline: FINITE_DELIVERY_PUZZLE_BASELINE
current_decision_span: SX-DEC-027~054
superseded_decision: SX-DEC-047 -> SX-DEC-048
authority_snapshot_through_product_main: 13db4ddd991bdb3162884c1b85fdc3d20e3eee8a
authority_refresh_audit: SX-AUD-035
latest_visual_asset_authority: SX-DEC-053
latest_visual_semantic_strategy: SX-DEC-054
latest_visual_asset_audit: SX-AUD-043
latest_tooling_authority: SX-DEC-052
base_reference_at_refresh: 2a6ced23f6d6de1fb6e0a281c7138beb03f1a13b
correct_sheet: 1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo
product_runtime_state: FINITE_CORE_AUTOMATED_PASS · ROUTE_END_USER_CURRENT_MAIN_F5_PASS · SWITCH_DIRECTION_USER_CURRENT_MAIN_F5_PASS · CARGO_PICKUP_RETRY_USER_F5_PASS · FULL_PC_MANUAL_GATE_NOT_CLOSED
visual_asset_state: ED_HYBRID_FINAL_DIRECTION · SX-DEC-053_39_PRODUCT_ASSETS · SX-DEC-054_RUN_2A_20 · SX-DEC-054_BUILD_2B_8 · SX-DEC-054_VFX_2C_6 · 73_TOTAL_PRODUCT_PNGS · SEMANTIC_ASSET_PRODUCTION_COMPLETE · RUNTIME_POC_DEFERRED
tooling_state: GODOT_AI_3_1_3_SYNCED · GUT_9_7_1_PRESERVED · HERA_TRACKED_V1_0_0_USER_ADOPTED · CONNECTED_PHYSICAL_EDITOR_NOT_RUN
asset_vault_state: LEGACY_14_TRACKED_PRESERVED · UNTRACK_DEFERRED_PENDING_LOCAL_PRESERVATION_ATTESTATION
physical_validation_ceiling: WINDOWS_PHYSICAL_RUNTIME_NOT_RUN · ANDROID_DEVICE_NOT_RUN · CONNECTED_PHYSICAL_EDITOR_NOT_RUN · BROADER_HUMAN_NOT_RUN
production_cutover: BLOCKED_DEFERRED
```

## Current Core Fun Authority

```text
선로 건설로 화물 조우 순서 설계
→ 수동/자동 적재로 LIFO 스택 구성
→ 운행 중 분기·교차 경로 전환
→ 연결된 모든 분기 방향을 화살표로 확인하고 필요 시 진입 방향으로 U턴
→ TOP 연속 동일 화물 하역
→ 제한 시간 안에 모든 필수 배송 완료
→ 사용하지 않는 열린 노선 끝과 색상 대칭 한쪽 연결 종착역 허용
→ 배송 완료 전 이동 불가 시 ROUTE_END 게임 오버
→ 필요 시 메뉴에서 현재 플레이를 안전하게 종료
→ 결과를 보고 같은 조건 재도전 또는 후속 재설계
```

The hard constraints remain LIFO, cargo/station color+shape readability, save/ruleset compatibility discipline, and no unapproved core-product widening.

## Current Decision Registry

| Decision ID | 분야 | 현재 결정 / 권위 | 현재 상태 |
|---|---|---|---|
| SX-DEC-027 | 제품 핵심 | 제한 시간 안에 모든 고정 화물을 배송하는 유한 수작업 퍼즐 | CURRENT · PASS |
| SX-DEC-028 | 건설 | 자유 선로 건설·비용·전액 환급·추천 비용 | CURRENT · PASS |
| SX-DEC-029 | 운행·판정 | 구조 검사·제한 시간·성공/실패·pause | CURRENT · PASS |
| SX-DEC-030 | 선로 | 직선·곡선·분기·교차 | CURRENT · PASS |
| SX-DEC-031 | 적재·LIFO | 수동 hold·auto toggle·무제한 stack·TOP 그룹 하역 | CURRENT · PASS |
| SX-DEC-032 | Combo | 하역 그룹과 최대 1초 표시 | CURRENT · PASS |
| SX-DEC-033 | 별·랭킹 | 신속·절약·점수 별과 leaderboard | APPROVED · NOT_STARTED |
| SX-DEC-034 | 캠페인 | tutorial·theme chapter | APPROVED · NOT_STARTED |
| SX-DEC-035 | 반복 도전 | 일일·주간 fixed-seed challenge | APPROVED · NOT_RUN |
| SX-DEC-036 | 공정성 | cosmetic-only, power progression·타인 route 공개 금지 | CURRENT |
| SX-DEC-037 | PC Vertical Slice | F5 one-click Title→Briefing→BUILD→RUN→Result | IMPLEMENTED · AUTOMATED_CORE_PASS · FULL_PC_LOCAL_FLOW_NOT_CLOSED |
| SX-DEC-038 | Demo Route Refinement | 15×11 대표 맵·권장 배치·열린 종착·운행 중 경로 전환·한쪽 연결 역 | IMPLEMENTED · AUTOMATED_ROUTE/PARITY_PASS · REMAINING_PHYSICAL_GATES_OPEN |
| SX-DEC-039 | Mid-Run Exit | BUILD/RUN 메뉴→pause/확인→타이틀 복귀, 취소 시 동일 플레이 유지 | IMPLEMENTED · TITLE_EXIT_USER_LOCAL_PASS · FULL_BUILD/RUN_FLOW_RETEST_REQUIRED |
| SX-DEC-040 | Station Color Parity | reciprocal 이웃 1개 이상 역의 한쪽 연결 종착 규칙 | CURRENT · AUTOMATED_PARITY_PASS |
| SX-DEC-041 | Route-End Failure | 이동 불가면 FAILURE/ROUTE_END, 마지막 필수 배송 SUCCESS 우선 | MERGED_MAIN_VERIFIED · AUTOMATED_PASS · USER_CURRENT_MAIN_F5_PASS |
| SX-DEC-042 | Switch Direction Arrows | reciprocal 세 방향 표시·직접 선택·진입 방향 U턴·점유 잠금 | MERGED_MAIN_VERIFIED · AUTOMATED_PASS · USER_CURRENT_MAIN_F5_PASS |
| SX-DEC-043 | v4.3 Entry Gate | 작업 전 Decision Ledger·미확정 목록·Sheet·merged main 재판정 | APPROVED_GOVERNANCE |
| SX-DEC-044 | GUT 9.7.1 Formal Authority | GUT 9.7.1 정식 RED/GREEN/JUnit 권위 | MERGED_MAIN_VERIFIED · CURRENT_TEST_AUTHORITY |
| SX-DEC-045 | Single Godot Authoring Authority | Scene·Node·Resource·Theme·Animation·signal wiring·project settings 단일 Godot authoring 경계 | APPROVED_AUTHORITY_BOUNDARY · CONNECTED_PHYSICAL_AUTHORING_NOT_RUN |
| SX-DEC-046 | Focused Visual/Audio Component | RouteControlOverlay 절차 화살표 안전 확장 | MERGED_MAIN_VERIFIED · USER_CURRENT_MAIN_F5_PASS · NO_NEW_BINARY_ASSET |
| SX-DEC-047 | Validation Execution Fallback | Windows/WSL local exact-HEAD fallback 제안 | SUPERSEDED_NOT_MERGED_BY_SX-DEC-048 |
| SX-DEC-048 | Standard Hosted Actions Authority | 표준 GitHub-hosted runner exact-HEAD 검증 권위 | MERGED_MAIN_VERIFIED · CURRENT_VALIDATION_EXECUTION_AUTHORITY |
| SX-DEC-049 | Cargo Pickup Marker Visibility | 적재 화물 마커 즉시 숨김, Retry/새 실행 복원 | MERGED_MAIN_VERIFIED · USER_PHYSICAL_F5_PICKUP_RETRY_PASS |
| SX-DEC-050 | Finite Visual Planning Package | VIS-FINITE-01/02/03 요구사항·컴포넌트·탐색 패키지 | PLANNING_PACKAGE_MERGED · RUNTIME_POC_DEFERRED |
| SX-DEC-051 | E+D Hybrid Production Asset Pack | 31 production-candidate + provenance/P0 범위 | MERGED_MAIN_VERIFIED · 31_CANDIDATES · NOT_RUNTIME_INTEGRATED |
| SX-DEC-052 | Local Tooling & Asset-Vault Reconciliation | Godot AI 3.1.3·GUT 9.7.1·Hera v1.0.0 정합화 | MERGED_MAIN_VERIFIED · VAULT_UNTRACK_DEFERRED |
| SX-DEC-053 | Final E+D Production Visual Direction | E+D HYBRID 최종 방향, blue hero, wagon 0.74, 39 import-safe assets, authoritative slice batch 1 | MERGED_MAIN_VERIFIED · 39_PRODUCT_ASSETS · 8_AUTHORITATIVE_SLICES · RUNTIME_POC_DEFERRED |
| SX-DEC-054 | Semantic Asset Completion Strategy | ambiguous atlas는 provenance로 보존하고 승인 component-state 계약으로 독립 semantic assets 완성 | MERGED_MAIN_VERIFIED · RUN_2A_20 + BUILD_2B_8 + VFX_2C_6 · 73_TOTAL_PRODUCT_PNGS · SEMANTIC_ASSET_PRODUCTION_COMPLETE · RUNTIME_POC_DEFERRED |

## Current Visual Asset Authority

```yaml
direction: E+D HYBRID · NEO-ARCADE READABILITY
source_candidates: 31
sx_dec_053_product_assets: 39
sx_dec_054_run_2a_semantic_assets: 20
sx_dec_054_build_2b_semantic_assets: 8
sx_dec_054_vfx_2c_semantic_assets: 6
product_assets_total: 73
sx_dec_054_build_2b_compositions: 28
sx_dec_054_vfx_2c_events: 8
sx_dec_054_vfx_2c_compositions: 16
sx_dec_054_vfx_reduced_motion_pairs: 8
track_palette_new_form_state_pngs: 0
authoritative_slice_batch_1: 8
blue_locomotive: HERO_ANCHOR
trailing_wagons_visual_scale: 0.74
semantic_split_state: RUN_2A_COMPLETE · BUILD_2B_COMPLETE · VFX_2C_COMPLETE
semantic_completion_strategy: SX-DEC-054 · SEMANTIC_FIRST_INDEPENDENT_ASSETS
semantic_implementation_state: RUN_2A_BUILD_2B_VFX_2C_MERGED_MAIN_VERIFIED
runtime_integrated: false
```

Completed RUN Batch 2A:
- Stack HUD remainder;
- train cargo strip compositions;
- load-mode compositions;
- switch state presentation while procedural direction authority remains unchanged.

Completed BUILD Batch 2B:
- placement `valid`, `invalid`, `rotate_preview`, `replacement_preview`;
- track palette 4 forms × 5 interaction states as 20 compositions using existing rails/UI frames;
- preflight `clear`, `primary_issue`, `multi_issue_summary`, `focused_location`;
- dedicated BUILD sidecar preserves RUN sidecar ownership;
- unnamed placement/track-palette atlas regions remain non-authoritative.

Completed VFX Batch 2C:
- 8 events: pickup, unload, combo, route selection, success, failure, ROUTE_END, TIME_EXPIRED;
- 6 new independent glyph PNGs plus exact combo/route-selection product reuse;
- 16 standard/reduced semantic compositions;
- 8 Reduced Motion information-equivalent pairs;
- historical unnamed VFX atlas remains reference-only/no-state-mapping;
- runtime animation/Scene/Resource authoring remains deferred.

## Current Runtime Evidence Boundary

Confirmed user/local evidence remains feature-scoped:
- `SX-DEC-041`: current-main F5 ROUTE_END behavior PASS;
- `SX-DEC-042` / `SX-DEC-046`: current-main F5 switch direction/select/U-turn/occupied-lock PASS;
- `SX-DEC-049`: user F5 pickup/retry 3/3 PASS;
- `SX-DEC-039`: title-exit visibility user-local PASS, full cancel/confirm flow not promoted to complete manual PASS.

Still not validated as physical/user completion:

```text
Windows exported artifact physical runtime / visual / audio / physical input: NOT_RUN
Android landscape device smoke: NOT_RUN
Connected physical Godot/Hera authoring session: NOT_RUN
Broader human / comprehension: NOT_RUN
Production cutover: BLOCKED_DEFERRED
```

Hosted Windows Demo Export PASS is build/package evidence only, not physical Windows runtime evidence.

## Latest Delivery Anchors

```yaml
final_product_assets:
  product_pr: 122
  product_merge: 57dbdd9be2cc70e0c9b973d502f57bd725b045cb
  closure_pr: 123
  closure_main: 9db05c0cc9866eb3e4a7f014a1cfe289aa4447bd
semantic_run_batch_2a:
  product_pr: 129
  exact_review_head: 34ab2b907190f69775ace8e89c32f689ba17bc35
  product_merge: 35b93f3a15f35780b12cd4e8887c8e06f8ade72b
  closure_pr: 130
  closure_main: fb229b2ef522fb29c70f43787549fb2e20bf89b0
  audit: SX-AUD-041
semantic_build_batch_2b:
  product_pr: 131
  exact_review_head: 6efe4c71e88799f886f136c98d0c4a4396e58808
  product_merge: 77276ec9b60aa91afd13f994ded8e0925e68be08
  audit: SX-AUD-042
semantic_vfx_batch_2c:
  product_pr: 133
  exact_review_head: 603a1a0330d651b4d7068487c17e88ef1657a009
  product_merge: 13db4ddd991bdb3162884c1b85fdc3d20e3eee8a
  contract_run: 31345334561
  gut_run: 31345334543
  godot_run: 31345334535
  thin_run: 31345334542
  windows_export_run: 31345334553
  audit: SX-AUD-043
```

The docs-only closure merge SHA is intentionally not self-referenced before merge. Record the actual closure PR and merge SHA in the configured Sheet after GitHub readback.

## Current Execution Authority

```text
1. SX-DEC-054 semantic asset production is complete at 73 physical product PNGs.
2. legacy atlas unnamed regions remain non-authoritative.
3. Reduced Motion meaning equivalence is statically defined for all 8 VFX events.
4. Do not auto-cross into Godot runtime integration / POC from SX-DEC-054 alone.
5. The next work package requires a separate runtime integration / POC gate.
6. Windows physical runtime, Android landscape device, connected editor, broader human validation remain separate.
7. `.asset-vault` untrack remains deferred until local hash-verified preservation attestation.
```

수동·물리 증거가 없는 Gate를 자동 테스트로 PASS로 확대하지 않는다. 새 gameplay/product 방향이 필요해지는 순간에는 새 사용자 결정이 선행되어야 한다.