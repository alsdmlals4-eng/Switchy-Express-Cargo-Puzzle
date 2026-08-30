# Route Book 02 · Wayside Content Specification

**Decision:** `SX-DEC-067`
**Status:** `USER_APPROVED · IMPLEMENTATION_NOT_STARTED`

## Content promise

Route Book 02 lets the player solve six fixed miniature delivery puzzles in a more lived-in railway landscape. A hazard is always visible and authored; a waste crate is always a deliberate LIFO obligation, never random punishment.

## Stage order

| Stage | Player observation | Required choice | Failure counterexample |
| --- | --- | --- | --- |
| RB07 Forest Relay | A forest siding sits beyond an early ordinary delivery route. | Revisit the siding to place the needed normal cargo on TOP. | Take the direct route and arrive with the wrong TOP. |
| RB08 Caution Cut | A visibly worn short cut crosses one caution cell; a clean outer loop is longer. | Choose a route that meets the time limit after the 0.55 departure multiplier. | Use the short cut when its total elapsed time expires. |
| RB09 Salvage Siding | One violet hexagonal waste crate shares a siding with normal deliveries. | Plan waste to be TOP at the disposal-yard service pass. | Reach disposal with a normal TOP cargo and leave waste aboard. |
| RB10 Clean Break | A caution approach reaches a disposal yard before two normal destinations. | Dispose the waste group, then rebuild the delivery stack. | Deliver normal cargo first so waste blocks the later service pass. |
| RB11 Turnout Under Load | A branch locks before a caution exit. | Select the correct branch before occupancy and account for the slow departure. | Switch late, take the terminal, or lose the time budget. |
| RB12 Lantern Loop | A night loop exposes a forest relay, waste siding, caution exit, and one switch. | Combine revisit, Auto off/on, LIFO, disposal, and branch timing. | Auto-load or branch selection creates an unrecoverable TOP/route state. |

## Decoration allocation

Each map has four to seven `board_decorations` entries on blocked cells only. RB07 uses forest/moss, RB08 waterway/boulder, RB09 timber/lantern, RB10 waterway/timber, RB11 lantern/boulder, and RB12 forest/lantern/waterway. Decorations never share a cell with active puzzle data.

## Content exclusions

No extra tutorial, unlock, ranking, map generator, editor, or recommended solution belongs to this book.
