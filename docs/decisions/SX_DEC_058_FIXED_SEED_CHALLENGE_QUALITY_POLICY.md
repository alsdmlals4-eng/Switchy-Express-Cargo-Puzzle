# SX-DEC-058 · Fixed-Seed Challenge Quality Policy

Status: `USER_APPROVED · PLANNING_CANON · DELTA_DOR_REVIEWED · IMPLEMENTATION_NOT_AUTHORIZED`

Approved: `2026-08-11 KST`

Delta DoR review: `SX-AUD-053`

Source benchmark: `SX-BMK-001 · BMK-R08`

Product baseline: `GMB-002`

Existing challenge authority: `SX-DEC-035/036`

## Decision

기존 `Daily 1개 / Weekly 1개 · fixed-seed procedural · same-period same map/ruleset · unlimited retry · archive practice` 계약을 유지하면서, 공개 seed가 재현 가능하고 최소 하나의 **합법적 성공 witness**를 가지며 route/LIFO 선택이 퇴화하지 않았다는 publication gate를 통과해야 한다.

이 Decision은 procedural을 authored map으로 바꾸지 않고, launch 시 challenge-exclusive gameplay modifier/power/hidden score를 추가하지 않는다.

## 1. Existing contract preserved

- Campaign은 handcrafted authored map.
- Daily는 기간당 1개 fixed-seed procedural challenge.
- Weekly는 기간당 1개 fixed-seed procedural challenge.
- 동일 기간의 모든 플레이어는 같은 published identity/map/ruleset을 사용.
- unlimited retry.
- 기간 종료 후 archive practice.
- cosmetic-only reward 원칙.
- base rules only at initial launch.

## 2. Challenge identity · exact contract

```text
ChallengeIdentity
- challenge_schema_version
- cadence: DAILY | WEEKLY
- period_key
- seed_u64
- generator_version
- ruleset_version
- content_profile_version
- map_definition_sha256
- publication_revision
```

Canonical period:

- DAILY `period_key`: UTC calendar date `YYYY-MM-DD`.
- WEEKLY `period_key`: ISO week `YYYY-Www`, Monday 00:00 UTC boundary.
- client local timezone does not create a different challenge identity.

The seed is an explicit published value, not required to be derivable from the period. Same full identity must reproduce a semantically identical MapDefinition and identical map SHA.

`publication_revision` begins at 1. A published identity is immutable. Emergency withdrawal may mark it unavailable but cannot overwrite map/seed/ruleset bytes under the same identity.

## 3. Deterministic random source

Generator randomness uses a versioned counter-based deterministic stream, not engine-global RNG state.

Initial algorithm contract:

`SHA256_COUNTER_V1`

Concept:

```text
block = SHA256("switchy-challenge|v1|" + seed_u64 + "|" + stream_id + "|" + counter)
```

- independent named streams for topology, placements, cargo types and layout variants;
- integer selection uses rejection sampling instead of modulo bias when range does not divide source domain;
- no dependency on frame time, locale, device clock, hash-table iteration order or global RandomNumberGenerator state;
- generator version change creates a different identity namespace.

Exact byte interpretation/endian rules belong in the implementation spec/tests and must be stable cross-platform.

## 4. Publication pipeline

```text
CANDIDATE
→ deterministic generate MapDefinition + private WitnessPlan + structural alternatives
→ STRUCTURAL_VALID
→ legal witness replay
→ SOLVABLE_PROVED
→ quality metric extraction
→ QUALITY_SCREENED
→ publication manifest/hash freeze
→ PUBLISHED
→ ARCHIVED
```

Any failure rejects the candidate before publication.

## 5. Solvability proof algorithm

Initial proof strategy is fixed to:

`CONSTRUCTIVE_WITNESS_REPLAY_V1`

The generator constructs both:

1. the player-facing MapDefinition candidate;
2. one private legal WitnessPlan that contains a TrackLayout and legal input/action schedule sufficient to finish that map under the same ruleset.

The verifier does **not** trust a boolean `solvable` flag. It replays the WitnessPlan through current finite domain authority/headless simulation.

Witness may include only legal player actions/state choices:

- TrackLayout pieces permitted by current build rules;
- initial route-control states;
- manual/auto load-mode changes and legal pickup decisions;
- accepted route-control changes at legal times;
- ordinary run advancement.

Witness may not:

- write stack contents;
- teleport train;
- delete cargo;
- force station unload;
- bypass time limit;
- set score/success directly;
- mutate locked route controls;
- use a gameplay rule not in the challenge ruleset.

Proof PASS requires current finite success outcome before the current time limit with all required cargo delivered.

No optimality proof is required. Witness proves existence only.

## 6. Deterministic proof budgets

Use deterministic operation limits as the normative budget; wall-clock time is diagnostic only.

Initial bounds:

```text
generator placement/backtrack attempts per candidate: <= 64
structural layout alternatives emitted for screening: 2..32
witness entered-cell/event steps: <= 4096
witness accepted route-control changes: <= 128
witness load-mode/input state changes: <= 256
candidate regeneration attempts after reject for one period selection: <= 256
```

Exceeding a bound rejects the candidate; it does not publish an unproved seed.

CI/tooling may add a wall-clock safety timeout, but timeout cannot be interpreted as proof of unsolvability. It is `PROOF_INDETERMINATE/REJECT` for publication.

## 7. Structural validity

Before witness replay:

- MapDefinition schema/identity valid;
- start/incoming/buildable/blocked/placement contract valid;
- required cargo/station count nonzero;
- cargo/station types valid and redundant identity-compatible;
- generator-produced witness TrackLayout passes current build/preflight structural checks;
- no required segment enters a permanent structural trap in the witness route;
- at least 2 structurally distinct layout alternatives are emitted by the bounded candidate generator for quality screening.

The last condition prevents the initial public challenge set from degenerating into a single obvious corridor, but does not claim all alternatives are successful or equally good.

## 8. Quality metrics and reject policy

Use the same 0..3 authoring axes as SX-DEC-057 for coherence:

- Topology Complexity
- Stack Entropy
- Execution Branching

Additional publication metrics:

```text
cargo_type_count
witness_max_stack_depth
structural_layout_alternative_count
witness_decision_classes[]
witness_route_control_change_count
witness_manual_skip_or_mode_change_count
witness_revisit_count
map_hash_duplicate_flag
```

Decision classes:

```text
BUILD_ROUTE_CHOICE
LOAD_SKIP_OR_MODE
ROUTE_CONTROL_CHANGE
REVISIT_LIFO
```

### Hard rejects for both Daily and Weekly

- cargo type count < 2;
- witness max stack depth < 2;
- structural layout alternative count < 2;
- solvability witness fails/indeterminate;
- duplicate published map hash in the active version pool;
- any exclusive/unapproved gameplay rule;
- any witness/runtime isolation violation.

### Daily profile V1

- exactly one primary difficulty axis at level 2;
- other axes each 0..1;
- at least 1 witness decision class;
- execution branching may be 0 when BUILD/stack provides the primary planning burden;
- avoid all-three-axis combined pressure.

### Weekly profile V1

- at least two difficulty axes at level 2 or higher;
- no requirement for all three axes to be 3;
- at least 2 distinct witness decision classes;
- expected stack depth/route revisit may be higher than Daily but stays within base rules.

Quality metrics are publication filters, not player score or ranking metrics.

## 9. Generated-corpus calibration gate

Before generator version V1 is considered release-ready, run a deterministic calibration corpus:

```text
Daily profile candidates: 1000 seeds minimum
Weekly profile candidates: 1000 seeds minimum
```

Automated release-readiness gates:

- 100% second-run regeneration hash match for every corpus seed;
- 0 candidate may be accepted without structural PASS + witness replay PASS;
- at least 100 accepted candidates per cadence/profile from the 1000-seed corpus;
- 0 duplicate map SHA among the first 100 accepted candidates of each cadence;
- no single quality signature `(T,S,E,cargo_count,route_control_count bucket)` may exceed 20% of the first 100 accepted candidates;
- every accepted candidate satisfies its Daily/Weekly profile thresholds;
- witness operation-budget overrun candidates are rejected, never silently accepted.

The `100 accepted / 1000` and `20%` values are initial V1 quality-engineering thresholds. Changing them after empirical generator validation is a policy/config revision and must be recorded with generator/content-profile versioning; it does not silently mutate a published challenge identity.

## 10. Publication manifest / runtime boundary

Runtime receives only a published manifest and player-facing MapDefinition.

Published manifest may contain:

```text
ChallengeIdentity
map path/hash
cadence/period display metadata
archive eligibility
```

Runtime must not receive:

- WitnessPlan;
- alternate candidate layouts;
- generator rejection notes;
- internal quality signatures;
- developer optimum;
- solver/search artifacts.

Initial architecture places generator/verifier/witness tooling outside normal runtime data/export paths. Export/package validation must provide **negative proof** that witness artifacts/tool outputs are absent from Windows/Android game packages.

## 11. Publication state machine

```text
CANDIDATE
→ STRUCTURAL_VALID
→ SOLVABLE_PROVED
→ QUALITY_SCREENED
→ PUBLISHED
→ ARCHIVED

PUBLISHED → WITHDRAWN  # emergency availability state only; map identity bytes immutable
```

No in-place mutation of a PUBLISHED identity. A withdrawn period is allowed to have no active challenge rather than silently replace the same identity with different bytes.

## 12. Archive/fairness

- archive stores/references the original ChallengeIdentity.
- archive practice loads the same MapDefinition hash and ruleset identity.
- practice result is not allowed to rewrite historical published identity.
- client clock/local timezone cannot select a different challenge for the same UTC period key.
- reward remains cosmetic-only.

## 13. Implementation dependency status

Current main search identifies no current generator/solver/challenge publication runtime owner. Therefore this delta DoR closes the algorithm/data/pipeline design but grants no implementation authority.

Also, because current finite runtime still lacks some approved late gameplay features (for example Stage 8 fast/cheap track attributes), challenge V1 generation profile must use only gameplay mechanics with authoritative runtime representation at the time of implementation. `base rules only` means **implemented current base rules**, not planned-but-missing fields.

## 14. Validation contract

Implementation must prove:

1. same full ChallengeIdentity → identical MapDefinition hash across independent runs;
2. different generator version namespace cannot masquerade as same identity;
3. structural-invalid candidate never reaches PUBLISHED;
4. witness replay performs only legal current actions and reaches real SUCCESS;
5. witness timeout/budget overrun rejects publication;
6. quality rejects single-corridor/single-type/trivial candidates per V1 thresholds;
7. published identity immutable;
8. archive reproduces map hash/ruleset;
9. witness/tool/rejection artifacts absent from runtime export/package;
10. Daily/Weekly each expose at most one selected PUBLISHED identity for a period;
11. no challenge-exclusive hidden scoring/power/modifier.

## 15. Authority boundary

- `SX-DEC-035/036` fixed-seed/cosmetic-only authority remains.
- `SX-DEC-058` owns publication-quality and deterministic identity refinement only.
- no backend/service architecture is authorized here; runtime may consume a packaged or future connected publication manifest, but delivery transport is separate.
- no generic optimal solver, player hint solver or leaderboard witness authority.
- no Phase B Build Authority inheritance; SX-DEC-055 remains the only implementation-authorized package.
- actual generator/verifier/publisher/runtime-consumer implementation requires explicit separate authority.
