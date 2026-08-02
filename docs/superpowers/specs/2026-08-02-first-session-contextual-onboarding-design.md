# Switchy Express First-Session Contextual Onboarding Design

```yaml
decision_id: SX-DEC-016
evidence_id: EV-USER-004
status: USER_APPROVED · PLANNING_SPEC
approved_option: A_CONTEXTUAL_FIRST_RUN
work_mode: TOTAL_PLANNING · REVIEW
implementation_status: NOT_STARTED
validation_status: NOT_RUN
```

## 1. Decision

Switchy Express는 별도 튜토리얼 맵이나 설명 화면만으로 규칙을 가르치지 않는다. 실제 첫 번째 무한 운행을 시작하되, 초반의 배치·연료 압박·안내 순서를 안전하게 조정한 **상황형 첫 판 온보딩**을 사용한다.

플레이어는 실제 규칙으로 다음 관계를 행동 직후 이해해야 한다.

1. `LOAD`로 화물을 적재한다.
2. 적재 화물 1개가 작은 compact wagon token 1개로 뒤에 붙는다.
3. 분기기 탭은 preview와 실제 다음 경로를 바꾼다.
4. 가장 뒤 token이 CargoStack top이며 다음 LIFO 하역 대상이다.
5. 한 역에서 같은 타입이 연속 하역되면 `COMBO ×N`이 된다.
6. 낮은 연료에서 `BOOST`는 시간을 줄이는 대신 연료를 더 쓴다.

## 2. 목표

- 처음 플레이하는 사람이 3분 안에 `LOAD`, 분기, rear-token LIFO, Combo의 관계를 실제 행동으로 설명할 수 있게 한다.
- 튜토리얼 전용 가짜 규칙·가짜 맵·가짜 보상을 만들지 않는다.
- 자동 운행의 판단 압박 때문에 설명을 읽지 못하는 문제를 첫 필수 입력의 안전 정지로 해결한다.
- 안내가 끝난 뒤에는 같은 run이 그대로 일반 무한 운행으로 이어지게 한다.
- 온보딩 UI·애니메이션은 게임 결과 권위를 갖지 않는다.

## 3. 비목표

- 모든 밸런스와 전략을 첫 판에서 설명하지 않는다.
- 모든 분기 상태·모든 화물 조합을 강제 학습하지 않는다.
- 별도 튜토리얼 스테이지, 튜토리얼 전용 통화, 완료 보상을 만들지 않는다.
- 실패를 막기 위해 무적 run을 제공하지 않는다.
- 첫 판 이후 매 run마다 같은 안내를 반복하지 않는다.

## 4. 실제 첫 판 학습 순서

### Step 0 · 안전한 실제 run 시작

- 일반 15×10 연결 맵과 실제 DeliveryLoop를 사용한다.
- 첫 핵심 시퀀스가 끝날 때까지 난이도 상승 타이머를 정지한다.
- 연료 소모는 `0.5×` `TEST_VALUE`로 완화한다.
- 안전 보조는 완료·건너뛰기·120초 경과 중 가장 먼저 발생한 시점에 종료한다.
- 점수·화물 capacity·LIFO·Combo·BOOST 공식은 일반 run과 동일하다.

### Step 1 · 첫 LOAD

- 첫 pickup은 기본 경로에서 4초 이내 접근 가능한 위치를 우선한다.
- 첫 LOAD 기회 직전에 simulation을 안전 정지한다.
- `LOAD를 누르고 있는 동안 화물을 싣습니다`를 최대 2줄로 표시한다.
- 플레이어가 LOAD를 수행하면 pickup domain event가 먼저 확정되고 안내가 진행된다.
- 명시적 `건너뛰기`를 선택하면 온보딩을 종료하고 일반 run으로 복귀한다.

### Step 2 · compact token 의미

- 첫 적재 직후 뒤에 token 1개가 추가된 상태를 강조한다.
- 카피: `화물 1개가 작은 화차 1개로 뒤에 붙습니다.`
- token 색상+모양과 HUD unload order의 첫 항목을 동시에 짧게 강조한다.
- 강조 모션 완료는 적재 성공·저장·점수의 조건이 아니다.

### Step 3 · 첫 분기

- 첫 학습용 분기는 첫 적재 후 10초 이내 접근 가능한 위치를 우선한다.
- active segment에 진입하기 전 안전 정지한다. 일반 플레이의 branch slow motion을 추가하지 않는다.
- 후보 경로와 실제 preview 3~5칸을 강조한다.
- 플레이어가 분기기를 탭하면 preview first cell과 실제 target lock이 일치한 상태로 재개한다.

### Step 4 · mixed-stack LIFO 증명

- 초기 안전 시퀀스는 서로 다른 두 타입의 적재 기회를 제공한다.
- 예시 목표 상태는 `front [A, B] rear`이며 B가 stack top이다.
- B 역 도착 시 rear B만 먼저 하역되고 A가 남는 실제 DeliveryLoop 결과를 보여준다.
- 카피: `가장 뒤 화물부터 내립니다.`
- 하역은 Station/CargoStack domain 결과가 권위이며 token 제거 모션은 표시만 담당한다.

### Step 5 · 첫 Combo 증명

- LIFO 증명 이후 같은 타입을 연속으로 쌓을 실제 기회를 제공한다.
- 첫 `unload_group_size >= 2`에서 `COMBO ×N`을 표시한다.
- 카피: `같은 화물을 이어 싣고 한 번에 내리면 Combo가 커집니다.`
- `speed_bonus`는 Combo 설명에 섞지 않는다.

### Step 6 · BOOST 맥락 안내

- core onboarding 완료 후 연료가 35% 이하가 되었을 때 한 번만 표시한다.
- 카피: `BOOST는 빨라지지만 연료를 더 씁니다.`
- BOOST 안내는 run을 정지하지 않는 권장 기본값이다.
- LOAD와 BOOST 동시 입력 시 기존 BOOST 우선 계약을 유지한다.

### Step 7 · 일반 run 전환

- mixed-stack LIFO 하역과 첫 Combo 설명이 끝나면 core onboarding을 완료한다.
- 난이도 상승과 연료 소모 보조를 일반 값으로 3초에 걸쳐 선형 복귀시키는 `TEST_VALUE`를 사용한다.
- 같은 run을 재시작하지 않고 그대로 일반 무한 운행을 계속한다.

## 5. 상태와 권위

권장 상태 모델:

```gdscript
enum OnboardingStep {
    NOT_STARTED,
    FIRST_LOAD,
    TOKEN_MEANING,
    FIRST_SWITCH,
    LIFO_PROOF,
    COMBO_PROOF,
    CORE_COMPLETE,
    BOOST_HINT_COMPLETE,
    SKIPPED,
}
```

권장 인터페이스:

```gdscript
class_name OnboardingState

var step: OnboardingStep
var core_completed: bool
var boost_hint_completed: bool
var skipped: bool
var assist_elapsed_seconds: float

func consume_domain_event(event: Dictionary) -> Array[Dictionary]
func should_pause_simulation() -> bool
func finish_or_skip(reason: StringName) -> void
```

- CargoStack, RailSwitch, DeliveryLoop, RunController가 실제 결과의 권위다.
- OnboardingState는 domain event를 소비해 다음 안내를 결정하지만 pickup·route·unload·score·fuel을 직접 변경하지 않는다.
- 안전 시작 배치와 연료 완화는 명시적인 first-run assist policy에서만 적용한다.
- UI animation completion signal은 단계 완료 조건이 아니다.

## 6. 저장·건너뛰기·도움말

- `onboarding_core_completed`와 `onboarding_boost_hint_completed`는 best record와 분리된 versioned preference로 저장한다.
- 첫 판 도중 앱이 종료되면 마지막 완료 단계부터 재개하거나, 안전하게 Step 1부터 다시 시작할 수 있다. 동일 domain reward를 재지급하지 않는다.
- 모든 필수 안내에는 `건너뛰기`를 제공한다.
- 완료 후 `? / 도움말`에서 짧은 재생 가능한 카드로 LOAD·분기·LIFO·Combo·BOOST를 다시 볼 수 있다.
- 도움말 재생은 first-run assist, spawn 보정, 연료 완화를 다시 활성화하지 않는다.

## 7. 접근성·표현 계약

- 설명은 한 화면 최대 2줄, 한 문장 중심으로 유지한다.
- 필수 입력 강조는 색상만 사용하지 않고 아이콘·외곽선·텍스트를 함께 사용한다.
- Reduced Motion에서도 단계·대상·결과를 동일하게 이해할 수 있어야 한다.
- mute와 haptic-off에서도 모든 P0/P1 정보가 시각적으로 남는다.
- token과 HUD unload order의 대응은 Android landscape 실제 크기에서 검증한다.

## 8. 계측

권장 event:

```text
onboarding_started
onboarding_step_shown
onboarding_step_completed
onboarding_skipped
onboarding_timeout
onboarding_core_completed
onboarding_boost_hint_shown
help_opened
```

필수 field:

```text
step
elapsed_seconds
cargo_stack_size
rear_token_type
active_switch_state
unload_group_size
fuel_ratio
skip_reason
```

## 9. 합격 기준

자동 검증:

- 안내 단계가 실제 domain event 순서와 일치한다.
- 첫 LOAD와 첫 switch에서만 안전 정지가 발생한다.
- skip·timeout·resume 후 simulation이 잠기지 않는다.
- onboarding이 score·fuel reward·Combo·spawn 결과를 중복 발생시키지 않는다.
- core completion 후 일반 balance가 복원된다.
- 이미 완료한 사용자에게 first-run assist가 다시 적용되지 않는다.

사람 검증, 최소 5명:

- 4/5 이상이 3분 안에 LOAD와 분기 조작을 독립 수행한다.
- 4/5 이상이 `가장 뒤 token이 먼저 내린다`고 설명한다.
- 4/5 이상이 Combo를 `한 역에서 함께 내린 개수`로 설명한다.
- 3/5 이상이 안내가 플레이를 과도하게 끊지 않았다고 평가한다.
- 첫 필수 입력 전에 불공정한 연료 0·경로 선택 실패가 0건이다.

## 10. 미검증 경계

- 0.5× 연료 소모, 120초 종료, 35% BOOST 안내, 3초 복귀는 `TEST_VALUE`다.
- 실제 초기 배치의 다양성·반복감·Android 가독성은 `NOT_RUN`이다.
- 이 문서 승인만으로 제품 구현·Android export·사람 검증이 완료된 것으로 간주하지 않는다.
