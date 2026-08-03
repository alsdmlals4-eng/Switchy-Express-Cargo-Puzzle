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
6. `기획서/50_제작_검증/VS03_02_SYNC_CLOSURE.md`
7. `기획서/50_제작_검증/VS03_02_IMPLEMENTATION_AUDIT.md`
8. `기획서/50_제작_검증/CORE_FUN_ALIGNMENT_SYNC_CLOSURE.md`
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

`VS03_PACKAGE_STATUS.md` owns current package status. `2026-08-03-vs03-core-first-resegmentation.md` owns the approved future order. Older plans remain behavior and unchanged-package responsibility references. When old status text, package order, pseudocode, path, test command, or shared-file order conflicts with newer authority, use the newer authority without changing approved player-facing meaning.

## Core Fun Authority

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

Every feature, balance value, UI choice, and package proposal must show how it protects or strengthens this hierarchy. Faster tapping, BOOST uptime, meta rewards, content volume, or UGC may not replace load-order and route planning.

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
- compact token positions follow route history
- capacity-eight geometry ends at 2.18 cells and reserves at most three trailing rail cells `TEST_VALUE`
- compact occupied cells are conservative and replace full-cell spawn occupancy when provider is present
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
core_fun_merge: a9368617102420639cc2bb83ee2b0c45505958a6
core_fun_closure: 0aaa9005af9bca7560bc75b6fff3cd3f9f197a92
vs03_02_audit: SX-AUD-008 · PASS · MERGED_AND_VERIFIED · SHEET_READBACK_PASS
vs03_02_evidence: EV-VS03-02-001
vs03_02_merge: cfe6d5ca0c76942720c5c12ad5dc59aaa651b915
codex: READY_FOR_BUILD
current_package: VS03-03_ONLY
product_implementation: IN_PROGRESS · VS03_01_AND_02_MERGED
headless_evidence: 19 cases · 7499 assertions · 0 failures
F92: EVIDENCE_GAP · PRODUCT_VIEW/DEVICE/HUMAN_NOT_RUN
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
→ VS03-02 compact footprint/DeliveryLoop seam · MERGED_AND_VERIFIED
→ VS03-03 target3 maps/session/restart/selection · READY_FOR_BUILD · CURRENT
→ VS03-R1 difficulty authority alignment · BLOCKED
→ VS03-05A minimal playable core surface · BLOCKED
→ VS03-04 Profile transaction/records/cosmetics/unlocks/rewards · BLOCKED
→ VS03-05B result/collection/map browser · BLOCKED
→ VS03-06 contextual onboarding · BLOCKED
→ VS03-07 integration/evidence handoff · BLOCKED
```

Rules:

- start from latest main after previous package merge and canonical synchronization
- do not run shared-hotspot packages in parallel
- only touch package-owned files unless the PR documents a necessary narrow adapter
- run full regression after each boundary connection
- no package may claim Android/human/online evidence without execution
- current implementation authority applies to VS03-03 only
- VS03-R1 follows `2026-08-03-vs03-r1-difficulty-authority-alignment.md`
- VS03-05A follows `2026-08-03-vs03-05a-minimal-playable-core-surface.md`
- VS03-05A may not create Profile, result, record, reward, collection, or map-browser authority

## VS03-02 Implemented Contract

- `CompactWagonTokenState` mirrors CargoStack `0..8`.
- front-to-rear equals stack bottom-to-top; rear equals top.
- changed source snapshot increments one revision; unchanged snapshot does not.
- `TrainFootprint` uses route-history sampling and conservative occupied-cell reservation.
- token distance is `0.22 + index×0.28`; capacity 8 ends at `2.18` cells.
- occupied order is locomotive-first/front-to-rear; trailing occupied cells are `<=3`.
- `DeliveryLoop.configure(..., occupancy_provider = null)` preserves exact legacy fallback.
- pickup/unload synchronizes compact state once per stack mutation.
- spawn/respawn avoids compact occupied cells and existing forward exclusion.

Do not regress compact production occupancy to full-cell `train_cells()`.

## VS03-03 Current Contract

Implement only:

```text
exactly 3 distinct validated official maps
+ immutable MapDefinition and strict MapCatalog
+ fully configured RunSessionFactory
+ explicit start/incoming train cells
+ exact same-map restart with fresh mutable services/identities
+ automatic undiscovered-first selection
+ discovered-map semantic reselection domain
```

Requirements:

- target3 is VS scope; target100 remains Production.
- MapDefinition contains stable map identity, seed, generator/content version, and required signatures.
- catalog construction rejects duplicates, fallback maps, invalid starts, and signature drift.
- session factory returns success only after all mutable services and adapters are configured.
- restart reuses the same immutable map definition but creates a new run ID, transaction ID, and mutable object graph.
- automatic selection is deterministic under explicit state and cannot starve eligible undiscovered maps.
- manual/restart requests do not consume automatic discovery state incorrectly.
- selected or restarted map is never silently substituted.
- raw seed is not player-facing.

Forbidden in VS03-03:

- Profile writer or final persistence schema
- product Scene/HUD/result/camera/browser presentation
- VS03-R1 difficulty union schedule
- onboarding
- target100 generator expansion/audit
- UGC/online

## Architecture Boundaries

- `main.gd`: application host only
- `PlayScene`: composition root and UI intent binding
- `RunController`: authoritative run lifecycle/tick/end
- `RunSession`: one attempt's complete mutable service graph
- `RunSessionFactory`: fully configured sessions only
- `TrainFootprint`: compressed spawn occupancy authority
- `DeliveryLoop`: pickup/unload integration plus optional occupancy provider
- `DifficultyDirector`: authoritative union schedule after VS03-R1
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

For a material player-facing decision, package sequencing choice, or important product recommendation, research and compare:

1. at least one close benchmark;
2. at least one adjacent benchmark solving the same problem differently;
3. current professional guidance or primary source when relevant.

Record the research date and separate source-supported facts, Switchy inference, and unverified hypotheses. State what to learn, what not to copy, production cost, strongest failure risk, and validation Gate.

## Benchmark-Backed Grill Me Format

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

Do not ask a material Grill Me before checking whether current Decision canon already answers it or whether it is a safe implementation correction.

## Adversarial Review Lenses

- distortion of approved meaning
- core-fun hierarchy inversion
- monocolor or other dominant strategy that removes LIFO planning
- speed/BOOST/reflex rewards overpowering group planning
- existing API regression
- multi-owner file overwrite
- UI/animation authority leakage
- full-cell occupancy leaking into compact footprint
- occupied rail segment under-reservation
- compact token/rear item unreadable on minimum Android viewport
- session returned before complete configuration
- stale mutable service reuse on restart
- map identity/version/signature silent substitution
- target100/online scope entering VS-03
- unsupported test harness examples
- automated evidence overstated as device/human evidence
- benchmark citation without adoption/rejection rationale

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
