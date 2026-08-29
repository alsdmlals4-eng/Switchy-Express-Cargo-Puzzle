# Windows ANGLE Renderer Compatibility Design

**Decision:** `SX-DEC-065` (approved technical compatibility correction)
**Tracking Issue:** #253
**Status:** `APPROVED_IMPLEMENTATION_CONTRACT · PRE_MERGE_LOCAL_VALIDATION_PASS`

## Goal

Make the Windows build select the rendering path that visibly draws the approved game on the observed Windows host, without changing any game rule, content, layout, asset, or non-Windows setting.

## Confirmed preflight

- Exact artifact: `SX60-POC-ACCEPT-004`, source `58b99f261c3576150ab275bb041d744c69b83538`.
- Independently verified package hashes: EXE `1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244`; PCK `3325f11115fdf3fc57e39bb35c545d115217614eb1e58607934edacf0c6b0839`.
- Default launch initializes project resources and reports native OpenGL 3.3 on NVIDIA GeForce RTX 3050 / driver `572.16`, but the visible game window is black.
- The same EXE, PCK, display, and process launched with only `--rendering-driver opengl3_angle` visibly reaches Title → Briefing → BUILD.
- `project.godot` selects `gl_compatibility` but has no Windows-specific compatibility-driver setting. The `Windows Demo` export preset has `application/export_angle=0`.

## Implementation hypothesis

The reported native OpenGL capability prevents Godot's unsupported-driver fallback from selecting ANGLE, even though native rendering produces no usable frame on this host. Prefer ANGLE only for Windows, include its export libraries explicitly, and retain native fallback if ANGLE cannot initialize.

```ini
# project.godot, [rendering]
gl_compatibility/driver.windows="opengl3_angle"
gl_compatibility/fallback_to_native=true

# export_presets.cfg, Windows Demo preset
application/export_angle=1
```

Godot 4.7 documents `opengl3_angle` as the Windows Compatibility renderer through Direct3D 11, with `fallback_to_native` returning to native OpenGL if ANGLE is unavailable. Its Windows exporter documents `application/export_angle=1` as exporting the required ANGLE libraries. These are platform-scoped settings; Android keeps its existing native Compatibility driver.

## Adversarial review

| Risk / competing explanation | Evidence and control |
| --- | --- |
| A scene, shader, or asset load failure causes the black screen | Headless and verbose runs load the scene/resources without runtime errors; the byte-identical ANGLE launch draws title, briefing, and board. Keep existing full regression. |
| The existing fallback would handle this automatically | It only activates when native OpenGL is unsupported; this host reports OpenGL 3.3, so preference must be explicit. |
| An ANGLE preference ships without its runtime libraries | Require `application/export_angle=1` and assert it in a Python contract test. |
| ANGLE fails on a different Windows machine | Set `fallback_to_native=true`; physical testing beyond this host remains required. |
| Android is changed accidentally | Contract test asserts only the Windows override and existing Android renderer remains untouched. |
| A visible diagnostic run is mistaken for Windows/audio acceptance | The replacement candidate needs a default-launch physical recheck. Audio, Android, five-person, and player-experience gates remain open. |

## Scope

- `project.godot` Windows Compatibility preference and fallback only.
- `export_presets.cfg` Windows Demo ANGLE runtime inclusion only.
- One focused Python configuration contract test.
- Technical decision/spec/plan and current-context documentation that preserve evidence boundaries.

## Exclusions

- Finite map/gameplay rules, station service, cargo/LIFO, first-session data, scenes, UI composition, assets, audio content, Android behavior, Base pin, and PR #174.
- Any PASS claim for audio perception, Android device, five-person comprehension, player experience, or production cutover.

## Acceptance criteria

1. A new focused test fails before the settings change and passes afterward.
2. Windows default Compatibility driver is `opengl3_angle`, native fallback is explicitly enabled, and the Windows export includes ANGLE libraries.
3. Existing project contract, Python contracts, Godot tests, and Windows export workflow pass on the implementation head.
4. A new exact post-change candidate supersedes Candidate 004 only after its artifact identity and package checks are recorded.
5. On this host, the new candidate reaches Title → Briefing → BUILD with no `--rendering-driver` override.
6. All remaining human/device/audio evidence is reported only as observed, not inferred.

## Merge-boundary split

This design deliberately ends at the merge boundary. The branch task may record SX-DEC-065 and run only source-independent local regression: project contract, full Python suite, and the local Godot runner. It must not create Candidate 005, update a candidate pointer/current hub, or imply a physical Windows/audio/device/player result.

After an exact implementation head has passed PR CI and is merged to `main`, a separate post-merge task may obtain the replacement artifact, independently record its EXE/PCK hashes and audit, mint Candidate 005, then perform a default-launch Windows observation. Candidate 004 remains immutable historical prior-byte evidence until then.
