# Current Confirmed Decisions

Last updated: `2026-08-09 KST`

This file is the compact current-status registry for the finite delivery puzzle. Detailed rule text, implementation evidence, provenance, and audit reasoning remain in each registered owner document and the configured Google Sheet. This refresh is the bounded `SX-AUD-035` authority repair; it does not create a new product decision or widen any runtime claim.

```yaml
current_product_baseline: FINITE_DELIVERY_PUZZLE_BASELINE
current_decision_span: SX-DEC-027~053
superseded_decision: SX-DEC-047 -> SX-DEC-048
authority_snapshot_through_main: 9db05c0cc9866eb3e4a7f014a1cfe289aa4447bd
authority_refresh_audit: SX-AUD-035
latest_visual_asset_authority: SX-DEC-053
latest_tooling_authority: SX-DEC-052
latest_visual_asset_audit: SX-AUD-040
base_reference_at_refresh: 2a6ced23f6d6de1fb6e0a281c7138beb03f1a13b
current_android_evidence: EV-FP-APK-001
correct_sheet: 1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo
wrong_sheet: 19Ff... · DO_NOT_MODIFY
product_runtime_state: FINITE_CORE_AUTOMATED_PASS · ROUTE_END_USER_CURRENT_MAIN_F5_PASS · SWITCH_DIRECTION_USER_CURRENT_MAIN_F5_PASS · CARGO_PICKUP_RETRY_USER_F5_PASS · FULL_PC_MANUAL_GATE_NOT_CLOSED
visual_asset_state: ED_HYBRID_FINAL_DIRECTION · 31_IMPORT_SAFE_PRODUCT_ASSETS · RUNTIME_POC_DEFERRED · SEMANTIC_SPLITS_PENDING
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
| SX-DEC-037 | PC Vertical Slice | F5 one-click Title→Briefing→BUILD→RUN→Result 제품형 데모 | IMPLEMENTED · AUTOMATED_CORE_PASS · FULL_PC_LOCAL_FLOW_NOT_CLOSED |
| SX-DEC-038 | Demo Route Refinement | 15×11 대표 맵·권장 배치·열린 종착·운행 중 경로 전환·한쪽 연결 역 | IMPLEMENTED · AUTOMATED_ROUTE/PARITY_PASS · REMAINING_PHYSICAL_GATES_OPEN |
| SX-DEC-039 | Mid-Run Exit | BUILD/RUN 메뉴→pause/확인→타이틀 복귀, 취소 시 동일 플레이 유지 | IMPLEMENTED · TITLE_EXIT_USER_LOCAL_PASS · FULL_BUILD/RUN_FLOW_RETEST_REQUIRED |
| SX-DEC-040 | Station Color Parity | cargo color와 무관하게 reciprocal 이웃 1개 이상인 역을 같은 한쪽 연결 종착역 규칙으로 판정 | CURRENT · AUTOMATED_PARITY_PASS |
| SX-DEC-041 | Route-End Failure | 접촉·하역 뒤 이동 불가면 FAILURE/ROUTE_END, 마지막 필수 배송 SUCCESS 우선 | MERGED_MAIN_VERIFIED · AUTOMATED_PASS · USER_CURRENT_MAIN_F5_PASS |
| SX-DEC-042 | Switch Direction Arrows | reciprocal 세 방향 표시·직접 선택·진입 방향 U턴·점유 잠금 | MERGED_MAIN_VERIFIED · AUTOMATED_PASS · USER_CURRENT_MAIN_F5_PASS |
| SX-DEC-043 | v4.3 Entry Gate | 작업 전 Decision Ledger·미확정 목록·Sheet·merged main을 증거로 재판정 | APPROVED_GOVERNANCE · ORIGINAL_ENTRY_BLOCK_IS_HISTORICAL |
| SX-DEC-044 | GUT 9.7.1 Formal Authority | GUT 9.7.1을 정식 RED/GREEN/JUnit 테스트 권위로 사용 | MERGED_MAIN_VERIFIED · CURRENT_TEST_AUTHORITY |
| SX-DEC-045 | Single Godot Authoring Authority | Scene·Node·Resource·Theme·Animation·signal wiring·project settings는 단일 Godot authoring authority 경계로 관리 | APPROVED_AUTHORITY_BOUNDARY · CURRENT_TOOL_VERSION_RECONCILED_BY_SX-DEC-052 · CONNECTED_PHYSICAL_AUTHORING_NOT_RUN |
| SX-DEC-046 | Focused Visual/Audio Component | RouteControlOverlay 절차 화살표를 안전 확장, 새 binary visual/audio 불필요 | MERGED_MAIN_VERIFIED · PROCEDURAL_COMPONENT_AUTOMATED_PASS · USER_CURRENT_MAIN_F5_PASS · NO_NEW_BINARY_ASSET |
| SX-DEC-047 | Validation Execution Fallback | Windows/WSL local exact-HEAD fallback 제안 | SUPERSEDED_NOT_MERGED_BY_SX-DEC-048 |
| SX-DEC-048 | Standard Hosted Actions Authority | 공개 저장소의 표준 GitHub-hosted runner를 exact-HEAD 검증 권위로 사용 | MERGED_MAIN_VERIFIED · CURRENT_VALIDATION_EXECUTION_AUTHORITY |
| SX-DEC-049 | Cargo Pickup Marker Visibility | 적재한 맵 화물 마커는 즉시 숨기고 Retry/새 실행에서 원위치 복원 | MERGED_MAIN_VERIFIED · AUTOMATED_EXACT_HEAD_PASS · USER_PHYSICAL_F5_PICKUP_RETRY_PASS |
| SX-DEC-050 | Finite Visual Planning Package | VIS-FINITE-01/02/03 요구사항·컴포넌트·탐색 패키지를 runtime보다 먼저 확정 | PLANNING_PACKAGE_MERGED · RUNTIME_POC_DEFERRED |
| SX-DEC-051 | E+D Hybrid Production Asset Pack | 31개 production-candidate와 provenance/P0 역할 범위를 추적 | MERGED_MAIN_VERIFIED · 31_CANDIDATES · PROVENANCE_SOURCE_FOR_SX-DEC-053 · NOT_RUNTIME_INTEGRATED |
| SX-DEC-052 | Local Tooling & Asset-Vault Reconciliation | Godot AI 3.1.3·GUT 9.7.1·Hera v1.0.0 tracked authority와 local-only vault를 비파괴 정합화 | MERGED_MAIN_VERIFIED · HEADLESS_COMPAT_PASS · PILOT_ADOPTION_RECONCILED · VAULT_UNTRACK_DEFERRED |
| SX-DEC-053 | Final E+D Production Visual Direction | E+D HYBRID 최종 방향, 파란 기관차 hero, 뒤 화물칸 0.74 비율, 31개 import-safe product asset | MERGED_MAIN_VERIFIED · DISPOSITION_31_COMPLETE · IMPORT_SAFE_31_PROMOTED · RUNTIME_POC_DEFERRED |

## Current Runtime Evidence Boundary

Current evidence must remain feature-scoped.

Confirmed user/local evidence recorded in the configured Sheet:

- `SX-DEC-041`: current-main Godot 4.7.1 F5 — BLUE no-cargo route end resolves `FAILURE/ROUTE_END` without the old assertion/process termination; final required delivery keeps SUCCESS priority.
- `SX-DEC-042` / `SX-DEC-046`: current-main Godot 4.7.1 F5 — three direction arrows visible, direct selection PASS, incoming-direction U-turn PASS, occupied-switch lock PASS.
- `SX-DEC-049`: user F5 pickup/retry scenarios 3/3 PASS; the feature-specific physical gate is closed.
- `SX-DEC-039`: title exit visibility has user-local PASS, but the complete BUILD/RUN cancel/confirm preservation flow is not promoted to full manual PASS here.

Historical `SX-AUD-033` recorded a stale-local failure fingerprint before the later current-main F5 evidence above. The dedicated GitHub audit file remains historical evidence; this `SX-AUD-035` refresh records the later same-ID Sheet evidence rather than inventing a nonexistent replacement PR or rewriting the historical observation.

Still not validated as physical/user completion:

```text
Windows exported artifact physical runtime / visual / audio / physical input: NOT_RUN
Android landscape device smoke: NOT_RUN
Connected physical Godot/Hera authoring session: NOT_RUN
Broader human / five-person comprehension: NOT_RUN
Production cutover: BLOCKED_DEFERRED
```

A hosted Windows Demo Export PASS is build/package evidence only and is not physical Windows runtime evidence.

## Current Visual Asset Authority

`SX-DEC-053` is the latest final visual/product-asset authority; `SX-DEC-051` remains its immutable provenance source.

```yaml
direction: E+D HYBRID · NEO-ARCADE READABILITY
source_candidates: 31
source_dispositions:
  PROMOTE_AS_IS: 18
  PROMOTE_AFTER_REVISION: 11
  REPLACE: 2
product_assets: 31
blue_locomotive: HERO_ANCHOR
trailing_wagons_visual_scale: 0.74
runtime_integrated: false
```

Pending semantic product splits are explicitly not complete:

- stack HUD, including next-unload-group state;
- remaining selected switch directions;
- train cargo strip after smaller-wagon hierarchy reconciliation;
- load-mode on/off semantics;
- BUILD placement / palette / preflight full state split;
- causal VFX state split.

After those bounded asset semantics are complete, runtime integration/POC remains a separate later gate.

## Current Tooling Authority

`SX-DEC-052` is the current tooling reconciliation authority.

```yaml
Godot_AI: 3.1.3 · TRACKED/SYNCED
GUT: 9.7.1 · TRACKED/PRESERVED
Hera: v1.0.0 provenance base · TRACKED/ENABLED/USER_ADOPTED
Hera_headless_compat: PASS
Godot_live_editor_pilot_reconciliation: PASS_AUTOMATED
connected_physical_editor_validation: NOT_RUN
legacy_asset_vault_tracked_paths: 14 · PRESERVED
asset_vault_untrack: DEFERRED_PENDING_LOCAL_HASH_VERIFIED_PRESERVATION
```

The tooling decision does not authorize gameplay changes or treat automated Pilot/headless checks as a connected physical-editor PASS.

## Latest Delivery Anchors

```yaml
route_end_and_switch_product_merge:
  pr: 106
  sha: 12d1ef9b5c49e401d32dfc283db11a12574b5da3
cargo_pickup_visibility:
  feature_pr: 110
  physical_closure_pr: 111
  closure_main: cb6b69360f4ba865cd103573d2a2c22d5c16a1cd
finite_visual_planning:
  pr: 112
  merge_main: 827c5b9ffe2a9170ec099083cdd2a2c22d5c16a1cd
production_candidates:
  pr: 113
  closure_pr: 114
  closure_main: 60f7834659b026494fa927c1b5aa5c9c41a2e489
local_tooling_and_hera:
  product_recovery_pr: 119
  pilot_reconciliation_pr: 120
  closure_pr: 121
  closure_main: 95dda145b518ce29bead78a5cbf5566cfa675419
final_product_assets:
  product_pr: 122
  product_merge: 57dbdd9be2cc70e0c9b973d502f57bd725b045cb
  closure_pr: 123
  closure_main: 9db05c0cc9866eb3e4a7f014a1cfe289aa4447bd
```

These anchors identify delivery history. Individual technical PASS claims remain bounded by their exact-head workflow evidence in the corresponding decision/audit documents.

## Canonical Android Evidence

The earlier canonical Android validation artifact remains preserved as build/export evidence:

```yaml
source_commit: 536911449018a3caf3511bc64e7bf1a66edf2016
workflow_run_id: 31011620357
apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
package_id: com.alsdmlals4.switchyexpress.validation
```

This does not close the current Android landscape device-smoke gate. PC entrypoint evidence and Android validation evidence remain separate.

## Preserved Decisions

- `SX-DEC-001`: 정식 제목 `Switchy Express: Cargo Puzzle`
- `SX-DEC-008`: LIFO와 TOP 연속 동일 종류 그룹 하역
- `SX-DEC-011`: 프리미엄 캐주얼 3D 카툰·토끼 기관사
- `SX-DEC-012`: Godot 4.7.1·GDScript·PC/Android 가로형
- `SX-DEC-014`: 한 역 도착의 연속 동일 화물 하역 수가 Combo
- `SX-DEC-015`: rear/TOP을 읽는 compact token 의미
- `SX-DEC-019`: cosmetic-only 공정성
- `SX-DEC-023`: 같은 조건 재도전과 immutable identity

## Historical Boundary

무한 생존, fuel, BOOST, capacity 8, cargo slowdown, pickup respawn, switch auto-reset은 현재 finite puzzle 제품 권위가 아니다.

`SX-DEC-047`은 승인 이력이 있으나 `SX-DEC-048`에 의해 superseded 되었고 main에 병합되지 않았다.

## Current Execution Authority

```text
1. SX-DEC-053의 남은 semantic asset splits를 승인된 범위 안에서 완결한다.
2. 그 후 별도 runtime integration / POC gate로 이동한다.
3. Windows physical runtime / visual / audio / physical input smoke를 별도 검증한다.
4. Android landscape device smoke를 별도 검증한다.
5. broader human / comprehension validation을 별도 수행한다.
6. .asset-vault legacy untrack은 local hash-verified preservation attestation 이후 별도 실행한다.
```

수동·물리 증거가 없는 Gate를 자동 테스트로 PASS로 확대하지 않는다. 새 gameplay/product 방향이 필요해지는 순간에는 새 사용자 결정이 선행되어야 한다.
