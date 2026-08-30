# Route Book 02 Surface Content Design

**Decision:** `SX-DEC-067`
**Status:** `USER_APPROVED · DEPENDS_ON_WAYSIDE_CORE`

## Goal

Add an optional second set of six fixed, directly selectable authored stages. The book demonstrates known rules in new combinations and introduces only the approved caution/disposal conditions. It does not add progression, score, lock state, or a solution reveal.

## Catalog structure

`RouteBookDefinition` becomes data-driven rather than hard-coding Route Book 01's ID and six stage IDs. It still rejects malformed entries, duplicate stage IDs, paths outside `res://data/maps/route_book/`, `RECOMMENDED_LAYOUT`, and missing command arrays.

`RouteBookCatalog` owns exactly these two definitions:

```text
ROUTE_BOOK_01 → res://data/route_book/route_book_01.json
ROUTE_BOOK_02 → res://data/route_book/route_book_02.json
```

`DemoFlowController` keeps an active book ID plus a `RouteBookDirector` for that book. The Stage Book screen gains two explicit book controls and presents only the active book's six stage cards. `Next Stage` never crosses a book boundary. The first session remains independent.

## Stage contract

| Stage | Main decision | Required special data | Surface tone |
| --- | --- | --- | --- |
| RB07 `FOREST_RELAY` | Revisit to choose the load order. | decorations only | forest and moss |
| RB08 `CAUTION_CUT` | Compare a short slow segment with a longer clean route. | one caution cell | wet stones and warning edge |
| RB09 `SALVAGE_SIDING` | Keep waste and normal cargo in the correct TOP order. | one waste crate and disposal yard | timber salvage yard |
| RB10 `CLEAN_BREAK` | Dispose a TOP waste group, then resume normal service. | caution + disposal | waterway worksite |
| RB11 `TURNOUT_UNDER_LOAD` | Commit the branch before occupancy while accounting for a slow exit. | caution + direct switch | lantern yard |
| RB12 `LANTERN_LOOP` | Combine revisit, Auto choice, disposal, caution, and switch control. | caution + disposal + switch | forest night yard |

Each stage has an authored success witness and at least one precise failure witness that ignores its named decision. The test suite validates the data contract and witnesses; it never exposes a recommended layout in the player UI.

## Localization and visual requirements

Every book/stage title and objective exists in `ko`, `en`, `ja`, and `zh-Hans`. Route Book 02 briefing copy names the actual new condition in one short factual sentence; it does not become an eighth tutorial.

Decorations only inhabit blocked cells. Stages use 4–7 placements selected from the five modular kinds so each map has a distinct silhouette while all buildable and service-critical cells retain a clear grid.
