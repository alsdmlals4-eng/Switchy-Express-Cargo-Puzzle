# CODEX_GODOT_PRODUCT_IMPLEMENTATION_HANDOFF · SX-DEC-062

Status: `HANDOFF_READY_AFTER_CANON_MERGE · IMPLEMENTATION_NOT_STARTED`

## Goal

Implement GitHub Issue #235 exactly as specified: a **board-first runtime composition** refinement for the existing Switchy Express vertical slice. Preserve every gameplay/data/asset consumer boundary and produce evidence that is exact-head safe.

## Read first

1. `AGENTS.md`
2. `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
3. `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
4. `docs/decisions/SX_DEC_060_CARDINAL_STATION_SERVICE_AND_REACHABLE_NETWORK.md`
5. `docs/decisions/SX_DEC_061_BOARD_FIRST_COZY_NEO_ARCADE_VISUAL_REFINEMENT.md`
6. `docs/decisions/SX_DEC_062_BOARD_FIRST_RUNTIME_COMPOSITION.md`
7. `docs/superpowers/specs/2026-08-28-board-first-runtime-composition-design.md`
8. `docs/superpowers/plans/2026-08-28-board-first-runtime-composition.md`
9. Actual owners: `demo_palette.gd`, `demo_theme_factory.gd`, `product_board_renderer.gd`, `route_control_overlay.gd`, `product_hud.tscn`, `vertical_slice_demo.tscn`, and their named tests.

Fresh-read project GitHub `main`, Base completed `main`, all open/draft PRs, current Switchy Notion owners, current local dirty state, Godot/tool pins, and candidate pointer before the first write.

## Player-visible contract

During BUILD and RUN, players see the board first and the smallest relevant decision UI second. Valid/selected, alternate, locked/invalid, lesson focus, cargo/station, TOP/load mode, and result recovery retain redundant meaning. The player still learns T2 exact-cell cargo versus cardinal-adjacent station service, T3 LIFO, T5 Auto choice, and T6 direct switch control without any added tutorial stage or rule.

## Exact allowed files

```text
game/demo/presentation/demo_palette.gd
game/demo/presentation/demo_theme_factory.gd
game/demo/presentation/product_board_renderer.gd
game/demo/presentation/product_hud.tscn
game/demo/vertical_slice_demo.tscn
tests/demo/test_demo_theme.gd
tests/demo/test_first_session_responsive_accessibility.gd
tests/demo/test_product_board_renderer.gd
tests/demo/test_product_board_route_clarity.gd
tests/demo/test_playable_poc_visual_integration.gd
tests/run_tests.gd only if a new test script is genuinely added
current exact-head evidence/canon owners only after results exist
```

Before changing a file outside this list, stop and report the discovered consumer and why it is required.

## Prohibited changes

- `art/product_assets/**`, asset manifests/hashes/Notion binary records, image generation, and any T2 hero replacement. Preserve v02 in T2 and v01 elsewhere. Issue #227 is out of scope.
- Maps, schemas, finite delivery/preflight, cargo/station/switch/LIFO semantics, first-session data/copy/locales, audio behavior, score/economy/progression, Base pin, or PR #174.
- Any human/device/audio/release PASS claim without new exact evidence.

## RED-first acceptance sequence

1. Add the specified theme, scene-variant, and renderer-layer tests from the SX-DEC-062 plan; run to prove RED.
2. Implement only the palette-to-theme aliases/variants, scene variation properties, and renderer service-before-route ordering described in the plan.
3. Run focused tests, then the full Godot runner, Python project contracts, and current required workflow checks from exact head.
4. Review final diff for prohibited paths/semantics and exact T2/T1/result asset assertions.
5. Package only through current official workflow. If it yields an exact artifact, create a new candidate; otherwise leave the candidate pointer unchanged.
6. Run at least five full-scope adversarial review loops and resolve only validated in-scope findings.

## Completion report requirements

1. exact base/main/head SHA and changed files;
2. mapping from each change to SX-DEC-062 player-visible intent;
3. RED/GREEN commands/results, exact test counts, required CI results, and any `NOT_RUN`;
4. exact package candidate/artifact hashes only if generated;
5. no-new-asset/no-gameplay-delta proof;
6. five-loop adversarial review record and residual risks;
7. manual Godot test path: title → T1 BUILD → T2 RUN → T3/T5 TOP/mode → T6 switch → success → `ROUTE_END` → time failure → Retry/Edit;
8. post-merge GitHub/Notion destinations/readback and all remaining physical/audio/Android/five-person/player gates.

This handoff authorizes no implementation by itself until the documentation contract is merged and the user or current task explicitly starts Phase 2.
