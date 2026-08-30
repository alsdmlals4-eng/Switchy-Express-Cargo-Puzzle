# SX-DEC-063 Core Board v02 Asset and Runtime Integration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:subagent-driven-development` (recommended) or `superpowers:executing-plans` to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the current mixed v01 board artwork with an approved, original Core Board v02 asset family while preserving all finite puzzle semantics, then prove the actual renderer loads and displays the v02 paths.

**Architecture:** Keep `ProductBoardRenderer` as the sole visual projection and preserve its 14-slot map, draw order, input math, and procedural state layers. Reuse the approved v02 terrain, create 13 original image-model candidates for the remaining current slots, require an explicit user disposition on the assembled candidate bundle, then switch only the versioned consumer-path values and add manifest/provenance/test evidence.

**Tech Stack:** Godot 4.7.1-stable, GDScript, repository custom test runner, Python `unittest`, OpenAI built-in Image Generation, existing Hera Agent live-editor session, JSON asset manifest, PNG/`CompressedTexture2D` import pipeline.

**Spec:** `docs/superpowers/specs/2026-08-30-sx-dec-063-core-board-v02-design.md`

## Global Constraints

- Use only the exact existing `ProductBoardRenderer::PRODUCT_VISUAL_ASSET_PATHS` slots; do not add a renderer, camera, scene, map, or input path.
- Reuse `art/product_assets/ed_hybrid_v2/board/board_terrain_playfield_v02.png`; retain every v01 asset as a rollback source.
- Create only the 13 versioned core candidates named in the spec: one train, four rails, two markers, three stations, and three cargo stars.
- Generate all new raster artwork with the built-in image model. The approved HGB r02 rail/station sheet is an in-project style reference only; do not crop, ship, or reproduce its board-frame composition.
- Keep all images text-free, logo-free, watermark-free, independently original, and transparent behind the object. All rules, labels, selection, lock, cardinal service, grid, and HUD feedback stay live Godot output.
- Preserve rectangular cells, `_board_rect()`, `board_cell_from_local()`, exact-cell cargo contact, cardinal-only station service, LIFO/TOP, Manual/Auto, route-lock semantics, T1–T6/capstone, audio, localization, score/economy/progression, T2 v02, Issue #227, PR #174, and the Base pin.
- Write and observe RED tests before promoting a v02 core bundle or changing a runtime consumer value. Never hand-edit `.import` files or `.godot/` cache files.
- Candidate 004 remains historical package evidence for its old bytes. A v02 renderer-path change requires a new exact candidate and leaves physical Windows/audio, Android, five-person, player experience, release-rights, and production-cutover evidence as `NOT_RUN`.
- Use the current Hera-connected Godot 4.7.1 instance (`pid 2072`) for live runtime captures. Do not represent a machine capture as a physical or human pass.

## File Structure and Responsibilities

| Path | Responsibility |
| --- | --- |
| `art/product_assets/ed_hybrid_v2/core/core_*_v02.png` | Approved original v02 normal-state Core Board sprites. |
| `art/product_assets/ed_hybrid_v2/manifest.json` | Exact asset IDs, paths, dimensions, SHA-256 values, consumers, and runtime-connection state for the v02 board family. |
| `docs/visual-references/sx-dec-063-core-board-v02/CORE_BOARD_V02_CANDIDATE_RECORD.md` | Candidate prompts, approved source images, user disposition, visual QA, and final asset provenance links. |
| `game/demo/presentation/product_board_renderer.gd` | The 14 versioned visual-path values only; rendering behavior remains unchanged. |
| `tests/demo/test_product_board_renderer.gd` | Runtime-facing v02 path/load/draw-order assertions. |
| `tests/python/test_sx_dec_063_core_board_asset_promotion.py` | PNG, alpha, manifest, hash, consumer, and v01 rollback contract. |
| `docs/ASSET_RIGHTS_AND_PROVENANCE_RECORD.md` | Rights/provenance record for every final image-model output. |
| `docs/decisions/SX_DEC_063_HYBRID_MINIATURE_DIORAMA_VISUAL_PRODUCTION_ALIGNMENT.md` | Exact scope/result/evidence status after implementation. |
| `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`, `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`, `기획서/40_표현/TARGET_BUILD_SCREEN_SURFACE_AND_VISUAL_COVERAGE.md` | Current decision, next action, visual coverage, candidate invalidation, and evidence ceiling readback. |

---

### Task 1: Record the approved implementation boundary and candidate brief

**Files:**
- Modify: `docs/superpowers/specs/2026-08-30-sx-dec-063-core-board-v02-design.md`
- Create: `docs/visual-references/sx-dec-063-core-board-v02/CORE_BOARD_V02_CANDIDATE_RECORD.md`

**Interfaces:**
- Consumes: the user’s 2026-08-30 design approval, the HGB r02 rail/station visual reference, and the exact existing v01 consumer names.
- Produces: `GENERATED_CANDIDATE` records with one exact prompt and runtime target for every v02 core image.

- [ ] **Step 1: Change the saved design status to the approved pre-generation state**

Set the specification status to `USER_APPROVED_FOR_CANDIDATE_GENERATION`. Preserve the approval sentence and add the narrow scope statement below it:

```md
**Candidate-promotion gate:** Generated images are review candidates only. The user must approve the assembled Core Board v02 pixels before any runtime path changes.
```

- [ ] **Step 2: Create the candidate record with the exact common prompt contract**

Write this common prompt prefix in the new record and use it unchanged for each individual image-model request:

```text
Use case: stylized-concept
Asset type: one original Godot Core Board v02 sprite for Switchy Express: Cargo Puzzle
Input image: the approved in-project Human Game Blueprint rail/station sheet is a style reference only; do not crop it, copy its framed board layout, or reproduce its object arrangement.
Style/medium: premium cozy miniature railway diorama, restrained 2.5D elevated cues within a rectangular-grid game piece, rounded readable silhouette, timber sleepers, dark steel rails, stone edging, modest moss, warm brass hardware, soft contact shadow, upper-left warm practical light, thin dark brown/navy separation.
Composition: one centered object only, generous transparent margin, designed to remain unmistakable when rendered inside a 64-pixel game cell unless a different target size is stated.
Constraints: genuine transparent background; no text, letters, numbers, logo, watermark, UI panel, frame, terrain backdrop, train wagon, coin, score, save symbol, fuel, boost, capacity symbol, or diagonal-station-service implication; no third-party art, trademark, or identifiable reference layout.
```

- [ ] **Step 3: Add the thirteen exact subject suffixes**

Add one row per candidate with these target paths and suffixes:

| Candidate ID | Target path | Append this exact subject request |
| --- | --- | --- |
| `SX-VIS-063-CORE-TRAIN-001` | `art/product_assets/ed_hybrid_v2/core/core_train_locomotive_blue_normal_v02.png` | `Subject: compact navy-blue locomotive facing right, short engine body only, brass lamp, no cargo wagon. Target render footprint: 128×96.` |
| `SX-VIS-063-CORE-RAIL-STRAIGHT-001` | `art/product_assets/ed_hybrid_v2/core/core_rail_straight_normal_v02.png` | `Subject: straight rail tile with exactly two clear ports centered on the left and right edges. Target render footprint: 64×64.` |
| `SX-VIS-063-CORE-RAIL-CURVE-001` | `art/product_assets/ed_hybrid_v2/core/core_rail_curve_normal_v02.png` | `Subject: quarter-turn rail tile with exactly two clear ports centered on the left and top edges. Target render footprint: 64×64.` |
| `SX-VIS-063-CORE-RAIL-CROSSING-001` | `art/product_assets/ed_hybrid_v2/core/core_rail_crossing_normal_v02.png` | `Subject: crossing rail tile with exactly four clear ports centered on all edges; north-south and east-west rails cross at one central point. Target render footprint: 64×64.` |
| `SX-VIS-063-CORE-RAIL-SWITCH-001` | `art/product_assets/ed_hybrid_v2/core/core_rail_switch_three_way_normal_v02.png` | `Subject: three-way rail switch with exact ports centered left, top, and right; one compact manual switch lever at the lower-right, no route arrows or lock icon. Target render footprint: 64×64.` |
| `SX-VIS-063-CORE-START-001` | `art/product_assets/ed_hybrid_v2/core/core_marker_start_normal_v02.png` | `Subject: small brass-and-navy circular start marker with a simple forward arrow, visually distinct from cargo and station, no letters. Target render footprint: 64×64.` |
| `SX-VIS-063-CORE-END-001` | `art/product_assets/ed_hybrid_v2/core/core_marker_route_end_normal_v02.png` | `Subject: small crimson route-end beacon on a stone plinth, visually distinct from cargo and station, no letters. Target render footprint: 64×64.` |
| `SX-VIS-063-CORE-STATION-RED-001` | `art/product_assets/ed_hybrid_v2/core/core_station_red_normal_v02.png` | `Subject: compact red off-track station building on its own stone plinth, with no rail through its footprint and no service-ring graphics. Target render footprint: 64×64.` |
| `SX-VIS-063-CORE-STATION-BLUE-001` | `art/product_assets/ed_hybrid_v2/core/core_station_blue_normal_v02.png` | `Subject: compact blue off-track station building on its own stone plinth, with no rail through its footprint and no service-ring graphics. Target render footprint: 64×64.` |
| `SX-VIS-063-CORE-STATION-YELLOW-001` | `art/product_assets/ed_hybrid_v2/core/core_station_yellow_normal_v02.png` | `Subject: compact yellow off-track station building on its own stone plinth, with no rail through its footprint and no service-ring graphics. Target render footprint: 64×64.` |
| `SX-VIS-063-CORE-CARGO-RED-001` | `art/product_assets/ed_hybrid_v2/core/core_cargo_star_red_normal_v02.png` | `Subject: red five-point cargo star token with a thick dark outline and small brass cargo clasp, no text. Target render footprint: 64×64.` |
| `SX-VIS-063-CORE-CARGO-BLUE-001` | `art/product_assets/ed_hybrid_v2/core/core_cargo_star_blue_normal_v02.png` | `Subject: blue five-point cargo star token with a thick dark outline and small brass cargo clasp, no text. Target render footprint: 64×64.` |
| `SX-VIS-063-CORE-CARGO-YELLOW-001` | `art/product_assets/ed_hybrid_v2/core/core_cargo_star_yellow_normal_v02.png` | `Subject: yellow five-point cargo star token with a thick dark outline and small brass cargo clasp, no text. Target render footprint: 64×64.` |

- [ ] **Step 4: Validate the record before generation**

Run:

```powershell
rg -n -i 'text|watermark|logo|transparent|left|right|top|ports|off-track|runtime target' -- docs/visual-references/sx-dec-063-core-board-v02/CORE_BOARD_V02_CANDIDATE_RECORD.md
```

Expected: every row has an exact runtime target and a subject-specific constraint; no row points to an explanation sheet or unnamed future use.

- [ ] **Step 5: Commit the approved candidate brief**

```powershell
git add docs/superpowers/specs/2026-08-30-sx-dec-063-core-board-v02-design.md docs/visual-references/sx-dec-063-core-board-v02/CORE_BOARD_V02_CANDIDATE_RECORD.md
git commit -m "docs: define core board v02 image candidates"
```

### Task 2: Generate and inspect the non-runtime Core Board v02 candidates

**Files:**
- Create outside the repository first: thirteen built-in image-model outputs, one per `SX-VIS-063-CORE-*` candidate ID.
- Modify after inspection only: `docs/visual-references/sx-dec-063-core-board-v02/CORE_BOARD_V02_CANDIDATE_RECORD.md`

**Interfaces:**
- Consumes: the exact common prompt plus one subject suffix from Task 1 and the locally inspected HGB r02 style reference.
- Produces: thirteen `GENERATED_CANDIDATE · NOT_RUNTIME_ASSET` images with output locators and per-candidate visual QA.

- [ ] **Step 1: Generate one image-model output per candidate**

Use the built-in Image Generation tool thirteen times. Include only `docs/visual-references/human-game-blueprint/r02/sx-hgb-vis-004-rail-station-language-candidate.png` as a local style-reference image. Do not request a sheet, collage, text, or pre-composed screen.

- [ ] **Step 2: Inspect each native image and game-scale reduction**

For each candidate, verify all of the following before it can be shown as a final candidate:

```text
transparent outer background
one centered object
no text, watermark, logo, panel, or frame
rail ports match the named cardinal edges exactly
curve and switch direction are unambiguous
station has no rail on its footprint
cargo color remains distinguishable by outline and silhouette
train is a short locomotive, not a wagon or long train
object remains readable at its 64×64 or 128×96 target footprint
```

- [ ] **Step 3: Run the candidate-only adversarial review**

Record five results in the candidate record:

```text
1. consumer mismatch or non-runtime composition
2. cardinal rail-port/station-footprint violation
3. low-resolution silhouette/readability failure
4. style/reference/provenance or embedded-text drift
5. accidental gameplay, UI, evidence, or scope claim
```

Any candidate that fails one check receives one targeted regeneration prompt that changes only the observed failure, then repeats all five checks.

- [ ] **Step 4: Show the assembled candidate bundle to the user**

Present all selected candidates with their target paths and state each as `GENERATED_CANDIDATE · NOT_RUNTIME_ASSET`. Do not copy them into `art/product_assets/`, change a renderer path, or claim runtime validation.

- [ ] **Step 5: Stop for the final visual-pixel disposition**

Proceed only when the user explicitly approves the assembled Core Board v02 bundle. A request to continue implementation is not treated as approval of pixels not yet generated.

### Task 3: Establish the v02 asset contract with failing tests

**Files:**
- Modify: `tests/demo/test_product_board_renderer.gd`
- Rename: `tests/python/test_sx_dec_063_terrain_asset_promotion.py` → `tests/python/test_sx_dec_063_core_board_asset_promotion.py`

**Interfaces:**
- Consumes: the fixed target-path table from Task 1.
- Produces: a failing renderer/manifest contract that requires every v02 image, a valid `Texture2D` load, exact v01 rollback presence, and runtime-verified manifest state.

- [ ] **Step 1: Add the exact GDScript v02 path/load assertion block**

Insert this before `renderer.free()` in `tests/demo/test_product_board_renderer.gd`:

```gdscript
var expected_v02_paths := {
	"board_terrain": "art/product_assets/ed_hybrid_v2/board/board_terrain_playfield_v02.png",
	"train": "art/product_assets/ed_hybrid_v2/core/core_train_locomotive_blue_normal_v02.png",
	"rail_straight": "art/product_assets/ed_hybrid_v2/core/core_rail_straight_normal_v02.png",
	"rail_curve": "art/product_assets/ed_hybrid_v2/core/core_rail_curve_normal_v02.png",
	"rail_crossing": "art/product_assets/ed_hybrid_v2/core/core_rail_crossing_normal_v02.png",
	"rail_switch": "art/product_assets/ed_hybrid_v2/core/core_rail_switch_three_way_normal_v02.png",
	"start_marker": "art/product_assets/ed_hybrid_v2/core/core_marker_start_normal_v02.png",
	"route_end_marker": "art/product_assets/ed_hybrid_v2/core/core_marker_route_end_normal_v02.png",
	"station_red": "art/product_assets/ed_hybrid_v2/core/core_station_red_normal_v02.png",
	"station_blue": "art/product_assets/ed_hybrid_v2/core/core_station_blue_normal_v02.png",
	"station_yellow": "art/product_assets/ed_hybrid_v2/core/core_station_yellow_normal_v02.png",
	"cargo_red": "art/product_assets/ed_hybrid_v2/core/core_cargo_star_red_normal_v02.png",
	"cargo_blue": "art/product_assets/ed_hybrid_v2/core/core_cargo_star_blue_normal_v02.png",
	"cargo_yellow": "art/product_assets/ed_hybrid_v2/core/core_cargo_star_yellow_normal_v02.png",
}
assert_equal(
	renderer.product_visual_asset_paths_for_test(),
	expected_v02_paths,
	"core board v02 must replace only the existing visual slot paths"
)
for asset_key: String in expected_v02_paths:
	assert_true(
		renderer.loaded_product_visuals_for_test().get(asset_key, false),
		"core board v02 asset must import as Texture2D: %s" % asset_key
	)
```

- [ ] **Step 2: Replace the renamed Python test with the complete asset-set contract**

Use this constant table in the renamed test:

```python
EXPECTED_ASSETS = {
    "SX-BOARD-TERRAIN-002": ("art/product_assets/ed_hybrid_v2/board/board_terrain_playfield_v02.png", (1672, 941), False),
    "SX-CORE-TRAIN-002": ("art/product_assets/ed_hybrid_v2/core/core_train_locomotive_blue_normal_v02.png", (128, 96), True),
    "SX-CORE-RAIL-STRAIGHT-002": ("art/product_assets/ed_hybrid_v2/core/core_rail_straight_normal_v02.png", (64, 64), True),
    "SX-CORE-RAIL-CURVE-002": ("art/product_assets/ed_hybrid_v2/core/core_rail_curve_normal_v02.png", (64, 64), True),
    "SX-CORE-RAIL-CROSSING-002": ("art/product_assets/ed_hybrid_v2/core/core_rail_crossing_normal_v02.png", (64, 64), True),
    "SX-CORE-RAIL-SWITCH-002": ("art/product_assets/ed_hybrid_v2/core/core_rail_switch_three_way_normal_v02.png", (64, 64), True),
    "SX-CORE-MARKER-START-002": ("art/product_assets/ed_hybrid_v2/core/core_marker_start_normal_v02.png", (64, 64), True),
    "SX-CORE-MARKER-END-002": ("art/product_assets/ed_hybrid_v2/core/core_marker_route_end_normal_v02.png", (64, 64), True),
    "SX-CORE-STATION-RED-002": ("art/product_assets/ed_hybrid_v2/core/core_station_red_normal_v02.png", (64, 64), True),
    "SX-CORE-STATION-BLUE-002": ("art/product_assets/ed_hybrid_v2/core/core_station_blue_normal_v02.png", (64, 64), True),
    "SX-CORE-STATION-YELLOW-002": ("art/product_assets/ed_hybrid_v2/core/core_station_yellow_normal_v02.png", (64, 64), True),
    "SX-CORE-CARGO-RED-002": ("art/product_assets/ed_hybrid_v2/core/core_cargo_star_red_normal_v02.png", (64, 64), True),
    "SX-CORE-CARGO-BLUE-002": ("art/product_assets/ed_hybrid_v2/core/core_cargo_star_blue_normal_v02.png", (64, 64), True),
    "SX-CORE-CARGO-YELLOW-002": ("art/product_assets/ed_hybrid_v2/core/core_cargo_star_yellow_normal_v02.png", (64, 64), True),
}
```

For every manifest entry, assert that its stored SHA-256 equals `hashlib.sha256(path.read_bytes()).hexdigest()`, that PNG dimensions equal the table, that alpha-required entries have PNG color type `4` or `6`, and that `runtime_consumer` is the literal `game/demo/presentation/product_board_renderer.gd::PRODUCT_VISUAL_ASSET_PATHS[...]` value for that entry's matching visual-slot name. Assert v01 terrain, all four v01 rail images, all three v01 stations, all three v01 cargo images, v01 train, and both v01 markers remain files on disk. Assert the manifest status is `APPROVED_GITHUB_PRESERVED_RUNTIME_VERIFIED_AUTOMATED` and the renderer contains every exact v02 source string.

- [ ] **Step 3: Observe the required RED state**

Run:

```powershell
& 'C:\Users\user\Downloads\Godot_v4.7.1-stable_win64.exe\Godot_v4.7.1-stable_win64_console.exe' --headless --path . --script res://tests/run_tests.gd
& 'C:\Users\user\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' tests/python/test_sx_dec_063_core_board_asset_promotion.py -v
```

Expected: GDScript fails because the current renderer still uses v01 paths; Python fails because the 13 approved final files and their full manifest records do not yet exist. No unrelated failure is accepted as RED evidence.

- [ ] **Step 4: Commit no production change while the contract is red**

Keep this checkpoint uncommitted until the final image bundle is selected and the renderer is made green in Task 5.

### Task 4: Promote the user-approved v02 binaries and provenance records

**Files:**
- Create: the 13 final v02 PNGs at the target paths from Task 1.
- Modify: `art/product_assets/ed_hybrid_v2/manifest.json`
- Modify: `docs/visual-references/sx-dec-063-core-board-v02/CORE_BOARD_V02_CANDIDATE_RECORD.md`
- Modify: `docs/ASSET_RIGHTS_AND_PROVENANCE_RECORD.md`

**Interfaces:**
- Consumes: the final user-approved image bundle and the failing assertions from Task 3.
- Produces: locally tracked original v02 source binaries with a complete provenance/consumer contract, but still no changed renderer path until Task 5.

- [ ] **Step 1: Create the repeatable Godot resampling utility before placing final source bytes**

Create `tools/prepare_sx_dec_063_core_board_asset.gd` as a Godot command-line utility. It must accept the image-model output path, final output path, exact width, and exact height; load through `Image`, resize with `Image.INTERPOLATE_LANCZOS`, preserve alpha, and save a PNG. It must fail with a non-zero exit if an input cannot be loaded, if a target dimension is non-positive, if the output write fails, or if the written image dimensions do not exactly match the requested dimensions. The utility is packaging only: it may scale an approved image-model output, but must not draw, paint, synthesize, vectorize, or alter its content.

- [ ] **Step 2: Create final dimensions from the selected image-model outputs**

For every approved candidate, use the Task 1 target path as the resampling output and its declared 64×64 or 128×96 size. The source object must remain centered and readable at the declared target footprint; any source that fails the Task 2 check is regenerated rather than manually painted or vector-redrawn. Keep the selected native image-model output outside `art/product_assets/` as candidate evidence, and save only the deterministic scaled final binary to the production target.

- [ ] **Step 3: Import through Godot without source-metadata edits**

Run:

```powershell
& 'C:\Users\user\Downloads\Godot_v4.7.1-stable_win64.exe\Godot_v4.7.1-stable_win64_console.exe' --headless --import --path .
```

Expected: each final PNG receives a Godot texture import descriptor. If the editor rewrites an unrelated tracked `.import` file only for line endings, restore that unrelated file before staging; do not commit it.

- [ ] **Step 4: Write complete asset manifest entries**

Set `manifest.json` status to `APPROVED_GITHUB_PRESERVED_RUNTIME_PENDING`. Include fourteen entries: the existing `SX-BOARD-TERRAIN-002` plus every Task 3 asset ID. Each entry contains `path`, dimensions, SHA-256 from the exact final bytes, `visual_role`, `runtime_consumer`, `consumer_status: PENDING_RENDERER_PATH`, `source_candidate_id`, `user_approval_ref`, and `runtime_connection_status: NOT_CONNECTED`.

- [ ] **Step 5: Record exact provenance and review disposition**

For each new asset, record the built-in image-model service, the full prompt, HGB r02 style-reference role, input-rights statement, no-third-party-source statement, final file SHA-256, dimensions, target consumer, user approval message, and `APPROVED_GITHUB_PRESERVED_RUNTIME_PENDING` in both provenance owners. State clearly that the reference sheet was not embedded, cropped, or shipped.

- [ ] **Step 6: Re-run the red tests and classify failures**

Run the Task 3 commands again.

Expected: final files/imports/provenance exist; the GDScript contract remains red only because the renderer still points to v01, and the Python contract remains red only because runtime-verified statuses and v02 consumer values are not yet true.

### Task 5: Switch only the fourteen visual paths and make the contract green

**Files:**
- Modify: `game/demo/presentation/product_board_renderer.gd`
- Modify: `art/product_assets/ed_hybrid_v2/manifest.json`
- Modify: `docs/visual-references/sx-dec-063-core-board-v02/CORE_BOARD_V02_CANDIDATE_RECORD.md`
- Modify: `docs/ASSET_RIGHTS_AND_PROVENANCE_RECORD.md`
- Modify: `tests/demo/test_product_board_renderer.gd`
- Modify: `tests/python/test_sx_dec_063_core_board_asset_promotion.py`

**Interfaces:**
- Consumes: final v02 source files/imports and the red contract.
- Produces: all fourteen `Texture2D` slots loaded from v02 with v01 rollback binaries still available.

- [ ] **Step 1: Replace only the fourteen map values**

In `PRODUCT_VISUAL_ASSET_PATHS`, change the existing values to the exact v02 paths from Task 3. Do not alter `_load_product_visuals()`, texture filtering, draw order, `_draw_track_piece()`, `_draw_marker()`, input code, or a palette constant.

- [ ] **Step 2: Promote only after the actual load contract becomes true**

After the renderer paths load all fourteen textures, change each v02 manifest entry to:

```json
{
  "consumer_status": "VERIFIED_AUTOMATED_RUNTIME",
  "runtime_connection_status": "VERIFIED"
}
```

Change the v02 manifest and provenance/candidate-record status to `APPROVED_GITHUB_PRESERVED_RUNTIME_VERIFIED_AUTOMATED`. Keep physical/human fields explicitly `NOT_RUN`.

- [ ] **Step 3: Run focused GREEN checks**

Run:

```powershell
& 'C:\Users\user\Downloads\Godot_v4.7.1-stable_win64.exe\Godot_v4.7.1-stable_win64_console.exe' --headless --path . --script res://tests/run_tests.gd
& 'C:\Users\user\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' tests/python/test_sx_dec_063_core_board_asset_promotion.py -v
```

Expected: the renderer reports every v02 slot as a `Texture2D`; visual-layer order and station-service procedural ownership assertions remain green; all final PNG hashes, alpha/dimensions, manifest paths, consumers, and retained v01 files pass.

- [ ] **Step 4: Commit the smallest green implementation**

```powershell
git add game/demo/presentation/product_board_renderer.gd tests/demo/test_product_board_renderer.gd tests/python/test_sx_dec_063_core_board_asset_promotion.py art/product_assets/ed_hybrid_v2 docs/visual-references/sx-dec-063-core-board-v02 docs/ASSET_RIGHTS_AND_PROVENANCE_RECORD.md
git commit -m "art: connect core board v02 assets"
```

### Task 6: Prove the live visual consumer and update current evidence owners

**Files:**
- Modify: `docs/decisions/SX_DEC_063_HYBRID_MINIATURE_DIORAMA_VISUAL_PRODUCTION_ALIGNMENT.md`
- Modify: `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
- Modify: `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
- Modify: `기획서/40_표현/TARGET_BUILD_SCREEN_SURFACE_AND_VISUAL_COVERAGE.md`

**Interfaces:**
- Consumes: Task 5 green tests and the active Hera Godot session.
- Produces: exact runtime screenshots and current-owner status that distinguishes automated runtime from unrun physical/human gates.

- [ ] **Step 1: Reload and inspect the exact editor project**

Run:

```powershell
hera --instance 2072 scene open res://game/main/main.tscn
hera --instance 2072 game run
hera --instance 2072 game ui tree
hera --instance 2072 screenshot --runtime --analyze
```

Expected: the running game is the Switchy project and exposes the existing title/briefing/build flow. If the editor reports a source reload, wait for reload completion and repeat the command; do not infer a successful visual result from source paths alone.

- [ ] **Step 2: Reach representative BUILD and RUN states through existing UI**

Use `game qa discover` and semantic `game click` commands to reach the existing BUILD board and a route-control RUN state. Capture both at the current 1280×720 window override. Do not use source-code simulation or a planning PNG as visual evidence.

- [ ] **Step 3: Audit the actual capture at gameplay scale**

Verify and record all ten observations:

```text
1. v02 terrain is visible below the live grid
2. straight/curve/crossing/switch ports remain aligned to cell edges
3. off-track stations do not imply rail through the station cell
4. four cardinal service frames remain visible around each station
5. cargo remains distinct by color, star silhouette, and live marker label
6. compact locomotive remains visible over routes
7. start and route-end markers differ from cargo/stations
8. selected route, alternate route, and locked cue remain above rail art
9. HUD and localized live text remain unclipped
10. no image contains pseudo-text, a watermark, or a framed documentation composition
```

- [ ] **Step 4: Update only truthful evidence states**

Record `RUNTIME_MACHINE_CAPTURE_VERIFIED` only if the capture demonstrates the exact v02 consumer paths at both representative states. Mark Candidate 004 `HISTORICAL_SUPERSEDED_BY_CORE_BOARD_V02_PLAYER_FACING_BYTE_CHANGE`; do not delete it. Record Windows physical/audio, Android, five-person, player experience, release rights, and production cutover as `NOT_RUN` or their prior blocker state.

- [ ] **Step 5: Commit current-owner readback**

```powershell
git add docs/decisions/SX_DEC_063_HYBRID_MINIATURE_DIORAMA_VISUAL_PRODUCTION_ALIGNMENT.md 기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md 기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md 기획서/40_표현/TARGET_BUILD_SCREEN_SURFACE_AND_VISUAL_COVERAGE.md
git commit -m "docs: record core board v02 runtime evidence"
```

### Task 7: Run full regression, five adversarial loops, and the new-candidate gate

**Files:**
- Modify only if a review finding requires a documented correction: the exact Task 5–6 owner/test files.

**Interfaces:**
- Consumes: exact green implementation head and live runtime captures.
- Produces: full machine evidence, a clean five-loop review receipt, and either a new exact package candidate or an explicit package blocker.

- [ ] **Step 1: Run the project validation and full automated suites**

Run:

```powershell
& 'C:\Users\user\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' tools/validate_project_contract.py
& 'C:\Users\user\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' -m unittest discover -s tests/python -p 'test_*.py' -v
& 'C:\Users\user\Downloads\Godot_v4.7.1-stable_win64.exe\Godot_v4.7.1-stable_win64_console.exe' --headless --import --path .
& 'C:\Users\user\Downloads\Godot_v4.7.1-stable_win64.exe\Godot_v4.7.1-stable_win64_console.exe' --headless --path . --script res://tests/run_tests.gd
```

Expected: all invoked checks are green. A missing local export template or package credential is reported as the exact blocker, never as a pass.

- [ ] **Step 2: Execute five full adversarial loops**

For each loop, re-read the complete changed set, run the affected checks, correct any valid finding, and rerun all relevant checks:

```text
Loop 1 — finite rules, grid input, rotation, station service, route/lock, and presentation ownership.
Loop 2 — raw PNG, alpha, import descriptor, source path, Texture2D load, SHA, manifest, and v01 rollback.
Loop 3 — 64/128 target readability, contrast, hierarchy, crop, safe bounds, live text, route/service layering, and repeated-input stability.
Loop 4 — prompt/reference independence, no embedded text/UI, source-generation provenance, user approval record, and rights ceiling.
Loop 5 — Candidate 004 invalidation, package evidence, exact source SHA, physical/audio/device/human ceiling, protected PRs, and no scope expansion.
```

- [ ] **Step 3: Run the existing package workflow on the exact implementation head**

Read the current package command from `evidence/acceptance/post_sx_dec_060_candidate.json` and `.github/workflows/windows-demo-export.yml`, then run only the repository-supported local package route. Record the exact head and artifact hashes if it succeeds. If the supported local package route cannot run because an export template or tool is absent, retain `PACKAGE_NOT_RUN_LOCAL_ENVIRONMENT` and do not move the candidate pointer.

- [ ] **Step 4: Commit any finding-driven correction separately**

```powershell
git add game/demo/presentation/product_board_renderer.gd tests/demo/test_product_board_renderer.gd tests/python/test_sx_dec_063_core_board_asset_promotion.py art/product_assets/ed_hybrid_v2 docs/visual-references/sx-dec-063-core-board-v02 docs/ASSET_RIGHTS_AND_PROVENANCE_RECORD.md docs/decisions/SX_DEC_063_HYBRID_MINIATURE_DIORAMA_VISUAL_PRODUCTION_ALIGNMENT.md 기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md 기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md 기획서/40_표현/TARGET_BUILD_SCREEN_SURFACE_AND_VISUAL_COVERAGE.md
git commit -m "fix: resolve core board v02 review finding"
```

Use this commit only when a validated finding required a correction. If all five loops are clean, create no empty review commit.

- [ ] **Step 5: Final exact-head and rollback readback**

Run:

```powershell
git status --short --branch
git log -1 --format='%H%n%s'
git diff origin/main...HEAD --check
```

Expected: only this workstream’s intentional files differ from `origin/main`; v01 source paths remain in Git; every current owner agrees on the v02 state and remaining human gates.

## Spec Coverage Self-Review

| Specification requirement | Implementing task |
| --- | --- |
| Original v02 board family with exact existing consumers | Tasks 1–5 |
| HGB used only as style reference | Tasks 1–2 and 4 |
| Final user disposition before runtime promotion | Task 2, Step 5 |
| TDD with observed RED and GREEN | Tasks 3–5 |
| Renderer-only change and procedural state ownership | Tasks 3, 5, and 6 |
| Provenance, SHA-256, rights, and v01 rollback | Tasks 4–5 and 7 |
| Actual editor/runtime capture | Task 6 |
| Five adversarial loops and evidence ceiling | Task 7 |
| No gameplay/UI/locale/audio/scope drift | Global constraints and Tasks 5–7 |

Placeholder scan requirements: no `TODO`, `TBD`, or unspecified asset path appears in this plan. The only dynamic values are final SHA-256 digests generated from the user-approved binary files, which Task 4 requires the manifest and Python test to read back exactly from those final bytes.
