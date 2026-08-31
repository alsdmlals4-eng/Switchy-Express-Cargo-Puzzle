# Title Screen Main Shell Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the cramped title dialog with a responsive, full-viewport main title shell that reuses the existing approved title artwork, adds the user-directed title wordmark candidate, and retains all current entry actions.

**Architecture:** Keep `DemoFlowController` as the sole owner of title-state transitions. Restructure only the `TitleScreen` node tree into a full-background composition; use existing `ProductShellArt` in `TITLE` mode for the exact hero asset and existing `DemoThemeFactory` styles for the two control decks. Add a narrow focus helper rather than new navigation state.

**Tech Stack:** Godot 4.7.1, GDScript, `.tscn` Controls/Containers, project-owned GUT-style runner.

**Spec:** `docs/superpowers/specs/2026-08-31-title-screen-main-shell-design.md`

## Global Constraints

- Reuse `art/product_assets/ed_hybrid_v1/shells/shell_title_hero_v01.png`. The approved amendment creates exactly one transparent **candidate** bitmap, `SX-TITLE-WORDMARK-001`, with a concrete `TitleLogo` runtime consumer and user pixel review still pending.
- Preserve the `StartButton`, `StageBookButton`, `ControlsButton`, and `QuitButton` logical actions; migrate every controller lookup to the new deck paths in the same task.
- Keep all finite gameplay, first-session, Route Book, save, and localization behavior unchanged.
- Initial TITLE focus is `StartButton`; all action buttons retain a visible focus state and at least 56px height.
- Candidate 007 remains exact historical evidence when the title runtime bytes change; do not describe it as evidence for the later bytes.

---

### Task 1: Specify the title main-shell scene contract in a failing test

**Files:**
- Modify: `tests/demo/test_demo_theme.gd`
- Modify: `tests/demo/test_demo_responsive_layout.gd`
- Test: `tests/demo/test_demo_theme.gd`, `tests/demo/test_demo_responsive_layout.gd`

**Interfaces:**
- Consumes: `DemoScene.instantiate() -> Control`, `DemoFlowController.state() -> StringName`.
- Produces: Tests requiring `TitleBackdrop`, `TitleShade`, `TitleDeck`, `ActionDeck`, and an explicit initial `StartButton` focus target.

- [ ] **Step 1: Write the failing title-shell topology test**

```gdscript
var backdrop := demo.get_node_or_null("TitleScreen/TitleBackdrop") as Control
assert_not_null(backdrop)
assert_equal(backdrop.mouse_filter, Control.MOUSE_FILTER_IGNORE)
assert_equal(backdrop.anchor_right, 1.0)
assert_equal(backdrop.anchor_bottom, 1.0)
assert_not_null(demo.get_node_or_null("TitleScreen/TitleMargin/TitleColumns/TitleDeck"))
assert_not_null(demo.get_node_or_null("TitleScreen/TitleMargin/TitleColumns/ActionDeck"))
```

- [ ] **Step 2: Run the focused scene tests and verify RED**

Run: `Godot_v4.7.1-stable_win64_console.exe --headless --path . --script res://tests/run_tests.gd -- --filter test_demo_theme,test_demo_responsive_layout`

Expected: FAIL because the current compact `TitleScreen/Panel` has no `TitleBackdrop` or two-deck layout.

- [ ] **Step 3: Add failing focus and action-reachability assertions**

```gdscript
demo.call_deferred("_sync_visibility")
await tree.process_frame
assert_true((demo.get_node("TitleScreen/TitleMargin/TitleColumns/TitleDeck/Content/StartButton") as Button).has_focus())
for button_path in TITLE_ACTIONS:
    var button := demo.get_node(button_path) as Button
    assert_true(button.custom_minimum_size.y >= 56.0)
```

- [ ] **Step 4: Commit only the RED test unit**

```text
git add tests/demo/test_demo_theme.gd tests/demo/test_demo_responsive_layout.gd
git commit -m "test: define main title shell contract"
```

### Task 2: Implement the responsive title scene and focused title entry

**Files:**
- Modify: `game/demo/vertical_slice_demo.tscn`
- Modify: `game/demo/demo_flow_controller.gd`
- Modify: `game/demo/presentation/demo_theme_factory.gd`
- Test: `tests/demo/test_demo_theme.gd`, `tests/demo/test_demo_responsive_layout.gd`

**Interfaces:**
- Consumes: `ProductShellArt` `TITLE` mode and `DemoFlowController`’s current button actions.
- Produces: `TitleScreen/TitleBackdrop`, `TitleShade`, `TitleMargin/TitleColumns/TitleDeck`, and `ActionDeck`, with focus-safe `StartButton` re-entry.

- [ ] **Step 1: Rebuild only the title subtree**

Place `TitleBackdrop` and `TitleShade` before an anchored `TitleMargin`. Place `TitleDeck`, a flexible spacer, and `ActionDeck` inside `TitleColumns`. Transfer the existing button names, text, 56px minimum size, and signals to their new node paths. Keep the existing non-title overlays untouched.

- [ ] **Step 2: Adapt controller paths and reset initial TITLE focus**

Define title-action path constants and use them in `_ready()` button wiring. Add a small `_focus_title_start()` after `_sync_visibility()` shows `TITLE`; call `grab_focus()` only when the primary control is visible and focusable.

```gdscript
const TITLE_START_BUTTON := NodePath("TitleScreen/TitleMargin/TitleColumns/TitleDeck/Content/StartButton")

func _focus_title_start() -> void:
    var start := get_node_or_null(TITLE_START_BUTTON) as Button
    if start != null and start.visible:
        start.grab_focus.call_deferred()
```

- [ ] **Step 3: Add minimal theme variations only if the test proves a missing deck treatment**

Use existing `ShellPanel` styling first. If separate primary emphasis is required, create one `TitlePrimaryButton` variation from the project palette; do not introduce a second UI framework, bitmap, icon, or color meaning.

- [ ] **Step 4: Run focused scene/focus/responsive tests to GREEN**

Run: `Godot_v4.7.1-stable_win64_console.exe --headless --path . --script res://tests/run_tests.gd -- --filter test_demo_theme,test_demo_responsive_layout,test_demo_flow_keyboard,test_playable_poc_visual_integration`

Expected: PASS; scene topology, exact title hero consumer, action behavior, and all supported layouts hold.

- [ ] **Step 5: Commit the runtime UI unit**

```text
git add game/demo/vertical_slice_demo.tscn game/demo/demo_flow_controller.gd game/demo/presentation/demo_theme_factory.gd tests/demo
git commit -m "feat: compose responsive main title shell"
```

### Task 3: Record current-state transition and prove the main shell does not leak scope

**Files:**
- Modify: `docs/decisions/SX_DEC_068_TITLE_SCREEN_MAIN_SHELL.md`
- Modify: `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
- Modify: `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
- Modify: `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md`
- Modify: `기획서/00_프로젝트_허브/ROADMAP.md`
- Create: `tests/python/test_sx_dec_068_title_screen_main_shell.py`

**Interfaces:**
- Consumes: the exact new runtime commit and machine test outputs.
- Produces: fail-closed candidate transition language and a freshness test that rejects a claim that Candidate 007 validates the changed title bytes.

- [ ] **Step 1: Write the failing candidate-boundary test**

```python
def test_title_shell_marks_candidate_007_historical_for_new_player_facing_bytes(self):
    pointer = json.loads(read("evidence/acceptance/post_sx_dec_060_candidate.json"))
    self.assertIn("SX60-POC-ACCEPT-007", pointer["current_candidate_id"])
    self.assertIn("SX-DEC-068", read("docs/decisions/SX_DEC_068_TITLE_SCREEN_MAIN_SHELL.md"))
    self.assertIn("HISTORICAL_SUPERSEDED", read("기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md"))
```

- [ ] **Step 2: Run the new contract test and verify RED**

Run: `python -m unittest tests.python.test_sx_dec_068_title_screen_main_shell -v`

Expected: FAIL because no current owner has yet transitioned Candidate 007 for the new title bytes.

- [ ] **Step 3: Update owner docs after exact runtime verification**

State the precise main-shell runtime source SHA, list Candidate 007 as historical for the previous exact bytes, and require a new exact package candidate for future final-user review. Retain Candidate 007’s own machine results unchanged.

- [ ] **Step 4: Run the new contract test to GREEN and commit**

```text
git add docs/decisions/SX_DEC_068_TITLE_SCREEN_MAIN_SHELL.md 기획서/00_프로젝트_허브 tests/python/test_sx_dec_068_title_screen_main_shell.py
git commit -m "docs: record title shell candidate transition"
```

### Task 4: Full validation and adversarial readback

**Files:**
- Modify: `docs/decisions/SX_DEC_068_TITLE_SCREEN_MAIN_SHELL.md`
- Create: `docs/operations/2026-08-31-sx-dec-068-title-main-shell-machine-verification.md`

- [ ] **Step 1: Run the project contract, focused Godot tests, all Godot tests, and Python suite**

Run:

```text
python tools/validate_project_contract.py
Godot_v4.7.1-stable_win64_console.exe --headless --path . --script res://tests/run_tests.gd
python -m pytest tests/python -q
```

- [ ] **Step 2: Perform five adversarial review loops**

1. Action/API preservation: Title → Briefing, Stage Book, Controls, Quit, return-to-title, and keyboard focus.
2. Layout/readability: backdrop input exclusion, button reachability, 960×540 / 1280×720 / 1920×1080 bounds, explicit focus contrast.
3. Asset/provenance: title art has one existing consumer path; no new PNG or untracked file is referenced.
4. Scope containment: no first-session, Route Book, finite rules, maps, or save keys change.
5. Evidence/canon: Candidate 007 exact source is retained, changed bytes are not promoted to final-user-ready before a new package candidate, and all current-owner references agree.

- [ ] **Step 3: Correct every in-scope finding, rerun affected tests, and record exact outputs**

- [ ] **Step 4: Commit verification evidence**

```text
git add docs/decisions/SX_DEC_068_TITLE_SCREEN_MAIN_SHELL.md docs/operations/2026-08-31-sx-dec-068-title-main-shell-machine-verification.md
git commit -m "test: verify title main shell"
```
