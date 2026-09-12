# SX-DEC-065 · Windows ANGLE renderer compatibility

**Status:** `APPROVED_IMPLEMENTATION_CONTRACT · PRE_MERGE_LOCAL_VALIDATION_PASS`
**Date:** 2026-08-29 KST
**Tracking:** GitHub Issue #253
**Predecessor:** `SX60-POC-ACCEPT-004` / SX-DEC-064 package baseline

## Decision

For the Windows Compatibility renderer only, prefer Godot's `opengl3_angle` driver, retain `fallback_to_native=true`, and export ANGLE dynamic libraries with the Windows Demo preset (`application/export_angle=1`). This is a **technical compatibility correction**, not a gameplay, content, UI, asset, audio, or visual-direction decision.

```text
Windows default launch
→ Compatibility driver: ANGLE over Direct3D 11
→ if ANGLE or its DLLs cannot initialize: native OpenGL fallback
→ all finite-puzzle and presentation semantics unchanged
```

## Confirmed reproduction and decision basis

| Item | Confirmed observation |
| --- | --- |
| Exact artifact | `SX60-POC-ACCEPT-004`, source `main@58b99f261c3576150ab275bb041d744c69b83538` |
| Package identity | EXE SHA-256 `1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244`; PCK SHA-256 `3325f11115fdf3fc57e39bb35c545d115217614eb1e58607934edacf0c6b0839` |
| Native control | The default native `opengl3` launch initialized resources and reported OpenGL 3.3 on NVIDIA GeForce RTX 3050 / driver `572.16`, but showed a black game frame. |
| ANGLE comparison | The exact same EXE, PCK, display, and process, launched only with `--rendering-driver opengl3_angle`, visibly reached `Title → Briefing → BUILD`. |
| Prior configuration | `project.godot` selected `gl_compatibility` with no Windows-specific driver, and Windows Demo had `application/export_angle=0`. |

The byte-identical diagnostic comparison isolates the renderer choice as the supported correction hypothesis. It does **not** prove every Windows device, audio perception, or player experience result.

## Godot-supported setting contract

Godot 4.7 documents `rendering/gl_compatibility/driver.windows` as a Windows-specific Compatibility override. Its supported `opengl3_angle` value uses OpenGL ES 3.0 through ANGLE over native Direct3D 11. `fallback_to_native` returns to native OpenGL when ANGLE is unsupported or its dynamic libraries are absent. The Windows exporter documents `application/export_angle=1` as exporting the ANGLE libraries with the application. [ProjectSettings — Compatibility renderer](https://docs.godotengine.org/en/4.7/classes/class_projectsettings.html#class-projectsettings-property-rendering-gl-compatibility-driver-windows) · [Windows exporter](https://docs.godotengine.org/en/4.7/classes/class_editorexportplatformwindows.html#class-editorexportplatformwindows-property-application-export-angle)

The implementation is exactly:

```ini
# project.godot [rendering]
gl_compatibility/driver.windows="opengl3_angle"
gl_compatibility/fallback_to_native=true

# Windows Demo preset only
application/export_angle=1
```

Android retains its existing native Compatibility driver. No unscoped global driver replacement is approved.

## Scope and exclusions

**In scope:** the two Windows rendering/export settings, their focused Python contract, this decision, and the linked design/plan boundary.

**Out of scope:** all finite rules, maps/schema, stations, cargo/LIFO, first-session content, Scenes, UI composition, assets, audio, Android behavior, Base pin, PR #174, Candidate 005, candidate-pointer/package evidence, and project-hub current-state changes.

## Pre-merge acceptance contract

1. The focused Python contract locks the Windows-only driver, native fallback, and ANGLE export setting.
2. The current project contract, full Python suite, and local Godot regression pass on the implementation head.
3. A PR must still obtain its exact-head CI results before merge; those CI results do not mint a candidate.
4. Candidate 005 and all package-pointer/current-hub changes may occur only in a separately authorized **post-merge** task using a merged-main artifact and its independent hashes/audit.

## Evidence ceiling

| Evidence field | Status |
| --- | --- |
| Candidate 004 native black-frame reproduction | `CONFIRMED` |
| Candidate 004 forced-ANGLE `Title → Briefing → BUILD` diagnostic | `CONFIRMED` |
| Current-branch configuration contract / local automated regression | `PASS · Project Contract; Python 224 passed, 1 skipped; Godot 112 cases / 13,513 assertions` |
| Exact-head PR CI | `NOT_RUN` |
| Candidate 005 / package pointer / merged-main artifact | `NOT_CREATED` |
| Default-launch physical Windows verification of a replacement candidate | `NOT_RUN` |
| Audio perceptual, Android device, five-person, Player Experience, production cutover | `NOT_RUN` / `BLOCKED_DEFERRED` |

No automated, export, package, or diagnostic command in this decision is a Windows physical, audio, device, or human-validation PASS.
