# Stage board preview implementation plan

> Execute with superpowers:executing-plans in the existing isolated worktree. User explicitly delegates continuous researched implementation without intermediate approval. Steps and corrections are recorded here and in the runtime receipt.

**Goal:** Connect stage planning questions to the actual selected map before BUILD, without revealing a solution.
**Architecture:** Reuse FiniteSliceSessionController.initialize/render_snapshot and ProductBoardRenderer inside a read-only briefing Control. No live ProductFiniteSlice, timer, command connections or duplicate asset mapping. Existing lesson art remains the tutorial/failure fallback.
**Tech Stack:** Godot 4.7.1, GDScript, existing approved PNGs and map schema v3.
**Spec:** Existing core-preserved-art-and-experience-replan.md, user delegated content-to-runtime loop.

## Research / feasibility / decisions

Source main: 253a774ff57f03c1f0bbc4d84125720723486d12; fresh Base d830c0f6967678eed3c208ac6b24f9cd1b262ec3 (no repin).
Actual audit: book02 reuses five book01 witness geometries; this proves content additions, not absence of alternative solutions.
The immediate consumer gap is stronger: all Route Book stages receive the same generic LESSON composition despite different cargo/station/caution placements.

| Source and observation | Fit and disposition |
|---|---|
| https://developer.apple.com/news/?id=0x08hncy (read 2026-09-13): Afterburn describes compact purposeful spaces, easy iteration, teaching through interaction rather than text blocks | ADAPT: let existing map geometry accompany concise questions. REJECT importing a hard rail-count limit or their mechanics |
| https://www.trainyard.ca/solutions/faq (read 2026-09-13): many solutions, own discovery | ADAPT: show only authored starting state; never witness rails, solver route or an optimality claim |
| Existing ProductBoardRenderer + initialized BUILD snapshot | REUSE: identical asset/semantic consumer; a new static screenshot atlas would duplicate data and become stale |

Alternatives: live gameplay miniature rejected (input/timer/lifecycle coupling); pre-rendered image per map rejected (stale duplicate and asset overhead); snapshot-only existing renderer selected.
SWOT: strengthen spatial route planning, address generic illustration weakness, use direct map-data connection, prevent hint/solution leakage and preview/runtime drift.
Expected readability benefit is a hypothesis, not human PASS. No map change is justified merely because witnesses share geometry.

## Constraints

No core, map, deadline, save, new bitmap, monetization, provider or Base change. Preserve dirty imports/settings and unrelated PR174/254/281.
Preview ignores mouse/touch/focus and never creates an active gameplay instance. Fit square cells inside available space, preserving board aspect.
Invalid map clears/hides preview and keeps existing lesson art. Tutorial selection hides previous preview. Next stage refreshes the exact map.

## Task 1 — selected map preview

Files: new game/demo/presentation/stage_board_preview.gd; existing demo_flow_controller.gd and vertical_slice_demo.tscn; new tests/demo/test_stage_board_preview.gd; tests/run_tests.gd.
- [ ] RED: instantiate actual demo; select RB08; require visible MapPreview/Board with map_id RB08_CAUTION_CUT, board_size(11,7), two cargo/two station/two caution cells, no layout pieces, no gameplay instance.
- [ ] GREEN: preview.show_map(path) initializes a temporary controller, applies a copied snapshot to existing renderer, and returns success. Fit child size using uniform cell scale plus renderer padding. Connect stage map_path only.
- [ ] Cover RB09 -> success Result -> RB10 refresh, invalid map clearing, repeated selection, tutorial fallback and square-cell layout. No new production test-only API.
- [ ] Full custom runner, Python, operating contract; fix all validated findings.

## Task 2 — actual screen and review

- [ ] Actual Godot main: inspect RB08/RB12 preview, click Begin, verify map identity and empty editable layout; inspect tutorial return.
- [ ] Review five passes: source/consumer, no solution/core leak, layout/input, assets/provenance/lifecycle, evidence limits. Correct and rerun.
- [ ] Update existing replan/Decisions/Active Context/Roadmap and runtime receipt, then exact branch checks, normal merge, postmerge main/tests/readback.

Rollback: normal revert of this scoped preview integration; no asset/save/map migration.

## Task 3 — next-loop RB08 strategy evidence

Before changing content, add one hand-authored alternative in tests/fixtures/route_book/route_book_witnesses.gd.
It travels (3,3)->(3,2)->(4,2)->(5,2)->(5,3), avoiding caution (4,3), then rejoins the original path.
Extend the existing real-session witness test with success, exact pickup/delivery order,
visited-cell exclusion, elapsed time and cost observations. These are internal author fixtures,
not a solver, optimality proof or recommended player layout. Test-only work characterizes current
behavior; it is not a new production RED/GREEN claim. If bypass is more expensive/slower, record
that result rather than invent a tradeoff or silently change the approved speed multiplier.
- [ ] Both authored alternatives succeed; record measured difference and remaining design implication.

Next loop: alternative strategy witnesses and content-specific choices; do not claim a single successful witness is a unique or optimal solution.
