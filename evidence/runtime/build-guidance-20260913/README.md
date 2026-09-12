# BUILD guidance evidence

Source baseline: d01454a4f911e9c95314d3b002d6931b4a77c447. Current task plan:
docs/superpowers/plans/2026-09-13-build-guidance.md.

## Automated checks

- Unchanged baseline attempt 1 terminated after first-session end-to-end output without TEST SUMMARY (tool exit 1). Not PASS and not attributed conclusively to an engine module.
- Windows Application error observed: Godot 4.7.1 native exception 0xc0000005, offset 0x321e44b. Event correlation with that exact headless PID remains unverified.
- Unchanged baseline attempt 2: 124 cases / 15,368 assertions / 0 failed / native exit 0.
- RED: new real-validator/presenter/HUD case failed eight guidance assertions. Full suite: 125 cases / 15,411 assertions / one failed case / native exit 1.
- GREEN: 125 cases / 15,411 assertions / 0 failed / native exit 0.
- Python: 273 passed / 1 skipped. Project operating contract: PASS.
- Log locator: Godot user data build-guidance-baseline.log, build-guidance-red.log, build-guidance-green.log (local diagnostic logs, not release artifacts).

## Evidence ceiling

Native intermittent exit: ROOT_CAUSE_UNRESOLVED. A serial successful run is not a fix.
No renderer/plugin/engine setting was changed. Other editors and PR254 remain untouched.
UI copy repair is independent and does not change validator priority or graph legality.
Actual main scene run started in verified Switchy worktree editor PID26468, session suffix eeb9,
at 1280x720 with no current-run errors. Capture/state evidence follows below; no human play claim.
Physical devices, final user appearance and release validation: NOT_RUN.

## Final local review and live readback

- Final suite after reviewer corrections: 125 cases / 15,415 assertions / 0 failed / exit 0.
- Independent reviewer completed five passes (semantics, code coverage, state freshness,
  layout risk, scope). Found missing controller Undo/Redo guidance assertions and UNLOADING
  hidden-state coverage; both corrected. No confirmed production logic defect found.
- Actual RB01 main runtime: removing witness piece 4 produces UNREACHABLE_STATION_SERVICE.
  station-guidance.png is the unscaled 1280x720 capture. Text is fully visible; problem stations
  remain marked. Label size 1388x55 logical pixels, minimum height 55.
- Actual synthetic pointer Undo restores PASS/banner=false; Redo restores
  UNREACHABLE_STATION_SERVICE/banner=true. No human interaction claim.
- A first inline QA expression failed compilation and left eval unavailable. It was not counted
  as runtime PASS. Stopped/relaunched the same verified project, then used the tracked QA script;
  new startup had no current-run errors and the script/capture returned successfully.
- Existing banner spans the upper board/right-column area; broad responsive layout changes
  and all-small-device claims are not part of this copy correction.
- Human Blueprint remains the preceding 56-page review artifact, not a screenshot of this copy.

PROJECT_ONLY lesson: actual machine error enums and UI branches had drifted. Real validator
fixtures routed through presenter/HUD catch this; no duplicated legality or new framework needed.
Base promotion: NO_PROMOTION (no cross-project validation).

Current-task remote checks/merge/post-merge state must be read from its PR. These are local
pre-merge results; unresolved crash investigation remains separate backlog, not a solved defect.
