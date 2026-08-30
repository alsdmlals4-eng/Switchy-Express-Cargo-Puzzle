# Wayside Hazards and Salvage Core Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add authored caution-track movement and LIFO waste disposal without changing existing finite-map behavior.

**Architecture:** Keep `FiniteMapDefinition` at schema v3 by making the new fields optional and fail-closed. Reuse `Station` and `FiniteDeliveryLoop` for disposal, then let `FiniteRunController` apply one fixed speed multiplier based only on the current departing cell. Pass map data through the existing render snapshot to a board layer below rails.

**Tech Stack:** Godot 4.7.1, GDScript, project headless test runner, GUT, Python contract checks, image-model raster candidates.

**Spec:** `docs/superpowers/specs/2026-08-30-wayside-hazards-and-salvage-design.md`

## Global Constraints

- Preserve `FiniteMapDefinition` schema version `3`; absent new data means existing behavior.
- `CAUTION_SPEED_MULTIPLIER` is exactly `0.55`; cargo count never affects speed.
- Waste service remains cardinal adjacent and uses unlimited LIFO matching TOP-group unload.
- Decorations occupy blocked cells only and draw beneath grid, rails, destinations, cargo, route and train.
- Use generated raster candidates only after concrete `ProductBoardRenderer` consumers exist; record SHA-256/provenance before runtime registration.
- Do not change first-session maps/policy, Route Book 01 data, PR #174, or PR #254.

---

### Task 1: Extend finite-map v3 data with fail-closed authored surface fields

**Files:**
- Modify: `game/finite/map/finite_map_definition.gd`
- Modify: `tests/finite/map/test_finite_map_definition.gd`
- Modify: `tests/map/test_map_definition.gd`

**Interfaces:**
- Produces `FiniteMapDefinition.caution_track_cells: Array[Vector2i]`.
- Produces `FiniteMapDefinition.board_decorations: Array[Dictionary]`.
- Produces `FiniteMapDefinition.CAUTION_SPEED_MULTIPLIER == 0.55`.
- Produces placement key `destination_kind`, defaulting to `STATION`.

- [ ] **Step 1: Write failing schema-preservation tests**

```gdscript
func test_v3_caution_and_decoration_round_trip() -> void:
	var definition = FiniteMapDefinition.create(_valid_data({
		"caution_track_cells": [[3, 2]],
		"board_decorations": [{"kind": "FOREST_CLUSTER", "cell": [0, 0]}],
	}))
	assert_true(definition.validation_errors().is_empty())
	assert_eq(definition.caution_track_cells, [Vector2i(3, 2)])
	assert_eq(definition.to_dictionary()["board_decorations"][0]["kind"], "FOREST_CLUSTER")
```

- [ ] **Step 2: Run the focused tests and verify RED**

Run: `& 'C:/Users/user/Downloads/Godot_v4.7.1-stable_win64.exe/Godot_v4.7.1-stable_win64_console.exe' --headless --path . --script res://tests/run_tests.gd`
Expected: the new test fails because the properties/validation do not exist.

- [ ] **Step 3: Add the minimal optional fields and source validation**

Read missing arrays as empty, include them in `to_dictionary()`, validate cells/kinds/duplicates, and reject a decoration not in `blocked_cells` or a caution cell not in `buildable_cells`. Preserve every existing validation error string.

- [ ] **Step 4: Add RED cases for invalid authored data**

```gdscript
func test_decoration_on_buildable_cell_fails_closed() -> void:
	var definition = FiniteMapDefinition.create(_valid_data({
		"board_decorations": [{"kind": "FOREST_CLUSTER", "cell": [3, 2]}],
	}))
	assert_has(definition.validation_errors(), "board decoration cells must be blocked")
```

- [ ] **Step 5: Implement only the failing validations and verify GREEN**

Run the two finite-map test files. Expected: all pre-existing assertions and both new validation cases pass.

- [ ] **Step 6: Commit the map-data unit**

```text
git add game/finite/map/finite_map_definition.gd tests/finite/map/test_finite_map_definition.gd tests/map/test_map_definition.gd
git commit -m "feat: validate authored caution and decoration map data"
```

### Task 2: Add waste cargo and disposal-yard constraints through existing LIFO service

**Files:**
- Modify: `game/cargo/cargo_type.gd`
- Modify: `game/finite/map/finite_map_definition.gd`
- Modify: `tests/finite/cargo/test_unlimited_cargo_stack.gd`
- Modify: `tests/finite/delivery/test_finite_delivery_loop.gd`
- Modify: `tests/finite/map/test_finite_map_definition.gd`

**Interfaces:**
- Produces `CargoType.WASTE_CRATE` with `VIOLET` / `HEXAGON` redundant identity.
- Accepts `station_placements[*].destination_kind == "DISPOSAL_YARD"` only with `WASTE_CRATE`.

- [ ] **Step 1: Write a failing disposal LIFO test**

```gdscript
func test_disposal_yard_unloads_only_a_waste_top_group() -> void:
	var stack = UnlimitedCargoStack.new()
	stack.push(CargoType.RED_STAR)
	stack.push(CargoType.WASTE_CRATE)
	stack.push(CargoType.WASTE_CRATE)
	var disposal = Station.new(Vector2i(4, 4), CargoType.WASTE_CRATE)
	assert_eq(disposal.try_unload(stack)["items"], [CargoType.WASTE_CRATE, CargoType.WASTE_CRATE])
	assert_eq(stack.peek(), CargoType.RED_STAR)
```

- [ ] **Step 2: Run the focused delivery test and verify RED**

Expected: failure because `WASTE_CRATE` is not valid.

- [ ] **Step 3: Add `WASTE_CRATE` and the destination-kind validator**

Do not add a second cargo stack or delivery loop. Require `DISPOSAL_YARD ↔ WASTE_CRATE` as a bijection and retain cardinal service/overlap checks unchanged.

- [ ] **Step 4: Add failing normal-cargo/normal-station rejection tests**

```gdscript
func test_waste_at_normal_station_fails_map_validation() -> void:
	var definition = FiniteMapDefinition.create(_valid_data({
		"station_placements": [{"cell": [5, 2], "cargo_type": "WASTE_CRATE"}],
	}))
	assert_has(definition.validation_errors(), "waste destination must be a disposal yard")
```

- [ ] **Step 5: Implement the exact validation and verify GREEN**

Run cargo, delivery, and finite-map focused suites. Expected: normal cargo cannot unload at waste service; waste cannot be authored as a normal station.

- [ ] **Step 6: Commit the cargo/service unit**

```text
git add game/cargo/cargo_type.gd game/finite/map/finite_map_definition.gd tests/finite/cargo/test_unlimited_cargo_stack.gd tests/finite/delivery/test_finite_delivery_loop.gd tests/finite/map/test_finite_map_definition.gd
git commit -m "feat: add waste cargo disposal semantics"
```

### Task 3: Apply the fixed authored caution multiplier in run control

**Files:**
- Modify: `game/finite/run/finite_run_session_factory.gd`
- Modify: `game/finite/run/finite_run_controller.gd`
- Modify: `tests/finite/run/test_finite_run_controller.gd`
- Modify: `tests/finite/integration/test_solution_identity_retry.gd`

**Interfaces:**
- `FiniteRunController.configure(..., caution_track_cells: Array[Vector2i] = [])`.
- `FiniteRunController.effective_speed_for_cell(cell: Vector2i) -> float`.

- [ ] **Step 1: Write the failing speed/restore test**

```gdscript
func test_caution_cell_uses_fixed_multiplier_then_restores_base_speed() -> void:
	var controller = _configured_controller_with_caution(Vector2i(2, 1), 2.0)
	assert_almost_eq(controller.effective_speed_for_cell(Vector2i(2, 1)), 1.1, 0.0001)
	assert_almost_eq(controller.effective_speed_for_cell(Vector2i(3, 1)), 2.0, 0.0001)
```

- [ ] **Step 2: Run the focused run-controller test and verify RED**

Expected: method/configuration parameter is absent.

- [ ] **Step 3: Implement one current-cell speed application helper**

Build the caution-cell lookup once during configure. Call `_apply_effective_speed()` after `start`, `resume`, successful cell-entry handling, and `_resolve_unload_completion`; leave pause and terminal code at speed zero.

- [ ] **Step 4: Add a retry identity regression**

Assert a retry retains the same `definition.to_dictionary()["caution_track_cells"]` and starts with base speed before it reaches its first authored caution cell.

- [ ] **Step 5: Run focused run/integration tests and verify GREEN**

Expected: normal maps still use base speed and no test observes cargo-count-dependent speed.

- [ ] **Step 6: Commit the movement unit**

```text
git add game/finite/run/finite_run_session_factory.gd game/finite/run/finite_run_controller.gd tests/finite/run/test_finite_run_controller.gd tests/finite/integration/test_solution_identity_retry.gd
git commit -m "feat: apply authored caution track speed"
```

### Task 4: Project authored surface data into the board renderer

**Files:**
- Modify: `game/finite/main/finite_slice_session_controller.gd`
- Modify: `game/demo/presentation/product_board_renderer.gd`
- Modify: `tests/finite/presentation/test_finite_slice_session_controller.gd`
- Modify: `tests/demo/test_product_board_renderer.gd`

**Interfaces:**
- Render snapshot keys: `caution_track_cells`, `board_decorations`.
- Layer order adds `DECORATION` after `TERRAIN` and `CAUTION` after `BLOCKED`.

- [ ] **Step 1: Write failing snapshot and layer-order tests**

```gdscript
func test_render_snapshot_copies_authored_surface_data() -> void:
	assert_eq(controller.render_snapshot()["caution_track_cells"], [Vector2i(3, 2)])

func test_decoration_and_caution_layers_are_below_rails() -> void:
	var layers = ProductBoardRenderer.new().visual_layer_order_for_test()
	assert_lt(layers.find(&"DECORATION"), layers.find(&"FIXED_TRACK"))
	assert_lt(layers.find(&"CAUTION"), layers.find(&"FIXED_TRACK"))
```

- [ ] **Step 2: Run both focused suites and verify RED**

- [ ] **Step 3: Copy the immutable definition fields to the snapshot and add draw helpers**

Draw caution overlays beneath rails. Draw decoration textures by registered kind after terrain, without changing the current terrain asset or replacing grid/marker drawing.

- [ ] **Step 4: Add the minimal disposal/waste marker-key test**

Assert a waste cargo selects `cargo_waste` and a disposal destination selects `station_disposal`; retain red/blue/yellow key mapping byte-for-byte.

- [ ] **Step 5: Verify GREEN and commit**

```text
git add game/finite/main/finite_slice_session_controller.gd game/demo/presentation/product_board_renderer.gd tests/finite/presentation/test_finite_slice_session_controller.gd tests/demo/test_product_board_renderer.gd
git commit -m "feat: render authored wayside surface data"
```

### Task 5: Generate and register the eight concrete raster assets

**Files:**
- Create: eight paths named in the design spec under `art/product_assets/ed_hybrid_v2/board` and `core`
- Modify: `art/product_assets/ed_hybrid_v2/manifest.json`
- Modify: `docs/ASSET_RIGHTS_AND_PROVENANCE_RECORD.md`
- Test: `tests/demo/test_product_board_renderer.gd`

- [ ] **Step 1: Generate image-model candidates for the eight registered consumers**

Use the approved E+D Hybrid / Neo-Arcade style. Generate independently legible, transparent-background square raster candidates; do not create rail, normal station, normal cargo, labels, logos, UI, or watermarks.

- [ ] **Step 2: Inspect candidates and reject any ambiguous gameplay silhouette**

Require that the waste crate is visibly violet/hexagonal, the disposal yard cannot resemble a normal color destination, and the caution overlay cannot resemble a route-selection or locked-switch state.

- [ ] **Step 3: Register each accepted candidate with SHA-256 and consumer evidence**

Record exact path, dimensions, generation receipt, `GENERATED_CANDIDATE` status, and `ProductBoardRenderer` key. Do not claim user-image promotion, runtime proof, human review, or release-rights PASS.

- [ ] **Step 4: Import assets and run renderer test GREEN**

Run Godot `--headless --import --path .`, then run the focused renderer suite. Expected: all eight registered textures load and existing fourteen visual consumers remain valid.

- [ ] **Step 5: Commit the asset/provenance unit**

```text
git add art/product_assets/ed_hybrid_v2 docs/ASSET_RIGHTS_AND_PROVENANCE_RECORD.md tests/demo/test_product_board_renderer.gd
git commit -m "feat: add wayside hazard runtime assets"
```

### Task 6: Run core regression and record evidence ceiling

**Files:**
- Modify: `docs/operations/2026-08-30-sx-dec-067-local-machine-verification.md`
- Modify: `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`

- [ ] **Step 1: Run project contract, full Python suite, and full Godot suite**

Expected: project contract PASS; all existing and new Godot tests pass; no new warnings/errors in the filtered log.

- [ ] **Step 2: Run five adversarial passes**

Check consumer/path misuse, visual/readability overlap, scope expansion, asset provenance, import/runtime failure, and evidence inflation. Correct each validated in-scope finding before the next pass.

- [ ] **Step 3: Record exact commands, commit SHA, test counts, and non-claims**

State machine verification only; Candidate 006 is historical for changed bytes and a new candidate is not minted until post-merge package proof.
