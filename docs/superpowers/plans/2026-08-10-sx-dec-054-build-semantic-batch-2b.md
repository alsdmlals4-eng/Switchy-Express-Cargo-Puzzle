# SX-DEC-054 BUILD Semantic Batch 2B Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Complete the already-approved BUILD semantic presentation for placement preview, track palette, and preflight notice without assigning meanings to unnamed atlas regions or beginning Godot runtime integration.

**Architecture:** Extend the existing `SX-DEC-054` sidecar additively: keep the RUN 2A `semantic_assets` / `semantic_compositions` contract unchanged, and add BUILD 2B-specific ownership keys. Author only eight new BUILD PNG primitives: four placement overlays and four preflight primitives. Track Palette uses composition, not a form×interaction binary explosion: existing four committed core rail silhouettes provide form identity and existing UI frame states provide idle/selected/unavailable/keyboard-focus/touch-pressed interaction presentation. A focused BUILD validator owns exact state coverage while the legacy `SX-DEC-053` validator is minimally widened to subtract both RUN and BUILD `SX-DEC-054` physical ownership from the shared product root.

**Tech Stack:** Godot 4.7.1 project repository · Python 3.12 static validators/tests · PNG RGBA assets · JSON sidecar manifest · GitHub Actions exact-head verification.

## Global Constraints

- Decision ID remains exactly `SX-DEC-054`; do not create a replacement product decision.
- Source visual authority remains `SX-DEC-053`; source component authority remains `SX-DEC-050`.
- Current main baseline is `fb229b2ef522fb29c70f43787549fb2e20bf89b0`.
- Existing `SX-DEC-053` ownership remains exactly 39 product PNGs and existing bytes are not modified.
- Existing `SX-DEC-054` RUN Batch 2A ownership remains exactly 20 semantic PNGs and RUN records/bytes remain unchanged.
- `build_placement_preview_states_v01.png` may retain only its four already-authoritative named slices under `SX-DEC-053`; no unnamed region receives a new meaning.
- `build_track_palette_v01.png` has no authoritative named slices and is `PRESERVE_REFERENCE_ONLY_NO_STATE_MAPPING` for BUILD 2B.
- Placement states are exactly `valid`, `invalid`, `rotate_preview`, `replacement_preview`.
- Track forms are exactly `straight`, `curve`, `switch`, `crossing`.
- Palette interaction states are exactly `idle`, `selected`, `unavailable`, `keyboard_focus`, `touch_pressed`.
- Preflight component presentation states are exactly `clear`, `primary_issue`, `multi_issue_summary`, `focused_location`.
- Do not introduce ready/warning/blocking as gameplay outcomes. Severity styling is not required in Batch 2B and remains presentation-only if implemented later from authoritative issue data.
- Optional-target misses must never be represented as general run failure.
- Committed/placed rail continues to use committed core rail authority; preview overlays must not masquerade as committed rail.
- Color-only state communication is forbidden; shape/outline/marker redundancy is required.
- No localized copy is baked into PNGs.
- `runtime_integrated=false` globally and per new asset/composition.
- No gameplay/domain, `.tscn`, `project.godot`, Resource, Theme, Animation, signal, plugin, or `.asset-vault` changes.
- Windows physical runtime, Android device, connected physical editor, and human validation remain `NOT_RUN`.

---

### Task 1: Lock the BUILD 2B contract in RED

**Files:**
- Create: `tests/python/test_sx_dec_054_build_semantic_assets.py`

**Interfaces:**
- Consumes: `art/product_assets/ed_hybrid_v1/semantic_manifest_sx_dec_054.json`
- Produces: a RED contract requiring `build_batch == "BUILD_2B"`, a BUILD-specific asset/composition package, and a focused validator file.

- [ ] **Step 1: Write the failing tests**

```python
import importlib.util
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SEMANTIC_MANIFEST = ROOT / "art/product_assets/ed_hybrid_v1/semantic_manifest_sx_dec_054.json"
VALIDATOR_PATH = ROOT / "tools/validate_sx_dec_054_build_semantic_assets.py"


def test_sx_dec_054_build_batch_is_declared():
    semantic = json.loads(SEMANTIC_MANIFEST.read_text(encoding="utf-8"))
    assert semantic.get("build_batch") == "BUILD_2B"
    assert semantic.get("build_semantic_assets")
    assert semantic.get("build_semantic_compositions")


def test_sx_dec_054_build_semantic_assets_contract():
    assert VALIDATOR_PATH.is_file(), "BUILD Batch 2B validator must exist"
    spec = importlib.util.spec_from_file_location("validate_sx_dec_054_build_semantic_assets", VALIDATOR_PATH)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    assert module.validate() == 0
```

- [ ] **Step 2: Run the focused test to verify RED**

Run: `python -m pytest tests/python/test_sx_dec_054_build_semantic_assets.py -q`

Expected: FAIL because `build_batch` / BUILD package and validator do not exist yet. The failure must be feature absence, not syntax/import corruption.

- [ ] **Step 3: Commit RED only**

```bash
git add tests/python/test_sx_dec_054_build_semantic_assets.py
git commit -m "test: define SX-DEC-054 BUILD batch 2B contract"
```

---

### Task 2: Add the focused BUILD validator

**Files:**
- Create: `tools/validate_sx_dec_054_build_semantic_assets.py`

**Interfaces:**
- Consumes: 053 baseline manifest, 054 sidecar, product-root PNG files.
- Produces: `validate() -> int`, returning `0` only when BUILD 2B ownership, state coverage, provenance boundaries, PNG integrity, and runtime-deferred boundaries pass.

- [ ] **Step 1: Define exact BUILD authorities and state sets**

```python
REQUIRED_PLACEMENT = {"valid", "invalid", "rotate_preview", "replacement_preview"}
REQUIRED_TRACK_FORMS = {"straight", "curve", "switch", "crossing"}
REQUIRED_PALETTE_STATES = {"idle", "selected", "unavailable", "keyboard_focus", "touch_pressed"}
REQUIRED_PREFLIGHT = {"clear", "primary_issue", "multi_issue_summary", "focused_location"}
AMBIGUOUS_TRACK_PALETTE = "art/production_candidates/ed_hybrid_v1/build/build_track_palette_v01.png"
PLACEMENT_ATLAS = "art/production_candidates/ed_hybrid_v1/build/build_placement_preview_states_v01.png"
```

- [ ] **Step 2: Validate additive sidecar identity**

Require:
- top-level `decision_id == SX-DEC-054`;
- existing `batch == RUN_2A` remains unchanged;
- `build_batch == BUILD_2B`;
- `runtime_integrated is False`;
- `baseline_sx_dec_053_asset_count == 39`;
- existing RUN physical records remain exactly 20;
- BUILD physical records are exactly 8 and under `art/product_assets/ed_hybrid_v1/build/build_`.

- [ ] **Step 3: Validate provenance boundaries**

Require:
- track-palette atlas policy is exactly `PRESERVE_REFERENCE_ONLY_NO_STATE_MAPPING`;
- placement atlas policy allows only `PRESERVE_NAMED_SLICES_ONLY_NO_NEW_STATE_MAPPING`;
- every new BUILD physical asset uses `derivation.kind == independent_semantic_asset`;
- no new asset claims either atlas as a pixel/crop authority;
- no new sidecar record uses `authoritative_slice_name` or crop bounds.

- [ ] **Step 4: Validate PNG integrity and ownership**

Use the same signature/chunk CRC/IDAT zlib/dimension/alpha checks as the RUN validator. Require eight unique BUILD asset paths, no overlap with 053 or RUN 2A paths, and exact existence of all BUILD-owned paths.

- [ ] **Step 5: Validate placement composition coverage**

Require exactly the four placement states. Each composition must declare all four valid form inputs through `allowed_form_inputs`, where the allowed set equals the four committed core rail product paths. State-specific overlay inputs must resolve to BUILD-owned PNGs.

- [ ] **Step 6: Validate palette composition matrix without binary explosion**

Require exactly 20 semantic compositions: every `(form, state)` pair from 4 forms × 5 interaction states exactly once. Require:
- form input uses the corresponding committed core rail product PNG;
- interaction frame uses the existing 053 UI control frame:
  - idle → `normal`
  - selected → `selected`
  - unavailable → `disabled`
  - keyboard_focus → `focus`
  - touch_pressed → `pressed`
- no BUILD 2B palette PNG is required or allowed merely to encode the form×state cross product.

- [ ] **Step 7: Validate preflight composition coverage**

Require exactly `clear`, `primary_issue`, `multi_issue_summary`, `focused_location`. `clear` uses the neutral shell alone; each other state adds its matching marker. Reject result/failure terms and any `optional_target` or leaderboard semantics in preflight records.

- [ ] **Step 8: Keep runtime deferred**

Require `runtime_integrated=false` on every BUILD asset and composition.

---

### Task 3: Author eight independent BUILD semantic PNG primitives and extend the sidecar atomically

**Files:**
- Create: `art/product_assets/ed_hybrid_v1/build/build_placement_valid_overlay_v01.png`
- Create: `art/product_assets/ed_hybrid_v1/build/build_placement_invalid_overlay_v01.png`
- Create: `art/product_assets/ed_hybrid_v1/build/build_placement_rotate_preview_overlay_v01.png`
- Create: `art/product_assets/ed_hybrid_v1/build/build_placement_replacement_preview_overlay_v01.png`
- Create: `art/product_assets/ed_hybrid_v1/build/build_preflight_shell_v01.png`
- Create: `art/product_assets/ed_hybrid_v1/build/build_preflight_primary_issue_marker_v01.png`
- Create: `art/product_assets/ed_hybrid_v1/build/build_preflight_multi_issue_marker_v01.png`
- Create: `art/product_assets/ed_hybrid_v1/build/build_preflight_focused_location_marker_v01.png`
- Modify: `art/product_assets/ed_hybrid_v1/semantic_manifest_sx_dec_054.json`

**Interfaces:**
- Consumes: approved E+D shape/palette language, exact component states, existing committed rail/UI frame product inputs.
- Produces: eight alpha-capable independent BUILD primitives and 28 BUILD compositions (4 placement + 20 palette + 4 preflight).

- [ ] **Step 1: Generate deterministic RGBA PNGs**

Use text-free vector-like raster primitives with shape redundancy:
- valid: affirmative check/port-outline cue, not color only;
- invalid: barred/X/blocked cue, not color only;
- rotate preview: curved rotation arrow cue;
- replacement preview: swap/replace double-arrow cue;
- preflight shell: neutral bounded issue container with no baked copy;
- primary issue: single exclamation/issue marker;
- multi issue: stacked/multiple marker;
- focused location: reticle/location marker.

Do not copy/crop unnamed atlas pixels.

- [ ] **Step 2: Extend the existing sidecar additively**

Keep the RUN keys and 20 RUN records byte-semantically intact. Add:

```json
{
  "completed_batches": ["RUN_2A", "BUILD_2B"],
  "build_batch": "BUILD_2B",
  "ambiguous_build_atlas_sources_preserved": [
    {
      "path": "art/production_candidates/ed_hybrid_v1/build/build_placement_preview_states_v01.png",
      "policy": "PRESERVE_NAMED_SLICES_ONLY_NO_NEW_STATE_MAPPING"
    },
    {
      "path": "art/production_candidates/ed_hybrid_v1/build/build_track_palette_v01.png",
      "policy": "PRESERVE_REFERENCE_ONLY_NO_STATE_MAPPING"
    }
  ],
  "build_semantic_assets": [],
  "build_semantic_compositions": []
}
```

Every BUILD physical record includes `decision_id`, `family: build`, `role`, `primitive`, `dimensions`, `transparent: true`, SHA-256, `runtime_integrated:false`, and independent semantic derivation from `SX-DEC-050 + SX-DEC-053`.

- [ ] **Step 3: Register four placement compositions**

Each state uses exactly one matching BUILD overlay and declares the same four committed core rail inputs as allowed selected-form inputs. No composition claims a placed/committed rail output.

- [ ] **Step 4: Register the 20 palette compositions**

Create the complete 4×5 semantic matrix in JSON only. Each record contains `component: track_palette`, `form`, `state`, and two inputs: one committed core rail silhouette and one existing UI frame corresponding to interaction state.

- [ ] **Step 5: Register four preflight compositions**

- clear → shell;
- primary_issue → shell + primary marker;
- multi_issue_summary → shell + multi marker;
- focused_location → shell + focused-location marker.

No severity or outcome meaning is added.

- [ ] **Step 6: Commit the eight PNGs + sidecar + validator together**

This commit must be atomic so physical BUILD PNGs never exist unowned in an intermediate branch state.

---

### Task 4: Widen shared ownership checks without weakening SX-DEC-053 or RUN 2A

**Files:**
- Modify: `tools/validate_final_ed_product_asset_promotion.py`
- Modify: `tests/python/test_final_ed_product_asset_promotion.py`

**Interfaces:**
- Consumes: 053 paths + RUN 2A paths + BUILD 2B paths.
- Produces: one exact partition of the shared physical product root.

- [ ] **Step 1: Aggregate both 054 asset lists**

In the 053 validator, derive `semantic_product_paths` from the union of:
- `semantic.semantic_assets` (RUN 2A), and
- `semantic.build_semantic_assets` (BUILD 2B).

Do not alter any 053 disposition, source-health, recovery, crop, scale, CRC/zlib, or runtime checks.

- [ ] **Step 2: Update the product ownership test**

Require:
- 053 paths unique;
- RUN paths unique;
- BUILD paths unique;
- all three sets pairwise disjoint;
- union equals every physical PNG under `art/product_assets/ed_hybrid_v1/`.

- [ ] **Step 3: Run focused + legacy Python contracts**

Run:

```bash
python -m pytest tests/python/test_sx_dec_054_build_semantic_assets.py tests/python/test_sx_dec_054_run_semantic_assets.py tests/python/test_final_ed_product_asset_promotion.py -q
```

Expected: PASS.

---

### Task 5: Update canonical asset/audit documentation

**Files:**
- Modify: `기획서/40_표현/FINAL_PRODUCT_ASSET_LIST_V1.md`
- Modify: `docs/decisions/SX_DEC_054_SEMANTIC_ASSET_COMPLETION_STRATEGY.md`
- Create only after confirming the ID is unused: `기획서/50_제작_검증/SX_AUD_042_SX_DEC_054_BUILD_SEMANTIC_BATCH_2B.md`

**Interfaces:**
- Consumes: final BUILD 2B physical count, exact-head CI, ownership partition.
- Produces: same-ID current authority and bounded technical audit.

- [ ] **Step 1: Search GitHub and Sheet for `SX-AUD-042`**

If occupied, use the next unused audit ID; never overwrite an unrelated audit.

- [ ] **Step 2: Record asset counts and composition reuse**

Expected new physical count if this plan is unchanged:
- SX-DEC-053: 39;
- SX-DEC-054 RUN 2A: 20;
- SX-DEC-054 BUILD 2B: 8;
- total physical product PNGs: 67.

Explicitly record that Track Palette adds zero form×interaction PNGs and reuses existing four committed rail silhouettes + existing interaction frames.

- [ ] **Step 3: Preserve validation boundaries**

Record `runtime_integrated=false`; physical Windows/Android/connected-editor/human gates remain `NOT_RUN`.

---

### Task 6: Exact-head PR validation, merge, merged-main closure, and same-ID Sheet sync

**Files:**
- Product PR: BUILD 2B branch to `main`.
- Closure docs after product merge: `SX-DEC-054`, the BUILD audit, and compact registry as needed.
- Google Sheet: existing `SX-DEC-054`, new BUILD audit row, and BUILD visual work surface.

**Interfaces:**
- Consumes: unchanged final PR head.
- Produces: `MERGED_MAIN_VERIFIED` BUILD 2B evidence and synchronized GitHub/Sheet authority.

- [ ] **Step 1: Verify final product PR head**

Require on one unchanged exact head:
- Project Contract PASS;
- GUT PASS;
- Godot PASS;
- Thin PASS;
- Windows Demo Export PASS when triggered by `tests/python/**`;
- focused BUILD test passes within `python -m pytest tests/python -q`;
- review threads 0;
- behind 0 / mergeable true;
- diff contains no forbidden runtime/gameplay/asset-vault surfaces.

- [ ] **Step 2: Squash merge with expected-head protection**

Do not merge if the head changes after validation.

- [ ] **Step 3: Create docs-only merged-main closure**

Record the product exact head, workflow IDs, product merge SHA, final 39+20+8 ownership, and deferred runtime boundaries under the same `SX-DEC-054`.

- [ ] **Step 4: Exact-head validate and merge closure**

Docs-only closure requires its triggered Contract/GUT/Godot/Thin checks, review threads 0, and expected-head merge protection.

- [ ] **Step 5: Synchronize Google Sheet**

Update the existing `SX-DEC-054` row, add the unused BUILD audit ID, and change `06_시각_작업면` BUILD status from pending to merged while preserving formatting/validation. Do not alter RUN Batch 2A evidence.

- [ ] **Step 6: Read back and search stale tokens**

Verify exact cells and ensure stale `BUILD_2B_PENDING` / implementation-in-progress tokens are absent from the updated authoritative ranges.

## Self-review

- Spec coverage: placement, palette, and preflight component states from `SX-DEC-050` / `SX-DEC-054` are each mapped to a concrete validator and composition task.
- No guessed atlas semantics: the unnamed track-palette atlas is reference-only; placement atlas receives no new crop/state mapping.
- Type/key consistency: RUN keys remain unchanged; BUILD keys are consistently `build_batch`, `build_semantic_assets`, and `build_semantic_compositions` across tests, validator, sidecar, and ownership checks.
- Binary scope: eight new PNGs only; palette interaction coverage is composition-based.
- Runtime boundary: no runtime authoring or physical validation claim is introduced.
- Placeholder scan: no TBD/TODO/unspecified implementation step remains.