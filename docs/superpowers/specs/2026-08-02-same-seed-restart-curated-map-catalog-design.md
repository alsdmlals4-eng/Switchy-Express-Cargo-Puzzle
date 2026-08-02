# Same-Seed Restart and Curated 100+ Map Catalog Design

**Decision:** `SX-DEC-023`  
**Evidence:** `EV-USER-012`  
**Batch:** `GMB-001` slot `7/10`  
**Status:** `APPROVED_PENDING_BATCH_MERGE`  
**Scope:** planning only; implementation, catalog assets, runtime behavior, Android evidence, and human validation remain `NOT_STARTED / NOT_RUN`

## 1. Decision

`RESTART` always starts a new run attempt on the exact same validated map definition and seed bundle as the run that just ended.

A new seed is not generated or selected by `RESTART`. New seeds are created, validated, and added through the production map-content pipeline to grow a curated catalog targeting at least 100 distinct maps.

```text
run ends
→ result screen
→ RESTART
→ same MapDefinition revision
→ new RunIdentity
→ all mutable run state reset
→ same deterministic map package rebuilt
→ run begins
```

The policy for selecting a different catalog map is intentionally deferred to `SX-DEC-024`.

## 2. Product Intent

The restart policy serves deliberate learning rather than surprise rerolling.

- A player can immediately retry the same route network after understanding a failure.
- Failure insight from `SX-DEC-017` can be tested against the same map conditions.
- The map catalog provides long-term variety through content quantity rather than changing the map underneath a retry.
- A large seed number is not accepted as proof of a distinct map. A catalog entry must pass validation and uniqueness checks.

## 3. Terminology

### 3.1 Map seed

`map_seed` is the deterministic input used to construct one candidate map package.

It is content-authoring data. It is not a run ID, reward event ID, save transaction ID, or restart counter.

### 3.2 Map definition

A `MapDefinition` is the immutable shipped identity of one validated map revision.

```yaml
map_id: map.sx.0001
map_revision: 1
map_seed: 104729
generator_version: railgen_v2
ruleset_version: standard_v1
layout_signature: sha256(...)
content_signature: sha256(...)
validation_status: VALIDATED
```

Required fields:

- `map_id: StringName` — stable product identifier.
- `map_revision: int` — monotonically increasing revision for that ID.
- `map_seed: int` — deterministic generator input.
- `generator_version: StringName` — exact generator contract used to build the map.
- `ruleset_version: StringName` — run-rules compatibility boundary.
- `layout_signature: String` — graph, stations, train start, and switch defaults.
- `content_signature: String` — layout signature plus initial pickup configuration.
- `validation_status: StringName` — `DRAFT`, `VALIDATED`, `SHIPPED`, or `RETIRED`.

Only `VALIDATED` or `SHIPPED` entries may be used by a standard run.

### 3.3 Run identity

Every attempt receives a new `RunIdentity` even when the map is reused.

```yaml
run_id: run-unique-id
map_id: map.sx.0001
map_revision: 1
map_seed: 104729
ruleset_version: standard_v1
retry_index: 3
restarted_from_run_id: prior-run-id
```

`run_id` is the authority for records, reward grants, telemetry, and transaction idempotency. `map_seed` is never reused as a transaction identifier.

### 3.4 Same-map restart

Same-map restart means all immutable map-definition fields remain equal while every mutable run field is recreated.

It does not mean continuing the old run state.

## 4. Deterministic Reconstruction Contract

A restart must resolve the same `map_id` and `map_revision`, then reconstruct the same map package.

The package includes:

- rail graph topology,
- train start cell and initial direction,
- station types and cells,
- switch initial/default states,
- initial cargo pickup types and cells,
- deterministic cargo-spawn random stream root,
- ruleset and difficulty configuration version.

For the same map definition, same ruleset, same assist state, and same player input sequence:

- graph signature is identical,
- station signature is identical,
- initial pickup signature is identical,
- cargo respawn decisions are identical when eligible-cell state is identical,
- difficulty committed events are identical,
- warning mode, Reduced Motion, cosmetic selection, and animation timing do not alter simulation results.

Determinism is bounded by explicit version fields. A silently changed generator is not considered the same map revision.

## 5. Restart Reset Contract

`RESTART` preserves only immutable map identity and approved profile-level state.

It must reset:

- elapsed run time,
- fuel and fuel-drain accumulators,
- score and score multipliers,
- CargoStack and compact token state,
- switch runtime state and committed target locks,
- train position, route history, and speed state,
- station-arrival and delivery state,
- pickup collection and pending respawn queues,
- difficulty step, forecast, warning cooldown, and presentation generation,
- result insight evidence,
- temporary onboarding overlay state,
- pause/suspend state,
- reward calculation and save transaction state.

It must create:

- a new `run_id`,
- a new reward event ID namespace,
- a new telemetry attempt record,
- `retry_index = previous.retry_index + 1`,
- `restarted_from_run_id = previous.run_id`.

The map ID, revision, seed, generator version, and ruleset version remain unchanged.

## 6. Existing Decision Integration

### 6.1 Result learning — `SX-DEC-017`

The result screen keeps `RESTART` as the primary action. The recommended next action can be tested on the same map rather than on a rerolled layout.

Result insight never selects or mutates the seed.

### 6.2 Camera — `SX-DEC-018`

Immediate restart uses the approved direct full-map path. It does not replay the initial preparation zoom.

`FULL_MAP_READY` still gates authoritative run progression.

### 6.3 Records and rewards — `SX-DEC-019` to `SX-DEC-021`

A same-map retry is a new eligible run attempt when all existing eligibility rules pass.

- Records are not copied from the previous attempt.
- Reward events use the new `run_id` and cannot collide with the previous attempt.
- Repeating a map does not automatically reduce rewards unless a later Decision explicitly introduces such a rule.
- `retry_index` is telemetry segmentation, not a gameplay penalty.

The fairness policy for comparing records across different maps is outside this Decision.

### 6.4 Difficulty communication — `SX-DEC-022`

Restart discards all previous warning and forecast state. The new attempt reconstructs the same authoritative difficulty schedule from the same map/ruleset inputs.

Stale callbacks from the prior run generation are ignored.

### 6.5 First-run onboarding — `SX-DEC-016`

The map remains the same on restart. Assist activation and onboarding completion follow the existing Profile and onboarding contract rather than being copied blindly from the failed run.

A deterministic comparison is valid only when assist state is also identical.

## 7. Curated Seed Catalog

### 7.1 Runtime rule

Runtime standard play loads only a validated catalog manifest. It does not search arbitrary new seeds during `RESTART`.

The production pipeline may generate and evaluate seed candidates offline, but only promoted entries become playable catalog maps.

### 7.2 Production target

The product target is at least 100 distinct validated maps.

A seed counts toward this target only when:

1. the graph satisfies all RailGraph contracts,
2. station placement succeeds,
3. initial cargo placement succeeds,
4. the map does not use the deterministic safe fallback,
5. its `layout_signature` is unique in the shipped catalog,
6. its content and ruleset versions are explicit,
7. automated validation passes,
8. required later readability and playtest evidence is recorded before production promotion.

Changing only pickup positions does not create a new map for the 100-map count if the `layout_signature` is unchanged.

### 7.3 Signature definitions

```text
layout_signature = SHA-256(
  generator_version
  + graph.signature()
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

The catalog rejects duplicate `map_id`, duplicate `(map_id, map_revision)`, duplicate `layout_signature`, invalid version fields, and any entry marked `used_fallback`.

### 7.4 Generator diversity requirement

The current generator chooses two horizontal rows and three vertical columns from only four binary offsets. This yields at most approximately 16 rail-topology combinations and cannot support 100 distinct layout signatures.

Before the 100-map target can be claimed, the generator must expand its deterministic candidate space. The recommended bounded extension is:

- choose two distinct interior rows from rows `1..8`,
- choose three distinct interior columns from columns `1..13`,
- retain the perimeter loop,
- sort selected rows and columns before graph construction,
- use a mixed `(seed, attempt)` value to shuffle candidate positions,
- retain the existing 32-attempt bound and deterministic safe fallback,
- reject fallback candidates from the shipped catalog.

This creates thousands of possible corridor combinations while preserving the existing connected, no-dead-end style.

## 8. Catalog Lifecycle

```text
seed candidate
→ generate rail graph
→ place train start and stations
→ place initial pickups
→ validate structural contract
→ calculate signatures
→ reject invalid/fallback/duplicate
→ DRAFT catalog entry
→ automated simulation and visual review
→ VALIDATED
→ production approval
→ SHIPPED
```

A later revision of an existing map increments `map_revision`. It does not silently replace the old signature while retaining the same revision number.

If a referenced revision is unavailable or corrupted:

- do not claim an exact same-map retry,
- abort the stale restart request,
- resolve a valid catalog entry through the future map-selection policy,
- show a short neutral recovery message,
- generate a new `run_id`,
- never reuse prior rewards or records transactions.

## 9. Catalog and Save Boundaries

The full 100-map catalog is product content, not per-player save data.

Profile data may later store discovered, selected, or recently played map IDs, but this Decision does not define those systems.

A result screen restart request carries a bounded snapshot:

```yaml
map_id: map.sx.0001
map_revision: 1
previous_run_id: run-unique-id
retry_index: 2
```

The runtime resolves the authoritative seed and signatures from the catalog. UI payloads do not provide arbitrary raw seeds.

## 10. Telemetry

Every run-start event records:

- `run_id`,
- `map_id`,
- `map_revision`,
- `generator_version`,
- `ruleset_version`,
- `retry_index`,
- `restarted_from_run_id` when applicable,
- assisted/standard eligibility segment,
- layout-signature hash prefix.

Raw internal seed exposure in player-facing UI is not required.

Telemetry must distinguish:

- first attempt on a map,
- same-map retry,
- different-map new run,
- recovery from missing or invalid map revision.

## 11. Vertical Slice Boundary

The Vertical Slice validates the architecture without producing the full catalog.

Required Vertical Slice evidence:

- at least three unique validated catalog entries,
- one same-map restart path,
- exact graph/station/initial-pickup signature parity on restart,
- complete mutable-state reset,
- new run/reward/telemetry IDs per retry,
- fallback and duplicate rejection,
- same-seed deterministic replay under warning on/off and Reduced Motion,
- no product-code claim that 100 maps are already complete.

The production milestone later requires at least 100 unique validated `layout_signature` values plus human readability and difficulty-distribution review.

## 12. Failure Handling

| Failure | Required behavior |
|---|---|
| map ID missing | reject restart and use neutral recovery path |
| revision mismatch | do not silently load a different revision as exact retry |
| signature mismatch | mark catalog entry invalid and block standard run |
| generator fallback used | reject as catalog map; fallback remains test/recovery only |
| duplicate layout signature | keep one authoritative entry and reject duplicate promotion |
| stale restart callback | ignore by run-generation token |
| reward/save retry | use new run ID and existing atomic idempotent contracts |
| catalog manifest corruption | isolate invalid entries; do not prevent valid entries from loading |

## 13. Adversarial Findings

### F56 — Mutable restart leakage

**Risk:** fuel, stack, switch, difficulty, pending spawn, or reward state survives restart.  
**Control:** reconstruct the run from immutable `MapDefinition`; never reuse mutable service instances.

### F57 — Seed and transaction identity collision

**Risk:** map seed is reused as run/reward ID and causes duplicate suppression or duplicate grant.  
**Control:** unique `run_id` and reward event namespace per attempt.

### F58 — Fake map-count inflation

**Risk:** many seeds resolve to the same topology or deterministic fallback while being counted as different maps.  
**Control:** unique `layout_signature`, fallback exclusion, and generator-space expansion before claiming 100 maps.

### F59 — Version and determinism drift

**Risk:** the same seed produces different content after generator or rules changes.  
**Control:** explicit generator/ruleset versions, immutable revision signatures, and mismatch rejection.

### F60 — Catalog-scale validation failure

**Risk:** a 100+ entry manifest contains invalid, duplicated, unreadable, or extreme-difficulty maps.  
**Control:** offline promotion pipeline, bounded automated audit, later visual/human distribution review, and invalid-entry isolation.

## 14. Acceptance Criteria

- `RESTART` never requests a new seed or different map.
- Restart resolves the same map ID and revision.
- Restart creates a new run ID and transaction namespace.
- Every mutable run subsystem begins from its initial state.
- Identical inputs on the same definition produce identical authoritative events.
- Warning, motion, cosmetics, and UI timing do not alter simulation.
- Catalog entries are versioned, validated, signature-addressed, and duplicate-safe.
- Safe fallback maps do not count toward the production map target.
- The current limited generator is not represented as capable of 100 unique layouts until expanded and verified.
- Map selection, rotation, discovery, and cross-map record fairness remain explicit follow-up Decisions.

## 15. Excluded Scope

- selecting or rotating to a different map,
- sequential map progression,
- map unlock economy,
- global versus per-map records,
- daily seeds or online challenge seeds,
- player-entered seed UI,
- runtime infinite seed search,
- user-generated maps or a map editor,
- cloud catalog updates,
- producing all 100+ maps in the Vertical Slice.

## 16. Decision Record

```yaml
decision_id: SX-DEC-023
evidence_id: EV-USER-012
user_choice: A
user_refinement: new seeds are for expanding the map count; production target approximately 100 or more maps
approved_policy: RESTART_ALWAYS_SAME_MAP_SEED
catalog_model: CURATED_VALIDATED_SEED_CATALOG
production_map_target: 100+
different_map_selection_policy: SX-DEC-024
status: APPROVED_PENDING_BATCH_MERGE
codex_state: CODEX_NOT_READY
```
