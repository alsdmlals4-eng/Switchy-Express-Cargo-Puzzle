# VS-03 Build Segmentation Plan

```yaml
audit_id: SX-AUD-005
evidence_id: EV-USER-016
status: PLANNING_ONLY · READY_FOR_BUILD_CANDIDATE
execution_order: VS03-01_TO_VS03-07
product_implementation: NOT_STARTED
```

> Implementation must use the repository's current custom test runner and the execution architecture in `docs/superpowers/specs/2026-08-02-vs03-execution-architecture-design.md`. This plan supersedes conflicting file paths, test commands, runner APIs, and package ordering in older Decision-specific plans while preserving their approved behavior.

## 1. Universal Gate for Every Package

Before work:

- fetch latest `main`
- confirm previous package is merged
- create a dedicated branch
- read current canon, this plan, execution architecture, and package-specific Decision plans
- do not copy unsupported `run(test)`, `test.case`, `run_single.gd`, or `--suite` examples

Before merge:

```text
behind 0
+ package file ownership respected
+ Project Contract success
+ Godot Tests success
+ unresolved review threads 0
+ REQUEST_CHANGES 0
+ package acceptance tests registered in tests/run_tests.gd
+ no deferred Production/online scope
= package merge authorized
```

Each package PR body must list:

- Decisions consumed
- exact files created/modified
- public API changes
- rollback path
- automated evidence
- explicit `NOT_RUN` evidence

## 2. VS03-01 — Authoritative Run Lifecycle and Difficulty Core

### Decisions

`SX-DEC-009`, `010`, `014`, local authority portion of `017`, `018`, `021`, `022`, `023`.

### Goal

Create a deterministic run lifecycle around the existing Train/Cargo/Delivery foundation without UI, Profile, map catalog, or onboarding coupling.

### Files owned

Create:

```text
game/run/run_balance.gd
game/run/run_state.gd
game/run/run_summary.gd
game/run/run_controller.gd
game/run/run_metrics_accumulator.gd
game/difficulty/difficulty_forecast.gd
game/difficulty/difficulty_event.gd
game/difficulty/difficulty_director.gd
```

Modify:

```text
game/train/train_controller.gd
tests/test_case.gd
tests/run_tests.gd
```

`TrainController` modification is limited to a read-only `seconds_to_next_cell()` and route-history/path-sampling seam. Existing movement meaning must not change.

### TDD order

1. Add minimal assertion helpers to `TestCase`.
2. Run existing 9 suites unchanged.
3. Add pure RunBalance boundary tests.
4. Add RunState and immutable RunSummary tests.
5. Add DifficultyDirector schedule/pause/restart tests.
6. Add boundary-sliced RunController tests.
7. Add no-input finite survival and fuel-zero-once tests.
8. Add Combo equality tests using existing `unload_result.count`.
9. Add exact timestamp tie test: cell event before fuel-zero evaluation.
10. Full regression.

### Acceptance

- no-input run reaches fuel zero within configured bound
- fuel-zero emits exactly once
- no movement/pickup/unload after end
- `combo_count == unload_result.count`
- `max_combo` and speed bonus separate
- cargo slowdown does not reduce fuel drain
- BOOST always costs extra fuel and keeps LOAD blocked
- warning UI absence cannot change difficulty commit sequence
- pause/assist-ready flags pause authoritative clocks without wall-clock catch-up
- existing 9 suites remain green

### Rollback

No save, scene, resource, asset, or catalog changes. Revert PR as one unit.

---

## 3. VS03-02 — Compact Tokens and Spawn Occupancy Seam

### Decisions

`SX-DEC-015` plus protected existing spawn rules.

### Goal

Replace full-cell cargo occupancy assumptions with a compressed footprint while preserving existing DeliveryLoop APIs and tests.

### Files owned

Create:

```text
game/train/compact_wagon_token_state.gd
game/train/train_footprint.gd
tests/train/test_compact_wagon_tokens.gd
tests/train/test_train_footprint.gd
tests/integration/test_compact_footprint_respawn.gd
```

Modify:

```text
game/delivery/delivery_loop.gd
game/train/train_controller.gd
tests/integration/test_delivery_loop.gd
tests/run_tests.gd
```

### API rule

`DeliveryLoop.configure()` gains an optional occupancy provider. Legacy null-provider behavior remains `train.train_cells()`. Product composition later injects `TrainFootprint`.

### TDD order

1. Existing DeliveryLoop compatibility remains green.
2. Token count/order/rear tests for 0..8.
3. Geometry and fractional path sample tests.
4. Occupied-cell tests for straight/curve/switch.
5. 8-token trailing footprint `<=3`.
6. Respawn exclusion with compressed footprint and forward route.
7. Same event updates stack/token/footprint once.

### Acceptance

- token count equals CargoStack size
- front-to-rear equals stack bottom-to-top
- rear equals stack top
- no token path cutting/order swap
- full-cell compatibility still works only as fallback
- production seam can inject compressed footprint
- no spawn inside occupied or forward exclusion cells

### Rollback

Provider is optional, so reverting restores previous behavior without changing existing signatures.

---

## 4. VS03-03 — Map Identity, Target-3 Catalog, Fresh Session, Restart and Selection

### Decisions

`SX-DEC-023`, `SX-DEC-024`, local record identity prerequisite from `SX-DEC-025`.

### Goal

Build exactly three validated official maps, fresh attempt sessions, exact same-map restart, undiscovered-first automatic selection, and discovered-map reselection domain APIs.

### Explicit deferral

Do not implement generator target100 expansion, target100 scan, 100-entry browser, or close `F58`.

### Files owned

Create:

```text
game/map/map_definition.gd
game/map/map_catalog.gd
game/map/map_build_result.gd
game/map/map_build_pipeline.gd
game/map/map_selection_request.gd
game/map/map_selection_receipt.gd
game/map/map_shuffle_bag.gd
game/map/map_discovery_state.gd
game/map/map_selection_service.gd
game/run/run_identity.gd
game/run/run_id_factory.gd
game/run/run_session.gd
game/run/run_session_factory.gd
data/maps/map_catalog_vs03.json
tests/support/map_fixture.gd
tests/map/**
tests/run/test_same_map_restart.gd
tests/integration/test_three_map_discovery_flow.gd
```

Modify narrowly:

```text
game/run/run_controller.gd
tests/run_tests.gd
```

### TDD order

1. Explicit MapDefinition reconstruction fields and validation.
2. Strict duplicate/fallback catalog rejection.
3. Build three non-fallback distinct layouts with current generator.
4. Same seed/version reconstructs signatures.
5. RunIdentity fresh ID/retry lineage.
6. Fully configured RunSessionFactory.
7. restart recreates all mutable services.
8. stale generation callbacks ignored.
9. selection request/receipt semantics.
10. first three AUTO_NEW_RUN starts unique.
11. RESTART/manual consume automatic bag zero.
12. unavailable manual/restart produces explicit failure, no silent map substitution.

### Acceptance

- exact map ID/revision/seed/start/incoming/signatures on restart
- new run ID and fresh service object identities
- score/fuel/stack/spawner/difficulty reset
- session cannot return success while any dependency is unconfigured
- three unique non-fallback layouts
- raw seed absent from UI-facing request/receipt
- `F58` remains NOT_MET

### Rollback

Catalog manifest and all session/catalog code revert together. Runtime generation fallback may not silently replace a selected map.

---

## 5. VS03-04 — Profile Transaction Foundation, Records, Cosmetics, Unlocks and Rewards

### Decisions

`SX-DEC-019`, `020`, `021`, local official-record portion of `025`.

### Goal

Establish one v1 local Profile and one transaction authority before any product UI consumes persistent data.

### Files owned

Create:

```text
game/profile/profile_schema.gd
game/profile/profile_store.gd
game/profile/profile_transaction_service.gd
game/profile/record_eligibility_policy.gd
game/profile/scoped_record_store.gd
game/cosmetics/cosmetic_definition.gd
game/cosmetics/cosmetic_registry.gd
game/cosmetics/cosmetic_collection_state.gd
game/progression/cosmetic_unlock_definition.gd
game/progression/cosmetic_unlock_registry.gd
game/progression/goal_eligibility_policy.gd
game/progression/cosmetic_goal_progress.gd
game/progression/cosmetic_currency_wallet.gd
game/progression/cosmetic_unlock_service.gd
game/progression/run_currency_reward_eligibility_policy.gd
game/progression/cosmetic_currency_reward_calculator.gd
game/progression/run_currency_reward_receipt.gd
```

Tests:

```text
tests/profile/**
tests/cosmetics/**
tests/progression/**
tests/integration/test_run_end_profile_transaction.gd
```

Modify narrowly:

```text
game/run/run_controller.gd
game/run/run_summary.gd
tests/run_tests.gd
```

### Schema v1

Define all VS-03 local persistent fields together:

```text
schema version
official global records
official per-map records
unlocked/selected cosmetics
currency balance
completed goal IDs
unlock provenance
map discovery/recent/favorites/automatic bag state
onboarding preference version/status
bounded processed operation journal
```

No Product user migration is claimed because no prior released profile exists. Migration entry points and corrupt-data recovery are tested for future versions.

### Transaction order at run end

```text
RunSummary frozen
→ eligibility evaluated
→ global/per-map records compared
→ record commit result produced
→ reward calculated from committed result
→ one Profile transaction saves records + reward + any eligible goal progress
→ immutable receipt sent to presentation
```

### Acceptance

- one Profile writer
- atomic temp-write/replace with injectable test backend
- retry same operation ID does not duplicate record/reward/unlock/discovery
- assisted/debug/integrity-invalid/ruleset-mismatch excluded
- global+per-map updates atomic
- record reward component max once
- no direct raw score/survival currency
- cosmetic gameplay modifier fields rejected
- missing asset/selected ID falls back to default
- save failure never blocks result/restart and never mutates RunState

### Rollback

No product UI depends on new assets yet. Revert PR before any released Profile. Later PR reverts must keep Profile v1 reader.

---

## 6. VS03-05 — Product Scene, Camera, HUD, Result and Local Browsers

### Decisions

Presentation portions of `SX-DEC-015`, `017~024`, local `025`.

### Goal

Create the first playable product surface over already merged authoritative services.

### Files owned

Create:

```text
game/play/play_scene.tscn
game/play/play_scene.gd
game/rail/rail_board_view.gd
game/rail/switch_view.gd
game/train/train_view.gd
game/train/compact_wagon_token_view.gd
game/camera/camera_presentation_state.gd
game/camera/camera_profile.gd
game/camera/game_camera_controller.gd
game/ui/preparation_panel.*
game/ui/game_hud.*
game/result/result_insight.gd
game/result/result_insight_analyzer.gd
game/result/result_view_model.gd
game/ui/result_panel.*
game/ui/collection_panel.*
game/map/map_browser_view_model.gd
game/ui/map_browser_panel.*
```

Modify:

```text
game/main/main.gd
game/main/main.tscn
project.godot only when required by actual scene composition
tests/run_tests.gd
```

### TDD order

1. pure camera state and FULL_MAP_READY idempotency.
2. board/view model tests without Scene authority.
3. HUD state tests.
4. result analyzer boundaries and neutral fallback.
5. result ViewModel survives analyzer/save failure.
6. collection/map browser ViewModels.
7. Scene smoke tests.
8. restart/new run/select map semantic input tests.
9. Reduced Motion and instant-complete parity.

### Acceptance

- main only hosts product scene
- PREP may zoom, active run fixed full map
- FULL_MAP_READY is explicit domain gate with failure fallback
- HUD reads score/fuel/speed/time/max Combo/rear item
- result cause 1 + action 1; RESTART primary
- committed records/reward only displayed
- no UI animation triggers save, reward, cargo, game-over, or discovery
- 48dp/safe-area contracts represented in scene tests
- no Android/human PASS claim

### Rollback

- camera instant full-map fallback
- result `NEUTRAL_ONLY`
- default cosmetic fallback
- hide manual browser entry while keeping validated semantic AUTO/RESTART flows

---

## 7. VS03-06 — Contextual First-Run Onboarding

### Decisions

`SX-DEC-016`, assisted evidence boundaries from `019~022`.

### Goal

Connect a pure onboarding state machine to the real product run after all required domain and presentation events exist.

### Files owned

Create:

```text
game/onboarding/onboarding_event.gd
game/onboarding/onboarding_state.gd
game/onboarding/first_run_assist_policy.gd
game/onboarding/onboarding_preferences.gd
game/ui/onboarding/**
game/ui/help/**
tests/onboarding/**
tests/integration/test_onboarding_*.gd
```

Modify narrowly:

```text
game/play/play_scene.gd
game/run/run_controller.gd
game/delivery/delivery_loop.gd only to forward normalized existing events when needed
game/rail/rail_switch.gd only to expose normalized selection/lock events when needed
tests/run_tests.gd
```

Actual DeliveryLoop path is `game/delivery/delivery_loop.gd`.

### Acceptance

- real endless run only
- LOAD → token → switch → mixed-stack LIFO → Combo → low-fuel BOOST
- only first LOAD/switch request safe pause
- domain event completes steps, not overlay animation
- skip/timeout/teardown release pause idempotently
- Help does not reactivate assist
- assisted first run updates no standard records/goals/variable rewards/balance evidence
- onboarding preference saved through ProfileTransactionService

### Rollback

Disable/skip onboarding and assist while preserving standard run. No tutorial-only map or formula remains.

---

## 8. VS03-07 — End-to-End Integration and Evidence Handoff

### Goal

Prove the full local flow automatically and prepare Issue #7 for device/human evidence.

### Files owned

Create:

```text
tests/integration/test_vs03_end_to_end.gd
tests/integration/test_vs03_restart_and_new_map.gd
tests/integration/test_vs03_profile_retry.gd
game/telemetry/run_event_log.gd
기획서/50_제작_검증/VS03_IMPLEMENTATION_AUDIT.md
```

Modify only current consumers and test registration.

### Automated flow

```text
new profile
→ first-run PREP/FULL_MAP_READY
→ assisted contextual learning
→ standard run
→ pickup/mixed stack/unload Combo
→ difficulty warning/commit
→ fuel-zero result
→ record/reward Profile transaction
→ same-map restart
→ AUTO_NEW_RUN second/third unique map
→ discovered-map manual selection
```

### Acceptance

- all prior suites green
- bounded event log
- stale run generation events ignored
- save/retry transaction duplication zero
- three-map flow deterministic
- current implementation docs and Issue #6 updated
- Android, 10-minute soak, captures, localization stress, accessibility runtime, economy simulation, and 5+ people remain Issue #7 `NOT_RUN`

### Rollback

Telemetry failure cannot block gameplay. Audit/reporting files can revert without product behavior changes.

---

## 9. Evidence Locations

| Evidence | Location |
|---|---|
| unit/integration | `tests/**` registered in `tests/run_tests.gd` |
| CI | Project Contract + Godot Tests on each PR exact head |
| package API/rollback | each PR body |
| implementation audit | `기획서/50_제작_검증/VS03_IMPLEMENTATION_AUDIT.md` |
| coordination | Issue #6 |
| device/human/soak | Issue #7 and later review document |
| Decision canon | `GMB-001_CANONICAL_DECISIONS.md` |
| DoR canon | `VS03_DEFINITION_OF_READY_AUDIT.md` + execution architecture |

## 10. Stop Conditions

Stop the current package and do not proceed when:

- existing public API regression is unexplained
- package edits a later package's owned hotspot without documented need
- Project Contract or Godot Tests fail
- new Scene/UI owns domain outcomes
- Profile has more than one writer
- selected/restarted map silently changes
- deferred target100 or online UGC enters VS-03
- runtime/Android/human evidence is overstated

## 11. Initial Build Authorization

After canonical DoR merge and Sheet readback:

```text
READY_FOR_BUILD applies to VS03-01 only.
VS03-02..07 become eligible sequentially after the prior package merge Gate.
No new product Decision is required unless implementation reveals a material player-facing choice or changes approved meaning.
```
