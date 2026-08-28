# Target Build Screen Surface and Visual Coverage

> Canonical coverage owner for the current Switchy Express vertical slice. This document records **screen-to-consumer coverage**, not a second asset manifest, visual bible, or image-production backlog.

```yaml
document_id: SX-SCREEN-VISUAL-COVERAGE-001
status: SCREEN_INVENTORY_HANDOFF_READY
target_build: GMB-002 finite delivery vertical slice · SX-DEC-060
source_main_audited: 1140b5fbc3a093af3f38d395827d752c62d2ac58
issue: '#222'
canonical_role: CANONICAL_VISUAL_COVERAGE_OWNER
screen_inventory_contract: SCREEN_SURFACE_INVENTORY_FIRST
image_generation_policy: NO_AUTOMATIC_IMAGE_GENERATION_FROM_GAPS
project_stage: VERTICAL_SLICE
design_resolution: 1920x1080 logical; 1280x720 override; canvas_items stretch
protected: SX-DEC-060 semantics, Candidate 003 historical-only, PR #174 READ_ONLY
```

## 1. Scope and verdict

The player-facing target is a finite first-session flow, not a campaign shell or release build.

```text
Title → Controls (optional) → T1–T6 / capstone briefing → BUILD
→ preflight feedback → RUN / route choice / event feedback
→ pause / exit confirmation (optional) → success or failure → retry / edit / title
```

- Relevant P0 and P1 surfaces are implemented with an actual scene or runtime consumer and have repository/runtime evidence.
- `P0 GAP_BLOCKING = 0`. There is no image-generation task created by this audit.
- The remaining Windows physical/audio, Android, five-person, and player-experience gates are evidence gates, not missing screen/image requirements. They stay `NOT_RUN`.
- Current runtime proof is machine evidence only: Godot 4.7.1, 1920×1080 logical / 1280×720 capture, Hera diagnostics `0 errors / 0 warnings`, plus the listed GUT/runtime tests. It is not human QA or release proof.

## 2. Screen inventory and screen-level evidence

| ID | Family / priority | Flow entry → exit | Player goal / question | Runtime consumer and screen evidence | Coverage |
| --- | --- | --- | --- | --- | --- |
| SX-SCR-001 | MAIN_TITLE_MENU · P0 | launch / title return → start, controls, quit | “What is this puzzle and how do I start?” | `vertical_slice_demo.tscn::TitleScreen`; `ProductShellArt::TITLE_HERO_PATH`; live 1280×720 Godot capture on 2026-08-27; `test_vertical_slice_demo_boot.gd`, `test_playable_poc_visual_integration.gd` | COVERED_EXISTING |
| SX-SCR-002 | CODEX_ARCHIVE_MANUAL_TUTORIAL_HELP · P1 | title controls → close / cancel → title | “Which pointer and keyboard inputs are available?” | `ControlsOverlay`; text is live `Label`, no bitmap slot; flow/controller and responsive-layout tests | COVERED_EXISTING |
| SX-SCR-003 | PREPARATION_BRIEFING_PARTY_EQUIPMENT (lesson briefing) · P0 | title / each lesson transition → begin build / cancel → build or title | “What is the one rule I should learn now?” | `BriefingScreen`; `ProductShellArt::LESSON_HERO_PATH`; first-session data/copy/director; live Lesson check in `2026-08-27-ingame-visual-consistency-runtime-verification.md` | COVERED_EXISTING |
| SX-SCR-004 | EXPLORATION_GAMEPLAY_CORE (BUILD) · P0 | briefing / edit result → preflight pass → RUN; menu → pause | “Where can I build, what is invalid, and what must be fixed before RUN?” | `ProductFiniteSlice/BoardRenderer/HUD`; `ProductBoardRenderer::board_terrain`; `ProductHUD::ProblemBanner`; live BUILD check, `test_product_hud.gd`, `test_demo_responsive_layout.gd` | COVERED_EXISTING |
| SX-SCR-005 | SPECIAL_ACTION_OVERLAY (route control) · P0 | reachable switch in RUN → direction choice / occupied lock → RUN | “Which branch will the train take, and is it locked?” | `RouteControlOverlay`; procedural arrows/route traces and semantic assets; `test_route_control_runtime_ui.gd`, `test_first_session_responsive_accessibility.gd` | COVERED_EXISTING |
| SX-SCR-006 | EXPLORATION_GAMEPLAY_CORE (RUN) · P0 | valid BUILD start → outcome / pause | “What is my load mode, TOP cargo, remaining time, and current route?” | `ProductFiniteSlice/HUD/StackPanel/RunToolbar`; `SemanticEventOverlay`; finite runtime + semantic presentation tests | COVERED_EXISTING |
| SX-SCR-007 | SPECIAL_ACTION_OVERLAY (semantic event) · P1 | cargo / station / route event → timed acknowledgement → RUN | “What just loaded, unloaded, locked, or failed?” | `SemanticEventOverlay`, `DemoEffects`, `DemoAudioDirector`; `test_runtime_semantic_poc.gd`, `test_semantic_event_overlay.gd` | COVERED_EXISTING |
| SX-SCR-008 | PAUSE_SETTINGS (pause only) · P1 | gameplay menu / pause → resume or exit confirmation | “Can I safely pause and inspect before deciding?” | Shell `PauseOverlay`; `test_demo_overlay_ownership.gd`, `test_demo_mid_run_exit.gd`, responsive layout evidence | COVERED_EXISTING |
| SX-SCR-009 | PAUSE_SETTINGS (exit confirmation) · P1 | pause exit → continue or title | “Will leaving discard this attempt?” | Shell `ExitConfirmOverlay`; live text/action nodes, `test_demo_mid_run_exit.gd` | COVERED_EXISTING |
| SX-SCR-010 | RESULT_REWARD (success) · P0 | finite success → retry, edit, title / next lesson | “Did I complete delivery and what can I do next?” | Shell `ResultOverlay` + `ProductShellArt::RESULT_SUCCESS_PATH`; result-copy and live success checks | COVERED_EXISTING |
| SX-SCR-011 | FAILURE_RETRY_ENDING_CREDITS (failure) · P0 | time/route-end failure → retry, edit, title | “Why did this attempt end, and do I retry unchanged or redesign?” | Shell `ResultOverlay` + `ProductShellArt::RESULT_FAILURE_PATH`; live 1280×720 failure capture, result-copy tests | COVERED_EXISTING |

All rows have `consumer_kind: GAME_RUNTIME`; their `consumer_surface` is the named screen/overlay rather than a document, concept sheet, or asset gallery.

### Per-screen reference, routing, and blocker record

| ID | Screen design reference / composition evidence | Variants / technical consumption | Notion destination | Repository destination | Blockers |
| --- | --- | --- | --- | --- | --- |
| 001 | `RUNTIME_SCENE_CAPTURE` + existing approved shell composition | 1920×1080 logical, 1280×720 current capture; 1774×887 title crop; pointer/keyboard | Home + Direction + Visual | scene, `product_shell_art.gd`, title manifest | none |
| 002 | `EXISTING_SCENE_COMPOSITION` + responsive screen tests | Korean live text; close/cancel; pointer/keyboard | Puzzle Systems + Direction | scene, flow controller, responsive tests | none |
| 003 | `RUNTIME_SCENE_CAPTURE` + live Lesson check | 1672×941 crop; T1–T6/capstone live text; pointer/keyboard | Puzzle Systems + Visual | first-session data/copy/director, scene, shell art | none |
| 004 | `RUNTIME_SCENE_CAPTURE` + live BUILD check | 1672×941 terrain backdrop; grid/board clipping bound; pointer/keyboard | Puzzle Systems + Visual + Production | board renderer, HUD, map/preflight tests | none |
| 005 | existing board composition + runtime UI test | selected/unselected/occupied/inactive; procedural arrow, no text-in-image | Puzzle Systems + Visual | route overlay, semantic catalog, tests | no physical readability claim |
| 006 | existing board composition + finite/semantic tests | manual/auto, TOP, timer, paused; 1920×1080 logical | Puzzle Systems + Visual | slice, HUD, semantic state/catalog | no audio perception claim |
| 007 | existing board composition + event overlay tests | pickup/unload/route state; timed overlay is non-authoritative presentation | Visual + Production | semantic overlay/effects/audio director | no audio perception claim |
| 008 | existing modal composition + overlay/exit tests | resume and exit; pointer/keyboard cancel path | Puzzle Systems + Production | scene, flow controller, overlay tests | none |
| 009 | existing modal composition + mid-run exit tests | continue vs discard; focus returns to continue | Puzzle Systems + Production | scene, flow controller, exit tests | none |
| 010 | `RUNTIME_SCENE_CAPTURE` + live success consumer check | success art crop; retry/edit/title labels remain UI | Home + Visual + Production | scene, shell art, result-copy tests | no human-result-comprehension claim |
| 011 | `RUNTIME_SCENE_CAPTURE` + 1280×720 failure capture | time/route-end copy; failure art crop; retry/edit/title | Home + Visual + Production | scene, shell art, result-copy tests | no human-result-comprehension claim |

### State-family disposition

| Surface family | Required states for this Slice | State-family status | Evidence ceiling |
| --- | --- | --- | --- |
| Shell buttons | normal, pressed, disabled where action unavailable, keyboard/cancel path | COMPLETE | `test_demo_theme.gd`, responsive/accessibility/flow tests; physical assistive-input QA NOT_RUN |
| Build preflight | valid start, invalid/blocked, reason badge, problem cells | COMPLETE | `ProductHUD`, preflight tests; no human comprehension claim |
| RUN | manual-held, auto off/on, TOP empty/loaded/unloading, time, paused | COMPLETE | semantic catalog/runtime tests; audio perception NOT_RUN |
| Route control | selected, unselected, occupied/locked, inactive | COMPLETE | descriptor/runtime UI tests; physical route readability remains an evidence gate |
| Result | success, time expired, route end, retry/edit/title | COMPLETE | result-copy/controller tests and live success/failure consumer checks |
| First session | T1–T6 plus capstone progressive disclosure | COMPLETE | first-session controller, copy, responsive-accessibility tests |

`COMPLETE` means the currently applicable Slice states are represented and tested; it does not promote human/device/accessibility certification.

## 3. Screen → visual layer / asset matrix

| Screen IDs | Composition / identity | World / object | UI, text, feedback | Modes and actual consumer | New image decision |
| --- | --- | --- | --- | --- | --- |
| 001 | dark E+D shell panel + title layout | title hero banner | live title/subtitle/buttons | `EXISTING_APPROVED`, `RASTER_IMAGE`, `GODOT_UI`, `TEXT_LAYER`; `TitleScreen/.../HeroArt` | NO_NEW_IMAGE_FILE_REQUIRED |
| 002, 008, 009 | shared panel/modal hierarchy | none | live labels, buttons, focus/cancel path | `REUSE_PROJECT`, `GODOT_UI`, `TEXT_LAYER` | DO_NOT_GENERATE |
| 003 | lesson card framing and hierarchy | lesson hero | live progress/title/objective/rules/action | `EXISTING_APPROVED`, `RASTER_IMAGE`, `GODOT_UI`, `TEXT_LAYER`; `BriefingScreen/.../LessonArt`, with T2-only cardinal-service Hero v02 | T2 consumer-specific v02 complete; no further image file required |
| 004 | board terrain under live grid | rails, train, cargo, stations | build tools, cost, preflight badge/problem text | terrain `RASTER_IMAGE`; rail/station/cargo assets `EXISTING_APPROVED`; grid/service/preflight `PROCEDURAL_DRAW`; HUD `GODOT_UI` | NO_NEW_IMAGE_FILE_REQUIRED |
| 005, 006, 007 | same board; no replacement screen art | train/rails/cargo/stations | route arrow, selected/unselected/locked trace, stack/mode/event feedback | `PROCEDURAL_DRAW`, existing semantic PNGs, `GODOT_UI`, `TEXT_LAYER`; `RouteControlOverlay`, `SemanticEventOverlay` | DO_NOT_GENERATE |
| 010, 011 | result panel composition | success/failure result art | live title, reason, remaining count, Retry/Edit/Title actions | `EXISTING_APPROVED`, `RASTER_IMAGE`, `GODOT_UI`, `TEXT_LAYER`; `ResultOverlay/.../ResultArt` | NO_NEW_IMAGE_FILE_REQUIRED |

### Runtime image records reused

| Asset set | Existing real consumer | Required technical handling | Status |
| --- | --- | --- | --- |
| `SX-TITLE-HERO-001` | `ProductShellArt::TITLE_HERO_PATH` | 1774×887 PNG; crop within HeroArt rect; text remains a Godot layer | dual-preserved / conditional release rights |
| `SX-BOARD-TERRAIN-001` (`SX-INGAME-VISUAL-001`) | `ProductBoardRenderer::PRODUCT_VISUAL_ASSET_PATHS[board_terrain]` | 1672×941 backdrop; live grid/rail/cargo/station/HUD remain engine-rendered | dual-preserved / runtime verified |
| `SX-LESSON-HERO-001` (`SX-INGAME-VISUAL-001`) | `ProductShellArt::LESSON_HERO_PATH` for T1, T3–T6, CAPSTONE | 1672×941 neutral shared source-region crop before cover draw; no embedded UI copy | dual-preserved / runtime verified |
| `SX-LESSON-HERO-002` (`SX-INGAME-VISUAL-001`) | `ProductShellArt::T2_LESSON_HERO_PATH` only for T2 | 1672×941 source-region crop before cover draw; off-track station + adjacent rail service; no embedded UI copy | dual-preserved / Notion readback 2026-08-27T21:34:35.550Z |
| `SX-RESULT-SUCCESS-002` (`SX-INGAME-VISUAL-001`) | `ProductShellArt::RESULT_SUCCESS_PATH` | 1672×941 source-region crop before cover draw; no embedded UI copy | dual-preserved / runtime verified |
| `SX-RESULT-FAILURE-002` (`SX-INGAME-VISUAL-001`) | `ProductShellArt::RESULT_FAILURE_PATH` | 1672×941 source-region crop before cover draw; no embedded UI copy | dual-preserved / runtime verified |
| semantic product PNGs | `SemanticAssetCatalog`, `ProductBoardRenderer`, overlays | state-specific component consumption; semantic color is reinforced by shape/text | existing project assets |

Exact hashes, Notion attachments, and conditional rights are owned by `art/product_assets/ed_hybrid_v1/runtime_visual_manifest.json` and `docs/ASSET_RIGHTS_AND_PROVENANCE_RECORD.md`; this document does not duplicate that manifest.

## 4. Full family applicability audit

| Base family | Current target disposition and reason |
| --- | --- |
| BOOT_SPLASH_LOADING | NOT_APPLICABLE — no implemented player-facing loading/progress surface in this Slice; engine boot is not a product screen. |
| MAIN_TITLE_MENU | COVERED_EXISTING — SX-SCR-001. Save/settings/credits are not implemented Slice features. |
| NEW_GAME_PROFILE_SAVE_LOAD | NOT_APPLICABLE — no save/profile/load owner in current Slice. |
| CHARACTER_BUILD_LOADOUT_SELECT | NOT_APPLICABLE — no character/loadout system. |
| HUB_HOME_MAP_ROUTE | NOT_APPLICABLE — first-session progression is linear, with no hub/map surface. |
| EXPLORATION_GAMEPLAY_CORE | COVERED_EXISTING — SX-SCR-004 and 006. |
| DIALOGUE_EVENT_STORY | NOT_APPLICABLE — no dialogue/event system. |
| PREPARATION_BRIEFING_PARTY_EQUIPMENT | COVERED_EXISTING as lesson briefing only — SX-SCR-003; party/equipment scope is not applicable. |
| BATTLE_COMBAT | NOT_APPLICABLE — finite rail puzzle, not combat. |
| SPECIAL_ACTION_OVERLAY | COVERED_EXISTING — route-control and semantic-event overlays. |
| RESULT_REWARD | COVERED_EXISTING — success and failure action surfaces; economy/reward selection is out of current Slice. |
| PROGRESSION_UPGRADE_SHOP_CRAFT_REST | NOT_APPLICABLE — cosmetic-only boundary and no implemented progression surface. |
| CODEX_ARCHIVE_MANUAL_TUTORIAL_HELP | COVERED_EXISTING as controls overlay / lesson flow; full codex is not implemented. |
| PAUSE_SETTINGS | COVERED_EXISTING as pause/exit confirmation; settings/accessibility/language screens are NOT_APPLICABLE because no runtime consumer exists. |
| FAILURE_RETRY_ENDING_CREDITS | COVERED_EXISTING for failure/retry; ending/credits are NOT_APPLICABLE. |
| LOADING_TRANSITION_ERROR | NOT_APPLICABLE — no explicit loading, network, save, or permission flow in target build. Preflight is an in-game BUILD state, not a loading/error screen. |
| DEBUG_DEVELOPMENT_ONLY | NOT_APPLICABLE to player-facing coverage; Hera/GUT diagnostics remain development evidence only. |

## 5. Visual requirement / production queue

No new `RASTER_IMAGE`, `SPRITE_SHEET`, or screen reference is authorized by this audit. The queue only records implementation work that becomes valid after a concrete consumer and separate decision exist.

| Queue ID | Candidate | Consumer / why it is not a current requirement | Status |
| --- | --- | --- | --- |
| SX-VIS-Q-001 | physical Windows/audio visual review | existing 001–011 screens; validates current implementation rather than creating a new asset | EVIDENCE_GATE_NOT_RUN |
| SX-VIS-Q-002 | Android landscape screen/input review | existing 001–011 screens; device evidence only | EVIDENCE_GATE_NOT_RUN |
| SX-VIS-Q-003 | first-contact comprehension study | existing player questions for build, TOP, route choice, result | EVIDENCE_GATE_NOT_RUN |
| SX-VIS-Q-004 | release system screens / store assets | no current runtime or product-distribution consumer/decision | DEFERRED_BY_DECISION · DO_NOT_GENERATE |
| SX-VIS-Q-005 | optional title-shell composition expansion | current title is a valid, non-clipped runtime surface; a larger landscape identity treatment is a P2 polish choice, not a missing P0/P1 image slot | DEFERRED_BY_DECISION · DO_NOT_GENERATE |

## SX-DEC-062 coverage addendum

`SX-DEC-062` authorizes a single existing-consumer composition refinement, tracked by GitHub Issue #235. It does not change this inventory’s `P0 GAP_BLOCKING = 0` result or create a bitmap queue item.

```yaml
allowed_runtime_consumers:
  - DemoPalette / DemoThemeFactory
  - ProductHUD and existing shell panels
  - ProductBoardRenderer draw ordering
protected_runtime_consumers:
  - ProductShellArt title / lesson / result exact paths
  - SemanticAssetCatalog and existing 73 product PNGs
  - FirstSession StagePolicy and current finite domain
new_image_file: 0
human_evidence: NOT_RUN
```

Issue #227 is a separate T2-consumer replacement proposal and is `DEFERRED_OUT_OF_SX_DEC_062_SCOPE`; it is neither closed nor absorbed.

## SX-DEC-063 coverage addendum

SX-DEC-063 changes the prior no-new-image disposition only for real consumers already inventoried in this document. It does not change the screen inventory, P0 blocking-gap verdict, finite gameplay, or evidence ceiling.

| Requirement | Applicable screen surfaces | Existing real consumer | Coverage status | Production state |
| --- | --- | --- | --- | --- |
| SX-VIS-063-RQ-001 board diorama | SX-SCR-004 BUILD, SX-SCR-005 route control, SX-SCR-006 RUN, SX-SCR-007 semantic events | ProductBoardRenderer product visual asset paths | REQUIREMENT_LINKED | First terrain image brief is ready; no image generated, approved, or integrated. |
| SX-VIS-063-RQ-002 shell cohesion | SX-SCR-001 title, SX-SCR-003 shared non-T2 lesson, SX-SCR-010 success, SX-SCR-011 failure | ProductShellArt title, shared lesson, success/failure paths | REQUIREMENT_LINKED | Four future versioned candidates, each with a separate one-image approval gate. T2 v02 is COVERED_EXISTING and protected. |
| SX-VIS-063-RQ-003 deck density | SX-SCR-001, 003, 004, 006, 010, 011 | existing Godot Theme, HUD, shell panels | REQUIREMENT_LINKED | Later code-only integration review; no new control or gameplay state. |

Current disposition:

~~~yaml
project_relation: SWITCHY_EXPRESS
decision: SX-DEC-063
candidate_generation_policy: EXACT_TEXT_BRIEF_THEN_ONE_USER_APPROVED_IMAGE
actual_consumer_required: true
approved_runtime_asset_count_from_sx_dec_063: 0
runtime_integration_from_sx_dec_063: NOT_STARTED
t2_hero_v02: PROTECTED_EXISTING_CONSUMER
issue_227: DEFERRED_SEPARATE_SCOPE
human_device_player_evidence: NOT_RUN
~~~

The original SX-DEC-062 addendum remains a true record of that implementation's zero-new-bitmap scope. It is not authorization for SX-DEC-063 image production.

## 6. Codex handoff boundary

```yaml
implementation_owner: CODEX_GODOT_PRODUCT_IMPLEMENTATION_HANDOFF
current_build_action: none
required_before_any_new_visual_asset:
  - exact runtime node/key/path consumer
  - coverage row with consumer_kind, primary_use, validation
  - Visual Requirement Gate / approved decision
  - latest applicable user image-approval policy (this audit supplies no generation authority)
  - local tracked path + Notion Visual/Asset destination + SHA-256/provenance + readback
never_do:
  - create images from a coverage gap alone
  - turn a screen composition reference into a runtime bitmap
  - change SX-DEC-060 gameplay semantics or PR #174
```

## 7. Review and readback record

### Five adversarial passes

1. **Screen completeness:** title, core gameplay, result, pause, exit, controls, overlays, and all Base families either have an inventory row or `NOT_APPLICABLE` reason.
2. **Player comprehension:** each relevant surface has a single player question; important game meaning remains color + shape + text, not color-only.
3. **Asset / variant completeness:** title, lesson, terrain, success/failure, semantic components, procedural route/service cues, and state families are separated by their actual consumers.
4. **Anti-overproduction:** no missing campaign/settings/store screen became an image task; all current rows reuse Godot UI, procedural draw, or existing approved assets.
5. **Canon/runtime consistency:** exact `main`, scene/controller/HUD/asset manifest, live Godot scene graph, decision boundaries, and Notion destinations were compared. The stale registry reference and first-session semantic wording below are corrected by Issue #222.

### Canonical freshness correction

- `DESIGN_DOCUMENT_REGISTRY.json` previously pointed its active work-instruction entry to the historical v4.5 r2 adapter. The registry must point to the active v4.8 r5.4 thin adapter.
- `FIRST_SESSION_SCREEN_CONTENT_DATA_CONTRACT.md` previously declared schema v2 as current and omitted the cardinal-adjacent station teaching rule. It now identifies schema v3, exact-cell cargo, cardinal station service, and the historical v2 boundary without changing lesson count or runtime behavior.
- This document is registered as the single project coverage owner for the current target build and linked from the Documentation Map. Historical visual requirement packages remain historical/planning evidence and do not own current coverage or auto-generate images.

### Remaining work recalculation

```yaml
machine_executable_screen_coverage_work: 0
p0_visual_gap_blocking: 0
current_scope_new_image_generation: 0
open_evidence_gates:
  - Windows physical + audio perceptual
  - Android device
  - five-person first-contact
  - player-experience decision
result: CLEAN_COVERAGE_EXIT_WITH_EVIDENCE_GATES_OPEN
```
