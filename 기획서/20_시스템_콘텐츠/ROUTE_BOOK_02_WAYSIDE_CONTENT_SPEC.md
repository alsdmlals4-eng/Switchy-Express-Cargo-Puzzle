# Route Book 02 · Wayside Content Specification

**Decision:** `SX-DEC-067`
**Status:** `USER_APPROVED · IMPLEMENTED_LOCAL_MACHINE_RUNTIME_VERIFIED · NOT_MERGED`

## Content promise

Route Book 02 lets the player solve six fixed miniature delivery puzzles in a more lived-in railway landscape. A hazard is always visible and authored; a waste crate is always a deliberate LIFO obligation, never random punishment.

## Stage order

| Stage | Player observation | Required choice | Failure counterexample |
| --- | --- | --- | --- |
| RB07 Forest Relay | Five blocked landscape modules frame a two-cargo relay. | Load Blue then Red so the Red delivery clears first and Blue remains for the final service pass. | Skip the first cargo and leave it unresolved. |
| RB08 Caution Cut | Two early cells use the visible 0.55 caution departure multiplier. | Preserve the same reverse load order while the authored slow segment consumes time. | Skip the later Red cargo and end with a required delivery unresolved. |
| RB09 Salvage Siding | A W-marked crate is paired with an off-track disposal yard. | Load waste first, normal Red second, then clear Red before the waste yard. | Pass the normal cargo and arrive at normal service with no matching TOP cargo. |
| RB10 Clean Break | A return loop crosses one caution cell before the final disposal service. | Deliver Red, revisit the waste crate, then clear it beside the disposal yard. | Load both cargoes on the first pass so waste blocks the Red service. |
| RB11 Turnout Under Load | A selected switch feeds a caution departure and a waste disposal endpoint. | Select the delivery branch before occupancy, then preserve the Red-before-waste TOP sequence. | Keep the default branch and take the factual finite failure. |
| RB12 Lantern Loop | Five decoration kinds frame a waste, Auto-load, caution, and switch composite. | Auto-load the initial waste, manually layer Yellow/Red, then complete Red → Yellow → disposal. | Use the wrong switch selection and end on the finite route failure. |

## Decoration allocation

Each map has four to seven `board_decorations` entries on blocked cells only. RB07 uses forest/moss, RB08 waterway/boulder, RB09 timber/lantern, RB10 waterway/timber, RB11 lantern/boulder, and RB12 forest/lantern/waterway. Decorations never share a cell with active puzzle data.

## Content exclusions

No extra tutorial, unlock, ranking, map generator, editor, or recommended solution belongs to this book.

## Local machine evidence

All six success witnesses and their factual counterexamples are in `tests/route_book/test_route_book_machine_witnesses.gd`. The current worktree's full Godot result is `PASS · 120 cases · 14,047 assertions`; live Godot inspection confirmed the bounded book selector and RB12 build board. Exact scope and non-claims are recorded in `docs/operations/2026-08-31-sx-dec-067-local-machine-runtime-verification.md`.
