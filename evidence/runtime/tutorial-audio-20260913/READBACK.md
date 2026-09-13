# Tutorial success audio lifecycle

Parent main8b8cb04f0bd7db7049983d91cc5141c232275171 (PR302, five CI green).
Plan/research/five-pass: docs/superpowers/plans/2026-09-13-tutorial-transition-audio.md.
Existing T2–T6 success cue now belongs to persistent shell while retiring product
audio stops first. No scene delay, global singleton, art, new sound, mix or core change.
T1/failure/capstone and Route Book results preserve their existing paths.

## Verified evidence and corrections

- Initial test draft called nonexistent advance_for_test: SCRIPT ERROR, NOT_RED/PASS.
  Corrected to actual advance_time before product implementation.
- tutorial-audio-red-corrected.log:2 actual assertions failed, exit1; leak warning
  retained, not a clean pass. Missing shell cue and retiring product duplicate detected.
- tutorial-audio-capture-final.log and receipt.json:8 cues plus actual T2→T3,
  63 assertions PASS/exit0. Old product freed=true, shell still active, capture cleared
  AFTER destruction, surviving output peak0.02446315, eventual stopped=false playing.
  Receipt exact LF source hashes bind implemented code, tests and engine.
- tutorial-audio-regression.log:129cases/0failed/16056assertions, exit0.
- Actual correct live editor26468/main.tscn/run12: T3, retiring product cue=false,
  shell cue=true immediately; later false, then return_to_title. No other editor touched.
- Changed shell hashes invalidated two existing visual receipts. Actual four-locale
  HUD/result and144 preview checks rerun, exit0. Preview parent revision plus exact
  source hashes represent working delta; NOT clean parent-byte proof.
- Refreshed result PNG changes required Blueprint publication regeneration; do not
  edit expected hashes without rerunning consumers/publication.
- Final full Python308passed/1skipped, exit0 after runtime/publication refresh.
  PDF77pages, no empty/out-of-bounds text, changed page4 and page13 rendered/inspected.
  Publication SHA c2365ffcfe176b4ff53d999f6ba90d57bb49e9e4b717669c8e746e5ddd932c55.

Independent review found capture before product destruction could falsely pass. Fixed
by clearing capture only after destruction+active checks; exact rerun measures tail.
Independent final readback closed P2, no additional important finding.

Machine capture does not prove all5 tutorial transitions directly, full downstream
audio waveform, human listening/UX or release. Shared branch is covered structurally;
T2→T3 is the actual measured consumer. Native C0000005 remains NOT_FIXED.
No retry PASS is presented as native repair. Whole-game completion remains open.

Learning: check lifetime of generated feedback, not cue-name bookkeeping; discard
pre-boundary samples when proving surviving output. Project-specific evidence only,
no unreviewed Base promotion.

## Merged delivery and replacement playable package

PR303 merged478530552884fdaa1534c85e8f37da8b376d2965 through normal protected flow,
five exact checks PASS. CI34730405830 artifact sourcec0390def1414917ccfea248592ecda02a6da1ee3
tree9979a6f4b63dcaad1c4088b16beee307241a9688 equals merged-main tree.
Current local package:C:/Users/user/Downloads/Switchy_Playable_20260913_PR303.

- EXE102982144bytes SHA256:1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244.
- PCK57885728bytes SHA256:e5b9ad1b57080bb21681fd54249ef9a465114cb6692a659e9062ff478a9f805b.
- README explains controls and unfinished native/human/release gates. Only these three
  files remain in the playable folder; proof-only extras are not game dependencies.
- Actual EXE headless and window startup120frames each: supervised process exit0.
  User-data logs:pr303-package-headless-final.log and pr303-package-window.log.
  Window renderer OpenGL3.3/NVIDIA RTX3050. Early unsupervised GUI invocation did not
  supply reliable exit evidence; only the later waited process results count.
- Official editor console mounted the actual PCK with the existing external verifier:
  pr303-package-consumer.log, exit0,2books/12stages/12actual BUILD entries,31JSON PASS.
  This is not12-stage gameplay completion, human visual approval or crash repair.

Cleanup holding:C:/Users/user/Downloads/Switchy_User_Delete_Review/20260913-pr303-package-cleanup.
Eight files moved with pre/post SHA verification:three superseded PR299 playable files
and five PR303 proof extras. manifest.json records exact original/holding paths, hashes,
sizes and non-overwriting restore instructions. User deletes manually; nothing deleted.
Active diagnostic build, unknown project files and open-PR worktrees remain untouched.
