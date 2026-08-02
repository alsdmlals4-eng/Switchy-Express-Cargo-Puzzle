# Hybrid Map Records and User-Published Maps Implementation Plan

> **Decision:** `SX-DEC-025`  
> **Evidence:** `EV-USER-014`  
> **Batch:** `GMB-001` slot `9/10`  
> **Status:** `APPROVED_PENDING_BATCH_MERGE`  
> **Execution gate:** planning only; do not implement until GMB-001 10/10 audit, canonical merge, Sheet closure, and Codex handoff.

## Goal

Implement:

1. official global personal records and official per-map personal records in one atomic record transaction,
2. revision-scoped personal records for published user maps without contaminating official records or rewards,
3. a constrained data-only map layout editor,
4. deterministic local validation and creator test mode,
5. immutable user-map publication packages and idempotent upload requests,
6. private/unlisted/public publication states,
7. playback by creator and other users through exact published revisions,
8. moderation, reporting, compatibility, quarantine, and safe failure boundaries.

## Non-goals

- no implementation during this planning batch,
- no arbitrary script, plugin, shader, image, audio, font, or model upload,
- no UGC cosmetic-currency reward, creator reward, rating, comments, or leaderboard before `SX-DEC-026`,
- no online global leaderboard,
- no collaboration, fork, remix, ownership transfer, or custom ruleset,
- no silent fallback from an unavailable UGC map to another map,
- no mixing UGC with official `AUTO_NEW_RUN` discovery bags.

## Required execution skills

- test-driven-development
- systematic-debugging for any failing test or unexpected behavior
- verification-before-completion before every completion claim
- requesting-code-review before merge
- GitHub PR workflow; no direct main push

## Existing contracts to preserve

- `SX-DEC-016`: assisted first runs do not update standard competitive evidence.
- `SX-DEC-017`: result insight is non-authoritative.
- `SX-DEC-018`: `FULL_MAP_READY` precedes progression.
- `SX-DEC-019`: records are personal and cosmetics are non-power.
- `SX-DEC-020`: unlock transactions remain atomic and idempotent.
- `SX-DEC-021`: record reward is at most once per eligible run.
- `SX-DEC-022`: difficulty UI cannot alter simulation.
- `SX-DEC-023`: exact map identity restart creates a fresh RunSession.
- `SX-DEC-024`: official automatic discovery and manual selection use separate semantics.

---

## Task 1: Add explicit record scopes and immutable record keys

**Files**

- Create: `game/profile/record_scope.gd`
- Create: `game/profile/map_record_key.gd`
- Create: `game/profile/record_values.gd`
- Create: `tests/profile/test_record_scope.gd`
- Create: `tests/profile/test_map_record_key.gd`
- Modify: `tests/run_tests.gd`

### Step 1 — Write failing scope tests

Test:

- official global key requires competitive ruleset ID,
- official per-map key requires stable map ID, competitive layout revision, and ruleset ID,
- UGC key requires immutable publication revision ID, content hash, and ruleset ID,
- official and UGC serialized keys can never collide,
- blank IDs, negative revisions, malformed hashes, and unknown scope values are rejected,
- dictionary order does not change serialized key output.

Example target API:

```gdscript
var global_key := MapRecordKey.official_global(&"standard_v1")
var map_key := MapRecordKey.official_per_map(&"map.sx.0042", 3, &"standard_v1")
var ugc_key := MapRecordKey.ugc_revision(
    &"ugc:user42:map77@2",
    "sha256:...",
    &"standard_v1"
)
```

### Step 2 — Run tests and confirm RED

```bash
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tests/run_tests.gd
```

Expected: missing scope/key classes.

### Step 3 — Implement the minimum domain model

`RecordScope` allowed values:

```text
OFFICIAL_GLOBAL_PERSONAL
OFFICIAL_PER_MAP_PERSONAL
UGC_PER_REVISION_PERSONAL
```

`RecordValues` contains only:

```text
best_score
longest_survival_seconds
best_max_combo
```

Validation must reject negative, non-finite, or out-of-range values without deleting unrelated Profile data.

### Step 4 — Run tests and confirm GREEN

### Step 5 — Commit

```bash
git add game/profile/record_scope.gd game/profile/map_record_key.gd game/profile/record_values.gd tests/profile/test_record_scope.gd tests/profile/test_map_record_key.gd tests/run_tests.gd
git commit -m "feat: add scoped personal record keys"
```

---

## Task 2: Implement atomic official global + per-map record commit

**Files**

- Create: `game/profile/scoped_record_commit_request.gd`
- Create: `game/profile/scoped_record_commit_result.gd`
- Modify or create according to the existing implementation state:
  - `game/profile/competitive_record_store.gd`
  - `game/profile/record_eligibility_policy.gd`
- Create: `tests/profile/test_scoped_record_commit.gd`
- Create: `tests/profile/test_record_scope_eligibility.gd`
- Modify: `tests/run_tests.gd`

### Step 1 — Write failing official transaction tests

Test one eligible official `RunSummary` that:

- updates the current official map score,
- updates global max Combo,
- leaves non-improved fields unchanged,
- commits both scopes and processed event ID atomically,
- returns immutable per-scope update flags,
- returns the same result on duplicate event processing,
- performs no partial update when save fails.

Also test:

- assisted, debug, integrity-invalid, incomplete, and wrong-ruleset runs update neither scope,
- a map no longer marked competitive cannot update the official per-map or global namespace,
- map competition key changes isolate records.

### Step 2 — Implement pure compare logic

Recommended split:

```text
RecordEligibilityPolicy
→ determines allowed scopes

ScopedRecordComparator
→ pure comparison of RunSummary against existing values

CompetitiveRecordStore
→ atomic Profile transaction + journal
```

The UI must not choose scopes or mutate values.

### Step 3 — Preserve SX-DEC-021 reward ordering

Required ordering:

```text
immutable RunSummary
→ scope eligibility
→ atomic scoped record compare-and-commit
→ ScopedRecordCommitResult
→ RewardCalculator
→ reward commit
→ Result ViewModel
```

`ScopedRecordCommitResult.any_standard_record_updated` is true when one or more official fields update, but reward calculation may grant the record component only once.

### Step 4 — Run focused and full tests

### Step 5 — Commit

```bash
git commit -am "feat: commit global and per-map records atomically"
```

---

## Task 3: Isolate UGC revision records from official progression

**Files**

- Create: `game/profile/ugc_record_eligibility_policy.gd`
- Modify: `game/profile/competitive_record_store.gd`
- Create: `tests/profile/test_ugc_record_isolation.gd`
- Create: `tests/profile/test_ugc_revision_record_identity.gd`
- Modify: `tests/run_tests.gd`

### Step 1 — Write failing isolation tests

Test:

- local draft and editor test run update zero records,
- private/unlisted/public published revision with valid server receipt may update only UGC per-revision personal records,
- UGC run never updates official global or official per-map records,
- UGC record update never produces an official record reward flag,
- revision 1 and revision 2 have independent records,
- same content hash under a forged publication ID is rejected,
- publication state `QUARANTINED`, `DELISTED`, `REMOVED`, or `INCOMPATIBLE` prevents new record commit,
- duplicate run-summary event is idempotent.

### Step 2 — Implement source-aware eligibility

The run summary or immutable run identity must expose:

```yaml
map_source_kind
map_identity
published_user_map_revision_id
content_hash
server_validation_receipt_id
run_mode
```

Do not infer UGC eligibility from UI route or cached browser metadata.

### Step 3 — Commit

```bash
git commit -am "feat: isolate user map records from official progression"
```

---

## Task 4: Migrate Profile schema without losing existing records

**Files**

- Modify or create according to current implementation state:
  - `game/profile/profile_schema.gd`
  - `game/profile/profile_store.gd`
  - `game/profile/profile_migrator.gd`
- Create: `tests/profile/test_scoped_record_migration.gd`
- Create: `tests/profile/test_record_partial_corruption.gd`
- Modify: `tests/run_tests.gd`

### Step 1 — Write migration tests

Fixtures:

- pre-SX-DEC-025 Profile with only global record fields,
- Profile with malformed one-map record and valid global values,
- Profile with unknown retired map key,
- Profile with removed UGC revision tombstone,
- duplicate processed event IDs,
- oversized UGC record history.

Expected:

- legacy global records become `OFFICIAL_GLOBAL_PERSONAL`,
- per-map and UGC dictionaries initialize empty,
- malformed entry is isolated rather than deleting the Profile,
- bounded cleanup is deterministic,
- migration retries are idempotent.

### Step 2 — Implement versioned migration

Never use display title as a record key. Use canonical serialized `MapRecordKey` only.

### Step 3 — Run tests and commit

```bash
git commit -am "feat: migrate profile to scoped map records"
```

---

## Task 5: Present current-map and global records without double celebration

**Files**

- Create: `game/ui/result_record_view_model.gd`
- Modify: `game/ui/result_panel.gd`
- Modify: result scene only when implementation is authorized
- Create: `tests/ui/test_result_record_view_model.gd`
- Create: `tests/ui/test_result_record_presentation.gd`
- Modify: `tests/run_tests.gd`

### Step 1 — Write failing view-model tests

Cases:

- map record only updated,
- global record only updated,
- both updated in different fields,
- both updated in the same field,
- no record updated,
- UGC per-revision record updated,
- save pending/failure,
- long localization and 140% expansion,
- Reduced Motion.

Expected presentation:

- current-map update is first,
- global update appears only for official global updates,
- UGC label never says global/official,
- one record reward receipt regardless of two scope updates,
- RESTART stays primary.

### Step 2 — Implement immutable presentation input

`ResultRecordViewModel` consumes only committed `ScopedRecordCommitResult`. It cannot compare records, save Profile, or grant rewards.

### Step 3 — Add accessibility checks

- text plus icon/shape, not color alone,
- 48dp controls,
- screen-reader order after core results,
- no required animation,
- map title fallback for removed/incompatible content.

### Step 4 — Commit

```bash
git commit -am "feat: present scoped personal record updates"
```

---

## Task 6: Add canonical user-map draft schema

**Files**

- Create: `game/ugc/user_map_schema.gd`
- Create: `game/ugc/user_map_draft.gd`
- Create: `game/ugc/user_map_canonicalizer.gd`
- Create: `game/ugc/user_map_hash.gd`
- Create: `tests/ugc/test_user_map_schema.gd`
- Create: `tests/ugc/test_user_map_canonicalizer.gd`
- Create: `tests/ugc/test_user_map_hash.gd`
- Modify: `tests/run_tests.gd`

### Step 1 — Write failing schema tests

Test canonical data for:

- 15×10 board bounds,
- rails, switches, start, stations, pickups, and spawn markers,
- deterministic sort order,
- normalized directions and coordinates,
- unknown field rejection,
- prohibited script/URL/asset fields,
- metadata length and approved tag enum,
- stable SHA-256 hash across dictionary insertion order,
- hash change when gameplay layout changes.

### Step 2 — Implement data-only schema

`UserMapDraft` may be mutable inside the editor, but publish input must be an immutable canonical snapshot.

Never serialize engine Node paths, object instance IDs, lambdas, scripts, Resources from arbitrary paths, or user-provided URLs.

### Step 3 — Commit

```bash
git add game/ugc tests/ugc tests/run_tests.gd
git commit -m "feat: add canonical user map draft schema"
```

---

## Task 7: Implement deterministic local validation and creator test mode

**Files**

- Create: `game/ugc/user_map_validation_finding.gd`
- Create: `game/ugc/user_map_validator.gd`
- Create: `game/ugc/user_map_test_run_policy.gd`
- Create: `tests/ugc/test_user_map_validator.gd`
- Create: `tests/ugc/test_user_map_test_run_policy.gd`
- Create: `tests/support/user_map_fixture.gd`
- Modify: `tests/run_tests.gd`

### Step 1 — Write failing validator tests

Include:

- out-of-bounds tile,
- overlapping exclusive objects,
- missing or duplicate train start,
- invalid switch topology,
- disconnected required graph,
- station/pickup/spawn off allowed cells,
- immediate start collision/dead end,
- excessive tile/node count,
- pathological graph that exceeds bounded validation work,
- valid minimum map,
- repeated validation returns identical ordered finding codes.

### Step 2 — Implement bounded validators

Each finding contains:

```yaml
finding_code
severity
cell_or_object_reference
localization_key
blocking_publish
```

Validation must have deterministic time/work caps. A timeout is a blocking finding, not a success.

### Step 3 — Enforce creator test mode

`USER_MAP_EDITOR_TEST` must set:

```text
record_eligible = false
goal_eligible = false
reward_eligible = false
discovery_eligible = false
```

Test mode must not write official or published UGC play counts.

### Step 4 — Commit

```bash
git commit -am "feat: validate and test user map drafts safely"
```

---

## Task 8: Build the editor state machine before visual polish

**Files**

- Create: `game/ugc/user_map_editor_state.gd`
- Create: `game/ugc/user_map_editor_command.gd`
- Create: `game/ugc/user_map_editor_history.gd`
- Create: `game/ugc/user_map_editor_controller.gd`
- Create: `game/ui/user_map_editor_view_model.gd`
- Create: `tests/ugc/test_user_map_editor_commands.gd`
- Create: `tests/ugc/test_user_map_editor_history.gd`
- Create: `tests/ugc/test_user_map_editor_save_load.gd`
- Modify: `tests/run_tests.gd`

### Step 1 — Test commands independently from UI

Commands:

- place/remove/rotate rail,
- place/remove switch,
- set train start,
- place/remove station,
- place/remove pickup/spawn marker,
- change bounded metadata,
- undo/redo,
- clear draft.

Test:

- commands never mutate outside board bounds,
- undo/redo restores exact canonical hash,
- duplicate input event is processed once,
- save interruption leaves last committed draft usable,
- editor UI cannot inject unsupported object types.

### Step 2 — Implement atomic local draft save

Use temp-write + replace or the repository’s approved Profile/save pattern. Draft corruption must not corrupt the player Profile.

### Step 3 — Add minimum UI only after domain tests pass

Proposed UI:

- board canvas,
- approved tool palette,
- selection/rotation controls,
- validation findings panel,
- undo/redo,
- save draft,
- test play,
- publish entry.

Touch targets and localization follow 48dp and 140% rules.

### Step 4 — Commit

```bash
git commit -am "feat: add deterministic user map editor state"
```

---

## Task 9: Define immutable publication manifest and idempotent upload contract

**Files**

- Create: `game/ugc/user_map_upload_request.gd`
- Create: `game/ugc/user_map_publication_manifest.gd`
- Create: `game/ugc/user_map_publication_receipt.gd`
- Create: `game/ugc/user_map_publication_state.gd`
- Create: `docs/contracts/user-map-publication-api.md`
- Create: `tests/ugc/test_user_map_upload_request.gd`
- Create: `tests/ugc/test_user_map_publication_manifest.gd`
- Modify: `tests/run_tests.gd`

### Step 1 — Write identity and state tests

Test:

- upload request ID cannot be reused for different content,
- same request+content returns the same publication result,
- content hash is verified against canonical payload,
- published revision is positive and immutable,
- visibility is PRIVATE/UNLISTED/PUBLIC only,
- invalid state transitions are rejected,
- revision 2 does not mutate revision 1 manifest,
- creator public display ID is separate from private account ID.

### Step 2 — Document the API before networking code

Contract endpoints or equivalent operations:

```text
POST /user-maps/uploads
GET /user-maps/uploads/{request_id}
GET /user-maps/{user_map_id}/revisions/{revision}
POST /user-maps/{id}/visibility
POST /user-maps/{id}/delist
POST /user-maps/{id}/reports
GET /user-maps/catalog
```

Specify:

- auth requirements,
- idempotency key,
- request/response schemas,
- hash validation,
- pagination,
- retryable versus terminal errors,
- moderation states,
- rate-limit response,
- compatibility response,
- quarantine behavior,
- privacy-sensitive fields that must never be returned.

### Step 3 — Commit

```bash
git commit -am "docs: define user map publication contract"
```

---

## Task 10: Implement publication client behind a fake service first

**Files**

- Create: `game/ugc/user_map_publication_gateway.gd`
- Create: `game/ugc/fake_user_map_publication_gateway.gd`
- Create: `game/ugc/http_user_map_publication_gateway.gd`
- Create: `game/ugc/user_map_publication_service.gd`
- Create: `tests/ugc/test_user_map_publication_service.gd`
- Create: `tests/ugc/test_user_map_publication_retry.gd`
- Create: `tests/ugc/test_user_map_publication_state_machine.gd`
- Modify: `tests/run_tests.gd`

### Step 1 — Test against the fake gateway

Test:

- valid local snapshot uploads once,
- network timeout retries with same request ID,
- app restart resumes pending upload without creating a second revision,
- server hash mismatch is terminal,
- validation rejection exposes bounded finding codes,
- moderation rejection does not delete local draft,
- PRIVATE success enables creator playback,
- UNLISTED success returns a share reference,
- PUBLIC remains pending until moderation approval,
- cancelled/stale callbacks cannot overwrite a newer editor state.

### Step 2 — Implement interface boundaries

The service owns state transitions. UI emits commands and displays state only.

The HTTP gateway must:

- use authenticated requests,
- enforce TLS through platform networking,
- cap payload and response size,
- avoid logging canonical payload or private tokens,
- validate response schema,
- use bounded exponential backoff,
- distinguish offline, retryable, rejected, quarantined, and incompatible outcomes.

### Step 3 — Gate actual backend dependency

If no production backend exists, complete the fake/integration contract and mark external backend implementation `NOT_STARTED`. Do not claim online publication works from client mocks alone.

### Step 4 — Commit

```bash
git commit -am "feat: add resumable user map publication client"
```

---

## Task 11: Add server-equivalent validation and moderation fixtures

**Files**

- Create: `tools/user_map_validation/validate_user_map.gd` or use the repository’s approved headless tool location
- Create: `tools/user_map_validation/user_map_validation_report.gd`
- Create: `tests/ugc/test_server_equivalent_validation.gd`
- Create: `tests/ugc/test_user_map_moderation_contract.gd`
- Create: `tests/fixtures/user_maps/valid_minimum.json`
- Create: `tests/fixtures/user_maps/invalid_overlap.json`
- Create: `tests/fixtures/user_maps/invalid_budget.json`
- Create: `tests/fixtures/user_maps/invalid_unknown_field.json`
- Modify: CI workflow only when implementation is authorized

### Step 1 — Prove client/server validation parity

For each fixture, local and server-equivalent validators must agree on:

- canonical hash,
- blocking finding codes,
- accepted schema version,
- graph/layout signatures,
- resource budget.

Client validation may be friendlier, but server validation is authoritative.

### Step 2 — Add bounded headless smoke

The tool must:

- reconstruct from canonical payload,
- verify `FULL_MAP_READY`,
- run a bounded deterministic smoke simulation,
- enforce time and memory budgets,
- output machine-readable report,
- exit nonzero for blocking failures.

Do not label a map “solvable” unless a separately defined proof exists. Use precise outcomes such as `RECONSTRUCTABLE`, `START_SAFE`, `SMOKE_COMPLETED`.

### Step 3 — Test moderation contract

Use only synthetic strings. Test:

- overlong title/description,
- unsupported characters/control codes,
- URL/markup attempts,
- rejected tags,
- report reason enums,
- block/takedown state transitions.

### Step 4 — Commit

```bash
git commit -am "test: validate user map publication packages headlessly"
```

---

## Task 12: Implement exact published-revision playback

**Files**

- Create: `game/ugc/user_map_download_cache.gd`
- Create: `game/ugc/user_map_catalog.gd`
- Create: `game/ugc/user_map_playback_service.gd`
- Modify: shared `MapIdentity` / `RunIdentity` implementation created under SX-DEC-023
- Modify: run-session factory created under SX-DEC-023
- Create: `tests/ugc/test_user_map_playback_service.gd`
- Create: `tests/ugc/test_user_map_restart_identity.gd`
- Create: `tests/ugc/test_user_map_quarantine.gd`
- Modify: `tests/run_tests.gd`

### Step 1 — Write playback tests

Test:

- creator can play PRIVATE revision,
- another account cannot play PRIVATE revision,
- share recipient can play UNLISTED revision,
- public catalog can resolve PUBLIC revision,
- content hash mismatch blocks before `FULL_MAP_READY`,
- same-map restart uses exact publication revision and hash with a fresh run ID,
- removed/quarantined revision cannot start even if cached,
- failed UGC load does not silently start another UGC or official map,
- UGC start does not consume official automatic discovery bag,
- UGC run creates only UGC per-revision record eligibility.

### Step 2 — Implement source-specific reconstruction

```text
OFFICIAL_SEEDED
→ seed + versions + signatures

USER_AUTHORED
→ immutable canonical payload + content hash + publication receipt
```

Both yield a shared immutable `MapIdentity`, but source-specific required fields remain explicit.

### Step 3 — Commit

```bash
git commit -am "feat: play immutable published user map revisions"
```

---

## Task 13: Add creator library, UGC browser, bookmarks, reports, and blocks

**Files**

- Create: `game/ui/user_map_library_view_model.gd`
- Create: `game/ui/user_map_browser_view_model.gd`
- Create: `game/ugc/user_map_bookmark_store.gd`
- Create: `game/ugc/user_map_report_service.gd`
- Create: `game/ugc/blocked_creator_store.gd`
- Create UI scenes only after domain tests pass
- Create: `tests/ui/test_user_map_library_view_model.gd`
- Create: `tests/ui/test_user_map_browser_view_model.gd`
- Create: `tests/ugc/test_user_map_report_block.gd`
- Modify: `tests/run_tests.gd`

### Step 1 — Test creator library states

- local draft,
- validation failed,
- upload pending,
- private validated,
- unlisted,
- public review pending,
- public,
- rejected,
- quarantined,
- delisted,
- incompatible.

### Step 2 — Test player browser states

- creator identity uses public display ID only,
- per-revision personal record appears,
- unavailable map uses neutral fallback title,
- blocked creators are excluded from discovery results,
- report action is idempotent,
- pagination does not duplicate cards,
- 100+ official and growing UGC lists remain separate,
- no rating/ranking placeholder implies an unapproved algorithm.

### Step 3 — Add accessibility and localization checks

- 48dp,
- 140% text expansion,
- screen-reader order,
- text+icon/shape states,
- Reduced Motion,
- offline and unavailable messaging,
- no exposure of raw IDs intended to be private.

### Step 4 — Commit

```bash
git commit -am "feat: add user map library and safe browsing"
```

---

## Task 14: Integrate telemetry without collecting map payload or private identity

**Files**

- Create or modify telemetry schema files following repository conventions
- Create: `tests/telemetry/test_user_map_telemetry.gd`
- Modify: `tests/run_tests.gd`

### Step 1 — Test bounded event schemas

Events:

- scoped record evaluated/committed/rejected,
- draft validated,
- upload requested,
- publication state changed,
- UGC run started,
- report submitted.

Reject telemetry fields containing:

- canonical layout payload,
- raw draft save,
- email,
- access token,
- IP,
- precise location,
- unbounded free text.

### Step 2 — Commit

```bash
git commit -am "feat: add privacy-bounded user map telemetry"
```

---

## Task 15: Run adversarial integration matrix

**Files**

- Create: `tests/integration/test_scoped_records_and_ugc_flow.gd`
- Create: `tests/integration/test_ugc_failure_recovery.gd`
- Create: `tests/integration/test_ugc_profile_restart_recovery.gd`
- Modify: `tests/run_tests.gd`

### Required matrix

#### Record scopes

- official current-map update only,
- official global update only,
- both update,
- UGC update only,
- no update,
- assisted/debug/integrity invalid,
- duplicate summary,
- Profile save failure/retry.

#### Publication lifecycle

- valid private,
- valid unlisted,
- public pending/approved,
- schema rejection,
- hash rejection,
- moderation rejection,
- network timeout,
- app restart during upload,
- duplicate request,
- new revision,
- creator delist,
- moderator quarantine.

#### Playback

- creator and another player,
- exact revision restart,
- stale cache,
- incompatible client,
- removed content,
- official discovery bag unchanged,
- no official reward or goal mutation.

### Commands

```bash
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tests/run_tests.gd
```

Run repository contract checks and any approved lint/static validation commands.

### Commit

```bash
git commit -am "test: cover scoped records and user map publication flow"
```

---

## Task 16: Evidence gates before claiming readiness

### Automated evidence

- all tests pass on a fresh checkout,
- Project Contract passes,
- changed-file inventory contains only intended implementation files,
- duplicate upload and duplicate record events are idempotent across process restart,
- local/server-equivalent canonical hash parity is exact,
- no UGC path changes official record, goal, reward, or discovery state,
- no custom executable/asset field reaches reconstruction,
- exact revision restart parity passes.

### Runtime/device evidence

- Android landscape and supported aspect ratios,
- low-memory reconstruction and cache behavior,
- editor touch input and undo/redo,
- 100+ card browsing performance,
- network interruption/resume,
- 140% localization,
- screen reader,
- Reduced Motion,
- offline/unavailable state.

### Backend/operations evidence

- authenticated publishing,
- storage/CDN integrity,
- idempotency retention,
- validation worker time/memory caps,
- moderation queue and report SLA,
- rate limits and ban enforcement,
- emergency quarantine drill,
- incompatible-version drill,
- privacy and retention review.

### Human evidence

At least 5 representative users:

- 4/5 distinguish current-map record from global personal record,
- 4/5 understand editor test does not grant rewards or records,
- 4/5 can create, validate, test, and share an unlisted map,
- 4/5 understand public versus unlisted visibility,
- no critical rail/station/switch placement misunderstanding,
- report/block/unavailable messages are understandable.

### Completion boundary

Do not claim “user maps can be uploaded and played online” until:

- production backend is actually deployed,
- server validation and moderation are operational,
- two-account playback succeeds against that backend,
- quarantine and removal prevent new starts,
- Android and human gates pass.

Client mocks, local fake gateways, or planning documents alone are not online publication evidence.

---

## Adversarial traceability

| Finding | Tests / gates |
|---|---|
| `F66` global record misleading | scoped keys, result labels, no global leaderboard |
| `F67` UGC official contamination | UGC isolation tests, reward/goal/discovery invariants |
| `F68` malicious invalid upload | data-only schema, caps, server-equivalent validation, no custom assets/code |
| `F69` revision identity collision | immutable manifest, content hash, revision-scoped records |
| `F70` moderation/spam/privacy operations | auth, rate limit, report/block/takedown, public launch feature gate, privacy review |

## Verification state at planning approval

```yaml
spec_review: PASS
plan_review: PASS
implementation: NOT_STARTED
product_code_changed_by_this_decision: false
backend: NOT_STARTED
runtime_tests: NOT_RUN
android: NOT_RUN
human: NOT_RUN
moderation_operations: NOT_RUN
privacy_review: NOT_RUN
batch_status: APPROVED_PENDING_BATCH_MERGE
codex_state: CODEX_NOT_READY
```
