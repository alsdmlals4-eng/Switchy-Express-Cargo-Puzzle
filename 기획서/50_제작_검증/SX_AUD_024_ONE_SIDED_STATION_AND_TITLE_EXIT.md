# SX-AUD-024 — One-Sided Station and Title Exit Audit

- Date: `2026-08-06`
- Parent decisions: `SX-DEC-038 · SX-DEC-039`
- Evidence: `EV-USER-027`
- Automated state: `PASS`
- Manual state: `TITLE_EXIT_VISIBLE_PASS · MID_RUN_EXIT_RETEST_REQUIRED`

## User Evidence

```text
1) 역에는 노선이 한 쪽만 연결되도 연결된 노선으로 인식되게해.
2) 타이틀 종료는 잘 표시됨
```

## Adopted Station Contract

A station is structurally connected when all of the following are true:

1. The station cell contains a player rail piece.
2. The station cell is reachable from the start through reciprocal rail ports.
3. The station cell has at least one reciprocal neighboring rail connection.

The station does not need a second connection on the opposite side. It may be used as a terminal station.

Cargo-marker cells and ordinary rail cells keep their existing connectivity rules. This amendment does not hide general disconnections or mismatched ports.

## Runtime Contract

A final delivery at a one-sided terminal station is resolved in this order:

```text
train enters station
→ station unload is evaluated
→ remaining map cargo and stack are evaluated
→ final unload sequence completes
→ SUCCESS
```

The run must not fail merely because the terminal station has no outgoing neighbor after the required delivery has completed.

This audit does not approve automatic reversal at an intermediate terminal station. A one-sided station used before all required deliveries are complete still requires a separate route design or future turnaround rule.

## Automated Evidence

A dedicated integration test was added:

```text
res://tests/finite/integration/test_one_sided_station_terminal.gd
```

The test builds a minimal route with one cargo and one final station. The station has exactly one reciprocal neighbor. It verifies:

- definition validation PASS
- Preflight PASS
- no problem-cell highlight
- exactly one reciprocal station neighbor
- auto-load pickup
- station unload
- final `SUCCESS`

```yaml
verified_main: 1339a9467312d0ac680725894a9efb59746ec2cc
project_contract:
  workflow: 922
  result: PASS
godot_tests:
  workflow: 853
  run_id: 31097301981
  result: PASS
  cases: 92
  assertions: 11457
  failures: 0
one_sided_station_assertions: 20
live_editor_pilot: PASS
```

## Pilot Boundary Repair

The isolated editor Pilot previously left its two temporary editor plugins enabled before starting ordinary project regression. This could stall the second Godot process during plugin initialization.

The runner now restores the source `project.godot` bytes after editor-Pilot evidence is collected and before project regression begins. Existing user plugins such as Godot AI and GUT are preserved because the exact source configuration is restored. The temporary Pilot plugins remain isolated to the editor-Pilot phase.

## Manual Evidence Boundary

The user confirmed that the title-screen exit control is displayed correctly.

```yaml
title_exit_visible: PASS
mid_run_menu_visible: RETEST_REQUIRED
mid_run_cancel_state_preservation: RETEST_REQUIRED
mid_run_confirm_title_return: RETEST_REQUIRED
windows_artifact_runtime: NOT_RUN
android_device: NOT_RUN
human_comprehension: NOT_RUN
production_cutover: BLOCKED
```

A partial manual PASS must not be expanded to the untested mid-run exit flow.
