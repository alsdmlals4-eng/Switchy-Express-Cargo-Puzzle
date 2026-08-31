# SX-DEC-068 · Main Title Shell Composition

**Status:** `USER_APPROVED · MERGED_MAIN_VERIFIED · PR_271 · TITLE_WORDMARK_USER_PIXEL_APPROVED_CANON_REGISTERED · CANDIDATE_009_PREPARED_PACKAGE_VERIFIED · FINAL_USER_REVIEW_NOT_RUN`
**Date:** 2026-08-31 KST
**Approval source:** The user approved the recommended continuation and explicitly requested “메인화면도 제작해”; the user then explicitly approved the title-wordmark pixels for canonical promotion on 2026-08-31 KST.

## Decision

Replace the compact, center-only title card with a responsive title shell that uses the already tracked title artwork as a full-viewport visual field and retains the existing, real gameplay entry actions.

```text
existing text-free title hero
→ full-viewport, non-interactive backdrop
→ left: game promise + first-session entry
→ right: Stage Book / controls / quit action deck
→ existing TITLE → BRIEFING / ROUTE_BOOK / CONTROLS flow
```

The result is a title screen that reads as a game entry surface rather than a narrow dialog over an unused background. It changes neither the finite puzzle rules nor the first-session and Route Book content.

### Title wordmark candidate amendment

The user clarified that the requested logo is the game’s in-world title treatment, not a plain UI label. The title shell therefore receives one real, transparent railway wordmark candidate: `SX-TITLE-WORDMARK-001` / `SX-VIS-068-TITLE-WORDMARK-001`.

```text
"SWITCHY EXPRESS" live title label
→ generated transparent railway wordmark candidate
→ 2:1 non-interactive TextureRect in the existing left title deck
→ unchanged Korean promise, first-run cue, and title actions
```

It uses a night-rail material language—midnight enamel, antique brass, amber signal lamps, a switch fork, cargo marks, and route geometry—rather than the reference’s fantasy/book motifs. The original `SX-VIS-068-TITLE-WORDMARK-001` candidate has now received explicit user pixel approval and is registered as a **canonical product asset**. Its original candidate ID, generation receipt, hash, stable tracked path, and sole `TitleLogo` consumer remain preserved for provenance. The canonical promotion alters no puzzle rule, action, or save key.

## Existing-solution and alternative study

| Option | Result | Decision |
| --- | --- | --- |
| Reuse `SX-TITLE-HERO-001` at full viewport scale; keep all current controls and flow APIs | Uses an approved, text-free 1774×887 runtime asset whose left-side negative space already supports Godot-owned copy. Lowest provenance and maintenance risk. | **ADOPT** |
| Generate a second title panorama | Would duplicate a concrete, already suitable title-art consumer and require another user pixel review without improving a gameplay decision. | **REJECT** |
| Put an interactive live game board behind the menu | Couples menu availability to mutable game state, competes with the explicit entry buttons, and weakens keyboard navigation. | **REJECT** |
| Replace the title only with another styled Godot `Label` | Keeps text live but cannot supply the requested world-setting title treatment or convey the rail/cargo identity at first glance. | **REJECT** |
| One transparent, generated rail wordmark in the existing `TitleDeck` | Has one concrete title-screen consumer, preserves action/focus behavior, and stays reviewable as a separate candidate. | **ADAPT** |

The feasibility basis is Godot's documented full-rect `Control` anchoring, `TextureRect` aspect-cover behavior, and explicit keyboard/controller focus navigation. The implementation uses the project’s existing `ProductShellArt` rather than adding an unreviewed UI plug-in or bitmap.

## Exact UI contract

- `TitleBackdrop` is a full-rect, mouse-ignored `ProductShellArt` in `TITLE` mode and consumes only `shell_title_hero_v01.png`.
- A translucent left reading deck owns the non-interactive `TitleLogo` candidate, Korean promise, first-session cue, and existing `StartButton`.
- A bounded right action deck owns the existing `StageBookButton`, `ControlsButton`, and `QuitButton`; buttons retain their existing signals and command routing.
- The primary action remains keyboard/controller focusable when `TITLE` becomes visible. All actions retain an explicit focus style and a 56px-or-greater height.
- The visual field must remain readable at 960×540, 1280×720, and 1920×1080; the wordmark is given a fixed 2:1 menu footprint and the remaining action copy stays live Godot text.
- No gameplay rule, map, stage ID, save key, economy, score, or tutorial content changes.

## User pixel approval and canonical promotion

| Option | Result | Decision |
| --- | --- | --- |
| Leave the approved pixels in `generated_candidates` and keep Candidate 008 current | Conflicts with the explicit approval and leaves the packaged manifest’s live owner state false. | **REJECT** |
| Move the approval into a document outside the packaged manifest | Avoids reminting a package, but splits the asset’s approval status away from its project-owned runtime asset record. | **REJECT** |
| Promote the unchanged file in the project manifest and mint a new exact package candidate | Keeps SHA-256/provenance/consumer/approval co-located and makes the user-review package byte-specific. | **ADOPT** |

This is a metadata and ownership transition only: the approved PNG bytes, scene path, input/focus flow, finite rules, maps, stage IDs, saves, score, economy, and tutorial content do not change. The product manifest is intentionally included in the PCK, so its status update requires a new exact package candidate.

## Candidate and evidence transition

`SX60-POC-ACCEPT-007` is the immutable machine package for exact product bytes at `main@c0bb86efa5bad6050217ca67dd6aa9eba155dc75`. This player-facing title-shell change cannot inherit its final-user-review eligibility.

`SX60-POC-ACCEPT-008` now binds the exact title-shell source at `main@53e29f874bc70a0057c310d661dc45dbecc6cf13`: GitHub Actions Windows Demo Export run `33392296685`, artifact `9757983433`, ZIP digest `f11fc0dc64ac59ce86d581bdb68e5833d79e92ec6345112c470a5f3a26b9902a`, and independent 575-entry PCK audit all passed. Candidate 007 is retained as `HISTORICAL_SUPERSEDED_BY_SX_DEC_068_PLAYER_FACING_PRODUCT_BYTE_CHANGE`; its own package evidence remains valid only for its own source bytes.

Candidate 008 remains immutable evidence for its own pre-canonical-status package bytes, including its then-pending wordmark disposition. It is historical after the manifest promotion and must not be used for a later final-user review. `SX60-POC-ACCEPT-009` now binds the exact canonical-status source at `1ac3099d9ab1451323cca2935547f82d210b50b4`: GitHub Actions Windows Demo Export run `33396533310`, artifact `9759591197`, ZIP digest `fe90c0b85abfa23684ac07b1cfb391e3b56e3f6f912180bd9702311b3fbefc22`, Windows PCK digest `5f5de90db1587f07c8e44e9ae1c8efcde8db6bd3c222785bf4f8eea5a4478d8c`, runtime JSON proofs, and an independent 575-entry PCK audit all passed. Candidate 009 is the current machine-primary package and is the only exact candidate eligible for a later final-user review. The asset’s user pixel approval is complete, but it does not imply physical display, device, accessibility, human/player, release, or production-cutover approval.

## Evidence boundary

Automated scene, focus, responsive-layout, asset-consumer, and full Godot-suite results are machine evidence. Five-person comprehension and player-experience studies remain `NOT_REQUIRED_BY_USER_VALIDATION_POLICY`. Physical Windows, audio, Android-device, accessibility-assistive-device, release, and final-user review states remain separate and must not be inferred from this work.

Candidate generation, import, and automated scene connection did not themselves constitute pixel approval. The user’s explicit pixel approval now completes canonical promotion, while the replacement package, physical display, device, accessibility, human/player, release, and production-cutover evidence remain separate.

## Title wordmark candidate local machine evidence

The candidate PNG imported as Godot `CompressedTexture2D` with its RGBA channel retained. The candidate-specific provenance/consumer contract passed, and the full headless Godot suite passed at `120 cases / 14,125 assertions / 0 failed`, including `test_demo_theme` and `test_demo_responsive_layout` at 960×540, 1280×720, 1600×900, and 1920×1080. This proves the tracked candidate connects to the intended scene consumer without pushing an action outside the supported screen bounds; it does **not** prove physical-display appearance, player comprehension, user pixel approval, or release readiness.

## Local machine verification

The title-shell changes were merged through PR #271 at `main@53e29f874bc70a0057c310d661dc45dbecc6cf13`. Its full local Godot suite, project operating-contract check, Python suite, and the exact-source remote export all passed; the focused title topology, consumer, focus, and 960×540 through 1920×1080 layout assertions are included in that evidence. The explicit pixel approval was then registered in the manifest without changing the PNG or game behavior, and Candidate 009 provides its own exact-source package proof. The historical Candidate 008 proof and retained evidence ceiling are recorded in `docs/operations/2026-08-31-sx-dec-068-title-wordmark-candidate-machine-verification.md`; the current Candidate 009 proof is recorded in `기획서/50_제작_검증/SX_DEC_060_POC_ACCEPTANCE_CANDIDATE_09.md`.

## Owners

- Runtime scene: `game/demo/vertical_slice_demo.tscn`
- Flow and focus: `game/demo/demo_flow_controller.gd`
- Art consumer: `game/demo/presentation/product_shell_art.gd`
- Theme: `game/demo/presentation/demo_theme_factory.gd`
- Design: `docs/superpowers/specs/2026-08-31-title-screen-main-shell-design.md`
- Plan: `docs/superpowers/plans/2026-08-31-title-screen-main-shell.md`
- Local machine evidence: `docs/operations/2026-08-31-sx-dec-068-title-main-shell-machine-verification.md`
- Wordmark candidate evidence: `docs/operations/2026-08-31-sx-dec-068-title-wordmark-candidate-machine-verification.md`
