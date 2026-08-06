# SX-AUD-023 — Curve Render Port Parity Audit

- Date: `2026-08-06`
- Parent decision: `SX-DEC-038`
- Evidence: `EV-USER-026`
- User finding: visually connected rails were reported as disconnected
- Automated state: `PASS`
- Manual local state: `RETEST_REQUIRED`

## User Evidence

The owner supplied a live BUILD screenshot where curve pieces appeared connected to adjacent rails while preflight returned `DISCONNECTED_REQUIRED_POINT`.

```text
1) 메인에 병합해야 내가 Fetch/Pull 해서 확인이 가능하지
2) 연결이 되어도 연결안된 판정이 뜬다
```

## Root Cause

The domain and renderer interpreted the same curve rotation differently.

```text
TrackPiece CURVE rotation 0: UP + RIGHT
ProductBoardRenderer CURVE rotation 0: RIGHT + DOWN
```

The renderer was one quarter-turn clockwise from the authoritative domain geometry. A player could therefore make a visually continuous route whose graph ports did not connect.

## Fix

- Added one renderer port projection used by both drawing and tests.
- Curve base ports now match `TrackPiece.ports()` exactly.
- Added parity assertions for rotations `0, 1, 2, 3`.
- Straight, switch, and crossing semantics were not changed.
- Preflight rules were not relaxed; the visual representation was corrected to match them.

## TDD Evidence

### RED

```yaml
workflow: Godot Tests #836
run_id: 31092338394
head: 8dc7c26ef455c1a9df92a7e084c093b71b60e480
result: EXPECTED_FAILURE
failure: ProductBoardRenderer.track_ports_for_test missing
```

### GREEN

```yaml
verified_head: eca9864aeca3711bbcdbdc7b8cb63ec47ac8989a
project_contract: PASS · #908 · run 31093048943
godot_tests: PASS · #839 · run 31093048854
godot_cases: 91
godot_failures: 0
godot_assertions: 11437
live_editor_pilot: PASS
thin_adapter: PASS · #105 · run 31093048867
windows_export: PASS · #63 · run 31093049036
windows_exe_pck_hash_upload: PASS
```

## Concurrent Main Baseline Repair

Current `main` added the GUT editor plugin to `project.godot`, but `tools/godot-live-editor-pilot/SOURCE_BASELINE.json` still expected the previous project hash. The PR merge result therefore failed before the editor pilot ran.

The source baseline was refreshed to current main commit `9e8f87b96d2cd1113e2e99bdda5809998780ee6a` and its exact `project.godot` blob/SHA-256. The target scene baseline remained unchanged.

## Preserved Boundaries

- finite connectivity and preflight rules: unchanged
- recommended layout domain data: unchanged
- Android validation entrypoint and package identity: unchanged
- default Project Play entrypoint: unchanged
- production cutover: `BLOCKED`

## Manual Retest Gate

After merge:

```text
GitHub Desktop → main → Fetch origin → Pull origin
→ Godot reopen → F5
→ place/rotate curves using their visible shape
→ verify connected pieces are not marked disconnected
→ verify genuinely mismatched ports remain highlighted
→ verify BUILD and RUN menu exit flow
```

Automated parity PASS does not replace the owner's local visual/input confirmation.
