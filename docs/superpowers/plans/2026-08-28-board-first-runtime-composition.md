# Board-first Runtime Composition Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:executing-plans` task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the existing Switchy Express runtime read as one board-first Cozy Neo-Arcade experience while preserving every finite puzzle rule, current production asset consumer, and evidence boundary.

**Architecture:** `DemoPalette` becomes the named visual-role source for board and control-deck colors; `DemoThemeFactory` derives shell/HUD variants from it. The scenes retain their current node and input ownership, while `ProductBoardRenderer` moves the subtle cardinal-service cue below decisive route feedback. Existing first-session policy and `ProductShellArt` continue to own progression and real bitmap selection.

**Tech Stack:** Godot 4.7.1-stable, GDScript, `.tscn`, existing custom test runner at `tests/run_tests.gd`, Python project contracts, current package workflow.

**Spec:** `docs/superpowers/specs/2026-08-28-board-first-runtime-composition-design.md`

## Global Constraints

- Implement GitHub Issue #235 and SX-DEC-062 only. Read `AGENTS.md`, SX-DEC-060, SX-DEC-061, the linked spec, and `기획서/50_제작_검증/SX_DEC_062_CODEX_GODOT_PRODUCT_IMPLEMENTATION_HANDOFF.md` first.
- Preserve GMB-002, SX-DEC-060 cardinal service, cargo exact-cell pickup, LIFO/TOP, Manual/Auto, direct switch lock, result semantics, T1→T6→capstone, all map/data bytes, and locales.
- Do not create or edit files under `art/product_assets/**`, `runtime_visual_manifest.json`, map data, or first-session content/copy.
- Keep T2 on `shell_lesson_hero_v02.png`; keep T1/T3–T6/capstone on `shell_lesson_hero_v01.png`; do not implement or close Issue #227.
- Every new GDScript file needs a Korean first-line header comment; this plan adds no new production GDScript file.
- Use RED → minimal GREEN → exact-head regression. Do not claim Windows/audio/Android/five-person/Player Experience/release PASS from automated evidence.
- PR #174 is read-only. Work from latest completed `main` on a fresh task branch; do not change Base pin or Base-owned files.

---

### Task 1: Establish one named palette for board and control-deck state

**Files:**

- Modify: `game/demo/presentation/demo_palette.gd`
- Modify: `game/demo/presentation/demo_theme_factory.gd`
- Modify: `tests/demo/test_demo_theme.gd`

**Interfaces:**

- Produces `DemoPalette.CONTROL_DECK_RAISED`, `CONTROL_DECK_HOVER`, `CONTROL_DECK_BORDER`, `CONTROL_DECK_DISABLED`, `CONTROL_DECK_ACTION`, and `TUTORIAL_FOCUS`.
- `DemoThemeFactory.create_theme() -> Theme` remains the only flow-level theme constructor.
- Produces theme variations `ShellPanel`, `StackPanel`, `PreflightPanel`, and `LessonFocusLabel`, based on the existing `PanelContainer`/`Label` behavior.

- [ ] **Step 1: Write failing theme-role assertions**

Add to `tests/demo/test_demo_theme.gd` after the existing button checks:

```gdscript
const Palette := preload("res://game/demo/presentation/demo_palette.gd")

var theme := demo.theme
assert_equal(
    theme.get_color(&"font_color", &"Label"),
    Palette.TEXT_LIGHT,
    "control-deck text must share the board light-text role"
)
assert_equal(
    theme.get_color(&"font_color", &"LessonFocusLabel"),
    Palette.TUTORIAL_FOCUS,
    "lesson focus must use the named violet role"
)
```

Instantiate the product scene using the test’s current SceneTree guard. Assert that the preflight border is `Palette.PROBLEM`, the StackPanel border is `Palette.CONTROL_DECK_BORDER`, and the focused button border is `Palette.CONTROL_DECK_ACTION`.

- [ ] **Step 2: Run the focused test and confirm RED**

Run the registered Godot 4.7.1 test command:

```powershell
& $godot --headless --path . --script res://tests/run_tests.gd
```

Expected: theme-role assertions fail because the palette aliases and theme variations do not yet exist. If no registered Godot 4.7.1 executable is available, record `NOT_RUN`; do not substitute another version.

- [ ] **Step 3: Add palette aliases and theme variations**

In `demo_palette.gd`, add the exact named roles without changing existing semantic values:

```gdscript
const CONTROL_DECK_RAISED := Color("18363c")
const CONTROL_DECK_HOVER := Color("24505a")
const CONTROL_DECK_BORDER := Color("6f806f")
const CONTROL_DECK_DISABLED := Color("536168")
const CONTROL_DECK_ACTION := Color("e9ae45")
const TUTORIAL_FOCUS := Color("9b6bdf")
```

In `demo_theme_factory.gd`, preload `DemoPalette`, remove duplicate control-deck colors, and use named palette roles for all existing style/color assignments. Register:

```gdscript
result.set_type_variation(&"ShellPanel", &"PanelContainer")
result.set_type_variation(&"StackPanel", &"PanelContainer")
result.set_type_variation(&"PreflightPanel", &"PanelContainer")
result.set_type_variation(&"LessonFocusLabel", &"Label")
result.set_color(&"font_color", &"LessonFocusLabel", Palette.TUTORIAL_FOCUS)
```

`PreflightPanel` may use `Palette.PROBLEM` only as a border; its background remains raised control-deck color. Preserve all existing font floors, rounded corners, padding, focus, hover, pressed, and disabled behavior.

- [ ] **Step 4: Run GREEN and commit**

Run the same official test command. Then commit only the files in this task:

```powershell
git add game/demo/presentation/demo_palette.gd game/demo/presentation/demo_theme_factory.gd tests/demo/test_demo_theme.gd
git commit -m "ui: unify board-first visual tokens"
```

---

### Task 2: Apply the control-deck variants without changing flow or input ownership

**Files:**

- Modify: `game/demo/presentation/product_hud.tscn`
- Modify: `game/demo/vertical_slice_demo.tscn`
- Modify: `tests/demo/test_first_session_responsive_accessibility.gd`
- Modify: `tests/demo/test_playable_poc_visual_integration.gd`

**Interfaces:**

- Existing node paths remain exact: `HUD/ProblemBanner`, `HUD/StackPanel`, `TitleScreen/Panel`, `BriefingScreen/Panel`, `ResultOverlay/Panel`, and `BriefingScreen/Panel/Content/LessonProgress`.
- Existing button signals, stage visibility, action labels, and `ProductShellArt` asset selection remain unchanged.

- [ ] **Step 1: Add failing scene-contract assertions**

Extend the responsive/asset tests with:

```gdscript
assert_equal((hud.get_node("ProblemBanner") as PanelContainer).theme_type_variation, &"PreflightPanel")
assert_equal((hud.get_node("StackPanel") as PanelContainer).theme_type_variation, &"StackPanel")
assert_equal((flow.get_node("TitleScreen/Panel") as PanelContainer).theme_type_variation, &"ShellPanel")
assert_equal((flow.get_node("BriefingScreen/Panel") as PanelContainer).theme_type_variation, &"ShellPanel")
assert_equal((flow.get_node("ResultOverlay/Panel") as PanelContainer).theme_type_variation, &"ShellPanel")
assert_equal((flow.get_node("BriefingScreen/Panel/Content/LessonProgress") as Label).theme_type_variation, &"LessonFocusLabel")
```

Keep all existing five viewport, inside-root, ≥48px, stage-gating, Retry/Edit, and exact title/T1/T2/result asset assertions.

- [ ] **Step 2: Run RED**

Run the official test runner. Expected: only the new variant assertions fail.

- [ ] **Step 3: Apply only declared `.tscn` type variations**

Add these exact `theme_type_variation` properties without renaming/reparenting nodes or changing their `custom_minimum_size`:

```text
product_hud.tscn
  ProblemBanner = PreflightPanel
  StackPanel = StackPanel

vertical_slice_demo.tscn
  TitleScreen/Panel = ShellPanel
  BriefingScreen/Panel = ShellPanel
  PauseOverlay/Panel = ShellPanel
  ExitConfirmOverlay/Panel = ShellPanel
  ResultOverlay/Panel = ShellPanel
  BriefingScreen/.../LessonProgress = LessonFocusLabel
```

Do not alter board/overlay offsets, toolbar anchors, current labels, stage visibility, action connections, asset paths, or image crops in this task.

- [ ] **Step 4: Run GREEN and commit**

Run the full runner; all current layout and asset assertions must pass. Then:

```powershell
git add game/demo/presentation/product_hud.tscn game/demo/vertical_slice_demo.tscn tests/demo/test_first_session_responsive_accessibility.gd tests/demo/test_playable_poc_visual_integration.gd
git commit -m "ui: align shell and HUD control deck"
```

---

### Task 3: Place cardinal-service orientation below decisive route feedback

**Files:**

- Modify: `game/demo/presentation/product_board_renderer.gd`
- Modify: `tests/demo/test_product_board_renderer.gd`
- Modify: `tests/demo/test_product_board_route_clarity.gd`

**Interfaces:**

- `station_service_descriptors_for_test() -> Array[Dictionary]` stays cardinal-only.
- `route_visual_descriptors_for_test()` and `route_visual_widths_for_test(viewport, board_size)` stay exact.
- Produces renderer-only diagnostic `visual_layer_order_for_test() -> Array[StringName]`; it does not become a gameplay rule source.

- [ ] **Step 1: Add failing draw-order assertions**

Add to `test_product_board_renderer.gd`:

```gdscript
assert_true(renderer.has_method("visual_layer_order_for_test"))
if renderer.has_method("visual_layer_order_for_test"):
    var order: Array = renderer.visual_layer_order_for_test()
    assert_true(order.find(&"STATION_SERVICE") < order.find(&"ROUTE"))
    assert_true(order.find(&"ROUTE") < order.find(&"MARKERS"))
    assert_true(order.find(&"MARKERS") < order.find(&"STATE"))
```

Retain the existing exact cardinal-service and selected > locked > alternate / selected ≥5px assertions.

- [ ] **Step 2: Run RED**

Expected: no diagnostic exists and current `_draw()` orders route before station service.

- [ ] **Step 3: Reorder only the visual passes**

Change `_draw()` to call exactly:

```gdscript
_draw_layout(rect, board_size)
_draw_station_service_ranges(rect, board_size)
_draw_route_visual_overlays(rect, board_size)
_draw_fixed_markers(rect, board_size)
_draw_start_marker(rect, board_size)
_draw_state_overlays(rect, board_size)
_draw_train(rect, board_size)
```

Add:

```gdscript
func visual_layer_order_for_test() -> Array[StringName]:
    return [&"TERRAIN", &"GRID", &"BLOCKED", &"FIXED_TRACK", &"LAYOUT", &"STATION_SERVICE", &"ROUTE", &"MARKERS", &"START", &"STATE", &"TRAIN"]
```

Do not change service alpha, route colors/widths, snapshot schema, event z-index, map data, or delivery logic.

- [ ] **Step 4: Run GREEN and commit**

Run focused and full Godot tests, then:

```powershell
git add game/demo/presentation/product_board_renderer.gd tests/demo/test_product_board_renderer.gd tests/demo/test_product_board_route_clarity.gd
git commit -m "ui: prioritize route feedback over station orientation"
```

---

### Task 4: Verify exact scope and produce a new evidence-safe candidate when possible

**Files:**

- Modify: current exact-head evidence/candidate owners only after actual command/workflow output exists.
- Do not modify: maps, finite systems, first-session content/copy, asset paths/manifests, audio, or Issue #227 material.

**Interfaces:**

- Existing runner scripts, asset manifest, `ProductShellArt` paths, first-session JSON/copy, finite maps, and audio controller are read-only.

- [ ] **Step 1: Run exact-head automated checks**

Run from the final SHA:

```powershell
& $godot --headless --path . --script res://tests/run_tests.gd
python tools/validate_project_contract.py
python tests/python/test_v48_current_authority_migration.py -v
```

Use every additional required workflow check from current repository CI. Record exact output/test count/final SHA; unavailable tooling is `NOT_RUN`.

- [ ] **Step 2: Mechanically inspect the final diff**

Confirm:

```text
no art/product_assets/** or runtime_visual_manifest.json change
no data/maps/**, game/finite/**, game/first_session/**, or audio change
no new Godot Scene or product image path
T2 v02 and all non-T2 v01 asset assertions still pass
```

- [ ] **Step 3: Package from exact head**

Run the current official package workflow. Mint a new post-SX-DEC-062 candidate only when exact artifacts/hashes are produced. Preserve `SX60-POC-ACCEPT-002` unchanged as pre-change evidence.

- [ ] **Step 4: Record remaining evidence gates exactly**

```text
Windows physical runtime: NOT_RUN until observed on the new exact build
Audio perceptual QA: NOT_RUN until observed on the new exact build
Android device: BLOCKED_UNVERIFIED until exact post-change APK identity exists
Five-person comprehension: NOT_RUN
Player Experience decision: NOT_RUN
Release rights: CONDITIONAL; unchanged
```

Do not commit invented candidate IDs, hashes, test counts, or human evidence.

---

### Task 5: Perform adversarial review and publish through normal governance

**Files:**

- Modify only files required to fix a validated SX-DEC-062 finding.
- Update current project-hub and Notion owners only after implementation PR merge and exact readback.

- [ ] **Step 1: Perform at least five full-scope adversarial loops**

For each loop, inspect user scope, decision/owner freshness, assets/consumers, scenes, state meaning, first-session progression, viewport/input, package evidence, open PRs, and long-term scope. Record:

```yaml
loop_index: 1..N
input_state_or_head: <exact SHA>
evidence_delta: []
validated_findings: []
changes_applied: []
verification: []
better_alternative_result: <result>
long_term_fit: <result>
unresolved: []
```

Correct only validated in-scope `MUST_FIX` or approved `SHOULD_FIX` findings; re-run exact-head regression after each correction.

- [ ] **Step 2: Publish and merge safely**

Create/update the implementation PR against latest `main`; verify exact head, required checks, unresolved review threads, and intended diff. Do not alter PR #174 or Issue #227. Squash merge only when repository rules permit it.

- [ ] **Step 3: Post-merge canonical/Notion readback**

Fetch new `main`; compare changed code/Scene/tests to SX-DEC-062. Update/read back only Switchy Direction, Visual/UX/Assets, Production, and Flow destinations. Keep the foreign Direction page untouched. Recalculate remaining work before declaring any completion state.

## Self-review result

- Spec coverage: board hierarchy, theme-token ownership, HUD/shell grammar, T2 protection, route/service ordering, responsive/accessibility, asset integrity, exact-byte evidence transition, adversarial review, and Notion/GitHub sync have explicit tasks.
- Placeholder scan: candidate IDs/hashes and human verdicts are runtime-produced values, not values to invent.
- Type/path consistency: planned paths exist on current `main`; each introduced name is declared by its producing task.
- Scope: all runtime changes form one presentation slice and do not require a gameplay/data project.

## Execution handoff

Execute only through the linked `CODEX_GODOT_PRODUCT_IMPLEMENTATION_HANDOFF` after this documentation/contract PR is merged and Phase 2 implementation is explicitly started.
