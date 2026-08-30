# SX-DEC-063 Core Board v02 live runtime verification

**Status:** `MACHINE_RUNTIME_CAPTURE_AND_LOCAL_PACKAGE_VERIFIED · PHYSICAL_HUMAN_NOT_RUN`

## Exact scope

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
