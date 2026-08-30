# Route Book 01 Stage Pack Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add six directly selectable, hand-authored Route Book stages without changing the existing first session or finite gameplay rules.

**Architecture:** A strict `RouteBookDefinition`/`RouteBookDirector` sidecar supplies the map and full-control policy data. `DemoFlowController` receives a distinct Stage Book entry state while reusing the existing briefing, finite product slice, result recovery, map loader, and production assets.

**Tech Stack:** Godot 4.7.1, GDScript, JSON data, repository custom Godot test runner, Python contract tests, GitHub CI/package workflow.

**Spec:** `docs/superpowers/specs/2026-08-30-route-book-01-stage-pack-design.md`

## Global Constraints

- Preserve T1–T6, `VS_DEMO_01`, first-session IDs/order/maps/policies/copy, and their existing tests byte-for-byte unless a new regression proves an unavoidable shared-parser correction.
- Use `FiniteMapDefinition v3`, exact cargo contact, cardinal-only station service, unlimited LIFO, persistent direct route controls, occupied lock, start-reachable preflight, and factual Retry/Edit result behavior.
- Create no bitmap/audio/VFX asset and do not change existing asset manifests or paths.
- Do not add score, rank, stars, rewards, saves, unlocks, generator content, Yard Labs, Mastery, Daily/Weekly, editor/UGC, network behavior, or new gameplay rules.
- Keep all six Route Book stages directly selectable and non-persistent; never expose `RECOMMENDED_LAYOUT` for them.
- Localize every added player-visible Route Book string in `ko`, `en`, `ja`, and `zh-Hans`.
- Keep PR #174 untouched and do not modify PR #254.
- Use RED→GREEN evidence, five full-scope post-build adversarial review loops, and a new exact candidate after product bytes change.

---

## File structure

| Path | Responsibility |
| --- | --- |
| `data/route_book/route_book_01.json` | Ordered, strict stage metadata and existing policy-compatible control allow-lists. |
| `data/localization/route_book_01_v1.json` | Four-locale Route Book text only. |
| `data/maps/route_book/*.json` | Six schema-v3 marker maps specified by the content owner. |
| `game/route_book/route_book_definition.gd` | Read-only Route Book JSON validation and stage lookup. |
| `game/route_book/route_book_director.gd` | Ephemeral selection/index/next-stage state. |
| `game/first_session/first_session_copy.gd` | Existing parser extended with a generic public JSON-path loader; default behavior retained. |
| `game/demo/demo_flow_controller.gd` | Route Book state, selection, briefing, product-policy installation, next/list result actions. |
| `game/demo/vertical_slice_demo.tscn` | Title entry, selection surface, and Route Book-only result actions. |
| `tests/fixtures/route_book/*.gd` | Non-player-facing authored rail witnesses, one fixture per new map. |
| `tests/route_book/*.gd` | Definition/director/map/witness contracts. |
| `tests/demo/test_route_book_flow_controller.gd` | Actual scene-level selection/recovery behavior. |
| `tests/demo/test_demo_responsive_layout.gd` | Expanded viewport/touch-target checks for new controls. |
| `tests/run_tests.gd` | Registers every new deterministic suite. |
| `docs/operations/<dated-route-book-verification>.md` | Filled only with evidence that is actually run. |

## Task 1: RED data-definition and copy contracts

**Files:**
- Create: `tests/route_book/test_route_book_definition.gd`
- Create: `tests/route_book/test_route_book_copy.gd`
- Modify: `tests/run_tests.gd`
- Create later in this task: `data/route_book/route_book_01.json`, `data/localization/route_book_01_v1.json`, `game/route_book/route_book_definition.gd`, `game/route_book/route_book_director.gd`
- Modify later in this task: `game/first_session/first_session_copy.gd`

**Interfaces:**
- Consumes: `FirstSessionStagePolicy.create(stage: Dictionary) -> Variant` and `FiniteMapLoader.load_from_path(path: String) -> Variant`.
- Produces: `RouteBookDefinition.load_from_path(path: String) -> Variant`; `RouteBookDirector.configure(definition: Variant) -> bool`; the exact six-stage order specified in the design.

- [ ] **Step 1: Write the failing definition and director tests**

```gdscript
func run() -> void:
    var definition: Variant = DefinitionScript.load_from_path(BOOK_PATH)
    assert_not_null(definition, "Route Book definition must load")
    assert_equal(definition.stage_ids(), REQUIRED_IDS, "Route Book order is exact")
    assert_equal(definition.stage_count(), 6, "Route Book has six fixed stages")
    assert_false(definition.stage(&"RB01_SERVICE_SIDINGS").get("visible_features", []).has("RECOMMENDED_LAYOUT"), "Route Book never exposes a recommended solution")
    var director := DirectorScript.new()
    assert_true(director.configure(definition), "director configures valid book")
    assert_false(director.select_stage(&"UNKNOWN"), "unknown stage is rejected")
    assert_true(director.select_stage(&"RB05_FORK_LOCK"), "known stage is selectable")
    assert_equal(director.current_stage_number(), 5, "selection keeps declared order")
```

- [ ] **Step 2: Register and run the failing tests**

Run: `& $godot --headless --path . --script res://tests/run_tests.gd`
Expected: FAIL because the Route Book scripts/data are absent and no legacy map catalogue is accepted as a substitute.

- [ ] **Step 3: Implement strict data owners and the reusable path loader**

```gdscript
# RouteBookDefinition validation must reject anything but the exact order.
const REQUIRED_IDS: Array[StringName] = [
    &"RB01_SERVICE_SIDINGS", &"RB02_REVERSE_ORDER", &"RB03_RETURN_MANIFEST",
    &"RB04_LOAD_WINDOW", &"RB05_FORK_LOCK", &"RB06_PORT_CIRCUIT",
]

# FirstSessionCopy preserves callers while permitting a separate catalog.
func load_default() -> bool:
    return load_from_path(DEFAULT_PATH)
```

Create both JSON files with all six stage records and every four-locale title/objective/navigation key. Validate every stage map path exists and can load through `FiniteMapLoader`; do not accept missing paths or fall back to `VS_DEMO_01`.

- [ ] **Step 4: Run data and parser tests green**

Run: `& $godot --headless --path . --script res://tests/run_tests.gd`
Expected: Route Book definition/copy tests pass, all first-session copy/definition tests remain green.

- [ ] **Step 5: Commit the self-contained data-owner increment**

```powershell
git add data/route_book data/localization/route_book_01_v1.json game/route_book game/first_session/first_session_copy.gd tests/route_book tests/run_tests.gd
git commit -m "feat: add route book stage definitions"
```

## Task 2: RED Stage Book selection and result-recovery flow

**Files:**
- Create: `tests/demo/test_route_book_flow_controller.gd`
- Modify: `tests/demo/test_demo_responsive_layout.gd`
- Modify: `tests/run_tests.gd`
- Modify later in this task: `game/demo/demo_flow_controller.gd`, `game/demo/vertical_slice_demo.tscn`

**Interfaces:**
- Consumes: `RouteBookDirector`, `FirstSessionStagePolicy.create(current_stage)`, existing `ProductFiniteSlice.map_path`, `set_stage_policy`, `terminal_reached` and Retry/Edit commands.
- Produces: `open_route_book()`, `select_route_book_stage(stage_id: StringName)`, `current_route_book_stage_id_for_test()`, and Route Book-only Next/List actions.

- [ ] **Step 1: Write failing scene-flow tests**

```gdscript
func run() -> void:
    var demo: Control = DemoScene.instantiate()
    tree.root.add_child(demo)
    demo.open_route_book()
    assert_equal(demo.state(), &"ROUTE_BOOK", "Title opens Route Book selection")
    assert_true(demo.select_route_book_stage(&"RB03_RETURN_MANIFEST"), "stage card selects known map")
    assert_equal(demo.state(), &"BRIEFING", "selected Route Book stage reuses briefing")
    demo.begin_build()
    assert_equal(_map_id(demo), &"RB03_RETURN_MANIFEST", "selected map reaches real product slice")
    assert_false((demo.gameplay_instance().get_node("HUD/BuildToolbar/RecommendButton") as Button).visible, "Route Book hides recommended layout")
```

Add assertions that existing Title Start still loads T1 in product main, standalone demo still loads `VS_DEMO_01`, Route Book success shows Next only before stage six, Stage Book returns to selectable cards, and Retry/Edit preserve current behavior.

- [ ] **Step 2: Run the test red**

Run: `& $godot --headless --path . --script res://tests/run_tests.gd`
Expected: FAIL because `ROUTE_BOOK`, selection methods, scene nodes, and result actions do not exist.

- [ ] **Step 3: Implement the smallest isolated flow/UI delta**

```gdscript
const ROUTE_BOOK: StringName = &"ROUTE_BOOK"

func open_route_book() -> void:
    if _state != TITLE:
        return
    _route_book_active = true
    _release_gameplay_instance()
    _populate_route_book_list()
    _transition_to(ROUTE_BOOK)
```

Add `StageBookButton`, `RouteBookScreen`, a six-card `StageList`, a Back button, and a separate `RouteBookActions` row. Reuse the existing briefing panel and neutral shell art. Install `FirstSessionStagePolicy.create(current_stage)` before adding the product node so full controls are present but `RECOMMENDED_LAYOUT` is hidden.

- [ ] **Step 4: Run selection, first-session, and responsive tests green**

Run: `& $godot --headless --path . --script res://tests/run_tests.gd`
Expected: Route Book flow passes; T1/T2 and standalone demo assertions still pass; every new visible Route Book control is within the target viewport and at least 48px.

- [ ] **Step 5: Commit the flow increment**

```powershell
git add game/demo/demo_flow_controller.gd game/demo/vertical_slice_demo.tscn tests/demo tests/run_tests.gd
git commit -m "feat: add route book stage selection flow"
```

## Task 3: Author Route Book maps 01–03 with real success and failure witnesses

**Files:**
- Create: `data/maps/route_book/rb_01_service_sidings.json`
- Create: `data/maps/route_book/rb_02_reverse_order.json`
- Create: `data/maps/route_book/rb_03_return_manifest.json`
- Create: `tests/fixtures/route_book/rb_01_service_sidings_solution.gd`
- Create: `tests/fixtures/route_book/rb_02_reverse_order_solution.gd`
- Create: `tests/fixtures/route_book/rb_03_return_manifest_solution.gd`
- Create: `tests/route_book/test_route_book_maps_01_03.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Consumes: exact coordinates/contract in `ROUTE_BOOK_01_STAGE_CONTENT_SPEC.md`, real finite loader/build/factory/session chain.
- Produces: three schema-v3 map identities and deterministic, non-player-facing witnesses.

- [ ] **Step 1: Write the failing stage contracts**

```gdscript
func run() -> void:
    var reverse: Dictionary = _run_map(RB02_PATH, RB02Solution.pieces(), &"MANUAL")
    assert_equal(reverse.get("phase"), &"SUCCESS", "RB02 reverse pickup witness succeeds")
    assert_equal(reverse.get("pickups"), [&"BLUE_DIAMOND", &"RED_STAR"], "RB02 loads in reverse order")
    assert_equal(reverse.get("unloads"), [&"RED_STAR", &"BLUE_DIAMOND"], "RB02 unloads required TOP order")
    assert_equal(_run_naive_forward_order(), &"FAILURE", "forward pickup order is not silently accepted")
```

For RB01, assert schema-v3 station cells are not buildable and no station-footprint/diagonal delivery occurs. For RB03, record two Blue-cell contacts and assert first skip, second pickup, and naive load-all failure.

- [ ] **Step 2: Run red**

Run: `& $godot --headless --path . --script res://tests/run_tests.gd`
Expected: FAIL because the three map files and fixtures do not yet exist.

- [ ] **Step 3: Author only the specified map bytes and witnesses**

Use the exact content-spec coordinates, `definition_schema_version: 3`, `marker_tracks_player_built: true`, and `allow_open_terminals_after_required: true`. Keep station cells off track. Build fixture pieces only through `TrackPiece.create`; start the real run, send actual Manual input, advance time to terminal, and collect actual `delivery_event_created` records.

- [ ] **Step 4: Run maps 01–03 green**

Run: `& $godot --headless --path . --script res://tests/run_tests.gd`
Expected: all schema, witness, and counterexample assertions pass with no finite-core test change.

- [ ] **Step 5: Commit the first three authored maps**

```powershell
git add data/maps/route_book tests/fixtures/route_book tests/route_book tests/run_tests.gd
git commit -m "feat: add route book stages one through three"
```

## Task 4: Author Route Book maps 04–06 with Auto and route-control proofs

**Files:**
- Create: `data/maps/route_book/rb_04_load_window.json`
- Create: `data/maps/route_book/rb_05_fork_lock.json`
- Create: `data/maps/route_book/rb_06_port_circuit.json`
- Create: `tests/fixtures/route_book/rb_04_load_window_solution.gd`
- Create: `tests/fixtures/route_book/rb_05_fork_lock_solution.gd`
- Create: `tests/fixtures/route_book/rb_06_port_circuit_solution.gd`
- Create: `tests/route_book/test_route_book_maps_04_06.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Consumes: `FiniteGameplayInputState`, `FiniteTrackGraph.select_switch_exit`, real session event history, and exact map contracts.
- Produces: Auto/Manual and switch occupancy proof for stages 04–06.

- [ ] **Step 1: Write failing behavioral tests**

```gdscript
func run() -> void:
    var auto: Dictionary = _run_rb04_deliberate_auto()
    assert_equal(auto.get("phase"), &"SUCCESS", "RB04 deliberate Auto window succeeds")
    assert_equal(auto.get("safe_auto_pickups"), 2, "RB04 Auto loads both safe Red cargo")
    assert_true(auto.get("auto_disabled_before_blue", false), "RB04 turns Auto off before Blue")
    assert_equal(_run_rb04_auto_always_on(), &"FAILURE", "RB04 Auto always on fails")
    assert_equal(_run_rb04_manual_only(), &"SUCCESS", "RB04 permits deliberate manual alternative")
```

For RB05, assert the witness changes a switch pre-occupancy, the graph rejects its change while occupied, the chosen exit persists, and initial wrong branch fails. For RB06, assert all three cargo types unload through cardinal service, at least one Auto transition occurs, at least one switch is used, and the specified wrong-order/branch fixture fails.

- [ ] **Step 2: Run red**

Run: `& $godot --headless --path . --script res://tests/run_tests.gd`
Expected: FAIL because stages 04–06 and their witness fixtures are absent.

- [ ] **Step 3: Implement exact map bytes and real control-driven witnesses**

Use no hidden timer/reflex mechanism, no switch auto-reset, and no tutorial-only shortcut. Every automation call must target the real input/graph command boundary, not mutate cargo stack, train cell, delivery result, or route-control state directly.

- [ ] **Step 4: Run maps 04–06 green**

Run: `& $godot --headless --path . --script res://tests/run_tests.gd`
Expected: explicit Auto, occupancy lock, three-type composite, and all negative cases pass; all pre-existing suites remain green.

- [ ] **Step 5: Commit the latter three authored maps**

```powershell
git add data/maps/route_book tests/fixtures/route_book tests/route_book tests/run_tests.gd
git commit -m "feat: add route book stages four through six"
```

## Task 5: Finalize user-facing copy, documentation, and regression coverage

**Files:**
- Modify: `data/localization/route_book_01_v1.json`
- Modify: `tests/route_book/test_route_book_copy.gd`
- Modify: `tests/demo/test_demo_responsive_layout.gd`
- Modify: `tests/demo/test_route_book_flow_controller.gd`
- Modify: `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
- Modify: `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
- Modify: `기획서/00_프로젝트_허브/ROADMAP.md`
- Modify: `기획서/00_프로젝트_허브/DESIGN_DOCUMENT_REGISTRY.json`
- Modify: `기획서/00_프로젝트_허브/DOCUMENTATION_MAP.md`
- Modify: `docs/design/PROJECT_AI_PRODUCTION_SPEC.md`
- Create: `docs/operations/2026-08-30-route-book-01-runtime-verification.md`

**Interfaces:**
- Consumes: exact final files/tests and current verification results.
- Produces: GitHub-owned canon synchronized with actual implementation and an evidence record that distinguishes executed PASS from `NOT_RUN`.

- [ ] **Step 1: Write red copy and visual-regression assertions**

```gdscript
for locale: String in [&"ko", &"en", &"ja", &"zh-Hans"]:
    assert_false(copy.text(&"SX_RB_STAGE_BOOK", locale).is_empty(), "%s has Stage Book label" % locale)
    assert_false(copy.text(&"SX_RB06_OBJECTIVE", locale).is_empty(), "%s has RB06 objective" % locale)
assert_false(route_book_actions.visible, "Route Book result controls never leak into first-session result")
```

Expand responsive checks to 960×540 and 2560×1080. Assert Route Book panel/cards and Stage Book/Next buttons are in bounds and at least 48px when visible.

- [ ] **Step 2: Run red**

Run: `& $godot --headless --path . --script res://tests/run_tests.gd`
Expected: FAIL until all locales and Route Book-only visual state boundaries are complete.

- [ ] **Step 3: Complete canonical synchronization and evidence template**

Record SX-DEC-066 as `IMPLEMENTED` only after implementation and checks actually pass. Preserve Candidate 005 as historical exact-byte evidence for the old product and reserve no new candidate ID until the existing mint procedure issues one from exact post-merge main. The verification record begins with `NOT_RUN` for physical/audio/device/final-user review and changes only when evidence is executed.

- [ ] **Step 4: Run all local checks green**

Run:

```powershell
python tools/validate_project_contract.py
python -m pytest tests/python -q
& $godot --headless --path . --script res://tests/run_tests.gd
```

Expected: contract and Python tests pass; Godot runner has zero failed cases and includes all Route Book tests.

- [ ] **Step 5: Commit canonical and regression completion**

```powershell
git add data/localization tests docs 기획서
git commit -m "docs: register route book stage pack evidence"
```

## Task 6: Independent review, PR, exact candidate, and post-merge readback

**Files:**
- Modify only if a verified review finding requires an in-scope correction.
- Create: exact-candidate evidence files only through the repository's existing minting procedure.

**Interfaces:**
- Consumes: full implementation diff, all local evidence, CI/package workflows, existing candidate procedure.
- Produces: a clean current-task PR, exact-main readback, and a new immutable machine-verified candidate or an explicit `BLOCKED_UNVERIFIED` record.

- [ ] **Step 1: Run five full-scope adversarial review loops**

Review and correct, in sequence: (1) first-session/finite rule and forbidden-scope drift, (2) map/witness/consumer realism, (3) UI/readability/touch/locale and no-op-control drift, (4) asset/provenance/candidate evidence boundary, and (5) exact PR/main/CI/package integrity. Re-run the complete relevant suite after every correction.

- [ ] **Step 2: Verify the final diff and current remote state**

Run:

```powershell
git diff origin/main...HEAD -- game data tests docs 기획서
git fetch origin main
gh pr list --repo alsdmlals4-eng/Switchy-Express-Cargo-Puzzle --state open --limit 100
```

Expected: only SX-DEC-066 scope files change; PR #174 and PR #254 are not altered or absorbed.

- [ ] **Step 3: Create the implementation PR and wait for required checks**

Run the repository-required CI/export/package checks on the exact PR head. Fix only verified in-scope findings, then rerun the full local suite and complete adversarial review again if bytes change.

- [ ] **Step 4: Merge only with clean required checks, then read exact main back**

After permitted merge, create a fresh exact-main readback workspace and rerun the contract validator, Python suite, Godot runner, and required package checks. Record the actual merge SHA and results.

- [ ] **Step 5: Mint and verify the new exact candidate**

Use the existing candidate workflow after exact-main checks pass. Record its source commit, package/hash facts, machine checks, and `FINAL_USER_REVIEW: NOT_RUN` unless the user requests it. Do not claim physical/audio/device/human/release PASS without corresponding executed evidence.
