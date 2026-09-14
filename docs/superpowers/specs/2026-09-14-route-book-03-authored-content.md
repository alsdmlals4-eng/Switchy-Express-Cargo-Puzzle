# Route Book 03 - authored coordinates and execution contract

Status: IMPLEMENTED / MACHINE_VERIFIED / checkout RUNTIME_VERIFIED on September14.
Each of six positive/negative map pairs passed before third-book exposure. Current
evidence owner: evidence/runtime/route-book-03-20260914/README.md. Package and merged
implementation readback remain separate; no final USER_APPROVED/release claim.
Authority: September14 user-approved C2 in `2026-09-14-remaining-work-design.md` and
CURRENT_CONFIRMED_DECISIONS. This is the detailed realization of that approved scope,
not PR281 adoption and not a new SX-DEC-070. Base compatibility v9.4.3 unchanged.
Research owner: remaining-work spec section3 (Railbound/Train Valley ADAPT); no copied
maps or new mechanics. Existing topdown assets only; new bitmap count0.

## Coordinates and serialization

Coordinates are zero-based [x,y]. JSON uses definition_schema_version3,
map_revision1, ruleset_version fp_core_v2, marker_tracks_player_built=true,
allow_open_terminals_after_required=true. Each map has one rectangular build area
[1,1] through [board_width-2,board_height-2]. Incoming is [0,start_y].
Stations are off-track objects, cardinal-only service; no diagonal or footprint service.
All rows below are exact authoring inputs; production JSON becomes the geometry owner
after implementation. Paths are TEST-ONLY witnesses, never player solution UI.

Notation B=BLUE_DIAMOND, R=RED_STAR, W=WASTE_CRATE. A W destination is DISPOSAL_YARD.

| Stage | Board / start / seconds | Cargo in map | Destinations | Caution | Blocked/decor |
|---|---|---|---|---|---|
| RB13_FOUR_SIDES | 10x8 / [1,3] /110 | B[3,3], R[5,4] | R[6,2], B[8,6] | none | FOREST_CLUSTER[3,1], MOSS_BOULDER[2,6] |
| RB14_MANIFEST_MIRROR | 12x9 / [1,2] /130 | R[3,4], B[4,4], R[5,4] | R[8,3], B[9,7] | none | TIMBER_STACK[7,1], LANTERN_FENCE[2,7] |
| RB15_MANUAL_GAP | 12x9 / [1,4] /150 | R[5,4], B[6,4] | R[9,2], B[8,7] | none | FOREST_CLUSTER[3,2], WATERWAY[4,7] |
| RB16_CAUTION_LEDGER | 12x9 / [1,5] /145 | B[3,5], R[5,5] | R[8,2], B[10,7] | [3,5],[7,4],[8,4] | MOSS_BOULDER[4,2], TIMBER_STACK[5,7] |
| RB17_CLEARANCE_YARD | 12x9 / [1,3] /155 | W[3,3], W[4,3], R[6,3] | R[8,1], W[10,6] | none | FOREST_CLUSTER[1,7], LANTERN_FENCE[7,7] |
| RB18_SWITCHBOARD_NIGHT | 15x11 / [1,5] /190 | W[3,5], W[4,5], R[7,4], B[8,4] | R[10,2], B[13,6], W[10,8] | [3,5],[6,4],[9,6] | FOREST_CLUSTER[3,2], MOSS_BOULDER[5,8], TIMBER_STACK[12,9], LANTERN_FENCE[2,8] |

Each listed decor cell is blocked; no invisible additional obstacles. Existing approved
station/cargo/caution/decoration/rails consumers render this data without new resources.
Numbers are conservative authoring limits, not human-tested difficulty claims. Runtime
validation may correct an impossible connection within this approved finite scope;
update this handoff and JSON/test evidence together if a coordinate changes.

## Exact authored positive and negative traces

The following sequences start at the immutable start marker (do not place player rail
there). Each adjacent pair differs by exactly one cardinal step. At the last cell,
the outgoing port continues the incoming travel direction. Repeated orthogonal visits
use CROSSING; all other bends encode their incoming/outgoing cardinal ports.

### RB13 - service face reading

Positive:
`[1,3],[2,3],[3,3],[4,3],[4,4],[5,4],[6,4],[6,3],[7,3],[8,3],[8,4],[8,5]`.
Manual load on, B->R pickup, R->B unload. Red service at[6,3], blue at[8,5].
Negative diagonal-only red approach:
`[1,3],[2,3],[3,3],[4,3],[4,4],[5,4],[6,4],[7,4],[7,3],[8,3],[8,4],[8,5]`.
Must fail preflight for missing red service (nearest[7,3] is diagonal). Separate
placement at red station[6,2] must be rejected. Do not call a failed build a RUN failure.

### RB14 - route order creates a contiguous TOP pair

Positive:
`[1,2],[2,2],[3,2],[4,2],[4,3],[4,4],[4,5],[3,5],[3,4],[4,4],[5,4],[6,4],[7,4],[8,4],[9,4],[10,4],[10,5],[10,6],[9,6]`.
[4,4] is CROSSING; manual load on. Pickup B,R,R; unload R,R as one group then B.
Negative first-row pickup order:
`[1,2],[2,2],[2,3],[2,4],[3,4],[4,4],[5,4],[6,4],[7,4],[8,4],[9,4],[10,4],[10,5],[10,6],[9,6]`.
Pickup R,B,R; red service removes only the top R, blue removes B, and one R remains
when the route ends. Must reach FAILURE with remaining cargo, not SUCCESS.

### RB15 - manual gap and revisit

Positive:
`[1,4],[2,4],[3,4],[4,4],[5,4],[6,4],[7,4],[7,3],[6,3],[5,3],[5,4],[5,5],[6,5],[7,5],[8,5],[9,5],[9,4],[9,3],[10,3],[10,4],[10,5],[10,6],[9,6],[8,6]`.
[5,4] is CROSSING. Manual load skips R on first contact, loads B[6,4], then R[5,4]
on the second contact. Red service[9,3], blue service[8,6].
Negative uses the same connected layout with Auto always ON: R then B blocks red
service, later blue clears but red remains, FAILURE. Assert skipped first contact and
actual second pickup in positive, not only final outcome.

### RB16 - caution does not bypass occupied switch lock

Positive:
`[1,5],[2,5],[3,5],[4,5],[5,5],[6,5],[7,5],[7,4],[8,4],[8,3],[9,3],[10,3],[10,4],[10,5],[10,6]`.
Override[7,5] to SWITCH rotation0 (WEST/EAST/UP); default EAST.
Add straight EAST spur[8,5],[9,5]. Before occupancy select UP. Manual load on.
During occupancy, attempting EAST is rejected and selected UP remains unchanged.
Negative leaves EAST selected; while occupied attempts UP, which is rejected, then
the spur ends with undelivered cargo. Both preflights pass; positive SUCCESS,
negative FAILURE plus occupied-lock rejection. Caution never changes lock semantics.

### RB17 - clear ordinary cargo before a waste group

Positive:
`[1,3],[2,3],[3,3],[4,3],[5,3],[6,3],[7,3],[7,2],[8,2],[9,2],[9,3],[9,4],[9,5],[9,6]`.
Manual pickup W,W,R; unload R at[8,2], then W,W as one group beside yard[10,6].
Negative takes R before the waste pair:
`[1,3],[2,3],[2,2],[2,1],[3,1],[4,1],[5,1],[6,1],[6,2],[6,3],[6,4],[5,4],[4,4],[4,3],[3,3],[3,4],[3,5],[4,5],[5,5],[6,5],[7,5],[7,4],[7,3],[7,2],[8,2],[9,2],[9,3],[9,4],[9,5],[9,6]`.
At red service W is TOP; disposal removes W,W but leaves R, so FAILURE.
Assert a two-item waste unload event on positive; no new disposal rule.

### RB18 - integrated dispatch

Positive:
`[1,5],[2,5],[3,5],[4,5],[5,5],[6,5],[6,4],[7,4],[8,4],[9,4],[9,3],[8,3],[7,3],[7,4],[7,5],[7,6],[8,6],[9,6],[9,5],[10,5],[10,4],[10,3],[11,3],[12,3],[12,4],[12,5],[12,6],[12,7],[11,7],[10,7]`.
Override[6,5] to SWITCH rotation0 default EAST; select UP before occupancy.
[7,4] repeated visits=CROSSING; override[7,5] to CROSSING and add spur[8,5] STRAIGHT0.
Auto ON for W[3,5],[4,5]; OFF before first R[7,4] contact, which is skipped.
Manual load B[8,4], then R[7,4] on return. Pickup W,W,B,R; unload R,B,W,W,
including a two-waste group. Assert Auto ON->OFF. While the train occupies SWITCH
[6,5], attempt EAST and require rejection plus selected UP unchanged. Checking the
neighbor CROSSING[7,5] is not a substitute for this switch-specific observation.
Negative preserves correct switch but keeps Auto ON throughout: W,W,R,B blocks
red unload and later waste disposal. Must be FAILURE, with all attempted contacts
observed. No fabricated terminal outcome or special success rule.

## Production and test integration

- Catalog adds ROUTE_BOOK_03 with exact definition/copy/display paths.
- Definition's expected ID list adds the six IDs above, in order. For book03,
  reject missing context and map_path that does not exactly match its stage ID.
  Existing book01/02 optional-context semantics remain unchanged.
- New selector_v1 owns shared selector labels and existing translations. Retain unused
  legacy selector duplicates in books01/02 as non-owner compatibility data during this
  bounded change; the actual selector consumer must read only selector_v1. Do not add
  duplicates to book03 or redesign the general localization loader.
- book03_v1 provides all four locales for stage title/objective/context and per-book
  progress/Begin/Next. Check actual `FirstSessionCopy` consumers, not key counts only.
- New fixtures and witness tests stay separate from old12. An explicit stage->book
  table in runtime QA prevents RB13+ being accidentally selected as book02.
- Production UI remains catalog-driven; no recommended-layout function, save, unlock,
  reward, timer/speed/cost rule or new artwork. Main Start still opens T1.
- Runtime completion verifies explicit18-ID set and all18 SUCCESS. Preview verifies
  216 (18x4x3) states plus pointer Begin per book/window; actual list/result layouts
  checked at960/1280, four locales, including long text and last-stage boundaries.
- Refresh dependent screenshot/PDF/receipt inputs after code/copy changes. Historical
  screenshots keep source labels; no old receipt automatically transfers to new bytes.

Exact localization owner matrix:

| Keys | Active owner / consumer |
|---|---|
| SX_RB_STAGE_BOOK, SX_RB_SELECT_BOOK, SX_RB_SELECT_STAGE, SX_RB_BACK | selector_v1 / main, selector, list, result list-button |
| SX_RB01_STAGE_BOOK, SX_RB02_STAGE_BOOK, SX_RB03_STAGE_BOOK | selector_v1 / catalog book cards |
| SX_RB_PROGRESS, SX_RB_BEGIN, SX_RB_NEXT_STAGE | each selected book copy / Briefing and Result Next |
| SX_RB13..18_TITLE, _OBJECTIVE, _CONTEXT | book03_v1 / stage cards and Briefing |

Independent pre-implementation review found these two ambiguities (selector ownership
and RB18 lock target); both corrected before implementation. Geometric review found no
collision, but actual feasibility remains unproven until machine/runtime execution.

## Five pre-implementation adversarial checks

1. Core/scope: paths use only current ports, cardinal service, exact pickup and LIFO.
2. Geometry: orthogonal sequences, station footprints excluded, obstacles not on witnesses;
   machine tests must reject any invalid placement, preflight or missing contact.
3. Negative meaning: RB13 preflight failure differs from five actual delivery failures;
   outcomes alone are insufficient without expected group/order/lock/contact observations.
4. UI/assets: new data must reach existing preview/HUD/results; four locales and book
   context reset are explicit, bitmap0, no solution leaks or inherited old-book labels.
5. Evidence/authority: independent review before exposure; exact package and merged-main
   readback before completion. PR281 and old Decision IDs protected; human/release separate.
