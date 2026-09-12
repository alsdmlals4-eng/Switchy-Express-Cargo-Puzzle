# BUILD recovery implementation review

Source main: `07a04d58c9071fd687e5e2d223354d2d42112adf`. Current task branch:
`codex/build-edit-history-20260912`. Latest user delegates routine researched improvements.
Base completed remote main `d830c0f6967678eed3c208ac6b24f9cd1b262ec3` was inspected;
both Base validation workflows completed successfully. Historical compatibility and provider unchanged.
Current Base receipt validator was executed directly from its exact Git blobs without changing Base.
Start receipt PASS checks recorded consistency, not product behavior.

## Research and feasibility

See the single design-owner amendment and `contract.json` benchmark entries. Three real
implementation alternatives were compared: copied domain snapshots, inverse edit commands,
and engine UndoRedo actions. Existing copied finite layouts minimize operation-specific rollback
code and avoid callbacks retaining the session. Reuse existing editor validation, cost derivation,
preflight, controller dispatch, scene buttons and current approved art. No new imagery or dependencies.
Public developer/product facts support iteration and restoration; no representative player sample
was recruited. UX benefit remains a hypothesis for final user review, not machine-proven fun.

## Five full-scope review loops and corrections

Each loop checked scope/core, ownership/consumer wiring, state transitions, UI/readability,
rights/provenance, import/runtime and evidence claims. The focus and result below identify
the main finding, not a substitute for whole-scope coverage. These are implementation review
loops, not five human playtests or five independent reviewers.

1. Domain boundary: copied signature includes initial switch direction; failed/no-op edits keep
   redo; changed edits branch; total retained history bounded. Batch replacement needed validation
   in a separate candidate before swap, now implemented and tested, including middle failure/duplicates.
2. Lifecycle/integration: controller refreshes preflight and costs; starter installation and Edit
   establish a new baseline; fixed lessons deny commands; RUN domain lock remains. Added explicit
   baseline and middle-batch tests. Existing core, authored solutions and maps unchanged.
3. UI/input: separate right-side panel does not overlap the board; buttons and keyboard reach
   the same dispatch. Initial live mouse witness failed because it used logical coordinates as
   physical coordinates: viewport logical 1920x1080, actual 1280x720, final scale 0.666667.
   Fixed only the QA coordinate conversion and reran the actual event path successfully. Shortened
   availability copy after inspecting the initial screenshot's awkward Korean word wrap.
4. Independent code review (`build_history_review`): no blocking finding, code-level merge-ready
   subject to final regression/runtime/CI. Reviewer inspected this scoped uncommitted delta read-only;
   no engine sessions or user files touched. Reviewer-noted pointer/keyboard coverage addressed by
   live Input.parse_input_event witness. Atomic middle failure and starter tests added. No foreign art,
   no generator bitmaps, no core or paid/provider scope drift.
5. Final full regression and publication: Godot 124 cases / 15,368 assertions / zero failures.
   Python 273 passed / 1 skipped; project operating contract PASS. Live actual 1280x720 main-scene
   event witness PASS. PDF changed sections visually inspected; removed an unnecessary near-empty
   page introduced while inserting the recovery section. Source fingerprints checked by existing
   Python tests. Remote checks/normal merge/post-merge readback are owned by this task's PR.

## Evidence / limitations

Verified product source: `5ca785228b9e3204e43078169d98d56519d412c2`.
Final Human Blueprint: 56 pages; SHA-256
`5389f08919eb8ba3b02bf169191ff49f6790725e523206e81f68c4ceaeaec109`.
Final publication fingerprint tests: 2 passed after density correction.

- `red-behavior.log`: expected feature-missing assertion. Earlier `red.log` was a test authoring
  parse error (missing fourth TrackPiece.create argument), corrected before counting valid RED.
- `ui-red.log`: expected missing visible action; `domain-green.log` / `integration-green.log` show
  subsequent successful increments; `final-godot.log` is the full final product regression.
- `receipt.json` and `layout/cleared/restored/edit-baseline.png`: fresh actual main scene, synthetic
  mouse and key input, layout/cost restoration, RUN lock and Edit baseline. Programmatic navigation
  and authored witness are not user play. New game startup returned no current-run errors.
- Full Python run after first PDF regeneration: 273 passed / 1 skipped (11.16 s). Final publication
  hash readback is rerun after the density correction. A skip is not PASS for that case.
- Small physical viewport, real devices, perceptual audio, final human approval and release NOT_RUN.
- Pre-existing dirty project/import files and other PRs are preserved. No direct file deletion.

## Learning and next safe boundary

PROJECT_ONLY: history must restore geometry, switch exit and derived cost together; seed/Retry/Edit
are lifecycle boundaries, not player edits. Test batch failure after at least one valid piece.
QA lesson: transform logical Control coordinates before injecting physical window pointer events.
Base promotion: NO_PROMOTION; one project integration is insufficient cross-project proof.
No automated study or new five-person validation requirement was introduced.
After this scoped unit passes normal remote checks, merge and read back exact main. Final player
appearance/device/release remain separate; do not revive retired features or read-only PRs.
