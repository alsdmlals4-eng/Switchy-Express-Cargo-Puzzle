# SX-AUD-026 — Route End and Switch Direction Planning Audit

## 1. Audit identity

```yaml
audit_id: SX-AUD-026
approval_batch_id: GMB-003
decision_ids:
  - SX-DEC-040
  - SX-DEC-041
  - SX-DEC-042
base_main_observed: 4f98f968a377f7b6a11aafa4fc94d11bddbebedc
project_main_observed: efe0ab7330387d1b411962074b5f91b3043fddc8
base_release_pin: 9.4.3
correct_sheet: 1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo
state: APPROVED_PENDING_MERGE
```

## 2. User evidence

```yaml
EV-USER-028:
  claim: red one-sided station accepted; blue one-sided station not accepted
  source: user local F5 observation
  exact_local_head: UNKNOWN
  screenshot_or_log: NOT_PROVIDED
  status: VALID_OBSERVATION · ROOT_CAUSE_UNVERIFIED
EV-USER-029:
  claim: SUCCESS result displayed normally
  source: user local F5 observation
  status: PASS_WITHIN_OBSERVED_SCOPE
```

## 3. Fresh recovery findings

### F148 — Color parity is not explicitly tested

```yaml
severity: P1
surface: one-sided station runtime
claim: existing explicit one-sided terminal regression covers RED_STAR only
evidence:
  - tests/finite/integration/test_one_sided_station_terminal.gd
player_impact: blue final station may appear to require different track semantics
recommended_fix: add identical RED_STAR and BLUE_DIAMOND parity scenarios
status: APPROVED · SX-DEC-040
```

The current Preflight and delivery contracts do not visibly branch on station color in the inspected code. Therefore the user-observed blue failure is not assigned a speculative source before the exact parity test runs.

### F149 — Route-end movement can reach an assertion boundary

```yaml
severity: P1
surface: TrainController / FiniteRunController
claim: graph.next_cell can return current at a dead end while TrainController commit asserts the target is a connected next cell
evidence:
  - game/finite/rail/finite_track_graph.gd
  - game/train/train_controller.gd
  - game/finite/run/finite_run_controller.gd
player_impact: dead-end route may crash/assert or wait for timeout instead of a clear game over
recommended_fix: explicit can_advance contract and ROUTE_END terminal reason
status: APPROVED · SX-DEC-041
```

### F150 — Switch UI hides alternative connected directions

```yaml
severity: P1
surface: RouteControlOverlay / FiniteTrackSwitch
claim: overlay draws only the selected switch arrow and domain cycles only two branch exits
evidence:
  - game/demo/presentation/route_control_overlay.gd
  - game/finite/rail/finite_track_switch.gd
player_impact: player cannot see all destinations and cannot deliberately return along the incoming route
recommended_fix: show all three reciprocal directions and allow direct selection including U-turn
status: APPROVED · SX-DEC-042
```

### F151 — Active context is stale after PR #99/#100

```yaml
severity: P1
surface: canonical project status
claim: ACTIVE_CONTEXT still records old main and PR #94 as Draft while GitHub and Sheet record PR #94 archived and PR #99/#100 merged
evidence:
  - project main efe0ab7330387d1b411962074b5f91b3043fddc8
  - correct Google Sheet SX-AUD-025 closure
recommended_fix: repair ACTIVE_CONTEXT and DEVELOPMENT_GATES in this planning batch
status: APPROVED_CANON_RECOVERY
```

## 4. Decision summary

| Decision | Contract | Player-visible result |
|---|---|---|
| SX-DEC-040 | Station connectivity is color-agnostic and requires at least one reciprocal neighbor | Blue and red one-sided terminals behave identically |
| SX-DEC-041 | No legal next cell after contact/unload resolution causes FAILURE/ROUTE_END | Train stops with a clear game-over reason instead of crashing or waiting |
| SX-DEC-042 | Every reciprocal switch direction is visible and directly selectable; incoming direction permits U-turn | Player sees where the train will go and can deliberately reverse at a junction |

## 5. Strength preservation

- final delivery SUCCESS remains higher priority than route-end failure
- unlimited LIFO and TOP group unload semantics are unchanged
- BUILD/RUN authority and occupied route-control lock are unchanged
- crossing mode remains STRAIGHT/RIGHT/LEFT for this batch
- Android validation identity, package ID and canonical APK evidence are unchanged
- no new binary or licensed visual asset is required

## 6. Test-first contract

```yaml
station_parity:
  red: CHARACTERIZATION
  blue: MUST_BE_EXPLICIT
route_end:
  red: missing can_advance/failure_reason must fail
  green: FAILURE · ROUTE_END · no assertion
success_priority:
  red: route-end failure must not overwrite pending final SUCCESS
  green: final one-sided unload remains SUCCESS
switch_three_way:
  red: current cycle has two exits and TrainController forbids immediate reverse
  green: three connected directions cycle/select and U-turn advances safely
overlay:
  red: current overlay draws one selected arrow and ignores input
  green: all arrows visible; direct hit selection; phase/lock guarded
```

## 7. Visual gate

```yaml
new_visual_asset_required: false
visual_action: REUSE_WITH_SAFE_ADAPTATION
asset: procedural arrows in RouteControlOverlay
binary_changes: none
license_change: none
runtime_readability: RETEST_REQUIRED
```

## 8. Verification and evidence ceiling

This planning audit does not claim implementation. Until the implementation PR is merged and verified:

```yaml
SX-DEC-040: APPROVED · IMPLEMENTATION_PENDING
SX-DEC-041: APPROVED · IMPLEMENTATION_PENDING
SX-DEC-042: APPROVED · IMPLEMENTATION_PENDING
local_f5: RETEST_REQUIRED
windows_artifact_runtime: NOT_RUN
android_device: NOT_RUN
five_person_comprehension: NOT_RUN
production_cutover: BLOCKED
```

## 9. Rollback

The planning batch can be reverted as one documentation commit without altering product code. Implementation rollback must restore the previous switch two-exit behavior and timeout-only failure presentation together with its tests; partial rollback is forbidden because snapshot, domain and Overlay contracts must stay aligned.
