# Actual-window stage-preview QA plan

Product853a635 / Blueprintae79bdc; diagnostic PR295 changes no product behavior.
Current gap: earlier preview checks covered1280x720, and one capture retained a
stale progress label. Need a repeatable actual-selection/post-draw QA consumer.

ADOPT existing tests/runtime/build_history_live_qa.gd input/capture convention.
ADAPT current Godot viewport stretch: physical Window.size and logical1920x1080
must be recorded separately. REJECT arbitrary screenshot mockups and treating
programmatic checks as human legibility/device approval.
No new UI design decision; prior official Godot container/viewport methods apply.

1. Build one opt-in live helper against Main/VerticalSliceDemo, existing Catalog,
   Definition and localized Copy owners. No private director mutation.
2. Exercise12 stages ×4 locales ×3 requested physical window sizes
   (960x540,1280x720,1600x900), reading back the actual accepted size.
3. Check stage-selection success, actual map identity, exact progress/context,
   zero player rails, no running gameplay, square cells, panel/Begin bounds.
   Await real frames/draw before capturing representative smallest-window states.
4. Restore original window size/locale and return to title; output explicit
   PASS/FAIL/observed dimensions and source bindings. No save/progression writes.
5. Run helper in verified Switchy session, inspect captures, correct proven
   in-scope issues with RED-first tests if found, independent five-pass review,
   full regression, normal PR/checks/merge/post-merge readback.

Native crash diagnosis remains locally deferred pending a traced recurrence or
matching native debugging evidence. No deletion or extra bitmap creation.

## Observed feasibility correction

The embedded editor game rejected960x540 and1600x900 window requests, remaining
1280x720. Initial matrix correctly returnedFAIL (144 selections,2 size failures),
not multi-sizePASS. Run the same helper through a minimal opt-in standalone
SceneTree QA launcher loading actual Main, preserving the normal product entry.
This launcher is live presentation QA, not a replacement for the full deterministic
runner. Keep the failed embedded receipt separate; only capture accepted sizes.

## Execution result and owner correction

Standalone144 combinations /3 synthetic Begin checks /0 failures; accepted actual
sizes match all three requests. Four960x540 locale captures visually inspected.
Independent five-pass review found two minor issues, both corrected: restoration
must fail on mismatch and exact source/QA/capture fingerprints are now recorded.
Publication/source tests:3 new tests PASS; full Python304 passed/1 skipped;
full deterministic Godot127 cases/15,701 assertions/0 failures in stage-window-full.log.
The latest successful run does not fix the historical intermittent native exit.

Fresh remaining-work audit found two stale owner statements: the replan still
called the eleven additional approved/implemented assets pending; Development Gates
still labeled the September1 snapshot current. Corrected those local statements,
retaining their historical evidence and the current Active Context route.
No Base promotion: embedded-window refusal and this narrow QA are project-specific
observations, not yet broadly validated shared policy.
