# Current Confirmed Decisions

Last updated: `2026-08-02`

```yaml
product_baseline: 4e435a1a6d10ab146197671049da80709fd18c1f
latest_planning_decision_merge: 9b63421a5ab4d57adbfcf69d2b6e1bf8e3d17496
gmb001: CLOSED · SX-DEC-017~026 · 10/10
dor_audit: SX-AUD-005 · PASS_WITH_PLANNING_FIXES
dor_evidence: EV-USER-016
sheet: GMB001_SYNCED · DOR_CANONICAL_SYNC_PENDING
implementation_authority: VS03-01_PENDING_CANONICAL_SYNC
codex_state: READY_FOR_BUILD_PENDING_CANONICAL_SYNC
product_implementation: NOT_STARTED
```

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
| SX-DEC-009 | 시스템 | 배송 점수·연료, 시간 증가 압력, 연료 0 종료. | 사용자 승인 | CONFIRMED · SYNCED |
| SX-DEC-010 | 시스템 | 화물 감속, BOOST 속도 증가·연료 추가 소모. | 사용자 승인 | CONFIRMED · SYNCED |
| SX-DEC-011 | 표현 | 둥근 프리미엄 캐주얼 3D 카툰과 토끼 기관사. | 사용자 승인 | CONFIRMED · SYNCED |
| SX-DEC-012 | 기술 | Godot 4.7.1/GDScript, Android, 가로형. | 프로젝트 기본값·PR #9 | CONFIRMED · SYNCED |
| SX-DEC-013 | 분기 UX | 기본 A는 가능하면 직진 우선, preview와 실제 next parity. | 사용자 승인·PR #9 | CONFIRMED · SYNCED |
| SX-DEC-014 | 점수 | Combo는 one-arrival unload-group size, speed bonus는 별도. | EV-USER-002 | CONFIRMED · SYNCED |
| SX-DEC-015 | 화차 UX | cargo 1개=compact token 1개, rear=LIFO top, compressed footprint. | EV-USER-003 | CONFIRMED · SYNCED |
| SX-DEC-016 | 첫 세션 | 실제 첫 run에서 LOAD→token→분기→LIFO→Combo→BOOST 학습. | EV-USER-004 | CONFIRMED · SYNCED |
| SX-DEC-017 | 결과 | 근거 있는 실패 원인 1개와 다음 행동 1개, 불확실하면 neutral fallback. | EV-USER-006 | CONFIRMED · SYNCED |
| SX-DEC-018 | 카메라 | first PREP 약한 확대, `FULL_MAP_READY` 뒤 run, active full map. | EV-USER-007 | CONFIRMED · SYNCED |
| SX-DEC-019 | 진행 | 표준 기록 3종과 gameplay power 없는 cosmetic collection/equip. | EV-USER-008 | CONFIRMED · SYNCED |
| SX-DEC-020 | 해금 | `DEFAULT / DUAL_PATH / CURRENCY_ONLY`, 구매는 goal 완료를 위조하지 않음. | EV-USER-009 | CONFIRMED · SYNCED |
| SX-DEC-021 | 보상 | 유효 일반 run의 bounded base·delivery·Combo·record cosmetic currency. | EV-USER-010 | CONFIRMED · SYNCED |
| SX-DEC-022 | 난이도 | authoritative prewarning와 `CALM/BUSY/INTENSE` persistent signal. | EV-USER-011 | CONFIRMED · SYNCED |
| SX-DEC-023 | 재시작·맵 | exact same-map restart, 새 seed는 검증 official catalog 제작에 사용. | EV-USER-012 | CONFIRMED · SYNCED |
| SX-DEC-024 | 맵 선택 | `NEW RUN`은 미발견 official map 우선, 발견 map 직접 재선택. | EV-USER-013 | CONFIRMED · SYNCED |
| SX-DEC-025 | 기록·UGC | official global+per-map 기록, data-only immutable user-map publication. | EV-USER-014 | CONFIRMED · SYNCED |
| SX-DEC-026 | UGC community | favorite·verified play·1추천·report/block·staff pick, reward/rating/leaderboard 제외. | EV-USER-015 | CONFIRMED · SYNCED |
| SX-OPS-001 | 운영 | 승인 10건마다 freeze·감사·canonical merge·Sheet closure. | EV-USER-005 | CONFIRMED_OPERATION · GMB001_CLOSED |

## Audit and Execution Registry

| ID | 범위 | 근거 | 현재 상태 |
|---|---|---|---|
| SX-AUD-004 | 전체 기획 coverage·Decision 충돌 | EV-USER-002~015 | GMB001_CLOSED · RUNTIME_FOLLOWUPS |
| SX-AUD-005 | VS-03 Definition of Ready·실제 API/file/test/save/order/rollback | EV-USER-016 | PASS_WITH_PLANNING_FIXES · CANONICAL_SYNC_PENDING |

`SX-AUD-005`는 제품 규칙 Decision을 변경하지 않는다. 승인된 의미를 실제 저장소에서 구현 가능한 package contract로 정규화한다.

## DoR Execution Authority

Canonical documents:

```text
기획서/50_제작_검증/VS03_DEFINITION_OF_READY_AUDIT.md
docs/superpowers/specs/2026-08-02-vs03-execution-architecture-design.md
docs/superpowers/plans/2026-08-02-vs03-build-segmentation.md
```

Decision-specific plans remain responsibility references. Their pseudocode/path/test command conflicts are non-authoritative against the DoR canon.

After merge + Sheet closure:

```text
Codex READY_FOR_BUILD · VS03-01 only
product implementation still NOT_STARTED until execution begins
```

## Implementation Tracking

| Scope | Status | Validation |
|---|---|---|
| existing rail/train/cargo/LIFO foundation | IMPLEMENTED_OR_PARTIAL | historical automated PASS/PARTIAL |
| SX-DEC-014~026 runtime | NOT_STARTED_OR_NOT_RUN | planning approved only |
| VS03-01 | READY_PENDING_CANONICAL_SYNC | NOT_STARTED |
| VS03-02~07 | BLOCKED_BY_PREVIOUS_PACKAGE | NOT_STARTED |
| target3 official maps | PLANNED_VS03 | NOT_RUN |
| target100 official maps | PRODUCTION | `F58 NOT_MET` |
| UGC online/backend/community | PRODUCTION | NOT_STARTED/NOT_RUN |
| Android/localization/accessibility/human | VS04_EVIDENCE | NOT_RUN |

## Common Protected Contracts

- UI·camera·Tween·animation·onboarding·result·browser·editor·community view는 non-authoritative다.
- current custom test runner를 사용한다.
- compact footprint는 explicit provider로 DeliveryLoop에 주입하고 legacy fallback을 보존한다.
- RunSessionFactory는 fully configured session만 성공으로 반환한다.
- movement/event/fuel-zero는 boundary-sliced authoritative order를 따른다.
- ProfileStore/TransactionService가 유일한 persistence writer다.
- assisted first run은 standard record·goal·variable reward·balance evidence와 분리한다.
- same-map restart는 fresh mutable services를 만든다.
- selected/restarted map은 silent substitution하지 않는다.
- target100과 online UGC는 VS-03 범위 밖이다.

## Evidence Registry

| Evidence | 상태 |
|---|---|
| EV-USER-002~005 | CONFIRMED_USER_DECISION/OPERATION · SYNCED |
| EV-USER-006~015 | CONFIRMED_USER_DECISION · PR #29/SHEET SYNCED |
| EV-USER-016 | user instruction to execute G3P DoR review and recommended fixes · CANONICAL_SYNC_PENDING |
| EV-VS01-001 | VALIDATED |
| EV-VS02-001 | VALIDATED |
| EV-VS02-FIX-001 | VALIDATED |
| EV-BASE-V94-001 | VALIDATED_AUTOMATED_ONLY |

## Scope Boundary

- VS-03: local core + exactly 3 representative official maps + local official records/progression.
- VS-04: Android/device/soak/localization/accessibility/economy/human evidence.
- Production: target100 + full online UGC.
- `F58` remains `NOT_MET` until target100 implementation/audit.

## Current Sync State

```text
GMB-001 CLOSED
DoR branch planning only
DoR canonical merge pending
correct Sheet DoR rows pending
wrong 19Ff... Sheet untouched
```
