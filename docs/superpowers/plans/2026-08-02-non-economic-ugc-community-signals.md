# Non-Economic UGC Community Signals — TDD Implementation Plan

```yaml
decision_id: SX-DEC-026
evidence_id: EV-USER-015
status: APPROVED_PENDING_BATCH_MERGE
batch: GMB-001
slot: 10/10
implementation_state: NOT_STARTED
scope: PLANNING_ONLY
```

## Goal

Implement a community-signal layer for immutable published UGC revisions that supports favorites, verified unique players, qualified plays, one recommendation per eligible account, reports, blocks, and staff picks without granting progression rewards or contaminating official records, discovery, or economy.

## Non-Goals

- no cosmetic currency from UGC
- no creator currency or payout
- no rating stars
- no comments
- no follower graph
- no most-played/trending leaderboard
- no creator leaderboard
- no UGC signal input to official automatic map assignment
- no client-authoritative aggregates
- no executable/custom-asset UGC

## Required Predecessors

- `SX-DEC-021` reward authority and idempotent grant
- `SX-DEC-023` map/run identity separation
- `SX-DEC-024` official selection/discovery isolation
- `SX-DEC-025` immutable UGC publication revision, data-only package, server validation, scoped records

## Proposed Runtime Modules

```text
game/ugc/community/ugc_signal_type.gd
game/ugc/community/ugc_signal_request.gd
game/ugc/community/ugc_signal_receipt.gd
game/ugc/community/ugc_play_qualification.gd
game/ugc/community/ugc_signal_policy.gd
game/ugc/community/ugc_signal_client.gd
game/ugc/community/ugc_signal_state.gd
game/ugc/community/ugc_aggregate_snapshot.gd
game/ugc/community/ugc_library_state.gd
game/ugc/community/ugc_browser_view_model.gd
game/ui/ugc/ugc_signal_bar.gd
game/ui/ugc/ugc_browser_panel.gd
game/ui/ugc/ugc_report_dialog.gd
game/telemetry/run_telemetry.gd
```

## Proposed Backend Contracts

```text
POST /ugc/revisions/{revision_id}/play-receipts
POST /ugc/revisions/{revision_id}/favorites
DELETE /ugc/revisions/{revision_id}/favorites
POST /ugc/revisions/{revision_id}/recommendations
DELETE /ugc/revisions/{revision_id}/recommendations
POST /ugc/revisions/{revision_id}/reports
POST /ugc/creators/{creator_id}/blocks
GET /ugc/revisions/{revision_id}/signals
GET /ugc/browser/new
GET /ugc/browser/staff-picks
GET /ugc/library/saved
```

All write requests carry:

```text
request_id
actor_account_id
publication_revision_id
content_hash
client_schema_version
```

Play qualification additionally carries an authoritative server-verifiable run receipt, never a client boolean.

## Test Strategy

Follow red→green→refactor for each task. Unit tests must not depend on a live backend. Contract and integration tests use a deterministic fake service; online readiness requires separate real-service evidence.

---

## Task 1 — Signal enums and immutable request/receipt models

### Files

```text
game/ugc/community/ugc_signal_type.gd
game/ugc/community/ugc_signal_request.gd
game/ugc/community/ugc_signal_receipt.gd
tests/ugc/community/test_ugc_signal_models.gd
```

### Red tests

- reject unknown signal type
- require request ID, actor, revision, content hash
- receipt is immutable after construction
- recommendation and favorite have distinct types
- report requires bounded reason code
- no reward/currency field exists

### Green implementation

Create strict constructors and validation helpers. Keep transport serialization explicit and versioned.

### Refactor

Remove duplicated validation and add stable canonical serialization for idempotency tests.

---

## Task 2 — Qualified-play policy for endless survival

### Files

```text
game/ugc/community/ugc_play_qualification.gd
tests/ugc/community/test_ugc_play_qualification.gd
```

### Red tests

- 29.9 seconds, no delivery, insufficient actions → false
- 30.0 seconds authoritative active time → true
- one successful delivery → true
- one LOAD plus one switch interaction → true
- pause/background time does not satisfy threshold
- editor test/local draft/creator PRIVATE test → false
- assisted/debug/test/integrity-invalid → false
- duplicate run event ID cannot qualify twice
- client-declared `qualified=true` is ignored

### Green implementation

Pure policy over immutable run summary and publication context.

### Refactor

Expose reason codes for UI and telemetry without leaking anti-abuse internals.

---

## Task 3 — Favorite state

### Files

```text
game/ugc/community/ugc_library_state.gd
game/ugc/community/ugc_signal_client.gd
tests/ugc/community/test_ugc_library_state.gd
tests/ugc/community/test_ugc_favorite_idempotency.gd
```

### Red tests

- add favorite once
- duplicate add returns same state
- remove favorite once
- duplicate remove is no-op success
- favorite is private to actor
- favorite does not change recommendation count
- creator favorite does not affect public aggregate
- offline pending queue reuses same request ID

### Green implementation

Use local optimistic pending state but display pending distinctly until server receipt.

### Refactor

Separate local library state from public aggregate snapshot.

---

## Task 4 — Unique-player and qualified-play receipts

### Files

```text
game/ugc/community/ugc_signal_policy.gd
game/ugc/community/ugc_aggregate_snapshot.gd
tests/ugc/community/test_ugc_unique_player_policy.gd
tests/ugc/community/test_ugc_qualified_play_receipt.gd
```

### Red tests

- same actor+revision counts unique once across repeated runs
- creator never increments public unique count
- PRIVATE creator test excluded
- UNLISTED second account can count
- PUBLIC second account can count
- blocked/quarantined revision excluded
- duplicate run event ID does not increment qualified plays
- revision A and revision B have separate counts
- official map identity cannot be used as UGC revision key

### Green implementation

Represent server receipts as immutable facts. Client state only consumes aggregate snapshots.

### Refactor

Move all distinctness logic behind backend contract; client tests verify it never invents counts.

---

## Task 5 — Recommendation eligibility and idempotency

### Files

```text
game/ugc/community/ugc_signal_policy.gd
game/ugc/community/ugc_signal_state.gd
tests/ugc/community/test_ugc_recommendation_policy.gd
tests/ugc/community/test_ugc_recommendation_replay.gd
```

### Red tests

- no qualified receipt → reject
- creator → reject
- qualified non-creator → allow
- account+revision active recommendation max one
- duplicate add request returns same receipt
- remove then duplicate remove remains inactive
- add after remove becomes active once
- new revision requires new qualified receipt
- quarantined revision rejects
- suspicious actor rejection changes community aggregate only, not gameplay result
- recommendation produces no reward event

### Green implementation

Policy returns explicit allow/reject reason and immutable command. Client sends request and waits for receipt before final state.

### Refactor

Ensure UI cannot bypass policy by directly toggling count.

---

## Task 6 — Reward and official-progression isolation

### Files

```text
game/progression/progression_service.gd
game/records/scoped_record_store.gd
game/ugc/community/ugc_signal_policy.gd
tests/integration/test_ugc_signal_progression_isolation.gd
```

### Red tests

For every UGC signal event:

- wallet unchanged
- unlock state unchanged
- goal progress unchanged
- official discovery unchanged
- official global record unchanged
- official per-map record unchanged
- `SX-DEC-021` reward calculator not invoked
- no creator payout event
- official auto-map bag unchanged

### Green implementation

Keep signal service outside progression and official selection transaction boundaries.

### Refactor

Add architectural assertion or dependency test preventing community module from importing progression mutation APIs.

---

## Task 7 — Reports and blocks

### Files

```text
game/ugc/community/ugc_signal_client.gd
game/ui/ugc/ugc_report_dialog.gd
game/ugc/community/ugc_browser_view_model.gd
tests/ugc/community/test_ugc_report_policy.gd
tests/ugc/community/test_ugc_block_filter.gd
```

### Red tests

- bounded reason enum required
- optional text length capped
- duplicate account+revision+reason request idempotent
- report count not exposed in public snapshot
- block hides creator publications from actor browser
- unblock policy explicit if supported
- report does not automatically delete map
- quarantine state prevents new starts/signals
- unavailable map never silently substitutes another map

### Green implementation

Add request models, local actor filters, and moderation-state rendering.

### Refactor

Keep report text out of gameplay telemetry.

---

## Task 8 — Staff-pick operations

### Files

```text
game/ugc/community/ugc_aggregate_snapshot.gd
game/ugc/community/ugc_browser_view_model.gd
tests/ugc/community/test_ugc_staff_pick_state.gd
backend contract tests
```

### Red tests

- only moderator-authorized receipt marks staff pick
- recommendation threshold cannot auto-mark staff pick
- staff pick removal reflected
- quarantined map cannot remain visible in staff picks
- staff pick grants no rewards or official eligibility
- audit actor/time/reason present in backend event

### Green implementation

Client consumes read-only `is_staff_pick` and moderation state.

### Refactor

Avoid embedding moderator identities in public client payload beyond required display metadata.

---

## Task 9 — Browser surfaces without ranking feedback loop

### Files

```text
game/ugc/community/ugc_browser_view_model.gd
game/ui/ugc/ugc_browser_panel.gd
tests/ui/test_ugc_browser_view_model.gd
tests/ui/test_ugc_browser_panel.gd
```

### Red tests

- tabs: NEW, STAFF PICKS, SAVED, SHARED, MY MAPS
- no rating, comments, trending, follower, creator rank
- NEW ordering uses verified publish time and moderation eligibility only
- recommendation count does not reorder NEW in initial policy
- quarantined/removed/incompatible cards excluded or clearly unavailable
- 100+ entries paginate/virtualize
- 48dp targets
- 140% localization does not clip P0 labels
- Reduced Motion keeps state legible
- empty/error/offline states do not fake content

### Green implementation

Build view model from immutable page receipts. UI requests semantic pages and cannot alter ranking.

### Refactor

Keep browser policy configuration server-owned and versioned.

---

## Task 10 — Signal bar UX

### Files

```text
game/ui/ugc/ugc_signal_bar.gd
game/ui/ugc/ugc_signal_bar.tscn
tests/ui/test_ugc_signal_bar.gd
```

### Red tests

- favorite and recommendation use distinct icon+label
- recommendation locked until eligible receipt
- creator sees `내 맵` and cannot recommend
- pending state not shown as committed
- server rejection rolls back visual state without changing gameplay
- count animation interruption preserves committed value
- color is not sole encoding
- 48dp and 140% localization
- mute/haptic-off parity

### Green implementation

Render only view-model state and send intents to client/policy.

### Refactor

Remove any direct aggregate mutation from UI nodes.

---

## Task 11 — Event journal and aggregate rebuild contract

### Backend/domain tests

- immutable append event IDs
- duplicate request returns original result
- unique actor count rebuild parity
- active recommendation rebuild parity after add/remove
- favorite remains private
- qualified run event counted once
- revision isolation
- quarantine override
- staff-pick add/remove audit
- partial transaction replay
- aggregate rebuild during client read returns bounded pending state

The backend may use a relational event/outbox design or equivalent, but atomicity/replay behavior is mandatory.

---

## Task 12 — Privacy and anti-abuse boundary tests

### Tests/review

- public payload excludes email, IP, precise location, device fingerprint
- gameplay telemetry excludes report text
- anti-abuse rejection reason exposed only as bounded public code
- risk signals cannot alter score/fuel/map/record silently
- retention/spending/skill prediction not used for initial browser ranking
- data retention and moderator audit owner documented
- account deletion/anonymization behavior documented

No `PRIVACY_READY` claim without human policy review.

---

## Task 13 — Two-account end-to-end evidence

Use real service staging, not only mocks.

Scenario:

1. Account A publishes immutable UNLISTED revision.
2. Account A creator play does not increment public unique/recommendation.
3. Account B opens share link and validates content hash/receipt.
4. Account B reaches `FULL_MAP_READY` and starts run.
5. A sub-threshold run does not qualify.
6. B performs a qualified run.
7. B recommendation succeeds once.
8. Duplicate request returns same receipt and count unchanged.
9. B removes and re-adds recommendation.
10. Account C repeats to verify unique count.
11. Moderator quarantines revision.
12. New starts/signals fail without silent map substitution.

Capture request IDs, receipts, aggregate snapshots, timestamps, moderation audit, and client screenshots.

---

## Task 14 — Android and accessibility evidence

- landscape safe areas
- 48dp touch targets
- screen-reader labels where supported
- 140% localization
- color-vision simulation
- Reduced Motion
- offline/reconnect pending states
- 100+ card browser performance
- signal bar does not obscure map/HUD

---

## Task 15 — Human comprehension test

Minimum 5 participants.

Success targets, initially `TEST_VALUE`:

- 4/5 distinguish favorite from recommendation
- 4/5 understand recommendation requires actual play
- 4/5 understand UGC signals do not grant currency
- 4/5 recognize staff pick as editorial, not leaderboard rank
- 0/5 believe creator can earn currency from self-play

Record actual counts, not percentages alone.

---

## Telemetry Integration

Add bounded events defined in the design. Validate:

- no PII in gameplay telemetry
- no callback mutates signal, reward, or record
- actor/publication/run IDs remain distinct
- retries reuse request ID
- editor tests and creator tests are segmented

---

## Adversarial Regression Matrix

| Finding | Required regression |
|---|---|
| F71 | every signal leaves wallet/unlocks/goals/rewards unchanged |
| F72 | creator, duplicate actor, duplicate request, bot-ineligible actor excluded |
| F73 | no completion-rate label; qualified-play boundary tested |
| F74 | NEW not ordered by recommendation/play counts; no trending leaderboard |
| F75 | public payload PII-free; report/audit retention and moderation owner reviewed |

## Delivery Sequence

1. local pure models/policies
2. fake-service client integration
3. reward/official isolation
4. UI and browser surfaces
5. backend event/idempotency contract
6. staging two-account flow
7. moderation/quarantine operations
8. privacy review
9. Android/accessibility/human validation

Do not build UI before policy tests define authority boundaries.

## Completion Claims

Allowed after local implementation:

- `CLIENT_POLICY_IMPLEMENTED`
- `LOCAL_TESTS_PASS`

Not allowed without real service evidence:

- `ONLINE_READY`
- `ANTI_ABUSE_READY`
- `MODERATION_READY`
- `PRIVACY_READY`
- `PRODUCTION_READY`

## Planning Boundary

This file is an implementation plan only. GMB-001 canonical merge does not authorize product implementation. `CODEX_NOT_READY` remains until the project planning/implementation gate is explicitly promoted.
