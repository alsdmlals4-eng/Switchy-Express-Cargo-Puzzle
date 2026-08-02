# Difficulty Escalation Communication Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add deterministic prewarning and a compact persistent difficulty-pressure indicator without moving escalation authority into UI or changing existing run, onboarding, camera, seed, or record contracts.

**Architecture:** `DifficultyDirector` remains the sole authority for difficulty schedule and committed steps. A pure `DifficultySignalPolicy` consumes immutable forecasts and committed events, a generation-safe `DifficultyPresentationState` handles banner visibility/coalescing only, and `DifficultyViewModel` feeds non-authoritative HUD surfaces. Pause, first-run assist, restart, suspend/resume, and Reduced Motion are explicit integration boundaries.

**Tech Stack:** Godot 4.7.1, GDScript, existing headless test runner, Android landscape UI, versioned ruleset/config resources.

## Global Constraints

- Decision: `SX-DEC-022`; Evidence: `EV-USER-011`; GMB-001 slot `6/10`.
- Design: `docs/superpowers/specs/2026-08-02-difficulty-escalation-communication-design.md`.
- Difficulty schedule and committed step are owned only by `DifficultyDirector` or the existing authoritative equivalent.
- Presentation may read forecast and committed events but may not advance, delay, skip, or reroll difficulty.
- `FULL_MAP_READY` precedes difficulty progression.
- First-run assist and safe pause stop authoritative escalation and warning presentation; assist end resumes from remaining time without catch-up.
- Active run camera remains fixed full-map.
- Warning surfaces never pause simulation, lock board input, own rewards, or alter seed/ruleset/records.
- Same seed, ruleset, and input must produce the same difficulty commit sequence with warning UI enabled, disabled, or Reduced Motion.
- Initial `TEST_VALUE`: prewarning `5.0s`, banner `1.5s`, cooldown `8.0s`, bands `CALM/BUSY/INTENSE`, thresholds `0-1/2-3/4+`.
- Banner is at most two lines, non-interactive, safe-area aware, and cannot cover rails, stations, switches, cargo tokens, fuel warnings, or rear LIFO information.
- Product implementation does not start before GMB-001 10/10, canonical sync, and `READY_FOR_BUILD`.

---

## Planned File Map

```text
game/difficulty/difficulty_forecast.gd
→ Immutable forecast snapshot with generation and schedule revision

game/difficulty/difficulty_event.gd
→ Normalized authoritative committed-step event

game/difficulty/difficulty_director.gd
→ Existing/new sole authority for schedule, pause, forecast, and step commit

game/difficulty/difficulty_signal_config.gd
→ Versioned TEST_VALUE warning and band mapping config

game/difficulty/difficulty_signal_policy.gd
→ Pure forecast/event-to-intent logic

game/difficulty/difficulty_presentation_state.gd
→ Generation-safe visible/cooldown/coalesced presentation state

game/ui/difficulty/difficulty_view_model.gd
→ Pure copy/icon/marker mapping

game/ui/difficulty/difficulty_indicator.tscn
→ Persistent three-band HUD surface

game/ui/difficulty/difficulty_indicator.gd
→ Render-only indicator and banner binding

game/run/run_controller.gd
→ FULL_MAP_READY, pause, assist, restart, and director wiring only

game/play/play_scene.gd
→ Bind authoritative events to presentation state and view

tests/difficulty/test_difficulty_forecast.gd
tests/difficulty/test_difficulty_director.gd
tests/difficulty/test_difficulty_signal_policy.gd
tests/difficulty/test_difficulty_presentation_state.gd
tests/ui/test_difficulty_view_model.gd
tests/integration/test_difficulty_warning_run_flow.gd
tests/integration/test_difficulty_warning_lifecycle.gd
tests/integration/test_difficulty_warning_simulation_parity.gd
tests/run_tests.gd
```

---

### Task 1: Define Immutable Forecast and Committed Event Contracts

**Files:**
- Create: `game/difficulty/difficulty_forecast.gd`
- Create: `game/difficulty/difficulty_event.gd`
- Test: `tests/difficulty/test_difficulty_forecast.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**

```gdscript
# game/difficulty/difficulty_forecast.gd
class_name DifficultyForecast
extends RefCounted

var run_generation: int
var schedule_revision: int
var current_step: int
var next_step: int
var seconds_until_commit: float
var is_available: bool

static func unavailable(run_generation_value: int, revision_value: int) -> DifficultyForecast
static func create(
    run_generation_value: int,
    revision_value: int,
    current_step_value: int,
    next_step_value: int,
    seconds_until_commit_value: float
) -> DifficultyForecast
func validate() -> Array[StringName]
func duplicate_immutable() -> DifficultyForecast
```

```gdscript
# game/difficulty/difficulty_event.gd
class_name DifficultyEvent
extends RefCounted

const STEP_COMMITTED := &"difficulty_step_committed"

var type: StringName
var run_generation: int
var schedule_revision: int
var previous_step: int
var current_step: int
var committed_at_run_seconds: float

static func step_committed(
    run_generation_value: int,
    revision_value: int,
    previous_step_value: int,
    current_step_value: int,
    committed_at_value: float
) -> DifficultyEvent
func validate() -> Array[StringName]
```

- [ ] **Step 1: Write failing forecast validation tests**

```gdscript
func test_available_forecast_requires_forward_step_and_non_negative_time() -> void:
    var forecast := DifficultyForecast.create(7, 2, 1, 2, 5.0)
    assert_eq(forecast.validate(), [])

func test_forecast_rejects_generation_and_step_regression() -> void:
    var invalid := DifficultyForecast.create(-1, 0, 2, 2, -0.1)
    assert_true(invalid.validate().has(&"INVALID_RUN_GENERATION"))
    assert_true(invalid.validate().has(&"NEXT_STEP_NOT_FORWARD"))
    assert_true(invalid.validate().has(&"NEGATIVE_SECONDS_UNTIL_COMMIT"))
```

- [ ] **Step 2: Write failing committed-event tests**

```gdscript
func test_step_event_requires_exact_forward_commit() -> void:
    var event := DifficultyEvent.step_committed(3, 9, 1, 2, 42.0)
    assert_eq(event.validate(), [])

func test_step_event_rejects_non_forward_change() -> void:
    var event := DifficultyEvent.step_committed(3, 9, 2, 2, 42.0)
    assert_true(event.validate().has(&"STEP_NOT_FORWARD"))
```

- [ ] **Step 3: Run and verify RED**

```bash
godot --headless --path . -s res://tests/run_single.gd -- tests/difficulty/test_difficulty_forecast.gd
```

Expected: classes or methods not found.

- [ ] **Step 4: Implement immutable-copy constructors and exact validation codes**

Requirements:
- `unavailable()` has `is_available == false`, `next_step == current_step`, and `seconds_until_commit == 0.0`;
- available forecasts reject negative generation/revision/time and non-forward next steps;
- event rejects negative values, unknown type, non-forward step, and negative commit time;
- `duplicate_immutable()` returns a deep independent value object.

- [ ] **Step 5: Register focused tests and verify GREEN**

```bash
godot --headless --path . -s res://tests/run_single.gd -- tests/difficulty/test_difficulty_forecast.gd
```

- [ ] **Step 6: Commit**

```bash
git add game/difficulty/difficulty_forecast.gd game/difficulty/difficulty_event.gd tests/difficulty/test_difficulty_forecast.gd tests/run_tests.gd
git commit -m "feat: define difficulty forecast events"
```

---

### Task 2: Make DifficultyDirector the Sole Schedule Authority

**Files:**
- Create or Modify: `game/difficulty/difficulty_director.gd`
- Create: `tests/difficulty/test_difficulty_director.gd`
- Modify: `game/run/run_controller.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**

```gdscript
class_name DifficultyDirector
extends RefCounted

var run_generation: int
var schedule_revision: int
var current_step: int
var run_seconds: float

func reset_for_run(
    generation: int,
    ruleset_id: StringName,
    seed: int,
    step_durations_seconds: PackedFloat32Array
) -> void
func set_escalation_paused(paused: bool, reason: StringName) -> void
func is_escalation_paused() -> bool
func advance(delta_seconds: float) -> Array[DifficultyEvent]
func get_current_step() -> int
func get_forecast() -> DifficultyForecast
```

`RunController` produces:

```gdscript
func is_difficulty_progression_allowed() -> bool
func get_run_generation() -> int
func get_ruleset_id() -> StringName
func get_run_seed() -> int
```

- [ ] **Step 1: Write failing deterministic schedule tests**

```gdscript
func test_director_commits_only_after_authoritative_duration() -> void:
    var director := DifficultyDirector.new()
    director.reset_for_run(4, &"standard_v1", 99, PackedFloat32Array([10.0, 20.0]))
    assert_eq(director.advance(9.9).size(), 0)
    var events := director.advance(0.1)
    assert_eq(events.size(), 1)
    assert_eq(events[0].current_step, 1)
    assert_eq(director.get_current_step(), 1)

func test_same_inputs_produce_same_commit_sequence() -> void:
    var left := make_director(77)
    var right := make_director(77)
    var left_events := advance_sequence(left, [1.0, 4.0, 5.0, 10.0])
    var right_events := advance_sequence(right, [1.0, 4.0, 5.0, 10.0])
    assert_eq(serialize_events(left_events), serialize_events(right_events))
```

- [ ] **Step 2: Write failing pause and no-catch-up tests**

```gdscript
func test_pause_preserves_remaining_time_without_catch_up() -> void:
    var director := make_director(5)
    director.advance(7.0)
    director.set_escalation_paused(true, &"FIRST_RUN_ASSIST")
    assert_eq(director.advance(100.0).size(), 0)
    director.set_escalation_paused(false, &"FIRST_RUN_ASSIST")
    assert_eq(director.get_forecast().seconds_until_commit, 3.0)
    assert_eq(director.advance(2.9).size(), 0)
    assert_eq(director.advance(0.1).size(), 1)
```

- [ ] **Step 3: Run and verify RED**

```bash
godot --headless --path . -s res://tests/run_single.gd -- tests/difficulty/test_difficulty_director.gd
```

- [ ] **Step 4: Implement schedule progression using run delta only**

Rules:
- never read wall clock;
- `advance()` rejects negative delta and returns no events for zero delta;
- paused `advance()` changes neither run seconds nor remaining duration;
- each commit increments step by exactly one and emits one event;
- large delta may emit multiple ordered events, but presentation will coalesce banners;
- reset increments/sets generation and invalidates previous schedule revision;
- forecast is derived from authoritative remaining duration.

- [ ] **Step 5: Wire `RunController` gates**

```gdscript
func _process_run_delta(delta: float) -> void:
    if not is_difficulty_progression_allowed():
        difficulty_director.set_escalation_paused(true, _difficulty_pause_reason())
        return
    difficulty_director.set_escalation_paused(false, &"")
    for event in difficulty_director.advance(delta):
        difficulty_event_committed.emit(event)
```

`is_difficulty_progression_allowed()` must be false before `FULL_MAP_READY`, during manual pause, onboarding safe pause, and first-run escalation assist.

- [ ] **Step 6: Verify focused and existing run tests**

```bash
godot --headless --path . -s res://tests/run_single.gd -- tests/difficulty/test_difficulty_director.gd
godot --headless --path . -s res://tests/run_single.gd -- tests/run
```

- [ ] **Step 7: Commit**

```bash
git add game/difficulty/difficulty_director.gd game/run/run_controller.gd tests/difficulty/test_difficulty_director.gd tests/run_tests.gd
git commit -m "feat: centralize difficulty schedule authority"
```

---

### Task 3: Add Versioned Signal Config and Pure Intent Policy

**Files:**
- Create: `game/difficulty/difficulty_signal_config.gd`
- Create: `game/difficulty/difficulty_signal_policy.gd`
- Create: `tests/difficulty/test_difficulty_signal_policy.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**

```gdscript
class_name DifficultySignalConfig
extends Resource

@export var config_version := 1
@export var prewarning_lead_seconds := 5.0
@export var banner_visible_seconds := 1.5
@export var banner_cooldown_seconds := 8.0
@export var band_step_thresholds := PackedInt32Array([0, 2, 4])

func validate() -> Array[StringName]
func band_for_step(step: int) -> StringName
```

```gdscript
class_name DifficultySignalPolicy
extends RefCounted

const INTENT_SHOW_PREWARNING := &"show_difficulty_prewarning"
const INTENT_SHOW_COMMIT_FALLBACK := &"show_difficulty_commit_fallback"
const INTENT_UPDATE_BAND := &"update_difficulty_band"
const INTENT_DISCARD_STALE := &"discard_stale_difficulty_signal"

func evaluate_forecast(
    forecast: DifficultyForecast,
    state: DifficultyPresentationState,
    config: DifficultySignalConfig,
    presentation_allowed: bool
) -> Array[Dictionary]

func evaluate_committed_event(
    event: DifficultyEvent,
    state: DifficultyPresentationState,
    config: DifficultySignalConfig,
    presentation_allowed: bool
) -> Array[Dictionary]
```

- [ ] **Step 1: Write failing config validation and band mapping tests**

```gdscript
func test_default_config_maps_steps_into_three_bands() -> void:
    var config := DifficultySignalConfig.new()
    assert_eq(config.validate(), [])
    assert_eq(config.band_for_step(0), &"CALM")
    assert_eq(config.band_for_step(2), &"BUSY")
    assert_eq(config.band_for_step(4), &"INTENSE")
    assert_eq(config.band_for_step(99), &"INTENSE")

func test_config_rejects_unsorted_or_negative_thresholds() -> void:
    var config := DifficultySignalConfig.new()
    config.band_step_thresholds = PackedInt32Array([0, 4, 2])
    assert_true(config.validate().has(&"BAND_THRESHOLDS_NOT_STRICTLY_ASCENDING"))
```

- [ ] **Step 2: Write failing prewarning and stale-revision tests**

```gdscript
func test_forecast_inside_lead_window_emits_one_prewarning() -> void:
    var state := make_state(5, 8, 1)
    var forecast := DifficultyForecast.create(5, 8, 1, 2, 5.0)
    var intents := policy.evaluate_forecast(forecast, state, config, true)
    assert_eq(intents.size(), 1)
    assert_eq(intents[0].type, DifficultySignalPolicy.INTENT_SHOW_PREWARNING)
    assert_eq(intents[0].target_step, 2)

func test_revision_mismatch_discards_forecast() -> void:
    var state := make_state(5, 9, 1)
    var forecast := DifficultyForecast.create(5, 8, 1, 2, 5.0)
    var intents := policy.evaluate_forecast(forecast, state, config, true)
    assert_eq(intents[0].type, DifficultySignalPolicy.INTENT_DISCARD_STALE)
```

- [ ] **Step 3: Write failing committed-event fallback tests**

```gdscript
func test_unwarned_commit_updates_band_and_shows_generic_fallback() -> void:
    var state := make_state(2, 1, 1)
    var event := DifficultyEvent.step_committed(2, 1, 1, 2, 10.0)
    var intents := policy.evaluate_committed_event(event, state, config, true)
    assert_true(has_intent(intents, DifficultySignalPolicy.INTENT_UPDATE_BAND))
    assert_true(has_intent(intents, DifficultySignalPolicy.INTENT_SHOW_COMMIT_FALLBACK))
```

- [ ] **Step 4: Run and verify RED**

- [ ] **Step 5: Implement pure policy without clocks, nodes, signals, or Profile writes**

Rules:
- forecast outside lead window emits no intent;
- target step already warned emits no duplicate;
- presentation disallowed emits suppression/discard result but no visible banner;
- committed event always emits latest band update when generation/revision is current;
- if the target was not warned, emit generic commit fallback unless cooldown handling coalesces it;
- invalid config returns safe `CALM` mapping and records validation failure at load boundary.

- [ ] **Step 6: Verify GREEN and commit**

```bash
godot --headless --path . -s res://tests/run_single.gd -- tests/difficulty/test_difficulty_signal_policy.gd
git add game/difficulty/difficulty_signal_config.gd game/difficulty/difficulty_signal_policy.gd tests/difficulty/test_difficulty_signal_policy.gd tests/run_tests.gd
git commit -m "feat: define difficulty signal policy"
```

---

### Task 4: Build Generation-Safe Presentation State and Coalescing

**Files:**
- Create: `game/difficulty/difficulty_presentation_state.gd`
- Create: `tests/difficulty/test_difficulty_presentation_state.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**

```gdscript
class_name DifficultyPresentationState
extends RefCounted

enum Mode { HIDDEN, STEADY, PREWARNING, COOLDOWN }

var mode := Mode.HIDDEN
var run_generation := -1
var schedule_revision := -1
var current_step := 0
var current_band := &"CALM"
var warned_for_next_step := -1
var banner_remaining_seconds := 0.0
var cooldown_remaining_seconds := 0.0
var coalesced_committed_step := -1
var banner_source := &""

func reset(generation: int, revision: int, initial_step: int, initial_band: StringName) -> void
func apply_intents(intents: Array[Dictionary], config: DifficultySignalConfig) -> void
func advance_presentation_time(delta_seconds: float, paused: bool) -> Array[Dictionary]
func hide_and_invalidate() -> void
func snapshot() -> Dictionary
```

- [ ] **Step 1: Write failing banner lifecycle tests**

```gdscript
func test_prewarning_enters_visible_then_cooldown() -> void:
    var state := ready_state()
    state.apply_intents([prewarning_intent(2)], config)
    assert_eq(state.mode, DifficultyPresentationState.Mode.PREWARNING)
    assert_eq(state.banner_remaining_seconds, 1.5)
    state.advance_presentation_time(1.5, false)
    assert_eq(state.mode, DifficultyPresentationState.Mode.COOLDOWN)
    assert_eq(state.cooldown_remaining_seconds, 8.0)
```

- [ ] **Step 2: Write failing pause and coalescing tests**

```gdscript
func test_pause_does_not_consume_banner_or_cooldown_time() -> void:
    var state := visible_state()
    var before := state.snapshot()
    state.advance_presentation_time(99.0, true)
    assert_eq(state.snapshot(), before)

func test_multiple_commits_during_cooldown_keep_latest_step_only() -> void:
    var state := cooldown_state()
    state.apply_intents([band_update_intent(2), fallback_intent(2)], config)
    state.apply_intents([band_update_intent(3), fallback_intent(3)], config)
    assert_eq(state.current_step, 3)
    assert_eq(state.coalesced_committed_step, 3)
```

- [ ] **Step 3: Write failing generation invalidation test**

```gdscript
func test_old_generation_intent_cannot_mutate_new_run() -> void:
    var state := ready_state_with_generation(10)
    state.apply_intents([prewarning_intent_for_generation(9, 2)], config)
    assert_eq(state.mode, DifficultyPresentationState.Mode.STEADY)
    assert_eq(state.warned_for_next_step, -1)
```

- [ ] **Step 4: Run and verify RED**

- [ ] **Step 5: Implement state transitions and latest-only coalescing**

Requirements:
- visible and cooldown timers use run presentation delta, never wall clock;
- paused call is an exact no-op;
- band updates apply immediately even while banner is cooling down;
- cooldown end emits at most one `show_coalesced_latest` action;
- reset clears all pending callbacks and source fields;
- negative or non-finite delta is rejected;
- generation/revision mismatch cannot mutate state.

- [ ] **Step 6: Verify GREEN and commit**

```bash
godot --headless --path . -s res://tests/run_single.gd -- tests/difficulty/test_difficulty_presentation_state.gd
git add game/difficulty/difficulty_presentation_state.gd tests/difficulty/test_difficulty_presentation_state.gd tests/run_tests.gd
git commit -m "feat: add difficulty presentation lifecycle"
```

---

### Task 5: Add ViewModel, Persistent Indicator, and Warning Banner

**Files:**
- Create: `game/ui/difficulty/difficulty_view_model.gd`
- Create: `game/ui/difficulty/difficulty_indicator.tscn`
- Create: `game/ui/difficulty/difficulty_indicator.gd`
- Create: `tests/ui/test_difficulty_view_model.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**

```gdscript
class_name DifficultyViewModel
extends RefCounted

var band_key: StringName
var band_label_key: StringName
var filled_marker_count: int
var marker_count: int
var banner_title_key: StringName
var banner_body_key: StringName
var banner_visible: bool
var reduced_motion: bool
var warning_source: StringName

static func from_state(
    state: DifficultyPresentationState,
    reduced_motion_value: bool
) -> DifficultyViewModel
```

```gdscript
# difficulty_indicator.gd
extends Control

func render(view_model: DifficultyViewModel) -> void
func force_hidden() -> void
```

- [ ] **Step 1: Write failing band semantics tests**

```gdscript
func test_busy_band_uses_text_shape_and_two_filled_markers() -> void:
    var state := state_with_band(&"BUSY")
    var vm := DifficultyViewModel.from_state(state, false)
    assert_eq(vm.band_label_key, &"ui.difficulty.band.busy")
    assert_eq(vm.marker_count, 3)
    assert_eq(vm.filled_marker_count, 2)
```

- [ ] **Step 2: Write failing warning-source and Reduced Motion tests**

```gdscript
func test_forecast_warning_uses_two_line_copy_keys() -> void:
    var vm := DifficultyViewModel.from_state(forecast_warning_state(), false)
    assert_true(vm.banner_visible)
    assert_eq(vm.banner_title_key, &"ui.difficulty.warning.title")
    assert_eq(vm.banner_body_key, &"ui.difficulty.warning.body")

func test_reduced_motion_preserves_copy_and_markers() -> void:
    var normal := DifficultyViewModel.from_state(forecast_warning_state(), false)
    var reduced := DifficultyViewModel.from_state(forecast_warning_state(), true)
    assert_eq(reduced.banner_title_key, normal.banner_title_key)
    assert_eq(reduced.banner_body_key, normal.banner_body_key)
    assert_eq(reduced.filled_marker_count, normal.filled_marker_count)
    assert_true(reduced.reduced_motion)
```

- [ ] **Step 3: Run and verify RED**

- [ ] **Step 4: Implement view model mapping and localization keys**

Exact keys:

```text
ui.difficulty.band.calm
ui.difficulty.band.busy
ui.difficulty.band.intense
ui.difficulty.warning.title
ui.difficulty.warning.body
ui.difficulty.warning.fallback
```

- [ ] **Step 5: Build reserved HUD-lane scene**

Scene requirements:
- non-interactive `mouse_filter = IGNORE`;
- persistent indicator remains visible during active run;
- banner uses at most two text rows;
- no full-screen overlay, camera shake, rotation, overshoot, or board input capture;
- Reduced Motion toggles immediate static visibility instead of Tween;
- view never calls DifficultyDirector or RunController mutation methods.

- [ ] **Step 6: Add UI-state tests**

```gdscript
func test_indicator_does_not_capture_pointer_input() -> void:
    var indicator := preload("res://game/ui/difficulty/difficulty_indicator.tscn").instantiate()
    assert_eq(indicator.mouse_filter, Control.MOUSE_FILTER_IGNORE)

func test_force_hidden_cancels_visuals_without_changing_view_model_state() -> void:
    var indicator := make_indicator_with_visible_banner()
    indicator.force_hidden()
    assert_false(indicator.is_banner_visible())
    assert_eq(indicator.get_bound_step_for_test(), 2)
```

- [ ] **Step 7: Verify GREEN and commit**

```bash
godot --headless --path . -s res://tests/run_single.gd -- tests/ui/test_difficulty_view_model.gd
git add game/ui/difficulty tests/ui/test_difficulty_view_model.gd tests/run_tests.gd
git commit -m "feat: add difficulty warning HUD"
```

---

### Task 6: Integrate First-Run Assist, Pause, Restart, and Suspend

**Files:**
- Modify: `game/run/run_controller.gd`
- Modify: `game/play/play_scene.gd`
- Create: `tests/integration/test_difficulty_warning_lifecycle.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**

```gdscript
# play_scene.gd integration boundary
func _on_difficulty_forecast_changed(forecast: DifficultyForecast) -> void
func _on_difficulty_event_committed(event: DifficultyEvent) -> void
func _reset_difficulty_presentation(generation: int) -> void
func _is_difficulty_presentation_allowed() -> bool
```

- [ ] **Step 1: Write failing FULL_MAP_READY and assist tests**

```gdscript
func test_no_forecast_or_warning_before_full_map_ready() -> void:
    var harness := DifficultyRunHarness.new()
    harness.start_in_prep_zoom()
    harness.advance(20.0)
    assert_eq(harness.director.current_step, 0)
    assert_eq(harness.warning_count(), 0)

func test_first_run_assist_pauses_step_and_warning() -> void:
    var harness := ready_assisted_harness()
    harness.advance(120.0)
    assert_eq(harness.director.current_step, 0)
    assert_eq(harness.warning_count(), 0)
```

- [ ] **Step 2: Write failing assist-end fresh-forecast test**

```gdscript
func test_assist_end_rebuilds_forecast_without_catch_up() -> void:
    var harness := ready_assisted_harness()
    harness.advance(60.0)
    harness.end_assist()
    assert_eq(harness.director.current_step, 0)
    assert_gt(harness.current_forecast().seconds_until_commit, 0.0)
    assert_eq(harness.warning_count(), 0)
```

- [ ] **Step 3: Write failing pause/restart/suspend tests**

```gdscript
func test_manual_pause_freezes_both_authoritative_and_visual_timers() -> void:
    var harness := harness_with_visible_warning()
    var before := harness.snapshot()
    harness.pause()
    harness.advance(30.0)
    assert_eq(harness.snapshot(), before)

func test_restart_discards_old_generation_callbacks() -> void:
    var harness := harness_with_pending_warning()
    var old_generation := harness.generation()
    harness.restart()
    harness.fire_delayed_callback_for_generation(old_generation)
    assert_eq(harness.current_step(), 0)
    assert_eq(harness.warning_count(), 0)

func test_resume_does_not_use_wall_clock_catch_up() -> void:
    var harness := active_harness()
    harness.suspend()
    harness.simulate_wall_clock_seconds(600.0)
    harness.resume()
    assert_eq(harness.current_step(), 0)
```

- [ ] **Step 4: Run and verify RED**

- [ ] **Step 5: Wire lifecycle using current generation/revision checks**

Rules:
- query forecast only when `FULL_MAP_READY`, active, unpaused, and escalation assist inactive;
- onboarding overlay has display priority over difficulty banner;
- ending assist requests a fresh forecast and does not replay suppressed warnings;
- restart calls director reset and presentation reset synchronously before scene animation;
- suspend/resume discards old forecast and rereads current authoritative state;
- delayed Tween callbacks compare captured generation before touching nodes.

- [ ] **Step 6: Verify integration tests and commit**

```bash
godot --headless --path . -s res://tests/run_single.gd -- tests/integration/test_difficulty_warning_lifecycle.gd
git add game/run/run_controller.gd game/play/play_scene.gd tests/integration/test_difficulty_warning_lifecycle.gd tests/run_tests.gd
git commit -m "feat: integrate difficulty warning lifecycle"
```

---

### Task 7: Prove Simulation Parity and End-to-End Warning Flow

**Files:**
- Create: `tests/integration/test_difficulty_warning_run_flow.gd`
- Create: `tests/integration/test_difficulty_warning_simulation_parity.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Consumes the completed director, signal policy, presentation state, view model, and run harness.
- Produces repeatable simulation hashes and end-to-end warning evidence.

- [ ] **Step 1: Write failing lead-window flow test**

```gdscript
func test_warning_precedes_commit_and_indicator_updates_after_commit() -> void:
    var harness := standard_harness(step_durations = [10.0])
    harness.advance(4.9)
    assert_eq(harness.warning_count(), 0)
    harness.advance(0.1)
    assert_eq(harness.last_warning_source(), &"FORECAST")
    assert_eq(harness.current_step(), 0)
    harness.advance(5.0)
    assert_eq(harness.current_step(), 1)
    assert_eq(harness.indicator_step(), 1)
```

- [ ] **Step 2: Write failing multi-step coalescing test**

```gdscript
func test_large_delta_commits_all_steps_but_stacks_no_banners() -> void:
    var harness := standard_harness(step_durations = [2.0, 2.0, 2.0])
    harness.advance(6.0)
    assert_eq(harness.current_step(), 3)
    assert_eq(harness.visible_banner_count(), 1)
    assert_eq(harness.indicator_step(), 3)
```

- [ ] **Step 3: Write failing UI parity test**

```gdscript
func test_warning_preferences_do_not_change_simulation_hash() -> void:
    var normal := run_scripted_session(warnings_enabled = true, reduced_motion = false)
    var hidden := run_scripted_session(warnings_enabled = false, reduced_motion = false)
    var reduced := run_scripted_session(warnings_enabled = true, reduced_motion = true)
    assert_eq(normal.simulation_hash, hidden.simulation_hash)
    assert_eq(normal.simulation_hash, reduced.simulation_hash)
    assert_eq(normal.difficulty_events, hidden.difficulty_events)
    assert_eq(normal.difficulty_events, reduced.difficulty_events)
```

- [ ] **Step 4: Run and verify RED**

- [ ] **Step 5: Complete only the minimal integration wiring needed for GREEN**

Do not add difficulty selection, numeric formula HUD, audio cue, haptic, Profile reward, or online telemetry upload in this task.

- [ ] **Step 6: Run focused and full headless suites**

```bash
godot --headless --path . -s res://tests/run_single.gd -- tests/integration/test_difficulty_warning_run_flow.gd
godot --headless --path . -s res://tests/run_single.gd -- tests/integration/test_difficulty_warning_simulation_parity.gd
godot --headless --path . -s res://tests/run_tests.gd
```

Expected: zero failures and identical simulation hashes across presentation modes.

- [ ] **Step 7: Commit**

```bash
git add tests/integration/test_difficulty_warning_run_flow.gd tests/integration/test_difficulty_warning_simulation_parity.gd tests/run_tests.gd
git commit -m "test: prove difficulty warning parity"
```

---

### Task 8: Add Bounded Telemetry and Android/Human Evidence Checklist

**Files:**
- Modify or Create: `game/telemetry/run_telemetry.gd`
- Create: `tests/integration/test_difficulty_warning_telemetry.gd`
- Modify: `기획서/50_제작_검증/PLAYTEST_PLAN.md`
- Modify: `기획서/40_표현/VISUAL_DIRECTION.md`
- Modify: `기획서/20_시스템_콘텐츠/CORE_SYSTEMS.md`
- Modify: `기획서/00_프로젝트_허브/EXECUTABLE_PROMPTS/CODEX_GOAL_VS_03.md`

**Interfaces:**

```gdscript
func record_difficulty_signal_event(
    event_name: StringName,
    run_generation: int,
    ruleset_id: StringName,
    schedule_revision: int,
    current_step: int,
    current_band: StringName,
    assisted_first_run: bool,
    reduced_motion: bool,
    warning_source: StringName
) -> void
```

Allowed events:

```text
difficulty_step_committed
difficulty_warning_shown
difficulty_warning_coalesced
difficulty_warning_fallback_shown
difficulty_warning_suppressed_assist
difficulty_warning_stale_discarded
difficulty_indicator_band_changed
```

- [ ] **Step 1: Write failing telemetry whitelist tests**

```gdscript
func test_signal_telemetry_contains_bounded_fields_only() -> void:
    var event := capture_warning_event()
    assert_eq(event.keys().sorted(), [
        "assisted_first_run",
        "current_band",
        "current_step",
        "event_name",
        "reduced_motion",
        "ruleset_id",
        "run_generation",
        "schedule_revision",
        "warning_source",
    ])
```

- [ ] **Step 2: Write failing assisted-segment test**

```gdscript
func test_assisted_suppression_is_not_counted_as_standard_warning_exposure() -> void:
    var events := capture_assisted_run_events()
    assert_eq(count_standard_warning_exposures(events), 0)
    assert_eq(count_named(events, &"difficulty_warning_suppressed_assist"), 1)
```

- [ ] **Step 3: Implement whitelist telemetry with no gameplay feedback path**

Telemetry writes must not be read by DifficultyDirector, ruleset config, reward services, or RecordStore during a run.

- [ ] **Step 4: Add exact Android evidence matrix**

```text
Required captures:
1. CALM persistent indicator
2. forecast prewarning
3. committed BUSY band
4. cooldown with a second committed step
5. INTENSE band
6. onboarding overlay priority with warning suppressed
7. manual pause preserving visible state
8. restart baseline with no stale banner
9. Reduced Motion static banner
10. 140% localization stress
11. 16:9 and each supported aspect/safe-area variant
```

- [ ] **Step 5: Add human validation script**

Ask at least five participants after an unprompted run:

```text
Q1. 방금 표시된 경고는 무엇이 바뀐다는 뜻이었나요?
Q2. 경고를 보고 다음 행동을 바꿀 수 있었나요? 무엇을 바꿨나요?
Q3. 현재 난이도 표시가 무엇을 뜻하는지 설명해 주세요.
Q4. 경고가 선로나 화물 판단을 방해했나요?
Q5. 표시가 너무 잦거나 너무 늦었다고 느꼈나요?
```

Acceptance:
- 4/5 이상이 `곧 운행 압력이 상승한다`는 의미를 설명;
- 4/5 이상이 persistent band의 상대적 압력을 설명;
- repeated occlusion/confusion complaint 0;
- exact values remain tunable when criteria fail.

- [ ] **Step 6: Run telemetry and full tests**

```bash
godot --headless --path . -s res://tests/run_single.gd -- tests/integration/test_difficulty_warning_telemetry.gd
godot --headless --path . -s res://tests/run_tests.gd
```

- [ ] **Step 7: Commit**

```bash
git add game/telemetry/run_telemetry.gd tests/integration/test_difficulty_warning_telemetry.gd tests/run_tests.gd 기획서/20_시스템_콘텐츠/CORE_SYSTEMS.md 기획서/40_표현/VISUAL_DIRECTION.md 기획서/50_제작_검증/PLAYTEST_PLAN.md 기획서/00_프로젝트_허브/EXECUTABLE_PROMPTS/CODEX_GOAL_VS_03.md
git commit -m "docs: define difficulty warning evidence gate"
```

---

## Final Verification Gate

Run only after all implementation tasks are complete and the project has been promoted to `READY_FOR_BUILD`:

```bash
godot --headless --path . -s res://tests/run_tests.gd
```

Then verify:

```text
- difficulty event sequence parity across UI modes
- warning target-step uniqueness
- no banner stack under multi-step commit
- assist/pause/restart/suspend lifecycle
- no product rule mutation from view or animation
- Android safe area and 140% localization captures
- Reduced Motion/mute information parity
- 5-person comprehension acceptance
- GDD, Core Systems, Visual Direction, Playtest Plan, Goal, Issue, Registry, and Sheet use SX-DEC-022 / EV-USER-011
```

Until that evidence exists, report:

```yaml
planning_spec: APPROVED
implementation: NOT_STARTED
automated_feature_tests: NOT_RUN
android: NOT_RUN
human_validation: NOT_RUN
status: APPROVED_PENDING_BATCH_MERGE
codex_state: CODEX_NOT_READY
```
