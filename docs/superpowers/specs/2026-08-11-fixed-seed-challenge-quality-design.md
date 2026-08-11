# SX-DEC-058 Fixed-Seed Challenge Quality Design

Status: `USER_APPROVED_DESIGN · DELTA_DOR_REVIEWED · IMPLEMENTATION_NOT_AUTHORIZED`

Decision owner: `docs/decisions/SX_DEC_058_FIXED_SEED_CHALLENGE_QUALITY_POLICY.md`

Delta review: `기획서/50_제작_검증/SX_AUD_053_SX_DEC_058_DELTA_DOR_FINAL_REVIEW.md`

Implementation plan: `docs/superpowers/plans/2026-08-11-sx-dec-058-fixed-seed-quality-delta.md`

## Goal

기존 Daily/Weekly fixed-seed procedural 계약을 보존하면서, 공개 seed가 재현 가능하고 구조적으로 유효하며 최소 한 개의 합법적 성공 해를 가진다는 publication-quality proof를 요구한다. Proof/witness는 publication tooling에만 존재하고 player runtime에는 유출되지 않는다.

## 1. Identity

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

- Daily: UTC `YYYY-MM-DD`.
- Weekly: ISO `YYYY-Www`, Monday 00:00 UTC.

Same full identity must regenerate a semantically identical map and the same SHA. Published identity cannot be mutated in place.

## 2. Deterministic entropy source

Initial source: `SHA256_COUNTER_V1`.

Input domain separation:

```text
"switchy-challenge|v1|<seed>|<stream_id>|<counter>"
```

Required named streams include at least:

```text
TOPOLOGY
PLACEMENT
CARGO_TYPE
LAYOUT_VARIANT
```

Implementation must define canonical UTF-8 encoding, unsigned byte interpretation and rejection-sampling integer selection in tests. No engine-global RNG, frame time, locale, local timezone or unordered dictionary iteration may affect generation.

## 3. Generator output contract

One candidate generation returns a private bundle:

```text
ChallengeCandidate
- identity_without_map_hash
- map_definition
- private_witness_plan
- structural_layout_alternatives[]
- generation_metrics
```

Only `map_definition` and final published identity are eligible for runtime exposure.

### Private WitnessPlan

```text
WitnessPlan
- track_layout
- initial_load_mode
- scheduled_load_mode_changes[]
- scheduled_manual_load_windows_or_pickup_choices[]
- scheduled_route_control_changes[]
- expected_terminal: SUCCESS
```

Schedule addressing must use deterministic gameplay coordinates/state checkpoints, not frame-number timing hacks. The verifier converts each scheduled item into the same legal domain calls a player action would cause.

## 4. Solvability verifier

Algorithm: `CONSTRUCTIVE_WITNESS_REPLAY_V1`.

The generator is constructive: it creates a candidate around at least one legal solution skeleton. The verifier then independently distrusts the generator's claim and replays the private witness using current finite domain authority.

The verifier must use:

- current `FiniteMapDefinition` validation;
- ordinary TrackLayout/build/preflight semantics;
- current cargo pickup/LIFO/station unload rules;
- current route-control acceptance/lock behavior;
- current time/success/failure semantics.

No direct mutation of stack, cargo registry, train cell, station result or terminal state is allowed.

Proof result:

```text
PASS
FAIL_ILLEGAL_WITNESS
FAIL_TERMINAL
INDETERMINATE_BUDGET
```

Only PASS advances to `SOLVABLE_PROVED`.

## 5. Operation budgets

Normative deterministic bounds:

```text
candidate placement/backtrack attempts <= 64
structural alternatives 2..32
witness entered-cell/event steps <= 4096
accepted route-control changes <= 128
load-mode/input changes <= 256
period candidate selection rejects before giving up <= 256
```

`INDETERMINATE_BUDGET` is a publication reject, not a proof that the map is impossible.

## 6. Structural alternatives

The generator emits at least 2 canonicalized structurally distinct TrackLayout alternatives for screening. Distinct means different canonical layout signature, not only a different initial switch selection.

At least one is the private witness layout. Other alternatives need only be structurally valid enough for route-choice ambiguity screening; they do not have to be successful.

This avoids an initial generated pool where one corridor is the only plausible build.

## 7. Quality extraction

Use the SX-DEC-057 internal difficulty rubric so authored and generated content share vocabulary.

```text
ChallengeQuality
- topology_complexity: 0..3
- stack_entropy: 0..3
- execution_branching: 0..3
- cargo_type_count
- witness_max_stack_depth
- structural_layout_alternative_count
- witness_decision_classes[]
- witness_route_control_change_count
- witness_manual_skip_or_mode_change_count
- witness_revisit_count
- route_control_count
- map_definition_sha256
```

Decision classes:

- BUILD_ROUTE_CHOICE
- LOAD_SKIP_OR_MODE
- ROUTE_CONTROL_CHANGE
- REVISIT_LIFO

Quality calculation must be deterministic from candidate/witness facts; it is not a hidden player score.

## 8. Daily profile V1

Accept only if:

```text
cargo_type_count >= 2
witness_max_stack_depth >= 2
structural_layout_alternative_count >= 2
exactly one of T/S/E == 2
all remaining axes <= 1
witness_decision_class_count >= 1
witness replay PASS
```

Daily is meant to have one readable primary planning idea, not combined expert pressure.

## 9. Weekly profile V1

Accept only if:

```text
cargo_type_count >= 2
witness_max_stack_depth >= 2
structural_layout_alternative_count >= 2
at least two of T/S/E >= 2
witness_decision_class_count >= 2
witness replay PASS
```

No requirement that all axes reach 3. Weekly may combine 2~3 known dimensions but uses base rules only.

## 10. Corpus calibration

For each new `(generator_version, ruleset_version, content_profile_version)` before release:

```text
1000 Daily-profile seeds minimum
1000 Weekly-profile seeds minimum
```

Release-readiness checks:

- independent second run has identical map SHA for 100% corpus seeds;
- accepted candidate count >=100 per cadence;
- every accepted candidate has structural PASS + witness PASS + quality PASS;
- first 100 accepted candidates have no duplicate map SHA;
- no quality signature `(T,S,E,cargo_count,route_control_count_bucket)` exceeds 20% of first 100 accepted;
- operation-budget overrun is rejected, never accepted.

Record acceptance/rejection reason counts so a weak generator can be diagnosed rather than loosening filters silently.

## 11. Publication artifacts

Planned development artifacts:

```text
challenge_candidate_report.json
challenge_witness_private.json
challenge_corpus_report.json
```

These are development/report outputs only.

Runtime-safe artifact:

```text
published_challenge_manifest.json
- identity
- map_resource/path/hash
- archive metadata
```

The manifest contains no witness, alternate layout or quality rejection note.

## 12. State machine

```text
CANDIDATE
→ STRUCTURAL_VALID
→ SOLVABLE_PROVED
→ QUALITY_SCREENED
→ PUBLISHED
→ ARCHIVED

PUBLISHED → WITHDRAWN
```

WITHDRAWN is an availability flag; it does not mutate published map bytes. No same-identity replacement.

## 13. Runtime selection

Runtime receives a published manifest from whatever delivery channel is separately authorized. SX-DEC-058 does not decide backend/service transport.

Selection rules:

- canonical UTC period key;
- at most one PUBLISHED Daily identity for current Daily period;
- at most one PUBLISHED Weekly identity for current ISO week;
- local client clock/timezone cannot alter the identity definition;
- archive loads exact stored identity/map hash.

Offline/cache behavior is a delivery/runtime implementation detail to specify when transport authority exists; it cannot fabricate a new seed when official publication data is absent.

## 14. Witness isolation / export negative proof

Generator/verifier/witness files live outside runtime data ownership.

Implementation must prove exported game packages do not contain:

```text
WitnessPlan
challenge_witness_private
alternate candidate layout corpus
solver/generator debug reports
developer optimum
```

Negative proof should inspect exported Windows/Android package contents in addition to source-tree path policy. A source `.gitignore` or UI omission is not enough.

## 15. Current implementation dependency

Fresh current-code search found no current challenge generator/solver/publisher owner. This is expected: 058 is planning authority only.

Generation profile must also restrict itself to gameplay capabilities that actually have authoritative runtime representation when implementation begins. Planned-but-not-yet-represented rules are excluded rather than approximated.

## 16. Validation matrix

Automated implementation validation must cover:

1. deterministic PRNG stream vectors;
2. identity canonicalization/UTC period keys;
3. same identity → identical map SHA;
4. one-bit seed/version change produces different namespace/input stream;
5. invalid structural candidate rejected;
6. illegal witness action rejected;
7. true legal witness reaches real current SUCCESS;
8. budget overrun becomes INDETERMINATE/REJECT;
9. Daily/Weekly hard quality filters;
10. 1000+1000 corpus health gate;
11. published identity immutability;
12. archive hash parity;
13. runtime manifest has no private witness fields;
14. exported package contains no private witness/tool reports;
15. no hidden score/power/modifier.

## 17. Scope boundary

- no generic optimum solver;
- no player hint solver;
- no backend decision;
- no generator/runtime code in this planning package;
- no rule imported only for challenge;
- no Build Authority inheritance from SX-AUD-047;
- separate implementation authority remains required.
