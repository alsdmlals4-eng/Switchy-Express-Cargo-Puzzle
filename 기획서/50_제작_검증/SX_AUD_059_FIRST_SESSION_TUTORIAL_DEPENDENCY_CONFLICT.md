# SX-AUD-059 · First-Session Tutorial Dependency Conflict

```yaml
audit_id: SX-AUD-059
status: USER_DECISION_REQUIRED
related_decision: SX-DEC-059
baseline_main: 0a88f707e1e4131ae4372929f2871d2b8a3a74b7
approval_state: DIRECTION_APPROVED · CONFLICT_RESOLUTION_PENDING
work_mode: PLAN
protected_open_pr: "#154 · READ_ONLY"
```

## 1. Finding

승인된 Tutorial 1~6 순서는 다음이다.

```text
T1 기본 선로
T2 화물과 대응 역·자동 하역
T3 LIFO
T4 수동 적재
T5 자동 적재 전환
T6 분기
```

그러나 실제 current main 입력 상태는 시작 시:

```gdscript
_manual_load_active = false
_auto_load_enabled = false
```

이고 접촉 적재 조건은:

```gdscript
not paused and (auto_load_enabled or manual_load_active)
```

이다.

따라서 T2가 현재 core rule을 그대로 사용하면서 플레이어에게 아무 적재 조작도 알려주지 않으면 화물을 싣지 못한다. 이는 문서상의 교육 순서와 실제 행동 prerequisite가 충돌하는 `PLANNING_CONFLICT`다.

## 2. Protected strengths

어떤 해결을 선택해도 다음을 보호한다.

- actual product default = manual load
- auto load는 플레이어가 선택하는 도구이며 숨은 기본값이 아님
- pickup을 정차/감속으로 바꾸지 않음
- T3 LIFO 전에 cargo/station 관계를 먼저 경험
- T5에서 manual vs auto의 의미 있는 차이를 학습
- domain CargoStack/LIFO 규칙 불변
- tutorial-only 규칙이 main campaign semantic을 왜곡하지 않음

## 3. Alternatives

### A · `PREREQUISITE_ACTION_EARLY · STRATEGY_LATER` — GPT RECOMMENDED

T2에서 cargo를 만나는 첫 순간에 **필요 조작만** 가르친다.

```text
T2: "화물을 지날 때 적재를 누르세요"
→ cargo pickup
→ matching station auto unload

T4: "이번 화물은 싣지 말고 지나가세요"
→ hold / release가 경로·LIFO 결과를 바꾸는 선택임을 학습
```

즉:
- T2가 가르치는 것 = pickup을 발생시키는 prerequisite action
- T4가 가르치는 것 = manual loading의 선택적·전략적 사용

장점:
- 기존 stage order 유지
- product default 유지
- 새 domain 상태/API 필요 없음
- 현재 `LOAD_ACTIVE` 입력과 HUD를 그대로 사용
- just-in-time onboarding

위험:
- 엄밀히 보면 manual-load control이 T4보다 먼저 노출된다.

대응:
- canonical tutorial 설명을 `T2 cargo/station + basic pickup action`, `T4 selective manual loading`으로 명료화한다.

### B · `TUTORIAL_AUTO_ASSIST_T2_T3`

T2~T3에서 tutorial-only auto pickup assist를 켜고 T4부터 manual default로 전환한다.

장점:
- 기존 tutorial 제목을 글자 그대로 유지 가능
- T2에서 cargo/station 인과만 집중 가능

위험:
- 실제 제품 기본값과 다른 행동을 먼저 학습
- T5 auto-load 개념이 이미 암묵적으로 노출됨
- tutorial-only 초기 input-state override 필요
- "왜 이번에는 자동으로 실리지 않지?"라는 전이 실패 가능

판정: `NOT_RECOMMENDED`.

### C · `PRELOADED_STACK_T2_T3`

T2는 화물 1개, T3는 LIFO 예제 화물을 열차에 미리 싣고 시작한다. T4에서 실제 pickup 조작을 처음 가르친다.

장점:
- T2/T3의 인지 목표를 매우 순수하게 분리
- tutorial 순서의 문구적 의미 유지

위험:
- current map schema에 initial stack 없음
- 새로운 domain initialization/data/API 필요
- 실제 게임에서 없는 시작 상태를 교육용으로 도입
- 구현비와 회귀 표면이 가장 큼

판정: `REJECT_UNLESS_FUTURE_NEED_PROVES_VALUE`.

### D · `REORDER_CURRICULUM`

manual pickup을 cargo/station보다 먼저 가르치도록 Tutorial 순서를 재작성한다.

장점:
- prerequisite 순서가 가장 명시적

위험:
- 승인된 Tutorial 1~10 순서를 직접 변경
- "화물이 무엇인지" 알기 전에 Load 입력을 가르쳐 의미가 약함
- 기존 문서/캠페인/057 curriculum consumer 재동기화 필요

판정: `VALID_BUT_HIGHER_CHANGE_COST`.

## 4. Benchmark disposition

Railbound의 공식 개발 회고에서 긴 onboarding text는 테스트에서 읽히지 않았고, 팀은 words를 제거한 뒤 첫 level을 사실상 실패 불가능하게 만들고 bend/rotate/delete 같은 기능을 **실제로 필요한 순서에 맞춰** 소개했다.

Switchy 적용:
- `ADAPT`: 필요 행동을 필요한 순간에 보여준다.
- `REJECT`: 완전 무문자 강제. LIFO는 추상 규칙이므로 한 줄 contextual copy를 허용한다.
- `REJECT`: input scheme 복제.

Source:
- https://developer.apple.com/news/?id=0x08hncy

## 5. Adversarial comparison

| 기준 | A | B | C | D |
|---|---:|---:|---:|---:|
| current core 보존 | 최고 | 중 | 낮음 | 높음 |
| existing Tutorial order 보존 | 높음 | 최고 | 최고 | 낮음 |
| 잘못된 mental model 위험 | 낮음 | 높음 | 중 | 낮음 |
| 구현 비용 | 최저 | 중 | 최고 | 중 |
| future campaign 전이 | 최고 | 낮음 | 중 | 높음 |
| rollback | 쉬움 | 보통 | 어려움 | 보통 |

## 6. Recommendation

`A · PREREQUISITE_ACTION_EARLY · STRATEGY_LATER`

이 선택은 새 mechanic을 만들지 않고 **같은 manual-load 동작을 두 번 다른 깊이로 가르치는 progressive disclosure**다.

T2 acceptance:
- 플레이어가 cargo 직전의 `적재` cue를 보고 눌러 pickup을 발생시킨다.
- 같은 종류 역에서 자동 하역되는 것을 관찰한다.
- 이 단계에서는 cargo를 일부러 skip해야 하는 퍼즐을 만들지 않는다.

T4 acceptance:
- 적재를 누르지 않고 지나가는 선택이 반드시 한 번 필요하다.
- 이후 재방문하거나 다른 cargo order를 만들기 위해 manual hold/release를 의도적으로 사용한다.
- 성공은 단순 버튼 누르기가 아니라 `왜 이번 화물을 싣지 않았는지` 설명 가능한 상태다.

## 7. Approval gate

```yaml
decision_question_id: GM-SX059-01
recommended_choice: A
state: USER_DECISION_REQUIRED
blocks:
  - exact T2/T4 content contract finalization
  - first-session stage map specifications
  - tutorial copy lock
does_not_block:
  - capstone analysis
  - UI information hierarchy planning
  - visual requirement inventory
  - tooling/work-instruction reconciliation planning
```
