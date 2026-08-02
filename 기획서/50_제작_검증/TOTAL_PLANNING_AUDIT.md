# Switchy Express 총기획 Coverage·충돌 감사

```yaml
audit_id: SX-AUD-004
status: IN_PROGRESS · GRILL_ME_REQUIRED
baseline_main: 474bef445c2cf5e501bd7478e26a5b8d0dfe26f1
work_mode: TOTAL_PLANNING · REVIEW
implementation_authority: PLANNING_AND_DOCUMENTATION_ONLY
sheet_state: SYNCED_AT_8245e22905d64e22b599fe009bbb660d005392ed
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
| 프로젝트·운영 | 정본·Sheet 동기화 완료 | 새 작업자가 VS-02 완료와 다음 Gate 복원 가능 | 프로젝트 Skill이 Post-VS01과 오래된 구현 경계를 가리킴 | AUTO_FIX_ELIGIBLE |
| 제품·타깃 | 모바일 캐주얼·짧은 세션·기록 경쟁 | 제품 약속은 선명함 | 목표 세션 시간·첫 세션 기대 결과가 정본에 수치화되지 않음 | TEST_VALUE_REQUIRED |
| 핵심 플레이 | 자동운행→LOAD→분기→LIFO | 독립 기술 계약과 테스트가 존재 | 콤보의 정확한 의미가 문서·점수·저장 사이에서 불명확 | USER_DECISION_REQUIRED |
| 화물·화차 | capacity 8·최대 8화차 | 코드가 wagon count와 cargo count를 모두 제공 | 한 화물=한 화차인지, 빈 화차가 존재하는지, 화차 증감 시점 미정 | USER_DECISION_REQUIRED |
| 생존 경제 | 시간·무게·BOOST 위험 교환 | 시험 공식과 악용 방지 가설 존재 | 수치는 미검증이며 콤보 정의가 reward/max_combo를 차단 | BLOCKED_BY_DECISION_AND_TEST |
| 실패·복구 | 연료 0→결과→재시작 | 즉시 재도전 방향 명확 | 결과 화면이 보여줄 실패 원인·학습 정보 우선순위 미정 | NEEDS_IMPROVEMENT |
| 온보딩 | 3분 내 LIFO 이해 목표 | 테스트 가설 존재 | 분기·LOAD·LIFO 학습 순서와 도움 방식 미정 | USER_DECISION_REQUIRED 후보 |
| UX·HUD | 상단 상태·하단 입력·경로 강조 | 정보 위계와 접근성 방향 존재 | 화차/화물 표현, 콤보 표기, 시간 압박 경고, 일시정지 흐름 미정 | BLOCKED_BY_DECISIONS |
| 아트·모션 | 승인 콘셉트와 모션 비권위 | 시각 Pillar가 명확 | 실제 자산·카메라·밀도·이펙트는 런타임 미검증 | TEST_IN_VERTICAL_SLICE |
| 오디오·햅틱 | mute·haptic-off fallback 언급 | 대체 경로 원칙 존재 | 어떤 사건을 소리·진동으로 전달할지 책임 계약 없음 | UNDERDESIGN |
| 세계·서사 | 토끼 기관사·미니어처 철도 | 제품 호감과 테마에 충분 | VS에서 이름·서사를 어느 수준까지 구현할지 미정 | DEFERRED_WITH_BOUNDARY 가능 |
| 데이터·저장 | best score/time/combo·schema version | 최소 메타 범위가 작고 명확 | max_combo 의미, 손상·버전 fallback 상세 부족 | PARTIAL_BLOCKED_BY_COMBO |
| 텔레메트리 | 핵심 이벤트 목록 존재 | 시스템 가설과 연결됨 | `color` 중심 필드가 색상+모양 계약을 충분히 표현하지 못함 | AUTO_FIX_ELIGIBLE |
| 플레이테스트 | 5명+·핵심 과제 존재 | 성공·실패 신호가 구체적 | 70%·50%는 5명 표본에서 직접 성립하지 않아 판정 규칙 모호 | AUTO_FIX_ELIGIBLE |
| 성능·접근성 | 60 FPS 목표·48dp·색+모양 | 목표 품질 Gate 존재 | 기기·해상도·사람 증거 없음 | BLOCKED_UNVERIFIED |
| 제작·인계 | VS-03A→VS-03B→VS-04 | 책임 분리·테스트 순서 명확 | 중요 Decision 미완료로 Codex 계약 확정 불가 | CODEX_NOT_READY |

## Finding Ledger

| ID | 유형 | 문제 | 영향 | 판정 | 처리 |
|---|---|---|---|---|---|
| SX-AUD-004-F01 | PLANNING_CONFLICT | 콤보가 단일 하역 그룹 크기인지 연속 배송 streak인지 불명확 | 점수·HUD·`max_combo`·저장·텔레메트리 차단 | USER_DECISION_REQUIRED | `SX-DEC-014` Grill Me |
| SX-AUD-004-F02 | UNDERDESIGN | cargo count와 visible wagon 관계 미정 | 열차 실루엣·무게 가독성·애니메이션·저장 표현 충돌 | USER_DECISION_REQUIRED | F01 이후 Grill Me 후보 |
| SX-AUD-004-F03 | UNDERDESIGN | 첫 세션 학습 순서·도움 방식 미정 | LIFO·분기 실패가 판단이 아닌 이해 실패가 될 위험 | USER_DECISION_REQUIRED 후보 | F01/F02 뒤 판정 |
| SX-AUD-004-F04 | STALE_REFERENCE | 프로젝트 Skill이 Post-VS01과 구형 구현 경계 사용 | 새 작업자의 잘못된 사실 복원 | MUST_FIX | 현재 PR에서 수정 |
| SX-AUD-004-F05 | MEASUREMENT_GAP | 5명 표본에 70%·50% 기준 | 성공 판정 반올림·자의성 | SHOULD_FIX | 명수 기준 병기 |
| SX-AUD-004-F06 | ACCESSIBILITY_RISK | telemetry가 `color`만 기록 | 색상+모양 오류 원인 분리 불가 | SHOULD_FIX | `cargo_type`·shape 포함 |
| SX-AUD-004-F07 | UNDERDESIGN | 오디오·햅틱 사건 우선순위 부재 | mute/haptic-off fallback과 실제 정보 설계 연결 끊김 | SHOULD_FIX | 표현 본책에 권장 계약 작성 |
| SX-AUD-004-F08 | UNPROVEN_ASSUMPTION | 속도·연료·보상·목표 세션 수치 | 영구 생존·상시 BOOST·피로 위험 | RESEARCH_OR_TEST_REQUIRED | TEST_VALUE·시뮬레이션·플레이테스트 |
| SX-AUD-004-F09 | PRODUCTION_RISK | 15×10에 역6·화물12+·분기·HUD의 실제 밀도 미검증 | 작은 화면 정보 과부하 | TEST_IN_VERTICAL_SLICE | VS-03B 캡처·Android 검증 |
| SX-AUD-004-F10 | MISSING_CANON | 총기획 감사와 Decision Queue의 현행 책임 문서 부재 | 기획 공백·보완 진행 추적 불가 | MUST_FIX | 이 문서를 현재 감사 원본으로 등록 |

## 콤보 충돌 근거

현재 정본과 소비자는 다음을 동시에 사용한다.

- `같은 색 연속 하역 콤보`
- 하역 결과의 `count`
- 점수표의 `연속 하역`
- HUD의 `Combo`
- 저장 대상의 `max_combo`
- 플레이테스트 이벤트의 `combo_size`
- 빠른 배송 보너스와 이전 배송 이후 시간

그러나 “한 번의 역 도착에서 연속으로 내린 동일색 화물 수”와 “여러 번의 배송을 끊기지 않고 이어간 횟수”가 분리돼 있지 않다. 두 정의는 점수 공식·상태 수명·HUD·저장·실패 조건을 다르게 만든다.

## 개선안 비교 — SX-AUD-004-F01

### A. 하역 그룹 크기만 Combo

- `combo_count = 이번 역 도착에서 연속 하역한 화물 수`
- `max_combo = 한 번에 하역한 최대 화물 수`
- 빠른 연속 배송은 기존 `speed_bonus`로 별도 처리
- 장점: LIFO 핵심과 직접 연결, 이해·테스트·HUD가 단순, 현재 `combo_size`와 자연스럽게 일치
- 단점: 장기 streak 긴장감은 약함

### B. 연속 배송 streak만 Combo

- 일정 시간 안에 유효 배송을 이어갈 때 증가
- 한 번에 내린 화물 수는 `unload_group_size`로 별도 표기
- 장점: 장기 운행 압박과 숙련 보상
- 단점: LIFO보다 시간 관리가 전면화되고 상태·리셋·HUD가 복잡

### C. 그룹 Combo + 배송 Chain 이중 체계

- 한 번의 하역 크기와 연속 배송 streak를 모두 보상
- 장점: 가장 풍부한 점수 전략
- 단점: 초기 Vertical Slice에서 정보·밸런스·UI 복잡도가 크고 핵심 학습을 흐릴 위험

## GPT 권장안

`A. 하역 그룹 크기만 Combo`를 권장한다.

이유:

1. 플레이어가 계획하는 LIFO 순서와 직접 인과가 있다.
2. 기존 하역 결과 `count`, `combo_size`, `max_combo`를 하나의 의미로 맞출 수 있다.
3. 연속 배송의 긴장감은 이미 `speed_bonus`로 시험 가능하다.
4. 나중에 반복 플레이가 단조롭다는 증거가 생기면 `Delivery Chain`을 별도 시스템으로 추가할 수 있어 되돌리기 쉽다.
5. 모바일 첫 세션의 정보량을 줄인다.

## Decision Queue

1. `SX-DEC-014` 콤보 정의 — NOW · BLOCKS VS-03A
2. `SX-DEC-015` 화물·화차 시각/기능 관계 — NEXT · BLOCKS VS-03B
3. `SX-DEC-016` 첫 세션 온보딩 방식 — LATER · BLOCKS USER PLAYTEST
4. 세계·마스코트 상세 범위 — 현재 VS에서는 `DEFERRED_WITH_BOUNDARY` 권장, 재검토 가능

## 자동 보완 예정

- 프로젝트 Skill의 읽기 순서·구현 경계를 Post-VS02로 갱신
- 플레이테스트 퍼센트에 실제 명수 판정 병기
- telemetry의 `color`를 `cargo_type`·shape-aware 계약으로 확장
- 오디오·햅틱 사건 우선순위의 권장 계약 작성
- 목표 세션 시간과 경제 수치는 `TEST_VALUE`로만 작성

## 현재 Gate

`USER_DECISION_REQUIRED · SX-DEC-014`

사용자 답변 전에는 콤보 의미·점수 상태·`max_combo` 저장 계약을 확정하거나 VS-03A를 `READY_FOR_BUILD`로 승격하지 않는다.
