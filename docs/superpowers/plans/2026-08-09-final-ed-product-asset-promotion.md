# Final E+D Product Asset Promotion Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Promote the approved SX-DEC-053 E+D visual direction into a bounded first product-asset batch while preserving all 31 SX-DEC-051 candidate sources and keeping Godot runtime integration deferred.

**Architecture:** Add a product-asset manifest that records one disposition for every candidate source, plus a promoted-asset list. `PROMOTE_AS_IS` files reuse the exact candidate blob; deterministic splits/resizes may create versioned derived files with explicit source transform metadata. Product assets live under `art/product_assets/ed_hybrid_v1/`; candidate sources remain unchanged under `art/production_candidates/ed_hybrid_v1/`.

**Tech Stack:** GitHub object/contents API, PNG assets, Python 3.12 standard-library validator/tests, existing GitHub Actions Project Contract/GUT/Godot/Thin/Pilot regressions.

## Global Constraints

- Decision: `SX-DEC-053`.
- Art direction: `E+D HYBRID · NEO-ARCADE READABILITY`.
- Blue locomotive remains hero anchor.
- Trailing cargo wagons target approximately 70–75% of locomotive visual size; domain collision/route geometry is unchanged.
- Candidate source root remains `art/production_candidates/ed_hybrid_v1/` and is never deleted or overwritten.
- Product root is `art/product_assets/ed_hybrid_v1/`.
- Every one of the 31 source candidates gets exactly one disposition: `PROMOTE_AS_IS`, `PROMOTE_AFTER_REVISION`, or `REPLACE`.
- Runtime/Scene/Resource/Theme/Animation/signal hookup remains deferred.
- No localized text is baked into promoted PNGs.
- No new concept-board/image generation is part of this plan.

---

### Task 1: Add a CI-consumed promotion contract (RED)

**Files:**
- Create: `tests/python/test_final_ed_product_asset_promotion.py`
- Create: `tools/validate_final_ed_product_asset_promotion.py`
- Modify: `.github/workflows/project-contract.yml`

**Interfaces:**
- Consumes: candidate manifest `art/production_candidates/ed_hybrid_v1/manifest.json` with `candidate_count == 31`.
- Produces: `validate() -> int` where `0` means product manifest/assets satisfy SX-DEC-053 static contract.

- [ ] **Step 1: Write the failing contract test**

The test must assert:

```python
ROOT = Path(__file__).resolve().parents[2]
PRODUCT_ROOT = ROOT / "art" / "product_assets" / "ed_hybrid_v1"
PRODUCT_MANIFEST = PRODUCT_ROOT / "manifest.json"
CANDIDATE_MANIFEST = ROOT / "art" / "production_candidates" / "ed_hybrid_v1" / "manifest.json"

assert PRODUCT_MANIFEST.is_file()
data = json.loads(PRODUCT_MANIFEST.read_text(encoding="utf-8"))
assert data["decision_id"] == "SX-DEC-053"
assert data["art_direction"] == "E+D HYBRID · NEO-ARCADE READABILITY"
assert data["runtime_integrated"] is False
assert data["source_candidate_count"] == 31
assert len(data["source_candidate_dispositions"]) == 31
assert {r["disposition"] for r in data["source_candidate_dispositions"]} <= {
    "PROMOTE_AS_IS", "PROMOTE_AFTER_REVISION", "REPLACE"
}
assert validator.validate() == 0
```

The contract also requires unique candidate source paths, promoted assets to point to a candidate source, and all promoted PNGs to be alpha-capable.

- [ ] **Step 2: Hook the focused test into Project Contract before implementation**

Add:

```yaml
      - name: Validate final E+D product asset promotion
        run: python tests/python/test_final_ed_product_asset_promotion.py -v
```

- [ ] **Step 3: Run CI and record expected RED**

Expected failure reason: `art/product_assets/ed_hybrid_v1/manifest.json` does not exist yet. Do not accept an environment/tooling failure as the RED evidence.

- [ ] **Step 4: Commit the RED contract**

Commit message: `test: define final E+D product asset promotion contract`.

---

### Task 2: Record all 31 candidate dispositions and product manifest skeleton

**Files:**
- Create: `art/product_assets/ed_hybrid_v1/README.md`
- Create: `art/product_assets/ed_hybrid_v1/manifest.json`
- Modify: `tools/validate_final_ed_product_asset_promotion.py`

**Interfaces:**
- Consumes: all 31 candidate records from SX-DEC-051.
- Produces: complete disposition ledger plus an initially bounded promoted asset set.

- [ ] **Step 1: Build the disposition ledger**

Use these source-level defaults from the approved spec/checklist:

```text
PROMOTE_AS_IS:
  locomotive, cargo stars, stations, committed rails, start marker, route-end marker,
  combo static candidate, ghost-route candidate, cost-HUD candidate,
  success/failure blank shells, progress/meta primitive

PROMOTE_AFTER_REVISION:
  three cargo wagons,
  stack HUD atlas,
  switch-direction atlas,
  train-cargo-strip atlas,
  load-mode atlas,
  build placement atlas,
  build track palette,
  build preflight candidate,
  controls atlas,
  VFX feedback atlas

REPLACE:
  none unless adversarial visual inspection finds a role that cannot be safely derived/reused
```

Every ledger record contains:

```json
{
  "source_candidate": "art/production_candidates/ed_hybrid_v1/...png",
  "source_decision_id": "SX-DEC-051",
  "disposition": "PROMOTE_AS_IS",
  "reason": "bounded inspection result"
}
```

- [ ] **Step 2: Implement validator invariants**

`validate()` must reject:

```text
missing/duplicate source records
source_candidate_count != 31
unknown disposition values
promoted assets outside art/product_assets/ed_hybrid_v1/
promoted asset without source candidate
runtime_integrated != false
missing SX-DEC-053 decision ID
PNG signature/dimension/alpha-capability failure
cargo wagon promoted without visual_scale in [0.70, 0.75]
missing seven reusable UI button states once controls are marked promoted
```

- [ ] **Step 3: Run focused contract**

Expected: ledger/schema checks pass; product-file checks may remain RED until Task 3/4 assets are added.

- [ ] **Step 4: Commit**

Commit message: `feat: record final E+D asset dispositions`.

---

### Task 3: Promote first-batch core assets without new image generation

**Files:**
- Create/reuse exact candidate blobs under `art/product_assets/ed_hybrid_v1/core/` and `board/`.
- Update: `art/product_assets/ed_hybrid_v1/manifest.json`

**Interfaces:**
- Consumes: candidate core/board PNGs.
- Produces: product core assets and provenance entries.

- [ ] **Step 1: Promote AS-IS core/board bytes by exact blob reuse**

Promote:

```text
core_train_locomotive_blue_normal_v01.png
core_cargo_star_red_normal_v01.png
core_cargo_star_blue_normal_v01.png
core_cargo_star_yellow_normal_v01.png
core_station_red_normal_v01.png
core_station_blue_normal_v01.png
core_station_yellow_normal_v01.png
core_rail_straight_normal_v01.png (target may map from board_rail_straight_normal_v01.png)
core_rail_curve_normal_v01.png
core_rail_crossing_normal_v01.png
core_rail_switch_three_way_normal_v01.png
core_marker_start_normal_v01.png
core_marker_route_end_normal_v01.png
```

For renamed product files, keep `source_candidate` and `source_blob_sha` in manifest.

- [ ] **Step 2: Derive three smaller wagon v02 assets deterministically**

Do not generate new art. Use the approved candidate wagon pixels as source and apply a deterministic centered scale transform. Preserve transparent canvas and record:

```json
{
  "transform": "centered_scale",
  "visual_scale": 0.74,
  "source_version": "v01",
  "product_version": "v02"
}
```

Target filenames:

```text
core_wagon_cargo_red_normal_v02.png
core_wagon_cargo_blue_normal_v02.png
core_wagon_cargo_yellow_normal_v02.png
```

- [ ] **Step 3: Verify visual hierarchy contract statically**

Validator checks each promoted wagon has `0.70 <= visual_scale <= 0.75` and locomotive has `visual_scale == 1.0`. Runtime collision remains explicitly absent from the manifest.

- [ ] **Step 4: Commit**

Commit message: `feat: promote final E+D core world assets`.

---

### Task 4: Split deterministic RUN and control states

**Files:**
- Create: `art/product_assets/ed_hybrid_v1/run/*.png`
- Create: `art/product_assets/ed_hybrid_v1/ui/*.png`
- Update: `art/product_assets/ed_hybrid_v1/manifest.json`

**Interfaces:**
- Consumes: documented SX-DEC-051 atlas slice bounds.
- Produces: independent semantic-state PNGs with transform provenance.

- [ ] **Step 1: Split documented stack states**

From `run_stack_hud_states_v01.png`, use exact documented bounds for:

```text
run_stack_empty_v01
run_stack_top_highlight_v01
run_stack_plus_n_v01 (source slice run_stack_32plus_v01)
run_stack_unloading_v01
```

Keep `run_stack_next_group_v01` unpromoted if no distinct approved visual can be derived without inventing a new state; its source atlas remains `PROMOTE_AFTER_REVISION`.

- [ ] **Step 2: Split/derive switch states**

Use documented `run_switch_arrow_left_selected_v01` slice as selected-state source. Deterministic rotation may produce center/right selected states only if the arrow remains semantically correct; record rotation degrees in manifest. Use the documented locked slice for `run_switch_locked_v01`. If rotation inspection fails, leave center/right as pending revision rather than fabricating art.

- [ ] **Step 3: Split load mode only if state boundary is unambiguous**

Inspect the source atlas. If two clean semantic halves exist, export `run_load_mode_off_v01.png` and `run_load_mode_on_v01.png` and record exact crop bounds. Otherwise keep the atlas `PROMOTE_AFTER_REVISION` and do not guess slice bounds.

- [ ] **Step 4: Split all seven control states from documented bounds**

Export:

```text
ui_button_frame_square_blue_normal_v01.png
ui_button_frame_square_blue_hover_v01.png
ui_button_frame_square_blue_pressed_v01.png
ui_button_frame_square_blue_selected_v01.png
ui_button_frame_square_blue_disabled_v01.png
ui_button_frame_square_blue_locked_v01.png
ui_button_frame_square_blue_focus_v01.png
```

Use the SX-DEC-051 slice bounds exactly.

- [ ] **Step 5: Keep train-cargo-strip pending if shrinking wagons inside the composite requires semantic repaint**

Do not use generative art. Mark the source `PROMOTE_AFTER_REVISION` and preserve the blocker in manifest/audit if a safe deterministic transform cannot isolate wagon elements.

- [ ] **Step 6: Run focused validator**

Expected: all actually promoted files pass PNG/provenance/naming checks; pending revision assets remain explicitly pending and do not falsely count as promoted.

- [ ] **Step 7: Commit**

Commit message: `feat: split final E+D RUN and control assets`.

---

### Task 5: Adversarial review, canonical docs, and exact-head merge

**Files:**
- Modify: `docs/decisions/SX_DEC_053_FINAL_ED_PRODUCTION_VISUAL_DIRECTION.md`
- Modify: `기획서/40_표현/FINAL_PRODUCT_ASSET_LIST_V1.md`
- Create: `기획서/50_제작_검증/SX_AUD_040_FINAL_ED_PRODUCT_ASSET_PROMOTION.md`
- Update PR #122 and Google Sheet using the same `SX-DEC-053`.

**Interfaces:**
- Consumes: exact promoted manifest and CI results.
- Produces: canonical promotion status without claiming runtime/device/human evidence.

- [ ] **Step 1: Adversarial diff review**

Reject the batch if it mutates gameplay, `.tscn`, Resource, Theme, Animation, signal, `project.godot`, Godot plugin state, or `.asset-vault` bytes.

- [ ] **Step 2: Run exact-head gates**

Require fresh success for:

```text
Project Contract
GUT 9.7.1 Tests
Godot Tests
Validate Thin Adapter Migration
```

Also inspect Windows/Pilot if triggered; failures are investigated, not ignored.

- [ ] **Step 3: Update canonical status from actual evidence**

Use statuses such as:

```text
FINAL_DIRECTION_APPROVED
DISPOSITION_31_COMPLETE
FIRST_PRODUCT_ASSET_BATCH_PARTIAL_OR_COMPLETE
STATIC_PROMOTION_VALIDATION_PASS
RUNTIME_POC_DEFERRED
```

Never claim missing RUN states as complete.

- [ ] **Step 4: Move PR #122 Draft → Ready and merge under inherited continuous-work authority only after exact-head green**

Use expected-head protection and no force update.

- [ ] **Step 5: Read back merged main and post-merge regressions**

Record the actual merge SHA and automated results.

- [ ] **Step 6: Sync Google Sheet using `SX-DEC-053`**

Update Hub, Decision row, VIS-FINITE rows as applicable, Audit, and Production verification. Preserve:

```text
ASSET_VAULT_UNTRACK_DEFERRED_EXTERNAL_EXECUTOR
RUNTIME_POC_DEFERRED
WINDOWS_PHYSICAL_NOT_RUN
ANDROID_DEVICE_NOT_RUN
CONNECTED_PHYSICAL_EDITOR_NOT_RUN
HUMAN_NOT_RUN
```

- [ ] **Step 7: Final readback**

Verify GitHub main/open PR state and Sheet values agree on the same final SHA and Decision ID.
