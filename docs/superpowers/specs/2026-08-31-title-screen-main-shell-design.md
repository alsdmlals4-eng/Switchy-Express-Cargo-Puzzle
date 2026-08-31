# Title Screen Main Shell Design

**Decision:** `SX-DEC-068`
**Status:** `USER_APPROVED · SPECIFIED`

## Goal

Turn the existing title entry point into a complete responsive main screen while preserving its four established player actions and the approved board-first cozy neo-arcade visual language.

## Player surface

At boot, the player sees the miniature rail world behind a darkened reading surface. The first visual question is answered by the clear title and promise; the first action is the primary start button. Optional content and control help remain visible but quieter on a separate action deck.

```text
TITLE
 ├─ StartButton       → existing BRIEFING flow
 ├─ StageBookButton   → existing ROUTE_BOOK flow
 ├─ ControlsButton    → existing CONTROLS flow
 └─ QuitButton        → existing quit confirmation/exit behavior
```

## Layout

`TitleScreen` remains a full-rect `Control`. Its children, ordered back to front, are:

1. `TitleBackdrop`: full rect, mouse ignored, `ProductShellArt` `TITLE` mode, consuming the approved text-free title hero.
2. `TitleShade`: full rect, a dark low-opacity `ColorRect` that protects copy without hiding the miniature world.
3. `TitleMargin`: a full-rect `MarginContainer` with responsive edge space.
4. `TitleColumns`: an `HBoxContainer` with a left `TitleDeck`, a flexible spacer, and a right `ActionDeck`.

Both decks use existing `ShellPanel` material grammar. The left deck is restrained, not another navigation list; the right deck is the navigation destination. The left deck has a non-interactive 2:1 `TitleLogo` `TextureRect` consuming the transparent `SX-TITLE-WORDMARK-001` candidate, then the existing Korean product promise, an explicit “첫 운행” cue, and the primary existing start control. The right deck gives the three non-primary actions a compact label and existing copy.

At the smallest supported 960×540 viewport the parent margin shrinks, but the action deck stays in view and every button remains 56px high. The title hero is always an aspect-cover backdrop, never a container-sized 96px crop.

## Interaction and accessibility

- `StartButton` is initial focus when the title becomes visible.
- The existing theme's visible gold focus outline remains enabled for all actions.
- Focus moves top-to-bottom through the title actions; initial focus is reset when returning from another shell state.
- Decorative background controls ignore mouse input; the buttons are the only title interaction targets.
- Korean product copy and all action labels stay as live Godot labels. The English title wordmark is a generated raster candidate, so its exact spelling is verified by review and its use remains separate from localization.

## Asset and provenance boundary

The title retains `SX-TITLE-HERO-001` at `art/product_assets/ed_hybrid_v1/shells/shell_title_hero_v01.png`, already a tracked, runtime-verified, text-free backdrop. The user-directed amendment adds exactly one transparent raster title wordmark, `SX-TITLE-WORDMARK-001`, at `art/product_assets/ed_hybrid_v2/shells/shell_title_wordmark_switchy_express_candidate_v01.png`. Its unchanged PNG is `USER_APPROVED_CANONICAL_PRODUCT_ASSET_RUNTIME_CONNECTED · USER_PIXEL_APPROVED · CANON_REGISTERED`, with SHA-256/original-candidate/provenance records and its sole `TitleLogo` consumer held in the project manifest. The eight SX-DEC-067 wayside images remain independent candidates.

## Technical basis

- Use full-rect anchors and `Control` containers rather than guessed screen coordinates.
- Reuse the custom `ProductShellArt` cover draw path, which loads the exact existing asset and does not make a second asset lookup policy.
- Maintain `DemoFlowController` APIs. Add only the smallest title-focus helper required to restore initial focus on TITLE re-entry.
- Add GDScript scene tests for full-rect backdrop, safe mouse filtering, asset mapping, action reachability, and responsive geometry.

The technical feasibility sources are the [Godot Control documentation](https://docs.godotengine.org/en/stable/classes/class_control.html), [TextureRect cover behavior](https://docs.godotengine.org/en/stable/classes/class_texturerect.html), and [keyboard/controller focus guidance](https://docs.godotengine.org/en/stable/tutorials/ui/gui_navigation.html). The project uses Godot 4.7.1; the documented patterns are limited to long-standing `Control`, container, and focus APIs already used by this project.

## Out of scope

- title-art replacement, score/rank/progression/persistence UI;
- new game rules, map data, tutorial stage, first-session sequence, Route Book data, or game-state preview;
- changing the user's machine-primary validation policy;
- declaring physical, user, accessibility-device, platform, release, or final-user review PASS.
