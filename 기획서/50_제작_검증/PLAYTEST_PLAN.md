# Playtest Plan

```yaml
status: CURRENT_CANON · PHASE_A_PLANNING · MANUAL_ACCEPTANCE_NOT_RUN
product_authority: GMB-002 · SX-DEC-027~055
planning_audit: SX-AUD-044
acceptance_build_state: UNASSIGNED_UNTIL_AUTHORIZED_IMPLEMENTATION_MERGE
acceptance_build_source_commit: UNASSIGNED
acceptance_build_sha256: UNASSIGNED
physical_acceptance_smoke: NOT_READY
five_person_comprehension: NOT_RUN · BLOCKED_BY_ACCEPTANCE_BUILD_AND_PHYSICAL_SMOKE
production_cutover: BLOCKED_DEFERRED
```

이 문서는 **현재 제품의 첫 세션 이해도와 사람 검증 방법**을 책임진다. 실제 사람 증거가 아니라 Phase A의 사전 acceptance contract다.

과거 Android validation APK는 별도 역사/진단 증거로 보존한다. post-SX-DEC-055 사람 검증의 active build identity로 자동 승격하지 않는다.

## 1. 절대 Gate 순서

```text
PHASE A planning complete
→ explicit user "기획 완료"
→ PHASE B final planning review
→ authorized SX-DEC-055 runtime semantic implementation
→ exact-head automated POC evidence + merge
→ acceptance build identity assignment
→ reviewed physical smoke on that exact acceptance build
→ FIVE-PERSON COMPREHENSION
→ evidence completeness/privacy/adversarial review
→ separate production/cutover decision
```

자동화 POC, export 생성, Android validation harness, 실제 제품 build 물리 실행, 사람 이해도는 서로 다른 증거다.

## 2. Historical Android Validation Harness Evidence

아래 값은 당시 validation-harness 패키징/해시 정합성 증거이며 삭제하지 않는다.

```yaml
historical_source_commit: 536911449018a3caf3511bc64e7bf1a66edf2016
historical_apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
historical_package_id: com.alsdmlals4.switchyexpress.validation
historical_android_device_smoke: NOT_RUN
role: HISTORICAL_VALIDATION_HARNESS · NOT_POST_POC_HUMAN_ACCEPTANCE_BUILD
```

- 전용 `ANDROID_DEVICE_SMOKE_RUNBOOK.md`와 Evidence Template은 이 historical validation-harness lane의 fixed-hash 계약을 계속 소유한다.
- 이 APK는 `SX-DEC-055` runtime semantic POC 이전 presentation이다.
- 따라서 이 APK로 이후 Five-person Comprehension을 실행해도 post-POC presentation 이해도 PASS가 되지 않는다.

## 3. Post-POC Acceptance Build Identity

현재 Phase A에서는 미래 build를 발명하지 않는다.

```yaml
acceptance_build_state: UNASSIGNED_UNTIL_AUTHORIZED_IMPLEMENTATION_MERGE
source_commit: UNASSIGNED
artifact_platform: ANDROID_PRIMARY
artifact_sha256: UNASSIGNED
package_identity: UNASSIGNED
sx_dec_055_runtime_requirement: MERGED_AUTOMATED_POC_EVIDENCE
physical_smoke: NOT_RUN
human_comprehension: NOT_RUN
```

### Identity rules

1. v4.5 user Gate와 Phase B 전에 build identity를 채우지 않는다.
2. `SX-DEC-055` 구현이 current main에 병합되고 automated POC evidence가 닫힌 뒤 exact source/artifact identity를 지정한다.
3. 사람 세션은 해당 comprehension round의 reviewed physical smoke와 **동일한 exact acceptance build identity**를 사용한다.
4. 테스트 대상 학습/UI/input/semantic feedback에 영향을 주는 player-facing 변경이 생기면 이전 사람 증거를 자동 승계하지 않는다.
5. PC physical smoke는 진단/보조 증거가 될 수 있지만 Android-oriented Five-person Comprehension을 PC-only 증거로 대체하지 않는다.

## 4. 연구 목적

첫 경험 사용자가 설명을 암기했는지가 아니라, 이미 승인된 제품 규칙을 **스스로 발견하고 다음 행동을 예측하며 다른 상태에 전이**할 수 있는지 확인한다.

핵심 연구 질문:

1. 현재 목표와 남은 배송을 이해하는가?
2. BUILD·preflight 피드백으로 스스로 노선을 고칠 수 있는가?
3. 선로가 화물 조우 순서를 만든다는 인과를 이해하는가?
4. manual/auto load 상태를 의도적으로 선택하고 읽는가?
5. 마지막 적재 화물을 TOP으로 예측하는가?
6. TOP부터 연속된 같은 종류만 함께 하역된다고 예측하는가?
7. 분기에서 선택 방향과 점유 잠금을 올바르게 읽는가?
8. 실패 원인에 따라 Retry와 Edit를 구분하는가?
9. 색상을 보지 않아도 shape/text/TOP 신호를 사용해 식별하는가?
10. pickup/unload/route/terminal semantic feedback을 실제 사건과 올바르게 연결하는가?
11. 한 번 경험한 규칙을 이후 바뀐 stack/route/switch 상태에 독립 적용하는가?

## 5. Learning Model — RULE → NEED → DISCOVER → FEEL → PROVE → TRANSFER

| Target | RULE | NEED / DISCOVER | PROVE | TRANSFER |
|---|---|---|---|---|
| Objective | 제한 시간 안에 모든 필수 배송 | goal/progress context | 도움 없이 유효한 시도를 시작 | 부분 run 뒤 남은 목표 식별 |
| Build/preflight | 구조적으로 도달 가능해야 시작 | placement/problem feedback | blocking issue를 스스로 수정 | 뒤의 다른 blocking state도 진단 |
| Encounter order | 경로가 화물 조우 순서를 결정 | route와 실제 조우 비교 | 다음 조우 화물을 예측 | route/load 선택 변경 후 결과 예측 |
| LIFO TOP | 마지막 적재가 TOP | stack/TOP presentation | 역 도착 전 다음 하역 후보 예측 | stack 변화 뒤 다시 예측 |
| Unload group | TOP 연속 동일 종류만 하역 | 하역 후 남은 stack 관찰 | 하역 그룹/수량 예측 | 뒤의 다른 stack 상태에 적용 |
| Load mode | manual hold / auto toggle 상태 차이 | 실제 input-state presentation | 의도한 방식으로 적재 | 이후 접촉에서 상태가 다르면 인지/복구 |
| Switch | 선택 방향이 다음 경로, 점유 중 잠금 | arrow + semantic reinforcement | 의도 경로를 선택 | 뒤의 다른 switch state 결과 예측 |
| Retry/Edit | Retry=같은 layout fresh runtime, Edit=노선 수정 | result choice | 문제 유형에 맞는 선택 | 다른 실패 원인에서 선택 변경 |
| Redundant identity | 색상 단독 아님 | shape/text/TOP | 색상 없이도 식별 | 뒤의 상태에서도 재식별 |
| Causal feedback | semantic feedback은 실제 event를 설명 | pickup/unload/route/terminal feedback | 올바른 사건에 귀인 | 장식과 gameplay authority를 혼동하지 않음 |

## 6. 참가자 계약

```yaml
research_goal: FIND_COMPREHENSION_AND_USABILITY_PROBLEMS
approved_gate_name: FIVE-PERSON COMPREHENSION
recruit_target: 6 · TEST_VALUE
minimum_analyzable_first_contact_sessions: 5
prior_exposure_to_acceptance_build: NONE
participant_aliases: P01..P06
solution_coaching: PROHIBITED
```

- `recruit_target=6`은 문제 발견 목적의 실무 buffer이며 제품 규칙이 아니다.
- 최소 분석 가능 세션은 기존 Gate대로 5명이다.
- P01, P02, P03, P04, P05는 최소 표본 예시이며 P06까지 유효하게 완료되면 P06도 분석한다.
- 모바일 캐주얼 퍼즐 경험 정도는 다양하게 모집하되 exact acceptance build 사전 노출자는 제외한다.
- 실명·연락처·계정 등 불필요한 개인정보를 기록하지 않는다.
- device/tester는 `D01`, `P01` 같은 alias를 사용한다.

## 7. 진행자 계약

시작 전 최소 목적만 전달한다.

```text
화물을 모두 알맞은 역에 배송하는 선로 퍼즐입니다. 화면을 보며 원하는 방식으로 진행해 주세요.
```

미리 설명하지 않는 것:

- 정답 노선
- LIFO/TOP 정답
- 하역 그룹 규칙의 정답 문장
- 최적 load mode
- 분기 정답 방향
- 실패 뒤 어떤 recovery 선택이 정답인지

허용되는 neutral probe:

- `지금 무슨 일이 일어나고 있다고 생각하나요?`
- `현재 목표가 무엇이라고 생각하나요?`
- `다음에는 무엇을 할 생각인가요?`
- `왜 그렇게 생각했나요?`
- `이 표시가 무엇을 뜻한다고 생각하나요?`

진행자는 참가자의 답이 맞는지 확인·부정하지 않는다. 해결에 필요한 사실을 직접 알려준 경우 해당 task를 `INTERVENTION_CONTAMINATED`로 기록하고 독립 수행 PASS 근거로 사용하지 않는다.

## 8. 행동 우선 증거 채널

각 관찰은 다음을 분리 기록한다.

```yaml
observed_behavior:
prediction_before_outcome:
post_task_explanation:
moderator_intervention:
control_or_motor_issue:
comprehension_issue:
visual_readability_issue:
participant_self_report:
```

자기보고가 긍정적이어도 관찰 행동과 반복 예측이 충돌하면 이해했다고 단정하지 않는다.

## 9. 필수 Observation Matrix

| ID | Observation | PASS evidence example |
|---|---|---|
| FS-01 | objective/progress | 현재 목표·남은 배송을 행동/설명으로 식별 |
| FS-02 | BUILD + preflight | blocking layout을 해결책 힌트 없이 수정 |
| FS-03 | route → encounter order | 다음 조우 또는 route 변경 결과를 사전 예측 |
| FS-04 | manual/auto state | 모드를 의도적으로 선택하고 현재 상태를 읽음 |
| FS-05 | TOP prediction | station 결과 전 next unload cargo를 예측 |
| FS-06 | contiguous group | unload group/count를 결과 전에 예측 |
| FS-07 | switch selected/locked | 선택 방향과 occupied lock 의미를 올바르게 행동에 반영 |
| FS-08 | Retry vs Edit | execution 문제와 route-design 문제에 맞는 recovery 선택 |
| FS-09 | non-color identification | shape/text/TOP으로 cargo/station/state 식별 |
| FS-10 | causal semantic feedback | pickup/unload/route/terminal feedback을 실제 event에 귀인 |
| FS-11 | transfer | later changed stack/route/switch 상태에서 새 설명 없이 규칙 적용 |
| FS-12 | independent core proof | solution-relevant intervention 없이 필수 core proof 수행 |

`FS-11`은 새 production map을 요구하지 않는다. 같은 대표 stage 안의 뒤 상태, Retry 또는 Edit로 바뀐 stack/route/switch 상황을 사용한다.

## 10. Post-task 질문

행동·예측 기록 뒤에만 사용한다.

1. `이번 run에서 가장 중요한 목표가 무엇이라고 생각했나요?`
2. `다음 역에서 가장 먼저 내려갈 화물을 어떻게 판단했나요?`
3. `선로를 바꾸면 무엇이 바뀐다고 생각하나요?`
4. `수동 적재와 자동 적재의 차이를 어떻게 이해했나요?`
5. `한 역에서 여러 화물이 같이 내려갈 때 어떤 규칙이 있었다고 생각하나요?`
6. `분기 화살표/잠금 표시는 각각 무엇을 뜻한다고 생각했나요?`
7. `Retry와 Edit 중 어떤 상황에서 각각 쓰고 싶나요?`
8. `색상을 제외하면 어떤 표시로 화물·역·TOP을 구분했나요?`
9. `방금 나온 시각 효과가 무엇 때문에 발생했다고 생각하나요?`
10. `이번 성공/실패의 가장 큰 원인은 무엇이라고 생각하나요?`

질문 정답률은 행동 증거를 보조하며 대체하지 않는다.

## 11. 참가자 기록표

| Participant | Build ID | FS-01 | FS-02 | FS-03 | FS-04 | FS-05 | FS-06 | FS-07 | FS-08 | FS-09 | FS-10 | FS-11 | FS-12 | 주요 오해 | 상태 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| P01 | UNASSIGNED | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | | NOT_RUN |
| P02 | UNASSIGNED | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | | NOT_RUN |
| P03 | UNASSIGNED | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | | NOT_RUN |
| P04 | UNASSIGNED | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | | NOT_RUN |
| P05 | UNASSIGNED | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | | NOT_RUN |
| P06 | UNASSIGNED | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | | NOT_RUN |

상태는 `PASS`, `FAIL`, `BLOCKED`, `NOT_RUN`, `INTERVENTION_CONTAMINATED` 중 하나를 사용한다.

## 12. 합격 기준

기본 최소 표본 5명에서는 threshold `4/5`를 사용한다. 6명 이상 유효 세션을 모두 분석할 때는 `ceil(N × 0.8)`로 계산한다.

| ID | 기준 |
|---|---|
| HUM-01 | FS-01 objective/progress threshold 충족 |
| HUM-02 | FS-03 route→encounter model threshold 충족 |
| HUM-03 | FS-05 LIFO TOP prediction threshold 충족 |
| HUM-04 | FS-06 contiguous unload prediction threshold 충족 |
| HUM-05 | FS-04 load-mode state threshold 충족 |
| HUM-06 | FS-07 selected switch direction/occupied lock threshold 충족 |
| HUM-07 | FS-08 Retry/Edit recovery model threshold 충족 |
| HUM-08 | FS-09 non-color identification threshold 충족 |
| HUM-09 | FS-10 causal feedback attribution threshold 충족 |
| HUM-10 | FS-11 independent transfer threshold 충족 |
| HUM-11 | 반복되는 치명적 reverse-switch-direction mental model = 0 analyzable sessions |
| HUM-12 | core proof 완료를 위해 solution-relevant moderator help 필요 = 0 analyzable sessions |
| HUM-13 | unresolved P0/P1 comprehension/accessibility finding = 0 |

모든 필수 build identity·physical-smoke 연결·관찰 기록이 없으면 전체 Gate는 PASS가 아니다.

## 13. Finding Severity

### P0 / Critical

- solution-relevant moderator intervention 없이는 진행 불가
- selected switch direction을 반복적으로 반대로 이해해 core route를 수행할 수 없음
- color 없이 필수 cargo/station/TOP 식별 불가
- 의도된 presentation 경험 뒤에도 LIFO/TOP 규칙을 추론할 수 없음
- acceptance build crash/input loss 등으로 증거가 무효화됨

### P1 / High

- 우연/무작위 반복으로 통과하지만 reusable route/LIFO mental model 형성 실패
- FS-11 transfer 실패
- manual/auto/preflight state 반복 오독으로 계획이 지속적으로 탈선
- semantic feedback이 잘못된 원인을 전달하거나 authoritative text/procedural state와 충돌

### P2 / Medium

- core proof를 막지는 않지만 반복 hesitation·문구·밀도·가독성 문제가 있음

### P3 / Low

- comprehension/accessibility 결과에 영향이 증명되지 않은 취향·polish finding

## 14. 전체 Gate 판정

```text
PASS:
  exact acceptance build identity assigned
  + required physical smoke reviewed PASS on that identity
  + minimum 5 analyzable first-contact sessions
  + HUM-01~13 all satisfied
  + evidence/privacy/adversarial review complete

FAIL:
  executable valid study where one or more required HUM criteria fail

BLOCKED:
  acceptance build / physical smoke / participant / evidence prerequisite missing

NOT_RUN:
  study has not been executed
```

현재 상태는 `NOT_RUN · BLOCKED_BY_ACCEPTANCE_BUILD_AND_PHYSICAL_SMOKE`다.

## 15. 증거 형식

```yaml
session_id:
participant_alias:
device_alias:
acceptance_build_source_commit:
acceptance_build_sha256:
started_at:
ended_at:
facilitator_alias:
observed_behavior:
predictions_before_outcome:
post_task_answers:
moderator_interventions:
control_or_motor_issues:
comprehension_issues:
visual_readability_issues:
recording_reference:
screenshot_references:
participant_result: PASS | FAIL | BLOCKED | NOT_RUN | INTERVENTION_CONTAMINATED
```

영상·음성 원본을 공개 저장소에 올릴 필요가 없다. 안전한 위치와 최소 참조, redacted excerpt만 기록한다.

## 16. 변경 후 증거 무효화 규칙

다음 변경이 tested learning target에 영향을 주면 해당 human evidence는 자동 승계하지 않는다.

- stack/TOP/load/preflight/switch semantic presentation
- target/click/focus/input behavior
- objective/progress copy or hierarchy
- causal VFX meaning/visibility
- accessibility signifier/channel
- representative stage flow materially affecting observed tasks

새 acceptance build identity를 지정하고 영향받은 physical/human evidence를 다시 실행한다.

## 17. External Evidence Disposition

- Professional Games User Research: `ADAPT` — observed one-to-one playtest, neutral probing, pragmatic recruit buffer, iterative retest.
- Xbox Accessibility Guidelines: `ADOPT_AS_VALIDATION_LENS` — objective clarity, UI context, additional signifiers, motion/readability considerations.
- Competitor puzzle references: `REFERENCE_ONLY` — finite handcrafted learning context only; no mechanic/hint import.

## 18. 현재 결론

```text
PHASE A PLAYTEST/COMPREHENSION CONTRACT: PLANNING
HISTORICAL VALIDATION APK: PRESERVED · NOT CURRENT HUMAN ACCEPTANCE BUILD
POST-POC ACCEPTANCE BUILD: UNASSIGNED
PHYSICAL ACCEPTANCE SMOKE: NOT_READY / NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
P01~P05: NOT_RUN
USER "기획 완료" GATE: NOT_GRANTED
PHASE B: NOT_RUN
SX-DEC-055 IMPLEMENTATION: NOT_STARTED
PRODUCTION CUTOVER: BLOCKED_DEFERRED
```
