# SX-DEC-054 VFX Semantic Batch 2C Implementation Plan

**Goal:** Complete the already-approved causal feedback semantics for cargo pickup, cargo unload, combo, route selection, success, failure, ROUTE_END, and TIME_EXPIRED while preserving a static Reduced Motion information-equivalent for every event and keeping runtime integration deferred.

**Baseline main:** `251ab46f757bd6741e5b1ea3f937fcd58ac18bb0`

## Architecture

- Keep existing ownership unchanged: `SX-DEC-053=39`, RUN 2A=`20`, BUILD 2B=`8`.
- Add a dedicated sidecar: `art/product_assets/ed_hybrid_v1/semantic_manifest_sx_dec_054_vfx_2c.json`.
- Preserve `art/production_candidates/ed_hybrid_v1/vfx/vfx_feedback_static_states_v01.png` as `PRESERVE_REFERENCE_ONLY_NO_STATE_MAPPING`; it has no authoritative named slices.
- Reuse existing information-bearing products when exact meaning already exists:
  - `combo` → `art/product_assets/ed_hybrid_v1/run/run_combo_feedback_static_v01.png`;
  - `route_selection` → `art/product_assets/ed_hybrid_v1/run/run_switch_state_selected_overlay_v01.png`.
- Author exactly six new text-free alpha PNG event glyphs:
  - `vfx_cargo_pickup_feedback_v01.png`;
  - `vfx_cargo_unload_feedback_v01.png`;
  - `vfx_success_feedback_v01.png`;
  - `vfx_failure_feedback_v01.png`;
  - `vfx_route_end_feedback_v01.png`;
  - `vfx_time_expired_feedback_v01.png`.
- Define exactly 16 semantic compositions: 8 events × (`standard`, `reduced_motion`). Standard and Reduced Motion variants share the same information-bearing input; runtime may later animate the standard form, but this batch authors no Animation/Scene/Resource/runtime wiring.
- Every composition carries `occlusion_policy: DO_NOT_COVER_NEXT_CRITICAL_BRANCH_OR_CARGO_TARGET`, `mute_independent: true`, and `runtime_integrated:false`.
- Expected product-root total after merge: `39 + 20 + 8 + 6 = 73` physical PNGs.

## TDD sequence

1. **RED contract**
   - Create `tests/python/test_sx_dec_054_vfx_semantic_assets.py` first.
   - Require the VFX sidecar, focused validator, exact event/mode coverage, Reduced Motion pair contract, and six new physical assets.
   - Open draft PR while RED is intentional and verify Python-contract failure is feature absence.

2. **Focused validator**
   - Create `tools/validate_sx_dec_054_vfx_semantic_assets.py`.
   - Validate decision/source authority, exact 8 event names, exact 16 compositions, six unique VFX-owned PNGs, atlas reference-only policy, no crop authority, PNG signature/chunk CRC/IDAT/dimensions/alpha/SHA-256, exact reuse inputs for combo/route_selection, and paired standard/reduced information identity.
   - Reject any composition without the exact occlusion/mute/runtime boundary.

3. **Atomic GREEN package**
   - Generate six deterministic RGBA glyphs using approved E+D shape/palette language; no localized copy.
   - Attach six PNG blobs + VFX sidecar atomically.
   - Standard/reduced pairs must share the same event `information_key` and primary input; Reduced Motion uses static information only.

4. **Shared product ownership**
   - Extend `tools/validate_final_ed_product_asset_promotion.py` to include the VFX sidecar in the explicit 054 ownership union.
   - Extend `tests/python/test_final_ed_product_asset_promotion.py` to require exact unique/disjoint counts `39/20/8/6` and total physical root `73`.
   - Do not weaken any existing 053 recovery/disposition/crop/scale/CRC/zlib/runtime contract.

5. **Canonical docs/audit**
   - Update `docs/decisions/SX_DEC_054_SEMANTIC_ASSET_COMPLETION_STRATEGY.md` and `기획서/40_표현/FINAL_PRODUCT_ASSET_LIST_V1.md`.
   - Confirm `SX-AUD-043` is unused in both GitHub and Sheet before creating `기획서/50_제작_검증/SX_AUD_043_SX_DEC_054_VFX_SEMANTIC_BATCH_2C.md`.
   - Record that this is static product-package evidence only; actual motion timing/occlusion capture remains runtime validation.

6. **Exact-head merge and same-ID closure**
   - Final product PR exact head must pass Project Contract, GUT, Godot, Thin, Windows Demo Export when triggered, review threads 0, behind 0, mergeable true, and approved diff scope.
   - Squash merge with expected-head protection.
   - Create docs-only merged-main closure for `SX-DEC-054`, `SX-AUD-043`, final asset list, and compact registry; exact-head validate and merge.
   - Synchronize Sheet same `SX-DEC-054` + `SX-AUD-043`, update VFX work-surface status, exact-read back, and remove stale `VFX_2C_PENDING` from current authority ranges.

## Boundaries

Forbidden in this batch: gameplay/domain changes, `.tscn`, `project.godot`, Godot Resource/Theme/Animation/signal authoring, plugins, runtime hookup, audio implementation, `.asset-vault` changes, or physical/device/human PASS claims.

Still deferred: runtime/POC, Windows physical runtime, Android landscape device, connected physical editor, human comprehension/playtest, and release cutover.