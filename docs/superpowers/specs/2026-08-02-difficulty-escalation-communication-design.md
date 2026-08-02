# Difficulty Escalation Communication Design

```yaml
decision_id: SX-DEC-022
evidence_id: EV-USER-011
batch_id: GMB-001
batch_slot: 6/10
status: APPROVED_PENDING_BATCH_MERGE
scope: PLANNING_ONLY
implementation: NOT_STARTED
codex_state: CODEX_NOT_READY
```

## 1. Decision

운행 중 난이도 상승은 정확한 내부 공식과 수치를 상시 공개하지 않는다. 대신 authoritative 난이도 시스템이 예정한 의미 있는 상승 직전에 짧은 경고를 표시하고, 상승 후에는 현재 압력 구간을 작은 3단계 지속 신호로 유지한다.

```text
authoritative forecast
→ 짧은 사전 경고
→ authoritative step commit
→ 지속 난이도 band 갱신
```

경고·아이콘·애니메이션·오디오는 난이도 시점, spawn 간격, 속도, 연료, 점수, route, seed, 기록 자격을 계산하거나 변경하지 않는다.

## 2. Why This Option

- 완전히 숨기면 spawn·속도 압력이 갑자기 변해 불공정하게 느껴질 수 있다.
- 정확한 수치 상시는 모바일 HUD를 복잡하게 만들고 퍼즐 판단보다 공식 감시를 유도한다.
- milestone 경고와 압축된 지속 신호는 대비 시간을 주면서 내부 밸런스 조정 자유도를 보존한다.
- 기존 `SX-DEC-016` first-run assist의 escalation pause, `SX-DEC-018` FULL_MAP_READY gate, 고정 전체 맵 계약과 함께 사용할 수 있다.

## 3. Goals

1. 플레이어가 난이도 상승 전에 짧게 대비할 수 있게 한다.
2. 현재 운행 압력을 한눈에 파악하게 한다.
3. UI 누락·지연·애니메이션 중단이 실제 난이도에 영향을 주지 않게 한다.
4. first-run assist, pause, restart, suspend/resume에서 stale 경고와 catch-up 상승을 방지한다.
5. Reduced Motion, mute, 색각 차이, 긴 localization에서도 같은 정보를 보존한다.
6. 동일 seed·ruleset·입력에서는 경고 설정과 무관하게 동일한 simulation 결과를 만든다.

## 4. Non-Goals

- 이 Decision은 난이도 공식, spawn 곡선, 속도 곡선, 연료 공식, 단계 개수의 최종 밸런스를 확정하지 않는다.
- 플레이어가 난이도 단계를 선택하는 기능을 추가하지 않는다.
- 운행 중 경고 때문에 simulation을 멈추거나 입력을 잠그지 않는다.
- 경고 전용 보상, 업적, 재화, 광고, 시즌, daily mission을 추가하지 않는다.
- 경고 UI에서 난이도 skip·delay·reroll을 제공하지 않는다.
- 오디오 cue와 haptic을 Vertical Slice 필수 범위로 두지 않는다.

## 5. Protected Existing Contracts

- `FULL_MAP_READY` 전에 fuel, timer, difficulty, spawn progression, board input, onboarding assist timer가 진행되지 않는다.
- active run 카메라는 고정 전체 맵이다.
- first-run assist 중 difficulty escalation은 pause된다.
- assist 종료 시 normal balance로 복귀하되 보류된 시간을 한 번에 catch-up하지 않는다.
- UI·Tween·animation completion은 gameplay 권위가 아니다.
- 같은 ruleset과 seed의 simulation은 cosmetic, camera, warning preference와 무관해야 한다.
- Reduced Motion은 정보량을 줄이지 않고 움직임만 제거한다.

## 6. Authoritative Architecture

```text
RunClock / RunState
    ↓
DifficultyDirector
    ├─ DifficultyForecast
    └─ DifficultyStepCommitted
          ↓
DifficultySignalPolicy
          ↓
DifficultyPresentationState
          ↓
DifficultyViewModel
          ↓
DifficultyIndicator / WarningBanner
```

### 6.1 DifficultyDirector

난이도 schedule과 현재 step의 유일한 권위다.

```gdscript
class_name DifficultyDirector

func get_current_step() -> int
func get_forecast() -> DifficultyForecast
func advance(delta_seconds: float) -> Array[DifficultyEvent]
func set_escalation_paused(paused: bool, reason: StringName) -> void
func reset_for_run(run_generation: int, ruleset_id: StringName, seed: int) -> void
```

- forecast는 현재 authoritative schedule의 읽기 전용 snapshot이다.
- presentation은 forecast를 추론하거나 자체 countdown으로 step을 commit하지 않는다.
- pause 중 authoritative due time도 진행하지 않는다.
- assist 종료 후 남은 시간이 그대로 이어지며 누적 catch-up이 없다.

### 6.2 DifficultyForecast

```gdscript
class_name DifficultyForecast

var run_generation: int
var schedule_revision: int
var current_step: int
var next_step: int
var seconds_until_commit: float
var is_available: bool
```

- forecast는 한 run generation과 schedule revision에만 유효하다.
- revision 또는 generation이 달라지면 기존 prewarning은 즉시 폐기한다.
- forecast가 손상·누락되면 사전 경고만 생략하고 simulation은 계속된다.

### 6.3 DifficultyStepCommitted

```gdscript
class_name DifficultyEvent

const STEP_COMMITTED := &"difficulty_step_committed"

var type: StringName
var run_generation: int
var schedule_revision: int
var previous_step: int
var current_step: int
var committed_at_run_seconds: float
```

- 지속 indicator는 committed event 또는 `get_current_step()` readback으로만 갱신한다.
- banner animation이 끝났는지는 step commit 근거가 아니다.

## 7. Presentation Policy

### 7.1 Initial TEST_VALUE

```yaml
prewarning_lead_seconds: 5.0
prewarning_allowed_range_seconds: 3.0-7.0
banner_visible_seconds: 1.5
banner_allowed_range_seconds: 1.0-2.0
banner_cooldown_seconds: 8.0
persistent_band_count: 3
band_thresholds_by_step:
  CALM: 0-1
  BUSY: 2-3
  INTENSE: 4+
```

모든 수치는 telemetry·Android·사람 검증 전 `TEST_VALUE`다.

### 7.2 Warning Rules

- forecast가 lead window에 진입하면 prewarning intent를 최대 1회 생성한다.
- 경고는 최대 2줄이며 기본 문구는 다음 의미를 유지한다.

```text
운행량 증가!
화물 요청이 곧 빨라집니다.
```

- 정확한 step 번호, spawn interval, 배율, 다음 임계 시각은 기본 HUD에 표시하지 않는다.
- cooldown 중 추가 step이 예정되면 banner를 stack하지 않는다.
- persistent indicator는 authoritative commit마다 즉시 최신 band로 갱신한다.
- cooldown 중 여러 step이 commit되면 하나의 최신 상태 banner만 허용하고 중간 banner는 coalesce한다.
- forecast가 없었지만 step commit을 받으면 즉시 중립 fallback banner `운행량 증가`를 표시할 수 있다.
- run end, restart, ruleset change, generation change 시 pending·coalesced intent를 모두 폐기한다.

### 7.3 Persistent Indicator

- HUD의 reserved top lane 안에서 Score/Fuel/Speed/Time과 충돌하지 않는 작은 비대화형 indicator를 사용한다.
- `CALM / BUSY / INTENSE` 의미를 텍스트+형태+채움 개수로 중복 부호화한다.
- 색상만으로 단계를 구분하지 않는다.
- 실제 내부 step 수가 3개를 초과해도 UI는 세 band로 압축할 수 있다.
- band mapping은 ruleset config이며 presentation이 임의 변경하지 않는다.

## 8. State Model

```gdscript
class_name DifficultyPresentationState

enum Mode {
    HIDDEN,
    STEADY,
    PREWARNING,
    COOLDOWN,
}

var run_generation: int
var schedule_revision: int
var current_step: int
var current_band: StringName
var warned_for_next_step: int
var banner_remaining_seconds: float
var cooldown_remaining_seconds: float
var coalesced_committed_step: int
```

상태 전이:

```text
RUN_READY
→ STEADY
→ valid forecast enters lead window
→ PREWARNING
→ banner timeout
→ COOLDOWN
→ authoritative STEP_COMMITTED
→ current band readback/update
→ cooldown end
→ STEADY or one coalesced latest banner
```

- presentation timer는 animation 가시성과 cooldown만 관리한다.
- authoritative difficulty countdown은 별도 RunClock/DifficultyDirector가 관리한다.
- gameplay pause 중 presentation timer도 pause해 경고가 pause 화면 뒤에서 소진되지 않게 한다.

## 9. First-Run Assist Contract

- assist active 동안 DifficultyDirector escalation clock과 presentation warning 모두 pause한다.
- assist가 끝날 때 기존 forecast를 재사용하지 않고 새 schedule revision snapshot을 요청한다.
- assist 종료 직후 stale prewarning 또는 여러 step catch-up을 실행하지 않는다.
- 정상 escalation은 남은 시간부터 이어진다.
- onboarding overlay와 난이도 banner를 동시에 표시하지 않는다. onboarding P0 guidance가 우선이다.
- assist 종료와 warning lead window가 같은 frame에 겹치면 다음 stable frame에서 하나의 warning intent만 생성한다.

## 10. Pause, Restart, Suspend, and Failure Handling

### Pause

- manual pause와 onboarding safe pause 중 simulation과 difficulty countdown은 멈춘다.
- banner visible/cooldown timer도 멈춘다.
- pause 화면에 새 warning banner를 띄우지 않는다.

### Restart

- 새 `run_generation`을 발급한다.
- current step·band는 baseline으로 즉시 reset한다.
- pending banner, coalesced step, Tween callback을 폐기한다.
- 이전 generation callback은 no-op이다.

### Suspend/Resume

- wall-clock 경과로 difficulty를 catch-up하지 않는다.
- resume 후 authoritative run clock 기준 forecast를 다시 읽는다.
- schedule revision mismatch가 있으면 presentation state를 재구성한다.

### Missing or Invalid Presentation Data

- unknown band mapping은 안전한 baseline indicator와 generic copy를 사용한다.
- UI scene load 실패는 simulation을 막지 않는다.
- forecast unavailable은 prewarning omission telemetry를 남기고 committed step readback으로 복구한다.

## 11. View Model and UI Contract

```gdscript
class_name DifficultyViewModel

var band_key: StringName
var band_label_key: StringName
var filled_marker_count: int
var marker_count: int
var banner_title_key: StringName
var banner_body_key: StringName
var banner_visible: bool
var reduced_motion: bool
```

Localization keys:

```text
ui.difficulty.band.calm
ui.difficulty.band.busy
ui.difficulty.band.intense
ui.difficulty.warning.title
ui.difficulty.warning.body
ui.difficulty.warning.fallback
```

UI constraints:

- banner는 선로·역·분기기·화물 token·fuel warning·rear LIFO token을 가리지 않는다.
- 최대 2줄, 긴 번역 140%에서도 핵심 board 영역을 침범하지 않는다.
- banner는 입력을 받지 않고 touch target을 차단하지 않는다.
- intro/outro animation은 no rotation, no camera shake, no overshoot를 기본으로 한다.
- Reduced Motion은 즉시 나타나고 정해진 시간 후 즉시 사라지는 static banner를 사용한다.
- mute 상태에서도 텍스트·형태 정보가 완전해야 한다.
- Vertical Slice 기본값은 haptic 없음이다.

## 12. Telemetry

Domain telemetry:

```text
difficulty_step_committed
```

Presentation telemetry:

```text
difficulty_warning_shown
difficulty_warning_coalesced
difficulty_warning_fallback_shown
difficulty_warning_suppressed_assist
difficulty_warning_stale_discarded
difficulty_indicator_band_changed
```

필수 fields:

```text
run_generation
ruleset_id
schedule_revision
current_step
current_band
assisted_first_run
reduced_motion
warning_source: FORECAST | COMMIT_FALLBACK
```

- presentation telemetry는 difficulty schedule 입력으로 되먹임하지 않는다.
- assisted segment는 standard balance·warning comprehension 분석과 분리한다.

## 13. Adversarial Findings

| Finding ID | Risk | Mitigation |
|---|---|---|
| `SX-AUD-004-F51` | UI가 난이도 시점·step을 소유하거나 animation completion으로 상승을 실행 | DifficultyDirector 단독 권위, presentation read-only event 소비 |
| `SX-AUD-004-F52` | forecast drift·late warning으로 실제 상승과 안내가 어긋남 | generation+revision validation, committed event readback, generic fallback |
| `SX-AUD-004-F53` | 반복 banner가 board를 가리고 주의를 과도하게 빼앗음 | 2줄 제한, reserved HUD lane, cooldown, coalescing, non-interactive surface |
| `SX-AUD-004-F54` | assist·pause·restart·resume에서 stale warning 또는 catch-up step 발생 | authoritative clock pause, fresh forecast, generation-safe reset, no wall-clock catch-up |
| `SX-AUD-004-F55` | 색상·motion·짧은 영문 기준 표현으로 접근성·번역 parity 붕괴 | 텍스트+형태+채움, Reduced Motion static state, 140% localization validation |

현재 알려진 P0/P1 open finding은 없다. runtime, Android, automated feature tests, localization stress, telemetry, 사람 이해 검증은 `NOT_STARTED / NOT_RUN`이다.

## 14. Acceptance Criteria

### Automated

- UI 없이도 같은 seed·ruleset·입력의 difficulty commit sequence가 동일하다.
- warning animation on/off 및 Reduced Motion on/off가 simulation hash를 바꾸지 않는다.
- warning은 forecast target step당 최대 한 번 생성된다.
- cooldown 중 step이 여러 번 commit돼도 banner stack이 없고 indicator는 최신 committed band다.
- first-run assist 동안 step commit과 warning이 0이다.
- assist 종료 후 catch-up commit이 없고 fresh forecast를 사용한다.
- pause 동안 authoritative countdown과 banner/cooldown timer가 모두 멈춘다.
- restart 후 이전 generation callback이 indicator·banner를 변경하지 않는다.
- forecast 누락 시 committed event fallback으로 현재 band가 복구된다.

### Android / Human

- 16:9 및 지원 aspect에서 banner가 핵심 board·HUD·safe area를 침범하지 않는다.
- 140% 긴 localization에서 2줄 의미를 보존한다.
- Reduced Motion과 mute에서 정보 손실이 없다.
- 5명 이상 중 4명 이상이 경고 후 `곧 운행 압력이 오른다`는 의미를 이해한다.
- 5명 이상 중 4명 이상이 정확한 수치를 읽지 않고도 준비 행동을 설명할 수 있다.
- 경고가 route 선택을 방해하거나 불필요하게 pause를 유도한다는 반복 피드백이 없어야 한다.

## 15. Planning Boundary

- 이 문서는 승인된 설계 정본이며 제품 구현 증거가 아니다.
- 구현은 GMB-001 10/10 pre-merge 감사, canonical merge, Sheet closure, `READY_FOR_BUILD` 뒤에만 시작한다.
- 최종 difficulty curve, band thresholds, warning timings는 runtime·Android·human evidence 전까지 `TEST_VALUE`다.

## 16. Canonical Consumers at 10/10 Audit

- `기획서/20_시스템_콘텐츠/CORE_SYSTEMS.md`
- `기획서/40_표현/VISUAL_DIRECTION.md`
- `기획서/50_제작_검증/PLAYTEST_PLAN.md`
- `기획서/00_프로젝트_허브/EXECUTABLE_PROMPTS/CODEX_GOAL_VS_03.md`
- `docs/superpowers/specs/2026-08-02-first-session-contextual-onboarding-design.md`
- `docs/superpowers/specs/2026-08-02-preparation-zoom-full-map-camera-design.md`
