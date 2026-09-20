# Representative experience/runtime review

> Execute inline with executing-plans; reuse project approval and the shared two-pass review budget.

Goal: verify SX-FUN-01/02/03 in the existing game, correct only demonstrated presentation/flow defects, and test native EXE input capability.
Spec: CORE_GAMEPLAY, PLAYTEST_PLAN current fun sections; September14 remaining-work spec V1; user approved this next batch with “작업진행해”.
Baseline: project main8208010b96c1bdb79b751cfe8c5e866152ca83dc; observed Base main23ecad5a (not repin).

## Global constraints / shared interfaces

- Preserve finite rules, all18 optional stages, approved topdown art, engine4.7.1, save compatibility, installed plugins/global settings and PR174/254/281.
- Existing Main -> demo shell -> ProductFiniteSlice -> HUD/route overlay is the shared consumer. Do not introduce test hooks in product code or force result state.
- Existing machine witnesses prove rules; runtime input/capture proves only the exercised UI paths. HUMAN/FUN_PASS/device/release remain NOT_RUN.
- Hera1.0.0 observes/inputs only; source delta across QA must be NONE. Computer Use uses its bundled sky API only, with fresh returned window/screenshot identity.
- Gameplay source search found no user:// persistence in game/; addon runtime request/heartbeat files are not player saves. Do not change normal save settings.
- Keep task-created intermediate files under build/fun-qa-20260920, later user-deletion holding; do not delete existing files or other processes.

## Tasks / completion ledger

### 1. Establish exact runtime and representative evidence

- [x] Fresh authority/PR/contract check; clean isolated branch; Python baseline330PASS/3environment skips.
- [x] Resolve installed engine4.7.1 and existing enabled Hera1.0.0; record task-owned editor38376. Never target another project instance.
- [x] Run Main; T3/T4 TOP/revisit, T6 lock, capstone failure/Retry/Edit exercised by input; RB08/RB18 via existing machine witnesses (not native input).
- [x] Reuse witnesses; historical outputs preserved. Injected setup is DIAGNOSTIC_ONLY, not input-path acceptance.

### 2. Correct demonstrated defects only

- [x] Classify one presentation-resource lifetime defect; input-tool physical-key mismatch and missing report directory are environment/setup, not game defects.
- [x] Add failing texture-lifetime test, apply minimal catalog ownership correction; actual window RED/GREEN confirms the same defect.
- [x] KEEP game semantics/assets; CHANGE resource ownership only. Full regression/integration recorded below.

### 3. Native EXE path

- [x] Recheck existing RouteBook03 EXE/PCK identity; native window capability available.
- [ ] Native input flow: INCONCLUSIVE_EXTERNAL_INPUT. Do not interfere with the native window after outside input was detected; no success inferred from unrelated progress.
- [x] Independent editor/runtime work continued; native rerun needs an exclusively available window, not a new gameplay decision.

### 4. Integration and durable evidence

- [ ] Review actual captures and state assertions, run focused/full tests; two whole-scope review passes share one budget, with independent whole-branch review.
- [x] Update existing Playtest Plan/Active Context/Decisions and existing cumulative monthly records with verified scope; no new fun report/server/skill.
- [ ] Exact approved protected manifest/checks, normal PR merge, main readback, append existing PDF without duplicate prior entries.
- [x] Gracefully stop only task-owned editor/game processes and verify source delta/remaining process identity.

## Review focus

1. Normal input path versus injected state/accelerated witness evidence.
2. TOP/loading and locked-switch feedback agrees with domain state.
3. Retry creates fresh state while Edit preserves intended layout.
4. Viewport/language/clipping and interleaved inputs cannot imply untested human readability.
5. Native window identity/package hashes and protected worktree/process ownership.

Ruling: use this existing repository plan/ledger and existing test owners instead of another orchestration workspace/report; project lean execution contract and user cumulative-record preference take precedence. If no defect is demonstrated, verification-only delivery is valid; unknown findings are not manufactured implementation work.

## Executed observations (2026-09-20 KST)

- Main/runtime baseline8208010b; no product source changes. Godot4.7.1 a13da4feb,
  existing Hera1.0.0, editor38376 and game14648, ko1280x720 render /1920x1080 logical input.
- T1: select Straight, place three connected cells through actual mouse events -> T2 briefing.
  Initial clicks without selecting a tool correctly did not build; not a product defect.
- T2: no load -> ROUTE_END, map1/train0. Retry + physical Shift -> T3 briefing.
  Non-physical synthetic Shift did not match the project's physical-key binding; physical=true
  did. This is tool configuration, not evidence that the player's keyboard is broken.
- T3: authored six-cell straight layout placed through mouse events; hold Shift, pause.
  HUD showed TOP A/star x1, total2 and B then A/TOP. Resume -> T4 briefing.
- T4: all-load attempt -> ROUTE_END, map0/train1. Retry, release Shift after A at(5,4),
  re-press on return at(6,2) -> T5 briefing. Read-only renderer state guided timing;
  this is synthetic gameplay input with authored knowledge, not spontaneous human understanding.
- T5: Auto ON, OFF after second safe A, manual load on return -> T6 briefing.
- T6: build seven pieces using ordinary tools; a misplaced orientation triggered station
  preflight rejection until corrected through the same UI. While train occupied(3,3),
  click the switch: before/after both locked=true and selected_exit=(1,0); then capstone briefing.
  See t6-occupied-before/after.json and capture under the evidence directory.
- Pre-fix full Godot tests:131 cases/17,040 assertions PASS, no SCRIPT ERROR/ERROR in log.
  GUT21tests/152assertions PASS on recheck. First run could not write absent
  test-results/gut/junit.xml parent; creating that task-local report directory fixed export.
  No engine/plugin/global setting or product change was made.
- Route Book runner:18 SUCCESS including RB08/RB18; book03 six fresh Retry/same-layout Edit checks.
  Reused existing runner with only temporary output-directory and fixture-locator substitutions,
  preventing overwrite of historical user:// evidence. Authored layouts, direct commands,
  accelerated0.05 steps and actual Main renderer: DIAGNOSTIC_MACHINE, not physical input.
  Original runner owner remains tests/runtime/route_book_completion_window_runner.gd.
- Native EXE/PCK SHA256:1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244 /
  f43eeebbedc1cab88e4ae9d5e2a4cab4cc20201c0134589019b9548fa9477c6b (September14 package,
  sourcec9e6a6d; not latest-main rebuild). Sky initialized and exact window461540 observed.
  First attempted native click stopped on external-input detection; refreshed window showed
  unrelated gameplay. No subsequent native control; NATIVE_INPUT_PATH_INCONCLUSIVE.
- Research disposition: REUSED_EVIDENCE for gameplay; targeted Godot Resource/RenderingServer
  documentation used for the confirmed resource-lifetime correction below. No new mechanic.
- Current disposition: KEEP rules/assets, CHANGE texture lifetime, RETEST native owned-window input.
  HUMAN/FUN_PASS, physical audio perception, device and release remain NOT_RUN.

Evidence directory: `evidence/runtime/fun-review-20260920/`. Captures are actual engine frames,
not generated images. Capture/record date is2026-09-20, separate from older package source date.
Product runtime used no outcome forcing, product node setters or test-layout installation in
the interactive T1–T6 path. The separate authored Route Book machine runner did use test setup.

## Confirmed finding and correction: SX-FUN-02 presentation

P2: `RouteControlOverlay._draw_semantic_target` acquired temporary texture arrays from
`SemanticAssetCatalog.textures_for`; no owner retained textures after the draw call.
Actual T6 showed white target rectangles despite valid approved transparent PNGs.
Godot's resource cache drops resources when references are released; drawing a texture RID
does not transfer resource ownership. Primary sources, read2026-09-20:
[Resource](https://docs.godotengine.org/en/stable/classes/class_resource.html),
[Rendering servers](https://docs.godotengine.org/en/stable/tutorials/performance/using_servers.html).
ADOPT explicit resource lifetime; do not change engine version based on web stable docs.

Minimal implementation: per-catalog path→Texture2D retention for both imported and PNG fallback;
reset clears that ownership. No singleton/global cache, asset edits, new icons or rule changes.
Existing catalog test now checks all four switch states across draw-scope exit, repeated use and
reset. RED:8 lifetime/identity failures; GREEN:40 total assertions, zero failures.
An initial test accidentally retained resources in its own function scope; that invalid probe was
replaced by a helper returning only weak references before the valid RED was accepted.

Actual ProductFiniteSlice T6 window regression (authored fixture/clock, not native input):
without correction, five target regions were94–100% white and failed the <=25% blank-white guard;
with correction, all six state/target samples have0% near-white pixels and the approved icons
are visible. Both runs use the same product scene/map/viewport; no terminal result is injected.
Runner:`tests/runtime/semantic_texture_window_runner.gd`; `semantic-red.json` / `semantic-green.json`
and matching captures in the evidence folder. Standalone renderer fixture does not instantiate
the Main theme shell, so its grey surroundings are diagnostic context, not a new art direction.
Initial runner `Control.to_global` error was rejected; it now uses the real global transform and
fails closed on incomplete captures. Deferred audio teardown is allowed two frames before quit;
the final run has no SCRIPT ERROR/ERROR/WARNING. Earlier failing probes remain task intermediates.

Capstone pre-fix input evidence:51 pieces entered through real build-tool clicks using authored
layout knowledge, cost5400; no-load150s timeout, map4/train0. Retry changed attempt identity,
started with empty stack/Auto OFF; Auto ON then reached success. Actual Edit button preserved
the exact layout. Evidence is bounded synthetic input, not human fun or optimal-solution proof.

Post-fix full regression:131 cases/17,064 assertions, zero failures; all18 Route Book witnesses
and six book03 Retry/Edit checks passed again. Independent whole-scope review pass1 found no
P0/P1/P2 correction required; requested explicit inclusion of ignored raw logs and separation of
pre/post-fix test counts, both handled in this closeout. The white-ratio guard is narrowly for the
reproduced white-box defect, not proof against every possible missing-icon failure.
Python regression initially found two exact approval-ID assertions still describing the previous
method-only batch. Updated their expected exact arrays to this approved combined protected delta;
did not weaken protected-path or historical-candidate checks. The exact protected-path validator
also required the sole approved product file (semantic_asset_catalog.gd) in the manifest; added
that exact path and a matching test, not a wildcard. An initial local invocation incorrectly used
the archive-only checker folder as the Git evidence repository; rerun uses the actual Base Git
repository for pinned history and the unchanged adopted checker snapshot for validation.

Final local Python330 PASS /3 optional-environment skips; post-fix GUT21 tests/152 assertions PASS.
Raw pre/post-fix and approval-assertion RED/final GREEN logs are explicitly tracked in the evidence
directory (normally ignored *.log). Route completion after-fix receipt/log are separately named.
Existing monthly preview:12 original rendered pages byte-identical, one dated addition ->13pages;
new page visually checked. Canonical PDF publication follows merged source, never this preview.
Owned game14648 stopped, editor38376 gracefully closed with exact project command-line check.
Project.godot/import metadata had EOL-only rewrites, normalized in the index with no semantic delta.
313 verified task-created sidecars/intermediates (61,034,440bytes) moved, not deleted, into
`C:/Users/user/Downloads/Switchy_삭제대기_20260920_runtime`; manifest.json records original path,
holding path, SHA256, reason and non-overwrite restore procedure. Other worktrees/processes untouched.

Next: final independent review, normal required-check merge/main readback, new user-testable export
and canonical monthly append. Current PR/check/merge state is the GitHub authority; remaining native
input needs an exclusively available window. No human/device/release PASS follows from this batch.
