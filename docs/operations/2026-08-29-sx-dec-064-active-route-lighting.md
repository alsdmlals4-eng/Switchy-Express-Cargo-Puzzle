# SX-DEC-064 active-route lighting · incident / solution / lesson

**Status:** `RESOLVED_BRANCH_LOCAL · GitHub Issue #248 · PR_PENDING`

## Incident

The existing route overlay rendered a blue trace on every rail plus a green forecast from the authored start. A player near a switch could therefore see a branch light that the train would not take and could still see a predictive trace after a terminal result. This weakens the intended question: “under my current switch setting, where will this train go now?”

## Solution

- `FiniteSliceSessionController.render_snapshot()` now exposes the existing train’s actual previous cell.
- `ProductBoardRenderer` roots the forward projection at actual train cell + previous cell, with authored start/incoming only before train state exists.
- It emits selected descriptors only for the current deterministic continuation. A non-selected rail has no rail-light descriptor.
- The existing dim route-control target stays as an input affordance. Occupied lock is a crimson overlay on the selected rail, not another illuminated route.
- SUCCESS/FAILURE emits no future-route descriptor.

## Evidence and boundary

- RED test evidence observed the old passed-rail, alternate-rail, and terminal-route behavior; GREEN requires their absence plus the actual train root and fallback.
- Local headless Godot full suite passed: 112 cases / 13,513 assertions.
- A correct live Switchy editor instance was not available; a headless `Viewport` capture did not provide an eligible same-state pixel composite. Physical device, human comprehension, Player Experience, release, and production evidence remain `NOT_RUN`.
- There are zero new bitmap assets. The separate planning-board source was hash/dimension reread and GitHub-preserved only after user approval; it is not evidence for this runtime change.

## Five-pass adversarial review

| Loop | Attack | Result |
| --- | --- | --- |
| 1 · player causality | Could a player still mistake a non-selected branch for the train’s future path? | PASS — only selected deterministic route descriptors are emitted; the test asserts alternate absence. |
| 2 · actual-state fidelity | Could the forecast begin from stale authored start after the train has moved? | PASS — snapshot carries `train_previous_cell` and tests assert route root at the active train. |
| 3 · interaction safety | Could removing blue rail lights also remove the ability to preselect a distant branch? | PASS — `RouteControlOverlay` remains an untouched dim control affordance. |
| 4 · rule/evidence inflation | Could lock become a new route, or predictive glow imply a solver/terminal movement? | PASS — lock is an overlay, terminal descriptors are empty, and the decision excludes solver/rule change. |
| 5 · visual/runtime proof and scope | Could headless structural tests be described as an approved gameplay composite or player proof, or could a protected changed path escape the approval record? | PASS after correction — same-state render/physical/human evidence is explicitly `NOT_RUN`; the first scope audit found the approval record and prior incident record missing from its own allow-list, then the final allow-list covered all 17 changed paths. |

## Lesson and Base-promotion assessment

**Lesson:** a route preview must root at the object’s real current traversal state and visually separate “rail the object will use” from “input that can still change a future branch.”

`NO_BASE_PROMOTION`: the reusable Base requirement already distinguishes state truth, user-visible feedback, and evidence ceilings. The exact `train_previous_cell` snapshot and `RouteControlOverlay` distinction are Switchy-specific consumer mechanics, so copying them into Base would create project leakage.
