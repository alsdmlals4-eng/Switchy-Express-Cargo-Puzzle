# CODEX_GODOT_PRODUCT_IMPLEMENTATION_HANDOFF · SX-DEC-063 Terrain v02

Status: `HANDOFF_READY · RUNTIME_NOT_STARTED · USER_APPROVED_ASSET_PROMOTION`

## Goal

Implement GitHub Issue #243 exactly as specified: connect only the user-promoted terrain v02 to the existing `ProductBoardRenderer.board_terrain` consumer. Preserve the current rectangular board/input mapping, finite delivery rules, all other assets, v01 rollback source, and evidence ceiling.

## Read first

1. `AGENTS.md`
2. `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
3. `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
4. `docs/decisions/SX_DEC_060_CARDINAL_STATION_SERVICE_AND_REACHABLE_NETWORK.md`
5. `docs/decisions/SX_DEC_063_HYBRID_MINIATURE_DIORAMA_VISUAL_PRODUCTION_ALIGNMENT.md`
6. `docs/operations/2026-08-28-sx-vis-063-terrain-promotion-feasibility-review.md`
7. `docs/superpowers/specs/2026-08-28-sx-dec-063-hybrid-miniature-diorama-production-design.md`
8. `docs/superpowers/plans/2026-08-28-sx-dec-063-terrain-runtime-integration.md`
9. Actual files: `game/demo/presentation/product_board_renderer.gd`, `tests/demo/test_product_board_renderer.gd`, `tests/python/test_sx_dec_063_terrain_asset_promotion.py`, v01/v02 asset manifests.

Fresh-read project `main`, latest Base completed `main`, all open/draft PRs, local dirty/diverged state, Godot 4.7.1 pin, and current candidate pointer before a write. PR #174 is read-only.

## Exact allowed production changes

```text
game/demo/presentation/product_board_renderer.gd
tests/demo/test_product_board_renderer.gd
tests/python/test_sx_dec_063_terrain_asset_promotion.py
art/product_assets/ed_hybrid_v2/manifest.json
docs/ASSET_RIGHTS_AND_PROVENANCE_RECORD.md
exact result/evidence owners created after verification
```

Before any additional path, stop and report the concrete consumer reason.

## Required behavior

- `PRODUCT_VISUAL_ASSET_PATHS["board_terrain"]` becomes `art/product_assets/ed_hybrid_v2/board/board_terrain_playfield_v02.png` only.
- The renderer still loads `Texture2D`, calls the existing `draw_texture_rect()` and veil, and draws grid → rail → station-service → route → markers → state → train in the same order.
- v01 remains tracked and can be restored by changing this one map value; do not delete or overwrite it.
- At 1280×720 BUILD with the same map/state, grid, rail ports, cargo, off-track station/cardinal cue, selected/alternate/locked route, train, and HUD remain readable.

## Explicit exclusions

No Scene/Resource/schema/map/gameplay/input/camera/hit-test/locale/audio/score/economy/progression/other asset change; no T2 Hero or Issue #227; no Base repin; no PR #174 operation. Do not claim package, physical/audio, Android, human, Player Experience, release-rights, or production-cutover PASS without new exact evidence.

## RED→GREEN and validation

1. Add the exact v02 path and `Texture2D` loaded assertions in the named GDScript test and change the Python manifest expectation to `RUNTIME_VERIFIED`; run both and observe RED against current v01/`NOT_CONNECTED` state.
2. Change only the renderer terrain path. Run the focused GDScript/Python tests to GREEN.
3. Update manifest/provenance status only after GREEN. Verify v01 still exists.
4. Run current project contract, full Godot runner, required exact-head checks, same-state 1280×720 visual comparison, and official package workflow.
5. Run five full-scope adversarial loops: semantics/input, import/path/rollback, gameplay-scale readability/style drift, rights/provenance, evidence/package/human ceiling. Correct valid scope findings and re-run affected checks.

## Completion report

Report exact base/main/head, changed paths, RED and GREEN evidence, runtime comparison result, package/candidate outcome, five-loop review, rollback, and each remaining `NOT_RUN` gate. This handoff grants no automatic promotion beyond terrain v02.
