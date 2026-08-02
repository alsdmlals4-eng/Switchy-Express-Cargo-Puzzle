# Switchy Express 총기획 Coverage·충돌 감사

```yaml
audit_id: SX-AUD-004
status: IN_PROGRESS · SX-DEC-014/015/016_AND_SX-OPS-001_SYNCED
baseline_main: 867563bb7bb69cfbb7343ef734585dd034ad7a64
latest_synchronized_main: 3cd13ff375a597d4eba9035af5b05e6186fb4853
work_mode: TOTAL_PLANNING · REVIEW
implementation_authority: PLANNING_AND_DOCUMENTATION_ONLY
sheet_state: PASS · 12_TABS_READBACK · SYNCED
codex_state: CODEX_NOT_READY
number_policy: RECOMMENDED_DEFAULT_OR_TEST_VALUE
user_decision_policy: ONE_MATERIAL_GRILL_ME_AT_A_TIME
merge_policy: GMB-001 · SX-DEC-017_START · 0/10
operating_protocol: SX-OPS-001
```

## 목적

VS-03 구현 전에 제품·경험·시스템·콘텐츠·UX·표현·세계·데이터·저장·검증·제작 기획을 실제 구현과 대조한다. 검증된 안전 보완은 자동 반영하고, 프로젝트 방향을 달리 만드는 충돌만 Grill Me Decision으로 닫는다.

`SX-DEC-014~016` catch-up은 canonical merge와 Google Sheet 12탭 readback까지 완료됐다. 이후 `SX-DEC-017`부터는 승인 10건마다 `SX-OPS-001`의 pre-merge 전수 감사와 Sync Closure를 수행한다.

## 보호 강점

- 자동 운행 중 적재·분기·LIFO를 함께 계획하는 핵심 조합
- 15×10 전체 연결·막다른길 없음
- 직진 우선·preview parity·segment target lock
- 색상+모양 화물·역
- capacity 8·결정론적 배치·bounded failure·deferred recovery
- compact token으로 적재량·LIFO를 읽되 긴 열차 점유 억제
- 실제 첫 run에서 행동 직후 규칙을 가르치는 상황형 온보딩
- 제품 결과와 UI·animation 권위 분리
- Godot 4.7.1·Android 가로형 기준

## Coverage Matrix

| 영역 | 현재 상태 | 공백·다음 증거 | 판정 |
|---|---|---|---|
| 운영 | `SX-OPS-001` GitHub·Sheet SYNCED, GMB-001 0/10 | 프로토콜 첫 실제 10건 실행 | ACTIVE |
| 제품·타깃 | 모바일 캐주얼·짧은 세션·기록 경쟁 | 목표 세션 실측 | TEST_VALUE_REQUIRED |
| 핵심 플레이 | 자동운행→LOAD→분기→LIFO | 생존 경제 미구현 | READY_FOR_PLAN |
| 화물·화차 | cargo 1=compact token 1 | 0/1/4/8·곡선·Android | TEST_REQUIRED |
| 생존 경제 | Combo와 speed bonus 분리 | RunBalance 수치·exploit | TEST_VALUE_REQUIRED |
| 실패·복구 | 연료 0→결과→재시작 | 실패 원인·다음 행동 우선순위 | NEXT_DECISION |
| 온보딩 | 실제 첫 run 상황형 계약 | runtime·Android·5명+ | TEST_REQUIRED |
| UX·표현 | HUD·route·token·safe pause 계약 | 실제 밀도·48dp·Reduced Motion | TEST_REQUIRED |
| 세계·서사 | 토끼 기관사·미니어처 철도 | VS 상세는 후순위 | DEFERRED_WITH_BOUNDARY |
| 데이터·저장 | records·onboarding preference 분리 | 구현·손상 fallback | READY_FOR_PLAN |
| 제작·인계 | VS-03A→VS-03B→VS-03C→VS-04 | GMB-001과 Definition of Ready | CODEX_NOT_READY |

## Finding Ledger

| ID | 문제 | 판정·처리 |
|---|---|---|
| F01 | Combo가 unload group인지 배송 streak인지 불명확 | `SX-DEC-014`로 고정·SYNCED |
| F02 | cargo count와 visible wagon 관계 미정 | `SX-DEC-015`로 고정·SYNCED |
| F03 | 첫 세션 학습 순서·도움 방식 미정 | `SX-DEC-016`으로 고정·SYNCED |
| F04 | 프로젝트 Skill의 구형 구현 경계 | Post-VS02/current plan으로 갱신 |
| F05 | 5명 표본 퍼센트 기준 모호 | 실제 명수·ceil 규칙 병기 |
| F06 | telemetry가 color만 기록 | cargo_type·color·shape 분리 |
| F07 | 오디오·햅틱 우선순위 부재 | P0/P1/P2와 fallback 계약 |
| F08 | 속도·연료·보상 수치 미검증 | `TEST_VALUE`·시뮬레이션·플레이테스트 |
| F09 | 작은 화면 실제 밀도 미검증 | VS-03B·Android 검증 |
| F10 | 총기획 감사 책임 문서 부재 | 이 문서를 CURRENT로 등록 |
| F11 | 구형 마스터 Plan status | 2026-08-02 Current Plan 등록·구형 HISTORICAL |
| F12 | 감사 문서 CURRENT 충돌 | SX-AUD-004 CURRENT·Post-VS02 HISTORICAL |
| F13 | full-cell wagon 8칸의 가시성 저하 | compact token·trailing≤3 |
| F14 | 시각만 압축하고 spawn 점유 유지 위험 | compressed footprint를 점유 권위로 정의 |
| F15 | 작은 token shape 식별 위험 | 0/1/4/8·곡선·Android `TEST_REQUIRED` |
| F16 | 2.25칸↔2.18칸 drift | 2.18칸 `TEST_VALUE`로 통일 |
| F17 | onboarding UI가 gameplay/pause 권위를 소유할 위험 | domain event 권위·UI 표시 전용 |
| F18 | assisted first run이 일반 balance 증거 오염 | `assisted_first_run` 분석 분리 |
| F19 | batch 중 Sheet를 SYNCED로 오표기할 위험 | `APPROVED_PENDING_BATCH_MERGE` 사용 |
| F20 | 10건 PR에 11번째 범위 잠입 | 10번째 승인 후 Freeze·inventory Gate |
| F21 | 역사 대체 이력·compact token 세부 계약 축약 | 병합 전 원문 보호선 복원 |
| F22 | 제작 순서에서 VS-03C 누락 | A→B→C→VS-04로 통일 |
| F23 | Sheet AB-TP01 행이 `SX-DEC-016 USER_DECISION_REQUIRED`로 잔존 | 12탭 readback 중 발견·현재 승인/commit/SYNCED로 수정 |

## 확정 Decision

### SX-DEC-014

```text
Combo = 한 번의 역 도착에서 stack top부터 연속 하역된 동일 cargo_type 개수
max_combo = 한 판 최대 unload group
speed_bonus = Combo와 독립
```

상태: `GITHUB_SHEET_SYNCED · IMPLEMENTATION_NOT_STARTED`.

### SX-DEC-015

```text
cargo 1 = compact wagon token 1
front→rear = stack bottom→top
rear token = next LIFO item
8 token chain = 2.18 cells TEST_VALUE
trailing footprint <=3 cells TEST_VALUE
```

상태: `GITHUB_SHEET_SYNCED · IMPLEMENTATION_NOT_STARTED`.

### SX-DEC-016

```text
별도 tutorial map 없음
실제 첫 run: LOAD→token→switch→mixed-stack LIFO→Combo→low-fuel BOOST
첫 LOAD·첫 switch만 safe full pause
assist: fuel 0.5×·escalation pause·120s·3s restore TEST_VALUE
UI·animation non-authoritative
```

상태: `GITHUB_SHEET_SYNCED · IMPLEMENTATION_NOT_STARTED`.

### SX-OPS-001

```text
GMB-001은 SX-DEC-017부터 10건
각 승인: batch branch/PR·Sheet APPROVED_PENDING_BATCH_MERGE
10번째: Freeze·GitHub/PR/Sheet 12탭 adversarial audit
checks PASS·P0/P1 0·thread 0에서 canonical merge
Sheet merge commit·12탭 readback·Sync Closure까지 batch CLOSED 아님
```

상태: `ACTIVE · GMB-001 0/10`.

## Catch-up Pre-merge·Sheet 결과

- main baseline: `867563bb7bb69cfbb7343ef734585dd034ad7a64`
- PR #27 exact head: `6d400aea3eb9de77ef37664d3348b556025e002b`
- canonical squash commit: `3cd13ff375a597d4eba9035af5b05e6186fb4853`
- changed files: 21 planning/Skill/operations, product files 0
- Project Contract: success
- Godot Tests: success
- unresolved review threads: 0
- P0/P1 open planning findings: 0
- correct Sheet ID/title verified
- Sheet 12 tabs reread; Decision/Evidence/commit/status matched
- unrelated `30_세계_서사` and historical evidence preserved
- F23 stale Sheet consumer corrected
- wrong `19Ff...` Sheet not modified

## Decision Queue

1. `SX-DEC-014` — CLOSED · SYNCED
2. `SX-DEC-015` — CLOSED · SYNCED
3. `SX-DEC-016` — CLOSED · SYNCED
4. `SX-DEC-017` 결과 화면 실패 원인·다음 행동 — `NEXT_GRILL_ME · GMB-001 SLOT 1`
5. 세계·마스코트 상세 — `DEFERRED_WITH_BOUNDARY`

## 현재 Gate

- `G2_IMPLEMENTED_FOUNDATION`: PASS
- `G3_CORE_LOOP_IMPLEMENTED`: PARTIAL
- `G3P_TOTAL_PLANNING_AND_REVIEW_COMPLETE`: NOT_READY
- `G3B_GRILL_ME_BATCH_PREMERGE`: GMB-001_NOT_STARTED · 0/10
- `G4_TARGET_QUALITY_VERTICAL_SLICE`: NOT_READY
- `CODEX_DEFINITION_OF_READY`: NOT_READY

## 다음 작업

```text
SX-DEC-017 Grill Me
→ 승인 시 GMB-001 1/10 · APPROVED_PENDING_BATCH_MERGE
→ 한 건씩 반복
→ 10/10에서 SX-OPS-001 pre-merge audit·canonical merge·Sheet closure
```

## 결론

`SX-DEC-014/015/016`과 `SX-OPS-001`은 GitHub와 Google Sheets에서 `PASS · SYNCED`다. 제품 구현·Android·사람 검증은 여전히 `NOT_STARTED / NOT_RUN / HUMAN_NOT_RUN`이며 `CODEX_NOT_READY`를 유지한다.
