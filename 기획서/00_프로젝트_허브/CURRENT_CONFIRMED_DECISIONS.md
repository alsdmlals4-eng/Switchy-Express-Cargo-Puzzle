# Current Confirmed Decisions

Last updated: `2026-08-02`

```yaml
product_baseline: 4e435a1a6d10ab146197671049da80709fd18c1f
latest_planning_decision_merge: 9b63421a5ab4d57adbfcf69d2b6e1bf8e3d17496
gmb001: CLOSED · SX-DEC-017~026 · 10/10
sheet: SYNCED · 12_TABS_READBACK_PASS
implementation_authority: PLANNING_ONLY
codex_state: CODEX_NOT_READY
next_gate: G3P_DEFINITION_OF_READY_REVIEW
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

정본 Decision merge: PR #29 · `9b63421a5ab4d57adbfcf69d2b6e1bf8e3d17496`.

상세 계약과 단계 분리: `GMB-001_CANONICAL_DECISIONS.md`.

## 구현·검증 추적

| Decision 범위 | 구현 상태 | 검증 상태 | 남은 범위 |
|---|---|---|---|
| SX-DEC-003~008,013 | IMPLEMENTED_OR_PARTIAL | AUTOMATED_PASS/PARTIAL | 제품 UI·실기·soak |
| SX-DEC-009~010 | NOT_STARTED / INTERFACE_ONLY | NOT_RUN | 생존 경제·BOOST exploit |
| SX-DEC-011~012 | DIRECTION/BASELINE | PARTIAL | 제품 아트·Android export·성능 |
| SX-DEC-014~018 | PLANNING_APPROVED | NOT_STARTED / NOT_RUN | Combo·tokens·onboarding·result·camera |
| SX-DEC-019~022 | PLANNING_APPROVED | NOT_STARTED / NOT_RUN | Profile·economy·difficulty·localization |
| SX-DEC-023~024 | PLANNING_APPROVED | NOT_STARTED / NOT_RUN | same-map·target3/100·selection/browser |
| SX-DEC-025 | PLANNING_APPROVED | NOT_STARTED / NOT_RUN | scoped records·editor·backend·moderation·two-account |
| SX-DEC-026 | PLANNING_APPROVED | NOT_STARTED / NOT_RUN | signal backend·journal·anti-abuse·privacy·human |
| SX-OPS-001 | ACTIVE | GMB001_CLOSED | next batch not started |

Planning approval and synchronization are not implementation success.

## Evidence Registry

| Evidence | 상태 |
|---|---|
| EV-USER-002~005 | CONFIRMED_USER_DECISION/OPERATION · SYNCED |
| EV-USER-006~015 | CONFIRMED_USER_DECISION · PR #29/SHEET SYNCED |
| EV-VS01-001 | VALIDATED |
| EV-VS02-001 | VALIDATED |
| EV-VS02-FIX-001 | VALIDATED |
| EV-BASE-V94-001 | VALIDATED_AUTOMATED_ONLY |

## 공통 보호 계약

- UI·camera·Tween·animation·onboarding·result·browser·editor·community view는 non-authoritative다.
- `FULL_MAP_READY` 전 authoritative progression·discovery·record·community qualification commit 없음.
- assisted first run은 standard record·goal·variable reward·balance evidence와 분리한다.
- map/UGC revision/run/record/reward/selection/upload/signal identity를 분리한다.
- mutations는 atomic·idempotent 또는 replay-safe다.
- same-map restart는 fresh mutable services를 만든다.
- fallback/duplicate official layout은 100+ count에서 제외한다.
- UGC package는 data-only이며 executable/custom asset/ruleset override를 금지한다.
- UGC record/signal은 immutable revision-scoped다.
- UGC는 official records·discovery·goals·rewards·wallet·unlock·official selection weight를 변경하지 않는다.

## 단계 경계

- VS-03: local core + 최소 3 official maps + official local global/per-map records.
- Production: official target 100+ + full online UGC editor/backend/moderation/community.
- `F58`은 target-100 증거 전 `NOT_MET`.
- local mock은 online readiness 증거가 아니다.

## 현재 동기화 상태

- GMB-001: `CLOSED`
- Decision 정본: `9b63421a5ab4d57adbfcf69d2b6e1bf8e3d17496`
- correct Sheet 12 tabs: `SYNCED · READBACK PASS`
- wrong `19Ff...` Sheet: untouched
- product code/Scene/Resource/asset changes in batch: 0
- next: `G3P Definition of Ready review`
- `CODEX_NOT_READY`

## 폐기·대체된 후보

- 자동차·스네이크 직접 조작 → 기차 노선 조작
- FIFO → LIFO
- 세로형 → 가로형
- 15×15·14×9 → 15×10
- 좌표순 기본 분기 → 직진 우선
- delivery streak Combo → one-arrival unload group
- full-cell wagon chain → compact tokens
- 별도 고정 tutorial → actual-run contextual onboarding
- 초기 UGC reward/rating/leaderboard → non-economic signals only
