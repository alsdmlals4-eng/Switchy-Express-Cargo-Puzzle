# SX-AUD-031 — Route-End / Direct Switch Implementation Audit

Date: `2026-08-08 KST`

## Verdict

`MERGED_MAIN_VERIFIED · PASS_WITH_PHYSICAL_GATES_OPEN`

PR #106 implemented the already-approved `SX-DEC-041` and `SX-DEC-042` contract without widening Scene/Resource/Theme/project-settings/signal authority and was merged as product main `12d1ef9b5c49e401d32dfc283db11a12574b5da3`. Automated evidence closes the implementation/merge gate only; local F5, physical Windows runtime, Android device, connected HiGodot, visual/touch readability, and human comprehension remain open.

## Authority

- Baseline main before PR #106: `23981d0bb3d65487951be2cbbc5ee365da624e1e`
- Implementation branch: `feat/route-end-switch-direct-selection`
- Implementation code head: `9f5aeb626c7e81e9d90232f84971c13211e808b1`
- Reviewed final PR head: `9c884e85efa9b60cbba21253fc71db034cc753d0`
- Product merge: `12d1ef9b5c49e401d32dfc283db11a12574b5da3`
- Pull request: `#106 feat: implement route-end and direct switch selection`
- `SX-DEC-041` — contact/unload resolution precedes `FAILURE/ROUTE_END`; final required delivery SUCCESS wins.
- `SX-DEC-042` — SWITCH exposes three reciprocal directions, direct selection, incoming-direction U-turn, occupied lock.
- `SX-DEC-044` — GUT 9.7.1 is the formal new RED/GREEN authority.
- `SX-DEC-046` / `VIS-014` — reuse the existing procedural `RouteControlOverlay`; no new binary visual/audio asset.

## RED evidence

### Initial formal GUT RED

At PR head `3337f7f625ddd972ef9ab82337cf80868d12303a`, hosted GUT run `31178984052` produced the expected RED state:

- total tests: `18`
- passing: `6`
- failing: `12`
- route-end/failure reason behavior missing
- three-port switch/direct selection/U-turn behavior missing
- overlay deterministic direction targets and pending intent APIs missing
- protected production snapshot verification and GUT vendor reconciliation still completed without unauthorized mutation

The failures matched the approved missing behavior rather than a pre-existing unrelated failure.

### Legacy runner RED characterization

At head `3517430743605eab69be155c93b790f04ea8d472`, the existing Godot regression suite failed only the newly expanded `test_interactive_route_controls` contract because `select_switch_exit` / `available_exits` were not yet implemented. This isolated the Task 2 RED from the already-green Task 1 route-end changes.

## Implemented behavior

### SX-DEC-041 — route-end ordering and failure reason

- `TrainController.can_advance()` exposes whether the current target is a reciprocal legal neighbor.
- Dead-end movement no longer relies on an assertion path; it safely remains on the current cell.
- `FiniteRunController` resolves current-cell contact and delivery handling before route exhaustion.
- Non-final unload at a route end completes its unload sequence before `ROUTE_END` is frozen.
- Final required delivery has pending SUCCESS priority over same-cell route exhaustion.
- `FiniteRunSummary.failure_reason` is immutable.
- Timeout uses `TIME_EXPIRED`; route exhaustion uses `ROUTE_END`; successful summaries carry no failure reason.
- Presenter/HUD copy distinguishes route-end failure from timeout while preserving Retry/Edit recovery.

### SX-DEC-042 — three-direction direct switch selection

- `FiniteTrackSwitch.connected_ports()` exposes all reciprocal switch ports in stable cardinal order.
- `FiniteTrackSwitch.select_exit()` accepts any connected port, including the incoming direction for U-turn.
- `FiniteTrackSwitch.cycle()` cycles all three reciprocal choices and returns to the authored initial state.
- `FiniteTrackGraph.select_switch_exit()` preserves occupied-lock authority.
- Route-control state exposes `available_exits` plus the selected direction.
- Product/open-terminal preflight search recognizes reciprocal SWITCH traversal including the incoming direction; CROSSING keeps its existing `STRAIGHT/RIGHT/LEFT` behavior.
- Legacy authored-route regression drivers make explicit switch selections like the product user instead of depending on the superseded two-state/automatic-merge assumption.

### VIS-014 — procedural direct-selection overlay

- `RouteControlOverlay.direction_targets_for_test()` exposes deterministic switch target descriptors.
- Every displayed SWITCH direction remains visible; selected state is differentiated by weight/fill as well as color.
- The automated descriptor contract enforces `>=44 px` targets when the rendered board cell permits that size.
- `_gui_input` accepts pointer selection only in `RUNNING` / `UNLOADING`.
- Locked switches and `BUILD` / `PAUSED` / terminal phases reject direct-selection input.
- Overlay requests are queued as `{ cell, cycle_count, target_port }`.
- `ProductFiniteSlice` consumes the queue and dispatches the existing `BOARD_CELL` command boundary exactly `cycle_count` times.
- Overlay never mutates graph authority directly.
- No new signal declaration or signal connection was added.

## Automated evidence

### Implementation code head

Head `9f5aeb626c7e81e9d90232f84971c13211e808b1`:

| Gate | Run | Result | Evidence |
|---|---:|---|---|
| GUT 9.7.1 Tests | `31226403455` | PASS | `18/18`, `129` assertions, JUnit PASS, vendor pre/post PASS, protected production snapshot PASS |
| Godot Tests | `31226403396` | PASS | `92` cases, `11,494` assertions, `0` failures |
| Project Contract | `31226403440` | PASS | exact-head contract gate green |
| Validate Thin Adapter Migration | `31226403397` | PASS | exact-head adapter gate green |
| Windows Demo Export | `31226403496` | PASS | export/package/hash workflow only; physical runtime not inferred |
| Real-project live-editor pilot within Godot Tests | `31226403396` | PASS | project regression `92/0/11,494`, protected source integrity PASS; `production_adapter_ready=false` preserved |

GUT evidence artifacts from run `31226403455`:

- JUnit artifact ID: `9012238410`
- Phase-B evidence artifact ID: `9012238672`

Godot/live-editor pilot artifact from run `31226403396`:

- artifact ID: `9012244538`

### Final reviewed PR head

Final PR head `9c884e85efa9b60cbba21253fc71db034cc753d0` re-ran the required checks after canon/audit updates:

- GUT 9.7.1 Tests `31226750561`: PASS
- Godot Tests `31226750559`: PASS
- Project Contract `31226750577`: PASS
- Validate Thin Adapter Migration `31226750563`: PASS
- Windows Demo Export `31226750575`: PASS

The exact reviewed HEAD was then merged with expected-head protection.

## Scope and authority audit

Final PR changed-file inventory contained GDScript product logic, tests/test helpers, the implementation plan, and two canon/evidence Markdown files only.

Not changed in PR #106:

- `.tscn`
- `.tres`
- `.res`
- `project.godot`
- Theme resources
- binary visual/audio assets
- autoload or InputMap configuration
- signal declarations / signal connections for direct selection

The implementation therefore stayed inside the approved Codex/GDScript boundary and did not claim HiGodot-authored Scene/Resource changes.

## Adversarial findings

### Closed during implementation

1. **Stale test doubles after the new `can_advance` / `failure_reason` interfaces** — fixed by updating the legacy test doubles and adding explicit route-end/time-expired assertions.
2. **Legacy two-state switch assumptions** — not fixed by weakening the new product rule. Regression fixtures were changed to choose an explicit destination before a switch, preserving the approved absolute-direction/U-turn semantics.
3. **GDScript type inference error in an updated regression test** — corrected with an explicit `Vector2i`; the subsequent exact-head suite passed.
4. **Windows export failure observed on an intermediate head** — traced to the same headless test failure; after the underlying regression issue was fixed, exact-head Windows Demo Export passed.

### Still open by evidence ceiling

- local F5 route-end result wording: `RETEST_REQUIRED`
- local F5 three-arrow visibility and pointer target feel: `RETEST_REQUIRED`
- physical Windows artifact runtime / visual / audio / physical input: `NOT_RUN`
- Android landscape device smoke: `NOT_RUN`
- connected HiGodot authoring session: `NOT_RUN`
- five-person comprehension / touch readability: `NOT_RUN`
- production cutover: `BLOCKED`

The old user-local BLUE one-sided-station failure remains historical/stale runtime evidence until merged main is fetched and reproduced; automated color parity is green and does not by itself invalidate that prior local observation.

## Review and merge surface

Before merge of PR #106:

- final reviewed head: `9c884e85efa9b60cbba21253fc71db034cc753d0`
- PR mergeability: `true`
- review submissions: `0`
- inline review threads: `0`
- PR comments: `0`
- no `REQUEST_CHANGES` evidence
- correct Sheet pre-merge same-ID readback completed for `SX-DEC-041`, `SX-DEC-042`, `SX-DEC-046`, `VIS-014`, `SX-AUD-031`, Hub/Order/Production surfaces

Merge result:

- method: merge commit
- expected head: `9c884e85efa9b60cbba21253fc71db034cc753d0`
- product merge SHA: `12d1ef9b5c49e401d32dfc283db11a12574b5da3`
- result: `merged=true`
- open PRs immediately after merge: `0`

## Post-merge closure

`SX-DEC-041` and `SX-DEC-042` are now `MERGED_MAIN_VERIFIED` for automated implementation evidence. `VIS-014` is implemented with automated component evidence and no new binary asset.

The next authority is physical/manual validation, not additional speculative gameplay changes:

1. Fetch/Pull merged main and reopen Godot.
2. F5 verify BLUE one-sided station parity against the stale prior local observation.
3. F5 verify ROUTE_END copy and final-delivery SUCCESS priority.
4. F5 verify three direction arrows, direct selection, U-turn, occupied lock, and practical pointer/touch target readability.
5. Run physical Windows artifact visual/audio/input smoke.
6. Run Android landscape device smoke and later five-person comprehension.

`PASS_WITH_PHYSICAL_GATES_OPEN` remains the ceiling until those observations exist.
