# SX-DEC-055 · Runtime Semantic POC

**Status:** `USER_APPROVED · SPEC_APPROVED · IMPLEMENTATION_NOT_STARTED`  
**Date:** 2026-08-10 KST  
**Approval reference:** `USER_APPROVAL_2026-08-10_RUNTIME_POC · USER_SPEC_APPROVAL_2026-08-10`  
**Baseline main:** `bcbd98c7e39b10146b22389bebe81a8b7a0a7b13`  
**Source semantic authority:** `SX-DEC-054`  
**Source visual authority:** `SX-DEC-053`  
**Source component authority:** `SX-DEC-050`  
**Godot authoring boundary:** `SX-DEC-045`

## Decision

Authorize a bounded Godot runtime proof of concept that connects the approved semantic product assets to the existing finite-demo presentation seams without changing core gameplay/domain rules.

The POC proves the runtime architecture and a representative end-to-end binding across RUN, BUILD, route control, and causal VFX. It does **not** require every one of the 73 physical product PNGs to replace every current procedural/text presentation in one batch.

## Selected architecture

Use a thin presentation-only integration:

```text
SX-DEC-053/054 product manifests
→ SemanticAssetCatalog
→ existing presenter model / render snapshot / existing events
→ HUD + board + route + event presentation adapters
→ runtime visual state
```

The domain layer must not know PNG paths, manifest keys, animation timing, or Reduced Motion policy.

### Runtime catalog

Add one manifest-backed runtime catalog that resolves the existing `SX-DEC-054` RUN/BUILD/VFX sidecars plus exact reused `SX-DEC-053` product inputs referenced by those sidecars.

The catalog is presentation infrastructure only. It does not create new product semantics or rewrite manifests.

### RUN POC

Use existing finite presentation data to prove:

- Stack semantic state selection from `stack_tokens`, phase, and unload-visual state;
- manual-load held state from the existing `FiniteGameplayInputState.is_manual_load_active()` read seam;
- auto-load on/off and paused-disabled presentation from existing input/run state;
- switch selected/unselected/occupied-locked state markers while `RouteControlOverlay` remains the sole procedural direction-geometry/click-target authority.

No switch exit, cycle, lock, or U-turn rule changes are authorized.

### BUILD POC

Use existing build snapshot/preflight data to prove:

- placement preview semantic reinforcement for valid/invalid and rotation/replacement when the existing snapshot can distinguish them;
- preflight clear/issue/focused-location presentation from existing `start_enabled`, `primary_reason`, and `problem_cells` data;
- committed track geometry remains procedural and authoritative.

The full 4-form × 5-interaction palette skin is not required for this POC; it remains a later integration expansion after the architecture is proven.

### VFX POC

Use only existing presentation seams:

- cargo pickup/unload from `delivery_event_created`;
- route-selection feedback from an accepted existing route-selection request;
- success / route-end / time-expired from the existing terminal summary;
- generic failure only where an existing outcome has no more-specific approved failure event.

`combo` must be catalog-resolvable but is **not** allowed to gain a new gameplay/domain signal just to make the POC fire it. The current finite delivery event does not carry combo data. If no existing presentation-readable combo seam is found during implementation, record `RUNTIME_TRIGGER_DEFERRED_NO_EXISTING_SEAM` and leave the trigger for a later separately reviewed integration step.

### Reduced Motion POC

The event presenter must expose a presentation-only Reduced Motion mode:

- standard mode may use a short presentation tween bounded by the existing `<= 1.0s` effects ceiling;
- Reduced Motion mode shows the same information-bearing product input without spatial/scale motion;
- both modes share the same semantic event key and product input;
- a settings/menu UI for the preference is outside this POC. A programmatic/test seam is sufficient to prove behavior.

Reduced Motion may change motion, never event meaning.

## Existing code seams confirmed at approval time

- `game/demo/product_finite_slice.gd`: controller model → HUD, render snapshot → board/route overlay, delivery/terminal event → effects/audio;
- `game/finite/presentation/finite_slice_presenter.gd`: authoritative finite presentation model including stack, auto, preflight/problem data;
- `game/finite/input/finite_gameplay_input_state.gd`: manual/auto/paused read seams;
- `game/demo/presentation/product_board_renderer.gd`: build ghost, selected cell, problem-cell overlays;
- `game/demo/presentation/route_control_overlay.gd`: procedural switch directions, selected/locked state, click targets;
- `game/demo/presentation/demo_effects.gd`: bounded presentation tweens;
- `game/demo/presentation/product_hud.gd`: finite HUD consumer.

These are implementation seams, not new product authorities.

## Proof-of-concept acceptance contract

Automated tests must prove at minimum:

1. runtime catalog resolves the approved semantic manifests and referenced textures without changing manifest ownership;
2. representative RUN semantic states select the expected approved product input;
3. manual/auto/paused load visuals read actual input state rather than UI-local guesses;
4. BUILD preview/preflight semantic selection uses existing snapshot/model data only;
5. switch semantic adornment does not change direction targets, cycle counts, lock behavior, or procedural arrow geometry authority;
6. supported existing VFX seams map to the approved event keys;
7. standard and Reduced Motion modes preserve the same information asset/key;
8. effect duration remains within the current 1-second ceiling;
9. no new gameplay/domain rule, save/ruleset identity, map data, product asset byte, or `.asset-vault` byte changes;
10. existing Project Contract / GUT / Godot / Thin / Windows-export gates pass on the exact implementation PR head when applicable.

Hosted Windows export remains package/build evidence only.

## Definition of Ready for implementation

Actual Godot/GDScript implementation may start only after:

- this decision and its written design spec are reviewed and explicitly approved by the user;
- the docs/spec PR is merged to `main`;
- the configured Google Sheet contains the same `SX-DEC-055` ID and merged spec status;
- project main/open-PR/Base/Sheet state is reread with no unresolved authority conflict;
- an implementation plan names exact code/test files and starts with RED tests.

Per project `AGENTS.md`, actual Godot/GDScript code/test modification is a Codex execution responsibility after this DoR is satisfied.

## Non-goals

This POC does not authorize:

- new gameplay/domain signals solely for visual effects;
- changes to LIFO, route control, cargo pickup/unload, failure priority, scoring, time limits, or map rules;
- a new settings screen or persisted accessibility preference;
- full replacement of all procedural visuals;
- new product PNG creation or atlas reinterpretation;
- Windows physical runtime PASS;
- Android device PASS;
- connected physical editor PASS;
- human comprehension/playtest PASS;
- `.asset-vault` cleanup;
- release cutover.

## Exit condition

The POC is complete when a reviewed exact-head implementation demonstrates manifest-backed semantic runtime presentation through the existing finite-demo seams, preserves all gameplay contracts, passes automated regression gates, and is merged-main verified with same-ID Sheet reconciliation.

Physical/device/human gates remain separate afterward.
