# Mid-Run Exit Confirmation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a visible, confirmation-protected way to abandon the current Vertical Slice stage from both BUILD and active RUN gameplay and return safely to TITLE.

**Architecture:** Keep overlay and flow authority in `DemoFlowController`. ProductHUD emits a menu intent, ProductFiniteSlice re-emits it and accepts a shell input lock, and the shell drives `PAUSED → EXIT_CONFIRM → PAUSED/TITLE` without adding a new finite-domain rule. Active runs continue to use existing `PAUSE` and `RESUME` commands; BUILD uses a shell-only modal pause.

**Tech Stack:** Godot 4.7.1-stable, GDScript, existing custom headless test runner, GitHub Actions.

## Global Constraints

- Do not change finite delivery, LIFO, map, scoring, Android validation, export identity, or production cutover state.
- `현재 플레이 종료` abandons only the current gameplay instance; it never calls `SceneTree.quit()`.
- A destructive exit requires a second explicit confirmation.
- `계속 플레이` is the initially focused confirmation button.
- Pause and confirmation overlays must lock product keyboard input.
- Tests are written and observed failing before production implementation.
- Existing default `run/main_scene`, validation feature override, and canonical Android evidence remain unchanged.

---

### Task 1: Add RED Contracts for Mid-Run Exit

**Files:**
- Create: `tests/demo/test_demo_mid_run_exit.gd`
- Modify: `tests/demo/test_demo_overlay_ownership.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Consumes: `DemoFlowController.state() -> StringName`, `gameplay_instance() -> Control`, `ProductFiniteSlice.session_controller() -> RefCounted`.
- Produces: executable behavior contract for `MenuButton`, `ExitButton`, `ExitConfirmOverlay`, cancel, confirmation, and shell input lock.

- [ ] **Step 1: Write the failing integration test**

Create `tests/demo/test_demo_mid_run_exit.gd`:

```gdscript
extends "res://tests/test_case.gd"

const DemoScene := preload("res://game/demo/vertical_slice_demo.tscn")


func run() -> void:
	var tree := Engine.get_main_loop() as SceneTree
	assert_not_null(tree, "mid-run exit test requires SceneTree")
	if tree == null:
		return

	var demo: Control = DemoScene.instantiate()
	tree.root.add_child(demo)
	demo.start_demo()
	demo.begin_build()

	var product: Control = demo.gameplay_instance()
	assert_not_null(product, "gameplay instance exists")
	if product == null:
		demo.free()
		return

	var menu_button := product.get_node_or_null("HUD/TopStatus/MenuButton") as Button
	assert_not_null(menu_button, "persistent menu button exists")
	if menu_button == null:
		demo.free()
		return

	menu_button.pressed.emit()
	assert_equal(demo.state(), &"PAUSED", "menu opens shell pause during BUILD")
	assert_equal(product.session_controller().phase(), &"BUILD", "BUILD menu does not mutate finite phase")
	assert_true(product.shell_input_locked_for_test(), "pause shell locks product input")

	var exit_button := demo.get_node_or_null("PauseOverlay/Panel/Content/ExitButton") as Button
	assert_not_null(exit_button, "pause overlay exposes current-play exit")
	if exit_button == null:
		demo.free()
		return

	exit_button.pressed.emit()
	assert_equal(demo.state(), &"EXIT_CONFIRM", "exit button opens confirmation")
	assert_true(demo.get_node("ExitConfirmOverlay").visible, "confirmation overlay is visible")
	assert_true(product.shell_input_locked_for_test(), "confirmation keeps gameplay locked")

	var continue_button := demo.get_node("ExitConfirmOverlay/Panel/Content/ContinueButton") as Button
	continue_button.pressed.emit()
	assert_equal(demo.state(), &"PAUSED", "continue returns to pause")
	assert_true(demo.gameplay_instance() == product, "cancel preserves the same gameplay instance")

	exit_button.pressed.emit()
	var confirm_button := demo.get_node("ExitConfirmOverlay/Panel/Content/ConfirmButton") as Button
	confirm_button.pressed.emit()
	assert_equal(demo.state(), &"TITLE", "confirmed exit returns to title")
	assert_true(demo.gameplay_instance() == null, "confirmed exit disposes gameplay")
	assert_true(demo.last_result() == null, "confirmed exit clears stale result")

	demo.free()
```

- [ ] **Step 2: Strengthen overlay ownership assertions**

Append these paths to `tests/demo/test_demo_overlay_ownership.gd` assertions:

```gdscript
for path: NodePath in [
	NodePath("PauseOverlay/Panel/Content/ResumeButton"),
	NodePath("PauseOverlay/Panel/Content/ExitButton"),
	NodePath("ExitConfirmOverlay/Panel/Content/ContinueButton"),
	NodePath("ExitConfirmOverlay/Panel/Content/ConfirmButton"),
]:
	assert_not_null(demo.get_node_or_null(path), "%s must exist" % path)
```

- [ ] **Step 3: Register the new test**

Add this preload to the demo test group in `tests/run_tests.gd`:

```gdscript
preload("res://tests/demo/test_demo_mid_run_exit.gd"),
```

- [ ] **Step 4: Run the suite and verify RED**

Run:

```bash
godot --headless --path . --script res://tests/run_tests.gd
```

Expected: existing tests pass; `test_demo_mid_run_exit.gd` fails because `HUD/TopStatus/MenuButton`, `ExitButton`, `ExitConfirmOverlay`, and `shell_input_locked_for_test()` do not exist.

- [ ] **Step 5: Commit RED contracts**

```bash
git add tests/demo/test_demo_mid_run_exit.gd tests/demo/test_demo_overlay_ownership.gd tests/run_tests.gd
git commit -m "test: require safe mid-run exit flow"
```

---

### Task 2: Implement Menu Intent and Shell Input Lock

**Files:**
- Modify: `game/demo/presentation/product_hud.gd`
- Modify: `game/demo/presentation/product_hud.tscn`
- Modify: `game/demo/product_finite_slice.gd`
- Test: `tests/demo/test_demo_mid_run_exit.gd`
- Test: `tests/demo/test_product_hud.gd`

**Interfaces:**
- Produces: `ProductHUD.menu_requested()`, `ProductFiniteSlice.menu_requested()`, `set_shell_input_locked(locked: bool) -> void`, `shell_input_locked_for_test() -> bool`.
- Consumed by: `DemoFlowController.open_pause_menu()` in Task 3.

- [ ] **Step 1: Add the HUD signal and button contract**

In `game/demo/presentation/product_hud.gd`, add:

```gdscript
signal menu_requested()
```

Connect `TopStatus/MenuButton` in `_ready()` using the existing button connection pattern:

```gdscript
_connect_button("TopStatus/MenuButton", func() -> void: menu_requested.emit())
```

- [ ] **Step 2: Add the persistent HUD button**

In `game/demo/presentation/product_hud.tscn`, append under `TopStatus` after `CostLabel`:

```gdscript
[node name="MenuButton" type="Button" parent="TopStatus"]
custom_minimum_size = Vector2(116, 48)
layout_mode = 2
text = "메뉴"
```

The button is not hidden by phase-specific toolbar visibility.

- [ ] **Step 3: Re-emit menu intent from ProductFiniteSlice**

In `game/demo/product_finite_slice.gd`, add:

```gdscript
signal menu_requested()
var _shell_input_locked: bool = false
```

In `_connect_hud()` add:

```gdscript
_hud.menu_requested.connect(func() -> void: menu_requested.emit())
```

Add:

```gdscript
func set_shell_input_locked(locked: bool) -> void:
	_shell_input_locked = locked
	_refresh_desktop_input_enabled()


func shell_input_locked_for_test() -> bool:
	return _shell_input_locked


func _refresh_desktop_input_enabled() -> void:
	var phase: StringName = _controller.phase()
	var terminal: bool = phase == &"SUCCESS" or phase == &"FAILURE"
	_desktop_input.set_gameplay_enabled(not _shell_input_locked and not terminal)
```

Replace the direct desktop enable call in `_apply_model()` with:

```gdscript
_refresh_desktop_input_enabled()
```

- [ ] **Step 4: Run focused tests**

Run:

```bash
godot --headless --path . --script res://tests/run_tests.gd
```

Expected: HUD and input-lock assertions progress; flow/overlay assertions remain RED until Task 3.

- [ ] **Step 5: Commit the product boundary**

```bash
git add game/demo/presentation/product_hud.gd game/demo/presentation/product_hud.tscn game/demo/product_finite_slice.gd
git commit -m "feat: expose persistent gameplay menu intent"
```

---

### Task 3: Add Pause Exit Confirmation Flow

**Files:**
- Modify: `game/demo/demo_flow_controller.gd`
- Modify: `game/demo/vertical_slice_demo.tscn`
- Test: `tests/demo/test_demo_mid_run_exit.gd`
- Test: `tests/demo/test_demo_flow_controller.gd`
- Test: `tests/demo/test_demo_flow_keyboard.gd`
- Test: `tests/demo/test_demo_overlay_ownership.gd`

**Interfaces:**
- Consumes: `ProductFiniteSlice.menu_requested()`, `set_shell_input_locked(bool)`, `session_controller().phase()`, `request_command(StringName, Variant)`.
- Produces:
  - `EXIT_CONFIRM: StringName`
  - `open_pause_menu() -> void`
  - `request_exit_confirmation() -> void`
  - `cancel_exit_confirmation() -> void`
  - `confirm_exit_to_title() -> void`

- [ ] **Step 1: Add shell state and button connections**

In `game/demo/demo_flow_controller.gd`, add:

```gdscript
const EXIT_CONFIRM: StringName = &"EXIT_CONFIRM"
```

In `_ready()` connect:

```gdscript
_connect_button("PauseOverlay/Panel/Content/ExitButton", request_exit_confirmation)
_connect_button("ExitConfirmOverlay/Panel/Content/ContinueButton", cancel_exit_confirmation)
_connect_button("ExitConfirmOverlay/Panel/Content/ConfirmButton", confirm_exit_to_title)
```

In `_ensure_gameplay_instance()` add:

```gdscript
_gameplay.menu_requested.connect(open_pause_menu)
```

- [ ] **Step 2: Implement menu opening for BUILD and RUN**

Add:

```gdscript
func open_pause_menu() -> void:
	if _state != GAMEPLAY or not is_instance_valid(_gameplay):
		return
	var phase: StringName = _gameplay.session_controller().phase()
	if phase == &"BUILD":
		_transition_to(PAUSED)
	elif phase == &"RUNNING" or phase == &"UNLOADING":
		_gameplay.request_command(&"PAUSE")
```

Update `_resume_demo()`:

```gdscript
func _resume_demo() -> void:
	if not is_instance_valid(_gameplay):
		set_paused(false)
		return
	var phase: StringName = _gameplay.session_controller().phase()
	if phase == &"PAUSED":
		_gameplay.request_command(&"RESUME")
	elif phase == &"BUILD" and _state == PAUSED:
		_transition_to(GAMEPLAY)
```

- [ ] **Step 3: Implement confirmation transitions**

Add:

```gdscript
func request_exit_confirmation() -> void:
	if _state != PAUSED:
		return
	_transition_to(EXIT_CONFIRM)
	var continue_button := get_node_or_null(
		"ExitConfirmOverlay/Panel/Content/ContinueButton"
	) as Button
	if continue_button != null:
		continue_button.grab_focus()


func cancel_exit_confirmation() -> void:
	if _state == EXIT_CONFIRM:
		_transition_to(PAUSED)


func confirm_exit_to_title() -> void:
	if _state == EXIT_CONFIRM:
		return_to_title()
```

Extend `dispatch_flow_action_for_test()`:

```gdscript
&"demo_cancel":
	match _state:
		EXIT_CONFIRM:
			cancel_exit_confirmation()
			return true
```

Do not map `demo_confirm` directly to `confirm_exit_to_title()`.

- [ ] **Step 4: Lock gameplay input from shell states**

At the end of `_sync_visibility()` add:

```gdscript
_set_visible("ExitConfirmOverlay", _state == EXIT_CONFIRM)
if is_instance_valid(_gameplay):
	_gameplay.set_shell_input_locked(_state != GAMEPLAY)
```

Keep `GameplayContainer` visible for `EXIT_CONFIRM` by including it in the existing visibility expression.

- [ ] **Step 5: Add scene controls**

Increase Pause panel minimum height to `320` and add:

```gdscript
[node name="ExitButton" type="Button" parent="PauseOverlay/Panel/Content"]
custom_minimum_size = Vector2(0, 56)
layout_mode = 2
text = "현재 플레이 종료"
```

Add the full-screen confirmation overlay after PauseOverlay:

```gdscript
[node name="ExitConfirmOverlay" type="CenterContainer" parent="."]
layout_mode = 1
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
grow_horizontal = 2
grow_vertical = 2

[node name="Panel" type="PanelContainer" parent="ExitConfirmOverlay"]
custom_minimum_size = Vector2(520, 340)
layout_mode = 2

[node name="Content" type="VBoxContainer" parent="ExitConfirmOverlay/Panel"]
layout_mode = 2
theme_override_constants/separation = 18

[node name="Title" type="Label" parent="ExitConfirmOverlay/Panel/Content"]
layout_mode = 2
theme_override_font_sizes/font_size = 30
text = "현재 플레이를 종료할까요?"
horizontal_alignment = 1

[node name="Body" type="Label" parent="ExitConfirmOverlay/Panel/Content"]
layout_mode = 2
size_flags_vertical = 3
text = "현재 노선과 진행 상황은 저장되지 않습니다."
horizontal_alignment = 1
vertical_alignment = 1

[node name="ContinueButton" type="Button" parent="ExitConfirmOverlay/Panel/Content"]
custom_minimum_size = Vector2(0, 56)
layout_mode = 2
text = "계속 플레이"

[node name="ConfirmButton" type="Button" parent="ExitConfirmOverlay/Panel/Content"]
custom_minimum_size = Vector2(0, 56)
layout_mode = 2
text = "종료하고 타이틀로"
```

- [ ] **Step 6: Run tests and verify GREEN**

Run:

```bash
godot --headless --path . --script res://tests/run_tests.gd
```

Expected: all registered Godot cases pass with zero failures and no script/runtime error.

- [ ] **Step 7: Commit flow implementation**

```bash
git add game/demo/demo_flow_controller.gd game/demo/vertical_slice_demo.tscn tests/demo/test_demo_flow_controller.gd tests/demo/test_demo_flow_keyboard.gd tests/demo/test_demo_overlay_ownership.gd
git commit -m "feat: add confirmed mid-run exit to title"
```

---

### Task 4: Adversarial Regression and Canonical Sync

**Files:**
- Create: `기획서/50_제작_검증/SX_AUD_022_MID_RUN_EXIT_AUDIT.md`
- Modify: `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
- Verify: `.github/workflows/godot-tests.yml`
- Sync: correct Google Sheet `1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo`

**Interfaces:**
- Produces: `SX-DEC-039`, `EV-USER-025`, `SX-AUD-022` with identical GitHub/Sheet state.

- [ ] **Step 1: Run full GitHub Actions verification**

Push the implementation branch and wait for `Godot Tests` to finish.

Expected:

```text
Run headless tests: success
Run Switchy real-project live-editor Pilot: success
Workflow conclusion: success
```

- [ ] **Step 2: Perform adversarial checks**

Verify all of these from automated evidence:

```text
BUILD menu does not send PAUSE to finite controller
RUN menu sends PAUSE exactly once
Cancel does not recreate or mutate gameplay
Confirm frees gameplay and returns TITLE
Exit confirm blocks keyboard gameplay commands
Title Quit still calls application quit only from TITLE
Android validation files and canonical APK evidence unchanged
```

- [ ] **Step 3: Record audit and decision**

Create `SX_AUD_022_MID_RUN_EXIT_AUDIT.md` with exact workflow number, run ID, verified commit, test count, assertion count, failures, and manual gate state.

Update `CURRENT_CONFIRMED_DECISIONS.md`:

```text
SX-DEC-039 | Mid-Run Exit | persistent menu → pause → confirmation → title | AUTOMATED_PASS · LOCAL_RETEST_REQUIRED
```

Keep Windows runtime, Android device, five-person comprehension, and production cutover as NOT_RUN/BLOCKED.

- [ ] **Step 4: Sync Google Sheet**

Insert matching rows in:

```text
01_작업순서
02_현재_확정결정
03_근거_라이브러리
50_제작_검증
```

Use `SX-DEC-039`, `EV-USER-025`, and `SX-AUD-022` in all four tabs, then read back the exact rows.

- [ ] **Step 5: Final commit**

```bash
git add 기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md 기획서/50_제작_검증/SX_AUD_022_MID_RUN_EXIT_AUDIT.md
git commit -m "docs: record mid-run exit authority"
```

## Self-Review

- Spec coverage: persistent access, safe confirmation, BUILD/RUN distinction, input lock, disposal, tests, and manual gate are each mapped to Tasks 1–4.
- Placeholder scan: no TBD, TODO, deferred implementation, or undefined interface remains.
- Type consistency: all state constants are `StringName`; menu signals have no arguments; shell lock accepts `bool`; gameplay controller phase is queried as `StringName`.
- Scope: one shell UX feature; no independent subsystem is bundled.
