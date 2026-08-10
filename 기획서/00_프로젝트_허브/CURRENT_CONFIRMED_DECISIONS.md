# Current Confirmed Decisions

Last updated: `2026-08-10 KST`

This is the compact current-status registry for the finite delivery puzzle. Detailed rule text, provenance, CI evidence, and audit reasoning remain in each registered owner document and the configured Google Sheet. `SX-AUD-035` remains the bounded registry-authority repair mechanism. This refresh records the user-approved and merged `SX-DEC-055` runtime semantic POC spec without claiming that Godot runtime implementation has started or completed.

```yaml
current_product_baseline: FINITE_DELIVERY_PUZZLE_BASELINE
current_decision_span: SX-DEC-027~055
superseded_decision: SX-DEC-047 -> SX-DEC-048
authority_snapshot_through_main: 34624a5d2a93306cd2b3c72dee6ce0035b751279
authority_refresh_audit: SX-AUD-035
latest_visual_asset_authority: SX-DEC-053
latest_visual_semantic_strategy: SX-DEC-054
latest_runtime_semantic_poc_authority: SX-DEC-055
latest_visual_asset_audit: SX-AUD-043
latest_tooling_authority: SX-DEC-052
project_base_pin: 9.4.3
upstream_base_observed_at_refresh: 53e63f7ebefbb5b2fc0dc528e335252692801421
correct_sheet: 1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo
product_runtime_state: FINITE_CORE_AUTOMATED_PASS · ROUTE_END_USER_CURRENT_MAIN_F5_PASS · SWITCH_DIRECTION_USER_CURRENT_MAIN_F5_PASS · CARGO_PICKUP_RETRY_USER_F5_PASS · FULL_PC_MANUAL_GATE_NOT_CLOSED
visual_asset_state: ED_HYBRID_FINAL_DIRECTION · SX-DEC-053_39_PRODUCT_ASSETS · SX-DEC-054_RUN_2A_20 · SX-DEC-054_BUILD_2B_8 · SX-DEC-054_VFX_2C_6 · 73_TOTAL_PRODUCT_PNGS · SEMANTIC_ASSET_PRODUCTION_COMPLETE · SX-DEC-055_RUNTIME_POC_SPEC_APPROVED · IMPLEMENTATION_NOT_STARTED
tooling_state: GODOT_AI_3_1_3_SYNCED · GUT_9_7_1_PRESERVED · HERA_TRACKED_V1_0_0_USER_ADOPTED · CONNECTED_PHYSICAL_EDITOR_NOT_RUN
asset_vault_state: LEGACY_14_TRACKED_PRESERVED · UNTRACK_DEFERRED_PENDING_LOCAL_PRESERVATION_ATTESTATION
physical_validation_ceiling: WINDOWS_PHYSICAL_RUNTIME_NOT_RUN · ANDROID_DEVICE_NOT_RUN · CONNECTED_PHYSICAL_EDITOR_NOT_RUN · BROADER_HUMAN_NOT_RUN
production_cutover: BLOCKED_DEFERRED
```

The project remains pinned to Base v9.4.3 under `AGENTS.md`. The newer upstream Base readback is observation/reference evidence only and is not an implicit Base upgrade.

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

Hard constraints remain LIFO, cargo/station color+shape readability, save/ruleset compatibility discipline, and no unapproved core-product widening.

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
| SX-DEC-050 | Finite Visual Planning Package | VIS-FINITE-01/02/03 요구사항·컴포넌트·탐색 패키지 | PLANNING_PACKAGE_MERGED · RUNTIME_CONSUMPTION_GOVERNED_BY_SX-DEC-055 |
| SX-DEC-051 | E+D Hybrid Production Asset Pack | 31 production-candidate + provenance/P0 범위 | MERGED_MAIN_VERIFIED · 31_CANDIDATES · NOT_RUNTIME_INTEGRATED |
| SX-DEC-052 | Local Tooling & Asset-Vault Reconciliation | Godot AI 3.1.3·GUT 9.7.1·Hera v1.0.0 정합화 | MERGED_MAIN_VERIFIED · VAULT_UNTRACK_DEFERRED |
| SX-DEC-053 | Final E+D Production Visual Direction | E+D HYBRID 최종 방향, blue hero, wagon 0.74, 39 import-safe assets, authoritative slice batch 1 | MERGED_MAIN_VERIFIED · 39_PRODUCT_ASSETS · 8_AUTHORITATIVE_SLICES · RUNTIME_CONSUMPTION_GOVERNED_BY_SX-DEC-055 |
| SX-DEC-054 | Semantic Asset Completion Strategy | ambiguous atlas는 provenance로 보존하고 승인 component-state 계약으로 독립 semantic assets 완성 | MERGED_MAIN_VERIFIED · RUN_2A_20 + BUILD_2B_8 + VFX_2C_6 · 73_TOTAL_PRODUCT_PNGS · SEMANTIC_ASSET_PRODUCTION_COMPLETE |
| SX-DEC-055 | Runtime Semantic POC | manifest-backed thin presentation adapter로 대표 RUN/BUILD/route/VFX semantic runtime 소비를 검증하며 domain 규칙은 변경하지 않음 | USER_APPROVED · SPEC_APPROVED · DOCS_MERGED_MAIN_VERIFIED · GODOT_IMPLEMENTATION_NOT_STARTED · RED_FIRST_DOR_PLAN_AUTHORED |

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
authoritative_slice_batch_1: 8
blue_locomotive: HERO_ANCHOR
trailing_wagons_visual_scale: 0.74
semantic_split_state: RUN_2A_COMPLETE · BUILD_2B_COMPLETE · VFX_2C_COMPLETE
semantic_completion_strategy: SX-DEC-054 · SEMANTIC_FIRST_INDEPENDENT_ASSETS
semantic_implementation_state: RUN_2A_BUILD_2B_VFX_2C_MERGED_MAIN_VERIFIED
runtime_poc_authority: SX-DEC-055 · RUNTIME_SEMANTIC_POC_ONLY
runtime_poc_spec_state: USER_APPROVED · SPEC_APPROVED · DOCS_MERGED_MAIN_VERIFIED
runtime_integrated: false
```

Completed semantic production remains unchanged:
- RUN 2A: Stack remainder, train cargo strip compositions, load-mode compositions, and switch-state presentation primitives;
- BUILD 2B: four placement states, 4×5 track-palette compositions, four preflight states;
- VFX 2C: eight events with standard/reduced information-equivalent pairs;
- legacy unnamed atlas regions remain reference-only/non-authoritative.

`SX-DEC-055` now authorizes a bounded runtime POC consuming this package. It does not retroactively change the historical `runtime_integrated=false` provenance recorded in SX-DEC-053/054 manifests and does not mean runtime implementation is already complete.

## SX-DEC-055 Runtime POC Boundary

Approved architecture:

```text
SX-DEC-053/054 manifests
→ presentation-owned SemanticAssetCatalog
→ existing presenter model / render snapshot / existing events
→ HUD + board + route + semantic event presentation
```

Approved representative proof:
- RUN Stack/load state from existing presentation/input state;
- BUILD placement/preflight from existing snapshot/model data;
- switch semantic reinforcement while procedural directions/cycle/hit/lock authority remains unchanged;
- pickup/unload/route-selection/terminal VFX from existing presentation seams;
- Reduced Motion uses the same information key/input with motion removed;
- combo asset resolves, but no new gameplay/domain signal may be invented solely to trigger it.

Implementation plan:
`docs/superpowers/plans/2026-08-10-sx-dec-055-runtime-semantic-poc.md`

Per `AGENTS.md`, actual Godot/GDScript/test modification is a Codex execution responsibility after the DoR is closed.

## Current Runtime Evidence Boundary

Confirmed user/local evidence remains feature-scoped:
- `SX-DEC-041`: current-main F5 ROUTE_END behavior PASS;
- `SX-DEC-042` / `SX-DEC-046`: current-main F5 switch direction/select/U-turn/occupied-lock PASS;
- `SX-DEC-049`: user F5 pickup/retry 3/3 PASS;
- `SX-DEC-039`: title-exit visibility user-local PASS, full cancel/confirm flow not promoted to complete manual PASS.

`SX-DEC-055` currently adds **spec/DoR authority only**. Godot runtime POC execution has not yet been run or merged.

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
semantic_run_batch_2a:
  product_pr: 129
  product_merge: 35b93f3a15f35780b12cd4e8887c8e06f8ade72b
  audit: SX-AUD-041
semantic_build_batch_2b:
  product_pr: 131
  product_merge: 77276ec9b60aa91afd13f994ded8e0925e68be08
  audit: SX-AUD-042
semantic_vfx_batch_2c:
  product_pr: 133
  product_merge: 13db4ddd991bdb3162884c1b85fdc3d20e3eee8a
  audit: SX-AUD-043
semantic_asset_closure:
  closure_pr: 134
  closure_main: bcbd98c7e39b10146b22389bebe81a8b7a0a7b13
runtime_semantic_poc_spec:
  decision: SX-DEC-055
  spec_pr: 135
  exact_approved_head: 383937ffe898d45b42d68cf21ef46d61981e4e09
  spec_merge_main: 34624a5d2a93306cd2b3c72dee6ce0035b751279
  project_contract_run: 31350446399
  gut_run: 31350446400
  godot_run: 31350446412
  thin_run: 31350446401
```

## Current Execution Authority

```text
1. SX-DEC-054 semantic asset production is complete at 73 physical product PNGs.
2. SX-DEC-055 separately authorizes a bounded manifest-backed runtime semantic POC; its spec is approved and merged.
3. The POC must be implemented from the RED-first exact-file plan and must preserve domain/gameplay authority.
4. No new gameplay/domain signal may be introduced solely for combo VFX; absent an existing presentation-readable seam, combo trigger remains deferred.
5. Historical semantic/product manifests stay immutable provenance records; do not flip their runtime_integrated field merely because a later POC consumes assets.
6. Windows physical runtime, Android landscape device, connected editor, and broader human validation remain separate gates.
7. `.asset-vault` untrack remains deferred until local hash-verified preservation attestation.
8. Actual Godot/GDScript/test changes execute through Codex after DoR per AGENTS.md.
```

수동·물리 증거가 없는 Gate를 자동 테스트로 PASS로 확대하지 않는다. 새 gameplay/product 방향이 필요해지는 순간에는 새 사용자 결정이 선행되어야 한다.
