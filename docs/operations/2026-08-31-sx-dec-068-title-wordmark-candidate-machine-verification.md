# SX-DEC-068 · Title Wordmark Candidate Machine Verification

**Status:** `LOCAL_MACHINE_VERIFIED · USER_PIXEL_REVIEW_PENDING · NOT_CANON`
**Date:** 2026-08-31 KST
**Scope:** `SX-TITLE-WORDMARK-001` only; title presentation candidate with the existing title actions and finite-puzzle rules unchanged.

## Candidate and consumer

| Field | Recorded value |
| --- | --- |
| Candidate | `SX-VIS-068-TITLE-WORDMARK-001` |
| Asset | `SX-TITLE-WORDMARK-001` |
| Tracked path | `art/product_assets/ed_hybrid_v2/shells/shell_title_wordmark_switchy_express_candidate_v01.png` |
| Dimensions / channel | `1774×887` / RGBA PNG (color type 6) |
| SHA-256 | `4faaefca00416119bc0c30e0e45b8e8bf33fe27c72a7466d541ab6c6576244e8` |
| Runtime consumer | `game/demo/vertical_slice_demo.tscn::TitleScreen/TitleMargin/TitleColumns/TitleDeck/Content/TitleLogo` |
| Consumer state | `GODOT_IMPORT_AND_AUTOMATED_TITLE_TEST_PASS` |
| Pixel disposition | `USER_REVIEW_PENDING` |

The generated image is an original rail/cargo wordmark candidate. It is not a canonical asset, does not imply exclusive-rights clearance beyond the project provenance record, and does not replace the approved title backdrop.

## RED → GREEN evidence

1. Added a title-consumer contract first. The full headless suite then failed exactly where expected: missing `TitleLogo` in `test_demo_theme` and at each supported viewport in `test_demo_responsive_layout` (`120 cases`, `14,117 assertions`, `2 failed cases`).
2. Added the transparent PNG, tracked Godot import descriptor, `TextureRect` consumer, manifest/provenance record, and 2:1 `360×180` minimum footprint.
3. Candidate-specific Python contract: `1 passed`.
4. Full project Python contracts: `251 passed, 1 skipped`.
5. Project operating-contract validator: `PASS`.
6. Full Godot headless suite: `120 cases`, `14,125 assertions`, `0 failed`; title theme and responsive-layout cases passed at `960×540`, `1280×720`, `1600×900`, and `1920×1080`.
7. Formal GUT consumers: `7 scripts`, `21 tests`, `152 assertions`, all passed; JUnit validation reported `21 tests`, `0 errors`, `0 failures`.

## GUT output-path incident and correction

The first local GUT invocation executed all 21 tests successfully but emitted `[GUT ERROR]: Could not create export file res://test-results/gut/junit.xml` after the run. Investigation showed that the repository workflow creates `test-results/gut` before invoking GUT, while a fresh local worktree did not have that ignored directory. Creating only that ignored output parent reproduced the CI precondition; the rerun wrote JUnit successfully. No production source, plugin, or test behavior changed for this correction.

## Five adversarial review passes

1. **Action and focus preservation:** scene-only title decoration; `StartButton`, Stage Book, controls, quit, and focus controller paths were not changed. Existing flow/theme tests passed.
2. **Layout and readability boundary:** the candidate ignores mouse input and the four supported viewport assertions proved the logo and all title actions remain in bounds.
3. **Asset and provenance boundary:** PNG signature, dimensions, RGBA channel, SHA-256, tracked import descriptor, manifest entry, and one concrete consumer are contract-tested.
4. **Scope containment:** the diff has no finite rules, maps, stage IDs, saves, economy, score, or tutorial-content changes.
5. **Evidence and canon boundary:** all records state `GENERATED_CANDIDATE_RUNTIME_CONNECTED_NOT_CANON` and `USER_PIXEL_REVIEW_PENDING`; no machine result is presented as a physical-display, player-study, user-approval, or release PASS.

## Evidence ceiling and remaining gate

This verifies source bytes, Godot import, scene connection, automated geometry, and formal test consumers. It does **not** verify a live Switchy editor display, physical Windows/Android display appearance, assistive-device behavior, player comprehension, player-experience study, legal/release readiness, or final user review. The linked live editor was an unrelated `urban-legend` project, so it was intentionally not touched. The next human gate is the user’s visual disposition of this candidate; only explicit approval may promote it to canonical status.
