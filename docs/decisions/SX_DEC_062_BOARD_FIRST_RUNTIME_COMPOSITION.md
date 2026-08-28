# SX-DEC-062 · Board-first Runtime Composition

Status: `USER_APPROVED · 2026-08-28 KST · DESIGN_AND_IMPLEMENTATION_CONTRACT · RUNTIME_UNCHANGED`

Tracking: GitHub Issue #235

## Decision

Apply the approved **Board-first Cozy Neo-Arcade** direction to the existing Godot presentation by adjusting runtime composition and visual hierarchy—not by replacing the production art family.

```text
existing E+D Hybrid / Neo-Arcade consumers
→ board is the first readable surface during BUILD and RUN
→ compact dark control deck explains the current decision
→ bounded lesson framing explains one rule before play
→ causal result returns the player to Retry or Edit
```

The player promise, finite-map rules, station cardinal-service semantics, Manual/Auto pickup, unlimited LIFO/TOP, direct switch control, time/`ROUTE_END` outcomes, and T1→T6→VS_DEMO_01 sequence do not change.

## Adopted scope

1. **One runtime visual grammar**
   - Existing dark control-deck surfaces, warm miniature board terrain, brass/navy train, restrained gold trim, and live Godot text remain the shared language.
   - `DemoPalette` owns gameplay-state colors. `DemoThemeFactory` must consume compatible named roles rather than introduce competing state colors.
   - Valid/selected uses lime with direction, width, or outline; alternate route uses blue with lower emphasis; invalid/locked/`ROUTE_END` uses crimson with a prohibition/lock/reason cue; lesson focus uses bounded violet with live text. No decision depends on color alone.

2. **Board-first BUILD and RUN hierarchy**
   - `ProductBoardRenderer` and `RouteControlOverlay` remain above decorative terrain and below only necessary input/event feedback.
   - Existing rails, cargo, off-track stations, cardinal-service corner marks, route traces, selected/locked switch cues, and compact Stack HUD remain readable at the current supported viewport matrix.
   - Build/RUN toolbars, preflight explanation, stack, and pause remain contextual control surfaces. They must not introduce economy, score, save, ranking, or unimplemented states.

3. **Single-rule lesson and causal result framing**
   - `BriefingScreen` continues to reveal one current lesson at a time. T2 keeps its existing v02 cardinal-station-service HeroArt; exact cargo/station rules stay in Godot text and runtime feedback.
   - Title and result keep their current real asset consumers. Their crop, surrounding panel density, and CTA hierarchy may be aligned with the board-first grammar, but no bitmap is replaced or added.
   - Result retains only runtime truth and same-layout Retry / Edit / Title recovery. No fabricated analytics, scores, currencies, or trace.

4. **Evidence-safe validation transition**
   - `SX60-POC-ACCEPT-002` is immutable pre-SX-DEC-062 package evidence. Its physical/audio/human observations cannot transfer to the new bytes.
   - `SX60-POC-ACCEPT-003` is immutable prior-byte package evidence after SX-DEC-062. `SX60-POC-ACCEPT-004` is the current exact merged-main package candidate after SX-DEC-064; it verifies package/automation only, and Windows physical+audio → Android device → five-person → Player Experience gates remain open.

## Explicit exclusions

- No new raster asset, sprite sheet, title/lesson/result replacement, or promotion of generated exploration images.
- No change to `ProductShellArt` consumer paths, `runtime_visual_manifest.json`, existing asset hashes, or their conditional release-rights status.
- GitHub Issue #227 (procedural T2 image replacement) is not absorbed. The current T2 v02 image stays active; #227 remains a separate future decision.
- No station/service, map/schema, data, tutorial-count, LIFO, Manual/Auto, switch, score, progression, economy, solver, Base pin, or PR #174 change.

## Actual consumer contract

| Visual concern | Current implementation owner | Required preservation |
|---|---|---|
| Board hierarchy and semantic overlays | `game/demo/presentation/product_board_renderer.gd`, `route_control_overlay.gd`, `product_finite_slice.tscn` | Board geometry and existing selected/locked/service semantics remain gameplay projections, not rule owners. |
| HUD and tool-deck hierarchy | `game/demo/presentation/product_hud.tscn`, `product_hud.gd`, `demo_theme_factory.gd`, `demo_palette.gd` | Stage visibility, 48px targets, keyboard/touch routes, and live Korean/localized text remain intact. |
| Title, lesson, result shell | `game/demo/vertical_slice_demo.tscn`, `demo_flow_controller.gd`, `product_shell_art.gd` | Existing hero/result paths and T2-only v02 selection stay exact; copy remains live Godot text. |
| First-session meaning | `data/first_session/first_session_v1.json`, `game/first_session/**` | T1→T6/capstone sequence and progressive disclosure remain unchanged. |

## Acceptance criteria for the future implementation

- At 960×540, 1280×720, 1600×900, 1920×1080, and 2560×1080, visible controls remain inside the root and at least 48px in both dimensions.
- Selected route remains visually stronger than locked route, which remains stronger than alternate route; station cardinal service and preflight problem emphasis retain their existing non-colour meanings.
- T2 still selects exactly `shell_lesson_hero_v02.png`; T1 and T3–T6/capstone still select `shell_lesson_hero_v01.png`; title and result path selection remains exact.
- No changed runtime output claims physical, audio, Android, five-person, Player Experience, production-cutover, or release-rights PASS without new exact evidence.
- No new `art/product_assets/**` path, manifest entry, image provenance record, gameplay feature, or unapproved system appears.

## Canonical destinations

- GitHub decision and implementation contract: this file, the linked spec/plan/handoff, and the current project-hub/visual owners.
- Historical Notion destinations remain audit-only history after the 2026-08-28 GitHub-only workspace decision; GitHub decision, project-hub, design, and code/runtime owners are the current destinations.
- The foreign historical Notion page identified by Issue #230 remains untouched and is not a current destination or blocker.

## Provenance

- User approval: selected the recommended A scope in this task on `2026-08-28 KST`.
- Direction predecessor: `SX-DEC-061`.
- User-provided collage: visual reference only. Its embedded text, labels, controls, and claimed status are not project requirements or runtime proof.
