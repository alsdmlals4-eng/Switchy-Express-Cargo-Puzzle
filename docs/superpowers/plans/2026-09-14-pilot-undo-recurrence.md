# D2 recurring editor undo diagnosis

Authority: current user continuation and approved remaining-work D2 recurrence trigger.
Baseline main5309829b; PR312 first Linux Pilot run failed dirty_undo while exact-byte
final restore passed. Same-head rerun passed. Cause is not established.

Order: add behavioral assertion for the actual Pilot's undo-boundary diagnostics;
observe missing-evidence RED; record before/immediate-after/next-frame history and
scene snapshots without extra undo, waiting, reopening, or acceptance changes; run
isolated Windows Pilot and remote Linux Pilot; compare failure/success evidence;
only then propose a demonstrated root-cause correction. Existing vendor remains pinned.

Capture: history id/version/action, root instance/path, target and renamed node presence,
scene SHA, filesystem scan state, unsaved scene status, monotonic timestamp and undo return.
No absolute user paths, node text or secrets. Diagnostics are test-tool output, not game UI.
Original bool acceptance and one process-frame wait stay unchanged.

Research: https://docs.godotengine.org/en/stable/classes/class_editorundoredomanager.html
ADOPT per-scene history inspection. Direct UndoRedo operations may affect editor state;
REJECT blindly adding waits, clearing history, vendor migration or masking a failed undo.
No product/art/core/release change; package from PR312 remains unchanged.
