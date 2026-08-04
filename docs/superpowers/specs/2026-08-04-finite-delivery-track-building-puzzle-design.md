# Finite Delivery Track-Building Puzzle Design

```yaml
status: APPROVED_DESIGN
approval: GMB-002 · SX-DEC-027~036
user_evidence: EV-USER-019
adversarial_audit: SX-AUD-012
implementation: NOT_STARTED · REPLAN_REQUIRED
```

## Goal

Rebase Switchy Express from an endless fuel-survival loop to a finite authored logistics puzzle while preserving its strongest identity: selective pickup order, LIFO unloading, visible cargo grouping, and branch planning.

## Design summary

The player reads a map containing a start point, cargo points, stations, terrain, and no-build zones. During a time-frozen preparation phase, the player freely builds a rail network and pays per placed piece. The run can start only when every required cargo and station is structurally reachable. During automatic train movement, the player holds LOAD to pick up selected cargo, may toggle auto-load, and taps switches to determine the route. Cargo is stored without a capacity limit. Stations unload only the contiguous matching group at the LIFO top. Large groups create Combo acceleration and score. The stage succeeds after the final unload and fails when the time limit expires with cargo undelivered.

## Core player decisions

1. Which rail geometry makes every required point reachable?
2. Which cargo should the train encounter and load first?
3. Which cargo should remain uncollected until a later pass?
4. Which station order exposes the current LIFO top?
5. Where should switches be pre-set or changed?
6. Where is expensive speed rail worth its cost?
7. Where can budget rail save cost without missing the time limit?
8. Is a larger Combo worth additional travel or construction?

## System boundaries

### MapDefinition

Owns terrain, build surface, start, stations, cargo, time limit, star targets, leaderboard caps, recommended blueprint, and immutable ruleset identity.

### TrackLayout

Owns placed track pieces, shape, performance property, one-way direction, initial switch states, and final build cost. It is separate from MapDefinition so the same authored puzzle can support many player solutions.

### BuildSession

Handles placement, rotation, replacement, removal, full refunds, cost preview, ghost blueprint visibility, and undo/redo. Time does not run.

### PreflightValidator

Blocks only structural impossibility: unreachable required points and mandatory traps. It does not solve pickup order, LIFO order, switch timing, or the time objective.

### DeliveryRun

Owns automatic motion, manual/auto loading state, switch state, unlimited CargoStack, station unload, Combo, time limit, success/failure sealing, pause integrity, and immutable result summary.

### Progression

Owns accumulated speed/cost/score stars, map leaderboard eligibility, tutorial/chapter progress, challenge history, and cosmetic-only rewards.

## Track model

Track geometry and performance property are separate dimensions.

Geometry:

- straight
- curve
- switch
- crossing with independent paths
- turnaround
- later map-authorized tunnel and bridge

Properties:

- normal
- speed
- budget
- one-way

Initial numeric values remain TEST_VALUE and must not be hard-coded as permanent balance before simulation and human playtests.

## Loading and unloading

- One cargo item per map point.
- Manual loading is the default; cargo is loaded only while LOAD is held.
- Auto-load is a toggle available during the run.
- Passing cargo without loading leaves it on the map.
- Loading never stops or slows the train.
- CargoStack has no gameplay capacity limit.
- The newest item is TOP.
- A station unloads only the contiguous TOP group matching its type.
- A mismatched station is passed without stopping.

## Combo

- Combo equals the unload-group count for one station arrival.
- Total visible unload time is capped at one second.
- More items animate at a faster per-item cadence.
- Combo 2+ grants temporary speed and score.
- Speed time refreshes to the longer of current remaining duration and new duration; it does not add.
- The timer starts after departure.
- Final speed is capped.

## Results and optimization

Every map exposes three fixed targets:

- Speed star
- Cost star
- Score star

Stars accumulate across different successful runs. Three stars unlock leaderboard submission for that map.

Leaderboards:

- Speed: fastest success within map cost cap
- Price: lowest final construction cost within time limit
- Score: normalized time/cost score with Combo contribution

Public records show summary metrics, not route layouts or replays.

## Content structure

- Stages 1–10: authored tutorial, one major lesson per stage
- Stage 10: comprehensive exam
- Stage 11+: themed chapters
- Chapter stages open in groups of three; clearing two opens the next group
- Chapter exam combines taught mechanics without introducing a new rule
- Daily and weekly challenges use fixed seeds and unlimited retries
- Unlearned mechanics are introduced with a concise micro tutorial
- Expired challenges remain playable in an archive, while official results stay frozen

## Visual requirements

- Ghost recommended rail must never look authoritative or optimal.
- Track geometry and performance property need distinct non-color-only signs.
- Switch and crossing silhouettes must be distinguishable.
- TOP and the next unload group must remain readable with 8, 16, and 32 cargo items.
- Each unloaded object must visibly leave the train within the one-second total animation.
- Combo acceleration feedback must not obscure upcoming switches or cargo.

## Failure handling

A failed attempt returns to the build phase with the TrackLayout intact. Cargo, train, time, and switch runtime state reset. Feedback identifies one evidence-backed problem and one actionable revision without installing the solution.

## Migration

Reusable candidates:

- movement interpolation and path following
- switch targeting concepts
- CargoStack and LIFO unload domain
- cargo/station color+shape identity
- map/session immutable identity patterns

Legacy or removed:

- endless survival
- fuel
- BOOST
- cargo capacity 8
- cargo slowdown
- pickup respawn
- timed difficulty escalation
- switch auto-reset

## Acceptance gates before implementation

1. New Definition of Ready approved.
2. MapDefinition/TrackLayout identities specified.
3. Exact rail graph semantics specified.
4. Unlimited stack representation validated by mockup or prototype.
5. At least three authored map specifications exist.
6. Star/score targets have a repeatable calibration method.
7. Legacy-code migration and rollback plan exists.
8. No old VS03 plan remains current authority.
9. GitHub and the correct 12-tab Sheet contain the same IDs and status.
