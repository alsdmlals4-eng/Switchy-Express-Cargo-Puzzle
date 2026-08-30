# PROJECT_CORE_SCENE_VISUAL_BOARD

Status: `CURRENT_PLANNING_OWNER · SX-DEC-061/063/064/065 · SYSTEM_EXPLANATION_CORRECTED · USER_APPROVED_GITHUB_PRESERVED_PLANNING_REFERENCE · NOT_RUNTIME_PROOF · SX-DEC-063_CORE_BOARD_V02_V04_MERGED_MAIN_VERIFIED_RUNTIME_CONSUMERS_CONNECTED`

This document owns the exact meaning of the planning board. The board image is only an AI-understanding and visual-direction review aid: no panel is a finished runtime asset, Godot screen, Scene, UI implementation, or Human/Player Experience PASS.

## Artifact boundary

```yaml
artifact_id: SX-VIS-061-CORE-SYSTEMS-BOARD-EXPLORATION-002
artifact_revision: B
visual_direction: BOARD_FIRST_COZY_NEO_ARCADE
generated_image_sha256: 6577d7ac5e490b1303af0105ef0573cf5b4be10a52cbdd4ccecb24ec116993bc
generated_image_dimensions: 1672x941 PNG
artifact_status: USER_APPROVED_GITHUB_PRESERVED_PLANNING_REFERENCE · NOT_RUNTIME_PROOF
runtime_consumer: NOT_APPLICABLE
tracked_project_copy: docs/visual-references/sx-vis-061-core-systems-board-exploration-002b.png
external_binary_attachment: SOURCE_READBACK_2026-08-29 · SHA256_AND_DIMENSIONS_MATCH
previous_explorations:
  - SX-VIS-061-CORE-SCENE-BOARD-EXPLORATION-001 · historical first-flow board
  - SX-VIS-061-CORE-SYSTEMS-BOARD-EXPLORATION-002A · rejected after visual review because its switch picture exposed three exits
why: the user approved the reviewed board as a durable GitHub planning reference; it remains neither a runtime asset nor runtime input
exact_semantic_owner: this Markdown document and SX-DEC-061
```

Generated panel numbers and pictograms are non-canonical. Exact UI wording, statistics, and controls remain owned by the current first-session screen/content and runtime owners; no generated pseudo-text is a requirement.

## 2026-08-28 correction · core systems must be legible as decisions

`SX-VIS-061-CORE-SCENE-BOARD-EXPLORATION-001` covered the first-session order but did not make the decisive systems readable as a connected player model. That is a planning-document defect, not evidence that the Godot systems are missing or a reason to invent new rules.

The replacement exploration must therefore let a viewer answer the following without relying on a long caption:

```text
Where can I install a rail, and what must preflight prove before RUN?
Why is an off-track station reached from an adjacent cardinal cell rather than by rail on its footprint?
Why can one cargo be loaded now, skipped, or auto-loaded later, and how does that change TOP?
Which branch will the moving train take, when may I change it, and when is it locked?
What causal result will tell me whether to retry the same layout or return to edit it?
```

The structured rules remain owned by `FINITE_DELIVERY_PUZZLE_BASELINE.md`, `CORE_GAMEPLAY.md`, `CORE_SYSTEMS.md`, and SX-DEC-060. This board owns only their human-readable scene projection.

## Core-system player contract · required board coverage

| Core system | Player action and what they judge | Meaningful choice / trade-off | Immediate feedback / observable result | Failure learning and next action | Exact authority and actual consumer |
|---|---|---|---|---|---|
| `BUILD + PREFLIGHT` | In BUILD, choose a straight, curve, switch, or crossing; place, rotate, replace, or remove it on a buildable cell. Read connected ports, current final cost, the off-track station footprint, and preflight problem cells. | A short route can produce the wrong cargo encounter order or miss a required station service cell. More rail is not automatically better; only the start-reachable RUN component must cover required cargo and at least one cardinal service cell per station. | Placement returns a concrete valid/invalid result; removal refunds the replaced piece's cost. `begin_run` seals only a passed layout and rejects an empty, disconnected-required, malformed, or trapped reachable route. | A preflight reason identifies a repair target, but never supplies the LIFO, manual/Auto, switch, time, or cheapest solution. Repair the relevant route and recheck. | `FiniteBuildSession`, `TrackLayoutEditor`, `PreflightValidator`, `ProductFiniteSlice`, `ProductBoardRenderer`. |
| `CARGO CONTACT + LIFO` | Drive automatically through a cargo's exact cell while holding Manual Load or with Auto enabled; read the compact world token plus the Stack HUD's ordered `TOP`. | Load now, leave the cargo on the map for a revisit, or use Auto only through a safe sequence. Every pickup changes the future unload order; cargo has no capacity limit and does not slow or stop the train. | A picked cargo leaves the fixed map field and is pushed onto `TOP`; an intentionally skipped cargo stays at its authored cell. The HUD—not a long train—shows the order and next relevant group. | If the wrong kind is on TOP, the player has learned an encounter/load-order error, not failed a reflex check. Revisit a skipped cargo, change Auto state before contact, or edit the route. | `FiniteGameplayInputState`, `FixedCargoField`, `UnlimitedCargoStack`, `FiniteDeliveryLoop`, `StackPanel`. |
| `OFF-TRACK STATION SERVICE` | Route the train through one of the four cells exactly adjacent to the station; compare station cargo identity with the stack `TOP`. | The station footprint is non-buildable and does not deliver. Diagonal, footprint, and distance-two passages may look nearby but give no service; the route must reserve a true cardinal pass at the right stack moment. | A matching station pops only the contiguous matching `TOP` group and briefly enters unload feedback. A mismatched TOP or invalid proximity passes without unloading. | “Nothing unloaded” points to one of two inspectable causes: wrong cell geometry or wrong TOP. Make the cardinal service route or stack order visible before retrying. | `FiniteMapDefinition` schema v3, `Station`, `FiniteDeliveryLoop`, procedural service indicator in `ProductBoardRenderer`. |
| `DIRECT SWITCH EXECUTION` | While the train is approaching, tap/select the desired reachable switch exit and read selected direction, alternate branch, and occupied lock. | Commit the branch before the train occupies that control. A late input is rejected; a choice remains until changed rather than auto-resetting after passage. The branch can send the train to a needed cargo, service cell, or a `ROUTE_END`. | Selected route and alternate route remain visually distinct; the occupied control is visibly locked. The graph's selected exit determines the next cell at the junction. | A locked or wrong branch is an execution/timing cause, not hidden randomness. Retry the sealed layout to rehearse the plan, or Edit if the network itself cannot support it. | `FiniteTrackGraph`, `FiniteTrackSwitch`, `RouteControlOverlay`, route descriptors in `ProductBoardRenderer`. |
| `FINITE OUTCOME + RECOVERY` | Execute the whole route under the running clock; inspect remaining map cargo, stack size, and the factual terminal reason. | Spend remaining time on a correct route rather than chase irrelevant rail. Decide whether the layout is sound enough to retry unchanged or needs a redesign. | All required cargo delivered with an empty stack produces success. `TIME_EXPIRED` or `ROUTE_END` produces failure and freezes domain mutation. | Retry creates a fresh mutable attempt from the same sealed layout; Edit returns to BUILD. No score, economy, progress, solver, or secret trace is implied. | `FiniteRunController`, `FiniteRunSessionFactory`, `ResultOverlay`, result flow controller. |

### Invariants the visual board must make harder to misread

- Cargo load is **exact-cell contact**; station delivery is **cardinal-adjacent service**. They must never share the same visual language.
- The station is **off track**. Rail through its footprint, diagonal service, arbitrary radius, and a station-centered stop are all non-canonical.
- `TOP` is an order label. It must not be represented by horizontal train length, capacity bars, or a full-wagon warning.
- A switch's active-route rail glow, dim alternate **control target**, and occupied lock are three different states. Only the rail the train will traverse under current selections glows; it has no auto-reset after passage.
- Preflight proves only structural start-reachable coverage/safety. It must not visually claim an optimal route, correct load timing, or a solved puzzle.
- The planning image may show labelled numeric callouts only. Exact text and state names stay in the structured GitHub owners above.

## Regenerated system-first board brief

`SX-VIS-061-CORE-SYSTEMS-BOARD-EXPLORATION-002B` is the user-approved GitHub-preserved **six-panel explanatory storyboard**, not six runtime assets. All panels retain the same rectangular board camera, toy-scale warm miniature materials, navy/charcoal control deck, and colour + shape redundancy. The first generated pass (`002A`) was rejected before this record because a switch appeared to expose three exits; the current candidate shows one incoming rail and exactly two selectable exits, with occupied lock as an overlay rather than a third route. Its planning meaning is approved; its image still is not runtime, UI, Scene, or Human/Player Experience proof.

| Panel / scene_or_screen_id | Required picture | System connection it must reveal | Must not imply |
|---|---|---|---|
| A · `BUILD_PREFLIGHT_ROUTE` | A buildable rectangular grid with a straight/curve/switch/crossing tool strip, one lime placement ghost, one crimson forbidden station footprint, and a compact preflight problem marker. | Rail geometry creates cargo encounter and station-service reachability before RUN. | A solved route, global-all-rail requirement, rail on a station, score/currency. |
| B · `CARGO_EXACT_CELL_STATION_CARDINAL` | One cargo on its own rail cell, one off-track station, four subtle cardinal service-cell cues, and a diagonal crossed out by shape/outline rather than text alone. | Exact pickup and adjacent delivery are deliberately different contacts. | Diagonal/footprint delivery or station-centred rail. |
| C · `LOAD_ORDER_LIFO_MANUAL_AUTO` | A short locomotive with compact cargo token, a vertical Stack HUD marked `TOP`, a deliberately skipped cargo still on the map, and a bounded Auto state cue. | Encounter order plus Manual/Auto choice produces the future top group. | Long cargo train, capacity limit, automatic best choice, reflex-only loading. |
| D · `LIVE_SWITCH_COMMITMENT` | The same board scale with a train approaching a switch with exactly one incoming approach and two exits: only the current deterministic path is bright, the alternate is a dim control target without rail glow, then a separate occupied-lock state. | A preselected persistent branch executes a planned route; timing matters only at occupation. | Auto-reset, hidden route choice, a new switch type, crossing turn behaviour, alternate-rail lighting. |
| E · `CAPSTONE_CHAIN` | One readable finite route linking the build decision, cargo order, cardinal station pass, and switch choice in a single compact run. | The systems form one puzzle rather than independent minigames. | Additional progression, economy, combat, characters, or unimplemented UI. |
| F · `RESULT_RETRY_OR_EDIT` | A concise factual success/failure debrief with remaining cargo/stack icons and two clearly different recovery paths. | Result feeds a same-layout rehearsal or a build redesign. | Score/combo reward, coins, saving, ranking, fake analytics, or Human/Player Experience PASS. |

## Screen and scene contract

| Board panel / scene_or_screen_id | Actual consumer | Player goal and primary action | Meaningful choice / required information | Expected feedback and next connection | Current evidence / unresolved detail |
|---|---|---|---|---|---|
| 1 · `SX-SCR-001_TITLE` | `vertical_slice_demo.tscn` Title screen / `ProductShellArt::TITLE_HERO_PATH` | Start the finite delivery slice. | A compact locomotive, route junction, cargo silhouettes, and start action establish “route plans stack order.” | Enters the current briefing/first session; title art is atmosphere, not an explanation sheet. | Runtime consumer verified; exact title layout stays current implementation. |
| 2 · `T1_TRACK_CONNECTION_BUILD` | Existing ProductFiniteSlice BUILD board / ProductBoardRenderer | Connect the first run route by placing a rail piece. | Grid, connected rail endpoints, valid placement, forbidden station footprint, and start-reachable intent. | Lime valid placement; crimson forbidden placement; then RUN becomes understandable. | SX-DEC-060 requires off-track station and no rail on its cell. Exact tooltip layout is not yet approved. |
| 3 · `T2_CARGO_AND_CARDINAL_SERVICE_RUN` | Existing T2 stage, lesson art v02 and finite delivery loop | Pick up cargo by exact-cell contact and deliver while passing an adjacent cardinal service cell. | Cargo exact cell versus station UP/RIGHT/DOWN/LEFT one-tile service; diagonal and station footprint excluded. | Pickup/anticipated unload state and delivery feedback clarify the different contacts; continues to LIFO planning. | Runtime semantics merged; this board is not proof of physical comprehension. |
| 4 · `T3_LIFO_TOP_REVERSE_PLAN` | Existing T3 stage / Stack HUD / semantic cargo assets | Plan load order backward from the station’s needed TOP group. | Compact stack, TOP, next group, cargo color + shape; no long train representation. | TOP is visible before arrival; correct contiguous matching group unload rewards the plan. | LIFO is implemented; final compact-token/HUD geometry is a Phase 2 UI task. |
| 5 · `T4_SELECTIVE_NONLOAD_REVISIT` | Existing T4 stage / finite delivery loop | Leave a tempting cargo unloaded and revisit it later. | Current stack order, later cargo value, route revisit possibility. | Untouched cargo remains visible; route and stack make the later correction leg readable. | No new route-visual system is authorized by this board. |
| 6 · `T5_AUTO_SAFE_OFF_DECISION` | Existing T5 stage / manual load + auto-load toggle | Use Auto only on the safe segment and turn it off when auto-loading would damage the plan. | Exact cargo contact, current auto state, next TOP consequence. | Persistent non-colour mode state plus normal cargo feedback; moves to live switch execution. | Existing manual/auto system only; no new controls or automated policies implied. |
| 7 · `T6_DIRECT_SWITCH_EXECUTION` | Existing T6 stage / RouteControlOverlay + ProductBoardRenderer | Directly choose a junction route while the train moves. | Actual current direction, dim alternate control target, selected forward route, occupied lock. | Only the train's current selected forward rail route is bright; lock is overlaid; terminal result does not predict another route. | Existing direct switch control with occupied lock remains authoritative; no solver is introduced. |
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
| BUILD/RUN board terrain, train, rail, markers, stations, cargo | SX-VIS-063-RQ-001 | User-approved terrain v02, nine non-rail v02 assets, and four v04 rail crops are GitHub-tracked and connected to the fourteen runtime slots. This planning-board binary itself remains `NOT_RUNTIME_PROOF`. |
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
