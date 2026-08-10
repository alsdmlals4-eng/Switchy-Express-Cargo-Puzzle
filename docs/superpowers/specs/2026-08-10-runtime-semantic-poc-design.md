# Runtime Semantic POC — Design Spec

**Decision:** `SX-DEC-055`  
**Date:** 2026-08-10 KST  
**Baseline main:** `bcbd98c7e39b10146b22389bebe81a8b7a0a7b13`  
**Approved boundary:** `RUNTIME_SEMANTIC_POC_ONLY`

## 1. Goal

Prove that the completed `SX-DEC-054` semantic product package can be consumed by the current Godot finite-demo runtime through thin presentation adapters, without moving product meaning into Godot UI code or changing finite-puzzle gameplay.

The POC is intentionally representative rather than exhaustive. It must establish a safe architecture for later full runtime integration while producing visible end-to-end evidence in RUN, BUILD, route control, and causal feedback.

## 2. Current runtime architecture

Live code inspection establishes these seams:

```text
FiniteSliceSessionController
├─ presenter model ───────→ ProductHUD
├─ render snapshot ───────→ ProductBoardRenderer
│                         └→ RouteControlOverlay
├─ delivery event ────────→ ProductFiniteSlice → DemoEffects / audio
└─ terminal summary ──────→ ProductFiniteSlice → DemoEffects / result flow
```

Relevant existing files:

- `game/demo/product_finite_slice.gd`
- `game/demo/product_finite_slice.tscn`
- `game/demo/presentation/product_hud.gd`
- `game/demo/presentation/product_hud.tscn`
- `game/demo/presentation/product_board_renderer.gd`
- `game/demo/presentation/route_control_overlay.gd`
- `game/demo/presentation/demo_effects.gd`
- `game/finite/main/finite_slice_session_controller.gd`
- `game/finite/presentation/finite_slice_presenter.gd`
- `game/finite/input/finite_gameplay_input_state.gd`

The POC must extend these presentation seams rather than bypass them.

## 3. Approach comparison

### Approach A — manifest-backed thin presentation adapters

**Selected.** Add one semantic asset catalog and small adapters at the existing HUD/board/route/effect seams.

Advantages:
- preserves domain/presentation separation;
- keeps `SX-DEC-054` manifests as semantic source;
- enables deterministic tests of state → asset selection;
- allows incremental integration after the POC.

Trade-off:
- adds a small runtime catalog and a few presentation nodes/helpers.

### Approach B — hardcode PNG paths directly in each UI script

Rejected. Fast initially, but duplicates semantic authority across HUD/renderer/effects and makes manifest drift likely.

### Approach C — replace the current demo presentation wholesale

Rejected. It would mix architecture migration, asset integration, input behavior, layout work, and visual polish in one risky batch.

## 4. Runtime catalog

Introduce a presentation-only `SemanticAssetCatalog` under the demo/presentation layer or another existing presentation-owned path selected by the implementation plan.

Responsibilities:

- read the approved `SX-DEC-054` RUN/BUILD/VFX sidecars;
- resolve exact product paths referenced by those records, including approved reuse inputs owned by `SX-DEC-053`;
- expose semantic lookup by stable family/role/state/event keys;
- return null/explicit failure for an unknown key rather than silently substituting a different semantic state;
- never edit or reinterpret manifests at runtime.

The catalog is not a gameplay service and is never called by domain classes.

## 5. Presentation-state mapping

### 5.1 RUN Stack

Derive the visible stack state from existing presentation data only:

- empty → no `stack_tokens`;
- paused → phase `PAUSED`;
- unloading → existing `unload_visual_active`/`UNLOADING` seam;
- compact / 8plus / 16plus → stack-token count thresholds already encoded in approved semantic assets;
- predicted unload-group highlight → contiguous same-cargo run from TOP computed from the presentation token list, never from a new gameplay rule.

The computation is descriptive of the already-visible LIFO stack. It does not alter unload eligibility.

### 5.2 Load mode

Read real state:

- manual held → `FiniteGameplayInputState.is_manual_load_active()`;
- auto on/off → `is_auto_load_enabled()`;
- paused disabled → phase/input paused state;
- manual idle → enabled and not held;
- input-received feedback may be driven by an already accepted input command only.

If the current presenter model lacks a read-only field needed by the HUD, add the minimum presentation field from the existing input-state getter. Do not create duplicate UI-owned truth.

### 5.3 Switch presentation

`RouteControlOverlay` keeps ownership of:

- available reciprocal directions;
- selected direction;
- occupied lock;
- cycle count;
- hit target geometry;
- procedural arrow drawing.

Semantic product art may reinforce selected/unselected/locked/inactive state but may not replace or transform the direction vectors. Tests must compare direction-target descriptors before and after the visual integration.

### 5.4 BUILD placement and preflight

Use existing render/model inputs:

- selected geometry;
- selected rotation;
- hover cell;
- buildable/blocked cells;
- selected cell;
- `problem_cells`;
- `start_enabled` / `primary_reason`.

POC bindings:

- valid placement reinforcement;
- invalid placement reinforcement;
- rotation/replacement preview when the existing state already distinguishes the case;
- preflight clear vs primary issue;
- focused issue location from the existing problem-cell list.

Full palette skinning remains outside this POC.

## 6. Event feedback and Reduced Motion

Add a presentation-owned semantic event overlay/presenter rather than teaching domain events about textures.

Existing trigger seams in POC scope:

- cargo pickup → `delivery_event_created` with `picked_up=true`;
- cargo unload → `delivery_event_created` with `unload_count > 0`;
- route selection → accepted route-selection request already produced by `RouteControlOverlay`;
- success → terminal summary outcome `SUCCESS`;
- route end → terminal failure reason `ROUTE_END`;
- time expired → terminal failure reason `TIME_EXPIRED`;
- generic failure → only when a terminal failure has no more-specific approved event mapping.

### Combo boundary

The current finite delivery event contains pickup/unload/stack data but no combo field. The POC must not modify domain gameplay just to emit combo feedback.

Required behavior:

- combo semantic asset resolves through the catalog;
- if implementation inspection finds an already-existing presentation-readable combo source, it may be consumed;
- otherwise the POC records `RUNTIME_TRIGGER_DEFERRED_NO_EXISTING_SEAM` and leaves combo runtime triggering for a later separately reviewed integration step.

### Reduced Motion

The event presenter exposes a presentation-only mode switch for automated proof:

- standard: same semantic asset plus short optional tween;
- reduced: same semantic asset/key, no spatial/scale motion;
- both modes retain equivalent visibility and event identity;
- standard motion duration never exceeds the existing `DemoEffects.MAX_EFFECT_DURATION = 1.0` ceiling.

No user settings screen or persisted preference is added in this POC.

## 7. Scene ownership

The POC may add minimal presentation nodes to `product_finite_slice.tscn` and `product_hud.tscn` only when required by the approved adapter design.

Examples:

- TextureRect/badge nodes owned by `ProductHUD`;
- a semantic event overlay owned by `ProductFiniteSlice` presentation;
- no domain scene ownership changes.

Scene/Resource/Theme/Animation/signal authoring must remain inside the single Godot authoring boundary of `SX-DEC-045` and the implementation plan must enumerate every authored scene/resource change.

## 8. Failure behavior

Runtime semantic presentation must fail soft without inventing meaning:

1. unknown semantic key → do not substitute a semantically different texture;
2. missing texture/resource → retain the existing procedural/text presentation and expose a deterministic test/debug failure path;
3. malformed sidecar → catalog initialization fails explicitly in tests; gameplay remains independent;
4. missing optional POC trigger seam (for example combo) → record deferred trigger, do not add domain behavior;
5. Reduced Motion toggle failure → default to static information-preserving presentation, not motion-only feedback.

Existing Korean text and procedural readability stay available during the POC as fallback/redundancy.

## 9. Testing strategy

Implementation follows RED → GREEN.

### RED first

Add focused tests before runtime catalog/presentation support exists, covering:

- catalog lookup of approved manifest keys;
- HUD state-to-semantic-key mapping;
- actual manual/auto/paused input-state projection;
- BUILD preview/preflight state mapping;
- switch direction-target invariance;
- VFX event mapping;
- Reduced Motion information-key equivalence;
- fallback on missing/unknown semantic key.

### GREEN

Add the minimum catalog/adapters/nodes to satisfy those contracts.

### Regression gate

Run on the unchanged final PR head when applicable:

- Project Contract;
- GUT 9.7.1;
- Godot Tests including live-editor Pilot where triggered;
- Validate Thin Adapter Migration;
- Windows Demo Export.

Windows export is packaging evidence only, not physical runtime PASS.

## 10. Expected implementation surfaces

The implementation plan must verify exact files before editing. Based on current live code, likely surfaces are:

- new presentation catalog/helper under `game/demo/presentation/`;
- `game/finite/presentation/finite_slice_presenter.gd` only for additional read-only presentation fields if needed;
- `game/finite/main/finite_slice_session_controller.gd` only to pass existing read state into the presenter;
- `game/demo/presentation/product_hud.gd` and `.tscn`;
- `game/demo/presentation/product_board_renderer.gd`;
- `game/demo/presentation/route_control_overlay.gd`;
- `game/demo/presentation/demo_effects.gd` or a new semantic event overlay;
- `game/demo/product_finite_slice.gd` and `.tscn` for presentation wiring;
- focused tests under `tests/demo/` and/or `tests/finite/presentation/`.

No file is authorized merely because it appears in this list; the implementation plan must re-read current main and justify each edit.

## 11. Definition of Ready

Implementation DoR is satisfied only when all are true:

1. `SX-DEC-055` user runtime-POC approval is recorded;
2. this written spec is explicitly approved by the user;
3. decision + spec PR is merged to current `main`;
4. same `SX-DEC-055` ID is synchronized to the configured Google Sheet;
5. Base/project/Sheet authority refresh shows no conflict;
6. implementation plan identifies exact current files and RED tests;
7. project `AGENTS.md` role boundary is respected: Godot/GDScript code/test implementation executes through Codex after DoR.

## 12. Non-goals

- no core gameplay changes;
- no new product semantics;
- no new product PNGs;
- no atlas reinterpretation;
- no full 73-asset visual replacement requirement;
- no persisted accessibility/settings UI;
- no audio redesign;
- no save/ruleset migration;
- no Windows physical, Android device, connected editor, or human PASS claim;
- no `.asset-vault` untrack;
- no release cutover.

## 13. POC success condition

The POC succeeds when the merged finite demo visibly and deterministically consumes approved semantic product assets through existing presentation seams for representative RUN, BUILD, route, and VFX states; automated tests prove no gameplay contract changed; Reduced Motion preserves information; and unresolved unsupported triggers are explicitly deferred rather than invented.