# Switchy Express 총기획 Coverage·충돌 감사

```yaml
audit_id: SX-AUD-004
status: IN_PROGRESS · SX-DEC-014_SYNCED · NEXT_GRILL_ME_SX-DEC-015
baseline_main: 474bef445c2cf5e501bd7478e26a5b8d0dfe26f1
combo_decision_commit: ca50538652c72cbb282d7818990e92a0dfe79c9a
work_mode: TOTAL_PLANNING · REVIEW
implementation_authority: PLANNING_AND_DOCUMENTATION_ONLY
sheet_state: SYNCED_AT_CA505386 · 12_TAB_READBACK_PASS
codex_state: CODEX_NOT_READY
number_policy: RECOMMENDED_DEFAULT_OR_TEST_VALUE
user_decision_policy: ONE_MATERIAL_GRILL_ME_AT_A_TIME
```

## 목적

VS-03 구현 전에 프로젝트의 제품·경험·시스템·콘텐츠·UX·표현·세계·데이터·저장·검증·제작 기획을 실제 구현과 대조한다. 검증된 안전 보완은 자동 반영하고, 프로젝트 방향을 달리 만드는 충돌만 Grill Me Decision으로 닫는다.

## 보호 강점

- 자동 운행 중 적재·분기·LIFO를 동시에 계획하는 핵심 조합
- 15×10 전체 연결·막다른길 없음
- 직진 우선·preview parity·segment target lock
- 색상+모양 화물·역
- 최대 적재 8·결정론적 배치·bounded failure·deferred recovery
- 귀엽고 친근한 프리미엄 캐주얼 철도 방향
- 짧은 모바일 세션과 기록 경쟁
- 제품 결과와 UI 모션의 권위 분리
- Godot 4.7.1·Android 가로형 기준

## Coverage Matrix

| 영역 | 현재 상태 | 확인된 강점 | 공백·충돌 | 판정 |
|---|---|---|---|---|
| 프로젝트·운영 | 정본·Sheet 동기화 완료 | 새 작업자가 VS-02 완료와 다음 Gate 복원 가능 | Skill·Plan·Registry의 구형 참조 발견 후 복구 | AUTO_FIXED |
| 제품·타깃 | 모바일 캐주얼·짧은 세션·기록 경쟁 | 제품 약속은 선명함 | 목표 세션 시간·첫 세션 기대 결과는 실측 전 수치 | TEST_VALUE_REQUIRED |
| 핵심 플레이 | 자동운행→LOAD→분기→LIFO | 독립 기술 계약과 테스트가 존재 | Combo 의미는 `SX-DEC-014`로 확정·동기화 | DECISION_CLOSED |
| 화물·화차 | capacity 8·최대 8화차 | 코드가 wagon count와 cargo count를 독립 제공 | 한 화물=한 화차인지, 빈 화차가 존재하는지, 증감 시점 미정 | USER_DECISION_REQUIRED |
| 생존 경제 | 시간·무게·BOOST 위험 교환 | Combo와 speed bonus가 분리됨 | 수치는 미검증 | TEST_VALUE_REQUIRED |
| 실패·복구 | 연료 0→결과→재시작 | 즉시 재도전 방향 명확 | 결과 화면의 실패 원인·학습 정보 우선순위 미정 | NEEDS_IMPROVEMENT |
| 온보딩 | 3분 내 LIFO 이해 목표 | 테스트 가설 존재 | 분기·LOAD·LIFO 학습 순서와 도움 방식 미정 | USER_DECISION_REQUIRED 후보 |
| UX·HUD | 상단 상태·하단 입력·경로 강조 | Combo/Speed Bonus 의미 분리 | 화차/화물 표현, 시간 압박 경고, 일시정지 흐름 미정 | BLOCKED_BY_SX_DEC_015 |
| 아트·모션 | 승인 콘셉트와 모션 비권위 | 시각 Pillar가 명확 | 실제 자산·카메라·밀도·이펙트는 런타임 미검증 | TEST_IN_VERTICAL_SLICE |
| 오디오·햅틱 | 정보 우선순위·fallback 권장 계약 작성 | mute·haptic-off에도 P0/P1 정보 보존 | 실제 자산·사람 반응 미검증 | AUTO_FIXED_THEN_TEST |
| 세계·서사 | 토끼 기관사·미니어처 철도 | 제품 호감과 테마에 충분 | VS에서 이름·서사를 어느 수준까지 구현할지 미정 | DEFERRED_WITH_BOUNDARY 가능 |
| 데이터·저장 | best score/time/max_combo·schema version | `max_combo` 의미 확정 | 손상·버전 fallback 실제 구현 없음 | READY_FOR_PLAN |
| 텔레메트리 | 핵심 이벤트 목록 존재 | cargo_type·shape·unload_group_size로 확장 | 실제 event log 미구현 | AUTO_FIXED_THEN_BUILD |
| 플레이테스트 | 5명+·핵심 과제 존재 | 퍼센트와 5명 실제 명수 일치 | 실제 표본 없음 | AUTO_FIXED_THEN_TEST |
| 성능·접근성 | 60 FPS 목표·48dp·색+모양 | 목표 품질 Gate 존재 | 기기·해상도·사람 증거 없음 | BLOCKED_UNVERIFIED |
| 제작·인계 | VS-03A→VS-03B→VS-04 | 책임 분리·테스트 순서 명확 | 중요 Decision 미완료 | CODEX_NOT_READY |

## Finding Ledger

| ID | 유형 | 문제 | 영향 | 판정 | 처리 |
|---|---|---|---|---|---|
| SX-AUD-004-F01 | PLANNING_CONFLICT | Combo가 단일 하역 그룹인지 배송 streak인지 불명확 | 점수·HUD·저장 차단 | CONFLICT_FIXED | `SX-DEC-014` 사용자 승인·GitHub/Sheet SYNCED |
| SX-AUD-004-F02 | UNDERDESIGN | cargo count와 visible wagon 관계 미정 | 실루엣·무게 가독성·점유·애니메이션 충돌 | USER_DECISION_REQUIRED | `SX-DEC-015` NEXT Grill Me |
| SX-AUD-004-F03 | UNDERDESIGN | 첫 세션 학습 순서·도움 방식 미정 | 이해 실패가 판단 실패로 오인될 위험 | USER_DECISION_REQUIRED 후보 | F02 뒤 판정 |
| SX-AUD-004-F04 | STALE_REFERENCE | 프로젝트 Skill이 Post-VS01과 구형 구현 경계 사용 | 잘못된 사실 복원 | CONFLICT_FIXED | Post-VS02·총기획 기준으로 갱신 |
| SX-AUD-004-F05 | MEASUREMENT_GAP | 5명 표본에 70%·50% 기준 | 반올림 자의성 | CONFLICT_FIXED | 퍼센트+실제 명수·ceil 규칙 병기 |
| SX-AUD-004-F06 | ACCESSIBILITY_RISK | telemetry가 `color`만 기록 | 색상+모양 오류 원인 분리 불가 | CONFLICT_FIXED | cargo_type·color·shape 기록 |
| SX-AUD-004-F07 | UNDERDESIGN | 오디오·햅틱 사건 우선순위 부재 | fallback과 정보 설계 단절 | IMPROVED | P0/P1/P2 권장 계약 작성 |
| SX-AUD-004-F08 | UNPROVEN_ASSUMPTION | 속도·연료·보상·목표 세션 수치 | 영구 생존·상시 BOOST·피로 위험 | RESEARCH_OR_TEST_REQUIRED | TEST_VALUE·시뮬레이션·플레이테스트 |
| SX-AUD-004-F09 | PRODUCTION_RISK | 역6·화물12+·분기·HUD의 실제 밀도 미검증 | 작은 화면 정보 과부하 | TEST_IN_VERTICAL_SLICE | VS-03B 캡처·Android 검증 |
| SX-AUD-004-F10 | MISSING_CANON | 총기획 감사·Decision Queue 책임 문서 부재 | 기획 보완 추적 불가 | CONFLICT_FIXED | 이 문서를 current 감사로 등록 |
| SX-AUD-004-F11 | STALE_REFERENCE | 마스터 Plan이 복구를 IN_PROGRESS, main을 `539d2bae…`로 표시 | 완료 작업 재실행·잘못된 구현 기준 | CONFLICT_FIXED | PR #16/#17 완료·main `474bef44…`·Decision 소비자 반영 |
| SX-AUD-004-F12 | AUTHORITY_CONFLICT | Registry에서 총기획 감사와 Post-VS02 감사를 모두 CURRENT로 표시 | 현행 감사 원본 선택 불명확 | CONFLICT_FIXED | 총기획 감사 CURRENT·Post-VS02 HISTORICAL |

## 확정 Decision — SX-DEC-014

사용자 승인:

```text
Combo = 한 번의 역 도착에서 stack top부터 연속 하역된 동일 cargo_type 개수
max_combo = 한 판에서 기록한 최대 Combo
빠른 연속 배송 = Combo가 아닌 별도 speed_bonus 시험 차원
```

파생 결과:

- `try_unload().count`, `combo_count`, `unload_group_size`를 같은 값으로 통일
- 배송 사이에 유지되는 Combo streak state 제거
- HUD 성공 피드백 `COMBO ×N`, 상단 run 최대 Combo, 결과 `MAX COMBO`
- `speed_bonus_applied`를 별도 telemetry 필드로 기록
- 저장은 `max_combo`만 보존
- `5+` 보상표의 모호한 “+ 콤보” 표현 제거
- Vertical Slice 계약과 마스터 Plan의 Task 6~8까지 동일 의미 전파

판정: `CONFLICT_FIXED · GITHUB_SHEET_SYNCED · IMPLEMENTATION_NOT_STARTED`.

동기화 증거:

- PR #18 canonical commit: `ca50538652c72cbb282d7818990e92a0dfe79c9a`
- Google Sheets: Adapter의 `1EpQ...`
- Decision `SX-DEC-014`, Evidence `EV-USER-002`, Audit `SX-AUD-004`
- 12개 탭 readback: `PASS · SYNCED`
- 다른 프로젝트 `19Ff...` Sheet: 변경하지 않음

## 다음 충돌 근거 — SX-AUD-004-F02

현재 코드 사실:

- `TrainState`는 `_wagon_count`를 `0~8`에서 독립적으로 설정할 수 있다.
- `CargoStack`도 `0~8` item을 독립적으로 보유한다.
- `DeliveryLoop`는 적재·하역 뒤 wagon count를 자동 동기화하지 않는다.
- `train_cells()`는 현재 wagon count에 따라 화물 spawn 금지 점유 칸에도 영향을 준다.

따라서 시각 표현 선택은 단순 아트 문제가 아니다. 열차 길이·점유·생성 공정성·화물 무게 가독성·하역 피드백을 함께 바꾼다.

### A. 적재 화물 1개 = 표시 화차 1개

- `wagon_count == cargo_stack.size()`
- 적재 시 뒤에 화차가 추가되고 하역 수만큼 제거
- 장점: 적재량·감속·capacity가 세계 안에서 즉시 읽힘, LIFO 순서와 열차 성장의 인과가 강함
- 위험: 열차 길이 변화가 spawn 점유와 작은 맵 밀도에 영향을 줌, 추가/제거 모션의 비권위 계약 필요

### B. 8개 빈 화차를 항상 표시

- run 시작부터 8개 화차, 화물만 슬롯에 채움
- 장점: 물리 슬롯·capacity가 가장 명확하고 열차 길이가 안정적
- 위험: 15×10에서 항상 9칸 열차가 길고, 빈 화차가 시각·spawn 공간을 과도하게 차지

### C. 고정 3~4개 화차에 여러 화물을 묶어 표현

- 실제 stack은 8, 표시 화차는 고정 소수
- 장점: 화면 밀도·점유 안정, 제품 구현 단순
- 위험: 화물 수와 열차 길이 인과가 약하고 “한 화차에 몇 개” 추가 규칙이 필요

## GPT 권장안 — SX-DEC-015

`A. 적재 화물 1개 = 표시 화차 1개`를 권장한다.

이유:

1. 화물 적재량이 속도 감속과 직접 연결되는 게임 규칙을 가장 명확하게 시각화한다.
2. capacity 8과 최대 8화차의 기존 계약을 하나의 의미로 통합한다.
3. 적재·하역이 열차 실루엣을 즉시 바꿔 핵심 행동의 손맛을 강화한다.
4. 현재 `set_wagon_count()` API가 있어 코어 라우팅 재설계 없이 연결 가능하다.
5. 열차 길이·spawn 공정성 위험은 자동 테스트와 VS-03B 화면 검증으로 측정할 수 있다.

보호 조건:

- wagon count 변화의 권위는 CargoStack 변경 직후 도메인 동기화이며 애니메이션 완료가 아니다.
- 적재 순서와 화차 시각 순서는 HUD Unload Order와 모순되지 않아야 한다.
- wagon 추가/제거 뒤 `train_cells()`·spawn 금지 칸을 즉시 갱신한다.
- 0화물에서는 기관차만 표시한다.
- 8화물의 작은 맵 밀도·자기 겹침·터치 가독성을 VS-03B/VS-04에서 검증한다.

## Decision Queue

1. `SX-DEC-014` Combo 정의 — `CONFIRMED · SYNCED · CLOSED`
2. `SX-DEC-015` 화물·화차 시각/기능 관계 — `NOW · BLOCKS VS-03B`
3. `SX-DEC-016` 첫 세션 온보딩 방식 — `LATER · BLOCKS USER PLAYTEST`
4. 세계·마스코트 상세 범위 — 현재 VS에서는 `DEFERRED_WITH_BOUNDARY` 권장

## 자동 보완 반영

- 프로젝트 Skill의 읽기 순서·구현 경계를 Post-VS02로 갱신
- 플레이테스트 퍼센트에 실제 명수·ceil 판정 병기
- telemetry를 cargo_type·color·shape·unload_group_size 기반으로 확장
- Combo와 speed bonus를 점수·HUD·저장·telemetry에서 분리
- 오디오·햅틱 사건 우선순위와 mute/haptic-off fallback 권장 계약 작성
- 목표 세션 시간과 경제 수치는 `TEST_VALUE`로 유지
- 마스터 구현 계획의 완료 상태·main·Task 6~8 소비자 최신화
- Vertical Slice 계약에 Combo 의미·제외 범위·품질 기준 반영
- Registry의 현행 감사 권위를 `SX-AUD-004`로 단일화

## 현재 Gate

`USER_DECISION_REQUIRED · SX-DEC-015 · CODEX_NOT_READY`

`SX-DEC-014`는 canonical commit과 Google Sheets 12개 탭 readback까지 `SYNCED`다. 다음 작업은 `SX-DEC-015`이며, VS-03 구현은 전체 필수 Decision과 G3P가 닫힌 뒤에만 시작한다.
