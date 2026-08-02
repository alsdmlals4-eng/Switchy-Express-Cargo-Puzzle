# Automatic Map Discovery and Reselection Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build an idempotent map-selection domain that assigns every undiscovered eligible map before replaying maps, preserves same-map restart, and lets players directly reselect discovered maps through a compact browser.

**Architecture:** `MapSelectionService` owns automatic and manual selection policy over an immutable `MapCatalog` snapshot. `MapDiscoveryState` owns Profile-persisted discovery, favorites, recent history, and deterministic shuffle bags. Selection produces an immutable receipt; only a successful `FULL_MAP_READY` run-start commit mutates Profile state. Result and browser UI emit semantic requests and never supply seeds or map revisions.

**Tech Stack:** Godot 4.7.1-stable, GDScript, existing versioned Profile store, existing custom headless test runner, Godot scenes/Controls, GitHub Actions Godot Tests.

## Global Constraints

- Decision: `SX-DEC-024`; Evidence: `EV-USER-013`; `GMB-001` slot `8/10`.
- Design: `docs/superpowers/specs/2026-08-02-automatic-map-discovery-and-reselection-design.md`.
- `RESTART_SAME_MAP` preserves the exact `MapDefinition` under `SX-DEC-023` and never consumes automatic bags.
- `AUTO_NEW_RUN` chooses every eligible undiscovered stable `map_id` before any replayed map.
- `SELECT_DISCOVERED_MAP` accepts discovered, currently eligible stable IDs only.
- Discovery commits after reconstruction, `FULL_MAP_READY`, and authoritative run start; selection alone does not discover or consume.
- Assisted first runs may discover maps but remain excluded from standard records, goals, and variable rewards.
- UI never supplies or displays raw seed, generator version, signatures, or arbitrary revision.
- Runtime never generates a seed when catalog selection or reconstruction fails.
- Automatic failure may try another catalog entry within a bounded list; manual and restart failure never silently substitute another map.
- Recent exclusion count `3`, browser density, telemetry retention, and performance budgets are `TEST_VALUE`.
- All Profile and selection commits are atomic and idempotent.
- Do not execute product implementation before `GMB-001 10/10`, canonical synchronization, and `READY_FOR_BUILD`.

## Prerequisites

Execute approved prerequisite plans first when their files do not yet exist:

```text
docs/superpowers/plans/2026-08-02-same-seed-restart-curated-map-catalog.md
docs/superpowers/plans/2026-08-02-records-cosmetic-only-progression.md
docs/superpowers/plans/2026-08-02-preparation-zoom-full-map-camera.md
```

Required or planned dependency files:

```text
game/map/map_definition.gd
game/map/map_catalog.gd
game/run/run_identity.gd
game/run/run_session_factory.gd
game/run/run_controller.gd
game/profile/profile_schema.gd
game/profile/profile_store.gd
game/ui/result_panel.gd
game/telemetry/run_event_log.gd
tests/support/map_fixture.gd
tests/run_tests.gd
```

Do not create competing Profile, catalog, run-controller, or result-panel implementations.

## Planned File Map

Create:

```text
game/map/map_selection_request.gd
  Semantic request modes and request identity.

game/map/map_selection_receipt.gd
  Immutable catalog/map decision returned by selection.

game/map/map_discovery_state.gd
  Profile-backed discovered/favorite/play-count/recent/bag state and reconciliation.

game/map/map_shuffle_bag.gd
  Deterministic no-replacement ordering and recent-window exclusion.

game/map/map_selection_service.gd
  Automatic undiscovered-first, replay, and direct discovered selection policy.

game/map/map_browser_view_model.gd
  Discovered-only browser sections and seed-free card data.

game/ui/map_browser_panel.gd
  Control bindings, favorite actions, and semantic select events.

game/ui/map_browser_panel.tscn
  RECENT/FAVORITES/ALL DISCOVERED layout.

game/telemetry/map_selection_event.gd
  Bounded selection and discovery payload constructors.

tests/map/test_map_shuffle_bag.gd
tests/map/test_map_discovery_state.gd
tests/map/test_map_selection_service.gd
tests/map/test_map_selection_profile_commit.gd
tests/run/test_map_selection_run_integration.gd
tests/ui/test_map_browser_view_model.gd
tests/ui/test_map_browser_panel.gd
tests/telemetry/test_map_selection_event.gd
tests/integration/test_three_map_discovery_flow.gd
tests/integration/test_hundred_map_discovery_simulation.gd
```

Modify:

```text
game/map/map_catalog.gd
game/profile/profile_schema.gd
game/profile/profile_store.gd
game/run/run_controller.gd
game/ui/result_panel.gd
game/telemetry/run_event_log.gd
tests/run_tests.gd
```

---

### Task 1: Selection Request and Receipt Domain

**Files:**
- Create: `game/map/map_selection_request.gd`
- Create: `game/map/map_selection_receipt.gd`
- Create: `tests/map/test_map_selection_request.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- `MapSelectionRequest.restart(request_id: String, previous_identity: RunIdentity) -> MapSelectionRequest`
- `MapSelectionRequest.auto_new_run(request_id: String, created_from_run_id: String = "") -> MapSelectionRequest`
- `MapSelectionRequest.select_discovered(request_id: String, map_id: StringName) -> MapSelectionRequest`
- `MapSelectionRequest.validation_errors() -> Array[String]`
- `MapSelectionReceipt.create(data: Dictionary) -> MapSelectionReceipt`
- `MapSelectionReceipt.identity_key() -> String`

- [ ] **Step 1: Write failing request-mode tests**

```gdscript
# tests/map/test_map_selection_request.gd
extends RefCounted

const RequestScript := preload("res://game/map/map_selection_request.gd")

func run(test: Variant) -> void:
    test.case("auto request requires only request identity", func() -> void:
        var request: Variant = RequestScript.auto_new_run("select-a")
        test.assert_equal(request.mode, &"AUTO_NEW_RUN")
        test.assert_true(request.validation_errors().is_empty())
        test.assert_equal(request.requested_map_id, &"")
    )

    test.case("manual request requires stable map id", func() -> void:
        var request: Variant = RequestScript.select_discovered("select-b", &"")
        test.assert_true(request.validation_errors().has("requested_map_id is required"))
    )

    test.case("request cannot contain raw seed", func() -> void:
        var request: Variant = RequestScript.auto_new_run("select-c")
        test.assert_false("map_seed" in request)
    )
```

- [ ] **Step 2: Run the suite and verify missing-file failure**

```bash
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tests/run_tests.gd
```

Expected: preload failure for `map_selection_request.gd`.

- [ ] **Step 3: Implement exact semantic requests**

```gdscript
# game/map/map_selection_request.gd
class_name MapSelectionRequest
extends RefCounted

const MODES: Array[StringName] = [
    &"RESTART_SAME_MAP",
    &"AUTO_NEW_RUN",
    &"SELECT_DISCOVERED_MAP",
]

var selection_request_id: String
var mode: StringName
var requested_map_id: StringName
var created_from_run_id: String
var previous_run_identity: Variant

static func auto_new_run(request_id: String, previous_run_id: String = "") -> MapSelectionRequest:
    return _create(request_id, &"AUTO_NEW_RUN", &"", previous_run_id, null)

static func select_discovered(request_id: String, map_id: StringName) -> MapSelectionRequest:
    return _create(request_id, &"SELECT_DISCOVERED_MAP", map_id, "", null)

static func restart(request_id: String, previous_identity: Variant) -> MapSelectionRequest:
    return _create(request_id, &"RESTART_SAME_MAP", &"", previous_identity.run_id if previous_identity != null else "", previous_identity)

static func _create(request_id: String, mode_value: StringName, map_id: StringName, previous_run_id: String, previous_identity: Variant) -> MapSelectionRequest:
    var value := MapSelectionRequest.new()
    value.selection_request_id = request_id
    value.mode = mode_value
    value.requested_map_id = map_id
    value.created_from_run_id = previous_run_id
    value.previous_run_identity = previous_identity
    return value

func validation_errors() -> Array[String]:
    var errors: Array[String] = []
    if selection_request_id.is_empty(): errors.append("selection_request_id is required")
    if mode not in MODES: errors.append("unsupported selection mode")
    if mode == &"SELECT_DISCOVERED_MAP" and requested_map_id == &"":
        errors.append("requested_map_id is required")
    if mode == &"RESTART_SAME_MAP" and previous_run_identity == null:
        errors.append("previous_run_identity is required")
    return errors
```

- [ ] **Step 4: Implement immutable receipts**

```gdscript
# game/map/map_selection_receipt.gd
class_name MapSelectionReceipt
extends RefCounted

var receipt_id: String
var selection_request_id: String
var selection_mode: StringName
var catalog_revision: StringName
var map_id: StringName
var map_revision: int
var cycle_generation: int
var created_from_run_id: String

static func create(data: Dictionary) -> MapSelectionReceipt:
    var value := MapSelectionReceipt.new()
    value.receipt_id = str(data.get("receipt_id", ""))
    value.selection_request_id = str(data.get("selection_request_id", ""))
    value.selection_mode = StringName(data.get("selection_mode", &""))
    value.catalog_revision = StringName(data.get("catalog_revision", &""))
    value.map_id = StringName(data.get("map_id", &""))
    value.map_revision = int(data.get("map_revision", 0))
    value.cycle_generation = int(data.get("cycle_generation", 0))
    value.created_from_run_id = str(data.get("created_from_run_id", ""))
    assert(not value.receipt_id.is_empty(), "receipt_id required")
    assert(not value.selection_request_id.is_empty(), "selection_request_id required")
    assert(value.map_id != &"" and value.map_revision > 0, "eligible map identity required")
    return value

func identity_key() -> String:
    return "%s@%d" % [map_id, map_revision]
```

- [ ] **Step 5: Run the full suite and commit**

```bash
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tests/run_tests.gd
git add game/map/map_selection_request.gd game/map/map_selection_receipt.gd tests/map/test_map_selection_request.gd tests/run_tests.gd
git commit -m "feat: add semantic map selection requests"
```

---

### Task 2: Deterministic Shuffle Bag

**Files:**
- Create: `game/map/map_shuffle_bag.gd`
- Create: `tests/map/test_map_shuffle_bag.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- `MapShuffleBag.build(ids: Array[StringName], seed: int, generation: int) -> MapShuffleBag`
- `MapShuffleBag.reconcile(eligible_ids: Array[StringName]) -> void`
- `MapShuffleBag.peek_next(excluded_ids: Array[StringName]) -> StringName`
- `MapShuffleBag.consume(map_id: StringName) -> void`
- `MapShuffleBag.remaining_ids() -> Array[StringName]`

- [ ] **Step 1: Write no-replacement and reconciliation tests**

```gdscript
# tests/map/test_map_shuffle_bag.gd
extends RefCounted

const BagScript := preload("res://game/map/map_shuffle_bag.gd")

func run(test: Variant) -> void:
    test.case("bag returns every id once before refill", func() -> void:
        var bag: Variant = BagScript.build([&"a", &"b", &"c"], 12345, 0)
        var seen: Array[StringName] = []
        for _i in range(3):
            var next_id: StringName = bag.peek_next([])
            seen.append(next_id)
            bag.consume(next_id)
        seen.sort()
        test.assert_equal(seen, [&"a", &"b", &"c"])
        test.assert_equal(bag.peek_next([]), &"")
    )

    test.case("excluded recent ids are skipped without removal", func() -> void:
        var bag: Variant = BagScript.build([&"a", &"b", &"c", &"d"], 7, 1)
        var next_id: StringName = bag.peek_next([&"a", &"b", &"c"])
        test.assert_equal(next_id, &"d")
        test.assert_equal(bag.remaining_ids().size(), 4)
    )

    test.case("reconcile removes retired ids and adds new ids", func() -> void:
        var bag: Variant = BagScript.build([&"a", &"b"], 9, 0)
        bag.reconcile([&"b", &"c"])
        var remaining: Array[StringName] = bag.remaining_ids()
        remaining.sort()
        test.assert_equal(remaining, [&"b", &"c"])
    )
```

- [ ] **Step 2: Run and verify failure**

```bash
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tests/run_tests.gd
```

Expected: preload failure for `map_shuffle_bag.gd`.

- [ ] **Step 3: Implement deterministic no-replacement ordering**

```gdscript
# game/map/map_shuffle_bag.gd
class_name MapShuffleBag
extends RefCounted

var _ids: Array[StringName] = []
var _seed: int
var _generation: int

static func build(ids: Array[StringName], seed: int, generation: int) -> MapShuffleBag:
    var value := MapShuffleBag.new()
    value._seed = seed
    value._generation = generation
    value._ids = ids.duplicate()
    value._ids.sort()
    var rng := RandomNumberGenerator.new()
    rng.seed = hash([seed, generation, value._ids])
    for index in range(value._ids.size() - 1, 0, -1):
        var swap_index: int = rng.randi_range(0, index)
        var temporary: StringName = value._ids[index]
        value._ids[index] = value._ids[swap_index]
        value._ids[swap_index] = temporary
    return value

func reconcile(eligible_ids: Array[StringName]) -> void:
    var eligible_lookup: Dictionary = {}
    for map_id in eligible_ids: eligible_lookup[map_id] = true
    _ids = _ids.filter(func(map_id: StringName) -> bool: return eligible_lookup.has(map_id))
    var existing: Dictionary = {}
    for map_id in _ids: existing[map_id] = true
    var additions: Array[StringName] = []
    for map_id in eligible_ids:
        if not existing.has(map_id): additions.append(map_id)
    additions.sort()
    _ids.append_array(additions)

func peek_next(excluded_ids: Array[StringName]) -> StringName:
    var excluded: Dictionary = {}
    for map_id in excluded_ids: excluded[map_id] = true
    for map_id in _ids:
        if not excluded.has(map_id): return map_id
    return &""

func consume(map_id: StringName) -> void:
    _ids.erase(map_id)

func remaining_ids() -> Array[StringName]:
    return _ids.duplicate()
```

- [ ] **Step 4: Run and commit**

```bash
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tests/run_tests.gd
git add game/map/map_shuffle_bag.gd tests/map/test_map_shuffle_bag.gd tests/run_tests.gd
git commit -m "feat: add deterministic map shuffle bags"
```

---

### Task 3: Profile-Backed Discovery State

**Files:**
- Create: `game/map/map_discovery_state.gd`
- Create: `tests/map/test_map_discovery_state.gd`
- Modify: `game/profile/profile_schema.gd`
- Modify: `game/profile/profile_store.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- `MapDiscoveryState.from_profile(data: Dictionary) -> MapDiscoveryState`
- `MapDiscoveryState.reconcile(eligible_ids: Array[StringName], catalog_revision: StringName) -> void`
- `MapDiscoveryState.is_discovered(map_id: StringName) -> bool`
- `MapDiscoveryState.mark_started(receipt: MapSelectionReceipt) -> Dictionary`
- `MapDiscoveryState.set_favorite(map_id: StringName, enabled: bool) -> Dictionary`
- `MapDiscoveryState.to_profile_dictionary() -> Dictionary`

- [ ] **Step 1: Write migration, discovery, and idempotency tests**

```gdscript
# tests/map/test_map_discovery_state.gd
extends RefCounted

const StateScript := preload("res://game/map/map_discovery_state.gd")
const ReceiptScript := preload("res://game/map/map_selection_receipt.gd")

func _receipt() -> Variant:
    return ReceiptScript.create({
        "receipt_id": "receipt-a",
        "selection_request_id": "request-a",
        "selection_mode": &"AUTO_NEW_RUN",
        "catalog_revision": &"catalog-v1",
        "map_id": &"map.sx.0001",
        "map_revision": 1,
        "cycle_generation": 0,
    })

func run(test: Variant) -> void:
    test.case("missing profile fields migrate to empty safe state", func() -> void:
        var state: Variant = StateScript.from_profile({})
        test.assert_false(state.is_discovered(&"map.sx.0001"))
        test.assert_equal(state.recent_map_ids, [])
    )

    test.case("run start discovers and increments once", func() -> void:
        var state: Variant = StateScript.from_profile({})
        var first: Dictionary = state.mark_started(_receipt())
        var duplicate: Dictionary = state.mark_started(_receipt())
        test.assert_true(first.committed)
        test.assert_false(duplicate.committed)
        test.assert_true(state.is_discovered(&"map.sx.0001"))
        test.assert_equal(state.map_play_count_by_id[&"map.sx.0001"], 1)
    )

    test.case("favorite requires discovered map", func() -> void:
        var state: Variant = StateScript.from_profile({})
        test.assert_equal(state.set_favorite(&"map.sx.0001", true).error, &"NOT_DISCOVERED")
        state.mark_started(_receipt())
        test.assert_true(state.set_favorite(&"map.sx.0001", true).committed)
    )
```

- [ ] **Step 2: Add exact Profile fields and migration defaults**

```gdscript
# profile schema extension dictionary
{
    "discovered_map_ids": [],
    "favorite_map_ids": [],
    "map_play_count_by_id": {},
    "recent_map_ids": [],
    "auto_discovery_bag": [],
    "auto_replay_bag": [],
    "map_cycle_seed": 0,
    "map_cycle_generation": 0,
    "map_catalog_revision_seen": "",
    "processed_selection_request_ids": [],
    "committed_selection_receipt_ids": [],
}
```

Migration requirements:

```gdscript
profile.discovered_map_ids = _deduplicate_string_names(profile.get("discovered_map_ids", []))
profile.favorite_map_ids = _deduplicate_string_names(profile.get("favorite_map_ids", []))
profile.recent_map_ids = _deduplicate_string_names(profile.get("recent_map_ids", [])).slice(0, 32)
profile.processed_selection_request_ids = _deduplicate_strings(profile.get("processed_selection_request_ids", [])).slice(-128)
profile.committed_selection_receipt_ids = _deduplicate_strings(profile.get("committed_selection_receipt_ids", [])).slice(-128)
```

- [ ] **Step 3: Implement discovery state**

```gdscript
# game/map/map_discovery_state.gd
class_name MapDiscoveryState
extends RefCounted

const RECENT_LIMIT := 32
const JOURNAL_LIMIT := 128

var discovered_map_ids: Array[StringName] = []
var favorite_map_ids: Array[StringName] = []
var map_play_count_by_id: Dictionary = {}
var recent_map_ids: Array[StringName] = []
var auto_discovery_bag: Array[StringName] = []
var auto_replay_bag: Array[StringName] = []
var map_cycle_seed: int
var map_cycle_generation: int
var map_catalog_revision_seen: StringName
var processed_selection_request_ids: Array[String] = []
var committed_selection_receipt_ids: Array[String] = []

static func from_profile(data: Dictionary) -> MapDiscoveryState:
    var state := MapDiscoveryState.new()
    state.discovered_map_ids = _names(data.get("discovered_map_ids", []))
    state.favorite_map_ids = _names(data.get("favorite_map_ids", []))
    state.map_play_count_by_id = data.get("map_play_count_by_id", {}).duplicate(true)
    state.recent_map_ids = _names(data.get("recent_map_ids", [])).slice(0, RECENT_LIMIT)
    state.auto_discovery_bag = _names(data.get("auto_discovery_bag", []))
    state.auto_replay_bag = _names(data.get("auto_replay_bag", []))
    state.map_cycle_seed = int(data.get("map_cycle_seed", 0))
    state.map_cycle_generation = maxi(0, int(data.get("map_cycle_generation", 0)))
    state.map_catalog_revision_seen = StringName(data.get("map_catalog_revision_seen", &""))
    state.processed_selection_request_ids = _strings(data.get("processed_selection_request_ids", [])).slice(-JOURNAL_LIMIT)
    state.committed_selection_receipt_ids = _strings(data.get("committed_selection_receipt_ids", [])).slice(-JOURNAL_LIMIT)
    return state

static func _names(values: Array) -> Array[StringName]:
    var output: Array[StringName] = []
    for value in values:
        var map_id := StringName(value)
        if map_id != &"" and not output.has(map_id): output.append(map_id)
    return output

static func _strings(values: Array) -> Array[String]:
    var output: Array[String] = []
    for value in values:
        var text := str(value)
        if not text.is_empty() and not output.has(text): output.append(text)
    return output

func is_discovered(map_id: StringName) -> bool:
    return discovered_map_ids.has(map_id)

func mark_started(receipt: Variant) -> Dictionary:
    if committed_selection_receipt_ids.has(receipt.receipt_id):
        return {"committed": false, "duplicate": true}
    var newly_discovered := not discovered_map_ids.has(receipt.map_id)
    if newly_discovered: discovered_map_ids.append(receipt.map_id)
    map_play_count_by_id[receipt.map_id] = int(map_play_count_by_id.get(receipt.map_id, 0)) + 1
    recent_map_ids.erase(receipt.map_id)
    recent_map_ids.push_front(receipt.map_id)
    recent_map_ids = recent_map_ids.slice(0, RECENT_LIMIT)
    committed_selection_receipt_ids.append(receipt.receipt_id)
    committed_selection_receipt_ids = committed_selection_receipt_ids.slice(-JOURNAL_LIMIT)
    return {"committed": true, "newly_discovered": newly_discovered, "play_count": map_play_count_by_id[receipt.map_id]}

func set_favorite(map_id: StringName, enabled: bool) -> Dictionary:
    if not is_discovered(map_id): return {"committed": false, "error": &"NOT_DISCOVERED"}
    favorite_map_ids.erase(map_id)
    if enabled: favorite_map_ids.append(map_id)
    return {"committed": true}
```

- [ ] **Step 4: Make ProfileStore commit state atomically**

Add one operation that writes the entire discovery dictionary and the receipt journal in the same temporary-file, fsync, rename sequence already used by ProfileStore. Never write play count, discovery, and bag consumption in separate saves.

- [ ] **Step 5: Run migration and full tests, then commit**

```bash
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tests/run_tests.gd
git add game/map/map_discovery_state.gd game/profile/profile_schema.gd game/profile/profile_store.gd tests/map/test_map_discovery_state.gd tests/run_tests.gd
git commit -m "feat: persist map discovery and favorites"
```

---

### Task 4: MapSelectionService

**Files:**
- Create: `game/map/map_selection_service.gd`
- Create: `tests/map/test_map_selection_service.gd`
- Modify: `game/map/map_catalog.gd`
- Modify: `tests/support/map_fixture.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- `MapCatalog.catalog_revision() -> StringName`
- `MapCatalog.latest_eligible_by_id(ruleset_version: StringName) -> Dictionary`
- `MapSelectionService.resolve(request: MapSelectionRequest, state: MapDiscoveryState) -> Dictionary`
- Result success: `{success: true, receipt: MapSelectionReceipt, definition: MapDefinition}`
- Result failure: `{success: false, reason: StringName, rejected_map_ids: Array[StringName]}`

- [ ] **Step 1: Write automatic, replay, and manual tests**

```gdscript
# tests/map/test_map_selection_service.gd
extends RefCounted

const RequestScript := preload("res://game/map/map_selection_request.gd")
const StateScript := preload("res://game/map/map_discovery_state.gd")
const ServiceScript := preload("res://game/map/map_selection_service.gd")
const Fixture := preload("res://tests/support/map_fixture.gd")

func run(test: Variant) -> void:
    test.case("automatic selection uses every undiscovered map before replay", func() -> void:
        var service: Variant = ServiceScript.new(Fixture.catalog_with_ids([&"a", &"b", &"c"]), &"standard_v1", 3)
        var state: Variant = StateScript.from_profile({"map_cycle_seed": 11})
        var selected: Array[StringName] = []
        for index in range(3):
            var result: Dictionary = service.resolve(RequestScript.auto_new_run("request-%d" % index), state)
            selected.append(result.receipt.map_id)
            state.mark_started(result.receipt)
            state.consume_auto_receipt(result.receipt)
        selected.sort()
        test.assert_equal(selected, [&"a", &"b", &"c"])
    )

    test.case("restart bypasses automatic bags", func() -> void:
        var context: Dictionary = Fixture.previous_run_identity(&"b")
        var service: Variant = ServiceScript.new(context.catalog, &"standard_v1", 3)
        var state: Variant = StateScript.from_profile({"auto_discovery_bag": [&"a", &"c"]})
        var before: Array[StringName] = state.auto_discovery_bag.duplicate()
        var result: Dictionary = service.resolve(RequestScript.restart("restart-a", context.identity), state)
        test.assert_equal(result.receipt.map_id, &"b")
        test.assert_equal(state.auto_discovery_bag, before)
    )

    test.case("manual selection rejects undiscovered map", func() -> void:
        var service: Variant = ServiceScript.new(Fixture.catalog_with_ids([&"a"]), &"standard_v1", 3)
        var result: Dictionary = service.resolve(RequestScript.select_discovered("manual-a", &"a"), StateScript.from_profile({}))
        test.assert_false(result.success)
        test.assert_equal(result.reason, &"MAP_NOT_DISCOVERED")
    )

    test.case("same request returns same receipt", func() -> void:
        var service: Variant = ServiceScript.new(Fixture.catalog_with_ids([&"a", &"b"]), &"standard_v1", 3)
        var state: Variant = StateScript.from_profile({"map_cycle_seed": 17})
        var request: Variant = RequestScript.auto_new_run("same-request")
        var first: Dictionary = service.resolve(request, state)
        var second: Dictionary = service.resolve(request, state)
        test.assert_equal(second.receipt.receipt_id, first.receipt.receipt_id)
        test.assert_equal(second.receipt.map_id, first.receipt.map_id)
    )
```

- [ ] **Step 2: Add catalog lookup by stable ID**

```gdscript
func latest_eligible_by_id(ruleset_version: StringName) -> Dictionary:
    var output: Dictionary = {}
    for definition in runtime_entries():
        if definition.ruleset_version != ruleset_version: continue
        var current: Variant = output.get(definition.map_id)
        if current == null or definition.map_revision > current.map_revision:
            output[definition.map_id] = definition
    return output
```

- [ ] **Step 3: Implement automatic and manual policy**

```gdscript
# game/map/map_selection_service.gd
class_name MapSelectionService
extends RefCounted

const ReceiptScript := preload("res://game/map/map_selection_receipt.gd")
const BagScript := preload("res://game/map/map_shuffle_bag.gd")

var _catalog: Variant
var _ruleset_version: StringName
var _recent_exclusion_count: int
var _receipt_by_request_id: Dictionary = {}

func _init(catalog: Variant, ruleset_version: StringName, recent_exclusion_count: int = 3) -> void:
    _catalog = catalog
    _ruleset_version = ruleset_version
    _recent_exclusion_count = maxi(0, recent_exclusion_count)

func resolve(request: Variant, state: Variant) -> Dictionary:
    var errors: Array[String] = request.validation_errors()
    if not errors.is_empty(): return {"success": false, "reason": &"INVALID_REQUEST", "errors": errors}
    if _receipt_by_request_id.has(request.selection_request_id):
        return _receipt_by_request_id[request.selection_request_id]
    var definitions: Dictionary = _catalog.latest_eligible_by_id(_ruleset_version)
    if definitions.is_empty(): return {"success": false, "reason": &"NO_ELIGIBLE_MAP"}
    var map_id: StringName = &""
    if request.mode == &"RESTART_SAME_MAP":
        map_id = request.previous_run_identity.map_definition.map_id
    elif request.mode == &"SELECT_DISCOVERED_MAP":
        if not state.is_discovered(request.requested_map_id):
            return {"success": false, "reason": &"MAP_NOT_DISCOVERED"}
        map_id = request.requested_map_id
    else:
        map_id = _resolve_automatic(definitions.keys(), state)
    if map_id == &"" or not definitions.has(map_id):
        return {"success": false, "reason": &"MAP_NOT_ELIGIBLE"}
    var definition: Variant = definitions[map_id]
    if request.mode == &"RESTART_SAME_MAP":
        definition = _catalog.resolve(
            request.previous_run_identity.map_definition.map_id,
            request.previous_run_identity.map_definition.map_revision
        )
        if definition == null or not definition.is_runtime_eligible():
            return {"success": false, "reason": &"RESTART_MAP_UNAVAILABLE"}
    var receipt: Variant = ReceiptScript.create({
        "receipt_id": "receipt-%s" % request.selection_request_id,
        "selection_request_id": request.selection_request_id,
        "selection_mode": request.mode,
        "catalog_revision": _catalog.catalog_revision(),
        "map_id": definition.map_id,
        "map_revision": definition.map_revision,
        "cycle_generation": state.map_cycle_generation,
        "created_from_run_id": request.created_from_run_id,
    })
    var result := {"success": true, "receipt": receipt, "definition": definition}
    _receipt_by_request_id[request.selection_request_id] = result
    return result

func _resolve_automatic(eligible_values: Array, state: Variant) -> StringName:
    var eligible: Array[StringName] = []
    for value in eligible_values: eligible.append(StringName(value))
    eligible.sort()
    var undiscovered: Array[StringName] = []
    for map_id in eligible:
        if not state.is_discovered(map_id): undiscovered.append(map_id)
    if not undiscovered.is_empty():
        state.ensure_discovery_bag(undiscovered)
        return state.peek_discovery_map()
    state.ensure_replay_bag(eligible)
    var exclusion_count: int = mini(_recent_exclusion_count, maxi(0, eligible.size() - 1))
    while exclusion_count >= 0:
        var excluded: Array[StringName] = state.recent_map_ids.slice(0, exclusion_count)
        var candidate: StringName = state.peek_replay_map(excluded)
        if candidate != &"": return candidate
        exclusion_count -= 1
    return &""
```

- [ ] **Step 4: Add state bag helpers and consume-on-commit only**

Required methods:

```gdscript
func ensure_discovery_bag(undiscovered_ids: Array[StringName]) -> void
func ensure_replay_bag(eligible_ids: Array[StringName]) -> void
func peek_discovery_map() -> StringName
func peek_replay_map(excluded_ids: Array[StringName]) -> StringName
func consume_auto_receipt(receipt: Variant) -> void
```

`consume_auto_receipt()` must do nothing for restart or manual receipts and must increment `map_cycle_generation` only when a replay bag is exhausted and rebuilt.

- [ ] **Step 5: Run service tests and commit**

```bash
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tests/run_tests.gd
git add game/map/map_catalog.gd game/map/map_selection_service.gd game/map/map_discovery_state.gd tests/map/test_map_selection_service.gd tests/support/map_fixture.gd tests/run_tests.gd
git commit -m "feat: assign undiscovered maps before replays"
```

---

### Task 5: Atomic Run-Start Commit and Failure Policy

**Files:**
- Create: `tests/map/test_map_selection_profile_commit.gd`
- Create: `tests/run/test_map_selection_run_integration.gd`
- Modify: `game/profile/profile_store.gd`
- Modify: `game/run/run_controller.gd`
- Modify: `game/run/run_session_factory.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- `RunController.request_map_start(request: MapSelectionRequest) -> Dictionary`
- `RunController.commit_selected_run_start(receipt: MapSelectionReceipt, session: RunSession) -> Dictionary`
- `ProfileStore.commit_map_run_start(receipt: MapSelectionReceipt, state: MapDiscoveryState) -> Dictionary`
- Failure codes: `NO_ELIGIBLE_MAP`, `NO_RECONSTRUCTABLE_MAP`, `MAP_NOT_DISCOVERED`, `MAP_NOT_ELIGIBLE`, `RESTART_MAP_UNAVAILABLE`, `MANUAL_MAP_UNAVAILABLE`.

- [ ] **Step 1: Write commit-after-ready tests**

```gdscript
# tests/run/test_map_selection_run_integration.gd
extends RefCounted

func run(test: Variant) -> void:
    test.case("selection does not discover before full map ready", func() -> void:
        var context: Dictionary = TestRunContext.with_three_maps()
        var pending: Dictionary = context.controller.request_map_start(context.auto_request("request-a"))
        test.assert_true(pending.success)
        test.assert_false(context.discovery_state.is_discovered(pending.receipt.map_id))
        context.session_factory.complete_full_map_ready(pending.session)
        context.controller.commit_selected_run_start(pending.receipt, pending.session)
        test.assert_true(context.discovery_state.is_discovered(pending.receipt.map_id))
    )

    test.case("duplicate start callback commits once", func() -> void:
        var context: Dictionary = TestRunContext.with_three_maps()
        var pending: Dictionary = context.start_ready_auto("request-b")
        var first: Dictionary = context.controller.commit_selected_run_start(pending.receipt, pending.session)
        var duplicate: Dictionary = context.controller.commit_selected_run_start(pending.receipt, pending.session)
        test.assert_true(first.committed)
        test.assert_false(duplicate.committed)
        test.assert_equal(context.discovery_state.map_play_count_by_id[pending.receipt.map_id], 1)
    )

    test.case("restart uses same map and does not consume auto bag", func() -> void:
        var context: Dictionary = TestRunContext.after_completed_run(&"map.sx.0002")
        var before: Array[StringName] = context.discovery_state.auto_discovery_bag.duplicate()
        var pending: Dictionary = context.controller.request_map_start(context.restart_request())
        test.assert_equal(pending.receipt.map_id, &"map.sx.0002")
        test.assert_equal(context.discovery_state.auto_discovery_bag, before)
    )
```

- [ ] **Step 2: Require FULL_MAP_READY and matching receipt/session identity**

```gdscript
func commit_selected_run_start(receipt: Variant, session: Variant) -> Dictionary:
    if session == null or not session.is_full_map_ready():
        return {"committed": false, "reason": &"FULL_MAP_NOT_READY"}
    if session.run_identity.map_definition.identity_key() != receipt.identity_key():
        return {"committed": false, "reason": &"MAP_IDENTITY_MISMATCH"}
    var state_result: Dictionary = _discovery_state.mark_started(receipt)
    if not state_result.committed: return state_result
    _discovery_state.consume_auto_receipt(receipt)
    var save_result: Dictionary = _profile_store.commit_map_run_start(receipt, _discovery_state)
    if not save_result.success:
        _discovery_state.restore_from_snapshot(save_result.previous_snapshot)
        return {"committed": false, "reason": &"PROFILE_COMMIT_FAILED"}
    _activate_session(session)
    return state_result
```

Use a transactional state snapshot or perform the mutation inside ProfileStore's transaction closure so an unsuccessful save cannot leave memory and disk divergent.

- [ ] **Step 3: Implement bounded automatic reconstruction fallback**

For `AUTO_NEW_RUN` only:

```gdscript
const MAX_AUTOMATIC_RECONSTRUCTION_ATTEMPTS := 8

func _reconstruct_automatic(request: Variant) -> Dictionary:
    var rejected: Array[StringName] = []
    for _attempt in range(MAX_AUTOMATIC_RECONSTRUCTION_ATTEMPTS):
        var resolved: Dictionary = _selection_service.resolve_excluding(request, _discovery_state, rejected)
        if not resolved.success: return resolved
        var session_result: Dictionary = _session_factory.create_session(resolved.definition)
        if session_result.success:
            return {"success": true, "receipt": resolved.receipt, "session": session_result.session}
        rejected.append(resolved.receipt.map_id)
        _runtime_quarantine[resolved.receipt.map_id] = session_result.reason
    return {"success": false, "reason": &"NO_RECONSTRUCTABLE_MAP", "rejected_map_ids": rejected}
```

Requirements:

- The failed map is not discovered and its bag entry is not consumed.
- Manual selection returns `MANUAL_MAP_UNAVAILABLE` and does not call automatic fallback.
- Restart returns `RESTART_MAP_UNAVAILABLE` and does not call automatic fallback.
- No path calls RailGenerator with an arbitrary new seed.

- [ ] **Step 4: Run integration tests and commit**

```bash
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tests/run_tests.gd
git add game/profile/profile_store.gd game/run/run_controller.gd game/run/run_session_factory.gd tests/map/test_map_selection_profile_commit.gd tests/run/test_map_selection_run_integration.gd tests/run_tests.gd
git commit -m "feat: commit map discovery at authoritative run start"
```

---

### Task 6: Result Actions and Discovered-Map Browser

**Files:**
- Create: `game/map/map_browser_view_model.gd`
- Create: `game/ui/map_browser_panel.gd`
- Create: `game/ui/map_browser_panel.tscn`
- Create: `tests/ui/test_map_browser_view_model.gd`
- Create: `tests/ui/test_map_browser_panel.gd`
- Modify: `game/ui/result_panel.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- `MapBrowserViewModel.build(catalog: MapCatalog, state: MapDiscoveryState) -> MapBrowserViewModel`
- `MapBrowserViewModel.recent_cards: Array[Dictionary]`
- `MapBrowserViewModel.favorite_cards: Array[Dictionary]`
- `MapBrowserViewModel.all_discovered_cards: Array[Dictionary]`
- `MapBrowserViewModel.discovery_progress_text: String`
- `MapBrowserPanel.map_selected(map_id: StringName)`
- `MapBrowserPanel.favorite_changed(map_id: StringName, enabled: bool)`
- `ResultPanel.restart_requested()`
- `ResultPanel.new_run_requested()`
- `ResultPanel.choose_map_requested()`

- [ ] **Step 1: Write seed-redaction and section tests**

```gdscript
# tests/ui/test_map_browser_view_model.gd
extends RefCounted

func run(test: Variant) -> void:
    test.case("browser includes discovered maps only", func() -> void:
        var context: Dictionary = BrowserFixture.with_maps([&"a", &"b", &"c"], [&"a", &"c"])
        var view_model: Variant = context.build_view_model()
        var ids: Array[StringName] = view_model.all_discovered_cards.map(func(card: Dictionary) -> StringName: return card.map_id)
        ids.sort()
        test.assert_equal(ids, [&"a", &"c"])
        test.assert_equal(view_model.discovery_progress_text, "2 / 3")
    )

    test.case("card never exposes seed or signatures", func() -> void:
        var card: Dictionary = BrowserFixture.one_discovered_card()
        test.assert_false(card.has("map_seed"))
        test.assert_false(card.has("layout_signature"))
        test.assert_false(card.has("generator_version"))
    )

    test.case("retired favorite renders unavailable and cannot select", func() -> void:
        var card: Dictionary = BrowserFixture.retired_favorite_card()
        test.assert_false(card.is_selectable)
        test.assert_equal(card.availability_text_key, &"map.status.unavailable")
    )
```

- [ ] **Step 2: Build seed-free card dictionaries**

```gdscript
# game/map/map_browser_view_model.gd
class_name MapBrowserViewModel
extends RefCounted

var recent_cards: Array[Dictionary] = []
var favorite_cards: Array[Dictionary] = []
var all_discovered_cards: Array[Dictionary] = []
var discovery_progress_text: String

static func build(catalog: Variant, state: Variant) -> MapBrowserViewModel:
    var value := MapBrowserViewModel.new()
    var eligible: Dictionary = catalog.latest_eligible_by_id(&"standard_v1")
    var cards_by_id: Dictionary = {}
    for map_id in state.discovered_map_ids:
        var definition: Variant = eligible.get(map_id)
        cards_by_id[map_id] = {
            "map_id": map_id,
            "display_name_key": "map.%s.name" % str(map_id),
            "short_label": str(map_id).get_slice(".", 2),
            "is_favorite": state.favorite_map_ids.has(map_id),
            "play_count": int(state.map_play_count_by_id.get(map_id, 0)),
            "is_selectable": definition != null,
            "availability_text_key": &"map.status.available" if definition != null else &"map.status.unavailable",
        }
    for map_id in state.recent_map_ids:
        if cards_by_id.has(map_id): value.recent_cards.append(cards_by_id[map_id])
    for map_id in state.favorite_map_ids:
        if cards_by_id.has(map_id): value.favorite_cards.append(cards_by_id[map_id])
    var sorted_ids: Array = cards_by_id.keys()
    sorted_ids.sort()
    for map_id in sorted_ids: value.all_discovered_cards.append(cards_by_id[map_id])
    value.discovery_progress_text = "%d / %d" % [state.discovered_map_ids.size(), eligible.size()]
    return value
```

Move the ruleset version into the constructor or caller rather than hard-coding it in final implementation; tests must assert the provided current ruleset is forwarded.

- [ ] **Step 3: Build the panel layout**

`map_browser_panel.tscn` hierarchy:

```text
MapBrowserPanel (Control)
└── MarginContainer
    └── VBoxContainer
        ├── HeaderRow
        │   ├── TitleLabel
        │   ├── ProgressLabel
        │   └── CloseButton
        ├── TabBar [RECENT, FAVORITES, ALL DISCOVERED]
        ├── ScrollContainer
        │   └── MapCardGrid
        └── StatusLabel
```

Requirements:

- card and buttons use at least `48dp` interactive targets,
- card emits stable `map_id` only,
- unavailable card cannot emit selection,
- favorite action is separate from select action,
- text+icon/shape communicates favorite, selected, and unavailable,
- layout supports `140%` localization expansion,
- list uses recycled or lazily instantiated cards for 100 discovered entries,
- Reduced Motion changes reveal animation only.

- [ ] **Step 4: Split result actions semantically**

```gdscript
# game/ui/result_panel.gd additions
signal restart_requested
signal new_run_requested
signal choose_map_requested

func _on_restart_pressed() -> void:
    restart_requested.emit()

func _on_new_run_pressed() -> void:
    new_run_requested.emit()

func _on_choose_map_pressed() -> void:
    choose_map_requested.emit()
```

The panel must not emit a map seed or revision. `RESTART` remains visually primary, `NEW RUN` secondary, and `CHOOSE MAP` compact/tertiary.

- [ ] **Step 5: Run UI tests and commit**

```bash
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tests/run_tests.gd
git add game/map/map_browser_view_model.gd game/ui/map_browser_panel.gd game/ui/map_browser_panel.tscn game/ui/result_panel.gd tests/ui/test_map_browser_view_model.gd tests/ui/test_map_browser_panel.gd tests/run_tests.gd
git commit -m "feat: add discovered map browser and result actions"
```

---

### Task 7: Bounded Map Selection Telemetry

**Files:**
- Create: `game/telemetry/map_selection_event.gd`
- Create: `tests/telemetry/test_map_selection_event.gd`
- Modify: `game/telemetry/run_event_log.gd`
- Modify: `game/map/map_selection_service.gd`
- Modify: `game/run/run_controller.gd`
- Modify: `game/ui/map_browser_panel.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- `MapSelectionEvent.requested(request, eligible_count, undiscovered_count, recent_exclusion_count) -> Dictionary`
- `MapSelectionEvent.resolved(receipt, source_cycle, repeat_distance) -> Dictionary`
- `MapSelectionEvent.committed(receipt, run_id, newly_discovered, play_count) -> Dictionary`
- `MapSelectionEvent.rejected(request_id, map_id, reason_code) -> Dictionary`
- `MapSelectionEvent.browser_action(action, map_id = &"") -> Dictionary`

- [ ] **Step 1: Write bounded payload tests**

```gdscript
# tests/telemetry/test_map_selection_event.gd
extends RefCounted

const EventScript := preload("res://game/telemetry/map_selection_event.gd")

func run(test: Variant) -> void:
    test.case("resolved event excludes raw seed and signatures", func() -> void:
        var payload: Dictionary = EventScript.resolved(TelemetryFixture.receipt(), &"DISCOVERY", 0)
        test.assert_false(payload.has("map_seed"))
        test.assert_false(payload.has("layout_signature"))
        test.assert_equal(payload.event_name, &"map_selection_resolved")
    )

    test.case("browser action accepts bounded enum only", func() -> void:
        test.assert_equal(EventScript.browser_action(&"OPEN").action, &"OPEN")
        test.assert_equal(EventScript.browser_action(&"DELETE").event_name, &"map_browser_action_rejected")
    )
```

- [ ] **Step 2: Implement payload constructors**

```gdscript
# game/telemetry/map_selection_event.gd
class_name MapSelectionEvent
extends RefCounted

const BROWSER_ACTIONS: Array[StringName] = [&"OPEN", &"SELECT", &"FAVORITE_ADD", &"FAVORITE_REMOVE"]

static func resolved(receipt: Variant, source_cycle: StringName, repeat_distance: int) -> Dictionary:
    return {
        "event_name": &"map_selection_resolved",
        "request_id": receipt.selection_request_id,
        "receipt_id": receipt.receipt_id,
        "mode": receipt.selection_mode,
        "map_id": receipt.map_id,
        "map_revision": receipt.map_revision,
        "source_cycle": source_cycle,
        "repeat_distance": repeat_distance,
    }

static func browser_action(action: StringName, map_id: StringName = &"") -> Dictionary:
    if action not in BROWSER_ACTIONS:
        return {"event_name": &"map_browser_action_rejected", "reason": &"UNSUPPORTED_ACTION"}
    return {"event_name": &"map_browser_action", "action": action, "map_id": map_id}
```

Add equally bounded `requested`, `committed`, and `rejected` constructors matching the design fields exactly.

- [ ] **Step 3: Emit once at domain boundaries**

- requested: before resolution,
- resolved: after receipt creation,
- rejected: once per rejected candidate/reason,
- committed: after atomic Profile success,
- browser action: on user semantic action.

Do not emit discovery completion from animation callbacks.

- [ ] **Step 4: Run telemetry tests and commit**

```bash
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tests/run_tests.gd
git add game/telemetry/map_selection_event.gd game/telemetry/run_event_log.gd game/map/map_selection_service.gd game/run/run_controller.gd game/ui/map_browser_panel.gd tests/telemetry/test_map_selection_event.gd tests/run_tests.gd
git commit -m "feat: add bounded map selection telemetry"
```

---

### Task 8: Vertical-Slice and 100-Map Simulations

**Files:**
- Create: `tests/integration/test_three_map_discovery_flow.gd`
- Create: `tests/integration/test_hundred_map_discovery_simulation.gd`
- Modify: `tests/support/map_fixture.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- `MapFixture.catalog_with_count(count: int) -> MapCatalog`
- `DiscoverySimulation.run_auto_starts(count: int) -> Array[StringName]`

- [ ] **Step 1: Write exact three-map acceptance flow**

```gdscript
# tests/integration/test_three_map_discovery_flow.gd
extends RefCounted

func run(test: Variant) -> void:
    test.case("three auto starts discover three maps without repeat", func() -> void:
        var simulation: Variant = DiscoverySimulation.new(3, 101)
        var first_cycle: Array[StringName] = simulation.run_auto_starts(3)
        test.assert_equal(first_cycle.size(), 3)
        test.assert_equal(first_cycle.duplicate().reduce(func(acc: Dictionary, id: StringName) -> Dictionary: acc[id] = true; return acc, {}).size(), 3)
        var fourth: StringName = simulation.run_auto_starts(1)[0]
        test.assert_not_equal(fourth, first_cycle[2])
    )

    test.case("same-map restart neither changes map nor consumes auto queue", func() -> void:
        var simulation: Variant = DiscoverySimulation.new(3, 102)
        var current: StringName = simulation.run_auto_starts(1)[0]
        var before: Array[StringName] = simulation.discovery_state.auto_discovery_bag.duplicate()
        var restarted: StringName = simulation.restart_current()
        test.assert_equal(restarted, current)
        test.assert_equal(simulation.discovery_state.auto_discovery_bag, before)
    )
```

Replace the reducer with the test runner's supported set helper if anonymous multi-statement reducers are not supported by the project parser; the acceptance assertion remains exactly three unique IDs.

- [ ] **Step 2: Write 100-map coverage simulation**

```gdscript
# tests/integration/test_hundred_map_discovery_simulation.gd
extends RefCounted

func run(test: Variant) -> void:
    test.case("first one hundred successful auto starts cover one hundred maps", func() -> void:
        var simulation: Variant = DiscoverySimulation.new(100, 20260802)
        var selected: Array[StringName] = simulation.run_auto_starts(100)
        var unique: Dictionary = {}
        for map_id in selected: unique[map_id] = true
        test.assert_equal(selected.size(), 100)
        test.assert_equal(unique.size(), 100)
    )

    test.case("new catalog additions return to discovery priority", func() -> void:
        var simulation: Variant = DiscoverySimulation.new(3, 33)
        simulation.run_auto_starts(3)
        simulation.add_validated_map(&"map.sx.0004")
        test.assert_equal(simulation.run_auto_starts(1)[0], &"map.sx.0004")
    )

    test.case("retired map is removed without runtime seed fallback", func() -> void:
        var simulation: Variant = DiscoverySimulation.new(3, 44)
        simulation.retire_map(&"map.sx.0002")
        var selected: Array[StringName] = simulation.run_auto_starts(2)
        test.assert_false(selected.has(&"map.sx.0002"))
        test.assert_false(simulation.runtime_seed_generation_called)
    )
```

- [ ] **Step 3: Run the full deterministic suite**

```bash
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tests/run_tests.gd
```

Expected: all suites pass, including 3-map and 100-map simulations.

- [ ] **Step 4: Run catalog audit prerequisites**

```bash
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tools/audit_map_catalog.gd -- --target=3
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tools/audit_map_catalog.gd -- --target=100
```

Expected at implementation time:

- target 3 passes before Vertical Slice evidence closes,
- target 100 passes only after generator diversity and 100-map production evidence exist,
- a target-100 failure is reported honestly and does not block the smaller VS target from being evaluated separately.

- [ ] **Step 5: Commit acceptance simulations**

```bash
git add tests/integration/test_three_map_discovery_flow.gd tests/integration/test_hundred_map_discovery_simulation.gd tests/support/map_fixture.gd tests/run_tests.gd
git commit -m "test: cover automatic discovery at catalog scale"
```

---

### Task 9: Runtime UX, Device, and Human Evidence

**Files:**
- Modify: `기획서/50_제작_검증/PLAYTEST_PLAN.md`
- Modify: `기획서/50_제작_검증/TOTAL_PLANNING_AUDIT.md`
- Modify: `docs/superpowers/specs/2026-08-02-automatic-map-discovery-and-reselection-design.md` only when evidence changes a `TEST_VALUE`

**Interfaces:**
- Evidence records reference `SX-DEC-024` and the exact implementation commit.

- [ ] **Step 1: Capture automated proof**

Record:

- first-three no-repeat sequence,
- fourth-start immediate-repeat avoidance,
- restart bag non-consumption,
- duplicate request and start-commit idempotency,
- invalid automatic bounded skip,
- invalid manual no-substitution,
- Profile save/reload for discovery, recent, favorite, and bags,
- target-100 simulation result,
- actual catalog target-3/target-100 audit results.

- [ ] **Step 2: Run Android aspect and lifecycle checks**

Validate at minimum:

- project reference landscape resolution,
- narrow and wide landscape aspect variants,
- suspend/resume during selection and browser display,
- duplicate tap suppression,
- browser scroll at 100 discovered cards,
- no overlap at `140%` localization expansion,
- `48dp` targets,
- Reduced Motion parity.

- [ ] **Step 3: Run at least five human sessions**

Success criteria:

- at least `4/5` distinguish `RESTART` as same map and `NEW RUN` as another automatically assigned map,
- at least `4/5` can reselect a previously played map without seeing or requesting a seed,
- no participant interprets undiscovered progress as a currency, ad, or time lock,
- no participant reports that automatic discovery repeats before the three-map VS pool is exhausted,
- browsing 100-entry prototype data does not block the primary automatic-start path.

These thresholds are `TEST_VALUE` until actual evidence is recorded.

- [ ] **Step 4: Run final verification**

```bash
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tests/run_tests.gd
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tools/audit_map_catalog.gd -- --target=3
```

Also verify:

- Project Contract workflow passes,
- Godot Tests workflow passes,
- product diff contains only intended implementation files,
- no raw seed field exists in result or browser UI,
- no unresolved P0/P1 finding remains,
- Android and human evidence are marked `NOT_RUN` unless actually executed.

- [ ] **Step 5: Commit evidence updates**

```bash
git add 기획서/50_제작_검증/PLAYTEST_PLAN.md 기획서/50_제작_검증/TOTAL_PLANNING_AUDIT.md
git commit -m "docs: record map discovery validation evidence"
```

## Plan Self-Review

- Spec coverage: request modes, discovery-first assignment, replay cycle, manual selection, catalog reconciliation, idempotent receipt, Profile atomicity, failure policy, browser, accessibility, telemetry, VS and production gates each have an implementation task.
- Placeholder scan: no `TBD`, `TODO`, generic error-handling instruction, or undefined “write tests” step remains.
- Type consistency: stable `map_id: StringName`, `map_revision: int`, request and receipt IDs as `String`, and catalog revision as `StringName` are consistent across tasks.
- Authority check: only domain services and ProfileStore select/commit; UI, animation, and loading states remain non-authoritative.
- Scope check: global/per-map records, map difficulty labels, regions, leaderboards, UGC, and download packaging remain deferred.

## Execution Boundary

This plan is recorded for later execution only. `GMB-001` is not yet at `10/10`, the Draft PR is not merged, and `CODEX_NOT_READY` remains. Do not begin Task 1 until the batch audit and canonical synchronization explicitly set `READY_FOR_BUILD`.
