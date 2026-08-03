---
name: switchy-express-design
description: Use for Switchy Express gameplay, route, cargo-stack, compact-token, run-lifecycle, map, Profile, onboarding, result, progression, benchmarking, or verification work.
---

# Switchy Express Design and Execution Discipline

## Read first

1. `기획서/00_프로젝트_허브/START_HERE.md`
2. `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
3. `기획서/10_경험/CORE_FUN_SYSTEM_HIERARCHY.md`
4. `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
5. `기획서/50_제작_검증/VS03_PACKAGE_STATUS.md`
6. `기획서/50_제작_검증/CORE_FUN_ALIGNMENT_SYNC_CLOSURE.md`
7. `기획서/50_제작_검증/CORE_FUN_ALIGNMENT_AUDIT.md`
8. `기획서/50_제작_검증/CORE_FUN_ALIGNMENT_APPROVAL_ADDENDUM.md`
9. `docs/superpowers/specs/2026-08-03-playable-core-before-meta-sequencing-design.md`
10. `docs/superpowers/plans/2026-08-03-vs03-core-first-resegmentation.md`
11. current package-specific plan
12. `기획서/50_제작_검증/VS03_01_IMPLEMENTATION_AUDIT.md`
13. `기획서/50_제작_검증/VS03_DEFINITION_OF_READY_AUDIT.md`
14. `docs/superpowers/specs/2026-08-02-vs03-execution-architecture-design.md`
15. `docs/superpowers/plans/2026-08-02-vs03-build-segmentation.md`
16. `docs/superpowers/plans/2026-08-02-switchy-express-current-vertical-slice.md`
17. `기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md`
18. actual code and tests

`VS03_PACKAGE_STATUS.md` owns current package status. `2026-08-03-vs03-core-first-resegmentation.md` owns the approved future order. Older plans remain behavior and unchanged-package responsibility references. When old status text, package order, pseudocode, path, test command, or shared-file order conflicts with the current status, core-first plan, or DoR canon, use the newer authority without changing approved player-facing meaning.

## Core Fun Authority

The core fun is:

> Anticipate the required unload order, selectively load cargo into a LIFO stack, prepare the route in advance, and accept weight/fuel pressure to execute a large matching unload group.

Priority:

```text
LIFO load-order planning
→ route preparation
→ risk/survival decision
→ BOOST and delivery tempo
→ result learning/retry
→ records/cosmetics/map discovery/UGC
```

Every feature, balance value, UI choice, and package proposal must show how it protects or strengthens this hierarchy. Faster tapping, BOOST uptime, meta rewards, content volume, or UGC may not become a substitute for load-order and route planning.

## Product Invariants

- automatic train movement
- connected 15×10 landscape rail network
- no degree-1 dead ends
- 2-state and 3-state switches
- straight route A when available
- preview first cell equals actual next cell
- active-segment target lock
- LOAD-gated pickup and BOOST priority
- capacity-eight LIFO CargoStack
- two stations and at least four pickups per cargo type
- deterministic bounded placement and deferred recovery
- delivery grants score and fuel
- cargo slowdown
- BOOST speed increase plus extra fuel drain
- fuel zero ends run
- color plus shape encoding
- Combo equals one-arrival matching unload-group size
- one cargo equals one compact token; rear equals LIFO top
- compact capacity-eight footprint reserves at most three trailing rail cells `TEST_VALUE`
- onboarding occurs in the real run
- assisted evidence separated from standard evidence
- UI/camera/animation never own gameplay, Profile, map, record, or reward outcomes

## Current State

```yaml
gmb001: CLOSED · SX-DEC-017~026
dor_audit: SX-AUD-005 · PASS · SYNCED
vs03_01_audit: SX-AUD-006 · PASS · SYNCED
vs03_01_merge: 43972d3d23e931af3dbc81ab9b1c7d942fffb201
vs03_01_closure: 9360eff0a97f48f2234fcaf35425f80e94fac445
core_fun_audit: SX-AUD-007 · PASS_WITH_FOLLOWUPS · SYNCED
core_fun_evidence: EV-USER-017~018
core_fun_merge: a9368617102420639cc2bb83ee2b0c45505958a6
sequencing_approval: RECOMMENDED_OPTION_C
codex: READY_FOR_BUILD
current_package: VS03-02_ONLY
product_implementation: IN_PROGRESS · VS03-01_MERGED
headless_evidence: 16 cases · 7110 assertions · 0 failures
F58: NOT_MET
runtime_android_human_online: NOT_RUN
```

## Actual Test Contract

Use the repository custom runner.

```bash
./Godot_v4.7.1-stable_linux.x86_64 \
  --headless --path . --script res://tests/run_tests.gd
```

Each suite:

```gdscript
extends "res://tests/test_case.gd"
func run() -> void:
    assert_true(...)
```

Do not use nonexistent `tests/run_single.gd`, unsupported `--suite`, `func run(test)`, or `test.case()`.

## Execution Packages

```text
VS03-01 run lifecycle/economy/difficulty · MERGED_AND_VERIFIED
→ VS03-02 compact footprint/DeliveryLoop seam · READY_FOR_BUILD
→ VS03-03 target3 maps/session/restart/selection · BLOCKED
→ VS03-R1 difficulty authority alignment · BLOCKED
→ VS03-05A minimal playable core surface · BLOCKED
→ VS03-04 Profile transaction/records/cosmetics/unlocks/rewards · BLOCKED
→ VS03-05B result/collection/map browser · BLOCKED
→ VS03-06 contextual onboarding · BLOCKED
→ VS03-07 integration/evidence handoff · BLOCKED
```

Rules:

- start from latest main after the previous package merge and canonical synchronization
- do not run shared-hotspot packages in parallel
- only touch package-owned files unless the PR documents a necessary narrow adapter
- run full regression after each boundary connection
- no package may claim Android/human/online evidence
- current implementation authority applies to VS03-02 only
- VS03-R1 follows `2026-08-03-vs03-r1-difficulty-authority-alignment.md`
- VS03-05A follows `2026-08-03-vs03-05a-minimal-playable-core-surface.md`
- VS03-05A may not create Profile, result, record, reward, collection, or map-browser authority

## Architecture Boundaries

- `main.gd`: application host only
- `PlayScene`: composition root and UI intent binding
- `RunController`: authoritative run lifecycle/tick/end
- `RunSession`: one attempt's complete mutable service graph
- `RunSessionFactory`: fully configured sessions only
- `TrainFootprint`: compressed spawn occupancy authority
- `DeliveryLoop`: existing pickup/unload integration plus optional occupancy provider
- `DifficultyDirector`: authoritative union schedule for every speed/fuel pressure boundary
- `ProfileStore`: serialization/normalization/atomic replace
- `ProfileTransactionService`: only Profile mutation writer
- presentation: read-only ViewModels/intents

## Frame Order

Use a boundary-sliced loop with at most one cell event per segment. Calculate the next segment from remaining delta, maximum step, next cell boundary, actual difficulty/balance boundary, and predicted fuel-zero boundary. Apply exact-timestamp cell event before fuel-zero evaluation. No movement or delivery event occurs after end.

## Map Scope

- VS-03: exactly three distinct validated non-fallback official maps
- Production: generator diversity expansion and 100+ unique layouts
- target100 scan does not run inside the 10-second VS unit watchdog
- selected/restarted map never silently changes
- raw seed never appears in player UI

## Profile Boundary

- first local schema: v1
- production path: `user://profile_v1.json`
- tests use injectable temporary storage
- records, rewards, unlocks, discovery, and onboarding do not save independently
- operation IDs are namespaced and idempotent
- save failure cannot mutate RunState or block result/restart
- Profile begins only after VS03-05A proves the minimal playable surface automatically

## Benchmark-Backed Work Rule

For a material player-facing decision, package sequencing choice, or important product recommendation, do not rely only on internal preference.

Research and compare:

1. at least one close benchmark with a similar genre, input model, platform, or session structure;
2. at least one adjacent benchmark that solves the same design problem through a different genre or structure;
3. current professional guidance or a primary source when the question concerns platform, accessibility, economy, live operations, backend, moderation, or publication.

Use primary/official sources when possible. Record the research date and clearly separate:

- source-supported facts;
- inference for Switchy;
- unverified hypotheses requiring tests.

Benchmarking must not be a feature checklist or popularity argument. State what to learn, what not to copy, and why Switchy's LIFO-route identity changes the recommendation.

## Benchmark-Backed Grill Me Format

Every material Grill Me should include:

```text
Decision question
→ current project constraint/evidence
→ close benchmark comparison
→ adjacent benchmark or professional practice
→ comparison axes
→ A/B/C or custom options
→ industry-common default
→ Switchy-specific trade-offs
→ production cost and failure risks
→ recommended option
→ strongest adversarial objection
→ validation method and evidence gate
```

Comparison axes should include the relevant subset of:

- core goal and player fantasy
- action/input density
- cognitive load and readability
- failure model and recovery
- session length and repeat motivation
- accessibility/localization/device reach
- economy/meta/monetization influence
- implementation and content cost
- analytics, device, simulation, or human evidence required

Do not ask a material Grill Me before checking whether the question is already answered by current Decision canon or can be closed as a safe implementation correction.

## Adversarial Review Lenses

- distortion of approved meaning
- core-fun hierarchy inversion
- monocolor or other dominant strategy that removes LIFO planning
- speed/BOOST/reflex rewards overpowering group planning
- existing API regression
- multi-owner file overwrite
- UI/animation authority leakage
- full-cell occupancy leaking into compact footprint
- compact token/rear item unreadable on the minimum Android viewport
- session returned before complete configuration
- fuel/event/difficulty order or authority ambiguity
- Profile multi-writer or duplicate grant
- map identity/revision silent substitution
- target100/online scope entering VS-03
- meta implementation delaying playable-core evidence
- unsupported test harness examples
- automated evidence overstated as device/human evidence
- benchmark citation without a stated adoption/rejection rationale

## PR Gate

Every package requires:

```text
behind 0
Project Contract success
Godot Tests success
unresolved review threads 0
REQUEST_CHANGES 0
owned-file inventory
acceptance tests registered
rollback documented
NOT_RUN evidence explicit
core-fun alignment statement
benchmark/professional comparison when a material choice was made
```

## User Decision Rule

Do not add a Decision for safe execution fixes that preserve approved meaning. Ask one material, benchmark-backed Grill Me only when implementation reveals a player-facing choice, changes core meaning, alters Vertical Slice scope/package sequencing, or introduces monetization/online policy not already approved.
