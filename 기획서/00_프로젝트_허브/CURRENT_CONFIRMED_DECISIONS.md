# Current Confirmed Decisions

Last updated: `2026-08-03`

```yaml
product_baseline: 4e435a1a6d10ab146197671049da80709fd18c1f
latest_planning_decision_merge: 9b63421a5ab4d57adbfcf69d2b6e1bf8e3d17496
gmb001: CLOSED · SX-DEC-017~026 · 10/10
dor_audit: SX-AUD-005 · PASS · SYNCED
dor_merge: 82fd3eeb1915e6ceedb2f5330b27e903064d6eb5
vs03_01_audit: SX-AUD-006 · PASS · SYNCED
vs03_01_evidence: EV-VS03-01-001
vs03_01_merge: 43972d3d23e931af3dbc81ab9b1c7d942fffb201
vs03_01_closure: 9360eff0a97f48f2234fcaf35425f80e94fac445
core_fun_audit: SX-AUD-007 · PASS_WITH_FOLLOWUPS · SYNCED
core_fun_evidence: EV-USER-017~018
core_fun_merge: a9368617102420639cc2bb83ee2b0c45505958a6
core_fun_closure: 0aaa9005af9bca7560bc75b6fff3cd3f9f197a92
vs03_02_audit: SX-AUD-008 · PASS · MERGED_AND_VERIFIED · SHEET_READBACK_PASS
vs03_02_evidence: EV-VS03-02-001
vs03_02_merge: cfe6d5ca0c76942720c5c12ad5dc59aaa651b915
implementation_authority: VS03-03_ONLY
codex_state: READY_FOR_BUILD
product_implementation: IN_PROGRESS · VS03_01_AND_02_MERGED
headless_evidence: 19 cases · 7499 assertions · 0 failures
```

## Core Fun Authority

```text
LIFO 적재 순서 계획
→ 목적 역까지의 노선 선행 결정
→ 큰 그룹을 위한 위험·생존 판단
→ BOOST와 배송 속도의 전술적 시간 관리
→ 결과 학습·같은 조건 재도전
→ 기록·꾸미기·맵 발견·UGC
```

상세 위계: `기획서/10_경험/CORE_FUN_SYSTEM_HIERARCHY.md`.

## Decision Registry

| Decision ID | 분야 | 현재 결정 | 근거 | 상태 |
|---|---|---|---|---|
| SX-DEC-001 | 제품 | 정식 제목은 `Switchy Express: Cargo Puzzle`이다. | 사용자 승인 | CONFIRMED · SYNCED |
| SX-DEC-002 | 경험 | 무한 운행에서 오래 생존하고 최고 점수를 경쟁한다. | 사용자 승인 | CONFIRMED · SYNCED |
| SX-DEC-003 | 경험 | 자동 운행 중 `LOAD`, 분기기, `BOOST`를 조작한다. | 사용자 승인 | CONFIRMED · SYNCED |
| SX-DEC-004 | 맵 | 가로형 15×10 connected railway, 막다른길 없음. | 사용자 승인·PR #9 | CONFIRMED · SYNCED |
| SX-DEC-005 | 맵 | 2/3단계 분기기와 명확한 활성 방향 표시. | 사용자 승인·PR #9 | CONFIRMED · SYNCED |
| SX-DEC-006 | 콘텐츠 | 빨강·파랑·노랑 station을 색상별 2개 배치. | 사용자 승인·PR #12 | CONFIRMED · SYNCED |
| SX-DEC-007 | 콘텐츠 | 색상별 pickup 최소 4개, 적재 후 유효 위치 재생성. | 사용자 승인·PR #12/#13 | CONFIRMED · SYNCED |
| SX-DEC-008 | 시스템 | capacity 8 LIFO, top 연속 동일 색 그룹 하역. | 사용자 승인·PR #12 | CONFIRMED · SYNCED |
| SX-DEC-009 | 시스템 | 배송 점수·연료, 시간 증가 압력, 연료 0 종료. | 사용자 승인 | CONFIRMED · SYNCED · CORE_IMPLEMENTED |
| SX-DEC-010 | 시스템 | 화물 감속, BOOST 속도 증가·연료 추가 소모. | 사용자 승인 | CONFIRMED · SYNCED · CORE_IMPLEMENTED |
| SX-DEC-011 | 표현 | 둥근 프리미엄 캐주얼 3D 카툰과 토끼 기관사. | 사용자 승인 | CONFIRMED · SYNCED |
| SX-DEC-012 | 기술 | Godot 4.7.1/GDScript, Android, 가로형. | 프로젝트 기본값·PR #9 | CONFIRMED · SYNCED |
| SX-DEC-013 | 분기 UX | 기본 A는 가능하면 직진 우선, preview와 실제 next parity. | 사용자 승인·PR #9 | CONFIRMED · SYNCED |
| SX-DEC-014 | 점수 | Combo는 one-arrival unload-group size, speed bonus는 별도. | EV-USER-002 | CONFIRMED · SYNCED · IMPLEMENTED |
| SX-DEC-015 | 화차 UX | cargo 1개=compact token 1개, rear=LIFO top, compressed footprint. | EV-USER-003·EV-VS03-02-001 | CONFIRMED · SYNCED · DOMAIN_IMPLEMENTED |
| SX-DEC-016 | 첫 세션 | 실제 첫 run에서 LOAD→token→분기→LIFO→Combo→BOOST 학습. | EV-USER-004 | CONFIRMED · SYNCED |
| SX-DEC-017 | 결과 | 근거 있는 실패 원인 1개와 다음 행동 1개, 불확실하면 neutral fallback. | EV-USER-006 | CONFIRMED · SYNCED |
| SX-DEC-018 | 카메라 | first PREP 약한 확대, `FULL_MAP_READY` 뒤 run, active full map. | EV-USER-007 | CONFIRMED · SYNCED |
| SX-DEC-019 | 진행 | 표준 기록 3종과 gameplay power 없는 cosmetic collection/equip. | EV-USER-008 | CONFIRMED · SYNCED |
| SX-DEC-020 | 해금 | `DEFAULT / DUAL_PATH / CURRENCY_ONLY`, 구매는 goal 완료를 위조하지 않음. | EV-USER-009 | CONFIRMED · SYNCED |
| SX-DEC-021 | 보상 | 유효 일반 run의 bounded base·delivery·Combo·record cosmetic currency. | EV-USER-010 | CONFIRMED · SYNCED |
| SX-DEC-022 | 난이도 | authoritative prewarning와 `CALM/BUSY/INTENSE` persistent signal. | EV-USER-011 | CONFIRMED · SYNCED · CORE_PARTIAL_IMPLEMENTED |
| SX-DEC-023 | 재시작·맵 | exact same-map restart, 새 seed는 검증 official catalog 제작에 사용. | EV-USER-012 | CONFIRMED · SYNCED |
| SX-DEC-024 | 맵 선택 | `NEW RUN`은 미발견 official map 우선, 발견 map 직접 재선택. | EV-USER-013 | CONFIRMED · SYNCED |
| SX-DEC-025 | 기록·UGC | official global+per-map 기록, data-only immutable user-map publication. | EV-USER-014 | CONFIRMED · SYNCED |
| SX-DEC-026 | UGC community | favorite·verified play·1추천·report/block·staff pick, reward/rating/leaderboard 제외. | EV-USER-015 | CONFIRMED · SYNCED |
| SX-OPS-001 | 운영 | 승인 10건마다 freeze·감사·canonical merge·Sheet closure. | EV-USER-005 | CONFIRMED_OPERATION · GMB001_CLOSED |

## Audit and Execution Registry

| ID | 범위 | 근거 | 현재 상태 |
|---|---|---|---|
| SX-AUD-004 | 전체 기획 coverage·Decision 충돌 | EV-USER-002~015 | PASS · GMB001_CLOSED · RUNTIME_FOLLOWUPS |
| SX-AUD-005 | VS-03 Definition of Ready·실제 API/file/test/save/order/rollback | EV-USER-016 | PASS_WITH_PLANNING_FIXES · SYNCED |
| SX-AUD-006 | VS03-01 planning preflight·TDD·implementation·exact-head Gate | EV-VS03-01-001 | PASS · MERGED_AND_VERIFIED · SYNCED |
| SX-AUD-007 | core fun/system hierarchy·benchmark·package sequencing | EV-USER-017~018 | PASS_WITH_FOLLOWUPS · SYNCED · CLOSED |
| SX-AUD-008 | VS03-02 compact-token/footprint/occupancy TDD·implementation·exact-head Gate | EV-VS03-02-001 | PASS · MERGED_AND_VERIFIED · SHEET_READBACK_PASS |

`SX-AUD-008`은 새 player rule을 만들지 않는다. `SX-DEC-015`의 승인 의미를 실제 domain geometry와 spawn occupancy로 구현한다.

## Current Execution Authority

Canonical current-status and future-order documents:

```text
기획서/10_경험/CORE_FUN_SYSTEM_HIERARCHY.md
기획서/50_제작_검증/VS03_PACKAGE_STATUS.md
기획서/50_제작_검증/VS03_02_SYNC_CLOSURE.md
기획서/50_제작_검증/VS03_02_IMPLEMENTATION_AUDIT.md
기획서/50_제작_검증/CORE_FUN_ALIGNMENT_SYNC_CLOSURE.md
docs/superpowers/plans/2026-08-03-vs03-core-first-resegmentation.md
docs/superpowers/plans/2026-08-03-vs03-r1-difficulty-authority-alignment.md
docs/superpowers/plans/2026-08-03-vs03-05a-minimal-playable-core-surface.md
기획서/50_제작_검증/VS03_01_IMPLEMENTATION_AUDIT.md
기획서/50_제작_검증/VS03_DEFINITION_OF_READY_AUDIT.md
docs/superpowers/specs/2026-08-02-vs03-execution-architecture-design.md
docs/superpowers/plans/2026-08-02-vs03-build-segmentation.md
```

Older plans remain behavior and unchanged-package responsibility references. Old status/order is non-authoritative against current status and the approved core-first plan.

```text
VS03-01 · MERGED_AND_VERIFIED · SYNCED
→ VS03-02 · MERGED_AND_VERIFIED · SHEET_SYNCED
→ VS03-03 · READY_FOR_BUILD · CURRENT_AUTHORITY
→ VS03-R1 · BLOCKED_BY_VS03_03
→ VS03-05A · BLOCKED_BY_VS03_R1
→ VS03-04 · BLOCKED_BY_VS03_05A
→ VS03-05B · BLOCKED_BY_VS03_04
→ VS03-06 · BLOCKED_BY_VS03_05B
→ VS03-07 · BLOCKED_BY_VS03_06
```

## Implementation Tracking

| Scope | Status | Validation |
|---|---|---|
| rail/train/cargo/LIFO foundation | IMPLEMENTED | automated PASS |
| VS03-01 run lifecycle/economy/Combo/difficulty core | MERGED_AND_VERIFIED | 16 cases · 7110 assertions · 0 failures |
| VS03-02 compact token/footprint/occupancy | MERGED_AND_VERIFIED | 19 cases · 7499 assertions · 0 failures |
| VS03-03 map/session/restart/selection | READY_FOR_BUILD · NOT_STARTED | CURRENT_AUTHORITY |
| VS03-R1 difficulty authority alignment | PLANNED · BLOCKED_BY_VS03_03 | NOT_STARTED |
| VS03-05A minimal playable core | PLANNED · BLOCKED_BY_VS03_R1 | NOT_STARTED |
| VS03-04 Profile/meta foundation | BLOCKED_BY_VS03_05A | NOT_STARTED |
| VS03-05B result/collection/browser | BLOCKED_BY_VS03_04 | NOT_STARTED |
| VS03-06~07 | BLOCKED_BY_PREVIOUS_PACKAGE | NOT_STARTED |
| target3 official maps | VS03-03 | NOT_STARTED |
| target100 official maps | PRODUCTION | `F58 NOT_MET` |
| UGC online/backend/community | PRODUCTION | NOT_STARTED/NOT_RUN |
| Android/localization/accessibility/human | VS04_EVIDENCE | NOT_RUN |

## Common Protected Contracts

- LIFO load-order planning is the primary fun; route and risk support it, meta does not replace it.
- UI·camera·animation·onboarding·result·browser·editor·community view는 non-authoritative다.
- current custom test runner를 사용한다.
- compact footprint는 explicit provider로 DeliveryLoop에 주입하고 legacy fallback을 보존한다.
- `TrainFootprint`는 route-history geometry와 conservative occupied cells를 소유한다.
- `RunSessionFactory`는 fully configured session만 성공으로 반환한다.
- movement/event/fuel-zero는 boundary-sliced authoritative order를 따른다.
- DifficultyDirector union schedule은 VS03-R1에서 정렬한다.
- VS03-05A는 Profile schema나 임시 저장 형식을 만들지 않는다.
- ProfileStore/TransactionService가 유일한 persistence writer다.
- same-map restart는 같은 MapDefinition과 fresh mutable services/identities를 사용한다.
- selected/restarted map은 silent substitution하지 않는다.
- target100과 online UGC는 VS-03 범위 밖이다.

## Benchmark-Backed Decision Rule

중요 player-facing choice나 package sequencing을 Grill Me로 질문할 때는 가까운 벤치마크, 인접 사례/현업 지침, 비교 축, 채택/비채택 이유, 제작 비용, 실패 위험, 권장안, 적대적 반론, 검증 Gate를 포함한다.

## Evidence Registry

| Evidence | 상태 |
|---|---|
| EV-USER-002~005 | CONFIRMED_USER_DECISION/OPERATION · SYNCED |
| EV-USER-006~015 | CONFIRMED_USER_DECISION · PR #29/SHEET SYNCED |
| EV-USER-016 | DoR review · PR #35/#36/SHEET SYNCED |
| EV-VS03-01-001 | VS03-01 exact-head evidence · PR #37/#38/SHEET SYNCED |
| EV-USER-017~018 | core-fun review and sequence approval · PR #39/#40/SHEET SYNCED |
| EV-VS03-02-001 | VS03-02 exact-head implementation evidence · PR #41/SHEET SYNCED · CLOSURE_IN_PROGRESS |
| EV-VS01-001 | VALIDATED |
| EV-VS02-001 | VALIDATED |
| EV-VS02-FIX-001 | VALIDATED |
| EV-BASE-V94-001 | VALIDATED_AUTOMATED_ONLY |

## Scope Boundary

- VS-03: local core + exactly 3 representative official maps + local official records/progression.
- VS-04: Android/device/soak/localization/accessibility/economy/human evidence.
- Production: target100 + full online UGC.
- `F92` remains open until product-view/device/human compact-token readability evidence.
- `F58` remains `NOT_MET` until target100 implementation/audit.

## Current Sync State

```text
VS03-02 implementation PR #41 merged cfe6d5ca...
correct Sheet SX-AUD-008 / EV-VS03-02-001 readback PASS
VS03-02 closure PR in progress
wrong 19Ff... Sheet untouched
VS03-03 READY_FOR_BUILD · CURRENT_AUTHORITY
```
