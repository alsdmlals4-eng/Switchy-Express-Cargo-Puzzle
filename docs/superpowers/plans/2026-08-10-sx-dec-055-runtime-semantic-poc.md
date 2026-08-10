# SX-DEC-055 Runtime Semantic POC Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Apply superpowers:test-driven-development for every production change and superpowers:verification-before-completion before any PASS/completion claim.

**Goal:** Prove that the approved 73-product semantic asset package can be consumed by the finite demo through manifest-backed presentation adapters for representative RUN, BUILD, route-control, and causal-feedback states without changing gameplay/domain authority.

**Architecture:** Add one presentation-owned `SemanticAssetCatalog` plus one pure `SemanticRuntimeState` resolver. Project the already-existing manual-load read state into the presenter model, then let HUD/board/route/event presentation consume catalog compositions. Keep procedural rail/switch geometry, Korean text, domain events, ruleset/save identity, and existing `DemoEffects` fallback authority unchanged. Add a separate semantic event overlay for approved VFX inputs and Reduced Motion proof. Do not create a combo gameplay signal; if no existing presentation-readable combo trigger exists, keep combo trigger deferred while proving catalog resolution.

**Tech Stack:** Godot 4.7.1-stable, GDScript, `Control`/`CanvasItem` drawing, `Texture2D`, `FileAccess`/JSON, Tween/SceneTreeTimer only in presentation, repository custom headless runner (`res://tests/run_tests.gd`), GitHub Actions Project Contract/GUT/Godot/Thin/Windows Demo Export.

## Global Constraints

- Decision authority: `SX-DEC-055`.
- Approved design: `docs/superpowers/specs/2026-08-10-runtime-semantic-poc-design.md`.
- Semantic source authority: `SX-DEC-054`; product visual authority: `SX-DEC-053`; component authority: `SX-DEC-050`; Godot authoring boundary: `SX-DEC-045`.
- Implementation baseline for this plan: `34624a5d2a93306cd2b3c72dee6ce0035b751279` plus the docs-only DoR closure that contains this plan. Re-read `main` immediately before implementation and rebase the exact-file assumptions if later commits touched any listed file.
- Project remains pinned to Base v9.4.3. Upstream Base was observed at `53e63f7ebefbb5b2fc0dc528e335252692801421` during DoR refresh; this observation does not repin or silently import the upstream feature-spec proposal.
- Domain/gameplay classes must never know product PNG paths, semantic manifest keys, animation timing, or Reduced Motion mode.
- No changes to LIFO, cargo eligibility, route topology, route-control cycle order, U-turn, occupied lock, time limit, scoring, failure priority, save/ruleset identity, map content, or retry identity.
- No new product PNG, atlas interpretation, semantic sidecar meaning, `.asset-vault` byte, `project.godot`, audio redesign, settings screen, or persisted accessibility preference.
- Existing Korean text and procedural board/route drawing stay present as fallback/redundancy during the POC.
- `run_stack_unloading_v01` is not the predicted unload-group asset. Predicted contiguous TOP grouping uses the explicit `run_stack_unload_group_v01` semantic primitive.
- Combo must resolve from VFX semantic authority, but a runtime trigger remains `RUNTIME_TRIGGER_DEFERRED_NO_EXISTING_SEAM` unless a pre-existing presentation-readable combo seam is found without domain modification.
- Reduced Motion must preserve the same VFX `information_key` and input asset as standard mode; only motion treatment changes.
- Every production-code task follows RED → verify RED → minimal GREEN → focused GREEN → commit.
- Hosted Windows Demo Export is packaging/build evidence only, never Windows physical runtime PASS.
- Windows physical runtime, Android device, connected physical editor, and broader human validation remain `NOT_RUN` after automated POC completion unless separately executed.

## Exact Verification Commands

Use the repository root as working directory.

Custom Godot suite, matching CI arguments:

```bash
godot --headless --path . --script res://tests/run_tests.gd
```

The authoritative GitHub Actions equivalent uses Godot 4.7.1 and the same argument vector:

```bash
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tests/run_tests.gd
```

Static semantic package guards:

```bash
python tools/validate_final_ed_product_asset_promotion.py
python tools/validate_sx_dec_054_run_semantic_assets.py
python tools/validate_sx_dec_054_build_semantic_assets.py
python tools/validate_sx_dec_054_vfx_semantic_assets.py
```

Before merge, require the final unchanged PR head to pass the applicable hosted workflows: Project Contract, GUT 9.7.1 Tests, Godot Tests (including the automated Switchy real-project live-editor Pilot), Validate Thin Adapter Migration, and Windows Demo Export when triggered.

---

## Planned File Structure

### New presentation infrastructure

```text
game/demo/presentation/semantic_asset_catalog.gd
    Reads immutable SX-DEC-053/054 manifests and resolves approved compositions/textures.

game/demo/presentation/semantic_runtime_state.gd
    Pure presentation-state mapping from existing model/snapshot/event data.

game/demo/presentation/semantic_texture_stack.gd
    Generic Control that draws all texture inputs of one approved composition.

game/demo/presentation/semantic_event_overlay.gd
    Presentation-only VFX event display plus programmatic Reduced Motion seam.
```

### Existing runtime surfaces to modify

```text
game/finite/presentation/finite_slice_presenter.gd
game/finite/main/finite_slice_session_controller.gd
game/demo/presentation/product_hud.gd
game/demo/presentation/product_hud.tscn
game/demo/presentation/product_board_renderer.gd
game/demo/presentation/route_control_overlay.gd
game/demo/product_finite_slice.gd
game/demo/product_finite_slice.tscn
```

`game/demo/presentation/demo_effects.gd` is expected to remain unchanged unless implementation proves a presentation-only reuse is strictly smaller. If it must change, preserve `MAX_EFFECT_DURATION = 1.0` and the existing domain-invariance test.

### New/focused tests

```text
tests/demo/test_semantic_asset_catalog.gd
tests/demo/test_semantic_runtime_state.gd
tests/demo/test_semantic_event_overlay.gd
tests/demo/test_runtime_semantic_poc.gd
```

Existing tests to extend rather than replace:

```text
tests/finite/presentation/test_finite_slice_presenter.gd
tests/finite/presentation/test_finite_slice_session_controller.gd
tests/demo/test_product_hud.gd
tests/demo/test_product_board_ghost.gd
tests/demo/test_route_control_runtime_ui.gd
tests/demo/test_demo_effects_authority.gd
tests/run_tests.gd
```

---

## Task 1: Add the manifest-backed SemanticAssetCatalog

**Files:**
- Create: `tests/demo/test_semantic_asset_catalog.gd`
- Modify: `tests/run_tests.gd`
- Create: `game/demo/presentation/semantic_asset_catalog.gd`

**Required interface:**

```gdscript
class_name SemanticAssetCatalog
extends RefCounted

func load_default() -> bool
func is_ready() -> bool
func errors() -> Array[String]
func composition(component: StringName, state: StringName) -> Dictionary
func vfx_composition(event: StringName, reduced_motion: bool) -> Dictionary
func base_asset_by_authoritative_slice(slice_name: StringName) -> Dictionary
func textures_for(record: Dictionary) -> Array[Texture2D]
```

Implementation constants must point only to:

```text
res://art/product_assets/ed_hybrid_v1/manifest.json
res://art/product_assets/ed_hybrid_v1/semantic_manifest_sx_dec_054.json
res://art/product_assets/ed_hybrid_v1/semantic_manifest_sx_dec_054_build_2b.json
res://art/product_assets/ed_hybrid_v1/semantic_manifest_sx_dec_054_vfx_2c.json
```

Catalog rules:
- validate owner IDs/batches (`SX-DEC-053`, `SX-DEC-054/RUN_2A`, `BUILD_2B`, `VFX_2C`) at load;
- index `semantic_compositions` without rewriting them;
- index base assets by exact path and `authoritative_slice_name` when present;
- convert manifest `art/...` inputs to `res://art/...` only for `load()`;
- unknown component/state/event returns `{}` and records no substituted state;
- a missing texture makes that lookup fail deterministically; gameplay continues independently;
- no runtime write to any manifest.

- [ ] **Step 1.1 — RED:** Add `test_semantic_asset_catalog.gd` using a path string, not a preload of the missing production script. Assert `ResourceLoader.exists("res://game/demo/presentation/semantic_asset_catalog.gd", "Script")`, then, if present, assert exact lookups for:
  - `stack_hud/compact` → `run_stack_compact_v01.png`;
  - `load_mode/manual_held` contains shell + manual marker + held marker;
  - `placement_preview/valid` resolves from BUILD sidecar;
  - `preflight_notice/focused_location` resolves from BUILD sidecar;
  - VFX `route_end` standard/reduced share the same `information_key` and exact input;
  - VFX `combo` resolves to `run_combo_feedback_static_v01.png`;
  - base authoritative slice `run_stack_empty_v01` resolves to the exact SX-DEC-053 product path;
  - unknown lookup returns `{}`.
- [ ] Add the new test to `tests/run_tests.gd` adjacent to other demo presentation tests.
- [ ] Run `godot --headless --path . --script res://tests/run_tests.gd` and verify RED is caused by the missing catalog assertion, not an unrelated regression.
- [ ] **Step 1.2 — GREEN:** Implement only the catalog and JSON/index helpers needed by the test.
- [ ] Re-run the custom Godot suite; require the new catalog test GREEN.
- [ ] Run all four semantic package validators above; require PASS and confirm the manifests/product bytes are unchanged.
- [ ] Commit: `feat: add semantic asset runtime catalog`

## Task 2: Add pure semantic runtime-state resolution

**Files:**
- Create: `tests/demo/test_semantic_runtime_state.gd`
- Modify: `tests/run_tests.gd`
- Create: `game/demo/presentation/semantic_runtime_state.gd`

**Required interface:**

```gdscript
class_name SemanticRuntimeState
extends RefCounted

static func stack_primary_state(model: Dictionary) -> StringName
static func contiguous_top_group_size(tokens: Array) -> int
static func manual_load_state(model: Dictionary) -> StringName
static func auto_load_state(model: Dictionary) -> StringName
static func preflight_summary_state(model: Dictionary) -> StringName
static func preflight_focus_state(model: Dictionary) -> StringName
static func placement_state(ghost: Dictionary, snapshot: Dictionary) -> StringName
static func route_target_state(target: Dictionary) -> StringName
static func terminal_event(outcome: StringName, reason: StringName) -> StringName
```

State mapping contract:
- Stack primary priority: `PAUSED → paused`; unload visual/phase `UNLOADING → unloading`; zero tokens → `empty`; count `>=32 → 32plus`; `>=16 → 16plus`; `>=8 → 8plus`; otherwise `compact`.
- `contiguous_top_group_size` walks backward from the TOP token and counts identical `cargo_type`; it is descriptive only and never changes unload eligibility.
- Manual state: paused → `paused_disabled`; active held → `manual_held`; otherwise `manual_idle`.
- Auto state: paused → `paused_disabled`; active true → `auto_on`; otherwise `auto_off`.
- Preflight summary: passed/start enabled → `clear`; multiple problem cells → `multi_issue_summary`; otherwise blocking/non-pass → `primary_issue`.
- Preflight focus: non-empty `problem_cells` → `focused_location`; otherwise empty key.
- Placement priority: empty/non-BUILD ghost → empty; invalid → `invalid`; existing piece at ghost cell → `replacement_preview`; non-zero selected rotation → `rotate_preview`; else `valid`.
- Route target: locked → `occupied_locked`; selected → `selected`; otherwise `unselected`. `inactive` is only for an explicitly inactive presentation context, never inferred by changing target geometry.
- Terminal mapping: SUCCESS → `success`; FAILURE/ROUTE_END → `route_end`; FAILURE/TIME_EXPIRED → `time_expired`; other failure → `failure`.

- [ ] **Step 2.1 — RED:** Add pure unit assertions covering each state and boundary counts 0/1/7/8/15/16/31/32, TOP contiguous grouping, paused priority, placement replacement/rotation/invalid priority, route locked priority, and terminal mapping.
- [ ] Register the test in `tests/run_tests.gd` and run the custom suite; verify focused RED for missing resolver.
- [ ] **Step 2.2 — GREEN:** Implement pure static functions only; no Node, domain object, manifest, or filesystem dependency.
- [ ] Run the custom suite; require GREEN.
- [ ] Commit: `feat: add semantic runtime state resolver`

## Task 3: Project actual manual-load state into the finite presentation model

**Files:**
- Modify: `tests/finite/presentation/test_finite_slice_presenter.gd`
- Modify: `tests/finite/presentation/test_finite_slice_session_controller.gd`
- Modify: `game/finite/presentation/finite_slice_presenter.gd`
- Modify: `game/finite/main/finite_slice_session_controller.gd`

**Interface change:** Keep existing call compatibility while adding the read-only field.

```gdscript
func show_run(
    run_state: Variant,
    load_order: Array[StringName],
    auto_load_active: bool,
    final_cost: int,
    manual_load_active: bool = false
) -> void
```

Model contract:
- `_reset_model`, BUILD, and result model contain `manual_load_active=false`;
- RUN/UNLOADING model contains the actual getter value;
- PAUSED contains false because `FiniteGameplayInputState.set_paused(true)` already clears manual hold;
- no UI-local manual-load truth is introduced.

- [ ] **Step 3.1 — RED presenter:** Extend presenter test to assert the model always contains `manual_load_active` and that a five-argument `show_run(..., manual_load_active=true)` projects true without affecting `auto_load_active`.
- [ ] Run the suite; verify RED on missing field/behavior.
- [ ] **Step 3.2 — GREEN presenter:** Add the field and backward-compatible optional parameter.
- [ ] Re-run; require presenter test GREEN.
- [ ] **Step 3.3 — RED controller:** Extend session-controller test using the existing finite run setup/fixture pattern to enter RUN, issue `LOAD_ACTIVE=true`, and assert `controller.model()["manual_load_active"] == true`; then pause and assert it becomes false.
- [ ] Run; verify RED because controller has not yet passed the getter into presenter.
- [ ] **Step 3.4 — GREEN controller:** In `_refresh_run_or_result`, pass `_run_session.input_state.is_manual_load_active()` as the fifth `show_run` argument. Do not change input-state behavior.
- [ ] Run the full custom suite; require GREEN.
- [ ] Commit: `feat: project manual load state to presentation`

## Task 4: Render Stack, load-mode, and preflight semantic compositions in ProductHUD

**Files:**
- Create: `game/demo/presentation/semantic_texture_stack.gd`
- Modify: `tests/demo/test_product_hud.gd`
- Modify: `game/demo/presentation/product_hud.gd`
- Modify: `game/demo/presentation/product_hud.tscn`

**SemanticTextureStack interface:**

```gdscript
class_name SemanticTextureStack
extends Control

func set_textures(textures: Array[Texture2D]) -> void
func texture_paths_for_test() -> Array[String]
```

Drawing rule: draw all composition inputs in declared manifest order in the same local rect; set nearest texture filtering for pixel-art readability; mouse filter must remain IGNORE.

**HUD node additions:**
- `StackPanel/StackLayout/StackSemanticBadge` using `SemanticTextureStack`, minimum size sufficient for the 64×24 semantic stack primitive;
- one manual-load semantic stack adjacent to `RunToolbar/LoadButton`;
- one auto-load semantic stack adjacent to `RunToolbar/AutoButton`;
- one preflight semantic stack inside/adjacent to `ProblemBanner`, while `ProblemText` remains visible.

**HUD test seam:**

```gdscript
func semantic_state_for_test() -> Dictionary
```

Return only presentation diagnostics such as selected state keys and resolved input paths; do not expose mutable catalog internals.

- [ ] **Step 4.1 — RED:** Extend `test_product_hud.gd` to require the new semantic nodes/test seam. Apply BUILD/RUNNING/PAUSED models and assert:
  - compact Stack path appears for a small non-empty stack;
  - manual held uses shell + manual + held composition when `manual_load_active=true`;
  - auto on uses the approved auto-on composition when `auto_load_active=true`;
  - PAUSED selects paused Stack and paused-disabled load composition;
  - failed BUILD selects preflight primary/multi issue; passed BUILD selects clear;
  - existing Korean text/button assertions remain unchanged.
- [ ] Run the suite; verify RED on absent semantic HUD support.
- [ ] **Step 4.2 — GREEN:** Instantiate one catalog per HUD, load it in `_ready`, compute keys with `SemanticRuntimeState`, resolve composition inputs, and feed `SemanticTextureStack` nodes. For empty Stack resolve the exact base authoritative slice `run_stack_empty_v01`; for `32plus` resolve `run_stack_32plus_v01`; for unloading use exact `run_stack_unloading_v01` only as the committed unloading presentation, never as unload-group prediction.
- [ ] Keep `StackText`, `ProblemText`, buttons, touch sizes, visibility logic, and signals unchanged.
- [ ] Re-run the full custom suite; require GREEN.
- [ ] Commit: `feat: bind semantic assets to runtime HUD`

## Task 5: Add BUILD placement and focused-preflight semantic reinforcement to ProductBoardRenderer

**Files:**
- Modify: `tests/demo/test_product_board_ghost.gd`
- Modify: `game/demo/presentation/product_board_renderer.gd`

**Test seam:**

```gdscript
func semantic_build_descriptor_for_test() -> Dictionary
```

Return the current placement state, resolved input paths, and focused-preflight input paths; keep `ghost_descriptor_for_test()` unchanged.

Rendering rules:
- procedural `_draw_track_piece` remains the committed-rail and preview geometry authority;
- semantic placement input(s) are reinforcement drawn within the existing ghost cell rect after the procedural ghost;
- focused preflight composition may reinforce existing `problem_cells`, but must not create/alter problem cells;
- invalid geometry remains determined by existing `_ghost_descriptor()` only;
- replacement/rotation state is derived only from current snapshot/ghost data.

- [ ] **Step 5.1 — RED:** Extend `test_product_board_ghost.gd` to assert semantic descriptor valid/invalid states while preserving every existing ghost assertion. Add replacement and rotated-preview snapshots and assert the expected semantic state keys.
- [ ] Run; verify RED for missing semantic descriptor.
- [ ] **Step 5.2 — GREEN:** Add catalog/resolver use and draw approved composition textures with `draw_texture_rect`/equivalent CanvasItem API. Do not alter `_track_ports`, `_ghost_descriptor`, board hit testing, or committed track drawing.
- [ ] Re-run the suite; require GREEN and all existing board tests unchanged.
- [ ] Commit: `feat: reinforce build states with semantic assets`

## Task 6: Reinforce route-control states without changing direction geometry

**Files:**
- Modify: `tests/demo/test_route_control_runtime_ui.gd`
- Modify: `game/demo/presentation/route_control_overlay.gd`

**New test seam:**

```gdscript
func semantic_target_descriptors_for_test() -> Array[Dictionary]
```

Each descriptor may add only presentation fields such as `semantic_state` and `input_paths`; it must reference but never mutate the existing target descriptor.

- [ ] **Step 6.1 — RED:** In the route runtime test, capture `direction_targets_for_test()` and assert exact cell/port/selected/locked/cycle_count/hit_rect values before semantic lookup. Require `semantic_target_descriptors_for_test()` and verify selected/unselected/occupied-locked keys resolve to the RUN sidecar overlays.
- [ ] Verify that calling the semantic test seam leaves a second `direction_targets_for_test()` result deeply equal to the first.
- [ ] Keep the existing graph `next_cell` assertions for straight/right/left transitions and add no new route command.
- [ ] Run; verify focused RED on absent semantic seam.
- [ ] **Step 6.2 — GREEN:** Draw state reinforcement near each existing arrow target using its existing `hit_rect`/target center. Do not change `_direction_targets`, `_direction_targets_for_switch`, cycle counts, target size, lock logic, `_gui_input`, or `_draw_arrow` direction vectors.
- [ ] Re-run full custom suite; require GREEN.
- [ ] Commit: `feat: add semantic route control reinforcement`

## Task 7: Add causal SemanticEventOverlay and Reduced Motion proof

**Files:**
- Create: `tests/demo/test_semantic_event_overlay.gd`
- Modify: `tests/run_tests.gd`
- Create: `game/demo/presentation/semantic_event_overlay.gd`

**Required interface:**

```gdscript
class_name SemanticEventOverlay
extends Control

const MAX_EVENT_DURATION := 1.0

func set_reduced_motion(enabled: bool) -> void
func play_event(event: StringName) -> bool
func cancel_all() -> void
func current_event_for_test() -> StringName
func information_key_for_test() -> StringName
func input_paths_for_test() -> Array[String]
func motion_active_for_test() -> bool
func maximum_event_duration_for_test() -> float
func combo_trigger_status_for_test() -> StringName
```

Behavior:
- `play_event` resolves `standard` or `reduced_motion` through the VFX sidecar;
- unknown event returns false and shows no semantically different substitute;
- standard may use a short presentation-only scale/position/alpha treatment, total duration `<=1.0`;
- reduced mode must use the same `information_key` and input path, with no spatial/scale motion;
- the overlay never writes controller/model/snapshot/domain state;
- combo catalog resolution is tested, but `combo_trigger_status_for_test()` returns `RUNTIME_TRIGGER_DEFERRED_NO_EXISTING_SEAM` unless an already-existing presentation-readable combo source is found during fresh implementation inspection.

- [ ] **Step 7.1 — RED:** Add tests for all eight approved VFX event keys, exact standard/reduced information equivalence, route-selection reuse path, combo reuse path, unknown-event fail-soft behavior, duration ceiling, and reduced-mode `motion_active=false`.
- [ ] Register in `tests/run_tests.gd`; run and verify RED for missing overlay.
- [ ] **Step 7.2 — GREEN:** Implement the overlay using the catalog; no domain import or gameplay signal.
- [ ] Run the full custom suite and VFX validator; require GREEN/PASS.
- [ ] Commit: `feat: add semantic event overlay`

## Task 8: Wire the semantic event overlay through existing ProductFiniteSlice seams

**Files:**
- Create: `tests/demo/test_runtime_semantic_poc.gd`
- Modify: `tests/run_tests.gd`
- Modify: `game/demo/product_finite_slice.gd`
- Modify: `game/demo/product_finite_slice.tscn`

**Scene change:** Add exactly one presentation child named `SemanticEventOverlay` under `ProductFiniteSlice`, with `mouse_filter=IGNORE`, above board presentation and below interaction-blocking shell overlays. Do not change domain scene ownership.

**Wiring contract:**
- pickup: existing `delivery_event_created` with `picked_up=true` → `cargo_pickup`;
- unload: same existing event with `unload_count>0` → `cargo_unload`;
- route selection: only after an existing `RouteControlOverlay.consume_route_selection_requests()` request has positive `cycle_count` and existing `BOARD_CELL` dispatch occurs → `route_selection`;
- terminal SUCCESS → `success`;
- terminal FAILURE/ROUTE_END → `route_end`;
- terminal FAILURE/TIME_EXPIRED → `time_expired`;
- other terminal failure → `failure`;
- combo: no new signal or command; remain deferred unless an existing seam is independently found.

**Test-only seam on ProductFiniteSlice:**

```gdscript
func semantic_event_overlay_for_test() -> Control
```

- [ ] **Step 8.1 — RED:** Add `test_runtime_semantic_poc.gd` that instantiates `product_finite_slice.tscn`, verifies semantic catalog-backed HUD/board/route nodes load, exercises a recommended route into RUN, verifies actual manual-hold projection, triggers an accepted route selection and checks `route_selection`, then uses existing delivery/terminal flow helpers where practical to verify existing event wiring. Domain model/snapshot/layout identity must remain unchanged by direct overlay playback.
- [ ] Register the test and run; verify RED on missing scene node/wiring.
- [ ] **Step 8.2 — GREEN:** Add the scene node/onready reference and only the wiring above. Call `cancel_all()` on exit. Do not remove existing `DemoEffects`/audio calls.
- [ ] Re-run full custom suite; require GREEN.
- [ ] Re-run `tests/demo/test_demo_effects_authority.gd` as part of the suite and ensure semantic feedback cannot mutate model/snapshot/layout/result authority.
- [ ] Commit: `feat: wire runtime semantic POC events`

## Task 9: Preserve semantic package immutability and complete automated regression

**Files:**
- No expected production-file changes in this task.
- Modify tests only if a test itself is proven incorrect; do not weaken assertions to obtain GREEN.

- [ ] Run custom Godot suite with the exact argument vector. Require exit 0 and no `SCRIPT ERROR:`/`ERROR:` output.
- [ ] Run all four static asset validators. Require PASS; `runtime_integrated=false` in historical asset sidecars remains unchanged because those manifests record production-package provenance, not live scene state.
- [ ] Inspect `git diff --name-only`/PR changed-file list. Explicitly reject changes under:
  - `game/finite/` other than the two approved presentation/read-projection files;
  - `data/`, save/ruleset/map content;
  - `art/product_assets/**/*.png`;
  - semantic JSON sidecars;
  - `.asset-vault`;
  - `project.godot`;
  - audio files unless separately authorized.
- [ ] Confirm no new combo signal, no new route command, and no mutation of `_direction_targets_for_switch` behavior.
- [ ] Open implementation PR against current `main`.
- [ ] On the final unchanged exact PR head require Project Contract, GUT 9.7.1, Godot Tests including live-editor Pilot, Thin Adapter Migration, and Windows Demo Export when triggered/applicable.
- [ ] Require unresolved review threads = 0 and mergeability true.
- [ ] Squash-merge with expected-head protection only after all exact-head evidence is green.

## Task 10: Canonical POC closure after implementation merge

**Files:**
- Modify: `docs/decisions/SX_DEC_055_RUNTIME_SEMANTIC_POC.md`
- Modify: `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
- Modify: an existing/new bounded audit record only if implementation evidence needs a canonical audit; do not create a new product Decision ID.
- Google Sheet: update existing `SX-DEC-055` row with the same Decision ID.

- [ ] Re-read Base structure/latest, project main/open PRs/latest commit, and configured Sheet before closure writes.
- [ ] Record exact implementation PR head, workflow run IDs/conclusions, merge SHA, changed-file scope, combo trigger disposition, and automated POC result.
- [ ] Set `runtime_integrated`/runtime state in current registry only to the bounded truth actually proven by the merged POC; do not rewrite historical `SX-DEC-053/054` asset sidecars merely to flip their original provenance field.
- [ ] Keep physical/device/human gates `NOT_RUN` unless separately executed.
- [ ] Synchronize Sheet with the same `SX-DEC-055` ID and re-read exact target cells.
- [ ] If compact registry and Sheet disagree, repair under the existing bounded registry-audit mechanism before declaring closure.

---

## Definition of Done for the Codex Implementation

The implementation is complete only when all are true:

1. The runtime catalog reads immutable SX-DEC-053/054 manifests and resolves representative approved compositions/textures.
2. Stack/load/preflight/placement/route state mapping consumes existing presentation data only.
3. Manual-load visual state is projected from the actual `FiniteGameplayInputState` getter, not UI-local state.
4. Procedural route targets, cycle counts, hit rectangles, lock behavior, U-turn behavior, and rail geometry remain unchanged.
5. Existing pickup/unload/route-selection/terminal seams drive approved semantic event keys.
6. Standard and Reduced Motion use the same VFX information key/input and stay within the one-second presentation ceiling.
7. Combo resolves in the catalog and is not given a new gameplay/domain signal solely for POC triggering.
8. Missing/unknown semantic lookups fail soft to existing procedural/text presentation without substituting different meaning.
9. No product PNG, sidecar semantics, map, save/ruleset, `.asset-vault`, or `project.godot` bytes change.
10. The final exact implementation PR head passes all applicable automated gates and merges with zero unresolved review threads.
11. Same-ID `SX-DEC-055` GitHub/Sheet closure is read back after merge.
12. Physical Windows, Android device, connected editor, and human validation are not promoted beyond evidence actually run.

## Plan Self-Review

- Spec coverage: RUN Stack/load, BUILD placement/preflight, route reinforcement, VFX, Reduced Motion, fallback, combo boundary, and validation ceilings are all mapped to explicit tasks.
- Type/data consistency: state resolvers accept only presentation dictionaries; catalog owns filesystem/resource lookup; domain objects never receive asset references.
- Authority consistency: all runtime meanings come from SX-DEC-053/054 records or existing presenter/snapshot/event fields; no unnamed atlas region is mapped.
- TDD consistency: every production surface has a preceding focused RED task and a defined GREEN verification command.
- Scope consistency: exhaustive 73-asset skinning, palette overhaul, settings UI, audio redesign, device/human gates, and production cutover remain outside the POC.
