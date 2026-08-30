# SX-DEC-063 Core Board v02 live runtime verification

**Current v04 status:** `MACHINE_RUNTIME_CAPTURE_AND_LOCAL_PACKAGE_VERIFIED · REMOTE_EXACT_HEAD_CI_PENDING · PHYSICAL_HUMAN_NOT_RUN`

> The v02/v03 sections before the explicit v04 correction below are historical evidence only. Their old screenshots, package counts, and hosted-CI records do not apply to the current v04 runtime bytes.

## Historical v02/v03 scope

The 2026-08-30 user approval promoted the displayed Core Board v02 image bundle and the narrow curve/switch visual seam-underlay strategy. This check verifies only the changed product-renderer asset family on the isolated implementation branch. It includes a local, uncommitted Windows debug export and Windows/Android data-package proof; it does not mint a GitHub exact-head candidate, validate a physical Windows build, audio perception, Android device, accessibility with users, player comprehension, release rights, or production cutover.

The live editor was Godot `4.7.1-stable`; its Hera connection reported the exact worktree project path `C:/Users/user/Documents/GitHub/Ninza/Switchy-Express-Cargo-Puzzle/.worktrees/codex-sx063-core-board-v02-runtime/` and the current scene `res://game/main/main.tscn` before the direct product-scene capture. The project addon initialized in the editor; its expected headless-only disable message is not an editor disable state.

## Captured real consumer states

The runtime capture uses the actual `res://game/demo/product_finite_slice.tscn` product scene with its default `VS_DEMO_01` map. Its visible `권장 배치` control installed the existing recommended layout, then its real `운행 시작` control entered RUN. No source simulation or planning image was substituted for the board.

| State | Capture | Observed runtime consumer truth |
| --- | --- | --- |
| BUILD with recommended layout | `evidence/runtime/sx_dec_063_core_board_v02/2026-08-30-core-board-v02-build-1280x720.png` | v02 terrain under the grid; v02 straight, curve, crossing, switch, start, red/blue stations, and red/blue cargo render in the live board while service frames remain procedural. |
| RUN from that layout | `evidence/runtime/sx_dec_063_core_board_v02/2026-08-30-core-board-v02-run-1280x720.png` | v02 locomotive renders above the live route; route/lock treatment, selected-path lighting, load controls, TOP stack, live Korean text, and station/cargo labels remain renderer/UI-owned. |

Observed runtime tree facts:

- `ProductFiniteSlice/BoardRenderer` was visible at the gameplay board bounds.
- BUILD displayed the existing four build-tool controls and switched to RUN after the visible start control was pressed.
- RUN displayed `운행 중`, remaining-time text, Manual/Auto controls, TOP stack, and the generated locomotive on the live rail path.
- Godot diagnostics returned `clean: true`, with zero runtime errors and warnings for both captures.
- The capture analyzer reported nonblank 1280×720 frames. Its generic `possible_clipping` heuristic is retained because the intentional bottom toolbar reaches the viewport edge; visual inspection found no clipped board or HUD content in these two machine captures. Physical/window-size validation remains unrun.

## Verified boundaries

- `ProductBoardRenderer::PRODUCT_VISUAL_ASSET_PATHS` loads all fourteen v02 `Texture2D` paths in the full automated suite.
- Curve and switch use the approved underlay only below their generated texture, with ports copied from the pre-existing authored port list. This is visual adjacency only; map data, click mapping, route choice, station service, locks, and train behavior were not changed.
- Stations remain off-track. Their four cardinal service frames and color + shape + live label redundancy are still drawn procedurally.
- The `route_end_marker` path remains a loaded retained map slot. It is not asserted here as a fixed board marker because the current finite product expresses `ROUTE_END` as a dynamic failure condition, not an authored static map object.

## Local package/export verification

The repository-supported export flow was executed from the isolated branch using Godot `4.7.1-stable`. The portable local Godot installation first reported that its private template cache was empty. Its two required Windows x64 templates were copied from the already-installed matching user-local Godot `4.7.1.stable` template store into that engine cache; each copied byte stream matched SHA-256 before export. This is local tooling bootstrap only, not a repository change.

| Check | Result |
| --- | --- |
| Windows debug export | `PASS` — `SwitchyExpressVerticalSlice.exe` (102,982,144 bytes; SHA-256 `1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244`) and companion PCK (14,965,164 bytes; SHA-256 `e0d4e6a495f0d1dd8a1ec6aaaba954bcbccba14e037aba0196975d46ec126ac1`) created outside the repository. |
| Windows preset proof PCK | `PASS` — 29 runtime JSON documents parsed, including `art/product_assets/ed_hybrid_v2/manifest.json`; integrity verifier: 536/536 entries, zero bounds or MD5 mismatches. |
| Android Validation preset proof PCK | `PASS` — 29 runtime JSON documents parsed, including the same v02 manifest; integrity verifier: 536/536 entries, zero bounds or MD5 mismatches. |
| Core Board v02 package inclusion | `PASS` — each proof PCK contains 15 v02 root entries: 14 `.import` records plus `manifest.json`; it also contains imported textures as `.ctex`. This is package-content proof, not an Android device run. |
| Windows CI trigger | `CORRECTED_AND_TESTED` — `.github/workflows/windows-demo-export.yml` now watches `art/product_assets/ed_hybrid_v2/**`; both export presets and the runtime JSON verifier now include the v02 manifest. Hosted CI remains unrun until this isolated branch is submitted for review. |
| Formal GUT regression | `PASS` — after creating CI-equivalent local `test-results/gut/`, GUT `9.7.1` ran 7 scripts, 21/21 tests, and 152 assertions. Its JUnit output was generated and validated. |

The temporary export directory was outside the repository and is not a durable candidate or release artifact. Its hashes are evidence for this local uncommitted worktree only.

## Five-pass adversarial close

| Loop | Attack | Evidence and disposition |
| --- | --- | --- |
| 1 | Consumer/gameplay mismatch | Renderer map contract, full Godot suite, and live BUILD/RUN captures show only the fourteen existing visual slots changed. Map data, service rules, input, routing, locks, and train behavior remain unchanged. `PASS`. |
| 2 | Asset/import/package omission | Exact source SHA-256, dimensions, alpha, import contracts, two 29-JSON proof packs, and two 536-entry PCK integrity checks completed. `PASS`. |
| 3 | Readability/visual drift | 1280×720 live BUILD and RUN machine captures show the grid, rail family, stations, cargo, locomotive, labels, and procedural service cues together. The bottom-edge heuristic remains noted; physical visual/audio validation is still `NOT_RUN`. `PASS_AT_MACHINE_EVIDENCE_CEILING`. |
| 4 | Provenance/reference drift | The asset record preserves image-model source identifiers, final hashes, the project-owned HGB reference boundary, and the prohibition on shipping/cropping reference sheets. No third-party source was introduced. `PASS_FOR_IMPLEMENTATION_SCOPE`; release-rights review remains separate. |
| 5 | Evidence inflation/scope expansion | No exact GitHub candidate, human/device result, release result, or protected PR was promoted. Local package output is explicitly non-candidate; v01 rollback remains tracked. `PASS`. |

## Evidence ceiling

```yaml
automated_renderer_asset_contract: PASS
full_headless_godot: PASS_112_CASES_13534_ASSERTIONS
formal_gut: PASS_21_TESTS_152_ASSERTIONS_JUNIT_VALIDATED
live_machine_build_capture: VERIFIED
live_machine_run_capture: VERIFIED
godot_runtime_diagnostics: CLEAN
local_windows_debug_export: PASS_UNCOMMITTED_ISOLATED_BRANCH
local_windows_and_android_package_proof: PASS_UNCOMMITTED_ISOLATED_BRANCH
exact_github_package_candidate_for_core_board_v02_bytes: NOT_MINTED
hosted_windows_export_ci_for_core_board_v02: NOT_RUN
windows_physical_visual_audio: NOT_RUN
android_device: NOT_RUN
human_accessibility_comprehension_player_experience: NOT_RUN
release_rights_and_production_cutover: NOT_RUN
```

The previous Candidate 004 package evidence is retained as historical evidence for earlier bytes. It does not transfer to the player-facing Core Board v02 runtime byte set.

## 2026-08-30 visual-readability repair addendum

### Observed problem and adopted bounded correction

The user inspected the real BUILD board and reported three renderer defects: the mouse placement preview whitened an entire cell, branch rails looked disconnected, and cargo had the same visual weight as a station. The repair stays within the existing user-approved Core Board v02 and curve/switch-underlay scope.

| Observation | Cause in the real renderer | Implemented correction |
| --- | --- | --- |
| White placement cell | The existing semantic placement texture was stretched across the whole ghost cell. | Preserve exact semantic state/path resolution, but draw that existing texture only as a compact in-cell corner badge. Ghost fill is now 0.08 and rail art is 0.46 opacity. |
| Branch/curve joins look broken | Curve and switch seam strokes ended at the already-inset source-texture rectangle, leaving a visible tile-edge gap. | Continue to use the same authored ports, but extend the visual-only seam target 3px beyond that rectangle. Curves use a 24-segment rectangular ellipse arc; switches retain their three port spokes. |
| Cargo competes with stations | Cargo and station textures both used the same inset cell rectangle. | Keep the station rectangle unchanged. Draw cargo into a centered square of 0.62 times the cell's shorter dimension. |

No `TrackPiece`, port list, map, input, route selection, station service, cargo mechanics, data asset, source image, manifest, or gameplay rule changed.

### RED → GREEN evidence

- **RED:** the full custom runner completed with exactly two failed cases and four new targeted assertions: missing compact ghost contracts, missing expanded rail-seam contract, and missing cargo sizing contract. An initial test-authoring issue used an unsupported assertion helper; it was corrected before this RED result and did not affect production code.
- **GREEN:** the same full runner passed **112 cases / 0 failed / 13,563 assertions** after the renderer change.
- Project operating contract: **PASS**.
- Python regression: **223 passed, 1 skipped**.
- Godot 4.7.1 headless import and formal GUT: **7 scripts / 21 tests / 152 assertions, all passing**; JUnit discovery guard passed.
- Current live Hera diagnostics: **0 errors / 0 warnings**. The formal import recreated two missing untracked `.uid` cache files; they were removed and are not part of this change.
- Approved asset integrity: `validate_ed_hybrid_asset_pack.py` passed 31 assets. `validate_final_ed_product_asset_promotion.py` passed with the existing two deferred historical candidate CRC findings; neither finding is in the v02 runtime asset family and neither was changed here.

### New real-consumer captures

Both captures use the actual isolated-worktree `ProductFiniteSlice` at native 1280×720. The visible `권장 배치` button installed the real recommended layout; the visible `곡선 2` tool was then selected and a real mouse-move event was sent to an empty board cell. No planning mockup or synthetic composition was substituted.

| State | Capture | Observed result |
| --- | --- | --- |
| Recommended BUILD layout | `evidence/runtime/sx_dec_063_core_board_v02/2026-08-30-core-board-v02-recommended-layout-1280x720.png` | Terrain, straight rails, curve rails, two three-way branches, station service frames, stations, smaller cargo, grid, and HUD appear together. |
| Curve hover preview | `evidence/runtime/sx_dec_063_core_board_v02/2026-08-30-core-board-v02-recommended-ghost-curve-1280x720.png` | The selected curve remains translucent over the terrain; its cyan cell outline and small semantic badge remain visible without turning the cell white. |

The analyzer reported nonblank frames. Its `possible_clipping` signal is the known bottom-toolbar edge heuristic; direct inspection found the board and HUD visible within their intended bounds. This remains machine runtime evidence, not physical Windows, device, accessibility, player-comprehension, or release evidence.

### Five-pass adversarial review for this repair

| Loop | Attack | Result |
| --- | --- | --- |
| 1 | Gameplay/topology or input drift from a visual patch | Renderer-only diff and full Godot/GUT regressions; no graph, map, controller, or input file changed. **PASS**. |
| 2 | Rotated curve and three-way switch use a wrong or shortened port | Renderer contracts cover all four curve rotations and switch ports; both seam families expand by the same 3px visual overlap. **PASS**. |
| 3 | Selection readability, cargo/station hierarchy, or clipping regresses in the live board | Two actual BUILD captures show the translucent preview, compact badge, smaller cargo, stations, curves, branches, grid, and HUD. **PASS_AT_MACHINE_EVIDENCE_CEILING**. |
| 4 | New or modified image/provenance drift | Asset validators passed and the working diff contains no `art/product_assets/**` change. **PASS_FOR_IMPLEMENTATION_SCOPE**. |
| 5 | Evidence inflation or unrelated branch impact | Local runtime evidence is recorded as local; physical/device/human/release gates and protected PR #174 remain untouched. **PASS**. |

### Updated evidence ceiling

```yaml
visual_readability_repair_renderer_contract: PASS
visual_readability_repair_full_headless_godot: PASS_112_CASES_13563_ASSERTIONS
visual_readability_repair_python_regression: PASS_223_PASSED_1_SKIPPED
visual_readability_repair_formal_gut: PASS_21_TESTS_152_ASSERTIONS_JUNIT_VALIDATED
visual_readability_repair_live_machine_build_capture: VERIFIED
visual_readability_repair_live_ghost_capture: VERIFIED
visual_readability_repair_godot_diagnostics: CLEAN
visual_readability_repair_asset_bytes: UNCHANGED
visual_readability_repair_windows_physical_visual_audio: NOT_RUN
visual_readability_repair_android_device: NOT_RUN
visual_readability_repair_human_accessibility_comprehension_player_experience: NOT_RUN
visual_readability_repair_release_rights_and_production_cutover: NOT_RUN
```

## 2026-08-30 connected rail-master v03 correction

### User direction and bounded implementation

The user found that even the repaired curve/switch seams did not make the rail network read as one connected route. They explicitly directed the team to draw the complete connected rail line first and cut runtime tiles from that image. The selected master was placed in the actual recommended BUILD board and the user approved the displayed result for final promotion.

The approved source is the tracked `1254×1254` RGBA master `art/product_assets/ed_hybrid_v2/source/core_rail_network_master_v03.png` (SHA-256 `f3a6f070b728e319a15b3fc1b72ac7c4732f3b632e73e5dda202a52e95bb5d5b`). Four explicit `256×256` crop rectangles are downsampled to the four `64×64` rail textures and recorded in the asset manifest. `ProductBoardRenderer` now uses those four v03 paths at the full cell rectangle; all renderer-local seam drawing was removed. The master source and this directory's runtime review captures are each `.gdignore`d, so reproducibility source and review evidence cannot become an accidental Godot import/export resource. No map, track topology, input, service, route, lock, train, cargo, locale, audio, or progression code changed.

### RED → GREEN contract evidence

- **RED:** after the v03 rail paths, four v03 manifest identities, tracked master source, crop coordinates, and no-seam renderer contract were specified, the focused promotion test failed exactly because the manifest still contained the four v02 rail identities.
- **GREEN:** after preserving the source and updating the manifest, `tests.python.test_sx_dec_063_core_board_asset_promotion` passed. The pre-existing full Godot runner rail-path contract then passed `112` cases / `0` failed / `13,548` assertions after importing the four new textures.
- **Live candidate:** the actual `ProductFiniteSlice` scene loaded the recommended layout with no Godot diagnostics errors or warnings. `evidence/runtime/sx_dec_063_core_board_v03/2026-08-30-master-rail-v03-recommended-1280x720.png` and `evidence/runtime/sx_dec_063_core_board_v03/2026-08-30-master-rail-v03-ghost-curve-1280x720.png` are the user-reviewed real-consumer captures; they are not planning compositions.

### Corrected local package proof

The first v03 package attempt exposed that review captures under `evidence/runtime/` could be imported by the broad all-resources preset. That is an evidence-boundary failure, not an accepted package result. The correction added a local `.gdignore` to this v03 capture directory, re-imported, and rebuilt every local package proof. The tracked derivation master already has its own `.gdignore`; both source master and captures have a zero entry count in the final PCKs.

| Check | Result |
| --- | --- |
| Windows Debug export | `PASS_UNCOMMITTED_ISOLATED_BRANCH` — `SwitchyExpressVerticalSlice.exe`, 102,982,144 bytes, SHA-256 `1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244`. This is export construction, not a physical Windows run. |
| Windows Demo runtime-JSON PCK | `PASS_UNCOMMITTED_ISOLATED_BRANCH` — 16,577,076 bytes, SHA-256 `6067ce9e6f5fab74af531b947febd64068e33b65a56d5c84ac7da603d82fedc2`; `RUNTIME_JSON_PACK_PROOF: PASS parsed_json=29`; integrity 551/551 entries, zero bounds or MD5 mismatches. |
| Android Validation runtime-JSON PCK | `PASS_UNCOMMITTED_ISOLATED_BRANCH` — 16,577,076 bytes, SHA-256 `1951b169d8ca325a4968a4175357242fbf42d0ab6b64dd0d67a88c36cf9fac99`; `RUNTIME_JSON_PACK_PROOF: PASS parsed_json=29`; integrity 551/551 entries, zero bounds or MD5 mismatches. This is not an Android device run or APK claim. |
| Runtime / evidence inclusion boundary | `PASS` — each PCK contains one `.import` entry for every v03 runtime rail path, zero entries for `core_rail_network_master_v03.png`, and zero entries for `evidence/runtime/sx_dec_063_core_board_v03/`. The full Godot runner separately loaded all four v03 paths as real `Texture2D` consumers. |
| Hosted exact runtime-byte CI | `PASS` — PR #255 runtime-byte head `c07e02b629781314956e103ca95ca2dc693f8df7` completed all seven required checks: two `validate`, two `contract`, `headless-tests`, `gut-tests`, and `export-windows-demo`. This CI result does not mint an immutable package candidate or a physical/device/human result. |

### Five full-scope adversarial review loops

Every loop rechecked the same full scope: actual consumer and gameplay boundary, source/asset provenance, import/package behavior, live readability, and evidence-ceiling wording. The separate attack column identifies the assumption challenged in that pass.

| Loop | Attack | Result and correction |
| --- | --- | --- |
| 1 | The rail correction changes topology, interaction, or rule semantics rather than pixels. | The diff is limited to four visual paths, full-cell drawing, deletion of renderer seam artwork, four derived PNGs, and documentation/tests. The full Godot runner passed `112` cases / `13,548` assertions. No map, `TrackPiece`, controller, input, route, service, cargo, or train owner changed. **PASS**. |
| 2 | The tiles are not traceable to one reproducible connected source, or a path/hash/import can silently drift. | A RED manifest identity mismatch was observed, then corrected. The master SHA-256, four exact crop rectangles, output hashes, source receipt, tracked source path, four imports, and renderer slot paths are asserted by the promotion test and passed. **PASS**. |
| 3 | The rail is mechanically valid but still unreadable, or the old white selection/cargo hierarchy regression returns. | Actual 1280×720 recommended and curve-hover captures show the long route, crossings, right branch, curves, compact cargo, cyan selection border, translucent preview, and compact badge. Godot diagnostics are `0` errors / `0` warnings. The analyzer's bottom-toolbar clipping heuristic remains non-human machine evidence only. **PASS_AT_MACHINE_EVIDENCE_CEILING**. |
| 4 | Reproducibility or review images ship as runtime payloads, inflating the product package. | The first package attempt found this risk. A v03 evidence `.gdignore` was added, import/export was rerun, and final Windows/Android proof PCKs show zero master/capture entries while retaining each v03 rail import. **CORRECTED_AND_PASS**. |
| 5 | Documentation or test success is being inflated into hosted, physical, device, human, or release proof. | Project contract, JSON parse, Python regression (`223 passed, 1 skipped`), GUT (`21/21`, 152 assertions), asset validators, runtime, local PCK evidence, and the seven hosted checks for the exact v03 runtime-byte head all pass at their stated machine ceiling. Immutable GitHub candidate, physical Windows/audio, Android device, accessibility, player comprehension, release rights, and cutover remain explicitly unrun. **PASS_WITH_BOUNDARY_RETAINED**. |

### Current v03 evidence ceiling

```yaml
v03_master_source_and_four_derivatives: USER_APPROVED_GITHUB_PRESERVED
v03_renderer_contract_and_full_headless_godot: PASS_112_CASES_13548_ASSERTIONS
v03_live_recommended_build_capture: VERIFIED_MACHINE_RUNTIME
v03_live_curve_hover_capture: VERIFIED_MACHINE_RUNTIME
v03_godot_diagnostics: CLEAN_0_ERRORS_0_WARNINGS
v03_local_windows_debug_export: PASS_UNCOMMITTED_ISOLATED_BRANCH
v03_local_windows_and_android_runtime_json_pck: PASS_UNCOMMITTED_ISOLATED_BRANCH_551_OF_551_ENTRIES
v03_formal_gut: PASS_21_TESTS_152_ASSERTIONS_JUNIT_VALIDATED
v03_full_python_regression: PASS_223_PASSED_1_SKIPPED
v03_hosted_exact_runtime_byte_ci: PASS_PR_255_C07E02B_7_REQUIRED_CHECKS
v03_immutable_package_candidate: NOT_MINTED
v03_windows_physical_audio_android_device_human_player_experience_release: NOT_RUN
```

## 2026-08-30 v04 centred-port correction

### Scope, diagnosis, and selected approach

The user reported that the actual curve was still not natural. The diagnosis used the current `ProductBoardRenderer` consumer and the actual v03 raster bytes, not a concept image: v03 curve right-edge opaque-pixel centre was `42.5` while its logical 64px tile edge centre is `31.5`; the v03 straight left edge was `27.5`. The renderer already draws a full 64px texture rectangle and owns quarter-turn rotation, so this source-coordinate error cannot be fixed correctly with a seam overlap.

| Option | Disposition | Reason |
| --- | --- | --- |
| Restore a procedural overlap / seam underlay | `REJECT` | It masks, rather than corrects, the source centreline discontinuity and reintroduces the previously rejected separate-tile appearance. |
| Promote a new generated rail master | `REJECT` | Tested candidates were not promoted because one did not preserve usable alpha and another lacked a clean standard curve; the approved master already contained usable connected material. |
| Re-crop the approved connected master with a real-byte edge-centre contract | `ADOPT` | It preserves the approved source, changes only four actual visual consumers, and gives a deterministic regression test for every declared tile port. |

The approved source remains `art/product_assets/ed_hybrid_v2/source/core_rail_network_master_v03.png` (SHA-256 `f3a6f070b728e319a15b3fc1b72ac7c4732f3b632e73e5dda202a52e95bb5d5b`). `tools/derive_sx_dec_063_master_rail_v04.gd` deterministically crops and Lanczos-resamples: straight `[650, 803, 256, 256]`, curve `[394, 803, 256, 256]`, crossing `[388, 300, 256, 256]`, and switch `[855, 300, 256, 256]`; its non-mutating `--verify` mode regenerated and byte-compared every v04 PNG to the tracked output. No new generated image, external source, engine API, plugin, game rule, map, route, station service, cargo behavior, or input was introduced. Official external research is `NOT_MATERIAL`: the existing Godot `Image` crop/import and `Texture2D` renderer path are already the supported, verified consumer boundary.

### RED → GREEN and actual-consumer evidence

- **RED:** `tests/python/test_sx_dec_063_core_board_asset_promotion.py` examined the real active textures and found eleven off-centre declared ports using a two-pixel tolerance.
- **Saved reproduction:** `evidence/runtime/sx_dec_063_core_board_v03/2026-08-30-curve-root-cause-reproduction-1280x720.png` preserves the original v03 consumer fault for comparison; it remains excluded from runtime import/export.
- **GREEN:** the same contract reads the real active v04 renderer paths and passes with these contiguous port spans: straight `31.0/33.0`, curve `32.0/31.0`, crossing `31.0–31.5`, and switch `32.0–32.5` against logical centre `31.5`; every span has at least 12 opaque rail/ballast pixels.
- **Non-square quarter turns:** the renderer contract tests all four curve rotations in a `100×60` target. It requires a pre-swapped local draw rectangle for rotations 1/3 and proves every rotated port lands at the matching target-edge centre.
- **Derived-byte verification:** `Godot --headless --script res://tools/derive_sx_dec_063_master_rail_v04.gd -- --verify` returned `SX_DEC_063_MASTER_RAIL_V04_DERIVATION: PASS` without writing an output file.
- **Live machine runtime:** the final recommended-layout capture at `evidence/runtime/sx_dec_063_core_board_v03/2026-08-30-master-rail-v04-rotated-cell-fix-recommended-1280x720.png` shows the top-right horizontal → curve → vertical path continuously aligned after the non-square rotation correction. Godot diagnostics reported `0` errors and `0` warnings. This is machine runtime evidence, not physical Windows, accessibility, player, or release proof.

### Local package proof for v04 bytes

| Check | Result |
| --- | --- |
| Windows Debug export | `PASS_LOCAL_UNCOMMITTED_WORKTREE` — `SwitchyExpressVerticalSlice.exe`, 102,982,144 bytes, SHA-256 `1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244`; this constructs an export but does not run a physical Windows smoke. |
| Windows Demo runtime-JSON PCK | `PASS_LOCAL_UNCOMMITTED_WORKTREE` — 16,608,376 bytes, SHA-256 `f0e233a2f245a5e0bef068d02399e3be39b05ee3915093548b35d36965a08ecd`; `RUNTIME_JSON_PACK_PROOF: PASS parsed_json=29`; integrity 561/561 entries, zero bounds and MD5 mismatches. |
| Android Validation runtime-JSON PCK | `PASS_LOCAL_UNCOMMITTED_WORKTREE` — 16,608,376 bytes, SHA-256 `61e294434b5d966b3b1d10fa7690181cc58e182684b30256759818a0f708e0d0`; `RUNTIME_JSON_PACK_PROOF: PASS parsed_json=29`; integrity 561/561 entries, zero bounds and MD5 mismatches. This is PCK proof only, not an Android APK/device claim. |
| Asset/evidence boundary | `PASS` — the `art/product_assets/ed_hybrid_v2/core/` package prefix contains 21 imported core records including the four v04 paths; master source and `evidence/runtime/sx_dec_063_core_board_v03/` each have zero package entries. |
| Hosted exact runtime-byte CI | `PENDING` — PR #255's prior v03 checks do not transfer to v04 bytes. |

### Five full-scope adversarial review loops

Every loop rechecked the entire bounded scope: actual consumer/gameplay, source and rights provenance, import/package inclusion, live readability, test evidence, and evidence-ceiling wording.

| Loop | Attack | Result and correction |
| --- | --- | --- |
| 1 | The visual defect could be game topology, rotation logic, or interaction logic rather than asset geometry. | The live fault and actual alpha-edge measurements isolate it to v03 crop alignment; no map, `TrackPiece`, graph, controller, input, route, service, train, or cargo owner changed. **CORRECTED_AND_PASS**. |
| 2 | A new crop could drift from the approved source or introduce a new rights/provenance boundary. | All four v04 files derive from the same approved master with its existing SHA; its `--verify` mode regenerated and byte-compared every tracked v04 output without writing it. Fresh generated attempts were rejected and not copied to the project. Manifest, four hashes, crop rectangles, and deterministic derivation tool are recorded. **PASS**. |
| 3 | The new curve might centre one orientation but fail after renderer rotation, or hide a white-selection/cargo hierarchy regression. | Review found that quarter-turning a pre-scaled non-square rectangle could swap its final bounds. The renderer now pre-swaps the local rectangle for rotations 1/3; a 100×60 all-rotation contract proves each curve port reaches its correct target edge centre. The real recommended 1280×720 layout displays the formerly faulty curve with the existing cyan/translucent selection treatment and compact cargo unchanged. **CORRECTED_AND_PASS_AT_MACHINE_EVIDENCE_CEILING**. |
| 4 | Review source or captures could leak into the runtime package, or the new paths could be omitted. | Windows and Android proof PCKs parse runtime JSON, verify 561/561 entries, include the imported core family, and contain zero master/capture prefix entries. **PASS_LOCAL_PACKAGE_ONLY**. |
| 5 | Local success might be inflated into a remote, immutable, physical, device, human, or release result. | All documentation keeps PR #255 v04 hosted CI pending; the local proof is explicitly uncommitted, Candidate 004 remains historical merged-main evidence, and physical/audio/device/accessibility/player/release gates remain `NOT_RUN`. **PASS_WITH_BOUNDARY_RETAINED**. |

### Current v04 evidence ceiling

```yaml
v04_real_byte_port_centre_contract: PASS_AFTER_RED_11_FINDINGS
v04_contiguous_rail_port_span_contract: PASS_MINIMUM_12_PIXELS
v04_non_square_quarter_turn_contract: PASS_100x60_ALL_CURVE_ROTATIONS
v04_master_derivation_byte_verification: PASS_NO_WRITE
v04_focused_python_contract: PASS_2_TESTS
v04_full_project_contract: PASS
v04_full_python_regression: PASS_215_TESTS_1_SKIPPED
v04_full_headless_godot: PASS_112_CASES_13560_ASSERTIONS
v04_formal_gut: PASS_21_TESTS_152_ASSERTIONS
v04_live_recommended_build_capture: VERIFIED_MACHINE_RUNTIME
v04_godot_diagnostics: CLEAN_0_ERRORS_0_WARNINGS
v04_local_windows_debug_export: PASS_UNCOMMITTED_ISOLATED_WORKTREE
v04_local_windows_android_runtime_json_pck: PASS_UNCOMMITTED_ISOLATED_WORKTREE_561_OF_561_ENTRIES
v04_remote_exact_runtime_byte_ci: PENDING
v04_immutable_package_candidate: NOT_MINTED
v04_windows_physical_audio_android_device_human_player_experience_release: NOT_RUN
```
