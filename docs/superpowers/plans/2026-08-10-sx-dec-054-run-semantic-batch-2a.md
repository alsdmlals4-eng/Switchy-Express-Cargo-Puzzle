# SX-DEC-054 RUN Semantic Batch 2A Implementation Plan

> **Execution:** Inline under the user's `[연속작업]` authorization. Follow TDD: plan → RED contract → GREEN minimum asset package → exact-head CI → merge → same-ID canonical/Sheet closure.

**Decision:** `SX-DEC-054`  
**Baseline main:** `bf0146bf51eb6b7a54d1ac219b021a6a41225c4c`  
**Branch:** `agent/sx-dec-054-run-semantic-batch-2a`  
**Visual authority:** `SX-DEC-053`  
**Component authority:** `SX-DEC-050`  
**Runtime integration:** forbidden in this batch

## Goal

Make the approved RUN semantic states implementation-ready without guessing any unnamed `SX-DEC-051` atlas region and without changing gameplay or Godot runtime surfaces.

Batch 2A covers:

1. remaining Stack HUD states;
2. train cargo strip semantics;
3. load-mode semantics;
4. switch presentation semantics while preserving the existing procedural direction authority.

## Architecture

### Preserve SX-DEC-053 ownership

Keep `art/product_assets/ed_hybrid_v1/manifest.json` owned by `SX-DEC-053` with its current 39 assets and 31-source disposition ledger unchanged.

Create a sidecar:

`art/product_assets/ed_hybrid_v1/semantic_manifest_sx_dec_054.json`

The sidecar owns only `SX-DEC-054` semantic assets and composition records. It must declare:

- `decision_id: SX-DEC-054`;
- `source_visual_authority: SX-DEC-053`;
- `source_component_authority: SX-DEC-050`;
- `batch: RUN_2A`;
- `runtime_integrated: false`;
- `baseline_sx_dec_053_asset_count: 39`;
- preserved ambiguous atlas paths;
- semantic assets;
- semantic compositions;
- complete required state sets.

The existing 39 product paths may be referenced as inputs but must not be duplicated into 054 ownership.

### Validator coexistence

`tools/validate_final_ed_product_asset_promotion.py` currently rejects every PNG under the product root that is not in the SX-DEC-053 manifest. Extend only this ownership boundary:

- if the 054 sidecar exists, load its physical semantic PNG paths;
- require no overlap with the SX-DEC-053 39 paths;
- compare SX-DEC-053 physical ownership against `all_product_pngs - sx_dec_054_owned_pngs`;
- do not change any SX-DEC-053 disposition, recovery, crop, scale, integrity, or runtime checks.

A new focused validator owns all 054 semantics:

`tools/validate_sx_dec_054_run_semantic_assets.py`

Focused test:

`tests/python/test_sx_dec_054_run_semantic_assets.py`

## Required semantic coverage

### Stack HUD — physical semantic assets

Keep existing SX-DEC-053 inputs:

- `run_stack_empty_v01.png`;
- `run_stack_32plus_v01.png`;
- `run_stack_unloading_v01.png`;
- `run_stack_top_highlight_v01.png`.

Add independent SX-DEC-054 product assets:

- `run/run_stack_compact_v01.png`;
- `run/run_stack_8plus_v01.png`;
- `run/run_stack_16plus_v01.png`;
- `run/run_stack_unload_group_v01.png`;
- `run/run_stack_paused_v01.png`.

`unload_group` is a predicted contiguous-TOP-group boundary/highlight. It must not reuse, alias, or claim derivation from `run_stack_unloading_v01`.

### Train cargo strip — reusable physical primitives + compositions

Physical primitives:

- `run/run_train_cargo_strip_shell_v01.png`;
- `run/run_train_cargo_strip_plus_badge_v01.png`;
- `run/run_train_cargo_strip_unload_transition_v01.png`.

Composition states:

- `empty`;
- `tokens_1_3`;
- `compressed_plus_n`;
- `unload_transition`.

Composition inputs may reference current red/blue/yellow cargo product assets and the approved 0.74 wagon hierarchy. The `+N` value remains runtime text/data; no fixed number is baked into the PNG.

### Load mode — reusable semantic primitives + compositions

Physical primitives:

- `run/run_load_mode_shell_v01.png`;
- `run/run_load_mode_manual_marker_v01.png`;
- `run/run_load_mode_auto_marker_v01.png`;
- `run/run_load_mode_held_marker_v01.png`;
- `run/run_load_mode_off_marker_v01.png`;
- `run/run_load_mode_on_marker_v01.png`;
- `run/run_load_mode_disabled_overlay_v01.png`;
- `run/run_load_mode_input_received_v01.png`.

Composition states:

- `manual_idle`;
- `manual_held`;
- `auto_off`;
- `auto_on`;
- `paused_disabled`;
- `input_received`.

Each state communicates through icon/shape plus value, not color alone. None may cite `run_load_mode_states_v01.png` as pixel/crop authority.

### Switch direction — style primitives + procedural-authority compositions

Do not create directional arrow geometry in Batch 2A. Direction geometry remains owned by the current `SX-DEC-042` / `SX-DEC-046` procedural switch authority (`RouteControlOverlay` / VIS-014 behavior). This avoids inventing a second direction coordinate system or silently rotating/mirroring historical atlas pixels.

Physical state-style primitives:

- `run/run_switch_state_selected_overlay_v01.png`;
- `run/run_switch_state_unselected_overlay_v01.png`;
- `run/run_switch_state_occupied_locked_overlay_v01.png`;
- `run/run_switch_state_inactive_overlay_v01.png`.

Composition states:

- `three_visible`;
- `selected`;
- `unselected`;
- `occupied_locked`;
- `inactive`.

The sidecar records `procedural_direction_authority: SX-DEC-042 · SX-DEC-046 · VIS-014` rather than a guessed atlas source.

## Visual generation rules

All new PNGs are deterministic independent semantic assets, not crops of ambiguous atlases.

- transparent RGBA PNGs;
- E+D / Neo-Arcade palette: dark navy shell, controlled blue/cyan accents, warm warning/lock accents only where semantically appropriate;
- state changes use shape/line weight/fill/marker changes, never hue alone;
- no localized text baked into PNGs;
- `+N` uses an empty badge/plus marker; actual N is runtime data;
- Stack `unload_group` uses a bounded/group boundary visual, not event-motion streaks;
- paused/disabled use shape/line treatment in addition to desaturation;
- all semantic assets remain `runtime_integrated: false`.

## Task 1 — Commit plan

Files:
- create this plan only.

Acceptance:
- branch is exactly based on `bf0146bf51eb6b7a54d1ac219b021a6a41225c4c`;
- no implementation files changed yet.

## Task 2 — TDD RED contract

Files:
- create `tests/python/test_sx_dec_054_run_semantic_assets.py`;
- create `tools/validate_sx_dec_054_run_semantic_assets.py`;
- modify `tools/validate_final_ed_product_asset_promotion.py` only for sidecar ownership partitioning.

RED expectations before assets/sidecar exist:

- focused 054 test fails because the sidecar is absent;
- existing 053 validation continues to treat the baseline 39 paths as valid and does not weaken its existing checks;
- failure must be a semantic-package missing/coverage failure, not a Python syntax/import failure.

Commit the RED state and retain its exact head/workflow evidence as TDD history.

## Task 3 — GREEN semantic package

Files:
- create `art/product_assets/ed_hybrid_v1/semantic_manifest_sx_dec_054.json`;
- create 20 RUN semantic PNG primitives listed above;
- update product README/list documentation only as needed for ownership and usage boundary.

Manifest contract:

- exactly 20 physical 054 PNGs for Batch 2A;
- all 20 have `decision_id: SX-DEC-054`, explicit role/state or primitive role, dimensions, transparent=true, `runtime_integrated=false`, and `derivation.kind=independent_semantic_asset`;
- all required semantic states have either a physical asset or a complete composition record;
- composition inputs exist and are owned by either SX-DEC-053 or SX-DEC-054;
- ambiguous atlas list includes at least train cargo strip, load mode, switch direction atlases and explicitly says `PRESERVE_REFERENCE_ONLY_NO_STATE_MAPPING`;
- no sidecar asset path overlaps the SX-DEC-053 39 paths.

Focused validator checks:

- JSON authority fields;
- exact required state sets;
- unique physical paths;
- PNG signature/chunk CRC/IDAT decode/dimensions/alpha;
- filename/path convention;
- manifest↔physical 054 PNG agreement;
- ownership disjointness from 053;
- no ambiguous atlas path appears as a pixel source/crop authority;
- all referenced composition inputs exist;
- switch states cite procedural authority instead of new direction geometry;
- `runtime_integrated=false` globally and per asset;
- baseline SX-DEC-053 count remains 39.

## Task 4 — Documentation and decision status

Before implementation merge, update:

- `docs/decisions/SX_DEC_054_SEMANTIC_ASSET_COMPLETION_STRATEGY.md` to `RUN_BATCH_2A_IMPLEMENTED_VALIDATION_PENDING`;
- `기획서/40_표현/FINAL_PRODUCT_ASSET_LIST_V1.md` with separate ownership counts (`SX-DEC-053=39`, `SX-DEC-054 RUN 2A=20`), without claiming runtime integration;
- a focused audit owner under `기획서/50_제작_검증/` using a new **Audit ID only if needed for audit evidence**, never a replacement Decision ID. If an existing same-scope audit exists, extend it instead.

Do not prematurely rewrite physical/device/human gates.

## Task 5 — Exact-head PR validation

Open a PR from `agent/sx-dec-054-run-semantic-batch-2a` to `main`.

Before merge verify:

- compare baseline/main and changed-file scope;
- focused validator/test PASS;
- Project Contract PASS;
- GUT PASS;
- Godot PASS;
- Thin PASS;
- Windows Demo Export PASS if triggered;
- unresolved review threads = 0;
- PR mergeable and exact review head unchanged;
- no gameplay/domain, `.tscn`, `project.godot`, Resource/Theme/Animation/signal, plugin, or `.asset-vault` byte changes.

Use expected-head protection for squash merge.

Hosted Windows export is packaging evidence only, not physical runtime evidence.

## Task 6 — Same-ID merged-main closure

After product merge:

1. read back main;
2. update `SX-DEC-054` owner doc with exact PR-head CI and merge/main SHA;
3. update `CURRENT_CONFIRMED_DECISIONS.md` only if needed so it does not drift behind the merged 054 state;
4. use a docs-only closure PR if required by the established project pattern;
5. update Google Sheet `02_현재_확정결정` same row/ID `SX-DEC-054` with final merge evidence;
6. update relevant visual/audit Sheet cells only where current state actually changed;
7. read back exact Sheet cells and GitHub main.

Final Batch 2A state must still say runtime/Windows physical/Android device/connected editor/human NOT_RUN.

## Verification commands / CI intent

Focused local-equivalent commands represented by repository CI:

```bash
python tools/validate_sx_dec_054_run_semantic_assets.py
python -m pytest -q tests/python/test_sx_dec_054_run_semantic_assets.py
python tools/validate_final_ed_product_asset_promotion.py
```

Repository-wide exact-head workflows remain authoritative where available.

## Non-goals

- no Batch 2B BUILD assets;
- no Batch 2C VFX assets;
- no Godot hookup/POC;
- no gameplay/domain change;
- no runtime screenshot claim;
- no Windows physical runtime;
- no Android device validation;
- no connected editor validation;
- no human/playtest validation;
- no `.asset-vault` cleanup;
- no release cutover.
