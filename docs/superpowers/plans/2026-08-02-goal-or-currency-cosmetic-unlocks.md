# Goal-or-Currency Cosmetic Unlocks Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** DUAL_PATH 꾸미기는 목표 달성 또는 꾸미기 전용 재화 구매로, CURRENCY_ONLY 꾸미기는 재화 구매로 해금하며 구매·목표·대체 보상을 원자적이고 멱등적으로 Profile에 저장한다.

**Architecture:** 기존 `ProfileSchema`, `ProfileStore`, `CosmeticRegistry`, `CosmeticCollectionState` 위에 경제 metadata를 분리한 `CosmeticUnlockDefinition/Registry`를 추가한다. authoritative run evidence는 `GoalEligibilityPolicy`와 `CosmeticGoalProgress`를 거쳐 `CosmeticUnlockService`에 전달되고, 구매 요청은 `CosmeticCurrencyWallet`과 같은 service 안에서 단일 Profile transaction으로 처리한다. UI는 progress·price·purchase intent만 표시·전달하며 balance·goal·unlock 상태의 권위가 아니다.

**Tech Stack:** Godot 4.7.1, GDScript, Resource/JSON registry, versioned local Profile, 기존 headless test runner, Android landscape UI validation.

## Global Constraints

- Decision: `SX-DEC-020`; Evidence: `EV-USER-009`; GMB-001 slot `4/10`.
- Unlock modes are exactly `DEFAULT`, `DUAL_PATH`, `CURRENCY_ONLY`; `GOAL_ONLY` is not supported.
- DUAL_PATH unlocks by eligible goal completion or currency purchase.
- CURRENCY_ONLY has no goal and unlocks only by currency purchase.
- Currency purchase never marks a goal complete or grants an achievement marker.
- If a purchased DUAL_PATH cosmetic's goal is completed later, grant one bounded one-time compensation instead of duplicate ownership.
- Goal evidence excludes assisted first run, ruleset mismatch, invalid integrity, incomplete run, and duplicate event IDs.
- Currency debit and unlock must be atomic and idempotent.
- Cosmetic unlock route cannot change speed, fuel, score, capacity, BOOST, collision, footprint, seed, camera, onboarding, or record eligibility.
- Prices and compensation are `TEST_VALUE`; general run currency earning is reserved for `SX-DEC-021`.
- Real-money purchase, ads, seasons, loot boxes, limited-time FOMO, and online account sync are out of scope.
- Product implementation does not start before GMB-001 10/10 and `READY_FOR_BUILD`.

---

## Planned File Map

```text
game/profile/profile_schema.gd
→ Add currency, completed goal IDs, provenance, processed transaction journal

game/progression/cosmetic_unlock_definition.gd
→ Immutable unlock metadata without gameplay modifiers

game/progression/cosmetic_unlock_registry.gd
→ Validate DEFAULT/DUAL_PATH/CURRENCY_ONLY definitions and lookup by cosmetic_id/goal_id

game/progression/goal_eligibility_policy.gd
→ Decide whether a RunSummary can advance cosmetic goals

game/progression/cosmetic_goal_progress.gd
→ Idempotent goal progress and completion state

game/progression/cosmetic_currency_wallet.gd
→ Bounded grant/debit arithmetic only

game/progression/cosmetic_unlock_service.gd
→ Sole authority for goal unlock, purchase, compensation, provenance, transaction results

game/ui/cosmetic_unlock_view_model.gd
→ Convert registry/profile state into display-only locked/goal/price/purchased states

game/ui/collection_panel.gd
→ Show goal progress, price, currency-only label, purchase intent

tests/profile/test_profile_unlock_economy_migration.gd
tests/progression/test_cosmetic_unlock_registry.gd
tests/progression/test_goal_eligibility_policy.gd
tests/progression/test_cosmetic_goal_progress.gd
tests/progression/test_cosmetic_currency_wallet.gd
tests/progression/test_cosmetic_unlock_service.gd
tests/ui/test_cosmetic_unlock_view_model.gd
tests/integration/test_cosmetic_unlock_profile_transaction.gd
```

---

### Task 1: Extend the Versioned Profile Schema

**Files:**
- Modify: `game/profile/profile_schema.gd`
- Create: `tests/profile/test_profile_unlock_economy_migration.gd`

**Interfaces:**
- Consumes: existing `ProfileSchema.create_default()`, `normalize()`, `migrate()`.
- Produces profile fields:
  - `cosmetic_currency_balance: int`
  - `completed_cosmetic_goal_ids: Array[String]`
  - `unlock_provenance_by_cosmetic_id: Dictionary`
  - `processed_progression_event_ids: Array[String]`
- Preserves existing records and cosmetic selection fields.

- [ ] **Step 1: Write the failing default-field test**

```gdscript
func test_default_profile_contains_unlock_economy_fields() -> void:
    var profile := ProfileSchema.create_default()
    assert_eq(profile.cosmetic_currency_balance, 0)
    assert_eq(profile.completed_cosmetic_goal_ids, [])
    assert_eq(profile.processed_progression_event_ids, [])
    assert_eq(
        profile.unlock_provenance_by_cosmetic_id["locomotive.default"],
        "DEFAULT"
    )
```

- [ ] **Step 2: Run and verify RED**

```bash
godot --headless --path . -s res://tests/run_single.gd -- tests/profile/test_profile_unlock_economy_migration.gd
```

Expected: missing fields.

- [ ] **Step 3: Increment the schema and add defaults**

```gdscript
const CURRENT_VERSION := 2
const MAX_PROCESSED_PROGRESSION_EVENTS := 256

static func _unlock_economy_defaults() -> Dictionary:
    return {
        "cosmetic_currency_balance": 0,
        "completed_cosmetic_goal_ids": [],
        "unlock_provenance_by_cosmetic_id": {
            "locomotive.default": "DEFAULT",
        },
        "processed_progression_event_ids": [],
    }
```

Merge these fields into `create_default()` without changing competitive record defaults.

- [ ] **Step 4: Write migration and normalization tests**

```gdscript
func test_v1_migration_preserves_unlocks_and_marks_them_migrated() -> void:
    var v1 := {
        "profile_schema_version": 1,
        "competitive_records": {"best_score": 900},
        "unlocked_cosmetic_ids": ["locomotive.default", "locomotive.old_skin"],
        "selected_cosmetic_by_category": {"LOCOMOTIVE_SKIN": "locomotive.old_skin"},
    }
    var migrated := ProfileSchema.migrate(v1)
    assert_eq(migrated.competitive_records.best_score, 900)
    assert_true(migrated.unlocked_cosmetic_ids.has("locomotive.old_skin"))
    assert_eq(migrated.unlock_provenance_by_cosmetic_id["locomotive.old_skin"], "MIGRATED")
    assert_eq(migrated.cosmetic_currency_balance, 0)

func test_normalize_repairs_negative_currency_and_bounds_journal() -> void:
    var raw := ProfileSchema.create_default()
    raw.cosmetic_currency_balance = -99
    raw.processed_progression_event_ids = []
    for index in range(ProfileSchema.MAX_PROCESSED_PROGRESSION_EVENTS + 20):
        raw.processed_progression_event_ids.append("event_%d" % index)
    var normalized := ProfileSchema.normalize(raw)
    assert_eq(normalized.cosmetic_currency_balance, 0)
    assert_eq(
        normalized.processed_progression_event_ids.size(),
        ProfileSchema.MAX_PROCESSED_PROGRESSION_EVENTS
    )
```

- [ ] **Step 5: Implement deterministic migration and bounded normalization**

Requirements:
- negative/non-integer currency becomes zero;
- completed goal IDs and event IDs are deduplicated strings;
- event journal keeps the newest 256 IDs;
- existing unlocked IDs missing provenance become `MIGRATED`;
- default item is always `DEFAULT`;
- unknown fields do not destroy valid existing fields.

- [ ] **Step 6: Run focused tests and verify GREEN**

- [ ] **Step 7: Commit**

```bash
git add game/profile/profile_schema.gd tests/profile/test_profile_unlock_economy_migration.gd
git commit -m "feat: extend profile for cosmetic unlock economy"
```

---

### Task 2: Define and Validate Unlock Metadata

**Files:**
- Create: `game/progression/cosmetic_unlock_definition.gd`
- Create: `game/progression/cosmetic_unlock_registry.gd`
- Create: `tests/progression/test_cosmetic_unlock_registry.gd`

**Interfaces:**
- Produces `CosmeticUnlockDefinition` fields:
  - `cosmetic_id: StringName`
  - `unlock_mode: StringName`
  - `goal_id: StringName`
  - `currency_price: int`
  - `goal_completion_compensation: int`
  - `catalog_version: int`
- Produces `CosmeticUnlockRegistry.get_by_cosmetic_id(id) -> CosmeticUnlockDefinition`.
- Produces `CosmeticUnlockRegistry.get_by_goal_id(goal_id) -> CosmeticUnlockDefinition`.

- [ ] **Step 1: Write failing validation matrix tests**

```gdscript
func test_dual_path_requires_goal_and_positive_price() -> void:
    var definition := CosmeticUnlockDefinition.new(
        &"locomotive.goal_sample", &"DUAL_PATH", &"goal.combo_3", 100, 25, 1
    )
    assert_true(definition.validate().is_empty())

func test_currency_only_rejects_goal_id() -> void:
    var definition := CosmeticUnlockDefinition.new(
        &"locomotive.currency_sample", &"CURRENCY_ONLY", &"goal.invalid", 150, 0, 1
    )
    assert_true(definition.validate().has("CURRENCY_ONLY_GOAL_NOT_ALLOWED"))

func test_default_rejects_price() -> void:
    var definition := CosmeticUnlockDefinition.new(
        &"locomotive.default", &"DEFAULT", &"", 1, 0, 1
    )
    assert_true(definition.validate().has("DEFAULT_PRICE_MUST_BE_ZERO"))
```

- [ ] **Step 2: Run and verify RED**

- [ ] **Step 3: Implement immutable definition and validation**

```gdscript
class_name CosmeticUnlockDefinition
extends RefCounted

const MODE_DEFAULT := &"DEFAULT"
const MODE_DUAL_PATH := &"DUAL_PATH"
const MODE_CURRENCY_ONLY := &"CURRENCY_ONLY"

var cosmetic_id: StringName
var unlock_mode: StringName
var goal_id: StringName
var currency_price: int
var goal_completion_compensation: int
var catalog_version: int
```

`validate()` must reject unknown modes, empty IDs, negative values, duplicate goal IDs, and mode-field mismatches.

- [ ] **Step 4: Add registry tests with the representative fixture**

```gdscript
func representative_definitions() -> Array[CosmeticUnlockDefinition]:
    return [
        CosmeticUnlockDefinition.new(&"locomotive.default", &"DEFAULT", &"", 0, 0, 1),
        CosmeticUnlockDefinition.new(&"locomotive.goal_sample", &"DUAL_PATH", &"goal.combo_3", 100, 25, 1),
        CosmeticUnlockDefinition.new(&"locomotive.currency_sample", &"CURRENCY_ONLY", &"", 150, 0, 1),
    ]
```

Assert exact lookup, no duplicate cosmetic IDs, no duplicate goal IDs, and all three modes present.

- [ ] **Step 5: Implement registry validation and lookup**

- [ ] **Step 6: Run focused tests and verify GREEN**

- [ ] **Step 7: Commit**

```bash
git add game/progression/cosmetic_unlock_definition.gd game/progression/cosmetic_unlock_registry.gd tests/progression/test_cosmetic_unlock_registry.gd
git commit -m "feat: define cosmetic unlock catalog modes"
```

---

### Task 3: Separate Goal Evidence Eligibility

**Files:**
- Create: `game/progression/goal_eligibility_policy.gd`
- Create: `tests/progression/test_goal_eligibility_policy.gd`

**Interfaces:**
- Consumes immutable `RunSummary` Dictionary and current goal ruleset ID.
- Produces `GoalEligibilityPolicy.evaluate(summary, current_ruleset_id) -> Dictionary` with `eligible` and `reason_code`.

- [ ] **Step 1: Write the failing eligibility tests**

```gdscript
func test_valid_standard_run_is_goal_eligible() -> void:
    var result := GoalEligibilityPolicy.evaluate({
        "run_completed": true,
        "assisted_first_run": false,
        "ruleset_id": "goals.v1",
        "integrity_state": "VALID",
    }, &"goals.v1")
    assert_true(result.eligible)

func test_assisted_run_is_not_goal_eligible() -> void:
    var result := GoalEligibilityPolicy.evaluate({
        "run_completed": true,
        "assisted_first_run": true,
        "ruleset_id": "goals.v1",
        "integrity_state": "VALID",
    }, &"goals.v1")
    assert_false(result.eligible)
    assert_eq(result.reason_code, &"ASSISTED_RUN")
```

Also cover incomplete, mismatch, invalid integrity, and missing fields.

- [ ] **Step 2: Run and verify RED**

- [ ] **Step 3: Implement fail-closed evaluation**

Use reason codes:

```text
ELIGIBLE
RUN_INCOMPLETE
ASSISTED_RUN
RULESET_MISMATCH
INTEGRITY_INVALID
```

- [ ] **Step 4: Run tests and verify GREEN**

- [ ] **Step 5: Commit**

```bash
git add game/progression/goal_eligibility_policy.gd tests/progression/test_goal_eligibility_policy.gd
git commit -m "feat: gate cosmetic goals by valid run evidence"
```

---

### Task 4: Implement Idempotent Goal Progress

**Files:**
- Create: `game/progression/cosmetic_goal_progress.gd`
- Create: `tests/progression/test_cosmetic_goal_progress.gd`

**Interfaces:**
- Consumes normalized Profile, goal definition fixture, eligible evidence, unique event ID.
- Produces `apply_evidence(profile, goal_id, progress_delta, target, event_id, eligibility) -> Dictionary`.
- Result fields: `profile`, `progressed`, `completed_now`, `reason_code`.

- [ ] **Step 1: Write failing progress and duplicate-event tests**

```gdscript
func test_goal_completes_once_at_target() -> void:
    var profile := ProfileSchema.create_default()
    var first := CosmeticGoalProgress.apply_evidence(
        profile, &"goal.combo_3", 2, 3, &"run_1:combo", {"eligible": true}
    )
    assert_false(first.completed_now)
    var second := CosmeticGoalProgress.apply_evidence(
        first.profile, &"goal.combo_3", 1, 3, &"run_2:combo", {"eligible": true}
    )
    assert_true(second.completed_now)
    assert_true(second.profile.completed_cosmetic_goal_ids.has("goal.combo_3"))

func test_duplicate_event_does_not_add_progress_twice() -> void:
    var profile := ProfileSchema.create_default()
    var first := CosmeticGoalProgress.apply_evidence(
        profile, &"goal.combo_3", 1, 3, &"run_1:combo", {"eligible": true}
    )
    var duplicate := CosmeticGoalProgress.apply_evidence(
        first.profile, &"goal.combo_3", 1, 3, &"run_1:combo", {"eligible": true}
    )
    assert_false(duplicate.progressed)
    assert_eq(duplicate.reason_code, &"EVENT_ALREADY_PROCESSED")
```

- [ ] **Step 2: Run and verify RED**

- [ ] **Step 3: Add bounded goal progress storage to the schema**

Use:

```text
cosmetic_goal_progress_by_id: Dictionary[String, int]
```

Normalize negative progress to zero and completed goals to at least their target when loaded through content reconciliation.

- [ ] **Step 4: Implement fail-closed, idempotent progress**

- ineligible evidence returns without profile mutation;
- non-positive delta is rejected;
- completed goal ignores later progress events;
- event ID is recorded only when progress mutation succeeds;
- goal completion marker is independent of cosmetic ownership.

- [ ] **Step 5: Run tests and verify GREEN**

- [ ] **Step 6: Commit**

```bash
git add game/profile/profile_schema.gd game/progression/cosmetic_goal_progress.gd tests/progression/test_cosmetic_goal_progress.gd
git commit -m "feat: track idempotent cosmetic goal progress"
```

---

### Task 5: Implement the Bounded Cosmetic Currency Wallet

**Files:**
- Create: `game/progression/cosmetic_currency_wallet.gd`
- Create: `tests/progression/test_cosmetic_currency_wallet.gd`

**Interfaces:**
- Produces `grant(profile, amount, event_id, reason_code) -> Dictionary`.
- Produces `can_debit(profile, amount) -> bool`.
- Produces `debit(profile, amount, event_id, reason_code) -> Dictionary`.
- Result fields: `profile`, `changed`, `amount`, `balance`, `reason_code`.

- [ ] **Step 1: Write failing grant/debit boundary tests**

```gdscript
func test_debit_rejects_insufficient_balance_without_mutation() -> void:
    var profile := ProfileSchema.create_default()
    profile.cosmetic_currency_balance = 40
    var result := CosmeticCurrencyWallet.debit(profile, 100, &"purchase_1", &"COSMETIC_PURCHASE")
    assert_false(result.changed)
    assert_eq(result.reason_code, &"INSUFFICIENT_BALANCE")
    assert_eq(result.profile.cosmetic_currency_balance, 40)

func test_duplicate_grant_event_is_idempotent() -> void:
    var profile := ProfileSchema.create_default()
    var first := CosmeticCurrencyWallet.grant(profile, 25, &"goal_1_reward", &"GOAL_COMPENSATION")
    var duplicate := CosmeticCurrencyWallet.grant(first.profile, 25, &"goal_1_reward", &"GOAL_COMPENSATION")
    assert_eq(duplicate.profile.cosmetic_currency_balance, 25)
    assert_false(duplicate.changed)
```

- [ ] **Step 2: Run and verify RED**

- [ ] **Step 3: Implement checked integer arithmetic**

Set:

```gdscript
const MAX_COSMETIC_CURRENCY := 2_000_000_000
```

Reject negative amount, overflow, zero-value debit, insufficient balance, and duplicate event IDs. General run rewards are not connected in this task.

- [ ] **Step 4: Run tests and verify GREEN**

- [ ] **Step 5: Commit**

```bash
git add game/progression/cosmetic_currency_wallet.gd tests/progression/test_cosmetic_currency_wallet.gd
git commit -m "feat: add bounded cosmetic currency wallet"
```

---

### Task 6: Implement the Sole Unlock Authority

**Files:**
- Create: `game/progression/cosmetic_unlock_service.gd`
- Create: `tests/progression/test_cosmetic_unlock_service.gd`

**Interfaces:**
- Consumes normalized Profile and `CosmeticUnlockRegistry`.
- Produces `handle_goal_completion(profile, goal_id, transaction_id) -> Dictionary`.
- Produces `purchase(profile, cosmetic_id, transaction_id) -> Dictionary`.
- Result fields: `profile`, `unlocked_now`, `currency_delta`, `goal_completed`, `reason_code`, `provenance`.

- [ ] **Step 1: Write failing DUAL_PATH goal-unlock test**

```gdscript
func test_dual_path_goal_completion_unlocks_free() -> void:
    var profile := ProfileSchema.create_default()
    profile.completed_cosmetic_goal_ids.append("goal.combo_3")
    var result := service.handle_goal_completion(profile, &"goal.combo_3", &"goal_unlock_1")
    assert_true(result.unlocked_now)
    assert_eq(result.currency_delta, 0)
    assert_eq(result.provenance, &"GOAL")
    assert_true(result.profile.unlocked_cosmetic_ids.has("locomotive.goal_sample"))
```

- [ ] **Step 2: Write failing DUAL_PATH purchase-separation test**

```gdscript
func test_dual_path_purchase_unlocks_without_completing_goal() -> void:
    var profile := ProfileSchema.create_default()
    profile.cosmetic_currency_balance = 100
    var result := service.purchase(profile, &"locomotive.goal_sample", &"purchase_1")
    assert_true(result.unlocked_now)
    assert_eq(result.profile.cosmetic_currency_balance, 0)
    assert_false(result.profile.completed_cosmetic_goal_ids.has("goal.combo_3"))
    assert_eq(
        result.profile.unlock_provenance_by_cosmetic_id["locomotive.goal_sample"],
        "CURRENCY_PURCHASE"
    )
```

- [ ] **Step 3: Write failing CURRENCY_ONLY and DEFAULT tests**

- CURRENCY_ONLY purchase succeeds with sufficient balance.
- CURRENCY_ONLY does not resolve by goal lookup.
- DEFAULT purchase is rejected with `DEFAULT_NOT_PURCHASABLE`.

- [ ] **Step 4: Run and verify RED**

- [ ] **Step 5: Implement purchase validation before mutation**

Validation order:

```text
transaction duplicate
→ definition exists
→ already unlocked
→ purchasable mode
→ sufficient balance
→ create copied profile
→ debit and unlock in copied profile
→ attach provenance
→ record transaction ID
→ return committed copy
```

Do not mutate the caller's profile before all validation succeeds.

- [ ] **Step 6: Implement goal completion unlock path**

- only DUAL_PATH definitions may resolve from goal ID;
- locked item: add unlock with GOAL provenance;
- already-owned-by-purchase item: grant compensation once;
- already-owned-by-goal item: no duplicate grant;
- completed goal marker must already be present or be passed in a validated completion result from Task 4.

- [ ] **Step 7: Run focused tests and verify GREEN**

- [ ] **Step 8: Commit**

```bash
git add game/progression/cosmetic_unlock_service.gd tests/progression/test_cosmetic_unlock_service.gd
git commit -m "feat: implement atomic cosmetic unlock paths"
```

---

### Task 7: Verify Compensation After Prior Purchase

**Files:**
- Modify: `tests/progression/test_cosmetic_unlock_service.gd`
- Modify: `game/progression/cosmetic_unlock_service.gd`

**Interfaces:**
- Uses Task 6 methods without adding a second unlock authority.

- [ ] **Step 1: Write failing compensation-once test**

```gdscript
func test_goal_after_purchase_grants_compensation_once() -> void:
    var profile := ProfileSchema.create_default()
    profile.cosmetic_currency_balance = 100
    var bought := service.purchase(profile, &"locomotive.goal_sample", &"purchase_1")
    bought.profile.completed_cosmetic_goal_ids.append("goal.combo_3")

    var completed := service.handle_goal_completion(
        bought.profile, &"goal.combo_3", &"goal_completion_1"
    )
    assert_eq(completed.currency_delta, 25)
    assert_eq(completed.profile.cosmetic_currency_balance, 25)
    assert_eq(
        completed.profile.unlock_provenance_by_cosmetic_id["locomotive.goal_sample"],
        "CURRENCY_PURCHASE"
    )

    var duplicate := service.handle_goal_completion(
        completed.profile, &"goal.combo_3", &"goal_completion_1"
    )
    assert_eq(duplicate.profile.cosmetic_currency_balance, 25)
    assert_eq(duplicate.currency_delta, 0)
```

- [ ] **Step 2: Run and verify RED**

- [ ] **Step 3: Implement compensation through the wallet**

Use a derived event ID that cannot collide with the goal-progress event:

```gdscript
var compensation_event_id := StringName("compensation:%s" % transaction_id)
```

Require compensation `<= currency_price`; reject invalid catalog definitions at registry load.

- [ ] **Step 4: Run tests and verify GREEN**

- [ ] **Step 5: Commit**

```bash
git add game/progression/cosmetic_unlock_service.gd tests/progression/test_cosmetic_unlock_service.gd
git commit -m "feat: compensate completed goals after purchase"
```

---

### Task 8: Integrate Atomic Profile Persistence

**Files:**
- Modify: `game/profile/profile_store.gd`
- Create: `tests/integration/test_cosmetic_unlock_profile_transaction.gd`

**Interfaces:**
- Consumes a pure profile transform callable from `CosmeticUnlockService`.
- Produces `ProfileStore.transact(transaction_id, transform) -> Dictionary`.
- Guarantees one committed result or unchanged previous profile.

- [ ] **Step 1: Write failing rollback test**

```gdscript
func test_failed_save_keeps_previous_balance_and_lock_state() -> void:
    var store := failing_profile_store_with_balance(100)
    var result := store.transact(&"purchase_1", func(profile: Dictionary) -> Dictionary:
        return service.purchase(profile, &"locomotive.goal_sample", &"purchase_1")
    )
    assert_false(result.committed)
    var reloaded := store.load_profile()
    assert_eq(reloaded.cosmetic_currency_balance, 100)
    assert_false(reloaded.unlocked_cosmetic_ids.has("locomotive.goal_sample"))
```

- [ ] **Step 2: Write successful restart/replay test**

Persist a purchase, recreate the store, replay the same transaction ID, and assert no second debit.

- [ ] **Step 3: Run and verify RED**

- [ ] **Step 4: Implement copy-transform-save-swap transaction order**

```text
load normalized current
→ reject processed transaction
→ deep duplicate candidate
→ apply pure transform to candidate
→ atomic temp write + replace
→ swap in-memory current only after replace succeeds
```

- [ ] **Step 5: Run integration tests and verify GREEN**

- [ ] **Step 6: Commit**

```bash
git add game/profile/profile_store.gd tests/integration/test_cosmetic_unlock_profile_transaction.gd
git commit -m "feat: persist cosmetic unlocks atomically"
```

---

### Task 9: Build the Display-Only Unlock View Model

**Files:**
- Create: `game/ui/cosmetic_unlock_view_model.gd`
- Create: `tests/ui/test_cosmetic_unlock_view_model.gd`

**Interfaces:**
- Consumes registry definition, Profile snapshot, localized name/progress strings.
- Produces immutable Dictionary fields:
  - `cosmetic_id`
  - `state`
  - `unlock_mode`
  - `goal_progress_text`
  - `currency_price_text`
  - `show_purchase_button`
  - `show_currency_only_badge`
  - `purchase_enabled`
  - `reason_code`

- [ ] **Step 1: Write failing state matrix tests**

Required states:

```text
OWNED_DEFAULT
OWNED_GOAL
OWNED_PURCHASED
LOCKED_DUAL_PATH
LOCKED_CURRENCY_ONLY
LOCKED_INSUFFICIENT_BALANCE
INVALID_DEFINITION
```

Assert DUAL_PATH shows goal progress and price together. Assert CURRENCY_ONLY hides goal progress and shows a `재화 전용` badge. Assert purchased DUAL_PATH does not show completed goal unless Profile contains the completed goal ID.

- [ ] **Step 2: Run and verify RED**

- [ ] **Step 3: Implement pure view-model construction**

No method in this file may mutate Profile, debit balance, complete goals, or unlock items.

- [ ] **Step 4: Run tests and verify GREEN**

- [ ] **Step 5: Commit**

```bash
git add game/ui/cosmetic_unlock_view_model.gd tests/ui/test_cosmetic_unlock_view_model.gd
git commit -m "feat: present cosmetic unlock routes without authority"
```

---

### Task 10: Wire the Minimal Collection Panel

**Files:**
- Modify: `game/ui/collection_panel.gd`
- Modify: `game/ui/collection_panel.tscn`
- Modify: `tests/ui/test_collection_panel_state.gd`

**Interfaces:**
- Consumes `CosmeticUnlockViewModel` list.
- Emits `purchase_requested(cosmetic_id, client_request_id)` only.
- Does not call wallet, ProfileStore, or goal progress directly.

- [ ] **Step 1: Write failing UI binding tests**

```gdscript
func test_dual_path_card_shows_goal_and_currency_route() -> void:
    panel.render([dual_path_view_model()])
    assert_true(panel.goal_progress_label.visible)
    assert_true(panel.price_label.visible)
    assert_true(panel.purchase_button.visible)

func test_currency_only_card_is_explicitly_labeled() -> void:
    panel.render([currency_only_view_model()])
    assert_false(panel.goal_progress_label.visible)
    assert_true(panel.currency_only_badge.visible)
```

Also verify insufficient balance disables purchase, owned item shows Equip instead of Buy, and 48dp minimum touch target.

- [ ] **Step 2: Run and verify RED**

- [ ] **Step 3: Implement view binding and intent emission**

On purchase tap:

```gdscript
purchase_requested.emit(
    current_view_model.cosmetic_id,
    StringName("client:%s:%d" % [current_view_model.cosmetic_id, Time.get_ticks_usec()])
)
```

The controller layer must replace this client ID with or map it to a persisted transaction ID before calling ProfileStore.

- [ ] **Step 4: Add accessibility and localization checks**

- goal and price are text, not color-only;
- CURRENCY_ONLY badge is localized;
- long Korean/English strings do not cover preview or purchase button;
- Reduced Motion does not remove ownership/progress information;
- collection panel is outside ACTIVE_RUN and cannot cover RESTART.

- [ ] **Step 5: Run UI tests and verify GREEN**

- [ ] **Step 6: Commit**

```bash
git add game/ui/collection_panel.gd game/ui/collection_panel.tscn tests/ui/test_collection_panel_state.gd
git commit -m "feat: show goal and currency cosmetic unlock routes"
```

---

### Task 11: Run Cross-Contract and Android Validation

**Files:**
- Modify: `tests/cosmetics/test_cosmetic_gameplay_parity.gd`
- Create: `tests/integration/test_cosmetic_unlock_end_to_end.gd`
- Modify: `기획서/50_제작_검증/PLAYTEST_PLAN.md`

**Interfaces:**
- Validates Tasks 1-10 and preserves `SX-DEC-019` gameplay parity.

- [ ] **Step 1: Add end-to-end route tests**

Test these exact flows:

```text
eligible goal → DUAL_PATH free unlock → persist → reload
currency purchase → DUAL_PATH unlock → goal remains incomplete
currency purchase → later goal completion → one compensation → persist
currency purchase → CURRENCY_ONLY unlock
assisted run evidence → no goal progress
same event/transaction replay → no duplicate progress/debit/reward
save failure → no partial debit/unlock
```

- [ ] **Step 2: Re-run gameplay parity matrix**

Compare default, DUAL_PATH, and CURRENCY_ONLY equipped states for exact equality of:

```text
speed
fuel_max
fuel_drain
capacity
BOOST multiplier/drain
score formula
collision shape
compact footprint
seed signature
record eligibility
```

Expected: 100% parity.

- [ ] **Step 3: Run the complete automated suite**

```bash
godot --headless --path . -s res://tests/run_all.gd
```

Expected: all existing and new tests pass.

- [ ] **Step 4: Capture Android evidence**

Capture at supported landscape aspect variants:

```text
DUAL_PATH locked: goal + price
DUAL_PATH purchased but goal incomplete
DUAL_PATH goal completed
CURRENCY_ONLY locked with explicit badge
insufficient balance
owned/equipped state
```

Verify safe area, 48dp touch targets, long localization, color+text redundancy, and no performance implication.

- [ ] **Step 5: Conduct 5-person comprehension check**

Ask each participant:

```text
이 꾸미기는 어떻게 얻을 수 있나요?
재화로 샀으면 목표도 달성한 것으로 처리되나요?
재화 전용 꾸미기는 성능이 더 좋은가요?
```

Acceptance:
- 4/5 explain DUAL_PATH correctly;
- 4/5 understand purchase does not complete the goal;
- 5/5 do not infer gameplay power from CURRENCY_ONLY.

- [ ] **Step 6: Update evidence status without overstating it**

Only after actual execution, record automated, Android, and human results separately. Until then keep `NOT_RUN`.

- [ ] **Step 7: Commit**

```bash
git add tests/cosmetics/test_cosmetic_gameplay_parity.gd tests/integration/test_cosmetic_unlock_end_to_end.gd 기획서/50_제작_검증/PLAYTEST_PLAN.md
git commit -m "test: verify cosmetic unlock economy contracts"
```

---

## Plan Self-Review

### Spec coverage

- DEFAULT/DUAL_PATH/CURRENCY_ONLY validation: Task 2.
- Goal eligibility and idempotent progress: Tasks 3-4.
- Bounded currency arithmetic: Task 5.
- Goal or purchase unlock and currency-only placement: Task 6.
- Purchase-before-goal compensation: Task 7.
- Atomic save and replay safety: Task 8.
- UI meaning separation: Tasks 9-10.
- Gameplay parity, Android, and human validation: Task 11.
- General run currency earning remains intentionally excluded for `SX-DEC-021`.

### Placeholder scan

No TBD/TODO or undefined implementation step remains. Representative IDs and numbers are explicitly marked fixture `TEST_VALUE` in the governing spec.

### Type consistency

- `cosmetic_id`, `goal_id`, transaction IDs use `StringName` at service boundaries.
- Profile serialization stores strings and integers.
- Registry lookup and service result field names are consistent across Tasks 2, 6, 7, 9, and 10.
- `CosmeticUnlockService` remains the only unlock authority.
