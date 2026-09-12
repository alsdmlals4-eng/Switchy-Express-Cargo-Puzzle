# BUILD guidance and stability investigation implementation plan

> Execute task-by-task using superpowers:executing-plans. User approved the preceding recommendation on 2026-09-13; no routine reapproval is required.

**Goal:** Explain actual preflight failures without changing route legality, and investigate the previously observed native test-process exit without speculative engine changes.

**Architecture:** Reuse PreflightValidator -> FiniteSlicePresenter -> ProductHUD and existing board problem-cell markers. The validator remains the only legality authority. Keep presentation copy in the existing HUD; no new subsystem, solver, bitmap, provider or save migration.

**Tech Stack:** Existing Godot 4.7.1 / GDScript / repository test runner.

**Spec:** Approved chat plan: construction/retry stabilization; existing SX-DEC-060 cardinal service contract and core-preserved replan remain authoritative.

## Constraints and evidence

- Source main d01454a4f911e9c95314d3b002d6931b4a77c447; Base observed d830c0f6967678eed3c208ac6b24f9cd1b262ec3, no compatibility repin.
- Existing dirty imports/project.godot are preserved. PR174/254/281 are read-only. User performs final deletion.
- UI guidance must distinguish cargo exact-cell pickup from station cardinal-adjacent service, excluding diagonal/footprint service.
- No reclassification of route-end legality, irrelevant disconnected islands, failure priorities or RUN input.
- Five-pass review, full regression and actual runtime evidence are required before completion; a repeated successful run does not prove the native crash fixed.

## Comparison and feasibility

Current consumer sends UNREACHABLE_CARGO and UNREACHABLE_STATION_SERVICE, while HUD matches neither and falls back to generic copy. Reuse those codes and existing markers (ADOPT).
Factorio FFF412 (https://www.factorio.com/blog/post/fff-412, read in preceding recommendation) explains action feedback: adapt actionable local information, reject remote/complex history preview for this task.
Godot official debugging overview (https://docs.godotengine.org/en/stable/tutorials/scripting/debug/overview_of_debugging_tools.html, read 2026-09-13): retain logs and inspect real runtime state (ADOPT); no inferred renderer fix.
Alternatives: (1) change existing HUD copy (selected: actual codes already sufficient), (2) new issue-list navigation panel (defer: additional interaction/space cost), (3) automatic route solver (reject: changes protected puzzle boundary).

## Task 1: Native-exit investigation

- [ ] Read previous failure evidence and current process identity.
- [ ] Run unchanged full suite serially and retain summary/exit. Repeat to distinguish reproducible failure from unresolved intermittent behavior.
- [ ] Record observed results and limits; do not mark original crash fixed without root cause. Do not stop unrelated editors or absorb PR254.

## Task 2: Actual preflight explanation

Files: game/demo/presentation/product_hud.gd; tests/demo/test_build_guidance.gd; tests/run_tests.gd.
Interface: existing apply_model(Dictionary), primary_reason, problem_cells and start_enabled; no new domain interface.

- [ ] RED: instantiate real HUD and send distinct UNREACHABLE_CARGO and UNREACHABLE_STATION_SERVICE; assert displayed instructions distinguish exact-cell and cardinal-adjacent service, not generic fallback.
- [ ] Test all actual failure codes for nonempty actionable guidance; PASS hides banner, RUN hides it; controller edits/Undo/Redo recompute rather than retain stale failure.
- [ ] Implement minimal match branches for EMPTY_LAYOUT, INVALID_START, DANGLING_EDGE, UNREACHABLE_CARGO, UNREACHABLE_STATION_SERVICE, INVALID_CROSSING, INVALID_SWITCH_EXIT, PERMANENT_TRAP; retain compatible legacy aliases.
- [ ] Full runner RED->GREEN and five review passes: semantic authority, code coverage, state freshness, layout/readability, scope/evidence.

## Task 3: Delivery

- [ ] Actual Godot main/HUD check and capture; small-screen results are not physical-device proof.
- [ ] Update current Active Context, Roadmap and approved decision with plan-first execution policy and honest evidence.
- [ ] Run project/Python checks, exact changed-file review, push task branch, required checks, normal merge and post-merge readback only if all mandatory evidence is complete.

No Base promotion: this is currently a project-specific code/copy mismatch, not cross-project validated learning.
