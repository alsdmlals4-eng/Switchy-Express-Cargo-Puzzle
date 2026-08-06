# PC Vertical Slice One-Click Entrypoint Amendment

Status: `USER_APPROVED_CANONICAL_AMENDMENT · IMPLEMENTED · LOCAL_RETEST_REQUIRED`

## Approval evidence

The user clarified and approved the following requirement after reviewing the first local Godot execution:

- opening the Godot project and pressing the normal Project Play button must be sufficient
- no separate Scene selection
- no Run Current Scene requirement
- no Project Settings, input mode, plugin or feature-flag setup
- the full playable demo must be available, not only a title or static board
- the same reusable rule must be promoted to Base for other projects

This amendment supersedes only the original specification clauses that required F6 execution and protected the empty legacy default entrypoint. All finite-domain, Android-validation, asset-rights and product-scope boundaries remain in force.

## Revised default execution contract

```text
project.godot
→ application/run/main_scene = res://game/main/main.tscn
→ Main/VerticalSliceDemo
→ Project Play(F5 / ▶)
→ Title → Briefing → BUILD → RUN → Result
→ Retry same layout · Edit layout · Title
```

The user must not need to select `res://game/demo/vertical_slice_demo.tscn`. That Scene remains available for development and isolated tests only.

## Product bootstrap architecture

```text
Main : Control
└─ VerticalSliceDemo : Control
   ├─ TitleScreen
   ├─ BriefingScreen
   ├─ GameplayContainer
   │  └─ ProductFiniteSlice
   │     ├─ FiniteSliceSessionController
   │     ├─ ProductBoardRenderer
   │     ├─ ProductHUD
   │     ├─ DesktopInputAdapter
   │     ├─ DemoEffects
   │     └─ DemoAudioDirector
   ├─ PauseOverlay
   └─ ResultOverlay
```

`game/main/main.tscn` owns only product bootstrap composition. It does not own finite rules or duplicate gameplay state.

## Runtime surface contract

After entering BUILD, the runtime must visibly expose:

- top phase, time and cost status
- central board
- bottom build or run toolbar
- right-side cargo TOP panel when applicable
- problem banner when preflight is incomplete
- mouse and keyboard input surface

The HUD must fill the product viewport and render explicitly above the board.

## Regression requirements

Automated tests must prove:

1. `project.godot` still points to `res://game/main/main.tscn`.
2. default `Main` creates `VerticalSliceDemo`.
3. default Project Play begins in `TITLE`.
4. the same default root reaches `BRIEFING` and `GAMEPLAY`.
5. `ProductFiniteSlice`, `HUD` and `BuildToolbar` exist and are visible.
6. HUD fills the product root and has a higher z-index than the board.
7. existing success, failure, retry, edit and title flows remain green.
8. Android validation feature override, package ID and proof map remain protected.

## Manual finding and fail-closed status

The user observed an earlier local build where the title rendered but the BUILD screen showed only the board grid. HUD and interaction controls were missing.

```yaml
finding: HUD_AND_INTERACTION_SURFACE_MISSING_AFTER_BUILD_ENTRY
manual_status: FAIL · RETEST_REQUIRED
```

Implemented corrections:

- full HUD anchors
- explicit HUD `z_index=10`
- default `Main` product bootstrap
- default-entry gameplay/HUD/toolbar regression
- complete suite timeout increased from 30 to 60 seconds after all 85 tests passed but the external process timed out

Automated PASS does not close the manual finding. The user must Fetch origin, Pull origin, reopen Godot and retest Project Play.

## Protected boundaries

The amendment does not:

- change finite product rules
- change `fp_core_proof_01.json`
- remove the Android validation launcher
- change the Android validation feature override
- change the Android validation package ID or canonical APK evidence
- claim Windows artifact runtime, Android device, human comprehension or production cutover PASS
- add additional stages, campaign, gamepad, online systems, monetization or ranking

## Completion status

```text
DEFAULT PROJECT PLAY BOOT: PASS · AUTOMATED
FULL PC DEMO FLOW: PASS · AUTOMATED
WINDOWS EXPORT·INTEGRITY: PASS
PC LOCAL PROJECT PLAY: FAIL · RETEST_REQUIRED
WINDOWS ARTIFACT RUNTIME: NOT_RUN
ANDROID DEVICE SMOKE: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
PRODUCTION CUTOVER: BLOCKED
PR #83: DRAFT
```
