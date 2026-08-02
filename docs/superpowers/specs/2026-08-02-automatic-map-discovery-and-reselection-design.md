# Automatic Map Discovery and Reselection Design

**Decision:** `SX-DEC-024`  
**Evidence:** `EV-USER-013`  
**Batch:** `GMB-001` slot `8/10`  
**Status:** `APPROVED_PENDING_BATCH_MERGE`  
**Scope:** planning only; implementation, map-browser assets, runtime behavior, Android evidence, localization stress, and human validation remain `NOT_STARTED / NOT_RUN`

## Decision

Use a hybrid map-access policy:

1. `RESTART` always replays the exact current map under `SX-DEC-023`.
2. `NEW RUN` automatically assigns an eligible undiscovered map before any replayed map.
3. After every eligible map has been discovered, `NEW RUN` uses a non-repeating replay cycle that avoids recently played maps.
4. A map becomes directly selectable after one authoritative run start on that map.
5. Discovered maps are exposed through a compact browser organized by recent, favorite, and all-discovered views.

```text
RESTART
→ same MapDefinition
→ new RunIdentity

NEW RUN
→ eligible catalog snapshot
→ undiscovered map bag first
→ otherwise replay bag with recent exclusion
→ MapSelectionReceipt
→ reconstruction
→ FULL_MAP_READY
→ authoritative run start
→ discovery/history commit

CHOOSE MAP
→ discovered and currently eligible map only
→ MapSelectionReceipt
→ new independent run
```

The player never enters or edits a raw seed.

## Product Intent

- Let the first 100+ map experiences arrive naturally without a 100-item decision wall.
- Guarantee broad catalog exposure instead of relying on replacement random selection.
- Preserve agency by allowing any previously played map to be selected again.
- Keep mastery-friendly `RESTART` distinct from variety-oriented `NEW RUN`.
- Avoid resource gates, ads, daily timers, or limited-time access around map discovery.

## Terminology

### Eligible map

A `MapDefinition` that is currently:

- present in the loaded catalog,
- `VALIDATED` or `SHIPPED`,
- compatible with the current ruleset,
- non-fallback,
- complete and signature-valid,
- not retired or quarantined.

### Discovered map

A stable `map_id` whose reconstructed run has reached `FULL_MAP_READY` and committed authoritative run start at least once for the Profile.

Discovery is content exposure, not achievement evidence. Therefore an assisted first run may discover a map while remaining excluded from standard records, goals, and variable rewards.

### Automatic discovery cycle

The persisted, profile-specific order in which undiscovered eligible map IDs are offered by `NEW RUN`.

### Replay cycle

The persisted order used only when no eligible undiscovered map remains. It excludes a bounded recent-history window where possible.

## Request Modes

Exactly three semantic request modes exist:

```yaml
RESTART_SAME_MAP:
  source: result primary action
  map_source: previous RunIdentity.MapDefinition
  consumes_auto_cycle: false

AUTO_NEW_RUN:
  source: result secondary action or main start action
  map_source: MapSelectionService automatic policy
  consumes_auto_cycle: on committed run start only

SELECT_DISCOVERED_MAP:
  source: map browser
  map_source: explicit discovered map_id
  consumes_auto_cycle: false
```

UI controls emit these semantic requests. UI never supplies `map_seed`, generator version, revision, or signatures.

## Automatic Assignment Policy

### 1. Snapshot the eligible catalog

`MapSelectionService` resolves one immutable catalog snapshot and sorts stable IDs before building candidate bags. The selection receipt stores the catalog revision used for the decision.

### 2. Prefer undiscovered maps

```text
undiscovered = eligible_map_ids - discovered_map_ids
```

When `undiscovered` is non-empty, `AUTO_NEW_RUN` must choose from a persisted deterministic shuffle bag containing only those IDs.

Consequences:

- No eligible map repeats before every eligible map in that discovery cycle has been offered and successfully started.
- Adding new eligible maps makes them undiscovered and therefore higher priority than replay candidates.
- A reconstruction failure does not mark the failed map discovered or consume it as a successful exposure.

### 3. Use replay cycle after full discovery

When every eligible map has been discovered, `AUTO_NEW_RUN` chooses from a persisted replay shuffle bag.

The replay policy:

- avoids the immediately previous map whenever at least two eligible maps exist,
- excludes the most recent `3` distinct map IDs when the eligible pool is large enough,
- falls back by reducing the exclusion window rather than generating a runtime seed,
- guarantees each eligible ID appears once per replay cycle before the next cycle begins,
- does not weight favorites, spending, skill, retention predictions, or previous performance.

`recent_exclusion_count = 3` is a `TEST_VALUE`.

### 4. Commit only after authoritative run start

A provisional selection does not mutate discovery or history.

After reconstruction and `FULL_MAP_READY`, run start atomically commits:

- `map_id` to `discovered_map_ids`,
- play-count increment,
- deduplicated recent-history update,
- automatic bag consumption when mode is `AUTO_NEW_RUN`,
- processed selection receipt ID,
- run/map telemetry lineage.

Backing out, reconstruction failure, or app interruption before authoritative run start does not count as discovery or play.

## Idempotent Selection Receipt

Every selection produces an immutable receipt:

```yaml
selection_request_id: select-unique-id
selection_mode: AUTO_NEW_RUN
catalog_revision: catalog-v12
map_id: map.sx.0042
map_revision: 3
map_identity_key: map.sx.0042@3
cycle_generation: 6
created_from_run_id: optional-previous-run-id
```

Rules:

- Reprocessing the same `selection_request_id` returns the same receipt.
- A receipt can commit run start once.
- Duplicate button events cannot consume two map IDs or start two sessions.
- `map_seed` never acts as the receipt ID.
- A stale or no-longer-eligible receipt is rejected before run start.

## Direct Reselection Policy

A map may be selected manually when:

- its stable `map_id` is discovered for the Profile,
- a compatible eligible revision exists in the current catalog,
- it is not retired or quarantined.

Manual selection:

- creates a new run identity,
- does not consume the automatic discovery or replay bag,
- updates play count and recent history only after authoritative run start,
- does not grant record, reward, or goal eligibility by itself,
- cannot change map seed or revision from the catalog-resolved definition.

A map revision update does not erase discovery because discovery is keyed by stable `map_id`. A fundamentally different layout intended to count as a new map must receive a new `map_id`.

## Catalog Change Reconciliation

### Newly added map

- enters the eligible undiscovered pool,
- is prioritized by the next automatic discovery cycle,
- does not alter already committed history.

### Revised map

- keeps discovered and favorite state by stable `map_id`,
- uses the newest compatible eligible revision for new runs,
- retains revision evidence in each historical `RunIdentity`.

### Retired, removed, or quarantined map

- remains in bounded discovery/history data as an unavailable tombstone,
- cannot be started manually or automatically,
- is removed from active bags during reconciliation,
- does not cause a runtime seed reroll,
- displays a neutral unavailable state only when relevant in recent or favorites.

### Empty eligible catalog

The game returns a neutral `NO_ELIGIBLE_MAP` result and stays outside run progression. It does not create an arbitrary seed, use a fallback map, or silently select an incompatible entry.

## Runtime Failure Handling

### Automatic selection candidate fails reconstruction

- reject the candidate with an authoritative reason code,
- do not mark it discovered,
- quarantine it for the current catalog session,
- try the next eligible automatic candidate within a bounded attempt count,
- emit telemetry,
- return `NO_RECONSTRUCTABLE_MAP` if no candidate succeeds.

### Manual selection candidate fails reconstruction

- do not substitute a different map,
- show the selected map as temporarily unavailable,
- return to the browser or menu,
- emit the same bounded failure evidence.

### Restart candidate fails reconstruction

Follow `SX-DEC-023`: do not silently switch maps. Report neutral incompatibility and return outside run progression.

## Profile Data Contract

The versioned Profile extension owns:

```yaml
discovered_map_ids: Array[StringName]
favorite_map_ids: Array[StringName]
map_play_count_by_id: Dictionary
recent_map_ids: Array[StringName]
auto_discovery_bag: Array[StringName]
auto_replay_bag: Array[StringName]
map_cycle_seed: int
map_cycle_generation: int
map_catalog_revision_seen: StringName
processed_selection_request_ids: bounded Array[String]
committed_selection_receipt_ids: bounded Array[String]
```

Constraints:

- IDs are deduplicated and bounded where required.
- Counts are nonnegative integers.
- Recent history stores distinct IDs in most-recent-first order.
- Save migration treats missing fields as empty/default state.
- Corrupt unknown IDs are isolated; valid Profile data remains usable.
- Profile save and discovery/history commit are atomic and idempotent.

## Map Browser Information Architecture

The browser is not a 100-item raw seed list.

Primary sections:

1. `RECENT`
2. `FAVORITES`
3. `ALL DISCOVERED`

Map cards may display:

- localized map display name,
- stable player-facing map number or short label,
- favorite state,
- play count,
- last-played relative order,
- availability state,
- non-authoritative descriptive tags approved for presentation.

Map cards must not display:

- raw seed,
- generator version,
- signatures,
- internal difficulty formula,
- undiscovered map names or layouts,
- monetization or time-lock messaging.

Undiscovered exposure is summarized as progress such as `37 / 100 discovered`, using the current eligible catalog count. The UI does not render 63 fake locked cards.

## Result and Menu UX

### Result screen

- `RESTART` remains the primary action and means same-map retry.
- `NEW RUN` is secondary and invokes automatic assignment.
- A compact `CHOOSE MAP` entry may open the discovered-map browser.
- No button exposes a raw seed or arbitrary reroll.

### Main flow

- Primary start invokes `AUTO_NEW_RUN` unless an already approved first-session flow supplies its own eligible map request.
- Browser access is secondary and contains discovered maps only.
- Manual selection must not displace the fast automatic start path.

## Accessibility and Localization

- Interactive targets meet the existing `48dp` minimum.
- Selection, discovery, favorite, and unavailable states use text plus icon/shape, never color alone.
- Long localization at `140%` reference expansion must not overlap map cards or actions.
- Reduced Motion removes nonessential reveal motion without changing assignment or discovery commit timing.
- Screen-reader order follows section, card name, status, play count, and action.
- Loading animation never controls selection or run-start authority.

## Existing Decision Integration

### `SX-DEC-023` — Same-map restart

`RESTART_SAME_MAP` bypasses `MapSelectionService` automatic bags and preserves the exact previous map definition. It still creates fresh run and transaction identities.

### `SX-DEC-018` — Camera

Every request mode must reach `FULL_MAP_READY` before authoritative run progression. Immediate restart keeps the direct full-map path.

### `SX-DEC-016` — First-session onboarding

An assisted first run may mark a map discovered after authoritative run start. This does not make the run eligible for standard records, goals, or variable rewards.

### `SX-DEC-019` to `SX-DEC-021` — Profile, records, rewards

Discovery and favorite state are Profile metadata. Map selection source never grants performance power and never changes existing record/reward eligibility.

### `SX-DEC-017` and `SX-DEC-022`

Result insight and difficulty warning are non-authoritative. Neither may alter automatic map order, manual eligibility, or catalog state.

## Telemetry

Bounded events:

```yaml
map_selection_requested:
  request_id
  mode
  eligible_count
  undiscovered_count
  recent_exclusion_count

map_selection_resolved:
  request_id
  map_id
  map_revision
  source_cycle
  repeat_distance

map_run_start_committed:
  receipt_id
  run_id
  map_id
  newly_discovered
  play_count

map_selection_rejected:
  request_id
  map_id
  reason_code

map_browser_action:
  action: OPEN|SELECT|FAVORITE_ADD|FAVORITE_REMOVE
  map_id: optional
```

Do not include raw seed in ordinary product analytics unless a separate diagnostic policy explicitly allows it.

## Validation Gates

### Vertical Slice

Use three unique validated maps and prove:

- three consecutive successful `AUTO_NEW_RUN` starts discover all three without a repeat,
- fourth automatic start enters replay policy and avoids the immediately previous map,
- `RESTART` keeps the same map and does not consume the auto bag,
- discovered maps appear in the browser,
- an undiscovered map cannot be selected manually,
- favorite and recent state survive save/reload,
- duplicate request and duplicate start commit are idempotent,
- invalid automatic candidate is skipped without runtime seed generation,
- invalid manual candidate is not silently substituted.

### Production catalog

With at least 100 eligible unique layouts:

- the first 100 successful automatic discovery starts cover every eligible stable `map_id` exactly once when the catalog remains unchanged,
- no map starves across replay cycles,
- recent exclusion works where pool size permits,
- new catalog additions enter discovery priority,
- retired entries cannot start,
- browser remains responsive and readable at 100 discovered entries,
- Android aspect, localization, accessibility, and human tests pass.

All UI density, recent-window, telemetry retention, and performance thresholds remain `TEST_VALUE` until evidence gates run.

## Adversarial Findings

### `F61` — Replacement random selection repeats and starves maps

Mitigation: persisted undiscovered and replay shuffle bags; successful run-start commit controls consumption.

### `F62` — 100-item browser overwhelms new users or leaks undiscovered content

Mitigation: automatic discovery first; browser contains discovered entries organized by recent, favorites, and all-discovered; aggregate undiscovered progress only.

### `F63` — Manual selection corrupts automatic cycle or restart semantics

Mitigation: three explicit request modes; manual and restart do not consume automatic bags.

### `F64` — Catalog revision, retirement, or save migration corrupts discovery state

Mitigation: discovery keyed by stable `map_id`; revision reconciliation, unavailable tombstones, versioned atomic Profile migration.

### `F65` — Duplicate UI events or reconstruction failure starts the wrong map

Mitigation: immutable idempotent receipts; commit after `FULL_MAP_READY`; automatic bounded skip, manual no-substitution, no runtime seed fallback.

## Deferred Decisions

This decision does not settle:

- whether records are global, per-map, or both,
- whether map difficulty labels are visible,
- whether maps support authored collections or regions,
- social leaderboards,
- user-generated seeds or map sharing,
- content download/update packaging.

The next material decision is `SX-DEC-025`: global versus per-map record and leaderboard fairness across a 100+ map catalog.
