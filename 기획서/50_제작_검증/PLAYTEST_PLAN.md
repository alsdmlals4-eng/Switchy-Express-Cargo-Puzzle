# Playtest Plan

```yaml
status: CURRENT_CANON · MANUAL_ACCEPTANCE_NOT_RUN
product_authority: GMB-002 · SX-DEC-027~036
current_audit: SX-AUD-019
current_evidence: EV-FP-APK-001
canonical_export_source: 536911449018a3caf3511bc64e7bf1a66edf2016
apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
android_device_smoke: NOT_RUN
five_person_comprehension: NOT_RUN · BLOCKED_BY_ANDROID
production_cutover: BLOCKED
```

## 1. Gate 순서

```text
ANDROID DEVICE SMOKE reviewed PASS
→ FIVE-PERSON COMPREHENSION
→ result completeness·privacy·adversarial review
→ GitHub canon and correct Sheet same-ID closure
→ separate production cutover review
```

이 문서는 처음 보는 5명의 finite delivery puzzle 이해도를 검증한다. Android Device Smoke와 동일한 canonical APK 전체 hash를 사용해야 하며, Android reviewed PASS 전에는 사람 검증을 시작하지 않는다.

## 2. 검증 가설

1. 사용자는 마지막에 적재한 화물이 `TOP`이며 다음 하역 후보임을 설명한다.
2. 사용자는 `A → B → A → A` 적재에서 A역 재방문이 필요한 이유를 LIFO 순서로 설명한다.
3. 사용자는 선로가 화물 조우 순서를 만들고 분기가 역 방문 순서를 실행한다는 관계를 이해한다.
4. 사용자는 수동 적재 홀드와 자동 적재 토글의 차이를 이해한다.
5. 사용자는 TOP부터 같은 종류가 연속된 그룹만 하역된다는 규칙을 이해한다.
6. 사용자는 실패 뒤 같은 노선 재시도와 노선 수정 후 재시도를 구분한다.
7. 사용자는 색상 없이도 형상·텍스트·TOP 표식으로 화물과 역을 구분한다.
8. 사용자는 성공 원인을 반사 속도가 아니라 노선·적재 순서·분기 실행으로 설명한다.

## 3. 참가자와 개인정보

- 첫 경험 사용자 5명
- 모바일 캐주얼 퍼즐 경험자와 비경험자 혼합
- 참가자 식별자는 `P01`~`P05`만 사용
- 실명, 연락처, 계정, 얼굴과 불필요한 개인정보 저장 금지
- 기기는 `D01` 같은 별칭만 기록
- 진행자는 조작 불능·명백한 오류 외에는 해답 힌트를 제공하지 않음
- 참가자 발언, 실제 행동과 진행자 해석을 분리 기록

## 4. 공통 환경

```yaml
apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
package_id: com.alsdmlals4.switchyexpress.validation
mode: PROOF
device_requirement: Android Smoke에서 reviewed PASS한 physical device 또는 동등 조건의 검증 기기
orientation: landscape
input_method: touch
solution_coaching: PROHIBITED
```

새 APK가 생성되면 기존 사람 증거를 승계하지 않고 새 hash로 다시 수행한다.

## 5. 참가자별 절차

### 시작 전

1. 게임 규칙과 정답 노선을 설명하지 않는다.
2. “화물을 모두 배송하는 선로 퍼즐”이라는 최소 목적만 전달한다.
3. 참가자가 화면과 조작을 스스로 탐색하게 한다.
4. 녹화 동의와 개인정보 비노출 상태를 확인한다.

### 세션

1. 불완전 노선에서 Start 가능 여부와 preflight 피드백을 확인한다.
2. 선로를 건설해 구조 검사를 통과한다.
3. 수동 적재 또는 자동 적재를 사용해 화물을 싣는다.
4. 운행 중 분기를 직접 탭해 다음 경로를 설정한다.
5. pause/resume을 사용한다.
6. 성공 또는 실패 결과를 확인한다.
7. 실패 시 같은 노선 재시도와 노선 수정 중 하나를 선택한다.
8. 결과 뒤 자유 회고 질문에 답한다.

진행자는 버튼 위치를 찾지 못해 세션이 완전히 중단될 때만 조작 위치를 알려줄 수 있다. 경로, 적재 순서, 역 방문 순서와 정답은 알려주지 않는다.

## 6. 필수 질문

각 참가자에게 다음 질문을 같은 표현으로 제시한다.

1. “지금 적재된 화물 중 다음 역에서 가장 먼저 내려갈 화물은 무엇이며, 왜 그런가?”
2. “A, B, A, A 순서로 실었다면 A역을 왜 한 번 더 방문해야 하는가?”
3. “화물을 만나는 순서는 무엇이 결정하고, 역을 방문하는 순서는 무엇이 결정하는가?”
4. “수동 적재와 자동 적재는 어떻게 다른가?”
5. “역에 도착했을 때 어떤 화물이 한 번에 함께 내려가는가?”
6. “실패 후 같은 노선 재시도와 노선 수정은 어떤 차이가 있는가?”
7. “색상을 보지 않고도 TOP과 화물 종류를 어떻게 구분할 수 있는가?”
8. “이번 성공 또는 실패의 가장 큰 원인은 무엇이라고 생각하는가?”

## 7. 필수 관찰

- 첫 BUILD에서 place·rotate·replace·remove 사용 여부
- preflight 실패 이유와 문제 cell 이해 여부
- 수동 적재 홀드 성공 여부
- 자동 적재 상태 이해 여부
- 운행 중 분기 직접 탭 성공 여부
- 점유 분기 잠금 오해 여부
- pause 뒤 상태 연속성 이해 여부
- TOP과 bottom-to-TOP 순서 식별
- A역 재방문 이유 이해
- 결과 원인 귀인
- 실패 후 retry/edit 선택과 이유
- 색상 외 형상·텍스트 사용
- 조작 실수와 규칙 판단 실수 분리

## 8. 참가자 기록표

| Participant | Device | TOP 설명 | A 재방문 설명 | 선로/분기 관계 | 적재 모드 차이 | Retry/Edit 구분 | 색상 외 식별 | 원인 귀인 | 주요 오해 | 상태 |
|---|---|---|---|---|---|---|---|---|---|---|
| P01 | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | | NOT_RUN |
| P02 | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | | NOT_RUN |
| P03 | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | | NOT_RUN |
| P04 | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | | NOT_RUN |
| P05 | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | | NOT_RUN |

상태는 `PASS`, `FAIL`, `BLOCKED`, `NOT_RUN` 중 하나만 사용한다.

## 9. 합격 기준

최소 표본 5명에서 다음을 모두 만족해야 한다.

| ID | 기준 | 합격 |
|---|---|---:|
| HUM-01 | 마지막 적재 화물이 TOP이라고 설명 | 4/5 이상 |
| HUM-02 | `A/B/A/A`에서 A역 재방문 이유 설명 | 4/5 이상 |
| HUM-03 | 선로=조우 순서, 분기=방문 실행 관계 설명 | 4/5 이상 |
| HUM-04 | 수동 적재와 자동 적재 차이 설명 | 4/5 이상 |
| HUM-05 | TOP 연속 동일 종류 그룹 하역 설명 | 4/5 이상 |
| HUM-06 | same-layout retry와 edit 차이 이해 | 4/5 이상 |
| HUM-07 | 형상·텍스트로 TOP과 종류 식별 | 4/5 이상 |
| HUM-08 | 성공 원인을 노선·적재·분기에 귀인 | 4/5 이상 |
| HUM-09 | 활성 분기 방향을 반대로 이해하는 치명 오해 | 0/5 |
| HUM-10 | 진행자 해답 개입이 필요한 세션 | 0/5 |

5명보다 많으면 각 `4/5` 기준은 `ceil(참가자 수 × 0.8)`로 계산한다.

## 10. 전체 Gate 판정

```text
PASS: P01~P05 전원 실행 + HUM-01~10 모두 합격 + 동일 APK hash + 증거 연결 + P0/P1 finding 0
FAIL: 실행 가능한 상태에서 하나 이상의 HUM 기준 실패
BLOCKED: Android Gate, 동일 APK, 기기, 참가자 또는 증거 선행 조건 부족
NOT_RUN: 하나 이상의 참가자나 필수 질문·관찰 미실행
```

일부 참가자만 실행하거나 질문·관찰이 누락되면 전체 Gate는 PASS가 아니다.

## 11. 증거 형식

```yaml
session_id:
participant_alias:
device_alias:
apk_sha256:
started_at:
ended_at:
facilitator_alias:
question_answers:
observed_actions:
control_failures:
rule_misunderstandings:
facilitator_interventions:
recording_reference:
screenshot_references:
participant_result: PASS | FAIL | BLOCKED | NOT_RUN
```

영상·음성 원본을 공개 저장소에 올릴 필요가 없다. 안전한 위치와 최소 참조, redacted excerpt만 기록한다.

## 12. 실패 신호와 후속

- TOP을 열차의 앞쪽 또는 첫 적재 화물로 이해
- 같은 종류가 stack 내부에 있어도 모두 하역된다고 이해
- 선로 건설과 분기 조작의 역할을 혼동
- 수동 적재를 순간 반응 성공 여부로만 인식
- 실패 뒤 노선이 보존된다는 사실을 이해하지 못함
- Retry가 같은 mutable runtime을 이어간다고 오해
- 색상만으로 화물과 역을 판단
- 성공을 우연 또는 빠른 탭에만 귀인
- 진행자 힌트가 정답 노선에 영향을 줌

실패가 있으면 원인에 따라 UI 문구·형상·조작·규칙 설명 또는 제품 계약 finding으로 분류한다. 수정이 필요하면 별도 TDD package와 새 APK를 생성하고 Android·HUMAN Gate를 새 hash에서 다시 수행한다.

## 13. 현재 결론

```text
ANDROID DEVICE SMOKE: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN · BLOCKED_BY_ANDROID
DEFAULT ENTRYPOINT: LEGACY
PRODUCTION CUTOVER: BLOCKED
```

현재 문서는 실행 가능한 계획 정본이며 실제 사람 증거가 아니다.
