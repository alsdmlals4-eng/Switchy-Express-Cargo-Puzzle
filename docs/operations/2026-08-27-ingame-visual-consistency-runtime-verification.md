# 2026-08-27 · In-game visual consistency runtime verification

## Scope

- GitHub Issue: #219
- Branch baseline: `5873c7ce5cf6e8f5f32f93fa981edbf2b9579dfa`
- Runtime asset set: `SX-INGAME-VISUAL-001`
- Protected scope: SX-DEC-060 rules unchanged; PR #174 remains read-only.

## Verified runtime consumers

| Surface | Runtime consumer | Evidence |
| --- | --- | --- |
| BUILD board | `ProductBoardRenderer::PRODUCT_VISUAL_ASSET_PATHS[board_terrain]` | Terrain backdrop renders under the live grid, rails, cargo, station, and semantic overlays. |
| Lesson | `BriefingScreen/.../LessonArt → ProductShellArt::LESSON_HERO_PATH` | First-session lesson renders its scene-scale hero inside the panel without covering title, objective, or action. |
| Success result | `ResultOverlay/.../ResultArt → ProductShellArt::RESULT_SUCCESS_PATH` | Live success result renders the scene-scale success image with separate Godot copy/actions. |
| Failure result | `ResultOverlay/.../ResultArt → ProductShellArt::RESULT_FAILURE_PATH` | Live failure result renders the scene-scale failure image with separate Godot reason/copy/actions. |

## Runtime checks

- Godot 4.7.1 live flow: title → T1 lesson → BUILD board; direct result-state checks covered success and failure art consumers.
- The first Lesson render exposed cover drawing outside its target rect. `ProductShellArt` was corrected to crop the source region before drawing, then Lesson was rechecked.
- Hera diagnostics after the correction: 0 errors, 0 warnings.
- Deterministic GUT regression: 21 passing tests, 152 assertions (the visible GUT suite run); project-wide CI remains required before merge.

## Non-claims

- This is machine runtime/visual evidence, not Windows human physical, Android device, player comprehension, audio perceptual, store, or release-rights approval.
- The generated assets are runtime-integrated but their release rights remain conditional pending the existing release/rights gate.
