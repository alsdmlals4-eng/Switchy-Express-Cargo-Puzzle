# Records + Cosmetic-Only Progression Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 표준 개인 기록 3종과 성능 없는 꾸미기 해금·장착 Profile을 구현하되 assisted run, cosmetic asset, UI, animation이 run 성능·기록 자격·저장 권위를 오염하지 않게 한다.

**Architecture:** `RunSummary`를 `RecordEligibilityPolicy`가 판정하고 `CompetitiveRecordStore`가 최고값만 versioned Profile에 저장한다. `CosmeticRegistry`와 `CosmeticCollectionState`는 immutable cosmetic metadata와 해금·장착 ID만 관리하며, visual/audio view는 선택 결과를 표현할 뿐 RunBalance와 collision을 변경하지 않는다.

**Tech Stack:** Godot 4.7.1, GDScript, Resource/JSON 기반 registry, 기존 headless test runner, Android landscape capture validation.

## Global Constraints

- Decision: `SX-DEC-019`; Evidence: `EV-USER-008`; GMB-001 slot `3/10`.
- 영구 진행은 개인 기록과 cosmetic-only 수집·장착만 허용한다.
- 표준 기록은 `best_score`, `longest_survival_seconds`, `best_max_combo`다.
- `assisted_first_run=true`인 run은 표준 기록을 갱신하지 않는다.
- cosmetic은 speed, fuel, capacity, BOOST, score, spawn, map, collision, compact footprint, camera, onboarding, record eligibility를 변경할 수 없다.
- 온라인 리더보드, 상점, 시즌, 가격, 유료 판매, 광고 보상은 범위 밖이다.
- 대표 Vertical Slice cosmetic은 기관차 스킨 1종만 구현한다.
- 제품 구현은 GMB-001 10/10과 `READY_FOR_BUILD` 전에는 시작하지 않는다.

---

## Planned File Map

```text
game/profile/profile_schema.gd
→ Profile schema version, defaults, normalization, migration entry point

game/profile/profile_store.gd
→ Atomic load/save, corruption recovery, migration persistence

game/profile/record_eligibility_policy.gd
→ RunSummary의 표준 기록 자격 판정

game/profile/competitive_record_store.gd
→ 세 개인 최고 기록의 idempotent 비교·갱신

game/cosmetics/cosmetic_definition.gd
→ gameplay modifier가 없는 immutable cosmetic metadata

game/cosmetics/cosmetic_registry.gd
→ cosmetic_id lookup, category/default validation

game/cosmetics/cosmetic_collection_state.gd
→ unlocked IDs와 selected ID 관리

game/cosmetics/cosmetic_view_model.gd
→ registry+selection을 visual/audio view 입력으로 변환

game/ui/collection_panel.gd
→ 대표 기관차 스킨 preview·equip UI, 상태 비권위

game/ui/collection_panel.tscn
→ 최소 collection 화면

tests/profile/test_record_eligibility_policy.gd
tests/profile/test_competitive_record_store.gd
tests/profile/test_profile_store_migration.gd
tests/cosmetics/test_cosmetic_registry.gd
tests/cosmetics/test_cosmetic_collection_state.gd
tests/cosmetics/test_cosmetic_gameplay_parity.gd
tests/ui/test_collection_panel_state.gd
tests/integration/test_run_end_profile_update.gd
```

---

### Task 1: Define Versioned Profile Schema

**Files:**
- Create: `game/profile/profile_schema.gd`
- Test: `tests/profile/test_profile_store_migration.gd`

**Interfaces:**
- Produces: `ProfileSchema.create_default() -> Dictionary`
- Produces: `ProfileSchema.normalize(raw: Variant) -> Dictionary`
- Produces: `ProfileSchema.migrate(raw: Dictionary) -> Dictionary`
- Consumes: no runtime subsystem.

- [ ] **Step 1: Write failing default-schema test**

```gdscript
func test_default_profile_contains_records_and_default_cosmetic() -> void:
    var profile := ProfileSchema.create_default()
    assert_eq(profile.profile_schema_version, ProfileSchema.CURRENT_VERSION)
    assert_eq(profile.competitive_records.best_score, 0)
    assert_eq(profile.competitive_records.longest_survival_seconds, 0.0)
    assert_eq(profile.competitive_records.best_max_combo, 0)
    assert_true(profile.unlocked_cosmetic_ids.has("locomotive.default"))
    assert_eq(profile.selected_cosmetic_by_category.LOCOMOTIVE_SKIN, "locomotive.default")
```

- [ ] **Step 2: Run the test and verify RED**

Run:

```bash
godot --headless --path . -s res://tests/run_single.gd -- tests/profile/test_profile_store_migration.gd
```

Expected: failure because `ProfileSchema` does not exist.

- [ ] **Step 3: Implement the schema constants and default factory**

```gdscript
class_name ProfileSchema
extends RefCounted

const CURRENT_VERSION := 1
const DEFAULT_LOCOMOTIVE_ID := &"locomotive.default"

static func create_default() -> Dictionary:
    return {
        "profile_schema_version": CURRENT_VERSION,
        "competitive_records": {
            "best_score": 0,
            "longest_survival_seconds": 0.0,
            "best_max_combo": 0,
            "records_ruleset_id": "",
        },
        "unlocked_cosmetic_ids": [String(DEFAULT_LOCOMOTIVE_ID)],
        "selected_cosmetic_by_category": {
            "LOCOMOTIVE_SKIN": String(DEFAULT_LOCOMOTIVE_ID),
        },
    }
```

- [ ] **Step 4: Add normalization tests for invalid numeric values and malformed collections**

```gdscript
func test_normalize_repairs_only_invalid_fields() -> void:
    var raw := ProfileSchema.create_default()
    raw.competitive_records.best_score = -10
    raw.competitive_records.longest_survival_seconds = NAN
    raw.unlocked_cosmetic_ids = "not-an-array"
    var normalized := ProfileSchema.normalize(raw)
    assert_eq(normalized.competitive_records.best_score, 0)
    assert_eq(normalized.competitive_records.longest_survival_seconds, 0.0)
    assert_true(normalized.unlocked_cosmetic_ids.has("locomotive.default"))
```

- [ ] **Step 5: Implement bounded normalization and version migration**

Requirements:
- negative and non-finite records become zero;
- unknown top-level fields are ignored;
- valid fields survive;
- default cosmetic always exists;
- migration is deterministic and idempotent.

- [ ] **Step 6: Run the focused schema tests and verify GREEN**

Run the same headless command. Expected: all profile schema tests pass.

- [ ] **Step 7: Commit**

```bash
git add game/profile/profile_schema.gd tests/profile/test_profile_store_migration.gd
git commit -m "feat: define versioned player profile schema"
```

---

### Task 2: Implement Record Eligibility Policy

**Files:**
- Create: `game/profile/record_eligibility_policy.gd`
- Test: `tests/profile/test_record_eligibility_policy.gd`

**Interfaces:**
- Consumes: immutable `RunSummary` Dictionary.
- Produces: `RecordEligibilityPolicy.evaluate(summary: Dictionary, current_ruleset_id: StringName) -> Dictionary`.

Expected result shape:

```text
eligible: bool
reason_code: StringName
ruleset_id: StringName
```

- [ ] **Step 1: Write failing eligibility matrix tests**

```gdscript
func test_standard_completed_run_is_eligible() -> void:
    var result := RecordEligibilityPolicy.evaluate({
        "run_completed": true,
        "assisted_first_run": false,
        "ruleset_id": "rules.v1",
        "integrity_state": "VALID",
    }, &"rules.v1")
    assert_true(result.eligible)
    assert_eq(result.reason_code, &"ELIGIBLE")

func test_assisted_first_run_is_not_eligible() -> void:
    var result := RecordEligibilityPolicy.evaluate({
        "run_completed": true,
        "assisted_first_run": true,
        "ruleset_id": "rules.v1",
        "integrity_state": "VALID",
    }, &"rules.v1")
    assert_false(result.eligible)
    assert_eq(result.reason_code, &"ASSISTED_RUN")
```

Also test incomplete run, ruleset mismatch, invalid integrity, missing field.

- [ ] **Step 2: Run and verify RED**

Expected: missing class.

- [ ] **Step 3: Implement deterministic eligibility evaluation**

```gdscript
class_name RecordEligibilityPolicy
extends RefCounted

static func evaluate(summary: Dictionary, current_ruleset_id: StringName) -> Dictionary:
    if not bool(summary.get("run_completed", false)):
        return _result(false, &"RUN_INCOMPLETE", current_ruleset_id)
    if bool(summary.get("assisted_first_run", false)):
        return _result(false, &"ASSISTED_RUN", current_ruleset_id)
    if StringName(summary.get("ruleset_id", "")) != current_ruleset_id:
        return _result(false, &"RULESET_MISMATCH", current_ruleset_id)
    if StringName(summary.get("integrity_state", "INVALID")) != &"VALID":
        return _result(false, &"INTEGRITY_INVALID", current_ruleset_id)
    return _result(true, &"ELIGIBLE", current_ruleset_id)
```

- [ ] **Step 4: Run focused tests and verify GREEN**

- [ ] **Step 5: Commit**

```bash
git add game/profile/record_eligibility_policy.gd tests/profile/test_record_eligibility_policy.gd
git commit -m "feat: separate standard record eligibility"
```

---

### Task 3: Implement Idempotent Competitive Record Updates

**Files:**
- Create: `game/profile/competitive_record_store.gd`
- Test: `tests/profile/test_competitive_record_store.gd`

**Interfaces:**
- Consumes: normalized profile, RunSummary, eligibility result.
- Produces: `CompetitiveRecordStore.apply_summary(profile: Dictionary, summary: Dictionary, eligibility: Dictionary) -> Dictionary`.
- Result fields: `profile`, `updated_fields`, `record_updated`.

- [ ] **Step 1: Write failing independent-max tests**

Test that one run can update score and combo without replacing a longer survival record.

```gdscript
func test_each_record_field_updates_independently() -> void:
    var profile := ProfileSchema.create_default()
    profile.competitive_records = {
        "best_score": 1000,
        "longest_survival_seconds": 180.0,
        "best_max_combo": 3,
        "records_ruleset_id": "rules.v1",
    }
    var result := CompetitiveRecordStore.apply_summary(profile, {
        "score": 1200,
        "survival_seconds": 150.0,
        "max_combo": 4,
    }, {"eligible": true, "ruleset_id": "rules.v1"})
    assert_eq(result.profile.competitive_records.best_score, 1200)
    assert_eq(result.profile.competitive_records.longest_survival_seconds, 180.0)
    assert_eq(result.profile.competitive_records.best_max_combo, 4)
    assert_eq(result.updated_fields, ["best_score", "best_max_combo"])
```

- [ ] **Step 2: Add ineligible and duplicate-summary tests**

Requirements:
- ineligible summary changes zero fields;
- same summary applied twice has no second update;
- invalid numeric input is ignored, not persisted;
- records never decrease.

- [ ] **Step 3: Run and verify RED**

- [ ] **Step 4: Implement pure record comparison**

Do not write files or emit UI signals inside `apply_summary`; return a new normalized result.

- [ ] **Step 5: Run focused tests and verify GREEN**

- [ ] **Step 6: Commit**

```bash
git add game/profile/competitive_record_store.gd tests/profile/test_competitive_record_store.gd
git commit -m "feat: persist independent personal best records"
```

---

### Task 4: Define Modifier-Free Cosmetic Metadata and Registry

**Files:**
- Create: `game/cosmetics/cosmetic_definition.gd`
- Create: `game/cosmetics/cosmetic_registry.gd`
- Test: `tests/cosmetics/test_cosmetic_registry.gd`

**Interfaces:**
- Produces: `CosmeticDefinition` Resource fields only for ID, category, assets, localization, compatibility, accessibility.
- Produces: `CosmeticRegistry.get_definition(id: StringName) -> CosmeticDefinition`
- Produces: `CosmeticRegistry.get_default_id(category: StringName) -> StringName`
- Produces: `CosmeticRegistry.validate() -> Array[Dictionary]`

- [ ] **Step 1: Write failing registry validation tests**

Test duplicate ID, missing default, invalid category, and forbidden gameplay-looking fields.

```gdscript
func test_registry_rejects_definition_with_gameplay_modifier_metadata() -> void:
    var raw := {
        "cosmetic_id": "locomotive.fast",
        "category": "LOCOMOTIVE_SKIN",
        "speed_multiplier": 1.1,
    }
    var errors := CosmeticRegistry.validate_raw_definition(raw)
    assert_true(errors.any(func(e): return e.code == &"FORBIDDEN_GAMEPLAY_FIELD"))
```

Forbidden key fragments include:

```text
speed fuel score capacity boost drain reward spawn collision footprint camera assist eligibility
```

- [ ] **Step 2: Run and verify RED**

- [ ] **Step 3: Implement `CosmeticDefinition` without modifier fields**

Required fields:

```gdscript
@export var cosmetic_id: StringName
@export var category: StringName
@export var asset_reference: String
@export var preview_reference: String
@export var localization_key: StringName
@export var compatibility_version: int = 1
@export var accessibility_tags: PackedStringArray
```

- [ ] **Step 4: Implement registry validation and default lookup**

The registry must always provide `locomotive.default` for `LOCOMOTIVE_SKIN`.

- [ ] **Step 5: Run registry tests and verify GREEN**

- [ ] **Step 6: Commit**

```bash
git add game/cosmetics/cosmetic_definition.gd game/cosmetics/cosmetic_registry.gd tests/cosmetics/test_cosmetic_registry.gd
git commit -m "feat: add modifier-free cosmetic registry"
```

---

### Task 5: Implement Cosmetic Unlock and Equip State

**Files:**
- Create: `game/cosmetics/cosmetic_collection_state.gd`
- Test: `tests/cosmetics/test_cosmetic_collection_state.gd`

**Interfaces:**
- Consumes: `CosmeticRegistry`, normalized profile cosmetic fields.
- Produces: `unlock(id: StringName) -> Dictionary`
- Produces: `equip(category: StringName, id: StringName) -> Dictionary`
- Produces: `resolve_selected(category: StringName) -> StringName`

- [ ] **Step 1: Write failing unlock/equip tests**

Cover:
- duplicate unlock is idempotent;
- locked cosmetic cannot equip;
- wrong-category cosmetic cannot equip;
- unknown/deleted selected ID falls back to default;
- default cosmetic cannot become unavailable.

- [ ] **Step 2: Run and verify RED**

- [ ] **Step 3: Implement collection state transitions**

Return explicit result codes:

```text
UNLOCKED
ALREADY_UNLOCKED
EQUIPPED
LOCKED
UNKNOWN_ID
CATEGORY_MISMATCH
FALLBACK_DEFAULT
```

- [ ] **Step 4: Run focused tests and verify GREEN**

- [ ] **Step 5: Commit**

```bash
git add game/cosmetics/cosmetic_collection_state.gd tests/cosmetics/test_cosmetic_collection_state.gd
git commit -m "feat: manage cosmetic unlock and equip state"
```

---

### Task 6: Implement Atomic Profile Load, Save, and Migration Recovery

**Files:**
- Create: `game/profile/profile_store.gd`
- Modify: `game/profile/profile_schema.gd`
- Test: `tests/profile/test_profile_store_migration.gd`

**Interfaces:**
- Produces: `ProfileStore.load_profile() -> Dictionary`
- Produces: `ProfileStore.save_profile(profile: Dictionary) -> Dictionary`
- Produces result fields: `success`, `profile`, `reason_code`, `migration_applied`.

- [ ] **Step 1: Write failing persistence tests**

Test:
- first launch creates default;
- valid save round-trips;
- truncated JSON recovers default and reports corruption;
- legacy version migrates valid records/unlocks;
- unknown cosmetic ID is retained in raw unlock list only if registry policy allows, but invalid selected ID falls back;
- failed temp-file rename leaves previous valid save readable.

- [ ] **Step 2: Run and verify RED**

- [ ] **Step 3: Implement temp-write then atomic replace**

Write normalized content to a temporary path, flush, then replace the profile file. Never mutate RunState based on save success.

- [ ] **Step 4: Implement migration and partial recovery**

Migration must preserve valid record fields and known unlocked IDs. A corrupt field must not discard unrelated valid fields.

- [ ] **Step 5: Run focused persistence tests and verify GREEN**

- [ ] **Step 6: Commit**

```bash
git add game/profile/profile_store.gd game/profile/profile_schema.gd tests/profile/test_profile_store_migration.gd
git commit -m "feat: add resilient profile persistence"
```

---

### Task 7: Connect Run End to Profile Records Without UI Authority

**Files:**
- Modify: `game/run/run_controller.gd`
- Modify: `game/run/run_summary.gd`
- Create: `tests/integration/test_run_end_profile_update.gd`

**Interfaces:**
- Consumes: final immutable `RunSummary` once per run generation.
- Calls: `RecordEligibilityPolicy.evaluate()` then `CompetitiveRecordStore.apply_summary()` then `ProfileStore.save_profile()`.
- Produces: bounded `profile_update_result` event for ResultViewModel.

- [ ] **Step 1: Write failing integration tests**

Test:
- fuel-zero emitted twice still updates profile once;
- standard run updates eligible fields;
- assisted first run updates zero standard records;
- save failure does not block result screen or restart;
- UI animation completion does not trigger record save.

- [ ] **Step 2: Run and verify RED**

- [ ] **Step 3: Add one-shot run-generation guard**

Use the same generation or run ID that protects game-over processing. Profile update must occur after summary finalization, not after ResultPanel animation.

- [ ] **Step 4: Emit bounded result data**

```text
record_eligible
record_reason_code
updated_record_fields
profile_save_success
```

Do not emit the full profile or save contents.

- [ ] **Step 5: Run focused integration tests and verify GREEN**

- [ ] **Step 6: Commit**

```bash
git add game/run/run_controller.gd game/run/run_summary.gd tests/integration/test_run_end_profile_update.gd
git commit -m "feat: update profile records at authoritative run end"
```

---

### Task 8: Add Representative Locomotive Cosmetic and Gameplay Parity Tests

**Files:**
- Create: `game/cosmetics/data/locomotive_default.tres`
- Create: `game/cosmetics/data/locomotive_reference_variant.tres`
- Create: `game/cosmetics/cosmetic_view_model.gd`
- Modify: `game/train/train_view.gd`
- Test: `tests/cosmetics/test_cosmetic_gameplay_parity.gd`

**Interfaces:**
- Consumes: selected locomotive cosmetic ID.
- Produces: visual asset reference only.
- Must not reach `RunBalance`, `TrainState`, `TrainFootprint`, `RailGraph`, or `RecordEligibilityPolicy`.

- [ ] **Step 1: Write failing parity snapshot tests**

For the same seed and scripted input, compare default vs representative skin:

```text
rail_graph_signature
train_collision_shape
occupied_cells
compact_trailing_footprint
speed_samples
fuel_samples
score
max_combo
spawn_sequence
record_eligibility
```

All values must be equal.

- [ ] **Step 2: Add dependency-boundary test**

Fail if cosmetic metadata exposes numeric gameplay modifier keys or if TrainState reads CosmeticCollectionState.

- [ ] **Step 3: Run and verify RED**

- [ ] **Step 4: Implement view-only locomotive asset selection**

Only sprite/mesh/material/animation references may vary. Collision and train footprint remain owned by existing domain nodes.

- [ ] **Step 5: Run parity tests and verify GREEN**

- [ ] **Step 6: Commit**

```bash
git add game/cosmetics game/train/train_view.gd tests/cosmetics/test_cosmetic_gameplay_parity.gd
git commit -m "feat: add view-only locomotive cosmetic"
```

---

### Task 9: Add Minimal Collection UI Without Run-Flow Blocking

**Files:**
- Create: `game/ui/collection_panel.tscn`
- Create: `game/ui/collection_panel.gd`
- Create: `game/cosmetics/cosmetic_view_model.gd`
- Test: `tests/ui/test_collection_panel_state.gd`

**Interfaces:**
- Consumes: registry entries and collection state snapshot.
- Produces: equip request intent.
- Does not own unlock, save, run start, record, or gameplay values.

- [ ] **Step 1: Write failing UI-state tests**

Test:
- locked item shows locked and cannot emit valid equip;
- unlocked item can request equip;
- save failure shows non-blocking status and keeps previous selection authoritative;
- missing preview uses placeholder;
- back closes collection without changing run state;
- collection is not inserted between result `RESTART` and next run.

- [ ] **Step 2: Run and verify RED**

- [ ] **Step 3: Implement minimal list, preview, equip, and back states**

Do not implement currency, price, rarity, purchase, ads, seasons, or online services.

- [ ] **Step 4: Run UI tests and verify GREEN**

- [ ] **Step 5: Commit**

```bash
git add game/ui/collection_panel.tscn game/ui/collection_panel.gd game/cosmetics/cosmetic_view_model.gd tests/ui/test_collection_panel_state.gd
git commit -m "feat: add minimal cosmetic collection panel"
```

---

### Task 10: Accessibility, Android, and Human Validation

**Files:**
- Modify: `기획서/50_제작_검증/PLAYTEST_PLAN.md`
- Add evidence under the repository's established evidence path.

**Interfaces:**
- Consumes: built Android artifact and fixed test seeds.
- Produces: captures and structured PASS/REVISE findings only.

- [ ] **Step 1: Run the full automated regression suite**

Expected: existing tests plus all new profile/cosmetic tests pass with zero failures.

- [ ] **Step 2: Capture default and representative skin on Android aspect variants**

Required captures:

```text
PREP view
ACTIVE_RUN with 0 cargo
ACTIVE_RUN with 8 tokens
switch preview
station delivery
low-fuel warning
result screen
collection preview
```

- [ ] **Step 3: Compare readability and geometry**

Verify:
- active route and station glyph contrast preserved;
- rear token remains identifiable;
- locomotive skin does not cover route preview or pickup;
- collision/occupied cells remain equal;
- Reduced Motion and mute states preserve all P0/P1 information.

- [ ] **Step 4: Conduct at least five-person comprehension test**

Acceptance:
- at least 4/5 state that the cosmetic does not improve performance;
- at least 4/5 identify standard personal records;
- no participant believes a locked cosmetic is required to improve score;
- result→restart flow is not delayed by collection prompts.

- [ ] **Step 5: Record honest evidence states**

Use `AUTOMATED_PASS`, `ANDROID_PASS`, and `HUMAN_PASS` only when their respective evidence exists. Otherwise retain `NOT_RUN` or `REVISE`.

- [ ] **Step 6: Commit evidence**

```bash
git add 기획서/50_제작_검증/PLAYTEST_PLAN.md evidence
git commit -m "test: validate cosmetic fairness and profile records"
```

---

## Self-Review Checklist

- Every spec requirement maps to a task.
- No task introduces gameplay upgrades, currency, prices, shop, season, ads, payment, or leaderboard.
- `assisted_first_run` is excluded by an explicit policy, not UI convention.
- Cosmetic definitions contain no modifier field.
- Collision, footprint, seed, speed, fuel, score, and record eligibility have parity tests.
- Save migration preserves unrelated valid data and has default cosmetic fallback.
- Result UI and Collection UI cannot own run-end or profile authority.
- Android and human claims remain unpassed until evidence exists.

## Rollback

- Profile record failure: disable profile write and keep result/restart functioning; do not alter RunState.
- Cosmetic registry failure: force all categories to their default cosmetic.
- Asset readability failure: remove the failing cosmetic from the registry without deleting valid records.
- Migration failure: preserve the original save backup, create a default normalized profile, and record a bounded migration error.

This plan is not an implementation authorization. Keep `CODEX_NOT_READY` until GMB-001 reaches 10/10, the full pre-merge audit passes, and the executable VS goal is explicitly promoted to `READY_FOR_BUILD`.
