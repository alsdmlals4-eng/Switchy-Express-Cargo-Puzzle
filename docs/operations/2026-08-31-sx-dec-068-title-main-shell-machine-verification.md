# SX-DEC-068 Title Main Shell local machine verification

**Status:** `LOCAL_MACHINE_VERIFIED · AWAITING_PR_REVIEW · NO_PACKAGE_CANDIDATE_MINTED`
**Decision:** `SX-DEC-068`
**Implementation commit:** `dc326af61a253f1d10db80bb73c476672a4d3d1b`
**Branch:** `codex/sx068-title-main-shell-20260831`
**Date:** 2026-08-31 KST

## Scope

This verification covers only the new responsive `TitleScreen` shell: its full-viewport backdrop, preserved real entry actions, keyboard focus, and layout bounds. It does not change finite-puzzle rules, maps, stages, Route Book content, save data, score/economy, or bitmap assets.

## RED to GREEN correction

The initial new layout assertions correctly failed before the main-shell scene existed. After the structural implementation, the first GREEN attempt still showed the primary title action below the 960×540 viewport: the two wrapping labels had no minimum width inside their deck, so their calculated heights expanded the panel to 1220px.

The correction was deliberately narrow: both live labels now have a 320px minimum width, allowing Godot's container layout to wrap them at a stable readable width. No action, flow state, theme meaning, gameplay data, or image was changed to address the finding. The complete suite then passed.

## Local commands and results

| Check | Result |
| --- | --- |
| `python tools/validate_project_contract.py` | `PASS` |
| Godot 4.7.1 headless `tests/run_tests.gd` | `PASS · 120 cases · 14,112 assertions · 0 failed` |
| `python -m pytest tests/python -q` | `PASS · 249 passed · 1 skipped` |
| Staged diff whitespace check | `PASS` |

The Godot suite contains the changed title topology/theme/first-session/visual-integration tests and explicit title bounds for `960×540`, `1280×720`, `1600×900`, and `1920×1080`.

## Five-scope adversarial readback

1. **Action and API preservation — PASS.** `StartButton`, `StageBookButton`, `ControlsButton`, and `QuitButton` retain their names, signals, and existing `DemoFlowController` behavior. The controller now owns explicit node-path constants, preventing a silent stale-path connection after the scene restructure. The first-session CTA localization and Route Book entry are covered by the full suite.
2. **Layout, input, and focus — PASS.** `TitleBackdrop` and `TitleShade` ignore mouse input; all four title actions remain within bounds at the tested viewports and retain a 56px-or-greater target. The primary action receives focus whenever the `TITLE` state becomes visible, while the existing visible focus style remains in force.
3. **Asset and provenance — PASS_WITH_BOUNDARY_RETAINED.** The only title bitmap consumer is the pre-existing, tracked `SX-TITLE-HERO-001` (`shell_title_hero_v01.png`). The change creates zero bitmap assets. The eight SX-DEC-067 board images are separate `GENERATED_CANDIDATE_RUNTIME_CONNECTED_NOT_CANON` assets with user pixel review still pending.
4. **Scope containment — PASS.** The diff changes only the title scene layout, title controller path/focus plumbing, associated tests, and the decision/spec/plan/evidence records. No finite rules, authored maps, stage IDs, player save keys, Route Book data, or asset files are changed.
5. **Candidate and evidence ceiling — PASS_WITH_BOUNDARY_RETAINED.** Candidate 007 remains the immutable package evidence for `main@c0bb86efa5bad6050217ca67dd6aa9eba155dc75`. This branch is not merged and no package was minted, so neither Candidate 007 nor this local suite is represented as final-user-ready for the new main-screen bytes. A successful merge requires the explicit Candidate 007 supersession record and a new exact package candidate before any future final user review.

## Evidence ceiling and remaining gates

This is automated local machine evidence only. A live Switchy editor session was not available during this verification, so no physical in-app screenshot is claimed. Five-person comprehension and player-experience studies remain `NOT_REQUIRED_BY_USER_VALIDATION_POLICY`. GitHub CI, merged-main readback, package/export verification, physical Windows, audio, Android-device, accessibility-assistive-device, release, and final-user review remain separate, unclaimed gates.
