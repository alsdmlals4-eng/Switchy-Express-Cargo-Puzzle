# SX-DEC-063 · Hybrid Miniature-Diorama Visual Production Alignment

**Status:** USER_APPROVED_DIRECTION · PLANNING_CURRENT · FIRST_CANDIDATE_GENERATED_REVIEW_PENDING · RUNTIME_UNCHANGED
**Date:** 2026-08-28 KST
**Tracking:** GitHub Issue #239
**Predecessors:** SX-DEC-061 visual lock, SX-DEC-062 existing-asset runtime composition
**User decision:** The user selected alternative A — Hybrid Diorama Alignment after a same-viewport machine comparison of the user-approved visual reference and current runtime consumers.

## Decision

Keep the actual rectangular BUILD/RUN cell model and its input mapping. Align the art around it as a **2D interaction board with controlled 2.5D miniature-diorama depth**, rather than converting it to a geometrically isometric board.

~~~text
unchanged rectangular cell input and finite puzzle rules
→ new versioned, text-free art only for proven current consumers
→ shared warm miniature material / silhouette / lighting grammar
→ denser dark-navy control deck around a board-first hierarchy
→ one later bounded Godot implementation window after candidate approval
~~~

This decision supersedes only SX-DEC-062's zero-new-raster limitation for the consumers enumerated below. SX-DEC-062 remains the verified existing-asset composition baseline and does not become historical or invalid.

## Why this change is needed

Machine runtime review at 1280×720 confirmed that the current Title, Briefing, BUILD board, and Result consumers load and render. It also confirmed a material visual conflict:

- the planning canon asks for a warm elevated miniature railway, while the actual gameplay interaction grid is orthogonal and the board objects use a separate high-contrast pixel/black-outline material language;
- current terrain, core objects, and shells do not yet read as one production family;
- Title, Briefing, and Result retain sparse, flat shell compositions relative to the approved board-first reference.

The user-provided comparison collage remains a **reference-only** input. Its layout, labels, controls, pseudo-text, and claimed game states are not requirements or runtime proof.

## Player-facing intent

The player must see the board before the deck, distinguish buildable rail, off-track station, cargo, route, selected branch, locked branch, and TOP state at gameplay scale, then understand a failure or success without invented score/economy feedback.

The visual treatment must strengthen this causal chain without changing it:

~~~text
build a route
→ predict encounter order and stack TOP
→ commit to a branch
→ observe cardinal-adjacent delivery / failure cause
→ Retry same layout or Edit
~~~

## Visual lock refinement

| Axis | Adopted |
| --- | --- |
| Gameplay projection | Rectangular grid and current cell hit-testing remain exact. This is **not** a true isometric coordinate conversion. |
| World | Warm toy-scale railway diorama; grass, stone, timber, brass, navy enamel, soft contact shadows, warm practical lights. |
| Object language | Rounded, readable silhouettes with thin dark navy/brown edge separation. Avoid universal pure-black pixel outlines or sticker-flat fills. |
| Camera reading | Elevated 3/4 depth cues are painted inside asset bounds; rail ports, station service cells, and cargo cell identity remain unambiguous on the rectangular board. |
| UI | Deep navy/charcoal control deck, restrained brass trim, visible spacing groups, live Godot text, and a clear primary action. |
| State grammar | Lime + direction/shape for selected or valid; blue + lower emphasis for alternative; crimson + prohibition/lock/reason for invalid or failure; violet + bounded live-text lesson focus. |

### Keep

- board-first hierarchy, compact LIFO world token and Stack HUD;
- color + shape + live text redundancy;
- off-track station, exact-cell cargo pickup, and cardinal-adjacent station service;
- compact train silhouette, not a long cargo train;
- T1→T6→VS_DEMO_01→Result flow and current localized live copy.

### Avoid

- copied reference layouts, logos, UI chrome, artists, or branded expression;
- pseudo-text, embedded UI copy, score, currency, leaderboard, save, progression, or analytics;
- a diagonal service implication, station-footprint rail/delivery, fuel, BOOST, capacity limit, or new game rule;
- overloaded ornament that hides track ports, valid/invalid feedback, route traces, cargo, station, lock, or TOP.

### Do not drift

- All new board assets share one material, light direction, elevation cue, and silhouette grammar.
- Failure may use stronger crimson and a lesson more violet, but they remain recognizably the same product.
- Exact rule text remains live Godot UI and structured canon, never image content.

## Actual-consumer production scope

All paths below are **proposed versioned candidate paths**, not created files or runtime integration. Existing assets stay tracked and recoverable.

| Requirement | Existing consumer | Candidate family / proposed target | Technical contract |
| --- | --- | --- | --- |
| SX-VIS-063-RQ-001 board diorama | ProductBoardRenderer product visual asset paths | terrain v02; locomotive v02; 4 rail v02; start/ROUTE_END markers v02; 3 stations v02; 3 cargo v02 | 14 slots. Terrain: 1672×941 RGB/RGBA backdrop. Train: 128×96 alpha. All remaining core slots: 64×64 alpha. Existing cell rotation/pivot conventions and transparent margins stay compatible. |
| SX-VIS-063-RQ-002 shell cohesion | ProductShellArt title, shared non-T2 lesson, success result, failure result | title v02, lesson v03, success v03, failure v03 | Title: 1774×887. Other shells: 1672×941. Text/logo/watermark-free; source-safe center crop for the existing cover draw. |
| SX-VIS-063-RQ-003 deck density | DemoThemeFactory, existing HUD/shell panels | code-only spacing, panel hierarchy, and CTA emphasis review | No new visible system, text ownership, or interactive control. Requires later implementation contract. |

The following are explicitly protected:

- ProductShellArt T2 lesson path remains shell_lesson_hero_v02.png;
- GitHub Issue #227 remains a separate deferred T2 procedure and is not absorbed;
- all 73 semantic product PNG consumers retain their current ownership until a separately approved requirement selects one;
- existing v01/v02 files, current manifest records, and their provenance are preserved rather than overwritten.

## Asset brief and candidate lifecycle

The first production unit is deliberately one image only:

~~~yaml
candidate_id: SX-VIS-063-CANDIDATE-001
requirement_id: SX-VIS-063-RQ-001
consumer: ProductBoardRenderer board_terrain
proposed_path: art/product_assets/ed_hybrid_v2/board/board_terrain_playfield_v02.png
output: 1672x941, text-free, logo-free, watermark-free
primary_use: warm board terrain backdrop beneath Godot grid, rails, train, cargo, stations, route, and HUD
must_show: calm grass/soil/stone/conifer miniature terrain; open readable central playfield; subdued 3/4 depth cues; warm low-angle practical lighting
must_not_show: track geometry, station/cargo/train objects, text, UI, coin/score/save elements, branded/logo material, identifiable reference layout
runtime_compare_required: true
candidate_status: TEXT_BRIEF_READY · NOT_GENERATED
~~~

**2026-08-28 user workflow amendment:** actual-consumer candidates may be generated and machine-reviewed without a per-image pre-generation approval. The first candidate has been generated for review. The user decides only whether to promote a reviewed candidate to a final project asset. This does not authorize a batch, runtime integration, or the next consumer family automatically.

For every candidate that later passes review:

~~~text
generate exactly one candidate
→ review against this decision and actual consumer size
→ user approval / revision / rejection decision
→ if promoted: project-local Git tracked asset + SHA-256 + provenance
→ approved asset only after explicit promotion
→ later Godot integration in one bounded implementation contract
~~~

## Production and implementation boundaries

### In scope now

- visual decision, coverage requirement links, exact candidate briefs, provenance plan, and stale-canon correction;
- production candidates may be generated and machine-reviewed under the user-authorized workflow; only final asset promotion requires the user’s disposition;
- asset review against real consumer dimensions.

### Deferred until the production set is approved

- GDScript, Scene, Resource, import, manifest, and consumer-path changes;
- test additions and a new exact package candidate;
- physical Windows/audio, Android, five-person, Player Experience, and production-cutover claims.

### Out of scope

- finite map/schema/rule change; cargo exact-cell pickup; cardinal station service; LIFO/TOP; switch controls; tutorial count; audio; score/economy/progression; Base pin; PR #174;
- T2 Hero replacement, Issue #227, and all 056–058 packages;
- true isometric coordinate projection or transformed touch hit-testing.

## Acceptance and validation contract

1. A future implementation preserves the current 960×540, 1280×720, 1600×900, 1920×1080, and 2560×1080 control bounds and 48px minimum targets.
2. Board art keeps rail ports, cargo/star silhouette, off-track station distinction, cardinal service cue, start/ROUTE_END, selected/alternate/locked routes, and train position readable.
3. Images contain no canonical text, pseudo-text, unimplemented systems, or copyrighted/branded reference expression.
4. Every promoted generated asset has a proven consumer, versioned local Git path, SHA-256 and provenance/rights record before it is called `APPROVED_GITHUB_PRESERVED`. Candidate generation alone remains `NOT_RUNTIME_PROOF`.
5. A later runtime comparison uses the same actual consumer state and viewport as the reference comparison. It checks material cohesion, crop, density, clipping, state readability, and style drift.
6. Automated/package/runtime evidence does not promote Windows physical/audio, Android, five-person, Player Experience, release-rights, or production-cutover evidence.

## Incident / solution / lesson

| Field | Record |
| --- | --- |
| Incident | The implemented existing-asset composition satisfied SX-DEC-062 but did not fully satisfy the approved miniature-diorama material/camera grammar. |
| Solution | Preserve the interaction grid and replace only proven visual consumer families with versioned, cohesion-first candidate art; generate and machine-review candidates before the user’s promotion/revise/reject disposition. |
| Lesson | A runtime asset loading check is necessary but insufficient for visual-direction verification; compare the approved visual grammar and the real consumer at the same viewport before declaring visual alignment. |
| Base promotion | NO_BASE_PROMOTION: the diagnosis depends on Switchy's exact board renderer, consumer paths, finite-rule readability, and user-approved direction. Repeated cross-project evidence is absent. |

## Canonical destinations

- Repository structured canon: this Decision, VISUAL_DIRECTION.md, PROJECT_CORE_SCENE_VISUAL_BOARD.md, TARGET_BUILD_SCREEN_SURFACE_AND_VISUAL_COVERAGE.md, current project-hub owners, and the later implementation contract.
- GitHub human-facing surface: `exports/` master GDD and project-hub/design owners. Notion is `RETIRED_NO_ACTIVE_USE`; previously synced pages are history/audit only.
- Not a destination: the foreign Direction page below Home, and Draft PR #174.

## Post-merge destination readback

- GitHub: PR #240 squash-merged to `main@f316ee1ba3b641e655facfb3bfaee28b3bc8d64b`; Project Contract, Base Adapter approval, Thin Adapter, GUT, Godot tests, and Windows Demo Export completed successfully on the exact head.
- Historical Notion sync/readback before the 2026-08-28 retirement remains audit evidence only. No future Notion binary attachment, runtime asset approval, or GitHub completion dependency exists.
