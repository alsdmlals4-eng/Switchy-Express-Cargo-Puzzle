# SX-AUD-042 · SX-DEC-054 BUILD Semantic Batch 2B

**Date:** 2026-08-10 KST  
**Decision:** `SX-DEC-054`  
**Implementation baseline main:** `fb229b2ef522fb29c70f43787549fb2e20bf89b0`  
**Branch:** `agent/sx-dec-054-build-semantic-batch-2b`  
**PR:** `#131`  
**Status:** `IMPLEMENTED · FINAL_EXACT_HEAD_VALIDATION_PENDING · RUNTIME_NOT_INTEGRATED`

## Scope

Audit the approved BUILD Batch 2B semantic package: placement preview, track palette interaction presentation, and preflight notice states. The batch is asset/package-only and does not authorize gameplay or Godot runtime hookup.

## Authority

- visual authority: `SX-DEC-053` / `E+D HYBRID · NEO-ARCADE READABILITY`;
- component-state authority: `SX-DEC-050`;
- product decision: same `SX-DEC-054`;
- baseline 053 owner: 39 physical PNGs;
- merged RUN 2A owner: 20 physical PNGs;
- BUILD 2B owner: 8 physical PNGs;
- expected product-root total after merge: 67 physical PNGs.

## Dedicated BUILD sidecar adaptation

The implementation plan initially described additive keys in the existing RUN sidecar. During execution, the safer technical boundary was to use the already-approved “dedicated semantic-completion manifest extension” option:

`art/product_assets/ed_hybrid_v1/semantic_manifest_sx_dec_054_build_2b.json`

This avoids reserializing the already-verified RUN Batch 2A sidecar and keeps RUN ownership exactly 20. It is not a product-direction change. The shared 053 ownership validator reads the union of both 054 sidecars and requires all ownership sets to remain pairwise disjoint.

## TDD lineage

### Initial RED

Exact head: `7d10ed2289e57fd1644c8a4c5bcf84bb86aff47b`.

The BUILD test existed before the BUILD package. Windows Demo Export failed in `Run Python contracts` because BUILD semantic data/validator support did not yet exist.

### Final-architecture RED

Exact head: `7444886f5aa3ecfe91977778d430c227d7f083a2`.

After selecting a dedicated BUILD sidecar, the test was changed to require that sidecar. Windows Demo Export again failed in `Run Python contracts` because the sidecar was intentionally still absent. This confirmed RED against the final architecture rather than against the superseded additive-key implementation detail.

### GREEN implementation

- eight independently authored BUILD PNG primitives were created;
- the eight PNGs and BUILD sidecar were attached atomically to avoid an intermediate unowned-product state;
- focused BUILD validator checks state coverage, PNG integrity, SHA-256, ownership, atlas-provenance boundaries, composition inputs, and runtime-deferred state;
- shared 053 validator/test were minimally widened from 39+20 to 39+20+8 ownership without weakening 053 recovery/disposition/crop/scale/CRC/zlib checks.

Intermediate GREEN head `b68bae4ea153eb066261db4da7f2ddbad70aac98` confirmed Project Contract, GUT, Godot, Thin, and the Windows workflow's Python-contract/headless stages. Final exact-head evidence is intentionally recorded only after all owner documentation is stable.

## BUILD coverage

### Placement preview

Physical overlays: 4.

States:
- `valid`;
- `invalid`;
- `rotate_preview`;
- `replacement_preview`.

All four are preview-only overlays and reuse the committed core rail products as allowed form authority. The historical placement atlas keeps only the four already-authoritative named `SX-DEC-053` crops; no unnamed region receives a new state mapping.

### Track palette

Physical form×interaction PNGs added: **0**.

Semantic compositions: **20** = 4 forms × 5 interaction states.

Forms:
- straight;
- curve;
- switch;
- crossing.

Interaction states reuse existing 053 UI frames:
- idle → normal;
- selected → selected;
- unavailable → disabled;
- keyboard-focus → focus;
- touch-pressed → pressed.

Form identity reuses the four committed core rail silhouettes. `build_track_palette_v01.png` remains `PRESERVE_REFERENCE_ONLY_NO_STATE_MAPPING`.

### Preflight

Physical primitives: 4.

- neutral shell;
- primary-issue marker;
- multi-issue marker;
- focused-location marker.

Compositions:
- `clear`;
- `primary_issue`;
- `multi_issue_summary`;
- `focused_location`.

No ready/warning/blocking gameplay outcome is invented. Optional-target/leaderboard misses are not represented as general run failure.

## Static contract

The focused validator requires:

- `decision_id: SX-DEC-054`;
- `batch: BUILD_2B`;
- exact source authorities;
- exact 39 / 20 baselines;
- exactly 8 unique BUILD PNG paths;
- exactly 28 BUILD compositions;
- exact placement/preflight state sets;
- exact 4×5 palette matrix;
- independent semantic derivation, no new crop authority;
- PNG signature/chunk CRC/IDAT zlib decode/dimensions/alpha/SHA-256;
- pairwise disjoint 053/RUN/BUILD ownership;
- existing committed rail/UI product inputs for palette compositions;
- `runtime_integrated=false` on every BUILD asset/composition.

## Adversarial scope boundary

Authorized changes:

- 8 BUILD PNG primitives;
- BUILD 2B sidecar;
- focused Python test/validator;
- minimal shared ownership validator/test changes;
- implementation plan and product/decision/audit documentation.

Forbidden and unchanged:

- gameplay/domain rules;
- `.tscn` scenes;
- `project.godot`;
- Godot Resource/Theme/Animation/signal authoring;
- plugins;
- runtime hookup;
- `.asset-vault` bytes.

## Final merge gate

Before PR #131 can merge, require on one unchanged exact head:

- Project Contract PASS;
- GUT PASS;
- Godot PASS;
- Thin PASS;
- Windows Demo Export PASS because `tests/python/**` triggers it;
- review threads 0;
- behind 0 / mergeable true;
- changed-file scope remains within the authorized boundary.

Hosted Windows Demo Export PASS remains packaging evidence only and is not physical Windows runtime evidence.

## Deferred evidence

`RUNTIME_POC_DEFERRED · WINDOWS_PHYSICAL_NOT_RUN · ANDROID_DEVICE_NOT_RUN · CONNECTED_PHYSICAL_EDITOR_NOT_RUN · HUMAN_NOT_RUN · ASSET_VAULT_UNTRACK_DEFERRED`

## Closure rule

After product merge, update this audit and the same `SX-DEC-054` owner document with final exact-head workflow IDs and product merge/main. Then use a docs-only merged-main closure and synchronize the configured Google Sheet with the same Decision/Audit IDs.