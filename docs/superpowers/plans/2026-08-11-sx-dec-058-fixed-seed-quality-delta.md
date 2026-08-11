# SX-DEC-058 Fixed-Seed Challenge Quality Implementation Plan

> **For agentic workers:** use superpowers:test-driven-development for every generator/verifier/runtime interface task and verification-before-completion before any PASS claim. This plan is not executable until SX-DEC-058 implementation authority is explicitly granted.

**Goal:** Implement deterministic Daily/Weekly candidate generation, private legal witness replay, quality screening, immutable publication manifests, archive parity, and negative witness-export proof while preserving SX-DEC-035/036 fixed-seed/cosmetic-only rules.

**Architecture:** Development-only generator uses `SHA256_COUNTER_V1` to produce a MapDefinition, a private WitnessPlan, and 2..32 structural layout alternatives. A separate verifier replays the witness through current finite gameplay authority. Quality screening uses the SX-DEC-057 T/S/E rubric plus route/LIFO decision metrics. Only frozen identity + player-facing map reach runtime. No generic optimal solver, backend, hidden score, or challenge-exclusive mechanic is introduced.

## Authority constraints

- Decision: `SX-DEC-058`.
- Exact design: `docs/superpowers/specs/2026-08-11-fixed-seed-challenge-quality-design.md`.
- Delta audit: `SX-AUD-053`.
- Existing fixed-seed/cosmetic-only authority: SX-DEC-035/036.
- BUILD authority remains SX-DEC-055_ONLY until separate 058 authorization.
- Generator profile may use only gameplay features with authoritative runtime representation at implementation time.
- Witness/private reports must not enter runtime package.

## Verification baseline

```bash
godot --headless --path . --script res://tests/run_tests.gd
```

Final unchanged implementation PR requires Project Contract, GUT, Godot + live-editor Pilot, Thin PASS plus package-content negative proof appropriate to Windows/Android exports. Hosted package proof does not equal physical/device/human PASS.

---

### Task 1: Implement canonical ChallengeIdentity and SHA256_COUNTER_V1 vectors

Planned owners:

```text
game/challenge/challenge_identity.gd       # runtime-safe identity DTO
/tools/challenge/deterministic_stream.*    # development generation authority, exact language chosen at implementation review
```

- [ ] RED: Daily UTC date and Weekly ISO week canonicalization vectors.
- [ ] RED: identity serialization is field-order canonical and stable.
- [ ] RED: fixed seed/stream/counter test vectors for SHA256_COUNTER_V1.
- [ ] RED: integer range selection uses rejection sampling and deterministic byte order.
- [ ] Implement without engine-global RNG/global clock.
- [ ] GREEN + commit.

### Task 2: Build candidate generator bundle

Planned development owner: `tools/challenge/challenge_candidate_generator.*`.

- [ ] RED: same identity-without-hash input twice → same MapDefinition semantics/private witness/alternative signatures.
- [ ] Produce `ChallengeCandidate` with MapDefinition, WitnessPlan, 2..32 canonical structural alternatives.
- [ ] Enforce ≤64 placement/backtrack attempts.
- [ ] Keep solution-bearing data in development/private output paths only.
- [ ] Do not generate gameplay capabilities absent from current runtime profile.
- [ ] GREEN + commit.

### Task 3: Structural validation gate

- [ ] Reuse current finite MapDefinition validation and build/preflight authority rather than duplicating geometry rules.
- [ ] RED: invalid start/placement/type/build surface reject.
- [ ] RED: witness layout structural/preflight failure reject.
- [ ] RED: <2 canonical layout alternatives reject.
- [ ] Emit structured rejection reasons.
- [ ] Commit.

### Task 4: Implement CONSTRUCTIVE_WITNESS_REPLAY_V1 verifier

Planned development owner: `tools/challenge/challenge_witness_verifier.*` plus focused Godot/domain harness.

- [ ] RED: direct stack mutation/teleport/forced unload/terminal success actions are rejected as illegal witness operations.
- [ ] RED: locked route-control mutation attempt rejected.
- [ ] RED: a known legal finite witness reaches actual `FiniteRunSummary.SUCCESS`.
- [ ] Route/load/control schedule is translated to ordinary current domain calls only.
- [ ] Enforce <=4096 entered-cell/event steps, <=128 accepted route-control changes, <=256 input-mode changes.
- [ ] Budget overrun → INDETERMINATE_BUDGET / publication reject.
- [ ] No optimization score returned.
- [ ] Commit.

### Task 5: Add deterministic quality metrics and Daily/Weekly filters

- [ ] Reuse exact SX-DEC-057 T/S/E rubric implementation or shared pure utility, not a divergent second definition.
- [ ] Extract cargo count, witness stack depth, alternatives count, decision classes, revisit/control/load metrics.
- [ ] RED Daily: exactly one axis=2, others <=1, >=1 decision class.
- [ ] RED Weekly: >=2 axes >=2, >=2 decision classes.
- [ ] RED both: cargo types>=2, stack depth>=2, alternatives>=2, witness PASS.
- [ ] Ensure metrics are internal publication metadata and never player score.
- [ ] Commit.

### Task 6: Build 1000+1000 deterministic corpus calibration command

Planned command owner: `tools/challenge/calibrate_challenge_generator.*`.

- [ ] Produce at least 1000 Daily-profile and 1000 Weekly-profile seed reports per version tuple.
- [ ] Independently regenerate every seed and compare map SHA.
- [ ] Require accepted count >=100 per cadence.
- [ ] Require no duplicate map SHA among first 100 accepted per cadence.
- [ ] Require no quality signature >20% of first 100 accepted.
- [ ] Report rejection reason histogram and operation-budget overruns.
- [ ] Calibration failure blocks generator-version release; it does not weaken filters automatically.
- [ ] Commit report schema/tests, not generated private witness corpus into runtime data.

### Task 7: Add publication manifest freezer/state machine

Planned owners:

```text
tools/challenge/challenge_publisher.*
game/challenge/published_challenge_manifest.gd
```

- [ ] RED: only QUALITY_SCREENED candidate may become PUBLISHED.
- [ ] Compute final MapDefinition SHA and freeze full identity.
- [ ] RED: attempts to mutate same PUBLISHED identity fail.
- [ ] Support PUBLISHED→ARCHIVED and emergency PUBLISHED→WITHDRAWN availability state without byte mutation.
- [ ] No same-identity replacement.
- [ ] Runtime manifest fields limited to identity, map reference/hash, cadence/period/archive metadata.
- [ ] Commit.

### Task 8: Add runtime current-period/archive consumer

- [ ] Runtime accepts only PUBLISHED manifest entries supplied by a separately authorized delivery source.
- [ ] Daily selects canonical UTC date identity; Weekly canonical ISO week.
- [ ] At most one published identity per cadence/period.
- [ ] Missing official publication data does not fabricate a local seed.
- [ ] Archive loads original identity/map hash.
- [ ] Unlimited retry and cosmetic-only product rules remain unchanged.
- [ ] Backend/network transport remains out of scope.
- [ ] Commit.

### Task 9: Prove witness/tool isolation from runtime package

- [ ] Define private paths for WitnessPlan/candidate/corpus reports outside normal runtime data.
- [ ] RED source-policy test: published runtime manifest has no witness/alternative/rejection fields.
- [ ] Build Windows/Android exported package in hosted validation when implementation reaches export gate.
- [ ] Inspect package contents and assert private witness/tool report names/patterns absent.
- [ ] Assert player runtime cannot import development generator/verifier owner.
- [ ] Package negative proof is required before 058 implementation acceptance.
- [ ] Commit tests/workflow only within separately authorized implementation scope.

### Task 10: Final identity/fairness/domain regression

- [ ] Full custom suite PASS.
- [ ] Determinism vectors PASS.
- [ ] 1000+1000 corpus gate PASS for candidate release version.
- [ ] Published identity immutable/archive parity PASS.
- [ ] Witness negative export proof PASS.
- [ ] Assert no changes to LIFO/load/switch/time/success/score rules.
- [ ] Assert no challenge-exclusive modifier/power/hidden score.
- [ ] Assert no player hint/optimal solution API.
- [ ] `git diff --check`, changed-file scope review and exact-head CI.

## Future transport boundary

A backend or remote schedule service can later deliver `published_challenge_manifest` entries, but that is not part of SX-DEC-058 implementation authority unless separately approved. The quality pipeline must work with a local/package publisher first so solvability/fairness does not depend on service architecture.

## Handoff

058 planning is complete enough for explicit future implementation authority. Until then, do not add generator/solver/publisher/runtime challenge code. The current Phase C first executable action remains SX-DEC-055 Task 1 / Step 1.1 RED.
