# Board-first Runtime Composition Design

**Decision:** `SX-DEC-062`
**Status:** `DESIGN_COMPLETE · IMPLEMENTATION_NOT_STARTED`
**Date:** `2026-08-28 KST`
**Canonical decision:** `docs/decisions/SX_DEC_062_BOARD_FIRST_RUNTIME_COMPOSITION.md`
**Tracking:** GitHub Issue #235

## 1. Intent and player experience

Switchy Express is a finite delivery puzzle, not a rail tycoon or a decorative railway viewer.

```text
Player Promise
→ draw a route that determines cargo encounter order
→ choose what to load now, leave, or automate
→ see the LIFO TOP and choose a live switch direction
→ pass a cardinal service tile to unload the matching TOP group
→ read a causal success/failure result
→ retry the same layout or edit it with a clearer next hypothesis
```

The visual adjustment must make that chain faster to perceive. It must not make the board into a background for an ornamental shell, add a fabricated meta loop, or substitute art for exact rules.

### Player questions per surface

| Surface | Question the player must answer | Required visual answer |
|---|---|---|
| BUILD | “Where can I build, and what prevents RUN?” | Grid/rail ghost plus valid-or-problem cue and one live reason. |
| T2/RUN | “Why did cargo load here but the station only accepts an adjacent pass?” | Exact-cell cargo marker, off-track station, subtle cardinal service cues, and live T2 text. |
| T3–T5/RUN | “What is on TOP, and should I load this cargo now?” | Compact world token plus Stack HUD and manual/auto state; never a long cargo train. |
| T6/RUN | “Which branch is selected and is it locked?” | Lime selected direction, blue alternate, crimson lock; line weight/direction/icon reinforce color. |
| Result | “What happened, and do I repeat or redesign?” | One factual cause, live remaining/stack truth, Retry/Edit/Title action hierarchy. |

## 2. Current evidence and design problem

### Confirmed strengths to protect

- The board renderer already projects approved terrain, rails, train, cargo, stations, grid, cardinal service range, selected/alternate/locked route, problem cells, and compact train state.
- `DemoPalette` already assigns lime `#74DF58`, blue `#4DA3FF`, crimson `#EF554D`, shape labels, direction cues, and line-width hierarchy to decision-critical board states.
- Current first-session policy prevents later-system UI from appearing before T4/T5/T6/capstone.
- Title, lesson, and result assets have real runtime consumers; exact copy remains a live Godot text owner.
- Automated responsive tests cover 960×540, 1280×720, 1600×900, 1920×1080, and 2560×1080 with 48px visible controls.

### Validated design gap

The approved world assets share railway motifs but vary more in camera density and cinematic lighting than the active board/control deck. The current theme also owns generic dark-teal/gold control styling separately from the board palette. This makes it too easy for screens to feel like illustrated shell cards surrounding a different gameplay language.

This is a **composition and token-ownership** gap, not evidence that the production assets are missing or unusable. No physical player study has confirmed a specific crop, contrast, or readability defect; that remains `NOT_RUN`.

## 3. Chosen visual grammar

### 3.1 Layer order and density

1. **Decision layer:** rail, selected route, switch target/lock, cargo/station identity, ghost/preflight problem, TOP/load state.
2. **Orientation layer:** grid, start, cardinal station service corners, current phase/time/cost, one bounded lesson focus.
3. **Control-deck layer:** compact tool/action deck, Stack HUD, pause/result controls.
4. **World layer:** existing terrain and shell art only after the above remain legible.

The renderer order is retained: terrain → grid → blocked cells → rail → route overlay → station service range → markers → state overlays → train. Any adjustment must preserve this semantic ordering and must not make the service indicator, preflight outline, or event overlay the gameplay authority.

### 3.2 Named tokens

| Role | Value / current source | Use | Non-colour reinforcement |
|---|---|---|---|
| control-deck base | `#10262B` / `DemoPalette.BACKGROUND` | background and dark shell family | panel silhouette and text contrast |
| raised control surface | `#18363C` / current theme raised surface | contextual panels and controls | border and elevation |
| live text | `#F7F2E8` / `DemoPalette.TEXT_LIGHT` | exact player-facing copy | never rasterized |
| restrained action trim | `#E9AE45` / current theme gold | focus/primary affordance, not success state | focus outline and button state |
| valid / selected | `#74DF58` / `DemoPalette.ROUTE_SELECTED` | valid ghost, selected route, active direction | route width, arrow, outline, hit target |
| alternate route | `#4DA3FF` / `DemoPalette.ROUTE_UNSELECTED` | non-selected available path | lower line weight and alternate direction |
| invalid / locked / route end | `#EF554D` / `DemoPalette.ROUTE_LOCKED` | invalid build, occupied lock, route-end emphasis | X/lock/reason/problem outline |
| bounded lesson focus | `#9B6BDF` / new `DemoPalette.TUTORIAL_FOCUS` | progress/one-rule framing only | visible title/rule grouping; no gameplay state |

`DemoThemeFactory` must derive its corresponding colors from `DemoPalette` or named palette aliases. A later change to a state role therefore cannot produce a second, contradictory visual language.

### 3.3 Screen contracts

#### BUILD and RUN board

- Keep `BoardRenderer`/`RouteControlOverlay` on the same measured board rect; do not give shell panels, terrain, or semantic events input ownership over the board.
- Keep the existing route width invariant: selected > occupied/locked > alternate, and selected width is at least 5px at every current supported viewport.
- Keep station service cues as transparent corner/outline treatment underneath markers and stronger preflight/route states. No filled opaque service tile and no diagonal/footprint implication.
- Keep shape and short Godot labels for cargo/station identity; no color-only instruction.
- Keep `ProblemBanner` conditional on invalid preflight and text-only. It may be made less visually dominant than the board, but must not hide its reason, its semantic badge, or the problem cell outline.

#### HUD / control deck

- Top status remains phase → current contextual instruction/time → cost → menu. It is orientation, not a simulation dashboard.
- Build and RUN toolbars remain bottom-anchored, preserve the existing keyboard labels and ≥48px minimum targets, and reveal only by current first-session policy.
- The Stack panel is visible only for current RUN/paused stages that reveal `STACK_TOP`; it continues to own order/TOP rather than world train length.
- A focused control may use gold; a lesson-only heading/progress may use violet. Gold/violet do not encode cargo, station type, valid placement, or route selection.

#### Title, briefing, result

- Use the same dark control-deck material, border/elevation, live text, and restrained trim as gameplay. Do not replace `ProductShellArt` paths.
- Title art establishes miniature railway atmosphere; it never communicates an exact rule by itself.
- Briefing has exactly one lesson objective, rules grouping, progress, asset crop, and begin action. T2 keeps v02 and text states exact cargo-cell/cardinal-station distinction.
- Result has a concise causal title/body and the existing retry/edit/title choices. Success/failure may vary warm/crimson in their existing art, while CTA spacing/reading order remains shared.

## 4. Out of scope and conflict handling

- Existing T2 v02 remains the active consumer. GitHub Issue #227 is explicitly deferred, not copied into this contract.
- No bitmap file, manifest, hash, Notion attachment, external style reference, or rights classification changes.
- No map/schema/scene-flow/gameplay/copy-rule changes. Current localization strings may be regrouped visually, but their semantic content and locales must not change in this contract.
- No change to candidate identity before an actual runtime change has passed exact-head tests/package verification.
- The stale Switchy Notion Flow description is a documentation correction: it must say cargo uses exact-cell contact and station uses exactly one cardinal adjacent tile; it must not alter runtime.
- The Base reuse profile lists absent `game/reuse/semantic_ui_skin_kit.gd` and `game/reuse/gameplay_symbol_atlas.gd`. This contract chooses `NO_REUSE`: the project’s existing palette/catalog/presentation owners stay authoritative. This is a project-specific profile drift record, not authorization to copy or repin Base.

## 5. Implementation architecture

```text
DemoPalette
  → named visual role values
  → DemoThemeFactory styles for shell/HUD controls
  → product_hud.tscn + vertical_slice_demo.tscn layout hierarchy

ProductBoardRenderer + RouteControlOverlay
  → retain board rect, z order, state descriptors, route/service semantics
  → expose only visual diagnostics needed by deterministic tests

FirstSessionStagePolicy + existing ShellArt/FlowController
  → preserve stage reveal, v02 T2 selection, localized live text, Retry/Edit behavior
```

No new singleton, generalized skin framework, asset resolver, gameplay signal, map field, or Scene is justified.

## 6. Verification design

### Automated RED-first requirements

1. Extend `tests/demo/test_demo_theme.gd` before changing theme code:
   - assert Theme label/button/control-deck colors derive from named palette values;
   - assert primary/focus, disabled, and error states are visually distinguishable;
   - assert rounded panel/button padding and existing readable font floor remain.
2. Extend `tests/demo/test_first_session_responsive_accessibility.gd` before scene/layout changes:
   - retain all five viewport sizes, inside-root checks, ≥48px buttons, stage visibility, and result recovery actions;
   - add shell panel/header/lesson-focus rect checks only after the intended controls are present.
3. Extend `tests/demo/test_product_board_route_clarity.gd` and `test_product_board_renderer.gd`:
   - retain selected > locked > alternate widths and selected ≥5px;
   - retain cardinal-only station service descriptors and the current renderer draw-order contract;
   - assert no tutorial-focus visual becomes a board gameplay state.
4. Extend `tests/demo/test_playable_poc_visual_integration.gd`:
   - exact existing board/title/lesson/result asset paths still load;
   - T2 remains v02; other lessons remain v01; no additional product-art path is introduced.
5. Run the existing runner plus current Python contracts and CI package workflow from the final exact head. Do not substitute old Candidate 002 output.

### Human evidence required after packaging

- Windows: title → briefing → BUILD → T2 RUN → T3/T5 stack/mode → T6 switch → success and both failure causes, including visible sound perception.
- Android: exact post-change APK identity must exist before device smoke; current Android gate is `BLOCKED_UNVERIFIED`.
- Five first-contact players: can state T2 cargo/station difference, identify TOP, choose/recognize a selected vs locked branch, and choose Retry vs Edit after a factual failure.
- The Player Experience decision remains `EXPAND / REWORK / REPEAT_SLICE / HOLD / STOP`; no automatic PASS threshold is invented here.

## 7. Risk controls

| Risk | Control |
|---|---|
| Board loses space to chrome | Preserve the existing board rect contract; test inside-root layout at all five viewports and inspect live captures before accepting any size change. |
| State colors drift between HUD and board | Derive control theme roles from `DemoPalette`; test named values and non-colour cues. |
| T2 explanation becomes art-dependent | Preserve live text and v02 as support only; test exact consumer selection and cardinal descriptors. |
| A visual refactor changes game rules | Do not touch finite domain/map/first-session data or delivery/preflight code; scope test diff confirms. |
| Candidate/human evidence inflation | Mint a new exact candidate only after changed bytes pass; retain all physical/audio/device/player outcomes as `NOT_RUN` until observed. |
| Base module mismatch causes parallel UI authority | Use existing project owners; record `NO_REUSE` and request Base-profile repair only if a shared owner later accepts it. |

## 8. Decision-quality review

### Reuse-first result

| Candidate | Disposition | Reason |
|---|---|---|
| Existing E+D assets + project palette/catalog | ADOPT | Actual consumers, manifest, tests, and visual direction already exist. |
| Base RM-VIS-001 / RM-VIS-002 profile modules | REJECT_NOW / NO_REUSE | Adoption profile names paths not present in this project; adapting them would create a second UI authority. |
| New image batch | REJECT | No missing concrete bitmap consumer; current design gap is composition, not asset absence. |
| Issue #227 procedural T2 replacement | DEFER | A distinct consumer change with independent value/risk; current v02 already supports the rule without owning it. |

### Benchmark disposition

| Reference | Adopt / adapt / reject | Project-specific conclusion |
|---|---|---|
| [Station to Station](https://store.steampowered.com/app/2272400/Station_to_Station/?curator_clanid=34646979&l=english) | ADAPT | Keep warm miniature readability, but make player-built route and LIFO decision—not scenery—the visual hero. |
| [Train Valley 2](https://store.train-valley.com/) | REJECT its tycoon pressure | Do not import upgrades/economy/production dashboard; retain a finite puzzle reading order. |
| [Mini Metro console page](https://minimetro.radialgames.com/) | ADOPT map clarity / REJECT pressure loop | Use immediate route legibility only; do not introduce endless growth, upgrades, or weekly challenges. |

## 9. Approval and next gate

The user approved the A scope on `2026-08-28 KST`. The next authorized action is to merge this documentation/contract package and then use the separate `CODEX_GODOT_PRODUCT_IMPLEMENTATION_HANDOFF` route. Runtime implementation, asset generation, and human-evidence promotion are not performed by this design record.
