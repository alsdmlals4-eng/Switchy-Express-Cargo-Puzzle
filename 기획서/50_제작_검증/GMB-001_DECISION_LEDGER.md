# GMB-001 Grill Me Decision Ledger

```yaml
batch_id: GMB-001
protocol: SX-OPS-001
baseline_main: 993c3ed1aaee172be52a8a8899685b419f7f6d97
branch: batch/gmb-001
pull_request: 29
batch_size: 10
approved_count: 10/10
decision_range: SX-DEC-017~026
evidence_range: EV-USER-006~015
status: FROZEN · CONTENT_AUDIT_PASS · FINAL_HEAD_VERIFICATION
canonical_main_sync: NOT_YET_MERGED
sheet_state: FROZEN_PENDING_FINAL_HEAD_SYNC
codex_state: CODEX_NOT_READY
next_decision: BLOCKED_UNTIL_GMB001_CLOSED
```

## Authority

- This is the branch ledger for the first regular `SX-OPS-001` batch.
- The batch contains exactly ten user-approved planning Decisions and no `SX-DEC-027`.
- Product code, Scene, Resource, asset, and runtime data are outside this batch.
- Canonical merge is authorized only after final exact-head checks and final-head Sheet readback pass.
- Merge does not authorize implementation or mark runtime/Android/human/online evidence as passed.

## Inventory

| Slot | Decision | Evidence | Canonical responsibility | State |
|---:|---|---|---|---|
| 1 | `SX-DEC-017` | `EV-USER-006` | result cause 1 + action 1 + neutral fallback | APPROVED_PENDING_CANONICAL_MERGE |
| 2 | `SX-DEC-018` | `EV-USER-007` | PREP zoom + `FULL_MAP_READY` + active full map | APPROVED_PENDING_CANONICAL_MERGE |
| 3 | `SX-DEC-019` | `EV-USER-008` | standard records + cosmetic-only progression | APPROVED_PENDING_CANONICAL_MERGE |
| 4 | `SX-DEC-020` | `EV-USER-009` | DEFAULT / DUAL_PATH / CURRENCY_ONLY unlocks | APPROVED_PENDING_CANONICAL_MERGE |
| 5 | `SX-DEC-021` | `EV-USER-010` | bounded eligible-run cosmetic-currency rewards | APPROVED_PENDING_CANONICAL_MERGE |
| 6 | `SX-DEC-022` | `EV-USER-011` | difficulty prewarning + persistent pressure band | APPROVED_PENDING_CANONICAL_MERGE |
| 7 | `SX-DEC-023` | `EV-USER-012` | exact same-map restart + validated official catalog target | APPROVED_PENDING_CANONICAL_MERGE |
| 8 | `SX-DEC-024` | `EV-USER-013` | undiscovered-first official selection + discovered-map reselection | APPROVED_PENDING_CANONICAL_MERGE |
| 9 | `SX-DEC-025` | `EV-USER-014` | official scoped records + data-only user-map publication | APPROVED_PENDING_CANONICAL_MERGE |
| 10 | `SX-DEC-026` | `EV-USER-015` | non-economic UGC community signals | APPROVED_PENDING_CANONICAL_MERGE |

## Responsibility Documents

| Decision | Spec | Plan |
|---|---|---|
| 017 | `docs/superpowers/specs/2026-08-02-result-failure-feedback-design.md` | `docs/superpowers/plans/2026-08-02-result-failure-feedback.md` |
| 018 | `docs/superpowers/specs/2026-08-02-preparation-zoom-full-map-camera-design.md` | `docs/superpowers/plans/2026-08-02-preparation-zoom-full-map-camera.md` |
| 019 | `docs/superpowers/specs/2026-08-02-records-cosmetic-only-progression-design.md` | `docs/superpowers/plans/2026-08-02-records-cosmetic-only-progression.md` |
| 020 | `docs/superpowers/specs/2026-08-02-goal-or-currency-cosmetic-unlocks-design.md` | `docs/superpowers/plans/2026-08-02-goal-or-currency-cosmetic-unlocks.md` |
| 021 | `docs/superpowers/specs/2026-08-02-bounded-run-cosmetic-currency-rewards-design.md` | `docs/superpowers/plans/2026-08-02-bounded-run-cosmetic-currency-rewards.md` |
| 022 | `docs/superpowers/specs/2026-08-02-difficulty-escalation-communication-design.md` | `docs/superpowers/plans/2026-08-02-difficulty-escalation-communication.md` |
| 023 | `docs/superpowers/specs/2026-08-02-same-seed-restart-curated-map-catalog-design.md` | `docs/superpowers/plans/2026-08-02-same-seed-restart-curated-map-catalog.md` |
| 024 | `docs/superpowers/specs/2026-08-02-automatic-map-discovery-and-reselection-design.md` | `docs/superpowers/plans/2026-08-02-automatic-map-discovery-and-reselection.md` |
| 025 | `docs/superpowers/specs/2026-08-02-hybrid-map-records-and-user-published-maps-design.md` | `docs/superpowers/plans/2026-08-02-hybrid-map-records-and-user-published-maps.md` |
| 026 | `docs/superpowers/specs/2026-08-02-non-economic-ugc-community-signals-design.md` | `docs/superpowers/plans/2026-08-02-non-economic-ugc-community-signals.md` |

Cross-decision consumer: `기획서/00_프로젝트_허브/GMB-001_CANONICAL_DECISIONS.md`.

Audit: `기획서/50_제작_검증/GMB-001_PREMERGE_AUDIT.md`.

## Canonical Decision Summary

### Result, camera, progression

- Result preserves score/time/max Combo/new record and shows one evidence-supported cause and one action; weak evidence uses neutral fallback.
- First PREP may zoom slightly, but authoritative progression starts only after `FULL_MAP_READY`; active run remains fixed full map.
- Standard records are score, survival, max Combo. Assisted/integrity-invalid/debug/test runs are ineligible.
- Cosmetics change no gameplay, collision, camera, readability, or record eligibility.
- Unlock modes are DEFAULT, DUAL_PATH, and CURRENCY_ONLY. Purchase never forges goal completion.
- Eligible standard runs receive bounded reward components; raw score and survival time do not directly mint currency.

### Difficulty, restart, official maps

- DifficultyDirector or equivalent owns schedule/commit; UI reads immutable forecast/events only.
- `RESTART` preserves exact official map identity and reconstruction signatures while creating new run/reward/record IDs and fresh mutable services.
- `NEW RUN` assigns eligible undiscovered official maps before replay and does not let manual/restart consume automatic bags.
- Fallback and duplicate layouts do not count toward the 100+ official goal.
- Minimum three validated official maps belong to the local VS; target 100+ belongs to Production.

### Scoped records and UGC

- Eligible official runs atomically evaluate all-official-map global personal records and exact-map personal records.
- A dual scope update produces at most one record reward component.
- User maps use data-only canonical layouts, immutable publication revisions, content hashes, and server validation receipts.
- UGC draft/editor tests update no standard records, goals, discovery, or rewards.
- Online editor/backend/publication/moderation is Production scope, not immediate VS scope.

### Community signals

Allowed initially:

- private favorite
- verified unique player
- verified qualified play
- one active recommendation per eligible account and immutable revision
- report, block, explicit staff pick

Disabled initially:

- UGC currency/unlock reward
- creator reward/payout
- rating, comments, followers
- trending/most-played/creator leaderboards
- engagement-weighted official map selection

Because the game is endless survival, generic completion rate is not used. Qualified play is a minimum anti-spam activity receipt, not a quality score.

## Protected Contracts

- UI·camera·Tween·animation·onboarding·result·browser·editor·community views are non-authoritative.
- `FULL_MAP_READY` precedes authoritative progression, discovery, record commit, and community qualification.
- Assisted first runs remain separate from standard records, goals, variable rewards, and balance evidence.
- Map, UGC revision, run, record, reward, selection, upload, and signal identities remain separate.
- Profile mutations are atomic/idempotent or replay-safe.
- Same-map restart creates fresh mutable services.
- Manual/restart/UGC load failure never silently substitutes another map.
- UGC packages contain no executable/custom asset/ruleset override.
- UGC cannot mutate official map count, discovery, records, goals, rewards, wallet, unlocks, or official selection weight.
- All balance, timing, catalog, UI, quota, moderation, and anti-abuse values remain `TEST_VALUE` until validated.

## Adversarial Findings

| Scope | Findings | State |
|---|---|---|
| Result | F26~F30 | PLANNING_FIXED · RUNTIME_NOT_RUN |
| Camera | F31~F35 | PLANNING_FIXED · DEVICE_NOT_RUN |
| Records/Cosmetics | F36~F40 | PLANNING_FIXED · RUNTIME_NOT_RUN |
| Unlocks | F41~F45 | PLANNING_FIXED · ECONOMY_NOT_RUN |
| Rewards | F46~F50 | PLANNING_FIXED · ECONOMY_NOT_RUN |
| Difficulty | F51~F55 | PLANNING_FIXED · RUNTIME_NOT_RUN |
| Restart/Catalog | F56~F60 | F58_NOT_MET · TARGET_AUDIT_NOT_RUN |
| Assignment/Browser | F61~F65 | PLANNING_FIXED · FLOW_NOT_RUN |
| Records/UGC Publication | F66~F70 | PRODUCTION_GATES_NOT_RUN |
| UGC Community | F71~F75 | PRODUCTION_GATES_NOT_RUN |

Known open P0/P1 design findings: 0.

## Evidence Boundary

```yaml
planning_specs: PASS
planning_tdd_plans: PASS
product_code_changed: false
scene_resource_asset_changed: false
runtime_features: NOT_RUN
android: NOT_RUN
human: NOT_RUN
localization_accessibility: NOT_RUN
economy_simulation: NOT_RUN
official_map_target_3: NOT_RUN
official_map_target_100: NOT_RUN
ugc_editor_backend: NOT_STARTED
moderation_privacy_two_account: NOT_RUN
community_anti_abuse: NOT_RUN
```

## Preliminary Audit Evidence

At head `1738e637fe6a8169dda2ff0158d6ca45c56e7949`:

- ahead 52 / behind 0
- 33 changed files, planning-only
- Project Contract run 193 success
- Godot Tests run 184 success
- unresolved review threads 0
- REQUEST_CHANGES 0
- PR open, Draft, mergeable

The audit and ledger updates create a new head. The same checks and final Sheet sync must run once more on that exact head before canonical merge.

## Final Gate

```text
final exact-head CI/inventory/reviews
+ final-head Sheet frozen 12-tab readback
+ expected-head protected merge
= canonical merge authorized
```

Until merge and Sheet closure finish:

- no `SX-DEC-027`
- no product implementation
- no unrelated refactor
- `CODEX_NOT_READY`
