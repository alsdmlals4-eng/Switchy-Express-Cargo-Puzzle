# Same-Seed Restart and Curated Map Catalog Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make `RESTART` rebuild the exact same validated map revision with a new run identity, and add an offline seed-catalog pipeline that can prove at least 100 genuinely distinct map layouts.

**Architecture:** `MapDefinition` owns immutable map identity and reconstruction signatures. `MapCatalog` admits only validated, non-fallback, unique layouts. `RunController` asks `RunSessionFactory` for a fresh mutable service graph on every attempt and reuses the same definition on restart. An offline builder expands `RailGenerator` diversity, validates candidates, and writes a versioned JSON manifest.

**Tech Stack:** Godot 4.7.1-stable, GDScript, JSON, SHA-256 through `HashingContext`, existing custom headless test runner, GitHub Actions Godot Tests.

## Global Constraints

- Decision: `SX-DEC-023`; Evidence: `EV-USER-012`; `GMB-001` slot `7/10`.
- Design: `docs/superpowers/specs/2026-08-02-same-seed-restart-curated-map-catalog-design.md`.
- `RESTART` preserves `map_id`, `map_revision`, `map_seed`, generator/ruleset versions, and all reconstruction signatures.
- `RESTART` creates a new `run_id`, reward-event namespace, retry lineage, and complete mutable run service graph.
- Fuel, score, stack, switches, train history, pending spawns, difficulty forecasts/events, warnings, result evidence, and transactions never survive restart.
- New seeds enter only through the offline content pipeline. Runtime restart never searches, rolls, or accepts a seed from UI.
- Only `VALIDATED` or `SHIPPED`, non-fallback catalog entries start standard runs.
- Production target: at least 100 unique `layout_signature` values, not 100 integers.
- Vertical Slice target: three unique validated entries plus one exact same-map restart path.
- Different-map selection, progression, discovery, and cross-map record fairness are not decided here.
- Existing onboarding, camera, record, reward, and difficulty authority contracts remain unchanged.
- Do not execute product implementation before `GMB-001 10/10`, canonical synchronization, and `READY_FOR_BUILD`.

## Prerequisites

This plan integrates with files already implemented or explicitly created by approved VS-03 plans:

```text
game/cargo/cargo_stack.gd
game/cargo/cargo_spawner.gd
game/station/station_placer.gd
game/delivery/delivery_loop.gd
game/train/train_controller.gd
game/run/run_state.gd
game/run/run_controller.gd
game/difficulty/difficulty_director.gd
game/ui/result_panel.gd
game/telemetry/run_event_log.gd
```

If execution reaches this plan before a prerequisite task, execute the prerequisite approved plan first. Do not invent duplicate parallel implementations.

## Planned File Map

```text
game/map/map_definition.gd
  Immutable ID, revision, seed, versions, component signatures, combined signatures, status.

game/map/map_catalog.gd
  Manifest load, duplicate rejection, exact revision resolution, invalid-entry isolation.

game/map/map_build_pipeline.gd
  Offline graph/station/pickup construction and signature calculation.

game/run/run_identity.gd
  One-attempt identity and retry lineage.

game/run/run_id_factory.gd
  Unique production IDs with deterministic test injection.

game/run/run_session.gd
  One attempt's mutable service ownership boundary.

game/run/run_session_factory.gd
  Reconstruct fresh services from one MapDefinition and verify signatures.

game/telemetry/run_start_event.gd
  Bounded authoritative run/map/retry telemetry payload.

tools/build_map_catalog.gd
  Bounded offline seed scan and JSON writer.

tools/audit_map_catalog.gd
  Rebuild and uniqueness audit for target 3 or 100.

data/maps/map_catalog.json
  Generated reviewed manifest.

tests/support/map_fixture.gd
  Exact catalog/identity fixtures shared by tests.
```

Modified:

```text
game/rail/rail_generator.gd
game/run/run_controller.gd
game/ui/result_panel.gd
game/telemetry/run_event_log.gd
tests/run_tests.gd
```

---

### Task 1: MapDefinition and RunIdentity

**Files:**
- Create: `game/map/map_definition.gd`
- Create: `game/run/run_identity.gd`
- Create: `game/run/run_id_factory.gd`
- Create: `tests/map/test_map_definition.gd`
- Create: `tests/run/test_run_identity.gd`
- Create: `tests/support/map_fixture.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- `MapDefinition.create(data: Dictionary) -> MapDefinition`
- `MapDefinition.validation_errors() -> Array[String]`
- `MapDefinition.is_runtime_eligible() -> bool`
- `MapDefinition.identity_key() -> String`
- `RunIdentity.create(definition, run_id, retry_index, restarted_from_run_id) -> RunIdentity`
- `RunIdFactory.next_id() -> String`

- [ ] **Step 1: Write failing definition tests**

```gdscript
# tests/map/test_map_definition.gd
extends RefCounted

const MapDefinitionScript := preload("res://game/map/map_definition.gd")
const Fixture := preload("res://tests/support/map_fixture.gd")

func run(test: Variant) -> void:
    test.case("validated complete definition is eligible", func() -> void:
        var definition: Variant = MapDefinitionScript.create(Fixture.map_data())
        test.assert_true(definition.is_runtime_eligible())
        test.assert_equal(definition.identity_key(), "map.sx.0001@1")
    )

    test.case("missing component signature is rejected", func() -> void:
        var data: Dictionary = Fixture.map_data()
        data.initial_pickup_signature = ""
        var definition: Variant = MapDefinitionScript.create(data)
        test.assert_false(definition.is_runtime_eligible())
        test.assert_true(definition.validation_errors().has("initial_pickup_signature is required"))
    )

    test.case("fallback definition is rejected", func() -> void:
        var data: Dictionary = Fixture.map_data()
        data.used_fallback = true
        test.assert_false(MapDefinitionScript.create(data).is_runtime_eligible())
    )
```

- [ ] **Step 2: Write failing run-identity tests**

```gdscript
# tests/run/test_run_identity.gd
extends RefCounted

const MapDefinitionScript := preload("res://game/map/map_definition.gd")
const RunIdentityScript := preload("res://game/run/run_identity.gd")
const Fixture := preload("res://tests/support/map_fixture.gd")

func run(test: Variant) -> void:
    test.case("retry preserves map and changes attempt identity", func() -> void:
        var definition: Variant = MapDefinitionScript.create(Fixture.map_data())
        var first: Variant = RunIdentityScript.create(definition, "run-a", 0, "")
        var retry: Variant = RunIdentityScript.create(definition, "run-b", 1, "run-a")
        test.assert_equal(retry.map_definition.identity_key(), first.map_definition.identity_key())
        test.assert_equal(retry.map_definition.map_seed, first.map_definition.map_seed)
        test.assert_not_equal(retry.run_id, first.run_id)
        test.assert_equal(retry.retry_index, 1)
        test.assert_equal(retry.restarted_from_run_id, "run-a")
    )
```

- [ ] **Step 3: Add the exact fixture**

```gdscript
# tests/support/map_fixture.gd
extends RefCounted

static func map_data() -> Dictionary:
    return {
        "map_id": &"map.sx.0001",
        "map_revision": 1,
        "map_seed": 104729,
        "generator_version": &"railgen_v2",
        "ruleset_version": &"standard_v1",
        "graph_signature": "graph-a",
        "station_signature": "stations-a",
        "initial_pickup_signature": "pickups-a",
        "layout_signature": "layout-a",
        "content_signature": "content-a",
        "validation_status": &"VALIDATED",
        "used_fallback": false,
    }
```

- [ ] **Step 4: Run tests and verify missing-file failure**

```bash
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tests/run_tests.gd
```

Expected: preload failure for the new domain files.

- [ ] **Step 5: Implement MapDefinition**

```gdscript
# game/map/map_definition.gd
class_name MapDefinition
extends RefCounted

const RUNTIME_STATUSES: Array[StringName] = [&"VALIDATED", &"SHIPPED"]

var map_id: StringName
var map_revision: int
var map_seed: int
var generator_version: StringName
var ruleset_version: StringName
var graph_signature: String
var station_signature: String
var initial_pickup_signature: String
var layout_signature: String
var content_signature: String
var validation_status: StringName
var used_fallback: bool

static func create(data: Dictionary) -> MapDefinition:
    var value := MapDefinition.new()
    value.map_id = StringName(data.get("map_id", &""))
    value.map_revision = int(data.get("map_revision", 0))
    value.map_seed = int(data.get("map_seed", 0))
    value.generator_version = StringName(data.get("generator_version", &""))
    value.ruleset_version = StringName(data.get("ruleset_version", &""))
    value.graph_signature = str(data.get("graph_signature", ""))
    value.station_signature = str(data.get("station_signature", ""))
    value.initial_pickup_signature = str(data.get("initial_pickup_signature", ""))
    value.layout_signature = str(data.get("layout_signature", ""))
    value.content_signature = str(data.get("content_signature", ""))
    value.validation_status = StringName(data.get("validation_status", &"DRAFT"))
    value.used_fallback = bool(data.get("used_fallback", false))
    return value

func identity_key() -> String:
    return "%s@%d" % [map_id, map_revision]

func validation_errors() -> Array[String]:
    var errors: Array[String] = []
    if map_id == &"": errors.append("map_id is required")
    if map_revision <= 0: errors.append("map_revision must be positive")
    if generator_version == &"": errors.append("generator_version is required")
    if ruleset_version == &"": errors.append("ruleset_version is required")
    if graph_signature.is_empty(): errors.append("graph_signature is required")
    if station_signature.is_empty(): errors.append("station_signature is required")
    if initial_pickup_signature.is_empty(): errors.append("initial_pickup_signature is required")
    if layout_signature.is_empty(): errors.append("layout_signature is required")
    if content_signature.is_empty(): errors.append("content_signature is required")
    return errors

func is_runtime_eligible() -> bool:
    return validation_errors().is_empty() and not used_fallback and validation_status in RUNTIME_STATUSES

func to_dictionary() -> Dictionary:
    return {
        "map_id": str(map_id),
        "map_revision": map_revision,
        "map_seed": map_seed,
        "generator_version": str(generator_version),
        "ruleset_version": str(ruleset_version),
        "graph_signature": graph_signature,
        "station_signature": station_signature,
        "initial_pickup_signature": initial_pickup_signature,
        "layout_signature": layout_signature,
        "content_signature": content_signature,
        "validation_status": str(validation_status),
        "used_fallback": used_fallback,
    }
```

- [ ] **Step 6: Implement RunIdentity and RunIdFactory**

```gdscript
# game/run/run_identity.gd
class_name RunIdentity
extends RefCounted

var map_definition: Variant
var run_id: String
var retry_index: int
var restarted_from_run_id: String

static func create(definition: Variant, run_id_value: String, retry_value: int, previous_id: String) -> RunIdentity:
    assert(definition != null and definition.is_runtime_eligible(), "eligible map definition required")
    assert(not run_id_value.is_empty(), "run_id required")
    assert(retry_value >= 0, "retry_index cannot be negative")
    var value := RunIdentity.new()
    value.map_definition = definition
    value.run_id = run_id_value
    value.retry_index = retry_value
    value.restarted_from_run_id = previous_id
    return value
```

```gdscript
# game/run/run_id_factory.gd
class_name RunIdFactory
extends RefCounted

func next_id() -> String:
    return "run-%s" % Crypto.new().generate_random_bytes(16).hex_encode()
```

- [ ] **Step 7: Register suites, run full tests, and commit**

```bash
git add game/map/map_definition.gd game/run/run_identity.gd game/run/run_id_factory.gd tests/map/test_map_definition.gd tests/run/test_run_identity.gd tests/support/map_fixture.gd tests/run_tests.gd
git commit -m "feat: add immutable map and run identities"
```

---

### Task 2: Strict MapCatalog

**Files:**
- Create: `game/map/map_catalog.gd`
- Create: `tests/map/test_map_catalog.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- `MapCatalog.load_entries(entries: Array) -> Dictionary`
- `MapCatalog.resolve(map_id: StringName, revision: int) -> MapDefinition`
- `MapCatalog.runtime_entries() -> Array`
- `MapCatalog.unique_layout_count() -> int`

- [ ] **Step 1: Write failing duplicate/fallback/isolation tests**

```gdscript
# tests/map/test_map_catalog.gd
extends RefCounted

const MapCatalogScript := preload("res://game/map/map_catalog.gd")
const Fixture := preload("res://tests/support/map_fixture.gd")

func run(test: Variant) -> void:
    test.case("valid entry resolves by exact revision", func() -> void:
        var catalog: Variant = MapCatalogScript.new()
        test.assert_true(catalog.load_entries([Fixture.map_data()]).success)
        test.assert_equal(catalog.resolve(&"map.sx.0001", 1).map_seed, 104729)
        test.assert_equal(catalog.resolve(&"map.sx.0001", 2), null)
    )

    test.case("duplicate layout is rejected", func() -> void:
        var first: Dictionary = Fixture.map_data()
        var second: Dictionary = Fixture.map_data()
        second.map_id = &"map.sx.0002"
        second.map_seed = 104730
        second.content_signature = "content-b"
        var result: Dictionary = MapCatalogScript.new().load_entries([first, second])
        test.assert_false(result.success)
        test.assert_true(result.errors.has("duplicate layout_signature: layout-a"))
    )

    test.case("invalid entry is isolated when partial loading is requested", func() -> void:
        var valid: Dictionary = Fixture.map_data()
        var invalid: Dictionary = Fixture.map_data()
        invalid.map_id = &"map.sx.invalid"
        invalid.layout_signature = ""
        var catalog: Variant = MapCatalogScript.new()
        var result: Dictionary = catalog.load_entries([valid, invalid], true)
        test.assert_true(result.success)
        test.assert_equal(catalog.runtime_entries().size(), 1)
        test.assert_equal(result.rejected_count, 1)
    )
```

- [ ] **Step 2: Implement catalog validation**

```gdscript
# game/map/map_catalog.gd
class_name MapCatalog
extends RefCounted

const MapDefinitionScript := preload("res://game/map/map_definition.gd")

var _by_identity: Dictionary = {}
var _layout_owner: Dictionary = {}
var _content_owner: Dictionary = {}

func load_entries(entries: Array, isolate_invalid: bool = false) -> Dictionary:
    _by_identity.clear()
    _layout_owner.clear()
    _content_owner.clear()
    var errors: Array[String] = []
    var rejected := 0

    for raw: Variant in entries:
        if not raw is Dictionary:
            errors.append("catalog entry must be Dictionary")
            rejected += 1
            continue
        var definition: Variant = MapDefinitionScript.create(raw)
        var entry_errors: Array[String] = definition.validation_errors()
        if definition.used_fallback:
            entry_errors.append("fallback entry is not catalog eligible")
        if not definition.validation_status in MapDefinitionScript.RUNTIME_STATUSES:
            entry_errors.append("runtime-ineligible status")
        if _by_identity.has(definition.identity_key()):
            entry_errors.append("duplicate map identity: %s" % definition.identity_key())
        if _layout_owner.has(definition.layout_signature):
            entry_errors.append("duplicate layout_signature: %s" % definition.layout_signature)
        if _content_owner.has(definition.content_signature):
            entry_errors.append("duplicate content_signature: %s" % definition.content_signature)

        if not entry_errors.is_empty():
            errors.append_array(entry_errors)
            rejected += 1
            if isolate_invalid:
                continue
            _by_identity.clear()
            _layout_owner.clear()
            _content_owner.clear()
            return {"success": false, "errors": errors, "rejected_count": rejected}

        _by_identity[definition.identity_key()] = definition
        _layout_owner[definition.layout_signature] = definition.identity_key()
        _content_owner[definition.content_signature] = definition.identity_key()

    return {
        "success": not _by_identity.is_empty() and (isolate_invalid or errors.is_empty()),
        "errors": errors,
        "rejected_count": rejected,
    }

func resolve(map_id: StringName, revision: int) -> Variant:
    return _by_identity.get("%s@%d" % [map_id, revision], null)

func runtime_entries() -> Array:
    var result: Array = _by_identity.values()
    result.sort_custom(func(a: Variant, b: Variant) -> bool: return a.identity_key() < b.identity_key())
    return result

func unique_layout_count() -> int:
    return _layout_owner.size()
```

- [ ] **Step 3: Run tests and commit**

```bash
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tests/run_tests.gd
git add game/map/map_catalog.gd tests/map/test_map_catalog.gd tests/run_tests.gd
git commit -m "feat: validate versioned map catalog entries"
```

---

### Task 3: Expand RailGenerator to support 100+ layouts

**Files:**
- Modify: `game/rail/rail_generator.gd`
- Create: `tests/rail/test_rail_generator_diversity.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Preserve: `generate(seed: int, max_attempts: int = 32, force_candidate_failure: bool = false) -> RailGraph`
- Add no runtime random global state.

- [ ] **Step 1: Write failing determinism/diversity tests**

```gdscript
# tests/rail/test_rail_generator_diversity.gd
extends RefCounted

const RailGeneratorScript := preload("res://game/rail/rail_generator.gd")

func run(test: Variant) -> void:
    test.case("same seed has same graph signature", func() -> void:
        var generator: Variant = RailGeneratorScript.new()
        test.assert_equal(generator.generate(12345).signature(), generator.generate(12345).signature())
    )

    test.case("bounded scan finds one hundred unique non-fallback graphs", func() -> void:
        var generator: Variant = RailGeneratorScript.new()
        var signatures: Dictionary = {}
        for seed: int in range(1, 2001):
            var graph: Variant = generator.generate(seed)
            if not graph.used_fallback:
                signatures[graph.signature()] = true
            if signatures.size() >= 100:
                break
        test.assert_true(signatures.size() >= 100)
    )

    test.case("forced candidate failure still uses stable fallback", func() -> void:
        var generator: Variant = RailGeneratorScript.new()
        var first: Variant = generator.generate(1, 32, true)
        var second: Variant = generator.generate(999, 32, true)
        test.assert_true(first.used_fallback)
        test.assert_equal(first.signature(), second.signature())
    )
```

- [ ] **Step 2: Run and verify the current diversity test fails**

Expected: existing binary offsets provide roughly 16 signatures.

- [ ] **Step 3: Replace `_build_candidate` and add deterministic selection helpers**

```gdscript
func _build_candidate(seed: int, attempt: int) -> Variant:
    var rows := _select_distinct_positions(seed, attempt, 0x51A7, 1, BOARD_HEIGHT - 2, 2)
    var columns := _select_distinct_positions(seed, attempt, 0xC013, 1, BOARD_WIDTH - 2, 3)
    return _build_network(rows, columns)

func _select_distinct_positions(
    seed: int,
    attempt: int,
    salt: int,
    minimum_value: int,
    maximum_value: int,
    count: int
) -> Array[int]:
    var values: Array[int] = []
    for value: int in range(minimum_value, maximum_value + 1):
        values.append(value)
    var random := RandomNumberGenerator.new()
    random.seed = _mixed_seed(seed, attempt, salt)
    for index: int in range(values.size() - 1, 0, -1):
        var swap_index := random.randi_range(0, index)
        var temporary := values[index]
        values[index] = values[swap_index]
        values[swap_index] = temporary
    var selected: Array[int] = []
    for index: int in range(count):
        selected.append(values[index])
    selected.sort()
    return selected

func _mixed_seed(seed: int, attempt: int, salt: int) -> int:
    var value := int(seed) * 1103515245 + int(attempt + 1) * 12345 + salt
    return absi(value ^ (value >> 16))
```

- [ ] **Step 4: Run all RailGraph tests and full regression**

Expected:

```text
same seed deterministic
all graph contracts pass
forced fallback deterministic
seed scan 1..2000 yields >=100 non-fallback signatures
```

- [ ] **Step 5: Commit**

```bash
git add game/rail/rail_generator.gd tests/rail/test_rail_generator_diversity.gd tests/run_tests.gd
git commit -m "feat: expand deterministic rail layout diversity"
```

---

### Task 4: Offline MapBuildPipeline and JSON manifest

**Files:**
- Create: `game/map/map_build_pipeline.gd`
- Create: `tools/build_map_catalog.gd`
- Create: `data/maps/map_catalog.json`
- Create: `tests/map/test_map_build_pipeline.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- `MapBuildPipeline.build(seed, map_id, revision, force_failure = false) -> Dictionary`
- Output includes `definition`, `graph`, `stations`, and initial pickup state.

- [ ] **Step 1: Write failing pipeline reconstruction tests**

```gdscript
# tests/map/test_map_build_pipeline.gd
extends RefCounted

const PipelineScript := preload("res://game/map/map_build_pipeline.gd")

func run(test: Variant) -> void:
    test.case("same seed rebuilds all component signatures", func() -> void:
        var pipeline: Variant = PipelineScript.new()
        var first: Dictionary = pipeline.build(101, &"map.sx.0001", 1)
        var second: Dictionary = pipeline.build(101, &"map.sx.0001", 1)
        test.assert_true(first.success)
        test.assert_equal(first.definition.graph_signature, second.definition.graph_signature)
        test.assert_equal(first.definition.station_signature, second.definition.station_signature)
        test.assert_equal(first.definition.initial_pickup_signature, second.definition.initial_pickup_signature)
        test.assert_equal(first.definition.layout_signature, second.definition.layout_signature)
        test.assert_equal(first.definition.content_signature, second.definition.content_signature)
    )

    test.case("fallback candidate cannot become definition", func() -> void:
        var result: Dictionary = PipelineScript.new().build(101, &"map.sx.fallback", 1, true)
        test.assert_false(result.success)
        test.assert_equal(result.status, &"FALLBACK_REJECTED")
    )
```

- [ ] **Step 2: Implement the pipeline**

```gdscript
# game/map/map_build_pipeline.gd
class_name MapBuildPipeline
extends RefCounted

const RailGeneratorScript := preload("res://game/rail/rail_generator.gd")
const StationPlacerScript := preload("res://game/station/station_placer.gd")
const CargoSpawnerScript := preload("res://game/cargo/cargo_spawner.gd")
const MapDefinitionScript := preload("res://game/map/map_definition.gd")

const GENERATOR_VERSION: StringName = &"railgen_v2"
const RULESET_VERSION: StringName = &"standard_v1"
const TRAIN_START := Vector2i(0, 0)
const INITIAL_DIRECTION := Vector2i.RIGHT

func build(seed: int, map_id: StringName, revision: int, force_failure: bool = false) -> Dictionary:
    var graph: Variant = RailGeneratorScript.new().generate(seed, 32, force_failure)
    if graph.used_fallback:
        return {"success": false, "status": &"FALLBACK_REJECTED"}

    var station_result: Dictionary = StationPlacerScript.new().place(graph, TRAIN_START, seed)
    if not station_result.success:
        return {"success": false, "status": &"STATION_PLACEMENT_FAILED"}

    var spawner: Variant = CargoSpawnerScript.new()
    spawner.configure(graph, station_result.stations, seed)
    if spawner.ensure_all_minimum() == &"SPAWN_DEFERRED":
        return {"success": false, "status": &"INITIAL_PICKUP_FAILED"}

    var graph_signature := graph.signature()
    var station_signature := str(station_result.signature)
    var pickup_signature := spawner.signature()
    var switch_defaults := _switch_default_signature(graph)
    var layout_signature := _sha256("%s\n%s\n%s\n%d,%d\n%d,%d\n%s" % [
        GENERATOR_VERSION,
        graph_signature,
        station_signature,
        TRAIN_START.x,
        TRAIN_START.y,
        INITIAL_DIRECTION.x,
        INITIAL_DIRECTION.y,
        switch_defaults,
    ])
    var content_signature := _sha256("%s\n%s\n%s" % [layout_signature, pickup_signature, RULESET_VERSION])

    var definition: Variant = MapDefinitionScript.create({
        "map_id": map_id,
        "map_revision": revision,
        "map_seed": seed,
        "generator_version": GENERATOR_VERSION,
        "ruleset_version": RULESET_VERSION,
        "graph_signature": graph_signature,
        "station_signature": station_signature,
        "initial_pickup_signature": pickup_signature,
        "layout_signature": layout_signature,
        "content_signature": content_signature,
        "validation_status": &"VALIDATED",
        "used_fallback": false,
    })
    return {
        "success": definition.is_runtime_eligible(),
        "status": &"BUILT",
        "definition": definition,
        "graph": graph,
        "stations": station_result.stations,
        "spawner": spawner,
    }

func _switch_default_signature(graph: Variant) -> String:
    var parts: Array[String] = []
    for cell: Vector2i in graph.switch_cells():
        parts.append("%d,%d:A" % [cell.x, cell.y])
    return "|".join(parts)

func _sha256(value: String) -> String:
    var context := HashingContext.new()
    context.start(HashingContext.HASH_SHA256)
    context.update(value.to_utf8_buffer())
    return context.finish().hex_encode()
```

- [ ] **Step 3: Implement the bounded catalog builder**

```gdscript
# tools/build_map_catalog.gd
extends SceneTree

const PipelineScript := preload("res://game/map/map_build_pipeline.gd")
const CatalogScript := preload("res://game/map/map_catalog.gd")
const TARGET_COUNT := 100
const SEED_SCAN_LIMIT := 10000
const OUTPUT_PATH := "res://data/maps/map_catalog.json"

func _init() -> void:
    var entries: Array = []
    var layouts: Dictionary = {}
    var pipeline: Variant = PipelineScript.new()

    for seed: int in range(1, SEED_SCAN_LIMIT + 1):
        var map_id := StringName("map.sx.%04d" % [entries.size() + 1])
        var result: Dictionary = pipeline.build(seed, map_id, 1)
        if not result.success:
            continue
        var definition: Variant = result.definition
        if layouts.has(definition.layout_signature):
            continue
        layouts[definition.layout_signature] = true
        entries.append(definition.to_dictionary())
        if entries.size() == TARGET_COUNT:
            break

    if entries.size() != TARGET_COUNT:
        push_error("unique map target failed: %d/%d" % [entries.size(), TARGET_COUNT])
        quit(1)
        return

    var validation: Dictionary = CatalogScript.new().load_entries(entries)
    if not validation.success:
        push_error("catalog invalid: %s" % [validation.errors])
        quit(1)
        return

    var payload := {
        "schema_version": 1,
        "generator_version": "railgen_v2",
        "ruleset_version": "standard_v1",
        "unique_layout_count": entries.size(),
        "maps": entries,
    }
    var file := FileAccess.open(OUTPUT_PATH, FileAccess.WRITE)
    if file == null:
        push_error("cannot write catalog")
        quit(1)
        return
    file.store_string(JSON.stringify(payload, "  "))
    file.close()
    print("MAP_CATALOG_BUILT count=%d" % entries.size())
    quit(0)
```

- [ ] **Step 4: Produce and commit only a three-entry Vertical Slice manifest at first**

Use an argument or test fixture target of `3`. The target-100 command is a production milestone and must not be claimed merely because the tool exists.

- [ ] **Step 5: Run tests and commit**

```bash
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tests/run_tests.gd
git add game/map/map_build_pipeline.gd tools/build_map_catalog.gd data/maps/map_catalog.json tests/map/test_map_build_pipeline.gd tests/run_tests.gd
git commit -m "feat: add validated offline map catalog pipeline"
```

---

### Task 5: Fresh RunSession and same-map restart

**Files:**
- Create: `game/run/run_session.gd`
- Create: `game/run/run_session_factory.gd`
- Modify: `game/run/run_controller.gd`
- Create: `tests/run/test_same_seed_restart.gd`
- Create: `tests/integration/test_restart_determinism.gd`
- Modify: `tests/support/map_fixture.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- `RunSessionFactory.create(identity: RunIdentity) -> Dictionary`
- `RunController.start_map(map_id, revision) -> Dictionary`
- `RunController.restart_same_map() -> Dictionary`
- `RunSession.immutable_signatures() -> Dictionary`

- [ ] **Step 1: Extend fixture with a real three-entry catalog and deterministic run IDs**

```gdscript
# tests/support/map_fixture.gd additions
class FixedRunIdFactory:
    extends RefCounted
    var ids: Array[String]
    func _init(values: Array[String]) -> void: ids = values.duplicate()
    func next_id() -> String: return ids.pop_front()
```

Build fixture definitions through `MapBuildPipeline`; do not hand-write fake signatures for integration tests.

- [ ] **Step 2: Write failing reset test**

```gdscript
# tests/run/test_same_seed_restart.gd
extends RefCounted

const Fixture := preload("res://tests/support/map_fixture.gd")

func run(test: Variant) -> void:
    test.case("restart preserves map and recreates mutable services", func() -> void:
        var setup: Dictionary = Fixture.controller(["run-a", "run-b"])
        var controller: Variant = setup.controller
        test.assert_true(controller.start_map(&"map.sx.0001", 1).success)
        var first_session: Variant = controller.session
        var first_identity: Variant = controller.identity

        first_session.run_state.fuel = 3.0
        first_session.run_state.score = 900
        first_session.cargo_stack.push(&"RED_STAR")
        first_session.spawner.collect(first_session.spawner.pickup_cells()[0], 1.0)
        first_session.difficulty_director.force_step_for_test(4)

        test.assert_true(controller.restart_same_map().success)
        test.assert_equal(controller.identity.map_definition.identity_key(), first_identity.map_definition.identity_key())
        test.assert_equal(controller.identity.map_definition.map_seed, first_identity.map_definition.map_seed)
        test.assert_not_equal(controller.identity.run_id, first_identity.run_id)
        test.assert_not_equal(controller.session, first_session)
        test.assert_equal(controller.session.run_state.score, 0)
        test.assert_equal(controller.session.cargo_stack.size(), 0)
        test.assert_equal(controller.session.difficulty_director.current_step(), 0)
        test.assert_equal(controller.identity.retry_index, 1)
        test.assert_equal(controller.identity.restarted_from_run_id, "run-a")
    )
```

- [ ] **Step 3: Write failing reconstruction and stale-event tests**

```gdscript
# tests/integration/test_restart_determinism.gd
extends RefCounted

const Fixture := preload("res://tests/support/map_fixture.gd")

func run(test: Variant) -> void:
    test.case("restart rebuilds exact component signatures", func() -> void:
        var controller: Variant = Fixture.controller(["run-a", "run-b"]).controller
        controller.start_map(&"map.sx.0001", 1)
        var first: Dictionary = controller.session.immutable_signatures()
        controller.restart_same_map()
        test.assert_equal(controller.session.immutable_signatures(), first)
    )

    test.case("old generation difficulty event is ignored", func() -> void:
        var controller: Variant = Fixture.controller(["run-a", "run-b"]).controller
        controller.start_map(&"map.sx.0001", 1)
        var old_generation: int = controller.run_generation
        controller.restart_same_map()
        controller.consume_difficulty_event(old_generation, {"step": 99})
        test.assert_equal(controller.session.difficulty_director.current_step(), 0)
    )
```

- [ ] **Step 4: Implement RunSession**

```gdscript
# game/run/run_session.gd
class_name RunSession
extends RefCounted

var identity: Variant
var graph: Variant
var stations: Array
var spawner: Variant
var cargo_stack: Variant
var run_state: Variant
var train_controller: Variant
var delivery_loop: Variant
var difficulty_director: Variant

func immutable_signatures() -> Dictionary:
    return {
        "graph_signature": graph.signature(),
        "station_signature": _station_signature(),
        "initial_pickup_signature": spawner.signature(),
    }

func _station_signature() -> String:
    var parts: Array[String] = []
    for station: Variant in stations:
        parts.append("%s@%d,%d" % [station.cargo_type, station.cell.x, station.cell.y])
    parts.sort()
    return "|".join(parts)
```

- [ ] **Step 5: Implement RunSessionFactory with signature enforcement**

```gdscript
# game/run/run_session_factory.gd
class_name RunSessionFactory
extends RefCounted

const PipelineScript := preload("res://game/map/map_build_pipeline.gd")
const SessionScript := preload("res://game/run/run_session.gd")
const CargoStackScript := preload("res://game/cargo/cargo_stack.gd")
const RunStateScript := preload("res://game/run/run_state.gd")
const TrainControllerScript := preload("res://game/train/train_controller.gd")
const DeliveryLoopScript := preload("res://game/delivery/delivery_loop.gd")
const DifficultyDirectorScript := preload("res://game/difficulty/difficulty_director.gd")

func create(identity: Variant) -> Dictionary:
    var definition: Variant = identity.map_definition
    var rebuilt: Dictionary = PipelineScript.new().build(
        definition.map_seed,
        definition.map_id,
        definition.map_revision
    )
    if not rebuilt.success:
        return {"success": false, "status": rebuilt.status}
    var actual: Variant = rebuilt.definition
    if actual.graph_signature != definition.graph_signature:
        return {"success": false, "status": &"GRAPH_SIGNATURE_MISMATCH"}
    if actual.station_signature != definition.station_signature:
        return {"success": false, "status": &"STATION_SIGNATURE_MISMATCH"}
    if actual.initial_pickup_signature != definition.initial_pickup_signature:
        return {"success": false, "status": &"PICKUP_SIGNATURE_MISMATCH"}
    if actual.layout_signature != definition.layout_signature or actual.content_signature != definition.content_signature:
        return {"success": false, "status": &"COMBINED_SIGNATURE_MISMATCH"}

    var session: Variant = SessionScript.new()
    session.identity = identity
    session.graph = rebuilt.graph
    session.stations = rebuilt.stations
    session.spawner = rebuilt.spawner
    session.cargo_stack = CargoStackScript.new(8)
    session.run_state = RunStateScript.new()
    session.train_controller = TrainControllerScript.new()
    session.delivery_loop = DeliveryLoopScript.new()
    session.difficulty_director = DifficultyDirectorScript.new()
    return {"success": true, "status": &"SESSION_CREATED", "session": session}
```

- [ ] **Step 6: Modify RunController**

```gdscript
var map_catalog: Variant
var session_factory: Variant
var run_id_factory: Variant
var identity: Variant
var session: Variant
var run_generation: int = 0

func start_map(map_id: StringName, revision: int) -> Dictionary:
    var definition: Variant = map_catalog.resolve(map_id, revision)
    if definition == null:
        return {"success": false, "status": &"MAP_NOT_FOUND"}
    return _start_attempt(definition, 0, "")

func restart_same_map() -> Dictionary:
    if identity == null:
        return {"success": false, "status": &"NO_PREVIOUS_RUN"}
    return _start_attempt(identity.map_definition, identity.retry_index + 1, identity.run_id)

func _start_attempt(definition: Variant, retry_index: int, previous_run_id: String) -> Dictionary:
    var next_identity: Variant = RunIdentity.create(
        definition,
        run_id_factory.next_id(),
        retry_index,
        previous_run_id
    )
    var result: Dictionary = session_factory.create(next_identity)
    if not result.success:
        return result
    run_generation += 1
    identity = next_identity
    session = result.session
    run_started.emit(identity)
    return {"success": true, "status": &"RUN_STARTED", "identity": identity}

func consume_difficulty_event(event_generation: int, event: Dictionary) -> void:
    if event_generation != run_generation:
        return
    session.difficulty_director.consume_authoritative_event(event)
```

- [ ] **Step 7: Run all regression and commit**

Explicit assertions:

```text
same map ID/revision/seed/signatures
new run/reward IDs
new service object identities
zeroed score/fuel/stack/difficulty
no pending previous respawns
stale callback ignored
same inputs -> same authoritative event/hash sequence
warning on/off and Reduced Motion -> same simulation hash
```

```bash
git add game/run/run_session.gd game/run/run_session_factory.gd game/run/run_controller.gd tests/run/test_same_seed_restart.gd tests/integration/test_restart_determinism.gd tests/support/map_fixture.gd tests/run_tests.gd
git commit -m "feat: restart runs on the same validated map"
```

---

### Task 6: Result UI and telemetry lineage

**Files:**
- Modify: `game/ui/result_panel.gd`
- Create: `game/telemetry/run_start_event.gd`
- Modify: `game/telemetry/run_event_log.gd`
- Create: `tests/telemetry/test_run_start_event.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Result UI emits `restart_requested()` with no seed argument.
- Controller alone resolves the existing map definition.
- Telemetry projects immutable identity and never mutates run state.

- [ ] **Step 1: Write failing telemetry test**

```gdscript
# tests/telemetry/test_run_start_event.gd
extends RefCounted

const EventScript := preload("res://game/telemetry/run_start_event.gd")
const Fixture := preload("res://tests/support/map_fixture.gd")

func run(test: Variant) -> void:
    test.case("retry telemetry has map and lineage but no UI seed", func() -> void:
        var identity: Variant = Fixture.retry_identity()
        var event: Dictionary = EventScript.from_identity(identity, false)
        test.assert_equal(event.map_id, &"map.sx.0001")
        test.assert_equal(event.map_revision, 1)
        test.assert_equal(event.retry_index, 1)
        test.assert_equal(event.restarted_from_run_id, "run-a")
        test.assert_false(event.has("ui_selected_seed"))
    )
```

- [ ] **Step 2: Implement bounded telemetry projection**

```gdscript
# game/telemetry/run_start_event.gd
class_name RunStartEvent
extends RefCounted

static func from_identity(identity: Variant, assisted: bool) -> Dictionary:
    var definition: Variant = identity.map_definition
    return {
        "event_name": &"run_started",
        "run_id": identity.run_id,
        "map_id": definition.map_id,
        "map_revision": definition.map_revision,
        "generator_version": definition.generator_version,
        "ruleset_version": definition.ruleset_version,
        "retry_index": identity.retry_index,
        "restarted_from_run_id": identity.restarted_from_run_id,
        "assisted": assisted,
        "layout_signature_prefix": definition.layout_signature.left(12),
    }
```

- [ ] **Step 3: Keep ResultPanel semantic**

```gdscript
signal restart_requested

func _on_restart_pressed() -> void:
    restart_requested.emit()
```

Forbidden result-UI responsibilities:

```text
choose seed
edit seed
advance map
reuse run_id
commit record
commit reward
rebuild graph
```

- [ ] **Step 4: Verify reward identity separation and commit**

```text
first.run_id != retry.run_id
first.reward_event_id != retry.reward_event_id
first.map_definition.identity_key == retry.map_definition.identity_key
```

```bash
git add game/ui/result_panel.gd game/telemetry/run_start_event.gd game/telemetry/run_event_log.gd tests/telemetry/test_run_start_event.gd tests/run_tests.gd
git commit -m "feat: record same-map retry lineage"
```

---

### Task 7: Catalog audit and evidence

**Files:**
- Create: `tools/audit_map_catalog.gd`
- Create: `기획서/50_제작_검증/MAP_CATALOG_VALIDATION.md`
- Modify only after implementation proof: `기획서/10_경험/CORE_GAMEPLAY.md`
- Modify only after implementation proof: `기획서/20_시스템_콘텐츠/CORE_SYSTEMS.md`

- [ ] **Step 1: Implement catalog audit assertions**

For requested target `N`, fail unless:

```text
schema_version == 1
entry_count >= N
unique map identity count == entry count
unique layout signature count == entry count
unique content signature count == entry count
fallback count == 0
runtime-ineligible count == 0
rebuild graph mismatch count == 0
rebuild station mismatch count == 0
rebuild pickup mismatch count == 0
combined signature mismatch count == 0
```

- [ ] **Step 2: Add bounded candidate-distribution evidence**

Collect without declaring final balance:

```text
cycle rank
switch counts
station distance distribution
initial pickup reachability
spawn-deferred count
no-input survival result
first-delivery time under baseline bot
runtime/script error count
```

All tuning thresholds remain `TEST_VALUE` until human review.

- [ ] **Step 3: Run Vertical Slice verification**

```bash
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tests/run_tests.gd
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tools/audit_map_catalog.gd -- --target-count=3
```

- [ ] **Step 4: Run production map milestone only when authorized**

```bash
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tools/build_map_catalog.gd
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tools/audit_map_catalog.gd -- --target-count=100
```

Do not report 100 maps complete unless both commands pass against the committed manifest and required visual/human distribution review is complete.

- [ ] **Step 5: Adversarially attack**

```text
restart state leakage
seed used as transaction ID
duplicate/fallback map inflation
same seed after generator-version change
missing/corrupt revision
stale warning or spawn callback
repeated restart memory growth
manifest load time and size
cosmetic/motion/warning simulation drift
easy-map dominance in global records (follow-up Decision)
```

- [ ] **Step 6: Commit evidence and follow SX-OPS-001 synchronization**

```bash
git add tools/audit_map_catalog.gd 기획서/50_제작_검증/MAP_CATALOG_VALIDATION.md 기획서/10_경험/CORE_GAMEPLAY.md 기획서/20_시스템_콘텐츠/CORE_SYSTEMS.md
git commit -m "docs: validate same-map restart and map catalog"
```

Then verify exact-head CI, unresolved threads, product scope, canonical merge, Decision Registry, correct Sheet 12-tab write/readback, and Sync Closure.

## Final Verification Matrix

| Requirement | Automated | Runtime | Human |
|---|---|---|---|
| same map identity on restart | unit/integration | debug capture | optional |
| new run/reward identity | unit/transaction | event log | not required |
| complete mutable reset | integration | side-by-side retry | 5+ later |
| component signature parity | rebuild audit | debug capture | not required |
| warning/motion/cosmetic parity | simulation hash | capture | accessibility review |
| fallback/duplicate exclusion | catalog tests/audit | not required | not required |
| three-map Vertical Slice | target-3 audit | three-map capture | readability review |
| 100+ production layouts | target-100 audit | load/performance | distribution/playtest review |

## Plan Self-Review

- All five signature fields are named identically in design, model, builder, factory, JSON, tests, and audit.
- No undefined alternate field such as `layout_graph_signature` remains.
- Catalog count uses unique `layout_signature`, not seed integers.
- Safe fallback never becomes a shipped map.
- Restart creates a new service graph and does not call a reset method on reused mutable services.
- UI emits a semantic request and cannot supply a seed.
- Reward and telemetry identity use `run_id`, never `map_seed`.
- Three-map proof and 100-map production milestone are explicitly separated.
- Different-map selection and cross-map record fairness remain unresolved.
- No product work begins before the required planning and build gates.
