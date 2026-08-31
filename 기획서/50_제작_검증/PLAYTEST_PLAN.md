# Playtest Plan

```yaml
status: CURRENT_CANON · SX_DEC_065_MACHINE_PRIMARY_FINAL_USER_REVIEW · SX60_POC_ACCEPT_009_PREPARED_PACKAGE_VERIFIED · FINAL_USER_REVIEW_NOT_RUN · TITLE_WORDMARK_USER_PIXEL_APPROVED_CANON_REGISTERED
product_authority: GMB-002 · SX-DEC-027~068 · SX-DEC-060_CARDINAL_SERVICE_AMENDMENT · SX-DEC-062_COMPOSITION_CONTRACT · SX-DEC-064_ACTIVE_ROUTE_LIGHTING · SX-DEC-065_MACHINE_PRIMARY_VALIDATION · SX-DEC-068_TITLE_SHELL_WORDMARK_CANDIDATE
planning_audit: SX-AUD-049 · HISTORICAL_METHOD_PROVENANCE
last_verified_package_candidate: SX60-POC-ACCEPT-007 · HISTORICAL_POST_SX_DEC_067_PACKAGE_VERIFIED · SUPERSEDED_BY_SX_DEC_068_PLAYER_FACING_TITLE_SHELL_BYTES
last_verified_package_source_main: c0bb86efa5bad6050217ca67dd6aa9eba155dc75
current_candidate: SX60-POC-ACCEPT-009 · PREPARED_PACKAGE_VERIFIED · EXACT_CANONICAL_WORDMARK_SOURCE_1ac3099d9ab1451323cca2935547f82d210b50b4
windows_physical_and_audio: FINAL_USER_REVIEW_ONLY · NOT_RUN
android_device: NOT_REQUIRED_FOR_MACHINE_PRIMARY_ACCEPTANCE · NOT_RUN
five_person_comprehension: NOT_REQUIRED_BY_USER_VALIDATION_POLICY
player_experience: NOT_REQUIRED_BY_USER_VALIDATION_POLICY
final_user_review: FINAL_USER_REVIEW · NOT_RUN · UNCHANGED_SX60_POC_ACCEPT_008_REQUIRED · TITLE_WORDMARK_PIXEL_DISPOSITION_SEPARATE
sx_dec_056_058_implementation: NOT_AUTHORIZED
production_cutover: BLOCKED_DEFERRED
```

이 문서는 **현재 제품의 첫 세션 이해도와 사람 검증 방법**을 책임진다. 실제 사람 증거가 아니라 현재 구현·acceptance 실행 전에 고정된 검증 contract다.

## Current validation scope · SX-DEC-065

이 Section이 현재 실행 상태의 단일 정본이다. 사용자 승인 `2026-08-30 KST`에 따라 현재 방법은 `MACHINE_PRIMARY_FINAL_USER_REVIEW`다. Windows physical, audio, Android, five-person, Player Experience, production cutover 중 어느 것도 실제 evidence 없이 PASS로 승격하지 않는다.

```text
exact immutable post-SX-DEC-068 candidate
→ deterministic contracts + Godot/runtime/export/package/CI machine verification
→ MACHINE_PRIMARY acceptance decision
→ FINAL_USER_REVIEW only when the user requests the final inspection
```

- 현재 머신 검증 단위는 `T1 → T2 → T3 → T4 → T5 → T6 → VS_DEMO_01 → Result / Retry / Edit`의 contract/runtime/package evidence다.
- T2의 필수 구분은 `cargo = same-cell Manual/Auto pickup`, `station = one cardinal-adjacent service cell`, `diagonal / station footprint = no delivery`다.
- `SX60-POC-ACCEPT-004`는 last verified Windows artifact identity와 Android runtime-JSON package proof를 보존한다. v04 product bytes에는 적용되지 않는다. Android runtime JSON proof는 APK artifact identity나 physical-device proof가 아니다. 기존 Android validation APK/runbook은 historical이며 post-060 device Gate에 재사용하지 않는다.
- `SX-DEC-061`은 planning/visual direction lock이며 runtime bytes를 바꾸지 않았다. 화면의 visual grammar는 관찰할 수 있지만 board·generated exploration·machine capture만으로 human usability를 통과 처리하지 않는다.
- `FIVE_PERSON_COMPREHENSION_NOT_REQUIRED`와 `PLAYER_EXPERIENCE_STUDY_NOT_REQUIRED`는 이 프로젝트의 명시 정책이다. 최종 사용자 검수의 관찰은 unchanged Candidate 009에만 기록하며, title-wordmark pixel disposition은 `USER_PIXEL_APPROVED · CANON_REGISTERED` asset state로 보존한다.
- 상세 실행 순서, 기록 규칙, stale correction의 Incident/Solution/Lesson은 `docs/superpowers/plans/2026-08-28-phase5-human-validation.md`를 따른다.

Sections 1–17 are `HISTORICAL_METHOD_REFERENCE_ONLY`. Phase B/055/old Android identity와 behavior-first 연구 방법은 provenance로 보존하되, SX-DEC-065의 현재 acceptance gate나 five-person requirement를 만들지 않는다.

과거 Android validation APK는 별도 역사/진단 증거로 보존한다. post-SX-DEC-055 사람 검증의 active build identity로 자동 승격하지 않는다.

## 1. Historical Phase B Gate Record

현재까지 완료된 planning gate와 이후 실행 gate를 한 체인으로 유지한다.

```text
PHASE A planning complete · DONE
→ explicit user "기획 완료" · GRANTED
→ PHASE B final planning review · PASS · SX-AUD-047
→ authorized SX-DEC-055 runtime semantic implementation · AUTHORIZED / NOT_STARTED
→ exact-head automated POC evidence + merge
→ acceptance build identity assignment
→ reviewed physical smoke on that exact acceptance build
→ FIVE-PERSON COMPREHENSION
→ evidence completeness/privacy/adversarial review
→ separate production/cutover decision
```

`SX-DEC-056~058`은 Phase B 이후 승인된 additive planning authority이며 위 `SX-DEC-055` 구현 Gate를 자동 확장하지 않는다. 056~058을 실제 player-facing/content/challenge 구현에 넣으려면 각각의 scoped delta DoR/final planning review가 먼저 필요하다.

`SX-DEC-056` 또는 `SX-DEC-057`의 player-facing 변경이 이후 acceptance build에 포함되면 해당 build identity로 physical/human evidence를 새로 연결해야 한다. `SX-DEC-058`의 generator/publication pipeline은 별도 content-pipeline validation을 요구하며 사람 UI evidence를 대신하지 않는다.

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

## 3. Historical Post-POC Acceptance Build Identity

현재 authorized implementation merge 전에는 미래 build를 발명하지 않는다.

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

1. 역사적으로 v4.5 user Gate와 Phase B 전에 build identity를 채우지 않았고, 현재도 구현 merge 전에는 채우지 않는다.
2. `SX-DEC-055` 구현이 current main에 병합되고 automated POC evidence가 닫힌 뒤 exact source/artifact identity를 지정한다.
3. 사람 세션은 해당 comprehension round의 reviewed physical smoke와 **동일한 exact acceptance build identity**를 사용한다.
4. 테스트 대상 학습/UI/input/semantic feedback에 영향을 주는 player-facing 변경이 생기면 이전 사람 증거를 자동 승계하지 않는다.
5. PC physical smoke는 진단/보조 증거가 될 수 있지만 Android-oriented Five-person Comprehension을 PC-only 증거로 대체하지 않는다.
6. `SX-DEC-056/057`이 implementation-authorized되어 acceptance build에 들어오면 그 exact merge/build identity를 새 round의 근거로 사용한다.

## 4. 연구 목적

첫 경험 사용자가 설명을 암기했는지가 아니라, 이미 승인된 제품 규칙을 **스스로 발견하고 다음 행동을 예측하며 다른 상태에 전이**할 수 있는지 확인한다.

핵심 연구 질문:

1. 현재 목표와 남은 배송을 이해하는가?
2. BUILD·preflight 피드백으로 스스로 노선을 고칠 수 있는가?
3. 선로가 화물 조우 순서를 만든다는 인과를 이해하는가?
4. manual/auto load 상태를 의도적으로 선택하고 읽는가?
5. 화물은 같은 칸 접촉, 역은 상·하·좌·우 한 칸 서비스라는 차이와 diagonal/역 footprint 비배송을 행동과 예측으로 구분하는가?
6. 마지막 적재 화물을 TOP으로 예측하는가?
7. TOP부터 연속된 같은 종류만 함께 하역된다고 예측하는가?
8. 분기에서 선택 방향과 점유 잠금을 올바르게 읽는가?
9. 실패 원인에 따라 Retry와 Edit를 구분하는가?
10. 색상을 보지 않아도 shape/text/TOP 신호를 사용해 식별하는가?
11. pickup/unload/route/terminal semantic feedback을 실제 사건과 올바르게 연결하는가?
12. 한 번 경험한 규칙을 이후 바뀐 stack/route/switch 상태에 독립 적용하는가?

### Conditional questions after SX-DEC-056/057 implementation

이 항목은 056/057이 실제 acceptance build에 포함된 경우에만 활성화한다.

12. request-only Route Probe를 정답 표시가 아니라 `내가 만든 노선의 예상 결과`로 이해하는가?
13. Debrief의 actual event trace를 보고 실패 원인을 설명하되 정답 노선을 자동으로 기대하지 않는가?
14. Yard Lab에서 격리 학습한 규칙을 이후 campaign 문제에 새 설명 없이 전이하는가?
15. Mastery Spur가 optional임을 이해하고 포기 후 core progression으로 자연스럽게 복귀하는가?

## 5. Learning Model — RULE → NEED → DISCOVER → FEEL → PROVE → TRANSFER

| Target | RULE | NEED / DISCOVER | PROVE | TRANSFER |
|---|---|---|---|---|
| Objective | 제한 시간 안에 모든 필수 배송 | goal/progress context | 도움 없이 유효한 시도를 시작 | 부분 run 뒤 남은 목표 식별 |
| Build/preflight | 구조적으로 도달 가능해야 시작 | placement/problem feedback | blocking issue를 스스로 수정 | 뒤의 다른 blocking state도 진단 |
| Station service | 화물은 같은 칸, 역은 cardinal-adjacent 1칸에서만 배송 | T2 direct-contact와 station service cue 비교 | diagonal/footprint를 배송으로 기대하지 않고 서비스 셀을 선택 | 뒤의 다른 역·route에서 같은 rule을 적용 |
| Encounter order | 경로가 화물 조우 순서를 결정 | route와 실제 조우 비교 | 다음 조우 화물을 예측 | route/load 선택 변경 후 결과 예측 |
| LIFO TOP | 마지막 적재가 TOP | stack/TOP presentation | 역 도착 전 다음 하역 후보 예측 | stack 변화 뒤 다시 예측 |
| Unload group | TOP 연속 동일 종류만 하역 | 하역 후 남은 stack 관찰 | 하역 그룹/수량 예측 | 뒤의 다른 stack 상태에 적용 |
| Load mode | manual hold / auto toggle 상태 차이 | 실제 input-state presentation | 의도한 방식으로 적재 | 이후 접촉에서 상태가 다르면 인지/복구 |
| Switch | 선택 방향이 다음 경로, 점유 중 잠금 | arrow + semantic reinforcement | 의도 경로를 선택 | 뒤의 다른 switch state 결과 예측 |
| Retry/Edit | Retry=같은 layout fresh runtime, Edit=노선 수정 | result choice | 문제 유형에 맞는 선택 | 다른 실패 원인에서 선택 변경 |
| Redundant identity | 색상 단독 아님 | shape/text/TOP | 색상 없이도 식별 | 뒤의 상태에서도 재식별 |
| Causal feedback | semantic feedback은 실제 event를 설명 | pickup/unload/route/terminal feedback | 올바른 사건에 귀인 | 장식과 gameplay authority를 혼동하지 않음 |

### Conditional learning targets after SX-DEC-056/057 implementation

| Target | RULE | NEED / DISCOVER | PROVE | TRANSFER |
|---|---|---|---|---|
| Route Probe | 현재 선택 상태를 따라 예상 encounter sequence를 보여주며 정답 solver가 아님 | probe 결과와 실제 run 비교 | 다음 encounter를 probe/route에서 설명 | branch 변경 뒤 바뀐 suffix를 예측 |
| Debrief | 실제 발생 event만 기록 | result trace와 직전 run 비교 | 실패 원인을 실제 state로 설명 | Edit 후 어떤 원인이 사라질지 예측 |
| Yard Lab transfer | Lab은 기존 rule 격리 연습 | Lab 직후 campaign 적용 | 새 설명 없이 같은 rule 사용 | 다른 topology/stack/switch 상태에서 재사용 |
| Mastery optionality | Mastery는 progression requirement 아님 | chapter path에서 선택 | 포기/재진입을 스스로 선택 | core progression을 막는다고 오해하지 않음 |

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
- Route Probe가 보여줄 encounter sequence의 정답 해석
- Debrief 뒤 다음에 고칠 정답 노선

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
| FS-02A | cargo contact vs cardinal station service | cargo의 same-cell pickup과 station의 cardinal-adjacent delivery를 예측하고, diagonal/footprint가 배송이 아님을 행동으로 구분 |
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

### Conditional Observation Matrix after SX-DEC-056/057 implementation

해당 기능이 acceptance build에 실제 포함되었을 때만 필수화한다.

| ID | Observation | PASS evidence example |
|---|---|---|
| FS-13 | Route Probe interpretation | probe를 solution reveal이 아닌 현재 선택 route의 prediction으로 설명 |
| FS-14 | Probe → actual comparison | probe와 RUN 차이를 branch/load state 변화로 설명 |
| FS-15 | Debrief causality | actual trace로 실패 원인을 설명하고 존재하지 않은 사건을 귀인하지 않음 |
| FS-16 | Yard Lab transfer | Lab 뒤 campaign에서 같은 rule을 새 설명 없이 적용 |
| FS-17 | Mastery optionality | Mastery를 progression requirement로 오해하지 않고 core로 복귀 가능 |

## 10. Post-task 질문

행동·예측 기록 뒤에만 사용한다.

1. `이번 run에서 가장 중요한 목표가 무엇이라고 생각했나요?`
2. `화물 위를 지날 때와 역 근처를 지날 때는 각각 무엇이 달랐나요? 역 칸이나 대각선에서도 배송될 거라고 생각했나요?`
3. `다음 역에서 가장 먼저 내려갈 화물을 어떻게 판단했나요?`
4. `선로를 바꾸면 무엇이 바뀐다고 생각하나요?`
5. `수동 적재와 자동 적재의 차이를 어떻게 이해했나요?`
6. `한 역에서 여러 화물이 같이 내려갈 때 어떤 규칙이 있었다고 생각하나요?`
7. `분기 화살표/잠금 표시는 각각 무엇을 뜻한다고 생각했나요?`
8. `Retry와 Edit 중 어떤 상황에서 각각 쓰고 싶나요?`
9. `색상을 제외하면 어떤 표시로 화물·역·TOP을 구분했나요?`
10. `방금 나온 시각 효과가 무엇 때문에 발생했다고 생각하나요?`
11. `이번 성공/실패의 가장 큰 원인은 무엇이라고 생각하나요?`

056/057이 acceptance build에 포함된 경우에만 추가한다.

12. `Route Probe가 무엇을 보여준다고 생각했나요?`
13. `Probe와 실제 운행이 달랐다면 무엇 때문에 달라졌다고 생각하나요?`
14. `Debrief에서 어떤 사건이 실패 원인을 가장 잘 설명했나요?`
15. `Lab에서 배운 것을 다음 campaign 문제에서 어떻게 사용했나요?`

질문 정답률은 행동 증거를 보조하며 대체하지 않는다.

## 11. 참가자 기록표

| Participant | Build ID | FS-01 | FS-02 | FS-02A | FS-03 | FS-04 | FS-05 | FS-06 | FS-07 | FS-08 | FS-09 | FS-10 | FS-11 | FS-12 | 주요 오해 | 상태 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| P01 | UNASSIGNED | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | | NOT_RUN |
| P02 | UNASSIGNED | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | | NOT_RUN |
| P03 | UNASSIGNED | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | | NOT_RUN |
| P04 | UNASSIGNED | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | | NOT_RUN |
| P05 | UNASSIGNED | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | | NOT_RUN |
| P06 | UNASSIGNED | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | | NOT_RUN |

상태는 `PASS`, `FAIL`, `BLOCKED`, `NOT_RUN`, `INTERVENTION_CONTAMINATED` 중 하나를 사용한다.

056/057 conditional observations가 활성화된 build에서는 FS-13~17을 별도 companion 기록표로 추가하거나 동일 session record에 확장한다. 기존 FS-01~12 및 FS-02A 열의 의미를 재정의하지 않는다.

## 12. 합격 기준

기본 최소 표본 5명에서는 threshold `4/5`를 사용한다. 6명 이상 유효 세션을 모두 분석할 때는 `ceil(N × 0.8)`로 계산한다.

| ID | 기준 |
|---|---|
| HUM-01 | FS-01 objective/progress threshold 충족 |
| HUM-02A | FS-02A cargo exact-contact / station cardinal-service mental model threshold 충족 |
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

### Conditional pass additions

`SX-DEC-056/057`이 acceptance build에 포함된 경우:

- FS-13~17 중 해당 build에 구현된 기능의 observation을 같은 threshold 원칙으로 평가한다.
- Route Probe가 solver/정답 reveal로 오해되어 독립 예측을 대체하면 P1 이상으로 triage한다.
- Debrief가 실제 사건과 다른 causal attribution을 만들면 P1 이상으로 triage한다.
- Lab이 campaign transfer를 만들지 못하거나 Mastery가 progression blocker로 오해되면 해당 Decision의 delta acceptance를 PASS로 닫지 않는다.

## 13. Finding Severity

### P0 / Critical

- solution-relevant moderator intervention 없이는 진행 불가
- selected switch direction을 반복적으로 반대로 이해해 core route를 수행할 수 없음
- color 없이 필수 cargo/station/TOP 식별 불가
- cargo exact-contact와 cardinal station service를 반복적으로 혼동해 T2 delivery를 수행할 수 없음
- 의도된 presentation 경험 뒤에도 LIFO/TOP 규칙을 추론할 수 없음
- acceptance build crash/input loss 등으로 증거가 무효화됨

### P1 / High

- 우연/무작위 반복으로 통과하지만 reusable route/LIFO mental model 형성 실패
- FS-11 transfer 실패
- manual/auto/preflight state 반복 오독으로 계획이 지속적으로 탈선
- semantic feedback이 잘못된 원인을 전달하거나 authoritative text/procedural state와 충돌
- Route Probe가 정답/solver authority로 인식되어 player prediction을 대체함
- Debrief가 실제 run과 다른 event/cause를 암시함
- Yard Lab이 본편 전이를 만들지 못하거나 Mastery가 진행 필수로 오해됨

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
  + HUM-01, HUM-02A, HUM-02~13 all satisfied
  + any active SX-DEC-056/057 conditional observations satisfied
  + evidence/privacy/adversarial review complete

FAIL:
  executable valid study where one or more required HUM/active conditional criteria fail

BLOCKED:
  acceptance build / physical smoke / participant / evidence prerequisite missing

NOT_RUN:
  study has not been executed
```

현재 상태는 `USER_AUTHORIZATION_RECORDED · WINDOWS_PHYSICAL_AND_AUDIO_NOT_RUN · ANDROID_EXACT_POST_060_ARTIFACT_UNASSIGNED · FIVE_PERSON_NOT_RUN`다.

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
- cargo exact-contact / station cardinal-service presentation or service-cell visibility
- target/click/focus/input behavior
- objective/progress copy or hierarchy
- causal VFX meaning/visibility
- accessibility signifier/channel
- representative stage flow materially affecting observed tasks
- Route Probe / Encounter Strip의 prediction 표현
- Debrief / Encounter Trace의 causal 표현
- Yard Lab / Mastery progression·학습 동선

새 acceptance build identity를 지정하고 영향받은 physical/human evidence를 다시 실행한다.

## 17. External Evidence Disposition

- Professional Games User Research: `ADAPT` — observed one-to-one playtest, neutral probing, pragmatic recruit buffer, iterative retest.
- Xbox Accessibility Guidelines: `ADOPT_AS_VALIDATION_LENS` — objective clarity, UI context, additional signifiers, motion/readability considerations.
- Competitor puzzle references: `REFERENCE_ONLY` — finite handcrafted learning context only; no mechanic/hint import.
- `SX-BMK-001`: `ADOPT_APPROVED_SUBSET` — R01~R08은 SX-DEC-056~058로 승격, R09/R10은 post-validation hold.

## 18. 현재 결론

```text
HISTORICAL_PLAYTEST/COMPREHENSION_METHODS: REFERENCE_ONLY · NOT_ACTIVE_ACCEPTANCE_GATE
HISTORICAL VALIDATION APK: PRESERVED · NOT CURRENT HUMAN ACCEPTANCE BUILD
USER PHASE 5 START AUTHORIZATION: HISTORICAL · 2026-08-28 KST
SX-DEC-065 USER APPROVAL: RECORDED · 2026-08-30 KST · MACHINE_PRIMARY_FINAL_USER_REVIEW
CURRENT PRODUCT AUTHORITY: GMB-002 · SX-DEC-027~068 · SX-DEC-060 cardinal station service · SX-DEC-062 board-first composition · SX-DEC-064 active-route lighting · SX-DEC-065 MACHINE_PRIMARY_FINAL_USER_REVIEW · SX-DEC-066 Route Book 01 · SX-DEC-067 Wayside Hazards / Route Book 02 · SX-DEC-068 Title Shell / Wordmark Candidate
LAST VERIFIED WINDOWS CANDIDATE: SX60-POC-ACCEPT-007 · HISTORICAL_POST_SX_DEC_067_PACKAGE_VERIFIED · SUPERSEDED_BY_SX_DEC_068_TITLE_SHELL_BYTES
CURRENT EXACT CANDIDATE: SX60-POC-ACCEPT-009 · PREPARED_PACKAGE_VERIFIED · FINAL_USER_REVIEW_NOT_RUN · TITLE_WORDMARK_USER_PIXEL_APPROVED_CANON_REGISTERED
WINDOWS PHYSICAL / AUDIO: FINAL_USER_REVIEW_ONLY · NOT_RUN
POST-060 ANDROID APK IDENTITY: NOT_REQUIRED_FOR_MACHINE_PRIMARY_ACCEPTANCE · NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_REQUIRED_BY_USER_VALIDATION_POLICY
PLAYER EXPERIENCE STUDY: NOT_REQUIRED_BY_USER_VALIDATION_POLICY
FINAL USER REVIEW: NOT_RUN · EXACT_CANDIDATE_REQUIRED
PRODUCTION CUTOVER: BLOCKED_DEFERRED
```
