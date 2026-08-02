# Same-Seed Restart and Curated Map Catalog Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make `RESTART` rebuild the exact same validated map revision with a new run identity, and add an offline validated seed-catalog pipeline capable of producing at least 100 genuinely distinct map layouts.

**Architecture:** Separate immutable map content identity from mutable run-attempt identity. Runtime resolves `MapDefinition` entries from a validated `MapCatalog`, creates a fresh `RunSession` for every attempt, and reuses the same definition on restart. An offline build pipeline expands the deterministic rail-generator candidate space, rejects fallback and duplicate layout signatures, and emits a versioned catalog manifest.

**Tech Stack:** Godot 4.7.1-stable, GDScript, JSON catalog manifest, SHA-256 through `HashingContext`, existing custom headless test runner, GitHub Actions Godot Tests.

## Global Constraints

- Decision authority is `SX-DEC-023 / EV-USER-012`.
- `RESTART` always uses the same `map_id`, `map_revision`, `map_seed`, `generator_version`, and `ruleset_version` as the ended run.
- Every restart creates a new `run_id`, reward-event namespace, telemetry attempt, and mutable run service graph.
- The previous run's fuel, score, CargoStack, switch state, route history, pending spawn requests, difficulty state, warning state, result evidence, and transaction state must not survive.
- New seeds are produced only by the map-content pipeline; restart never searches or rolls a seed.
- Runtime standard play loads only `VALIDATED` or `SHIPPED` catalog entries.
- Safe fallback graphs never count toward the production map total.
- The production target is at least 100 unique `layout_signature` values, not merely 100 seed integers.
- Different-map selection, rotation, progression, discovery, and global-versus-per-map record policy remain outside this plan.
- Existing `SX-DEC-016` through `SX-DEC-022` authority and eligibility contracts remain unchanged.
- Godot, Scene, Resource, asset, runtime, Android, and human evidence remain untouched until `GMB-001` is merged and the build gate is `READY_FOR_BUILD`.

---

## File Structure

### New domain files

```text
game/map/map_definition.gd
  Immutable map identity, version, signatures, and validation status.

game/map/map_catalog.gd
  Loads and validates catalog entries; rejects duplicate IDs/signatures and fallback maps.

game/map/map_build_pipeline.gd
  Offline candidate construction, station/pickup placement, signature calculation, and promotion result.

game/run/run_identity.gd
  Immutable identity for one attempt.

game/run/run_id_factory.gd
  Production unique run-ID creation with test injection boundary.

game/run/run_session.gd
  Owns one attempt's mutable gameplay services and resettable state.

game/run/run_session_factory.gd
  Reconstructs a fresh session from one immutable MapDefinition.

game/telemetry/run_start_event.gd
  Bounded map/retry identity payload for telemetry.

tools/build_map_catalog.gd
  Offline command that scans candidate seeds and writes a validated JSON manifest.

data/maps/map_catalog.json
  Generated and reviewed catalog manifest; Vertical Slice starts with three entries.
```

### Modified files

```text
game/rail/rail_generator.gd
  Expand deterministic topology space from binary corridor offsets to seeded distinct interior rows/columns.

game/run/run_controller.gd
  Start attempts from MapDefinition and restart with the same definition plus a new RunIdentity.

game/ui/result_panel.gd
  Emit a semantic restart request; never choose or mutate a seed.

game/telemetry/run_event_log.gd
  Record map ID/revision and retry lineage without owning gameplay.

tests/run_tests.gd
  Register the new map, catalog, restart, and telemetry suites.
```

### New tests

```text
tests/map/test_map_definition.gd
tests/map/test_map_catalog.gd
tests/map/test_map_build_pipeline.gd
tests/rail/test_rail_generator_diversity.gd
tests/run/test_run_identity.gd
tests/run/test_same_seed_restart.gd
tests/integration/test_restart_determinism.gd
tests/telemetry/test_run_start_event.gd
```

---

### Task 1: Immutable MapDefinition and RunIdentity

**Files:**
- Create: `game/map/map_definition.gd`
- Create: `game/run/run_identity.gd`
- Create: `game/run/run_id_factory.gd`
- Create: `tests/map/test_map_definition.gd`
- Create: `tests/run/test_run_identity.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Produces: `MapDefinition.create(data: Dictionary) -> MapDefinition`
- Produces: `MapDefinition.is_runtime_eligible() -> bool`
- Produces: `MapDefinition.identity_key() -> String`
- Produces: `RunIdentity.create(definition: MapDefinition, run_id: String, retry_index: int, restarted_from_run_id: String) -> RunIdentity`
- Produces: `RunIdFactory.next_id() -> String`

- [ ] **Step 1: Write failing MapDefinition validation tests**

```gdscript
# tests/map/test_map_definition.gd
extends RefCounted

const MapDefinitionScript := preload("res://game/map/map_definition.gd")

func run(test: Variant) -> void:
    test.case("validated map definition is runtime eligible", func() -> void:
        var definition: Variant = MapDefinitionScript.create({
            "map_id": &"map.sx.0001",
            "map_revision": 1,
            "map_seed": 104729,
            "generator_version": &"railgen_v2",
            "ruleset_version": &"standard_v1",
            "layout_signature": "layout-a",
            "content_signature": "content-a",
            "validation_status": &"VALIDATED",
            "used_fallback": false,
        })
        test.assert_true(definition.is_runtime_eligible())
        test.assert_equal(definition.identity_key(), "map.sx.0001@1")
    )

    test.case("fallback and draft entries are not runtime eligible", func() -> void:
        var fallback: Variant = MapDefinitionScript.create({
            "map_id": &"map.sx.fallback",
            "map_revision": 1,
            "map_seed": 1,
            "generator_version": &"railgen_v2",
            "ruleset_version": &"standard_v1",
            "layout_signature": "fallback-layout",
            "content_signature": "fallback-content",
            "validation_status": &"VALIDATED",
            "used_fallback": true,
        })
        var draft: Variant = MapDefinitionScript.create({
            "map_id": &"map.sx.draft",
            "map_revision": 1,
            "map_seed": 2,
            "generator_version": &"railgen_v2",
            "ruleset_version": &"standard_v1",
            "layout_signature": "draft-layout",
            "content_signature": "draft-content",
            "validation_status": &"DRAFT",
            "used_fallback": false,
        })
        test.assert_false(fallback.is_runtime_eligible())
        test.assert_false(draft.is_runtime_eligible())
    )
```

- [ ] **Step 2: Write failing run identity tests**

```gdscript
# tests/run/test_run_identity.gd
extends RefCounted

const MapDefinitionScript := preload("res://game/map/map_definition.gd")
const RunIdentityScript := preload("res://game/run/run_identity.gd")

func run(test: Variant) -> void:
    test.case("retry keeps map identity and changes run identity", func() -> void:
        var definition: Variant = MapDefinitionScript.create(_definition_data())
        var first: Variant = RunIdentityScript.create(definition, "run-a", 0, "")
        var retry: Variant = RunIdentityScript.create(definition, "run-b", 1, first.run_id)

        test.assert_equal(retry.map_definition.identity_key(), first.map_definition.identity_key())
        test.assert_equal(retry.map_definition.map_seed, first.map_definition.map_seed)
        test.assert_not_equal(retry.run_id, first.run_id)
        test.assert_equal(retry.retry_index, 1)
        test.assert_equal(retry.restarted_from_run_id, "run-a")
    )

func _definition_data() -> Dictionary:
    return {
        "map_id": &"map.sx.0001",
        "map_revision": 1,
        "map_seed": 104729,
        "generator_version": &"railgen_v2",
        "ruleset_version": &"standard_v1",
        "layout_signature": "layout-a",
        "content_signature": "content-a",
        "validation_status": &"VALIDATED",
        "used_fallback": false,
    }
```

- [ ] **Step 3: Run the new tests and verify failure**

Run:

```bash
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tests/run_tests.gd
```

Expected: failure because `map_definition.gd` and `run_identity.gd` do not exist.

- [ ] **Step 4: Implement MapDefinition**

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
var layout_signature: String
var content_signature: String
var validation_status: StringName
var used_fallback: bool

static func create(data: Dictionary) -> MapDefinition:
    var definition := MapDefinition.new()
    definition.map_id = StringName(data.get("map_id", &""))
    definition.map_revision = int(data.get("map_revision", 0))
    definition.map_seed = int(data.get("map_seed", 0))
    definition.generator_version = StringName(data.get("generator_version", &""))
    definition.ruleset_version = StringName(data.get("ruleset_version", &""))
    definition.layout_signature = str(data.get("layout_signature", ""))
    definition.content_signature = str(data.get("content_signature", ""))
    definition.validation_status = StringName(data.get("validation_status", &"DRAFT"))
    definition.used_fallback = bool(data.get("used_fallback", false))
    return definition

func identity_key() -> String:
    return "%s@%d" % [map_id, map_revision]

func validation_errors() -> Array[String]:
    var errors: Array[String] = []
    if map_id == &"": errors.append("map_id is required")
    if map_revision <= 0: errors.append("map_revision must be positive")
    if generator_version == &"": errors.append("generator_version is required")
    if ruleset_version == &"": errors.append("ruleset_version is required")
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
        "layout_signature": layout_signature,
        "content_signature": content_signature,
        "validation_status": str(validation_status),
        "used_fallback": used_fallback,
    }
```

- [ ] **Step 5: Implement RunIdentity and RunIdFactory**

```gdscript
# game/run/run_identity.gd
class_name RunIdentity
extends RefCounted

var map_definition: Variant
var run_id: String
var retry_index: int
var restarted_from_run_id: String

static func create(
    definition: Variant,
    attempt_run_id: String,
    attempt_retry_index: int,
    previous_run_id: String
) -> RunIdentity:
    assert(definition != null and definition.is_runtime_eligible(), "run requires an eligible map definition")
    assert(not attempt_run_id.is_empty(), "run_id is required")
    assert(attempt_retry_index >= 0, "retry_index cannot be negative")
    var identity := RunIdentity.new()
    identity.map_definition = definition
    identity.run_id = attempt_run_id
    identity.retry_index = attempt_retry_index
    identity.restarted_from_run_id = previous_run_id
    return identity
```

```gdscript
# game/run/run_id_factory.gd
class_name RunIdFactory
extends RefCounted

func next_id() -> String:
    var crypto := Crypto.new()
    return "run-%s" % crypto.generate_random_bytes(16).hex_encode()
```

- [ ] **Step 6: Register suites, run all tests, and commit**

Expected: all prior tests plus the new identity tests pass.

```bash
git add game/map/map_definition.gd game/run/run_identity.gd game/run/run_id_factory.gd tests/map/test_map_definition.gd tests/run/test_run_identity.gd tests/run_tests.gd
git commit -m "feat: add immutable map and run identities"
```

---

### Task 2: Validated MapCatalog and duplicate rejection

**Files:**
- Create: `game/map/map_catalog.gd`
- Create: `tests/map/test_map_catalog.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Consumes: `MapDefinition.create(data)`
- Produces: `MapCatalog.load_entries(entries: Array) -> Dictionary`
- Produces: `MapCatalog.resolve(map_id: StringName, revision: int) -> MapDefinition`
- Produces: `MapCatalog.runtime_entries() -> Array[MapDefinition]`

- [ ] **Step 1: Write failing catalog tests**

```gdscript
# tests/map/test_map_catalog.gd
extends RefCounted

const MapCatalogScript := preload("res://game/map/map_catalog.gd")

func run(test: Variant) -> void:
    test.case("catalog resolves validated entry", func() -> void:
        var catalog: Variant = MapCatalogScript.new()
        var result: Dictionary = catalog.load_entries([_entry("map.sx.0001", 1, "layout-a", false)])
        test.assert_true(result.success)
        test.assert_equal(catalog.resolve(&"map.sx.0001", 1).map_seed, 1001)
    )

    test.case("catalog rejects duplicate layout signature", func() -> void:
        var catalog: Variant = MapCatalogScript.new()
        var result: Dictionary = catalog.load_entries([
            _entry("map.sx.0001", 1, "layout-a", false),
            _entry("map.sx.0002", 1, "layout-a", false),
        ])
        test.assert_false(result.success)
        test.assert_true(result.errors.has("duplicate layout_signature: layout-a"))
    )

    test.case("catalog rejects fallback entry", func() -> void:
        var catalog: Variant = MapCatalogScript.new()
        var result: Dictionary = catalog.load_entries([_entry("map.sx.0001", 1, "layout-a", true)])
        test.assert_false(result.success)
    )

func _entry(id: String, revision: int, layout: String, fallback: bool) -> Dictionary:
    return {
        "map_id": id,
        "map_revision": revision,
        "map_seed": 1000 + revision,
        "generator_version": "railgen_v2",
        "ruleset_version": "standard_v1",
        "layout_signature": layout,
        "content_signature": "%s-content" % layout,
        "validation_status": "VALIDATED",
        "used_fallback": fallback,
    }
```

- [ ] **Step 2: Run tests and verify missing class failure**

Use the full headless command. Expected: missing `map_catalog.gd`.

- [ ] **Step 3: Implement strict catalog loading**

```gdscript
# game/map/map_catalog.gd
class_name MapCatalog
extends RefCounted

const MapDefinitionScript := preload("res://game/map/map_definition.gd")

var _by_identity: Dictionary = {}
var _layout_owner: Dictionary = {}
var _content_owner: Dictionary = {}

func load_entries(entries: Array) -> Dictionary:
    _by_identity.clear()
    _layout_owner.clear()
    _content_owner.clear()
    var errors: Array[String] = []

    for raw_entry: Variant in entries:
        if not raw_entry is Dictionary:
            errors.append("catalog entry must be a Dictionary")
            continue
        var definition: Variant = MapDefinitionScript.create(raw_entry)
        for error: String in definition.validation_errors():
            errors.append("%s: %s" % [definition.identity_key(), error])
        if definition.used_fallback:
            errors.append("fallback entry is not catalog eligible: %s" % definition.identity_key())
        if not definition.is_runtime_eligible():
            errors.append("entry is not runtime eligible: %s" % definition.identity_key())

        var identity := definition.identity_key()
        if _by_identity.has(identity):
            errors.append("duplicate map identity: %s" % identity)
        if _layout_owner.has(definition.layout_signature):
            errors.append("duplicate layout_signature: %s" % definition.layout_signature)
        if _content_owner.has(definition.content_signature):
            errors.append("duplicate content_signature: %s" % definition.content_signature)

        _by_identity[identity] = definition
        _layout_owner[definition.layout_signature] = identity
        _content_owner[definition.content_signature] = identity

    if not errors.is_empty():
        _by_identity.clear()
        _layout_owner.clear()
        _content_owner.clear()
    return {"success": errors.is_empty(), "errors": errors}

func resolve(map_id: StringName, revision: int) -> Variant:
    return _by_identity.get("%s@%d" % [map_id, revision], null)

func runtime_entries() -> Array:
    var result: Array = _by_identity.values()
    result.sort_custom(func(first: Variant, second: Variant) -> bool:
        return first.identity_key() < second.identity_key()
    )
    return result

func unique_layout_count() -> int:
    return _layout_owner.size()
```

- [ ] **Step 4: Run full regression and commit**

```bash
git add game/map/map_catalog.gd tests/map/test_map_catalog.gd tests/run_tests.gd
git commit -m "feat: validate versioned map catalog entries"
```

---

### Task 3: Expand deterministic RailGenerator topology space

**Files:**
- Modify: `game/rail/rail_generator.gd`
- Create: `tests/rail/test_rail_generator_diversity.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Preserves: `RailGenerator.generate(seed: int, max_attempts: int = 32, force_candidate_failure: bool = false) -> RailGraph`
- Produces: at least 100 distinct valid graph signatures within a bounded seed scan

- [ ] **Step 1: Write failing diversity and determinism tests**

```gdscript
# tests/rail/test_rail_generator_diversity.gd
extends RefCounted

const RailGeneratorScript := preload("res://game/rail/rail_generator.gd")

func run(test: Variant) -> void:
    test.case("same seed produces same signature", func() -> void:
        var generator: Variant = RailGeneratorScript.new()
        test.assert_equal(generator.generate(12345).signature(), generator.generate(12345).signature())
    )

    test.case("bounded scan yields one hundred unique non-fallback layouts", func() -> void:
        var generator: Variant = RailGeneratorScript.new()
        var signatures: Dictionary = {}
        for seed: int in range(1, 2001):
            var graph: Variant = generator.generate(seed)
            if graph.used_fallback:
                continue
            signatures[graph.signature()] = true
            if signatures.size() >= 100:
                break
        test.assert_true(signatures.size() >= 100)
    )

    test.case("forced failure remains deterministic fallback", func() -> void:
        var generator: Variant = RailGeneratorScript.new()
        var first: Variant = generator.generate(7, 32, true)
        var second: Variant = generator.generate(999, 32, true)
        test.assert_true(first.used_fallback)
        test.assert_equal(first.signature(), second.signature())
    )
```

- [ ] **Step 2: Run the test and verify the current generator fails the 100-layout assertion**

Expected: the current four binary offsets produce no more than about 16 graph signatures.

- [ ] **Step 3: Replace binary offsets with seeded distinct interior selections**

Replace `_build_candidate()` and add the helpers below while retaining `_build_network()` and `_is_valid()`.

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
    for index: int in range(mini(count, values.size())):
        selected.append(values[index])
    selected.sort()
    return selected

func _mixed_seed(seed: int, attempt: int, salt: int) -> int:
    var value := int(seed) * 1103515245 + int(attempt + 1) * 12345 + salt
    return absi(value ^ (value >> 16))
```

- [ ] **Step 4: Run structural, determinism, and diversity regression**

Expected:

- all existing RailGraph contracts pass,
- same seed remains deterministic,
- forced fallback remains deterministic,
- scan `1..2000` finds at least 100 distinct non-fallback signatures.

- [ ] **Step 5: Commit**

```bash
git add game/rail/rail_generator.gd tests/rail/test_rail_generator_diversity.gd tests/run_tests.gd
git commit -m "feat: expand deterministic rail layout diversity"
```

---

### Task 4: Offline MapBuildPipeline and catalog manifest generation

**Files:**
- Create: `game/map/map_build_pipeline.gd`
- Create: `tools/build_map_catalog.gd`
- Create: `tests/map/test_map_build_pipeline.gd`
- Create: `data/maps/map_catalog.json`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Consumes: `RailGenerator.generate()`, `StationPlacer.place()`, `CargoSpawner.configure()/ensure_all_minimum()/signature()`
- Produces: `MapBuildPipeline.build(seed: int, map_id: StringName, revision: int) -> Dictionary`
- Produces: deterministic `layout_signature` and `content_signature`
- Produces: a JSON manifest with unique validated entries

- [ ] **Step 1: Write failing pipeline tests**

```gdscript
# tests/map/test_map_build_pipeline.gd
extends RefCounted

const MapBuildPipelineScript := preload("res://game/map/map_build_pipeline.gd")

func run(test: Variant) -> void:
    test.case("same seed creates identical signatures", func() -> void:
        var pipeline: Variant = MapBuildPipelineScript.new()
        var first: Dictionary = pipeline.build(101, &"map.sx.0001", 1)
        var second: Dictionary = pipeline.build(101, &"map.sx.0001", 1)
        test.assert_true(first.success)
        test.assert_equal(first.definition.layout_signature, second.definition.layout_signature)
        test.assert_equal(first.definition.content_signature, second.definition.content_signature)
    )

    test.case("fallback candidate is rejected", func() -> void:
        var pipeline: Variant = MapBuildPipelineScript.new()
        var result: Dictionary = pipeline.build(101, &"map.sx.fallback", 1, true)
        test.assert_false(result.success)
        test.assert_equal(result.status, &"FALLBACK_REJECTED")
    )
```

- [ ] **Step 2: Implement SHA-256 helper and build pipeline**

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
    var spawn_status: StringName = spawner.ensure_all_minimum()
    if spawn_status == &"SPAWN_DEFERRED":
        return {"success": false, "status": &"INITIAL_PICKUP_FAILED"}

    var switch_defaults := _switch_default_signature(graph)
    var layout_source := "%s\n%s\n%s\n%d,%d\n%d,%d\n%s" % [
        GENERATOR_VERSION,
        graph.signature(),
        station_result.signature,
        TRAIN_START.x,
        TRAIN_START.y,
        INITIAL_DIRECTION.x,
        INITIAL_DIRECTION.y,
        switch_defaults,
    ]
    var layout_signature := _sha256(layout_source)
    var content_signature := _sha256("%s\n%s\n%s" % [
        layout_signature,
        spawner.signature(),
        RULESET_VERSION,
    ])

    var definition: Variant = MapDefinitionScript.create({
        "map_id": map_id,
        "map_revision": revision,
        "map_seed": seed,
        "generator_version": GENERATOR_VERSION,
        "ruleset_version": RULESET_VERSION,
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
        "initial_pickup_signature": spawner.signature(),
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

- [ ] **Step 3: Implement bounded offline catalog builder**

```gdscript
# tools/build_map_catalog.gd
extends SceneTree

const MapBuildPipelineScript := preload("res://game/map/map_build_pipeline.gd")
const MapCatalogScript := preload("res://game/map/map_catalog.gd")

const TARGET_COUNT := 100
const SEED_SCAN_LIMIT := 10000
const OUTPUT_PATH := "res://data/maps/map_catalog.json"

func _init() -> void:
    var accepted: Array = []
    var layouts: Dictionary = {}
    var pipeline: Variant = MapBuildPipelineScript.new()

    for seed: int in range(1, SEED_SCAN_LIMIT + 1):
        var map_id := StringName("map.sx.%04d" % [accepted.size() + 1])
        var result: Dictionary = pipeline.build(seed, map_id, 1)
        if not result.success:
            continue
        var definition: Variant = result.definition
        if layouts.has(definition.layout_signature):
            continue
        layouts[definition.layout_signature] = true
        accepted.append(definition.to_dictionary())
        if accepted.size() >= TARGET_COUNT:
            break

    if accepted.size() < TARGET_COUNT:
        push_error("catalog build found %d/%d unique maps" % [accepted.size(), TARGET_COUNT])
        quit(1)
        return

    var catalog: Variant = MapCatalogScript.new()
    var validation: Dictionary = catalog.load_entries(accepted)
    if not validation.success:
        push_error("catalog validation failed: %s" % [validation.errors])
        quit(1)
        return

    var payload := {
        "schema_version": 1,
        "generator_version": "railgen_v2",
        "ruleset_version": "standard_v1",
        "unique_layout_count": catalog.unique_layout_count(),
        "maps": accepted,
    }
    var file := FileAccess.open(OUTPUT_PATH, FileAccess.WRITE)
    if file == null:
        push_error("cannot write %s" % OUTPUT_PATH)
        quit(1)
        return
    file.store_string(JSON.stringify(payload, "  "))
    file.close()
    print("MAP_CATALOG_BUILT count=%d path=%s" % [accepted.size(), OUTPUT_PATH])
    quit(0)
```

- [ ] **Step 4: Generate a three-map Vertical Slice fixture first**

Temporarily run a test-only target count of three or call the pipeline directly in the test. Commit only three reviewed entries for the Vertical Slice. Do not claim the production 100-map milestone yet.

Run:

```bash
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tools/build_map_catalog.gd
```

Expected for production-target mode: `MAP_CATALOG_BUILT count=100` only after the diversity task passes.

- [ ] **Step 5: Validate generated JSON through MapCatalog in a test**

The test must parse `data/maps/map_catalog.json`, assert schema version `1`, assert no duplicate layout signatures, and assert every entry resolves as runtime eligible.

- [ ] **Step 6: Commit**

```bash
git add game/map/map_build_pipeline.gd tools/build_map_catalog.gd data/maps/map_catalog.json tests/map/test_map_build_pipeline.gd tests/run_tests.gd
git commit -m "feat: add validated offline map catalog pipeline"
```

---

### Task 5: Fresh RunSession reconstruction and same-map restart

**Files:**
- Create: `game/run/run_session.gd`
- Create: `game/run/run_session_factory.gd`
- Create or modify: `game/run/run_controller.gd`
- Create: `tests/run/test_same_seed_restart.gd`
- Create: `tests/integration/test_restart_determinism.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Consumes: `MapCatalog.resolve()`, `MapDefinition`, `RunIdentity`, `RunIdFactory`
- Produces: `RunSessionFactory.create(identity: RunIdentity) -> RunSession`
- Produces: `RunController.start_map(map_id: StringName, revision: int) -> Dictionary`
- Produces: `RunController.restart_same_map() -> Dictionary`
- Produces: `signal run_started(identity: RunIdentity)`

- [ ] **Step 1: Write failing reset and identity tests**

```gdscript
# tests/run/test_same_seed_restart.gd
extends RefCounted

func run(test: Variant) -> void:
    test.case("restart preserves map definition and resets mutable state", func() -> void:
        var fixture: Dictionary = TestRunFixture.create_catalog_and_controller(["run-a", "run-b"])
        var controller: Variant = fixture.controller
        test.assert_true(controller.start_map(&"map.sx.0001", 1).success)

        controller.session.run_state.fuel = 4.0
        controller.session.run_state.score = 900
        controller.session.cargo_stack.push(&"RED_STAR")
        controller.session.difficulty_state.step = 4
        controller.session.spawner.collect(controller.session.spawner.pickup_cells()[0], 1.0)

        var previous_identity: Variant = controller.identity
        var restart: Dictionary = controller.restart_same_map()

        test.assert_true(restart.success)
        test.assert_equal(controller.identity.map_definition.identity_key(), previous_identity.map_definition.identity_key())
        test.assert_equal(controller.identity.map_definition.map_seed, previous_identity.map_definition.map_seed)
        test.assert_not_equal(controller.identity.run_id, previous_identity.run_id)
        test.assert_equal(controller.identity.retry_index, 1)
        test.assert_equal(controller.session.run_state.score, 0)
        test.assert_equal(controller.session.cargo_stack.size(), 0)
        test.assert_equal(controller.session.difficulty_state.step, 0)
        test.assert_true(controller.session.spawner.pending_respawns().is_empty())
    )
```

- [ ] **Step 2: Write deterministic reconstruction integration test**

```gdscript
# tests/integration/test_restart_determinism.gd
extends RefCounted

func run(test: Variant) -> void:
    test.case("same map restart reproduces immutable signatures", func() -> void:
        var fixture: Dictionary = TestRunFixture.create_catalog_and_controller(["run-a", "run-b"])
        var controller: Variant = fixture.controller
        controller.start_map(&"map.sx.0001", 1)
        var first: Dictionary = controller.session.immutable_signatures()
        controller.restart_same_map()
        var second: Dictionary = controller.session.immutable_signatures()
        test.assert_equal(second, first)
    )

    test.case("stale generation event cannot mutate restarted session", func() -> void:
        var fixture: Dictionary = TestRunFixture.create_catalog_and_controller(["run-a", "run-b"])
        var controller: Variant = fixture.controller
        controller.start_map(&"map.sx.0001", 1)
        var stale_generation: int = controller.session_generation
        controller.restart_same_map()
        controller.consume_difficulty_event(stale_generation, {"step": 99})
        test.assert_equal(controller.session.difficulty_state.step, 0)
    )
```

- [ ] **Step 3: Implement RunSession as a one-attempt ownership boundary**

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
var difficulty_state: Variant
var train_controller: Variant
var delivery_loop: Variant

func immutable_signatures() -> Dictionary:
    return {
        "map_identity": identity.map_definition.identity_key(),
        "graph": graph.signature(),
        "stations": _station_signature(),
        "initial_pickups": spawner.signature(),
    }

func _station_signature() -> String:
    var parts: Array[String] = []
    for station: Variant in stations:
        parts.append("%s@%d,%d" % [station.cargo_type, station.cell.x, station.cell.y])
    parts.sort()
    return "|".join(parts)
```

- [ ] **Step 4: Implement RunSessionFactory**

The factory must allocate new graph, station, spawner, CargoStack, RunState, difficulty state, TrainController, and DeliveryLoop instances for every call. No mutable instance may be cached by map ID.

```gdscript
# game/run/run_session_factory.gd
class_name RunSessionFactory
extends RefCounted

const RailGeneratorScript := preload("res://game/rail/rail_generator.gd")
const StationPlacerScript := preload("res://game/station/station_placer.gd")
const CargoSpawnerScript := preload("res://game/cargo/cargo_spawner.gd")
const CargoStackScript := preload("res://game/cargo/cargo_stack.gd")
const RunSessionScript := preload("res://game/run/run_session.gd")

func create(identity: Variant) -> Variant:
    var definition: Variant = identity.map_definition
    var graph: Variant = RailGeneratorScript.new().generate(definition.map_seed)
    assert(not graph.used_fallback, "validated map cannot rebuild as fallback")
    assert(graph.signature() == definition.layout_graph_signature or definition.layout_graph_signature.is_empty(), "graph signature drift")

    var station_result: Dictionary = StationPlacerScript.new().place(graph, Vector2i(0, 0), definition.map_seed)
    assert(station_result.success, "validated station placement must rebuild")

    var spawner: Variant = CargoSpawnerScript.new()
    spawner.configure(graph, station_result.stations, definition.map_seed)
    assert(spawner.ensure_all_minimum() != &"SPAWN_DEFERRED", "validated initial pickups must rebuild")

    var session: Variant = RunSessionScript.new()
    session.identity = identity
    session.graph = graph
    session.stations = station_result.stations
    session.spawner = spawner
    session.cargo_stack = CargoStackScript.new(8)
    session.run_state = RunState.new()
    session.difficulty_state = DifficultyState.new()
    session.train_controller = TrainController.new()
    session.delivery_loop = DeliveryLoop.new()
    return session
```

Before implementation, add explicit `graph_signature`, `station_signature`, and `initial_pickup_signature` fields to `MapDefinition` rather than relying on the illustrative `layout_graph_signature` name above. Keep the exact final field names consistent across the spec, factory, builder, JSON, and tests:

```text
graph_signature
station_signature
initial_pickup_signature
layout_signature
content_signature
```

- [ ] **Step 5: Implement RunController restart policy**

```gdscript
# relevant game/run/run_controller.gd excerpt
var catalog: Variant
var session_factory: Variant
var run_id_factory: Variant
var identity: Variant
var session: Variant
var session_generation: int = 0

func start_map(map_id: StringName, revision: int) -> Dictionary:
    var definition: Variant = catalog.resolve(map_id, revision)
    if definition == null:
        return {"success": false, "status": &"MAP_NOT_FOUND"}
    return _start_attempt(definition, 0, "")

func restart_same_map() -> Dictionary:
    if identity == null:
        return {"success": false, "status": &"NO_PREVIOUS_RUN"}
    return _start_attempt(
        identity.map_definition,
        identity.retry_index + 1,
        identity.run_id
    )

func _start_attempt(definition: Variant, retry_index: int, previous_run_id: String) -> Dictionary:
    session_generation += 1
    var next_identity: Variant = RunIdentity.create(
        definition,
        run_id_factory.next_id(),
        retry_index,
        previous_run_id
    )
    var next_session: Variant = session_factory.create(next_identity)
    identity = next_identity
    session = next_session
    run_started.emit(identity)
    return {"success": true, "status": &"RUN_STARTED", "identity": identity}

func consume_difficulty_event(generation: int, event: Dictionary) -> void:
    if generation != session_generation:
        return
    session.difficulty_state.consume(event)
```

- [ ] **Step 6: Run all reset, determinism, warning-mode, Reduced Motion, record, and reward regressions**

Explicitly verify:

- map identity equal,
- run ID unequal,
- graph/station/initial pickup signatures equal,
- mutable states reset,
- previous pending spawn queue absent,
- previous warning callbacks ignored,
- reward event IDs are new,
- Profile records are read but not copied into RunState,
- identical inputs produce identical authoritative events.

- [ ] **Step 7: Commit**

```bash
git add game/run/run_session.gd game/run/run_session_factory.gd game/run/run_controller.gd tests/run/test_same_seed_restart.gd tests/integration/test_restart_determinism.gd tests/run_tests.gd
git commit -m "feat: restart runs on the same validated map"
```

---

### Task 6: Result-panel request boundary and telemetry lineage

**Files:**
- Modify: `game/ui/result_panel.gd`
- Create: `game/telemetry/run_start_event.gd`
- Modify: `game/telemetry/run_event_log.gd`
- Create: `tests/telemetry/test_run_start_event.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Result panel produces: `signal restart_requested()` with no seed argument
- Controller consumes: `restart_requested()` and calls `restart_same_map()`
- Telemetry produces a bounded dictionary derived from authoritative RunIdentity

- [ ] **Step 1: Write failing telemetry test**

```gdscript
# tests/telemetry/test_run_start_event.gd
extends RefCounted

const RunStartEventScript := preload("res://game/telemetry/run_start_event.gd")

func run(test: Variant) -> void:
    test.case("run start telemetry records retry lineage without player seed authority", func() -> void:
        var identity: Variant = TestRunFixture.retry_identity()
        var payload: Dictionary = RunStartEventScript.from_identity(identity, false)
        test.assert_equal(payload.event_name, &"run_started")
        test.assert_equal(payload.map_id, &"map.sx.0001")
        test.assert_equal(payload.map_revision, 1)
        test.assert_equal(payload.retry_index, 1)
        test.assert_equal(payload.restarted_from_run_id, "run-a")
        test.assert_false(payload.has("ui_selected_seed"))
    )
```

- [ ] **Step 2: Implement telemetry projection**

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

- [ ] **Step 3: Make result UI semantic and non-authoritative**

```gdscript
# game/ui/result_panel.gd excerpt
signal restart_requested

func _on_restart_pressed() -> void:
    restart_requested.emit()
```

Forbidden UI APIs:

```text
set_seed(...)
choose_random_seed(...)
advance_map(...)
reuse_run_id(...)
commit_reward(...)
```

The result panel receives the committed result and displays the existing `RESTART` primary action. It never receives an editable raw seed.

- [ ] **Step 4: Verify transaction identity separation**

Add integration assertions that:

```text
first.run_id != retry.run_id
first.reward_event_id != retry.reward_event_id
first.map_definition.identity_key == retry.map_definition.identity_key
```

- [ ] **Step 5: Run full regression and commit**

```bash
git add game/ui/result_panel.gd game/telemetry/run_start_event.gd game/telemetry/run_event_log.gd tests/telemetry/test_run_start_event.gd tests/run_tests.gd
git commit -m "feat: record same-map retry lineage"
```

---

### Task 7: Catalog-scale audit, product evidence, and canonical documentation

**Files:**
- Create: `tools/audit_map_catalog.gd`
- Create: `기획서/50_제작_검증/MAP_CATALOG_VALIDATION.md`
- Modify after implementation approval: `기획서/10_경험/CORE_GAMEPLAY.md`
- Modify after implementation approval: `기획서/20_시스템_콘텐츠/CORE_SYSTEMS.md`
- Modify after implementation approval: project Decision Registry, Roadmap, Gate, Issue #6/#7, and correct Google Sheet

**Interfaces:**
- Audit consumes `data/maps/map_catalog.json`
- Audit emits machine-readable totals and exits nonzero on invalidity

- [ ] **Step 1: Implement catalog audit command**

The command must assert:

```text
schema_version == 1
entry_count >= requested target
unique map identity count == entry count
unique layout signature count == entry count
unique content signature count == entry count
fallback count == 0
invalid status count == 0
rebuild signature mismatch count == 0
```

For the Vertical Slice, call it with target `3`. For the production map milestone, call it with target `100`.

- [ ] **Step 2: Add deterministic rebuild audit**

For every manifest entry:

1. rebuild through `MapBuildPipeline`,
2. compare graph, station, initial-pickup, layout, and content signatures,
3. fail on any mismatch,
4. record generator and ruleset version distribution.

- [ ] **Step 3: Add simulation distribution evidence before production promotion**

For each candidate map, run bounded automated probes using the same baseline bot/input policy and collect:

```text
reachable station count
switch count and state distribution
cycle rank
mean route distance between same-type stations
initial pickup reachability
spawn-deferred count
no-input survival result
first-delivery time distribution
fallback or runtime error count
```

Do not set final difficulty thresholds in this plan. Store raw evidence and mark tuning values `TEST_VALUE` until human review.

- [ ] **Step 4: Run required commands**

```bash
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tests/run_tests.gd
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tools/audit_map_catalog.gd -- --target-count=3
```

Production milestone only:

```bash
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tools/build_map_catalog.gd
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tools/audit_map_catalog.gd -- --target-count=100
```

- [ ] **Step 5: Capture runtime evidence without overstating proof**

Capture at least:

- first attempt and same-map retry side by side,
- identical map layout and initial content,
- reset fuel/score/stack/switch/warning states,
- new run ID and retry index in debug evidence,
- three distinct Vertical Slice catalog maps,
- no claim of 100 maps until the production audit passes.

- [ ] **Step 6: Run adversarial review**

Attack:

- stale service instances,
- reward ID reuse,
- fallback entries,
- duplicate signatures,
- same seed after generator-version change,
- corrupted catalog row,
- missing revision,
- warning/cosmetic/Reduced Motion determinism drift,
- repeated restart memory growth,
- catalog load time and manifest size,
- easy-map record dominance as an unresolved `SX-DEC-024+` policy question.

- [ ] **Step 7: Commit evidence and synchronize only after proof exists**

```bash
git add tools/audit_map_catalog.gd 기획서/50_제작_검증/MAP_CATALOG_VALIDATION.md 기획서/10_경험/CORE_GAMEPLAY.md 기획서/20_시스템_콘텐츠/CORE_SYSTEMS.md
git commit -m "docs: validate same-map restart and map catalog"
```

Then follow `SX-OPS-001`: exact-head CI, adversarial PR audit, canonical merge, Decision Registry update, correct Sheet 12-tab write/readback, and Sync Closure.

---

## Final Verification Matrix

| Requirement | Automated evidence | Runtime evidence | Human evidence |
|---|---|---|---|
| Restart same map ID/revision | unit + integration | debug capture | optional |
| New run ID per retry | unit + transaction test | event log | not required |
| Complete mutable reset | integration assertions | side-by-side retry | 5+ playtest later |
| Same input deterministic events | replay/hash test | soak | not required |
| Warning/motion/cosmetic parity | hash regression | visual capture | accessibility review |
| Fallback excluded | catalog unit/audit | not required | not required |
| Duplicate layout rejected | catalog unit/audit | not required | not required |
| Three-map Vertical Slice catalog | manifest audit | three-map capture | readability review |
| 100+ production maps | target-100 audit | catalog/load performance | distribution/playtest review |

## Plan Self-Review Checklist

- Every mutable service is created by `RunSessionFactory`; none is reused across retries.
- `MapDefinition` and `RunIdentity` names are consistent across tasks.
- Catalog uniqueness uses `layout_signature`, not seed count.
- Fallback maps are rejected from standard catalog use.
- Generator expansion preserves the public `generate()` signature and bounded fallback.
- Result UI emits only a semantic restart request.
- Reward and telemetry identity use `run_id`, never `map_seed`.
- Three-map Vertical Slice proof is separated from the 100-map production target.
- Different-map selection and cross-map record fairness are not silently decided.
- No product implementation begins before `GMB-001 10/10`, canonical synchronization, and `READY_FOR_BUILD`.
