# SX-DEC-068 · Main Title Shell Composition

**Status:** `USER_APPROVED · TITLE_WORDMARK_CANDIDATE_RUNTIME_CONNECTED · USER_PIXEL_REVIEW_PENDING · AWAITING_PR_REVIEW`
**Date:** 2026-08-31 KST
**Approval source:** The user approved the recommended continuation and explicitly requested “메인화면도 제작해”.

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

It uses a night-rail material language—midnight enamel, antique brass, amber signal lamps, a switch fork, cargo marks, and route geometry—rather than the reference’s fantasy/book motifs. It is a **generated candidate**, not a canonical asset, and retains `USER_PIXEL_REVIEW_PENDING` until the user reviews the actual pixels. Candidate connection is limited to the existing `TitleLogo` consumer and does not alter a puzzle rule, action, or save key.

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

## Candidate and evidence transition

`SX60-POC-ACCEPT-007` is the immutable machine package for exact product bytes at `main@c0bb86efa5bad6050217ca67dd6aa9eba155dc75`. This player-facing title-shell change cannot inherit its final-user-review eligibility.

After the new runtime bytes are machine-verified, Candidate 007 is retained as `HISTORICAL_SUPERSEDED_BY_SX_DEC_068_PLAYER_FACING_PRODUCT_BYTE_CHANGE`; a new exact package candidate must then be minted before any future final user review. This does not invalidate Candidate 007’s existing package integrity evidence for its own source bytes.

## Evidence boundary

Automated scene, focus, responsive-layout, asset-consumer, and full Godot-suite results are machine evidence. Five-person comprehension and player-experience studies remain `NOT_REQUIRED_BY_USER_VALIDATION_POLICY`. Physical Windows, audio, Android-device, accessibility-assistive-device, release, and final-user review states remain separate and must not be inferred from this work.

Candidate generation, its manifest record, import, and automated scene connection also do not constitute a user pixel approval or canonical promotion.

## Title wordmark candidate local machine evidence

The candidate PNG imported as Godot `CompressedTexture2D` with its RGBA channel retained. The candidate-specific provenance/consumer contract passed, and the full headless Godot suite passed at `120 cases / 14,125 assertions / 0 failed`, including `test_demo_theme` and `test_demo_responsive_layout` at 960×540, 1280×720, 1600×900, and 1920×1080. This proves the tracked candidate connects to the intended scene consumer without pushing an action outside the supported screen bounds; it does **not** prove physical-display appearance, player comprehension, user pixel approval, or release readiness.

## Local machine verification

The implementation commit is `dc326af61a253f1d10db80bb73c476672a4d3d1b` on `codex/sx068-title-main-shell-20260831`. Its full local Godot suite, project operating-contract check, and Python suite passed; the focused title topology, consumer, focus, and 960×540 through 1920×1080 layout assertions are included in that suite. The full evidence, the corrective layout finding, and the retained evidence ceiling are recorded in `docs/operations/2026-08-31-sx-dec-068-title-main-shell-machine-verification.md`.

## Owners

- Runtime scene: `game/demo/vertical_slice_demo.tscn`
- Flow and focus: `game/demo/demo_flow_controller.gd`
- Art consumer: `game/demo/presentation/product_shell_art.gd`
- Theme: `game/demo/presentation/demo_theme_factory.gd`
- Design: `docs/superpowers/specs/2026-08-31-title-screen-main-shell-design.md`
- Plan: `docs/superpowers/plans/2026-08-31-title-screen-main-shell.md`
- Local machine evidence: `docs/operations/2026-08-31-sx-dec-068-title-main-shell-machine-verification.md`
- Wordmark candidate evidence: `docs/operations/2026-08-31-sx-dec-068-title-wordmark-candidate-machine-verification.md`
