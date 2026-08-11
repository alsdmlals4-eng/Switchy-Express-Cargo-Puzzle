# SX-DEC-056 · Route Causality Learning and Result Feedback

Status: `USER_APPROVED · PLANNING_CANON · IMPLEMENTATION_NOT_AUTHORIZED_UNTIL_DELTA_DOR`

Approved: `2026-08-11 KST`

Source benchmark: `SX-BMK-001 · BMK-R01/R02/R03/R07`

Product baseline: `GMB-002`

## Decision

Switchy Express는 새 gameplay rule을 추가하지 않고, 이미 승인된 핵심 인과인 `노선 → 화물 조우 순서 → LIFO/TOP → 방문/하역 결과 → 재설계`를 플레이어가 스스로 예측하고 설명할 수 있도록 다음 학습·결과 피드백 구조를 제품 방향으로 승인한다.

1. 내부 feature triage 문장은 `노선을 그리는 순간 화물 스택의 순서가 정해지고, 운행은 그 계획을 실행한다.`로 둔다.
2. BUILD에는 사용자가 요청할 때만 여는 `Route Probe / Encounter Strip`을 둔다.
3. RUN 후에는 실제로 발생한 사건만 보여주는 `Actual Encounter Trace / Debrief`를 둔다.
4. Result에서는 `Fastest / Cheapest / Highest Score` 개인 기록을 서로 독립적으로 유지하고, route fingerprint를 보조 정보로 제공한다.

## 1. Route Probe / Encounter Strip

Route Probe는 solver가 아니다. 플레이어가 현재 만든 TrackLayout과 현재 선택된 switch state를 따라 하나의 실제 진행 후보를 읽기 쉽게 투영한다.

필수 표현:

- 시작점부터 현재 선택 상태를 따라 만나는 `cargo / station / switch`를 순서대로 표시한다.
- cycle을 만나면 `LOOP`를 표시한다.
- 더 진행할 수 없으면 `DEAD END`를 표시한다.
- branch 선택이 바뀌면 해당 투영 결과도 갱신한다.
- 요청하지 않으면 상시 HUD를 점유하지 않는다.

금지:

- 최적 노선 제시
- 정답 switch sequence 제시
- 최종 unload order 정답 제시
- 3-star route 제시
- 어떤 cargo를 의도적으로 skip해야 하는지 제시
- 자동 수정·자동 건설

Route Probe가 답이 아니라 `내가 만든 계획의 결과를 읽는 도구`로 남는 것이 핵심이다.

## 2. Prediction → Execution → Debrief

승인된 학습 루프:

```text
BUILD
→ Route Probe로 내가 만든 조우 순서를 확인/예측
→ RUN
→ 실제 Stack/TOP/load mode/switch state를 관찰
→ RESULT
→ Actual Encounter Trace로 실제 사건과 실패/성공 원인을 확인
→ EDIT
→ 같은 문제를 다시 설계
```

Actual Encounter Trace는 실제 발생 사건만 기록한다.

허용 예:

```text
A pickup
→ B pickup
→ A station PASS · TOP=B
→ switch East
→ B station unload 1
→ A station unload 1
```

실패 설명은 정답을 주는 대신 관찰 가능한 원인 상태를 우선한다.

허용 예:

- `TIMEOUT · 2 cargo remain`
- `A station passed · TOP was B`
- `cargo C never encountered`

## 3. Three PBs and Route Fingerprint

한 개의 종합 효율 등급으로 플레이 스타일을 압축하지 않는다.

제품이 기억하는 개인 기록 축:

- `Fastest PB`
- `Cheapest PB`
- `Highest Score PB`

Route Fingerprint는 비교·회고용 보조 정보이며 ranking authority가 아니다. 후보 필드는 다음을 승인한다.

- track cost
- completion/travel time
- score
- total rail tiles
- switch count / switch changes
- station revisits
- max stack depth
- cargo-type transitions in stack
- max combo
- pause count

Route Fingerprint는 개발자 정답, 다른 플레이어 정답 노선, 자동 solver 결과와 비교하지 않는다.

## 4. Protected boundaries

이 Decision은 다음을 변경하지 않는다.

- unlimited cargo LIFO
- manual/auto load 규칙
- contiguous TOP unload
- switch input/lock/cycle/U-turn authority
- free build + piece cost + full refund
- time/success/failure/scoring rules
- pause 허용
- map content
- save/ruleset identity
- semantic asset provenance

`Route Probe`, `Encounter Trace`, `PB/Fingerprint` 구현을 위해 새 gameplay/domain rule이나 승패 조건을 만들 수 없다. 필요한 정보는 기존 domain state와 실제 run 결과의 read-only projection/recording으로 구성해야 한다.

## 5. Validation contract

구현 승인 전 delta DoR에서 최소 다음을 닫아야 한다.

1. Route Probe가 solution authority가 아니라는 정적/행동 계약.
2. LOOP/DEAD END/branch 변경의 결정론적 표시 계약.
3. Actual Encounter Trace가 실제 사건과 일치하고 발생하지 않은 사건을 합성하지 않는 계약.
4. PB 세 축이 서로 독립적으로 저장·갱신되는 계약.
5. Route Fingerprint가 ranking/gameplay 결과를 바꾸지 않는 계약.
6. Five-person comprehension에서 `route → encounter order` 사전 예측과 실패 후 원인 설명을 측정한다.

## 6. Authority boundary with SX-DEC-055

`SX-DEC-055`의 기존 Phase B BUILD authority는 이 Decision으로 확대되지 않는다.

- SX-DEC-055 first implementation step는 계속 `Task 1 / Step 1.1 RED`다.
- SX-DEC-056은 별도 post-Phase-B additive product Decision이다.
- 실제 코드 구현 전 별도 delta DoR / final planning review가 필요하다.
- Codex quota로 현재 Phase C 실행은 사용자 선택에 따라 일시 보류 중이다.
