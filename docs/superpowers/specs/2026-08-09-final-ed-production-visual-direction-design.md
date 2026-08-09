# Final E+D Production Visual Direction — Design Spec

**Decision:** `SX-DEC-053`  
**Date:** 2026-08-09 KST  
**Baseline:** `95dda145b518ce29bead78a5cbf5566cfa675419`

## 1. Goal

Convert the already-approved `E+D HYBRID · NEO-ARCADE READABILITY` direction into a production-facing asset contract that can be implemented without reopening art direction questions.

This spec does **not** generate new images, promote candidate bytes, or integrate anything into Godot runtime. It defines what must exist, how states must be split, how files are named, and what qualifies for promotion.

## 2. Visual synthesis

### E contribution

- premium cel-shaded depth;
- dark navy / metal framing;
- controlled neon rim/highlight accents;
- reward and success moments with energetic polish;
- contemporary, collectible-feeling finish.

### D contribution

- bold, simple silhouettes;
- high-contrast directional information;
- large touch-friendly state changes;
- fast board parsing;
- minimal dependence on text.

### Combined rule

If E polish reduces puzzle readability, D readability wins. If D simplification makes the product look generic or flat, add E polish only where it does not compete with gameplay information.

## 3. Core proportions

### Locomotive

The blue locomotive is the hero anchor of the moving train silhouette.

### Cargo wagons

Trailing cargo wagons are deliberately smaller than the locomotive.

- initial visual-footprint target: **70–75% of locomotive**;
- collision/logic footprint: unchanged by this art ratio;
- coupling and order must remain obvious;
- color + shape identity must survive 16:9 Android-scale presentation;
- TOP/recent cargo representation takes precedence over rendering every stored item.

If a 70–75% wagon loses clarity, increase it only enough to restore legibility while keeping a clearly subordinate hierarchy.

## 4. Palette and material hierarchy

- background/frame: dark navy, low-noise premium arcade shell;
- board/world: warmer miniature-railway surfaces so playable geometry separates from UI chrome;
- locomotive: blue primary anchor;
- cargo/station semantics: red / blue / yellow with shape redundancy;
- selected/valid: brighter edge + shape/marker reinforcement;
- invalid/locked: desaturation/darkening plus explicit icon/shape reinforcement;
- ghost route: lower-opacity and lower-energy than committed rail.

Avoid full-screen neon saturation and heavy bloom. Accent energy is reserved for direction, selection, pickup/unload, combo, success, and critical state changes.

## 5. Asset architecture

Future promoted root:

`art/product_assets/ed_hybrid_v1/`

Families:

1. `core/`
2. `run/`
3. `build/`
4. `ui/`
5. `vfx/`
6. `shells/`
7. `meta/`

Candidate source remains:

`art/production_candidates/ed_hybrid_v1/`

Promotion never deletes the candidate source or its provenance.

## 6. Naming contract

Use lowercase snake_case:

`<family>_<object>_<variant>_<state>_vNN.png`

Examples:

- `core_train_locomotive_blue_normal_v01.png`
- `core_wagon_cargo_red_normal_v02.png`
- `run_switch_arrow_left_selected_v01.png`
- `build_track_straight_invalid_ghost_v01.png`
- `ui_button_frame_square_blue_pressed_v01.png`

Rules:

- one semantic state per exported file unless a state atlas is explicitly required;
- localized text must not be baked into PNGs;
- state atlases require documented slice bounds;
- alpha-backed gameplay assets use transparent backgrounds;
- version increments only when pixels or slice contract change.

## 7. Required state model

### Core world

Locomotive:
- normal;
- selected/highlight if needed by runtime interaction;
- disabled only if a product screen genuinely requires it.

Cargo wagons:
- red/blue/yellow normal;
- selected/TOP emphasis should be an overlay or HUD state when possible rather than separate wagon art.

Cargo stars:
- red/blue/yellow normal;
- pickup feedback is VFX, not a permanent world-state sprite;
- collected cargo disappears from runtime world state.

Stations:
- red/blue/yellow base;
- active match highlight;
- non-match remains readable without looking disabled.

Rails:
- straight;
- curve;
- crossing;
- three-way switch;
- selected path;
- inactive path;
- occupied lock;
- build ghost valid/invalid are BUILD-family assets, not committed-rail replacements.

### RUN/LIFO

- stack empty;
- TOP highlight;
- next-unload-group highlight;
- 32+ / `+N` compression;
- unloading;
- switch direction selected;
- switch occupied lock;
- load mode off/on/processing if asynchronous feedback exists;
- combo static equivalent for Reduced Motion.

### BUILD

- placement normal;
- valid ghost;
- invalid ghost;
- selected/editing;
- rotate affordance;
- remove affordance;
- ghost-route hidden/shown;
- cost under/equal/over optional star/leaderboard threshold without implying general clear failure;
- preflight ready/warning/blocking.

### Controls

Every primary reusable button frame must support:

- normal;
- hover;
- pressed;
- selected;
- disabled;
- locked;
- keyboard/gamepad focus.

### VFX / feedback

Provide animated/runtime-ready source or static frames for:

- cargo pickup;
- cargo unload;
- combo;
- route selection;
- success;
- failure;
- `ROUTE_END`;
- `TIME_EXPIRED`;
- Reduced Motion equivalents.

No effect may obscure the next critical input target.

### Shell / meta

Text-safe shells are required for:

- stage briefing;
- pause;
- exit confirm;
- success result;
- failure result;
- retry/edit/title actions;
- stage select;
- chapter/progress card;
- 0/1/2/3-star states;
- locked/new/best states;
- archive/leaderboard gate primitives where already allowed by product decisions.

## 8. Promotion decisions

Each `SX-DEC-051` candidate receives exactly one disposition:

- `PROMOTE_AS_IS`;
- `PROMOTE_AFTER_REVISION`;
- `REPLACE`.

Recommended first-pass default:

- locomotive: `PROMOTE_AFTER_REVISION` only if hero silhouette/blue anchor needs final polish;
- cargo wagons: `PROMOTE_AFTER_REVISION` to enforce smaller visual hierarchy;
- cargo stars/stations/rails: inspect for `PROMOTE_AS_IS` first;
- state atlases: split when runtime reuse or localization benefits from independent files;
- shells/meta: retain blank text-safe structure, revise decorative framing only when necessary.

## 9. Acceptance checks before product promotion

Static/art checks:

- locomotive remains dominant at gameplay scale;
- wagon is visibly smaller but still legible;
- red/blue/yellow identity works in grayscale-assisted shape review;
- switch selected/inactive/locked states can be distinguished without relying on hue alone;
- ghost rail is weaker than committed rail;
- button states remain distinguishable at target touch size;
- text-safe shells have sufficient expansion room for localization;
- VFX does not cover the next branch/cargo interaction area.

Runtime checks are explicitly later gates and are not passed by this spec.

## 10. Error handling / fallback

If an existing candidate fails a promotion check:

1. keep the candidate unchanged for provenance;
2. mark it `PROMOTE_AFTER_REVISION` or `REPLACE`;
3. create a new versioned file rather than silently overwriting the approved candidate;
4. update the future product manifest with origin candidate path and disposition;
5. do not change gameplay/domain rules to make art easier to fit.

## 11. Testing strategy

Implementation should add a focused static contract that verifies:

- required promoted roles exist;
- filenames follow the naming contract;
- transparent assets actually contain alpha-capable PNG data;
- promoted wagon dimensions/declared visual scale stay below the locomotive target hierarchy;
- controls expose all seven required states;
- shells remain text-safe and contain no baked localized copy metadata;
- product manifest records source candidate + disposition + Decision ID.

Existing Contract/GUT/Godot/Pilot workflows remain regression gates. Physical/runtime/device/human gates remain separate.

## 12. Non-goals

This spec does not:

- generate another concept board;
- change game mechanics;
- integrate sprites into scenes;
- edit Theme/Animation/Resource/signal structure;
- run a POC;
- claim device or human validation;
- delete `.asset-vault` legacy files.
