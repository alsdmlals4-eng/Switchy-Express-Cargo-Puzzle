# Route Book 01 · Stage Content Specification

**Decision:** `SX-DEC-066`
**Status:** `USER_APPROVED · SPECIFIED · IMPLEMENTATION_NOT_STARTED`
**Content boundary:** Six optional, fixed post-onboarding stages. This file does not change T1–T6 or `VS_DEMO_01`.

## Common authoring contract

```yaml
map_schema: FiniteMapDefinition_v3
ruleset_version: fp_core_v2
marker_tracks_player_built: true
allow_open_terminals_after_required: true
controls: STRAIGHT, CURVE, SWITCH, CROSSING, ROTATE, REMOVE, CLEAR, PREFLIGHT, LOAD, AUTO_LOAD, STACK_TOP, SWITCH_STATE, TIME
hidden_control: RECOMMENDED_LAYOUT
result_recovery: RETRY_SAME_LAYOUT, EDIT_LAYOUT, STAGE_BOOK, NEXT_STAGE_when_available
art: existing_ProductBoardRenderer_assets_only
locales: ko, en, ja, zh-Hans
progression: no_unlocks_no_save_all_six_directly_selectable
```

Each map must have a deterministic success witness held only in tests. A witness never becomes a player-facing recommended layout or solver reveal. Each stage also owns a counterexample that proves its central decision matters.

## Stage sequence

| Order / ID | Player-facing Korean name | Map identity | Board / time | Central decision | Required automatic evidence |
| --- | --- | --- | --- | --- | --- |
| 01 · `RB01_SERVICE_SIDINGS` | 역 옆의 선로 | `RB01_SERVICE_SIDINGS@1` | 9×7 / 90s | Match exact cargo contact with a legal cardinal service pass; route must not treat the station footprint as rail. | schema + reachable preflight + success witness + no footprint/diagonal delivery regression |
| 02 · `RB02_REVERSE_ORDER` | 역순 적재 | `RB02_REVERSE_ORDER@1` | 11×7 / 105s | Build encounter order so a required Red-then-Blue unload sequence receives Blue-then-Red pickup order. | schema + success witness + naive forward-pickup failure |
| 03 · `RB03_RETURN_MANIFEST` | 되돌아오는 화물 | `RB03_RETURN_MANIFEST@1` | 12×9 / 120s | Skip one cargo on first encounter, service the current TOP, then return and load the skipped cargo. | schema + successful revisit witness + load-everything-first failure |
| 04 · `RB04_LOAD_WINDOW` | 자동 적재 창 | `RB04_LOAD_WINDOW@1` | 12×9 / 120s | Use Auto for a safe same-type pair, turn it off at the ordering-sensitive cargo, then use deliberate loading. | schema + Auto on/off success witness + Auto-always-on failure + manual-only success |
| 05 · `RB05_FORK_LOCK` | 잠긴 분기 | `RB05_FORK_LOCK@1` | 13×9 / 120s | Preselect the delivery branch before occupancy and observe that the selected branch cannot change under the train. | schema + preselected-switch success + occupied-lock rejection + wrong-branch failure |
| 06 · `RB06_PORT_CIRCUIT` | 항만 순환선 | `RB06_PORT_CIRCUIT@1` | 15×11 / 165s | Combine LIFO, exact cargo/adjacent station distinction, Auto-off choice, and persistent switch selection across three cargo types. | schema + full success witness + composite wrong-order or wrong-branch failure |

## Authored map marker specifications

All marker coordinates below use `[x, y]`. Station cells are non-buildable service objects. Cargo cells remain player-track cells. The implementation must preserve the listed identifiers, dimensions, start direction, placements, and time limits exactly; only the player-built rail witness is authored by the test fixture.

### `RB01_SERVICE_SIDINGS@1`

```yaml
board_size: [9, 7]
start_cell: [1, 3]
incoming_cell: [0, 3]
time_limit_seconds: 90.0
buildable_rect: { minimum: [1, 1], maximum: [8, 5] }
blocked_cells: []
cargo:
  - { cell: [3, 3], cargo_type: BLUE_DIAMOND }
  - { cell: [4, 4], cargo_type: RED_STAR }
stations:
  - { cell: [6, 2], cargo_type: RED_STAR }
  - { cell: [7, 5], cargo_type: BLUE_DIAMOND }
```

The witness must deliver only by legal neighbouring cells. It must not add a rail to either station cell, and the stage test must prove that an attempted station-footprint or diagonal interpretation never produces unload.

### `RB02_REVERSE_ORDER@1`

```yaml
board_size: [11, 7]
start_cell: [1, 3]
incoming_cell: [0, 3]
time_limit_seconds: 105.0
buildable_rect: { minimum: [1, 1], maximum: [10, 5] }
blocked_cells: []
cargo:
  - { cell: [3, 3], cargo_type: BLUE_DIAMOND }
  - { cell: [5, 3], cargo_type: RED_STAR }
stations:
  - { cell: [7, 1], cargo_type: RED_STAR }
  - { cell: [9, 5], cargo_type: BLUE_DIAMOND }
```

The success witness must record pickup `[BLUE_DIAMOND, RED_STAR]` and unload `[RED_STAR, BLUE_DIAMOND]`. A forward order that puts Blue on TOP at the Red service point must end in a factual finite failure, not an invented explanatory result.

### `RB03_RETURN_MANIFEST@1`

```yaml
board_size: [12, 9]
start_cell: [1, 4]
incoming_cell: [0, 4]
time_limit_seconds: 120.0
buildable_rect: { minimum: [1, 1], maximum: [10, 7] }
blocked_cells: []
cargo:
  - { cell: [4, 4], cargo_type: RED_STAR }
  - { cell: [5, 4], cargo_type: BLUE_DIAMOND }
stations:
  - { cell: [8, 2], cargo_type: RED_STAR }
  - { cell: [7, 7], cargo_type: BLUE_DIAMOND }
```

The success witness must pass the Blue cargo cell twice, skip it on the first contact, load it on the second, and finish after Red unloads before Blue. Loading both cargoes on their first contacts must fail with current finite semantics.

### `RB04_LOAD_WINDOW@1`

```yaml
board_size: [12, 9]
start_cell: [1, 4]
incoming_cell: [0, 4]
time_limit_seconds: 120.0
buildable_rect: { minimum: [1, 1], maximum: [10, 7] }
blocked_cells: []
cargo:
  - { cell: [3, 4], cargo_type: RED_STAR }
  - { cell: [4, 4], cargo_type: RED_STAR }
  - { cell: [6, 4], cargo_type: BLUE_DIAMOND }
stations:
  - { cell: [9, 2], cargo_type: RED_STAR }
  - { cell: [9, 7], cargo_type: BLUE_DIAMOND }
```

The success witness must enable Auto before the two Red cargo cells, disable it before the first Blue contact, later manually load Blue, and complete. Auto left enabled for every contact must fail; a deliberate manual-only route remains a valid alternate solution.

### `RB05_FORK_LOCK@1`

```yaml
board_size: [13, 9]
start_cell: [1, 4]
incoming_cell: [0, 4]
time_limit_seconds: 120.0
buildable_rect: { minimum: [1, 1], maximum: [11, 7] }
blocked_cells: []
cargo:
  - { cell: [4, 4], cargo_type: BLUE_DIAMOND }
  - { cell: [8, 2], cargo_type: RED_STAR }
stations:
  - { cell: [11, 2], cargo_type: RED_STAR }
  - { cell: [11, 6], cargo_type: BLUE_DIAMOND }
```

The witness must create at least one direct switch, set its delivery exit before train occupancy, and assert that the same control refuses a change while occupied. The wrong initial selection must not become a hidden auto-corrected success.

### `RB06_PORT_CIRCUIT@1`

```yaml
board_size: [15, 11]
start_cell: [1, 5]
incoming_cell: [0, 5]
time_limit_seconds: 165.0
buildable_rect: { minimum: [1, 1], maximum: [13, 9] }
blocked_cells: [[6, 3], [8, 3], [6, 7], [8, 7]]
cargo:
  - { cell: [4, 5], cargo_type: BLUE_DIAMOND }
  - { cell: [7, 4], cargo_type: YELLOW_TRIANGLE }
  - { cell: [9, 7], cargo_type: RED_STAR }
stations:
  - { cell: [12, 2], cargo_type: RED_STAR }
  - { cell: [12, 5], cargo_type: YELLOW_TRIANGLE }
  - { cell: [12, 8], cargo_type: BLUE_DIAMOND }
```

The witness must use at least one switch and one Auto on/off transition, must unload all three types through cardinal service cells, and must finish before the finite time limit. A witness that preserves the wrong LIFO or branch choice must fail instead of silently finding an alternative route.

## UI / copy rules

- Route Book cards show only index, title, and objective; they do not show a score, rank, star, reward, lock, unlock, completion percentage, or solution.
- The existing neutral lesson shell art is reused. T2's protected cardinal-service illustration remains T2-only.
- Route Book uses `Stage Book 01 · N / 6` in the existing briefing progress field.
- All map instructions use color + silhouette + text terminology already consumed by the board and HUD.
- Result copy remains evidence-safe. “Next Stage” exists only after a Route Book success with a following fixed index; “Stage Book” returns to selection without recording persistent progress.

## Completion criteria

```text
six valid schema-v3 maps
→ six deterministic success witnesses
→ five required central-decision counterexamples plus composite capstone counterexample
→ direct selection and recovery flow
→ no unused Recommended Layout action
→ four-locale string completeness
→ existing first-session and VS_DEMO_01 contracts unchanged
→ full machine verification and new exact candidate
```
