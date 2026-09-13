# Canonical admission / exact restoration — local Windows proof

Final readback: PR306 merged normally as e40b2ec6922e1d3f1f20b46392eb94f589997d2d;
all five required checks SUCCESS at d6ad8f8365aaa5dfc158d778a975fed46f029875.
Local active checkout HEAD matched origin/main. Product paths game/data/art/project.godot
have no change from PR305, so its exact-source verified executable remains the product handoff.
Existing216 tracked local import/settings modifications were preserved, not called clean.

RED actual official Windows Pilot rejected CRLF source with TARGET_SCENE_CONTRACT_MISMATCH.
Snapshot7506bytes raw7b24444f1031f3eb9f323a60a5222d4fbf1088502567b228754e432328727e24;
LF7222bytes matches pinnedc5f69f957b462a916d424f4487bfc6025901b9254a5425623619952562623f62.
Python canonical admission and editor raw admission disagreed. red.json preserves failure.

Project-local wrapper now captures bytes once before plugin activation, checks canonical
LF content against unchanged pin, and keeps raw snapshot SHA for subsequent checks and
exact-byte restoration. Existing actual-file check rejects changes after snapshot.
Vendor, baseline, source scene, game consumers, undo and restore behavior unchanged.

Marker RED1 -> GREEN7 (structural regression only). Actual Windows Editor Pilot green.json:
PASS/exit0, original_scene_byte_count7506, original/restored raw hash identical7b24444f...,
all inspect/dirty/save/undo/restore/adversarial flags true, batch64, protected346files intact.
Its full product regression129/16133 PASS. Two exact known dummy-renderer thumbnail errors
are reported by existing policy, not suppressed as zero. Report windows_runtime:NOT_RUN
is a generic physical-game limitation, not a denial of this actual Windows editor run.
No physical input/human usability/external transport/production adapter approval implied.

Independent review Critical0/Important0/Minor0; five-pass source identity, same-snapshot
restore, inheritance, protected boundaries and evidence ceiling closed.
Full Python309passed/1skipped,exit0 with GODOT_BINARY; contract PASS. The optional
GODOT_BIN-configured pytest remains skipped; the direct actual Pilot run above is separate.

Separate Linux PR305 first Pilot attempt failed RESTORE_TARGET_MISMATCH after saved undo;
unchanged retry passed. No cause/fix is claimed for that intermittent observation.
If recurrent, next diagnostic must record active root identity, scene path, filesystem scan,
undo history/action and node names around undo. Do not fix it by arbitrary extra waits.

## Product delivery readback

PR305 merged a6f6fb2dbdf02535c0a3312acb209cacbda1c3f8, required five checks SUCCESS.
Artifact34733288630 source92d24f40b4a3f5ba4a5f60efaff75eaa11ed8455 tree
08d30a3b292bde40dfa0b3f88ea5d5ba81bf7e41 equals merged tree.
Current package: C:/Users/user/Downloads/Switchy_Playable_20260913_PR305.
EXE102982144bytes SHA1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244;
PCK57885664bytes SHA3bd6993fba9dc52d27ea310fee9e2e7140832cf1a848cb1b36babc7220fb25cd.
Supervised120-frame EXE headless/window both exit0; mounted PCK2books/12BUILD/31JSON PASS.
Correct editor26468 run15 RB01 actual SUCCESS, terminal guidance empty, returned TITLE.
One earlier eval used mixed indentation and failed compilation; corrected tab-indented
eval ran successfully. This was a tool-eval error, not a product-source correction.

Cleanup: diagnostic17799files7551218997bytes moved to
C:/Users/user/Downloads/Switchy_User_Delete_Review/20260913-native-tools.
PR303 package3files and PR305 proof extras5files moved to sibling20260913-pr305-package-cleanup.
Every moved file pre/post SHA verified, manifest includes original/holding/restore.
No deletion, official Godot/project untouched. Space is reclaimed only if user deletes.
Initial diagnostic manifest aggregate was null due to hashtable enumeration; corrected
to independently measured7551218997, per-file hash verification was unaffected.

Product ready for final user review is not public release or zero-warning/all-defect proof.
Separate frame diagnostic ObjectDB warnings and final human/rights/device gates remain.
