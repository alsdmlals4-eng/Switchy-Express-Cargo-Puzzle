# First-Session Contextual Onboarding Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the user-approved `SX-DEC-016` contextual first-run onboarding inside the real endless run without creating tutorial-only gameplay rules or moving gameplay authority into UI.

**Architecture:** Add a pure `OnboardingState` that consumes existing domain events and emits guidance intents. A separate first-run assist policy selects safe initial opportunities and temporary balance modifiers, while CargoStack, RailSwitch, DeliveryLoop, RunController, score, fuel, Combo, and spawn systems remain authoritative. UI renders guidance and simulation-pause requests but never owns completion, reward, route, or save outcomes.

**Tech Stack:** Godot 4.7.1-stable, GDScript, current custom headless test runner, versioned local preferences, Android landscape UI.

## Global Constraints

- Decision: `SX-DEC-016` · `A_CONTEXTUAL_FIRST_RUN`.
- Design: `docs/superpowers/specs/2026-08-02-first-session-contextual-onboarding-design.md`.
- No separate tutorial map, tutorial currency, fake reward, or tutorial-only LIFO/Combo formula.
- First-run assist ends on core completion, explicit skip, or 120 seconds, whichever occurs first.
- First-run fuel drain multiplier starts at `0.5` and returns to normal over `3.0` seconds after assist end; both are `TEST_VALUE`.
- First LOAD and first switch may request a full safe simulation pause; no branch slow-motion mechanic is added.
- CargoStack, RailSwitch, DeliveryLoop, RunController, score, fuel, Combo, and spawn results stay domain-authoritative.
- UI animation completion signals never complete onboarding steps or trigger gameplay outcomes.
- Existing `SX-DEC-014` Combo and `SX-DEC-015` compact token contracts are unchanged.
- `CODEX_NOT_READY` remains until total planning and batch governance gates close.

---

## File Structure

### New domain files

- `game/onboarding/onboarding_state.gd` — pure step state machine consuming domain events.
- `game/onboarding/first_run_assist_policy.gd` — temporary first-run setup and balance modifiers.
- `game/onboarding/onboarding_event.gd` — normalized event names and payload validation.
- `game/onboarding/onboarding_preferences.gd` — versioned completion/skip persistence independent of best records.

### New presentation files

- `game/ui/onboarding/onboarding_overlay.tscn` — guidance surface and skip/help controls.
- `game/ui/onboarding/onboarding_overlay.gd` — renders guidance intents only.
- `game/ui/onboarding/onboarding_view_model.gd` — pure copy/icon/highlight mapping.
- `game/ui/help/help_panel.tscn` and `game/ui/help/help_panel.gd` — replayable reference cards without first-run assists.

### Tests

- `tests/onboarding/test_onboarding_state.gd`
- `tests/onboarding/test_first_run_assist_policy.gd`
- `tests/onboarding/test_onboarding_preferences.gd`
- `tests/onboarding/test_onboarding_view_model.gd`
- `tests/integration/test_onboarding_delivery_flow.gd`
- `tests/integration/test_onboarding_skip_resume.gd`
- `tests/ui/test_onboarding_overlay_state.gd`

### Existing files to modify after exact-code review

- `game/cargo/delivery_loop.gd` — expose or forward normalized pickup/station/unload events; do not add tutorial outcomes.
- `game/train/train_controller.gd` — honor an external safe-pause request before committed movement, without changing route authority.
- `game/rail/rail_switch.gd` or its integration owner — expose switch-selected and target-locked events.
- `game/run/run_controller.gd` — apply first-run balance modifiers and restore normal values.
- `game/save/record_store.gd` or a sibling preference store — keep onboarding preferences separate from best records.
- `game/play/play_scene.gd` — wire domain events to OnboardingState and guidance intents to UI.
- `tests/run_tests.gd` — register new test suites.

---

### Task 1: Define normalized onboarding events and pure state transitions

**Files:**
- Create: `game/onboarding/onboarding_event.gd`
- Create: `game/onboarding/onboarding_state.gd`
- Test: `tests/onboarding/test_onboarding_state.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**

```gdscript
# game/onboarding/onboarding_event.gd
class_name OnboardingEvent

const RUN_STARTED := &"run_started"
const PICKUP_LOADED := &"pickup_loaded"
const SWITCH_SELECTED := &"switch_selected"
const ROUTE_TARGET_LOCKED := &"route_target_locked"
const STATION_ARRIVED := &"station_arrived"
const CARGO_UNLOADED := &"cargo_unloaded"
const COMBO_AWARDED := &"combo_awarded"
const FUEL_CHANGED := &"fuel_changed"
const ONBOARDING_SKIPPED := &"onboarding_skipped"
const ASSIST_TIMEOUT := &"assist_timeout"

static func make(type: StringName, payload: Dictionary = {}) -> Dictionary:
    return {"type": type, "payload": payload.duplicate(true)}
```

```gdscript
# game/onboarding/onboarding_state.gd
class_name OnboardingState

enum Step {
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

var step: Step = Step.NOT_STARTED
var core_completed := false
var boost_hint_completed := false
var skipped := false
var assist_elapsed_seconds := 0.0

func start(already_completed: bool) -> Array[Dictionary]
func advance_time(delta: float) -> Array[Dictionary]
func consume_domain_event(event: Dictionary) -> Array[Dictionary]
func should_pause_simulation() -> bool
func skip(reason: StringName) -> Array[Dictionary]
```

- [ ] **Step 1: Write failing start and first-load tests**

```gdscript
func test_new_player_starts_at_first_load_and_requests_safe_pause() -> void:
    var state := OnboardingState.new()
    var intents := state.start(false)
    assert_eq(state.step, OnboardingState.Step.FIRST_LOAD)
    assert_true(state.should_pause_simulation())
    assert_eq(intents[0].type, &"show_first_load")

func test_completed_player_does_not_restart_onboarding() -> void:
    var state := OnboardingState.new()
    var intents := state.start(true)
    assert_true(state.core_completed)
    assert_false(state.should_pause_simulation())
    assert_eq(intents.size(), 0)
```

- [ ] **Step 2: Run focused tests and verify RED**

Run:

```bash
godot --headless --path . --script res://tests/run_tests.gd --suite onboarding_state
```

Expected: FAIL because the onboarding classes and suite registration do not exist.

- [ ] **Step 3: Implement the minimal start transition and guidance-intent shape**

Guidance intent fields:

```gdscript
{
    "type": StringName,
    "step": int,
    "pause_requested": bool,
    "highlight_target": StringName,
    "copy_key": StringName,
}
```

- [ ] **Step 4: Add failing event-order tests**

Cover exactly:

```text
FIRST_LOAD + pickup_loaded -> TOKEN_MEANING
TOKEN_MEANING acknowledgement -> FIRST_SWITCH
FIRST_SWITCH + switch_selected + route_target_locked -> LIFO_PROOF
LIFO_PROOF + cargo_unloaded(count=1, rear_before=B, rear_after=A) -> COMBO_PROOF
COMBO_PROOF + combo_awarded(count>=2) -> CORE_COMPLETE
CORE_COMPLETE + fuel_changed(ratio<=0.35) -> BOOST hint
```

- [ ] **Step 5: Implement minimal transitions and ignore unrelated/out-of-order events**

Out-of-order events must return no gameplay mutation and no step regression.

- [ ] **Step 6: Add and pass skip/timeout idempotency tests**

```gdscript
func test_skip_is_idempotent_and_releases_pause() -> void:
    var state := OnboardingState.new()
    state.start(false)
    state.skip(&"user")
    state.skip(&"user")
    assert_eq(state.step, OnboardingState.Step.SKIPPED)
    assert_false(state.should_pause_simulation())
```

- [ ] **Step 7: Run the focused and full suite**

```bash
godot --headless --path . --script res://tests/run_tests.gd --suite onboarding_state
godot --headless --path . --script res://tests/run_tests.gd
```

- [ ] **Step 8: Commit**

```bash
git add game/onboarding/onboarding_event.gd game/onboarding/onboarding_state.gd tests/onboarding/test_onboarding_state.gd tests/run_tests.gd
git commit -m "feat: add contextual onboarding state machine"
```

---

### Task 2: Add first-run assist policy without changing core formulas

**Files:**
- Create: `game/onboarding/first_run_assist_policy.gd`
- Test: `tests/onboarding/test_first_run_assist_policy.gd`
- Modify after exact-code review: run balance/setup owner only

**Interfaces:**

```gdscript
class_name FirstRunAssistPolicy

const MAX_ASSIST_SECONDS := 120.0
const FUEL_DRAIN_MULTIPLIER := 0.5
const RESTORE_SECONDS := 3.0
const BOOST_HINT_FUEL_RATIO := 0.35

var active := false
var elapsed_seconds := 0.0
var restore_elapsed_seconds := 0.0

func begin(first_run: bool) -> void
func advance_time(delta: float) -> Array[Dictionary]
func finish(reason: StringName) -> void
func fuel_drain_multiplier() -> float
func difficulty_escalation_enabled() -> bool
func prefer_initial_opportunities(board_context: Dictionary) -> Dictionary
```

- [ ] **Step 1: Write failing multiplier and timeout tests**

```gdscript
func test_first_run_assist_halves_fuel_drain_and_pauses_escalation() -> void:
    var policy := FirstRunAssistPolicy.new()
    policy.begin(true)
    assert_float_eq(policy.fuel_drain_multiplier(), 0.5)
    assert_false(policy.difficulty_escalation_enabled())

func test_assist_times_out_at_120_seconds() -> void:
    var policy := FirstRunAssistPolicy.new()
    policy.begin(true)
    var events := policy.advance_time(120.0)
    assert_false(policy.active)
    assert_eq(events[0].type, &"assist_timeout")
```

- [ ] **Step 2: Run and verify RED**

- [ ] **Step 3: Implement minimal modifier state**

Do not duplicate the fuel formula. The run economy owner must multiply its existing drain result by `fuel_drain_multiplier()`.

- [ ] **Step 4: Write failing 3-second restoration test**

Expected multipliers after finish:

```text
t=0.0 -> 0.50
t=1.5 -> 0.75
t=3.0 -> 1.00
```

- [ ] **Step 5: Implement linear restoration and clamp to 1.0**

- [ ] **Step 6: Add opportunity-selection tests**

The policy returns preferences, not forced domain outcomes:

```gdscript
{
    "first_pickup_max_eta_seconds": 4.0,
    "first_switch_max_eta_seconds": 10.0,
    "preferred_cargo_sequence": [&"red_star", &"blue_diamond"],
    "preferred_first_unload_type": &"blue_diamond",
    "preferred_combo_type": &"red_star",
    "preferred_combo_count": 2,
}
```

If a board cannot satisfy preferences, return a bounded fallback reason and continue with normal valid placement. Never create an invalid cell or bypass spawn constraints.

- [ ] **Step 7: Run focused and full regression tests**

- [ ] **Step 8: Commit**

```bash
git add game/onboarding/first_run_assist_policy.gd tests/onboarding/test_first_run_assist_policy.gd
git commit -m "feat: add first run assist policy"
```

---

### Task 3: Persist completion separately from run records

**Files:**
- Create: `game/onboarding/onboarding_preferences.gd`
- Test: `tests/onboarding/test_onboarding_preferences.gd`
- Modify after exact-code review: save service composition root

**Interfaces:**

```gdscript
class_name OnboardingPreferences

const SCHEMA_VERSION := 1

func load_from_dict(raw: Variant) -> Dictionary
func to_dict(core_completed: bool, boost_hint_completed: bool, skipped: bool) -> Dictionary
```

Canonical shape:

```json
{
  "schema_version": 1,
  "core_completed": false,
  "boost_hint_completed": false,
  "skipped": false
}
```

- [ ] **Step 1: Write failing default/corruption/version tests**
- [ ] **Step 2: Verify RED**
- [ ] **Step 3: Implement strict parsing with safe defaults**
- [ ] **Step 4: Prove corrupt onboarding preferences do not delete best score/time/max_combo**
- [ ] **Step 5: Run full save regression**
- [ ] **Step 6: Commit**

```bash
git add game/onboarding/onboarding_preferences.gd tests/onboarding/test_onboarding_preferences.gd
git commit -m "feat: persist onboarding preferences"
```

---

### Task 4: Integrate real pickup, switch, LIFO, Combo, and fuel events

**Files:**
- Create: `tests/integration/test_onboarding_delivery_flow.gd`
- Create: `tests/integration/test_onboarding_skip_resume.gd`
- Modify after exact-code review: existing DeliveryLoop, switch integration owner, RunController, PlayScene

**Interfaces:**

Existing systems emit normalized events after their domain mutation succeeds:

```gdscript
pickup_loaded: {"cargo_type": StringName, "stack_size": int, "rear_token_type": StringName}
switch_selected: {"switch_id": StringName, "state": int}
route_target_locked: {"switch_id": StringName, "next_cell": Vector2i}
cargo_unloaded: {"cargo_type": StringName, "count": int, "rear_before": StringName, "rear_after": StringName}
combo_awarded: {"unload_group_size": int, "max_combo": int}
fuel_changed: {"fuel": float, "fuel_ratio": float}
```

- [ ] **Step 1: Write a failing real-flow integration test**

The test must use real CargoStack/Station/DeliveryLoop logic to prove:

```text
load A -> load B -> unload B -> A remains -> load A -> unload A×2 -> Combo×2
```

- [ ] **Step 2: Verify RED before adding event forwarding**
- [ ] **Step 3: Add the smallest event forwarding after successful domain mutations**
- [ ] **Step 4: Add duplicate-event protection tests**
- [ ] **Step 5: Add skip during FIRST_LOAD and FIRST_SWITCH tests**
- [ ] **Step 6: Add resume tests proving no reward is repeated**
- [ ] **Step 7: Run all integration and full tests**
- [ ] **Step 8: Commit**

```bash
git add tests/integration/test_onboarding_delivery_flow.gd tests/integration/test_onboarding_skip_resume.gd <exact reviewed integration files>
git commit -m "feat: connect onboarding to real delivery events"
```

---

### Task 5: Build guidance ViewModel, safe pause, overlay, skip, and help

**Files:**
- Create: `game/ui/onboarding/onboarding_view_model.gd`
- Create: `game/ui/onboarding/onboarding_overlay.tscn`
- Create: `game/ui/onboarding/onboarding_overlay.gd`
- Create: `game/ui/help/help_panel.tscn`
- Create: `game/ui/help/help_panel.gd`
- Test: `tests/onboarding/test_onboarding_view_model.gd`
- Test: `tests/ui/test_onboarding_overlay_state.gd`
- Modify after exact-code review: `game/play/play_scene.gd`, train pause owner

**Interfaces:**

```gdscript
class_name OnboardingViewModel

static func from_intent(intent: Dictionary, reduced_motion: bool) -> Dictionary
```

Output:

```gdscript
{
    "copy_key": StringName,
    "primary_icon": StringName,
    "highlight_target": StringName,
    "show_skip": bool,
    "pause_requested": bool,
    "motion_mode": StringName,
}
```

- [ ] **Step 1: Write failing copy and highlight mapping tests for every step**
- [ ] **Step 2: Verify RED**
- [ ] **Step 3: Implement exact copy keys and 2-line limits**

Required Korean copy:

```text
LOAD를 누르고 있는 동안 화물을 싣습니다.
화물 1개가 작은 화차 1개로 뒤에 붙습니다.
분기기를 눌러 다음 경로를 바꿉니다.
가장 뒤 화물부터 내립니다.
같은 화물을 이어 싣고 한 번에 내리면 Combo가 커집니다.
BOOST는 빨라지지만 연료를 더 씁니다.
```

- [ ] **Step 4: Write failing safe-pause ownership tests**

Pause may be requested only in `FIRST_LOAD` and `FIRST_SWITCH`. UI hide/animation complete must not unpause; only domain action, skip, or teardown releases it.

- [ ] **Step 5: Implement overlay and skip wiring**
- [ ] **Step 6: Implement Help cards without enabling assist policy**
- [ ] **Step 7: Verify Reduced Motion, mute, and haptic-off preserve information**
- [ ] **Step 8: Run UI and full regression tests**
- [ ] **Step 9: Commit**

```bash
git add game/ui/onboarding game/ui/help tests/onboarding/test_onboarding_view_model.gd tests/ui/test_onboarding_overlay_state.gd <exact reviewed scene integration files>
git commit -m "feat: build onboarding guidance and help UI"
```

---

### Task 6: Add telemetry, representative captures, and human gate

**Files:**
- Modify: current telemetry event map after exact-code review
- Modify: `기획서/50_제작_검증/PLAYTEST_PLAN.md`
- Add evidence under the repository's existing evidence path

- [ ] **Step 1: Add telemetry schema tests**

Required event names:

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

Required fields:

```text
step, elapsed_seconds, cargo_stack_size, rear_token_type,
active_switch_state, unload_group_size, fuel_ratio, skip_reason
```

- [ ] **Step 2: Verify RED, implement schema, and pass focused tests**
- [ ] **Step 3: Capture 1920×1080 states**

Capture at minimum:

```text
FIRST_LOAD paused
first token meaning
FIRST_SWITCH paused with preview
mixed stack before B unload
B unloaded with A remaining
COMBO ×2
BOOST hint at <=35% fuel
Reduced Motion variants
```

These desktop captures are not Android evidence.

- [ ] **Step 4: Run Android landscape and 5-person human tests**

Pass thresholds:

```text
4/5 independently use LOAD and switch within 3 minutes
4/5 explain rear-token LIFO
4/5 explain Combo as one-arrival unload group size
3/5 report guidance did not interrupt excessively
0 unfair fuel-zero or forced-route failures before first required input
```

- [ ] **Step 5: Classify result PASS / REVISE / PIVOT / STOP**
- [ ] **Step 6: Update Decision and evidence only with executed results**
- [ ] **Step 7: Commit**

```bash
git add <telemetry files> 기획서/50_제작_검증/PLAYTEST_PLAN.md <evidence files>
git commit -m "test: validate first session onboarding"
```

---

## Plan Self-Review Result

- Spec coverage: every design section maps to Tasks 1–6.
- Authority boundary: no UI completion signal owns gameplay or onboarding completion.
- Tutorial-only rule check: none; assists modify only initial opportunity preference, temporary fuel multiplier, and difficulty escalation.
- Existing Decision compatibility: `SX-DEC-014` and `SX-DEC-015` remain unchanged.
- Placeholder scan: no `TBD`, generic test instruction, or undefined core interface remains.
- Current status: planning only; no product implementation or runtime evidence exists yet.
