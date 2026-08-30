# Route Book 01 Stage Pack Design

**Decision:** `SX-DEC-066`
**Status:** `USER_APPROVED · IMPLEMENTED_LOCAL_MACHINE_VERIFIED · NOT_MERGED`
**Content source:** `기획서/20_시스템_콘텐츠/ROUTE_BOOK_01_STAGE_CONTENT_SPEC.md`

Implementation follows this architecture at local commits `d1d2087` and `49574b249cf4cfa675d4ba804851bfeb5e317dff`. The local machine evidence is recorded separately; this design does not claim merge, hosted CI/package, an exact candidate, or user/physical evidence.

## 1. Architecture

`Route Book 01` is a data-driven optional stage surface. It does not alter the current first-session state machine or put a second campaign progression model inside finite gameplay.

```text
data/route_book/route_book_01.json
        ↓
RouteBookDefinition → RouteBookDirector
        ↓                    ↓
route-book locale JSON   selected stage + next-stage state
        ↓                    ↓
  FirstSessionCopy parser  DemoFlowController
                                ↓
          existing Briefing / ProductFiniteSlice / Result recovery
                                ↓
            existing FiniteMapLoader + current finite runtime
```

### Separate responsibilities

| Owner | Responsibility | Does not own |
| --- | --- | --- |
| `RouteBookDefinition` | Strict, read-only validation of exactly six ordered stage records | map schema, game rules, UI state |
| `RouteBookDirector` | Volatile current-stage selection, next-stage availability, reset | persistence, unlocks, game results |
| `FirstSessionStagePolicy` | Existing generic feature and input allow-list projection for a Route Book stage record | stage selection or map interpretation |
| `FirstSessionCopy` | Existing JSON string parser, extended only with a path loader while keeping `load_default()` | gameplay facts or locale fallback invention |
| `DemoFlowController` | Title/Stage Book/briefing/gameplay/result screen orchestration | finite rules, map validation, save data |
| `FiniteMapDefinition` + finite runtime | Current v3 map/routing/cargo/station authority | Route Book order, unlock state, result navigation |

## 2. Data interfaces

### Route Book definition JSON

`data/route_book/route_book_01.json` has exactly this top-level contract:

```json
{
  "schema_version": 1,
  "book_id": "ROUTE_BOOK_01",
  "stages": [
    {
      "stage_id": "RB01_SERVICE_SIDINGS",
      "map_path": "res://data/maps/route_book/rb_01_service_sidings.json",
      "title_key": "SX_RB01_TITLE",
      "objective_key": "SX_RB01_OBJECTIVE",
      "visible_features": ["BOARD", "STRAIGHT", "CURVE", "SWITCH", "CROSSING", "ROTATE", "REMOVE", "CLEAR", "PREFLIGHT", "LOAD", "AUTO_LOAD", "STACK_TOP", "SWITCH_STATE", "TIME"],
      "allowed_build_tools": ["STRAIGHT", "CURVE", "SWITCH", "CROSSING"],
      "allowed_build_commands": ["BUILD_TOOL", "BOARD_CELL", "CANCEL_SELECTION", "ROTATE", "REMOVE", "CLEAR", "START"],
      "allowed_run_commands": ["LOAD_ACTIVE", "AUTO_TOGGLE", "BOARD_CELL", "SWITCH", "PAUSE", "RESUME"]
    }
  ]
}
```

The other five entries use the same feature/command sets and replace only `stage_id`, `map_path`, `title_key`, and `objective_key`. Exact required order:

```gdscript
const REQUIRED_IDS: Array[StringName] = [
    &"RB01_SERVICE_SIDINGS",
    &"RB02_REVERSE_ORDER",
    &"RB03_RETURN_MANIFEST",
    &"RB04_LOAD_WINDOW",
    &"RB05_FORK_LOCK",
    &"RB06_PORT_CIRCUIT",
]
```

`RECOMMENDED_LAYOUT` is intentionally omitted. This causes the existing HUD visibility gate to hide the action and prevents `RecommendedLayoutProvider`, which only owns `VS_DEMO_01`, from presenting a no-op control.

### Required director interface

```gdscript
class_name RouteBookDirector
extends RefCounted

func configure(definition: Variant) -> bool
func reset() -> void
func stage_ids() -> Array[StringName]
func stage(stage_id: StringName) -> Dictionary
func current_stage_id() -> StringName
func current_stage_number() -> int
func stage_count() -> int
func current_stage() -> Dictionary
func select_stage(stage_id: StringName) -> bool
func has_next_stage() -> bool
func advance_to_next_stage() -> bool
```

`select_stage` and `advance_to_next_stage` change only the in-memory index. They never write a file, preference, profile, unlock, or statistic.

### Copy interface

`FirstSessionCopy` gains a public loader without changing current default behavior:

```gdscript
func load_from_path(path: String) -> bool
func load_default() -> bool: return load_from_path(DEFAULT_PATH)
```

The Route Book creates a separate copy instance using `res://data/localization/route_book_01_v1.json`. Missing keys return the existing safe empty string; all required Route Book keys must instead be validated by tests for all four current locales.

## 3. Flow and UI design

### State additions

`DemoFlowController` adds one state only:

```gdscript
const ROUTE_BOOK: StringName = &"ROUTE_BOOK"
```

The existing `BRIEFING`, `GAMEPLAY`, and `RESULT` states are reused. A private `_route_book_active: bool` distinguishes the two callers while a Route Book stage is selected.

```text
TITLE ── Start ───────────────→ existing first-session BRIEFING
TITLE ── Stage Book ──────────→ ROUTE_BOOK
ROUTE_BOOK ── card select ───→ BRIEFING (Route Book stage card)
BRIEFING ── Start ───────────→ GAMEPLAY
GAMEPLAY ── terminal ────────→ RESULT
RESULT ── Next Stage ────────→ BRIEFING (next Route Book record)
RESULT ── Stage Book ────────→ ROUTE_BOOK
RESULT ── Retry/Edit ────────→ existing same-layout recovery
```

The standard Title action always preserves its current behavior. Opening Route Book never resets, rewrites, skips, or completes a first-session lesson.

### Scene changes

`game/demo/vertical_slice_demo.tscn` adds:

1. `TitleScreen/Panel/Content/StageBookButton`, a 56px minimum-height button below Start.
2. `RouteBookScreen`, a `CenterContainer` with one `ShellPanel`, title, short explanatory label, a scrollable `VBoxContainer` named `StageList`, and a 56px Back button.
3. `ResultOverlay/Panel/Content/RouteBookActions`, a separate two-button row containing `StageBookButton` and `NextStageButton`. It is hidden outside active Route Book result state.

The existing result action row remains untouched for first-session and standalone demo behavior. The new panel/controls must fit 960×540, 1280×720, 1600×900, 1920×1080, and 2560×1080 with every visible touch target at least 48px on both axes.

### UI behavior

- Route Book creates six cards from validated definition data, in declared order; cards are all selectable on every fresh launch.
- The generic briefing panel shows `Route Book 01 · N / 6`, the localized title/objective, existing neutral lesson art, and a start CTA.
- Route Book maps receive `FirstSessionStagePolicy.create(current_stage())` to show all production controls but hide `RECOMMENDED_LAYOUT`.
- `NextStageButton` is visible only for a successful Route Book stage when `has_next_stage()` is true; it releases the completed product instance, advances the director, applies the next briefing card, and does not fabricate a result history.
- `StageBookButton` returns to the list after releasing the gameplay instance. It does not reset the first-session director.

## 4. Map and witness strategy

The six map bytes follow the exact marker specifications in the content source. Their fixture scripts live under `tests/fixtures/route_book/`, one named file per stage. Every fixture constructs player-owned track with `TrackPiece.create`; none is wired to production UI as an automatic layout.

The shared test helper creates a run only through the real consumer chain:

```text
FiniteMapLoader
→ FiniteBuildSession.place_piece
→ begin_run / PreflightValidator
→ FiniteRunSessionFactory
→ session.run_controller + real input state
→ terminal phase and delivery-event history
```

This prevents a map from being accepted only because a fixture bypassed preflight, input, LIFO, route-control, station, or result authority.

## 5. Verification plan and evidence ceiling

### RED-first coverage

1. Route Book data rejects missing/duplicate/out-of-order IDs, empty map/copy keys, unsupported command arrays, and missing maps.
2. Director cannot select unknown stages, cannot advance after the final stage, and writes no persistence.
3. Stage Book entry cannot alter title/first-session flow, but each selected stage reaches the correct map and all controls except recommended layout.
4. Each map loads as schema v3, passes its success witness, and retains its central negative case.
5. Route Book next/list actions appear only in the correct result state and do not alter Retry/Edit behavior.
6. Stage Book and result controls stay inside supported viewports and preserve 48px targets.

### Exact checks after implementation

```text
python tools/validate_project_contract.py
python -m pytest tests/python -q
Godot 4.7.1 --headless --path . --script res://tests/run_tests.gd
required GitHub CI/export/package checks on exact PR head
post-merge exact-main readback
new exact candidate mint and machine verification
```

The user-approved validation policy applies: `FIVE_PERSON_COMPREHENSION_NOT_REQUIRED` and `PLAYER_EXPERIENCE_STUDY_NOT_REQUIRED`. No unexecuted visual, audio, device, human, or release gate is reported as passed.

## 6. Five-scope pre-build adversarial review

| Scope | Finding tested | Disposition |
| --- | --- | --- |
| First-session scope | Adding T7 or changing the existing lesson list would violate the retained contract. | Corrected by using a separate Route Book definition/director and direct Title entry. |
| Legacy-content revival | Existing map selection, Yard Labs, Mastery, Daily/Weekly, and generator code could be accidentally reused. | Rejected; Route Book uses only current finite-map consumers and has no unlock/generation path. |
| Rule drift | New maps could encode station-as-rail, diagonal delivery, FIFO, or branch auto-reset behavior. | Prevented by v3 map validation plus exact central-decision witnesses/counterexamples. |
| UI/asset drift | A generic full-control HUD would show a no-op recommended layout or encourage new art. | Route Book policy hides `RECOMMENDED_LAYOUT`; existing shells and product assets are reused without new bytes. |
| Evidence drift | Current Candidate 005 or automatic results could be overstated as proof for changed product bytes or human experience. | Candidate transition is explicit; only a new exact candidate can receive machine acceptance, and human evidence stays `NOT_RUN` unless performed. |
