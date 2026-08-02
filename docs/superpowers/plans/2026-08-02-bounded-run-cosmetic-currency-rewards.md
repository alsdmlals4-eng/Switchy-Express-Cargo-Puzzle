# Bounded Run Cosmetic Currency Rewards Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development or superpowers:executing-plans. Implement with test-driven-development and run verification-before-completion before every completion claim.

**Goal:** 유효한 일반 run에 기본 꾸미기 재화를 지급하고 성공 배송·최고 Combo·표준 신기록에 상한 있는 보너스를 더하며, assist·무조작·중복 종료·저장 재시도에서 경제가 오염되지 않게 한다.

**Architecture:** immutable `RunSummary`와 authoritative `RecordCommitResult`를 입력으로 `RunCurrencyRewardEligibilityPolicy`와 pure `CosmeticCurrencyRewardCalculator`가 grant intent를 만든다. 기존 `CosmeticCurrencyWallet`, `CosmeticProgressionService`, `ProfileStore`가 balance와 processed reward event를 한 transaction에서 commit하고 immutable receipt를 UI에 전달한다. UI와 animation은 표시만 담당한다.

**Tech Stack:** Godot 4.7.1, GDScript, versioned Resource/JSON config, local versioned Profile, headless test runner, Android landscape validation.

## Global Constraints

- Decision: `SX-DEC-021`; Evidence: `EV-USER-010`; GMB-001 slot `5/10`.
- Standard reward requires completed current-ruleset integrity-valid non-debug non-assisted run and at least one successful delivery.
- Survival time and raw score do not directly grant currency.
- Formula v1 TEST_VALUE:
  - base 10;
  - delivery +2 each, cap 10;
  - max Combo highest tier only: 3→2, 5→5, 8→8;
  - any authoritative standard record update +5 once;
  - run total cap 30.
- First-run assist receives no standard variable reward; actual onboarding completion may grant one fixed 10 TEST_VALUE once.
- Reward event handling is atomic and idempotent.
- Result UI displays committed receipt only.
- Real-money, ads, daily missions, seasons, gacha, online sync, and final price tuning are out of scope.
- Product implementation cannot start before GMB-001 10/10, canonical sync, and `READY_FOR_BUILD`.

---

## Planned File Map

```text
game/run/run_summary.gd
→ Ensure stable run_id and reward evidence fields exist

game/profile/profile_schema.gd
→ Add processed reward journal and one-time intro grant state if not already covered

game/progression/cosmetic_currency_reward_policy_config.gd
→ Versioned TEST_VALUE config and validation

game/progression/run_currency_reward_eligibility_policy.gd
→ Standard reward eligibility and rejection codes

game/progression/cosmetic_currency_reward_calculator.gd
→ Pure bounded formula

game/progression/run_currency_reward_receipt.gd
→ Immutable committed/rejected receipt

game/progression/cosmetic_progression_service.gd
→ Atomic idempotent grant authority integrated with existing unlock service

game/ui/result_view_model.gd
→ Add committed reward summary fields

game/ui/result_panel.gd
→ Compact reward summary; animation non-authoritative

tests/run/test_run_summary_reward_evidence.gd
tests/profile/test_profile_reward_migration.gd
tests/progression/test_reward_policy_config.gd
tests/progression/test_run_currency_reward_eligibility_policy.gd
tests/progression/test_cosmetic_currency_reward_calculator.gd
tests/progression/test_cosmetic_progression_reward_transaction.gd
tests/progression/test_onboarding_intro_grant.gd
tests/ui/test_result_reward_view_model.gd
tests/integration/test_run_end_record_reward_order.gd
```

Use actual existing paths after repo inspection. Do not create duplicate services if the SX-DEC-019/020 implementation has already established equivalent names.

---

## Task 1: Confirm Existing Authority and Write an Integration Contract Test

**Files:**
- Inspect: `game/run/run_summary.gd`
- Inspect: `game/profile/profile_schema.gd`
- Inspect: `game/profile/profile_store.gd`
- Inspect: `game/progression/cosmetic_currency_wallet.gd`
- Inspect: `game/progression/cosmetic_unlock_service.gd`
- Inspect: record store / result flow files
- Create: `tests/integration/test_run_end_record_reward_order.gd`

**Purpose:** Stop duplicate ownership before adding code.

- [ ] **Step 1: Inventory actual classes and write a responsibility table**

Required findings:

```text
Who freezes RunSummary?
Who commits standard records?
Who owns Profile transactions?
Who owns cosmetic currency balance?
Who marks processed progression events?
Who builds ResultViewModel?
```

- [ ] **Step 2: Write a failing integration test for required ordering**

```gdscript
func test_record_commit_precedes_reward_calculation_and_ui_receives_receipt() -> void:
    var result := await _finish_valid_run({
        "successful_deliveries": 3,
        "max_combo": 5,
        "score": 999,
    })

    assert_true(result.record_commit.completed)
    assert_true(result.reward_receipt.committed)
    assert_true(result.reward_receipt.record_bonus > 0)
    assert_eq(result.view_model.currency_reward_total, result.reward_receipt.committed_total)
    assert_eq(result.event_order, [
        "RUN_SUMMARY_FROZEN",
        "RECORD_COMMITTED",
        "REWARD_COMMITTED",
        "RESULT_VIEW_MODEL_BUILT",
    ])
```

- [ ] **Step 3: Run and verify RED**

```bash
godot --headless --path . -s res://tests/run_single.gd -- tests/integration/test_run_end_record_reward_order.gd
```

Expected: reward policy classes or ordering are missing.

- [ ] **Step 4: Record the actual file map in the implementation PR**

Do not change product code in this planning branch.

---

## Task 2: Extend RunSummary with Stable Reward Evidence

**Files:**
- Modify: `game/run/run_summary.gd`
- Create: `tests/run/test_run_summary_reward_evidence.gd`

**Required Fields:**

```gdscript
run_id: StringName
completed: bool
end_reason: StringName
successful_delivery_count: int
successful_delivery_event_ids: Array[StringName]
max_combo: int
assisted_first_run: bool
ruleset_version: int
integrity_state: StringName
debug_or_test_run: bool
```

- [ ] **Step 1: Write failing construction and normalization tests**

```gdscript
func test_reward_evidence_is_immutable_and_deduplicated() -> void:
    var summary := RunSummary.new({
        "run_id": &"run_001",
        "completed": true,
        "successful_delivery_count": 3,
        "successful_delivery_event_ids": [&"d1", &"d1", &"d2"],
        "max_combo": 5,
    })
    assert_eq(summary.successful_delivery_event_ids, [&"d1", &"d2"])
    assert_eq(summary.successful_delivery_count, 2)
```

- [ ] **Step 2: Verify RED**

- [ ] **Step 3: Implement bounded normalization**

Rules:

- empty run ID is invalid;
- counts derive from unique successful delivery IDs when IDs exist;
- negative counts and max Combo normalize to zero;
- unknown integrity becomes INVALID, not VALID;
- summary cannot be mutated after freeze.

- [ ] **Step 4: Add evidence corruption tests**

- [ ] **Step 5: Verify focused tests GREEN**

---

## Task 3: Add Versioned Reward Policy Configuration

**Files:**
- Create: `game/progression/cosmetic_currency_reward_policy_config.gd`
- Create: `tests/progression/test_reward_policy_config.gd`

**Interface:**

```gdscript
class_name CosmeticCurrencyRewardPolicyConfig
extends Resource

@export var policy_version: int = 1
@export var base_reward: int = 10
@export var delivery_reward_each: int = 2
@export var delivery_reward_cap: int = 10
@export var combo_tiers: Array[Dictionary] = [
    {"min_combo": 3, "reward": 2},
    {"min_combo": 5, "reward": 5},
    {"min_combo": 8, "reward": 8},
]
@export var new_record_reward: int = 5
@export var new_record_reward_cap_per_run: int = 5
@export var run_total_cap: int = 30
@export var onboarding_intro_grant: int = 10
```

- [ ] **Step 1: Write failing validation matrix tests**

```gdscript
func test_default_v1_config_is_valid() -> void:
    assert_true(CosmeticCurrencyRewardPolicyConfig.default_v1().validate().is_empty())

func test_negative_value_is_rejected() -> void:
    var config := CosmeticCurrencyRewardPolicyConfig.default_v1()
    config.base_reward = -1
    assert_true(config.validate().has("NEGATIVE_REWARD"))

func test_combo_tiers_must_be_strictly_increasing() -> void:
    var config := CosmeticCurrencyRewardPolicyConfig.default_v1()
    config.combo_tiers = [
        {"min_combo": 5, "reward": 5},
        {"min_combo": 3, "reward": 8},
    ]
    assert_true(config.validate().has("COMBO_TIER_ORDER_INVALID"))
```

- [ ] **Step 2: Verify RED**

- [ ] **Step 3: Implement config validation**

Reject:

- policy version <= 0;
- any negative integer;
- non-integer values;
- decreasing or duplicate Combo thresholds;
- decreasing Combo rewards;
- component caps greater than total cap where impossible;
- arithmetic overflow risk.

- [ ] **Step 4: Add invalid-config safe failure test**

Invalid config must disable reward grant without blocking game over, record commit, result display, or restart.

- [ ] **Step 5: Verify GREEN**

---

## Task 4: Implement Standard Run Reward Eligibility

**Files:**
- Create: `game/progression/run_currency_reward_eligibility_policy.gd`
- Create: `tests/progression/test_run_currency_reward_eligibility_policy.gd`

**Output:**

```gdscript
class_name RunCurrencyRewardEligibility
extends RefCounted

var eligible: bool
var code: StringName
```

Recommended codes:

```text
ELIGIBLE
INCOMPLETE_RUN
NO_SUCCESSFUL_DELIVERY
ASSISTED_FIRST_RUN
RULESET_MISMATCH
INTEGRITY_INVALID
DEBUG_OR_TEST_RUN
MISSING_RUN_ID
MISSING_EVIDENCE
ALREADY_PROCESSED
POLICY_INVALID
```

- [ ] **Step 1: Write a table-driven failing test**

```gdscript
func test_eligibility_matrix() -> void:
    var cases := [
        [_valid_summary(), true, &"ELIGIBLE"],
        [_valid_summary({"completed": false}), false, &"INCOMPLETE_RUN"],
        [_valid_summary({"successful_delivery_count": 0}), false, &"NO_SUCCESSFUL_DELIVERY"],
        [_valid_summary({"assisted_first_run": true}), false, &"ASSISTED_FIRST_RUN"],
        [_valid_summary({"integrity_state": &"INVALID"}), false, &"INTEGRITY_INVALID"],
        [_valid_summary({"debug_or_test_run": true}), false, &"DEBUG_OR_TEST_RUN"],
    ]
    for case in cases:
        var result := RunCurrencyRewardEligibilityPolicy.evaluate(case[0], _context())
        assert_eq(result.eligible, case[1])
        assert_eq(result.code, case[2])
```

- [ ] **Step 2: Verify RED**

- [ ] **Step 3: Implement deterministic precedence**

The same invalid run must always return the same primary rejection code. Document precedence so telemetry does not drift.

- [ ] **Step 4: Add duplicate event and corrupted evidence tests**

- [ ] **Step 5: Verify GREEN**

---

## Task 5: Implement the Pure Bounded Reward Calculator

**Files:**
- Create: `game/progression/cosmetic_currency_reward_calculator.gd`
- Create: `game/progression/run_currency_reward_receipt.gd`
- Create: `tests/progression/test_cosmetic_currency_reward_calculator.gd`

**Inputs:**

```gdscript
calculate(
    summary: RunSummary,
    eligibility: RunCurrencyRewardEligibility,
    record_commit_result: RecordCommitResult,
    config: CosmeticCurrencyRewardPolicyConfig
) -> RunCurrencyRewardReceipt
```

- [ ] **Step 1: Write failing baseline formula test**

```gdscript
func test_valid_run_receives_bounded_components() -> void:
    var receipt := _calculate({
        "successful_delivery_count": 4,
        "max_combo": 5,
        "updated_record_keys": [&"best_score"],
    })
    assert_eq(receipt.base_reward, 10)
    assert_eq(receipt.delivery_bonus, 8)
    assert_eq(receipt.combo_bonus, 5)
    assert_eq(receipt.record_bonus, 5)
    assert_eq(receipt.raw_total, 28)
    assert_eq(receipt.committed_total, 28)
```

- [ ] **Step 2: Write cap tests**

```gdscript
func test_component_and_total_caps() -> void:
    var receipt := _calculate({
        "successful_delivery_count": 999,
        "max_combo": 999,
        "updated_record_keys": [&"best_score", &"longest_survival", &"best_max_combo"],
    })
    assert_eq(receipt.delivery_bonus, 10)
    assert_eq(receipt.combo_bonus, 8)
    assert_eq(receipt.record_bonus, 5)
    assert_eq(receipt.raw_total, 33)
    assert_eq(receipt.committed_total, 30)
```

- [ ] **Step 3: Write highest-tier-only Combo test**

- [ ] **Step 4: Write no-score/no-survival-direct-reward test**

Two summaries with equal deliveries, Combo, and record result must receive equal reward even if score and survival differ.

- [ ] **Step 5: Verify RED**

- [ ] **Step 6: Implement pure checked arithmetic**

No Profile read/write, signal emission, UI call, or telemetry call inside the calculator.

- [ ] **Step 7: Verify GREEN**

---

## Task 6: Extend Profile Migration and Reward Event Journal

**Files:**
- Modify: `game/profile/profile_schema.gd`
- Create: `tests/profile/test_profile_reward_migration.gd`

**Required Profile Fields:**

```yaml
processed_run_reward_event_ids: Array[String]
onboarding_intro_grant_claimed: bool
last_reward_policy_version_seen: int
```

Reuse an existing general progression journal if it already guarantees bounded idempotency and can distinguish event namespaces. Avoid duplicate journals without reason.

- [ ] **Step 1: Write failing default and migration tests**

- [ ] **Step 2: Verify RED**

- [ ] **Step 3: Implement migration**

Requirements:

- old profiles default to no processed run rewards;
- existing currency and unlocked cosmetics remain unchanged;
- invalid IDs are removed;
- duplicate IDs are deduplicated;
- journal is bounded with newest entries preserved;
- intro grant bool normalizes strictly;
- unknown fields do not destroy valid history.

- [ ] **Step 4: Add partial-corruption recovery tests**

- [ ] **Step 5: Verify GREEN**

---

## Task 7: Add Atomic Idempotent Run Reward Grant

**Files:**
- Modify or create: `game/progression/cosmetic_progression_service.gd`
- Modify: `game/progression/cosmetic_currency_wallet.gd`
- Create: `tests/progression/test_cosmetic_progression_reward_transaction.gd`

**Interface:**

```gdscript
func grant_run_reward(
    reward_event_id: StringName,
    calculated_receipt: RunCurrencyRewardReceipt
) -> RunCurrencyRewardReceipt
```

- [ ] **Step 1: Write failing happy-path transaction test**

```gdscript
func test_grant_commits_balance_and_event_together() -> void:
    var before := _profile_balance()
    var receipt := _service.grant_run_reward(&"run_reward:run_001:policy_v1", _receipt(24))
    assert_true(receipt.committed)
    assert_eq(_profile_balance(), before + 24)
    assert_true(_profile_has_event(&"run_reward:run_001:policy_v1"))
```

- [ ] **Step 2: Write duplicate-event test**

Second call with the same ID must not increase balance.

- [ ] **Step 3: Write rollback test**

Inject ProfileStore failure after staging balance but before commit. Assert balance and journal both remain unchanged.

- [ ] **Step 4: Verify RED**

- [ ] **Step 5: Implement one Profile transaction**

Transaction sequence:

```text
validate receipt
check event journal
read balance
checked add
stage balance
stage processed event
atomic save
return committed receipt
```

- [ ] **Step 6: Implement retry semantics**

- already committed ID returns `ALREADY_COMMITTED` with zero additional grant;
- save failure returns `COMMIT_FAILED` and permits retry with same ID;
- no UI signal before commit success.

- [ ] **Step 7: Verify GREEN**

---

## Task 8: Implement One-Time Onboarding Intro Grant

**Files:**
- Create: `tests/progression/test_onboarding_intro_grant.gd`
- Modify: `game/progression/cosmetic_progression_service.gd`
- Integrate with authoritative onboarding completion owner

**Rules:**

```text
assisted first run standard reward = 0
actual onboarding completion + at least one delivery = intro grant 10 TEST_VALUE once
skip without delivery = 0
repeat completion = 0 additional
```

- [ ] **Step 1: Write four failing tests**

- completed onboarding with delivery grants once;
- repeated event does not grant twice;
- skip without delivery does not grant;
- assisted result never receives delivery/Combo/record bonuses.

- [ ] **Step 2: Verify RED**

- [ ] **Step 3: Implement fixed event namespace**

```text
onboarding_completion:<profile_stable_id>:v1
```

If no profile ID exists, use a singleton fixed event ID stored inside that local Profile rather than inventing online identity.

- [ ] **Step 4: Verify GREEN**

---

## Task 9: Integrate Record Commit and Reward Grant at Run End

**Files:**
- Modify actual RunController/result coordinator
- Modify record store integration
- Complete: `tests/integration/test_run_end_record_reward_order.gd`

- [ ] **Step 1: Add failing test for record bonus source**

```gdscript
func test_ui_new_record_animation_cannot_create_record_bonus() -> void:
    var result := await _finish_run_with_fake_ui_record_flag()
    assert_eq(result.reward_receipt.record_bonus, 0)
```

- [ ] **Step 2: Add partial failure tests**

Cases:

- record commit succeeds, reward save fails;
- reward retry uses same event ID and then succeeds once;
- result screen rebuild after app resume does not re-grant;
- immediate restart does not bypass reward commit ordering or duplicate it.

- [ ] **Step 3: Verify RED**

- [ ] **Step 4: Implement authoritative order**

```text
freeze RunSummary
commit record update
calculate reward using RecordCommitResult
grant reward transaction
build ResultViewModel from receipt
show result
```

The result screen must still appear and RESTART must remain usable when reward policy is invalid or reward commit fails. Display a neutral pending/failure state without fabricating a credited amount.

- [ ] **Step 5: Verify integration test GREEN**

---

## Task 10: Add Compact Result Reward Presentation

**Files:**
- Modify: `game/ui/result_view_model.gd`
- Modify: `game/ui/result_panel.gd`
- Create: `tests/ui/test_result_reward_view_model.gd`

**ViewModel Fields:**

```yaml
currency_reward_state: StringName
currency_reward_total: int
currency_balance_after: int
reward_breakdown_rows: Array[Dictionary]
show_reward_detail: bool
```

- [ ] **Step 1: Write failing view-model tests**

- committed receipt renders total and nonzero component rows;
- rejected ineligible run does not display fake `+0` celebration;
- commit failure displays neutral state;
- assisted intro grant has distinct copy;
- reduced-motion flag changes animation only, not content.

- [ ] **Step 2: Verify RED**

- [ ] **Step 3: Implement minimal presentation**

Default result hierarchy:

```text
Score / Survival / Max Combo / New Record
Failure insight cause + action
Currency reward compact line
RESTART primary
Optional details secondary
```

Do not allow reward breakdown to displace the RESTART primary action.

- [ ] **Step 4: Add localization-length and accessibility fixtures**

- [ ] **Step 5: Verify GREEN**

---

## Task 11: Add Telemetry Without Making It Authoritative

**Files:**
- Modify telemetry event schema or adapter
- Create focused telemetry test if repository uses schema validation

Recommended events:

```text
cosmetic_currency_reward_evaluated
cosmetic_currency_reward_committed
cosmetic_currency_reward_rejected
onboarding_intro_grant_committed
```

- [ ] **Step 1: Verify telemetry consumes immutable receipt only**

- [ ] **Step 2: Add policy version, component totals, eligibility code, and run segment**

- [ ] **Step 3: Ensure no player PII or unnecessary path trace is added**

- [ ] **Step 4: Ensure telemetry failure cannot block reward commit, result, or restart**

- [ ] **Step 5: Run telemetry schema tests**

---

## Task 12: Economy Simulation and Anti-Farm Validation

**Files:**
- Create: `tools/simulate_cosmetic_currency_economy.gd` or repository-standard analysis script
- Create: `tests/fixtures/cosmetic_currency_run_samples.json`
- Do not harden final prices in product code during this task

- [ ] **Step 1: Prepare representative run cohorts**

```text
new player: 1~2 deliveries, max Combo 1~3
mid player: 3~5 deliveries, max Combo 3~6
high player: 6+ deliveries, max Combo 8+
short farm: exactly 1 delivery then intentional end
idle run: 0 deliveries, long survival
assisted first run
```

- [ ] **Step 2: Simulate reward distributions**

Report:

- reward per run;
- reward per active minute;
- 10th/50th/90th percentile;
- short-farm efficiency relative to normal play;
- runs to representative DUAL_PATH and CURRENCY_ONLY item prices.

- [ ] **Step 3: Adversarially test exploit strategies**

- one delivery then immediate fail;
- restart spam;
- duplicate terminal event;
- save failure retry;
- assist replay;
- record bonus manipulation by tiny incremental records.

- [ ] **Step 4: Keep results as evidence, not silent permanent tuning**

Any formula or price change after simulation requires Decision/TEST_VALUE update and same-ID synchronization.

---

## Task 13: Full Automated Regression

**Files:** none unless defects are found.

- [ ] **Step 1: Run focused reward suite**

```bash
godot --headless --path . -s res://tests/run_single.gd -- tests/progression/test_reward_policy_config.gd
godot --headless --path . -s res://tests/run_single.gd -- tests/progression/test_run_currency_reward_eligibility_policy.gd
godot --headless --path . -s res://tests/run_single.gd -- tests/progression/test_cosmetic_currency_reward_calculator.gd
godot --headless --path . -s res://tests/run_single.gd -- tests/progression/test_cosmetic_progression_reward_transaction.gd
godot --headless --path . -s res://tests/run_single.gd -- tests/progression/test_onboarding_intro_grant.gd
godot --headless --path . -s res://tests/run_single.gd -- tests/integration/test_run_end_record_reward_order.gd
```

- [ ] **Step 2: Run all Profile/progression/result tests**

- [ ] **Step 3: Run full project test command**

Use repository authority rather than guessing a command.

- [ ] **Step 4: Run Project Contract validation**

- [ ] **Step 5: Confirm no gameplay parity changes**

Identical seeded runs with reward system enabled/disabled must produce identical speed, fuel, cargo, score, Combo, spawn, collision, and termination results.

---

## Task 14: Android Runtime and Human Validation

- [ ] **Step 1: Build repository-approved Android target**

- [ ] **Step 2: Validate result layout on supported aspect variants**

Capture:

- eligible standard reward;
- capped reward;
- no-delivery rejection;
- intro grant;
- reward commit failure neutral state;
- Reduced Motion.

- [ ] **Step 3: Validate rapid restart and lifecycle interruption**

Scenarios:

- tap RESTART repeatedly;
- background during result entry;
- terminate after record commit before reward retry;
- resume and rebuild result;
- rotate only if platform policy permits orientation change.

Expected duplicate grants: 0.

- [ ] **Step 4: Run 5+ person comprehension test**

Questions:

- What caused currency to be earned?
- Does merely surviving earn it?
- Was the first-run grant a recurring reward?
- Can replaying the result animation grant more?
- Is RESTART still obvious?

Acceptance baseline: 4/5 correct on each core rule, subject to later approved adjustment.

---

## Task 15: Documentation and Canonical Synchronization

Only execute after GMB-001 10/10 pre-merge audit authorizes propagation.

**Consumers:**

```text
기획서/20_시스템_콘텐츠/CORE_SYSTEMS.md
기획서/40_표현/VISUAL_DIRECTION.md
기획서/50_제작_검증/PLAYTEST_PLAN.md
기획서/00_프로젝트_허브/EXECUTABLE_PROMPTS/CODEX_GOAL_VS_03.md
Decision Registry / evidence registry
correct Google Sheet 12 tabs
```

- [ ] **Step 1: Propagate the same `SX-DEC-021` and `EV-USER-010`**

- [ ] **Step 2: Preserve `TEST_VALUE` labels on all numeric values**

- [ ] **Step 3: Record actual implementation commit and evidence paths**

- [ ] **Step 4: Run stale-reference and duplicate-authority checks**

- [ ] **Step 5: Perform Sheet 12-tab readback**

- [ ] **Step 6: Mark `SYNCED` only after canonical merge and closure**

---

## Definition of Done

The implementation is not complete until fresh evidence proves all of the following:

- standard eligibility rejects 0-delivery, assisted, incomplete, invalid, mismatch, and debug runs;
- formula v1 produces exact bounded component values;
- no direct score or survival reward exists;
- Combo pays highest tier only;
- record bonus uses authoritative `RecordCommitResult` and pays once per run;
- run total cap is enforced;
- duplicate event, restart spam, save retry, and resume produce zero duplicate grants;
- Profile migration preserves records, unlocks, selection, and existing currency;
- one-time intro grant is truly one-time and requires actual completion with delivery;
- result UI displays committed receipt only and keeps RESTART primary;
- reward system does not change gameplay simulation;
- focused tests, full tests, Project Contract, Android validation, economy simulation, and 5+ person validation have recorded evidence;
- Decision, Evidence, GitHub canon, PR, Issue, and correct Sheet share the same IDs and state.

Until those checks run, status remains `IMPLEMENTATION_NOT_STARTED / NOT_RUN / CODEX_NOT_READY`.
