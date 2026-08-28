# PROJECT_CORE_SCENE_VISUAL_BOARD

Status: `CURRENT_PLANNING_OWNER · SX-DEC-061/063 · GENERATED_EXPLORATION · NOT_RUNTIME_PROOF · SX-DEC-063_TERRAIN_V02_GITHUB_PRESERVED_RUNTIME_NOT_CONNECTED`

This document owns the exact meaning of the planning board. The board image is only an AI-understanding and visual-direction review aid: no panel is a finished runtime asset, Godot screen, Scene, UI implementation, or Human/Player Experience PASS.

## Artifact boundary

```yaml
artifact_id: SX-VIS-061-CORE-SCENE-BOARD-EXPLORATION-001
visual_direction: BOARD_FIRST_COZY_NEO_ARCADE
generated_image_sha256: 6aabad5e9834e777cae9124b4279fef0a1bca48ab6b056b3aebd48f901d7fafc
artifact_status: GENERATED_EXPLORATION
runtime_consumer: NOT_APPLICABLE
tracked_project_copy: NOT_CREATED
external_binary_attachment: NOT_APPLICABLE · GITHUB_ONLY_WORKSPACE
why: user approved the direction, not the generated board binary as a durable project reference
exact_semantic_owner: this Markdown document and SX-DEC-061
```

Generated panel numbers and pictograms are non-canonical. Exact UI wording, statistics, and controls remain owned by the current first-session screen/content and runtime owners; no generated pseudo-text is a requirement.

## Screen and scene contract

| Board panel / scene_or_screen_id | Actual consumer | Player goal and primary action | Meaningful choice / required information | Expected feedback and next connection | Current evidence / unresolved detail |
|---|---|---|---|---|---|
| 1 · `SX-SCR-001_TITLE` | `vertical_slice_demo.tscn` Title screen / `ProductShellArt::TITLE_HERO_PATH` | Start the finite delivery slice. | A compact locomotive, route junction, cargo silhouettes, and start action establish “route plans stack order.” | Enters the current briefing/first session; title art is atmosphere, not an explanation sheet. | Runtime consumer verified; exact title layout stays current implementation. |
| 2 · `T1_TRACK_CONNECTION_BUILD` | Existing ProductFiniteSlice BUILD board / ProductBoardRenderer | Connect the first run route by placing a rail piece. | Grid, connected rail endpoints, valid placement, forbidden station footprint, and start-reachable intent. | Lime valid placement; crimson forbidden placement; then RUN becomes understandable. | SX-DEC-060 requires off-track station and no rail on its cell. Exact tooltip layout is not yet approved. |
| 3 · `T2_CARGO_AND_CARDINAL_SERVICE_RUN` | Existing T2 stage, lesson art v02 and finite delivery loop | Pick up cargo by exact-cell contact and deliver while passing an adjacent cardinal service cell. | Cargo exact cell versus station UP/RIGHT/DOWN/LEFT one-tile service; diagonal and station footprint excluded. | Pickup/anticipated unload state and delivery feedback clarify the different contacts; continues to LIFO planning. | Runtime semantics merged; this board is not proof of physical comprehension. |
| 4 · `T3_LIFO_TOP_REVERSE_PLAN` | Existing T3 stage / Stack HUD / semantic cargo assets | Plan load order backward from the station’s needed TOP group. | Compact stack, TOP, next group, cargo color + shape; no long train representation. | TOP is visible before arrival; correct contiguous matching group unload rewards the plan. | LIFO is implemented; final compact-token/HUD geometry is a Phase 2 UI task. |
| 5 · `T4_SELECTIVE_NONLOAD_REVISIT` | Existing T4 stage / finite delivery loop | Leave a tempting cargo unloaded and revisit it later. | Current stack order, later cargo value, route revisit possibility. | Untouched cargo remains visible; route and stack make the later correction leg readable. | No new route-visual system is authorized by this board. |
| 6 · `T5_AUTO_SAFE_OFF_DECISION` | Existing T5 stage / manual load + auto-load toggle | Use Auto only on the safe segment and turn it off when auto-loading would damage the plan. | Exact cargo contact, current auto state, next TOP consequence. | Persistent non-colour mode state plus normal cargo feedback; moves to live switch execution. | Existing manual/auto system only; no new controls or automated policies implied. |
| 7 · `T6_DIRECT_SWITCH_EXECUTION` | Existing T6 stage / RouteControlOverlay | Directly choose a junction route while the train moves. | Active direction, alternate branch, route preview, occupied lock. | Bright selected route; occupied branch lock; state persists after pass. | Existing direct switch control with occupied lock remains authoritative. |
| 8 · `VS_DEMO_01_CAPSTONE_RESULT` | Existing capstone and ResultOverlay / result art | Execute the whole plan, then learn from success or `ROUTE_END`/time failure. | Delivered/remaining map cargo, stack size, one factual failure cause, Retry same layout versus Edit. | Concise causal debrief drives a retrial or redesign. | Runtime result truth only; no fake score, economy, progress, or hidden trace. |

## Visual grammar across the board

- **World:** cozy miniature rail diorama, warm world lights, and elevated 3/4 depth cues inside the actual rectangular gameplay grid; this is not an isometric input-map promise.
- **Control deck:** dark navy/charcoal frames with limited gold trim; panels support the board rather than replace it.
- **State redundancy:** lime/crimson/violet never stand alone; shape, outline, icon, direction, brightness, or current Godot text carries the same meaning.
- **LIFO:** world token is compact; Stack HUD owns the exact sequence and count. `TOP` is semantic text, not “front/back.”
- **Variation:** failure may use more crimson and a tutorial may use more violet, but material language, cargo silhouettes, camera, and UI framing stay shared.

## SX-DEC-062/063 runtime-composition and production mapping

SX-DEC-062 maps to a merged existing-asset presentation contract. SX-DEC-063 maps only proven consumers to a candidate-production sequence; neither Decision promotes this planning board binary into a runtime asset:

### SX-DEC-063 actual-consumer refinement

| Consumer family | Requirement | Current production state |
| --- | --- | --- |
| BUILD/RUN board terrain, train, rail, markers, stations, cargo | SX-VIS-063-RQ-001 | Terrain v02 is user-approved/GitHub-preserved but not runtime connected; the remaining 13 proposed slots have no generated or approved asset. |
| Title, shared non-T2 lesson, success/failure result | SX-VIS-063-RQ-002 | 4 proposed versioned slots; deferred until their own candidate generation and final promotion disposition. |
| Control deck density | SX-VIS-063-RQ-003 | Later code-only implementation review; no new control or system. |

T2 Hero v02 remains protected and Issue #227 remains outside this mapping.

| Runtime concern | Existing consumer | SX-DEC-062 change boundary |
|---|---|---|
| Board-first action hierarchy | `ProductBoardRenderer`, `RouteControlOverlay`, `ProductFiniteSlice` | Keep route feedback above subtle cardinal service orientation; no gameplay/render snapshot schema change. |
| Control deck | `DemoPalette`, `DemoThemeFactory`, `ProductHUD` | Use shared named state roles and panel variants; retain stage visibility and 48px controls. |
| Lesson focus | `BriefingScreen/.../LessonProgress`, current live text | Violet bounded orientation only; T2 v02 asset and exact T2 copy remain. |
| Result recovery | `ResultOverlay`, `ProductShellArt`, flow controller | Keep runtime-truth Retry/Edit/Title; no score/economy/trace invention. |

`PROJECT_CORE_SCENE_VISUAL_BOARD` remains `GENERATED_EXPLORATION · NOT_RUNTIME_PROOF`. The implementation contract is `docs/decisions/SX_DEC_062_BOARD_FIRST_RUNTIME_COMPOSITION.md`; it cannot promote the board binary, asset rights, or human-usability evidence.

## Adversarial review of the generated board

| Check | Result | Correction in this owner |
|---|---|---|
| Does one still replace the full core loop? | PASS | Eight panels cover Title, T1–T6, and capstone/result; Phase 5 validates the whole chain. |
| Did generated imagery invent text, score, currency, saving, or progression? | PASS | No such semantics are adopted; non-canonical pictograms are explicitly excluded. |
| Did it imply diagonal or station-footprint delivery? | PARTIAL | Generated imagery cannot prove grid coordinates; T2 is bound to SX-DEC-060 cardinal service text here. |
| Did it turn a long train into the LIFO representation? | PASS | The approved rule is compact token + Stack HUD; no horizontal capacity signal is adopted. |
| Is it runtime or usability evidence? | FAIL if claimed | Explicitly `NOT_RUNTIME_PROOF`; Godot and human evidence remain NOT_RUN. |
| Is it a project asset or production image? | FAIL if claimed | It remains a generated exploration without consumer-bound tracked copy or user-approved promotion. |
