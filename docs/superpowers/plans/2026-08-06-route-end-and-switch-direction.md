# Route End and Switch Direction Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 모든 역 색상의 한쪽 연결 판정을 대칭화하고, 노선 끝 이동 불가를 명시적 게임 오버로 처리하며, 분기의 모든 연결 방향을 직접 선택 가능한 화살표로 표시한다.

**Architecture:** 현재 finite domain 권위를 유지한다. `FiniteTrackSwitch`와 `FiniteTrackGraph`가 세 방향 선택과 U턴을 소유하고, `TrainController`는 이동 가능 여부를 제공하며, `FiniteRunController`가 배송 우선순위 뒤 `ROUTE_END` 실패를 결정한다. Product Overlay는 graph snapshot만 읽고 선택 의도를 Controller로 전달한다.

**Tech Stack:** Godot 4.7.1, typed GDScript, repository custom TestCase runner, GitHub Actions, Google Sheets decision workspace.

## Global Constraints

- Base release pin은 `v9.4.3`으로 유지한다.
- Windows와 Android는 단일 게임 규칙·데이터 코어를 공유한다.
- 마지막 필수 배송 성공이 같은 칸의 노선 끝 실패보다 우선한다.
- `CROSSING`의 기존 `STRAIGHT/RIGHT/LEFT` 계약은 변경하지 않는다.
- 새 바이너리·외부 애드온·외부 라이선스 자산을 추가하지 않는다.
- 모든 제품 코드 변경은 RED 실패를 먼저 확인한다.
- 자동 검증은 로컬 F5·Windows runtime·Android·HUMAN PASS를 대체하지 않는다.

---

### Task 1: Station color parity regression

**Files:**
- Modify: `tests/finite/integration/test_one_sided_station_terminal.gd`
- Modify: `tests/run_tests.gd` only if a new suite file is chosen

**Interfaces:**
- Consumes: `FiniteMapDefinition.create(Dictionary)`, `PreflightValidator.validate(definition, layout)`, `FiniteRunSessionFactory.create_attempt()`
- Produces: explicit RED_STAR and BLUE_DIAMOND one-sided terminal parity evidence

- [ ] **Step 1: Extract a test helper accepting `cargo_type: StringName`**

The helper builds the same 7×3 straight terminal layout for the requested type, validates exactly one reciprocal neighbor, runs auto-load, and returns the terminal phase.

- [ ] **Step 2: Assert RED_STAR and BLUE_DIAMOND both pass**

```gdscript
assert_equal(_run_one_sided_terminal(&"RED_STAR"), &"SUCCESS", "red one-sided station succeeds")
assert_equal(_run_one_sided_terminal(&"BLUE_DIAMOND"), &"SUCCESS", "blue one-sided station succeeds")
```

- [ ] **Step 3: Run exact RED check**

Run through Draft PR GitHub Actions using:

```bash
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tests/run_tests.gd
```

Expected: either BLUE fails with the user-observed defect, or the parity test passes and is recorded as `COLOR_DOMAIN_PARITY_ALREADY_GREEN`; a passing characterization test must not be represented as a reproduced bug.

- [ ] **Step 4: Commit the characterization test**

```bash
git add tests/finite/integration/test_one_sided_station_terminal.gd tests/run_tests.gd
git commit -m "test: cover one-sided station color parity"
```

### Task 2: Route-end failure domain

**Files:**
- Modify: `tests/finite/run/test_finite_run_controller.gd`
- Modify: `tests/finite/integration/test_one_sided_station_terminal.gd`
- Modify: `game/train/train_controller.gd`
- Modify: `game/finite/run/finite_run_controller.gd`
- Modify: `game/finite/run/finite_run_summary.gd`
- Modify: `game/finite/presentation/finite_slice_presenter.gd`
- Modify: `game/demo/presentation/product_hud.gd`

**Interfaces:**
- Produces: `TrainController.can_advance() -> bool`
- Produces: `FiniteRunSummary.failure_reason: StringName`
- Produces: failure reasons `TIME_EXPIRED` and `ROUTE_END`

- [ ] **Step 1: Write failing no-cargo dead-end test**

Create a configured fake or real finite route whose train target becomes the current cell while required cargo remains. Assert the run becomes `FAILURE`, summary reason is `ROUTE_END`, and no assertion/crash occurs.

- [ ] **Step 2: Write failing non-final unload-at-dead-end test**

Assert unloading completes before `ROUTE_END`, remaining cargo and stack values remain truthful, and no further movement occurs.

- [ ] **Step 3: Preserve final-delivery priority test**

Extend the one-sided terminal test to assert final unload remains `SUCCESS` and `failure_reason == &""` even though the station is the route end.

- [ ] **Step 4: Run the RED commit in GitHub Actions**

Expected: failure because `can_advance` and `failure_reason` do not exist or dead-end assertion remains.

- [ ] **Step 5: Implement `TrainController.can_advance` and safe commit guard**

```gdscript
func can_advance() -> bool:
    return _state != null and _target_cell != _state.current_cell and _graph.neighbors(_state.current_cell).has(_target_cell)
```

`_commit_next_cell` must return the current cell without emitting `cell_entered` when movement is impossible. Remove the unconditional immediate-reverse assertion so a graph-authorized switch Uturn can execute.

- [ ] **Step 6: Implement ordered route-end outcome in `FiniteRunController`**

- Check movement availability only while phase is `RUNNING`.
- After cell contact, allow `UNLOADING` and pending final `SUCCESS` to resolve first.
- After non-final unloading, fail with `ROUTE_END` if no legal next cell.
- All timer branches fail with `TIME_EXPIRED`.

- [ ] **Step 7: Add summary and player-facing reason**

`FiniteRunSummary` stores an immutable `failure_reason`. Presenter and Product HUD show distinct copy:

```text
ROUTE_END: 노선 끝 · 기차가 더 이동할 수 없습니다
TIME_EXPIRED: 제한 시간 종료
```

- [ ] **Step 8: Run focused and full GREEN**

Run Project Contract and all Godot tests. Expected: all PASS, no warnings introduced.

- [ ] **Step 9: Commit**

```bash
git add game/train game/finite/run game/finite/presentation game/demo/presentation tests/finite
git commit -m "feat: fail finite runs at route end"
```

### Task 3: Three-way switch selection and U-turn

**Files:**
- Modify: `tests/finite/rail/test_interactive_route_controls.gd`
- Modify: `game/finite/rail/finite_track_switch.gd`
- Modify: `game/finite/rail/finite_track_graph.gd`
- Modify: `game/finite/build/preflight_validator.gd`
- Modify: `game/train/train_controller.gd`

**Interfaces:**
- Produces: `FiniteTrackSwitch.connected_ports() -> Array[Vector2i]`
- Produces: `FiniteTrackSwitch.select_exit(port: Vector2i) -> bool`
- Extends: switch `route_control_states()` with `available_exits`

- [ ] **Step 1: Write failing three-direction cycle test**

Assert a switch cycles through approach plus both branch exits and returns to the initial selection.

- [ ] **Step 2: Write failing U-turn test**

Set the selected exit equal to the incoming port. Assert `graph.next_cell(switch_cell, previous_cell)` returns `previous_cell`, then `TrainController.advance_one_cell()` completes without assertion.

- [ ] **Step 3: Write failing snapshot contract test**

Assert switch route-control descriptor contains all reciprocal `available_exits` in stable cardinal order and the selected value is one of them.

- [ ] **Step 4: Verify RED in Actions**

Expected: missing `connected_ports`, missing `select_exit`, and current immediate-reverse assertion.

- [ ] **Step 5: Implement minimal switch selection**

- Store the three connected ports as selectable exits.
- `exit_for(incoming)` returns the selected connected port, including the same incoming port for U-turn.
- `cycle()` moves through the stable three-port list.
- `select_exit` rejects non-connected directions and occupied locks remain enforced by graph.

- [ ] **Step 6: Align structural search**

For the interactive product route, Preflight treats every reciprocal switch port as a possible successor, including the incoming port. Ordinary straight/curve and non-product contracts remain unchanged.

- [ ] **Step 7: Run focused and full GREEN, then commit**

```bash
git add game/finite/rail game/finite/build game/train tests/finite/rail
git commit -m "feat: allow direct three-way switch routing"
```

### Task 4: Interactive direction arrows

**Files:**
- Modify: `tests/demo/test_route_control_overlay.gd` or existing equivalent
- Modify: `tests/demo/test_product_finite_slice.gd` or existing equivalent
- Modify: `game/demo/presentation/route_control_overlay.gd`
- Modify: `game/demo/product_finite_slice.gd`

**Interfaces:**
- Produces: signal `route_cycles_requested(cell: Vector2i, cycle_count: int)`
- Consumes: `route_controls[].available_exits`, `selected_exit`, `locked`, `phase`

- [ ] **Step 1: Write failing arrow descriptor and hit-test tests**

Assert every connected switch direction has a drawn/hit-test target, selected direction has state `SELECTED`, and an incoming-direction target maps to the number of cycles required to select it.

- [ ] **Step 2: Write failing phase/lock tests**

Assert BUILD/PAUSED/result ignore arrow input and an occupied switch emits no selection request.

- [ ] **Step 3: Verify RED in Actions**

Expected: overlay has no interaction signal and only renders the selected arrow.

- [ ] **Step 4: Implement procedural arrows**

- Draw all available directions.
- Use fill plus stroke/weight to distinguish selected state.
- Use direction-end hit rectangles with a 44 px target goal.
- Keep `mouse_filter=IGNORE` outside RUNNING/UNLOADING so BUILD board editing remains intact.

- [ ] **Step 5: Connect wrapper dispatch**

`ProductFiniteSlice` handles `route_cycles_requested` by dispatching `BOARD_CELL` exactly `cycle_count` times through the existing Controller boundary. Overlay never mutates graph state directly.

- [ ] **Step 6: Run GREEN and commit**

```bash
git add game/demo tests/demo
git commit -m "feat: select switch routes with direction arrows"
```

### Task 5: Canon, Sheet, and exact-head delivery

**Files:**
- Modify: `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
- Modify: `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
- Modify: `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md`
- Create/Modify: `기획서/50_제작_검증/SX_AUD_026_ROUTE_END_AND_SWITCH_DIRECTION.md`
- Update Google Sheet tabs: `02_현재_확정결정`, `04_누락_충돌_감사`, `20_시스템_콘텐츠`, `50_제작_검증`

**Interfaces:**
- Produces: same Decision IDs `SX-DEC-040~042` in GitHub canon and Sheet
- Produces: exact-head evidence and merged-main readback

- [ ] **Step 1: Record RED/GREEN evidence by exact commit**

Include whether BLUE parity reproduced or was already green, exact failing checks, exact GREEN checks, assertion counts, and limitations.

- [ ] **Step 2: Update canonical status without expanding manual evidence**

Automated status may become PASS. Local F5 blue terminal, visual arrow readability, Windows runtime, Android, HUMAN, and production remain `RETEST_REQUIRED/NOT_RUN/BLOCKED` until physical evidence exists.

- [ ] **Step 3: Update the correct Sheet with the same IDs**

Pre-merge: `APPROVED_PENDING_MERGE`. Post-merge: `SYNCED_TO_MAIN`. Re-read every written range.

- [ ] **Step 4: Run all required checks on exact HEAD**

```text
Project Contract
Godot Tests
Validate Project Base Adapter when triggered
Validate Thin Adapter Migration
Base adoption contracts
JSON/whitespace checks
```

- [ ] **Step 5: Adversarial review**

Confirm changed-file inventory, product scope, no Android validation identity change, no untracked generated/cache/secret asset, review threads 0, comments 0, P0/P1 0.

- [ ] **Step 6: Merge only the reviewed exact HEAD**

Apply current-conversation recommended merge authority, merge, re-read `main`, then close Sheet state to the merged SHA.

- [ ] **Step 7: Issue local validation route**

```text
main Fetch/Pull → Godot reopen → F5 → blue one-sided station → route-end failure copy → switch three arrows → incoming arrow U-turn → final delivery SUCCESS priority
```
