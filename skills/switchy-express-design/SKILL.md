---
name: switchy-express-design
description: Use for Switchy Express gameplay, route, cargo-stack, compact-token, run-lifecycle, map, Profile, onboarding, result, progression, or verification work.
---

# Switchy Express Design and Execution Discipline

## Read first

1. `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
2. `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
3. `기획서/50_제작_검증/VS03_DEFINITION_OF_READY_AUDIT.md`
4. `docs/superpowers/specs/2026-08-02-vs03-execution-architecture-design.md`
5. `docs/superpowers/plans/2026-08-02-vs03-build-segmentation.md`
6. `docs/superpowers/plans/2026-08-02-switchy-express-current-vertical-slice.md`
7. `기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md`
8. package-specific Decision specs/plans
9. actual code and tests

Older Decision plans remain behavior references. When their pseudocode, path, test command, or shared-file order conflicts with the DoR canon, use the DoR canon without changing the approved player-facing meaning.

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
dor_audit: SX-AUD-005 · PASS_WITH_PLANNING_FIXES
codex: READY_FOR_BUILD_PENDING_CANONICAL_SYNC
initial_package: VS03-01
product_implementation: NOT_STARTED
F58: NOT_MET
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
VS03-01 run lifecycle/economy/difficulty
→ VS03-02 compact footprint/DeliveryLoop seam
→ VS03-03 target3 maps/session/restart/selection
→ VS03-04 Profile transaction/records/cosmetics/unlocks/rewards
→ VS03-05 product scene/camera/HUD/result/browsers
→ VS03-06 contextual onboarding
→ VS03-07 integration/evidence handoff
```

Rules:

- start from latest main after the previous package merge
- do not run shared-hotspot packages in parallel
- only touch package-owned files unless the PR documents a necessary narrow adapter
- run full regression after each boundary connection
- no package may claim Android/human/online evidence

## Architecture Boundaries

- `main.gd`: application host only
- `PlayScene`: composition root and UI intent binding
- `RunController`: authoritative run lifecycle/tick/end
- `RunSession`: one attempt's complete mutable service graph
- `RunSessionFactory`: fully configured sessions only
- `TrainFootprint`: compressed spawn occupancy authority
- `DeliveryLoop`: existing pickup/unload integration plus optional occupancy provider
- `ProfileStore`: serialization/normalization/atomic replace
- `ProfileTransactionService`: only Profile mutation writer
- presentation: read-only ViewModels/intents

## Frame Order

Use a boundary-sliced loop with at most one cell event per segment. Calculate the next segment from remaining delta, maximum step, next cell boundary, and predicted fuel-zero boundary. Apply exact-timestamp cell event before fuel-zero evaluation. No movement or delivery event occurs after end.

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

## Adversarial Review Lenses

- distortion of approved meaning
- existing API regression
- multi-owner file overwrite
- UI/animation authority leakage
- full-cell occupancy leaking into compact footprint
- session returned before complete configuration
- fuel/event/difficulty order ambiguity
- Profile multi-writer or duplicate grant
- map identity/revision silent substitution
- target100/online scope entering VS-03
- unsupported test harness examples
- automated evidence overstated as device/human evidence

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
```

## User Decision Rule

Do not add a Decision for safe execution fixes that preserve approved meaning. Ask one material Grill Me only when implementation reveals a player-facing choice, changes core meaning, alters Vertical Slice scope, or introduces monetization/online policy not already approved.
