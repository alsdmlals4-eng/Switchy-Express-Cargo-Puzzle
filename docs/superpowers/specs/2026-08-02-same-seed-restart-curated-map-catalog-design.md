# Same-Seed Restart and Curated 100+ Map Catalog Design

**Decision:** `SX-DEC-023`  
**Evidence:** `EV-USER-012`  
**Batch:** `GMB-001` slot `7/10`  
**Status:** `APPROVED_PENDING_BATCH_MERGE`  
**Scope:** planning only; implementation, map assets, runtime behavior, Android evidence, and human validation remain `NOT_STARTED / NOT_RUN`

## Decision

`RESTART` always starts a new run attempt on the exact same validated map definition and seed bundle as the run that just ended.

A restart never searches for, rolls, or selects a new seed. New seeds are produced through a separate content-production pipeline and added to a curated catalog whose production target is at least 100 genuinely distinct maps.

```text
run ends
→ result screen
→ RESTART
→ same MapDefinition revision
→ new RunIdentity
→ all mutable run state recreated
→ same deterministic map package rebuilt
→ run begins
```

The policy for selecting a different catalog map is deferred to `SX-DEC-024`.

## Product Intent

- Failure insight from `SX-DEC-017` can be tested against the same route network.
- Immediate retry supports mastery instead of replacing the failed conditions with a reroll.
- Long-term variety comes from the number and quality of validated maps.
- A different integer seed does not automatically count as a different map.

## Map Seed

`map_seed` is content-authoring input for deterministic map construction.

It is not:

- a run ID,
- a reward transaction ID,
- a save transaction ID,
- a retry counter,
- a player-editable result-screen value.

## MapDefinition

A `MapDefinition` is the immutable shipped identity of one validated map revision.

```yaml
map_id: map.sx.0001
map_revision: 1
map_seed: 104729
generator_version: railgen_v2
ruleset_version: standard_v1
graph_signature: sha256(...)
station_signature: sha256(...)
initial_pickup_signature: sha256(...)
layout_signature: sha256(...)
content_signature: sha256(...)
validation_status: VALIDATED
used_fallback: false
```

Required fields:

- `map_id: StringName` — stable product identifier.
- `map_revision: int` — monotonically increasing revision for that map ID.
- `map_seed: int` — deterministic generator input.
- `generator_version: StringName` — exact generator contract.
- `ruleset_version: StringName` — run-rules compatibility boundary.
- `graph_signature: String` — exact rail graph signature.
- `station_signature: String` — station type and cell signature.
- `initial_pickup_signature: String` — initial cargo type and cell signature.
- `layout_signature: String` — graph, stations, train start, initial direction, and switch defaults.
- `content_signature: String` — layout plus initial pickups and ruleset version.
- `validation_status: StringName` — `DRAFT`, `VALIDATED`, `SHIPPED`, or `RETIRED`.
- `used_fallback: bool` — whether deterministic safe fallback was used.

Only entries with `VALIDATED` or `SHIPPED`, complete signatures, and `used_fallback = false` may start a standard run.

## RunIdentity

Every attempt receives a new identity even when the same map is retried.

```yaml
run_id: run-unique-id
map_id: map.sx.0001
map_revision: 1
retry_index: 3
restarted_from_run_id: previous-run-id
```

`run_id` owns record, reward, telemetry, and transaction identity. `map_seed` never substitutes for it.

## Deterministic Reconstruction

A same-map restart resolves the same `map_id` and `map_revision`, then rebuilds the exact map package represented by the stored signatures.

The package includes:

- rail graph topology,
- train start cell and initial direction,
- station types and cells,
- switch initial/default states,
- initial cargo pickup types and cells,
- deterministic cargo-spawn random-stream root,
- ruleset and difficulty configuration version.

For the same map definition, same ruleset, same assist state, and same player input sequence:

- graph signature is identical,
- station signature is identical,
- initial pickup signature is identical,
- cargo respawn decisions are identical when eligible-cell state is identical,
- committed difficulty events are identical,
- warning mode, Reduced Motion, cosmetics, and animation timing do not change simulation.

A generator or ruleset change requires an explicit new version and map revision. A silently changed generator is not the same map.

## Restart Reset Contract

`RESTART` preserves only immutable map identity and already-approved Profile-level state.

It resets:

- elapsed time,
- fuel and drain accumulators,
- score and multipliers,
- CargoStack and compact token state,
- switch runtime state and target locks,
- train position, speed, and route history,
- station-arrival and delivery state,
- collected pickups and pending respawn requests,
- difficulty step, forecast, warning cooldown, and presentation generation,
- result-insight evidence,
- temporary onboarding overlay state,
- pause and suspend state,
- reward-calculation and save-transaction state.

It creates:

- a new `run_id`,
- a new reward-event namespace,
- a new telemetry attempt,
- `retry_index = previous.retry_index + 1`,
- `restarted_from_run_id = previous.run_id`.

It preserves:

- `map_id`,
- `map_revision`,
- `map_seed`,
- `generator_version`,
- `ruleset_version`,
- all five stored signatures.

## Existing Decision Integration

### `SX-DEC-017` — Result learning

`RESTART` remains the primary action. Result insight may recommend a next action but cannot select or mutate a seed.

### `SX-DEC-018` — Camera

Immediate restart uses the approved direct full-map path and does not replay preparation zoom. `FULL_MAP_READY` still precedes authoritative run progression.

### `SX-DEC-019` to `SX-DEC-021` — Records and rewards

A same-map retry is a new eligible attempt when existing eligibility rules pass.

- prior records are not copied into mutable RunState,
- reward events use the new `run_id`,
- repeated map attempts are not automatically penalized,
- `retry_index` is telemetry segmentation, not gameplay balance.

Cross-map record fairness remains unresolved.

### `SX-DEC-022` — Difficulty communication

Restart discards all old forecasts, warnings, cooldowns, and callbacks. Same map/ruleset/input must rebuild the same authoritative difficulty event sequence.

### `SX-DEC-016` — First-run onboarding

The map stays the same. Assist activation follows the existing Profile/onboarding contract rather than copying temporary state from the failed attempt.

## Curated Seed Catalog

Runtime standard play loads only a validated catalog manifest. Runtime restart does not perform arbitrary seed search.

A seed counts toward the production target only when:

1. RailGraph contracts pass,
2. station placement succeeds,
3. initial pickup placement succeeds,
4. safe fallback was not used,
5. `layout_signature` is unique in the shipped catalog,
6. version fields and all component signatures are present,
7. automated reconstruction validation passes,
8. later readability and difficulty-distribution evidence passes before production promotion.

Changing only pickup positions does not create another map for the 100-map target when `layout_signature` is unchanged.

## Signature Contract

```text
graph_signature = graph.signature()
station_signature = canonical sorted station type/cell signature
initial_pickup_signature = canonical sorted cargo type/cell signature

layout_signature = SHA-256(
  generator_version
  + graph_signature
  + station_signature
  + train_start
  + initial_direction
  + switch_default_signature
)

content_signature = SHA-256(
  layout_signature
  + initial_pickup_signature
  + ruleset_version
)
```

Catalog validation rejects:

- duplicate `(map_id, map_revision)`,
- duplicate `layout_signature`,
- duplicate `content_signature`,
- absent component signatures,
- invalid version fields,
- `used_fallback = true`,
- runtime-ineligible status.

## Generator Diversity Requirement

The current `RailGenerator` chooses four binary position offsets: upper row, lower row, left column, and right column. It therefore exposes at most roughly 16 graph combinations and cannot honestly support 100 distinct layout signatures.

The recommended bounded expansion is:

- choose two distinct interior rows from `1..8`,
- choose three distinct interior columns from `1..13`,
- retain the perimeter loop,
- sort selected rows and columns before graph construction,
- use a mixed `(seed, attempt)` value for deterministic shuffling,
- retain the 32-attempt bound and deterministic safe fallback,
- reject fallback results from the shipped catalog.

This keeps the current corridor-network style while creating thousands of candidate combinations.

## Catalog Lifecycle

```text
seed candidate
→ graph generation
→ train start and station placement
→ initial pickup placement
→ structural validation
→ component signature calculation
→ duplicate/fallback rejection
→ DRAFT
→ automated simulation and visual review
→ VALIDATED
→ production approval
→ SHIPPED
```

A map revision increments when any deterministic content or version changes. Existing signature data is never silently replaced under the same revision.

## Missing or Invalid Revision

When the exact referenced revision cannot be resolved or reconstructed:

- do not claim an exact retry,
- reject the stale restart request,
- do not reuse the old run/reward transaction identity,
- show a short neutral recovery message,
- hand control to the future different-map selection policy.

## Save and UI Boundary

The catalog is product content, not a copy inside every Profile.

A restart request carries only:

```yaml
map_id: map.sx.0001
map_revision: 1
previous_run_id: previous-run-id
retry_index: 2
```

The controller resolves seed, versions, and signatures from the authoritative catalog. UI does not submit arbitrary raw seeds.

## Telemetry

Every run start records:

- `run_id`,
- `map_id`,
- `map_revision`,
- `generator_version`,
- `ruleset_version`,
- `retry_index`,
- `restarted_from_run_id`,
- assisted/standard eligibility segment,
- a bounded layout-signature prefix.

Telemetry distinguishes first attempt, same-map retry, different-map run, and invalid-revision recovery.

## Vertical Slice Boundary

Vertical Slice proves the architecture with at least three unique validated catalog entries. It does not claim the production catalog is complete.

Required evidence:

- three unique `layout_signature` values,
- one same-map restart path,
- graph/station/initial-pickup signature parity,
- complete mutable-state reset,
- new run/reward/telemetry identity per retry,
- fallback and duplicate rejection,
- deterministic parity with warning on/off and Reduced Motion.

The production milestone later requires at least 100 validated unique layout signatures plus readability and difficulty-distribution review.

## Failure Handling

| Failure | Required behavior |
|---|---|
| map ID absent | reject restart and enter neutral recovery |
| revision mismatch | never silently load another revision as exact retry |
| component signature mismatch | invalidate entry and block standard run |
| safe fallback used | reject catalog promotion |
| duplicate layout | reject duplicate promotion |
| stale callback | ignore by run-generation token |
| reward/save retry | use the new run ID and existing idempotent contracts |
| partially corrupted manifest | isolate invalid entries while preserving valid entries |

## Adversarial Findings

### F56 — Mutable restart leakage

Fuel, CargoStack, switches, pending spawns, difficulty, or transaction state may survive. Control: every retry gets a new `RunSession` and new mutable service instances.

### F57 — Seed/transaction identity collision

Using map seed as a run or reward ID can suppress valid rewards or duplicate grants. Control: unique `run_id` and reward-event namespace for every attempt.

### F58 — Fake map-count inflation

Many seeds may resolve to duplicate topology or fallback while being counted separately. Control: unique layout signature, fallback exclusion, and generator-space expansion.

### F59 — Version and determinism drift

The same seed may produce different content after generator/rules changes. Control: explicit versions, immutable revisions, stored component signatures, and mismatch rejection.

### F60 — Catalog-scale QA failure

A 100+ manifest may contain duplicated, invalid, unreadable, or extreme maps. Control: offline promotion pipeline, bounded audit, invalid-entry isolation, and later visual/human distribution review.

## Acceptance Criteria

- `RESTART` never requests a new seed or another map.
- Restart resolves the same map ID and revision.
- Restart produces a new run ID and transaction namespace.
- Every mutable subsystem begins from initial state.
- All component signatures match the catalog entry.
- Identical inputs preserve authoritative event parity.
- UI, cosmetics, warning mode, and motion settings cannot change simulation.
- Fallback and duplicate maps do not count toward the catalog target.
- The current limited generator is not represented as capable of 100 unique layouts before expansion and verification.
- Different-map selection and cross-map record policy remain follow-up Decisions.

## Excluded Scope

- selecting or rotating to another map,
- sequential progression and map unlocks,
- global versus per-map records,
- daily or online seeds,
- player seed entry,
- runtime infinite seed search,
- user-generated maps or a map editor,
- cloud catalog updates,
- producing all 100 maps in Vertical Slice.

## Decision Record

```yaml
decision_id: SX-DEC-023
evidence_id: EV-USER-012
user_choice: A
user_refinement: new seeds expand the map catalog; production target approximately 100 or more maps
approved_policy: RESTART_ALWAYS_SAME_MAP_SEED
catalog_model: CURATED_VALIDATED_SEED_CATALOG
production_map_target: 100+
different_map_selection_policy: SX-DEC-024
status: APPROVED_PENDING_BATCH_MERGE
codex_state: CODEX_NOT_READY
```
