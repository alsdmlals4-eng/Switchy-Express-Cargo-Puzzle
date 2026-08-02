# Preparation Zoom + Full-Map Camera Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 최초 준비 화면에서는 기관차 주변을 약간 확대해 보여주고, START 뒤 실제 run이 시작되기 전에 전체 15×10 맵으로 복귀한 다음 운행 중에는 고정 전체 맵을 유지한다.

**Architecture:** `CameraPresentationState`가 PREP_ZOOM→FULL_MAP_READY 표현 상태를 관리하고, `RunController`는 FULL_MAP_READY 전에는 fuel·timer·difficulty·spawn progression을 시작하지 않는다. Camera2D와 Tween은 표현 계층이며 도메인 권위를 갖지 않고, 중단·Reduced Motion·오류에서는 전체 맵 즉시 전환으로 수렴한다.

**Tech Stack:** Godot 4.7.1, GDScript, Camera2D, existing RunController/first-session onboarding contracts, Android landscape.

## Global Constraints

- Decision: `SX-DEC-018`; Evidence: `EV-USER-007`; GMB-001 slot `2/10`.
- Active run camera is fixed full-map; no train tracking, free pan, pinch zoom, rotation, or contextual inset.
- PREP magnification `1.15×~1.25×`, baseline `1.20×`; transition `0.60~0.90s`, baseline `0.75s`; all `TEST_VALUE`.
- FULL_MAP_READY before fuel drain, run timer, difficulty timer, spawn progression, board input, and first-session assist timer.
- Reduced Motion uses an immediate full-map cut.
- UI/Tween/animation completion is non-authoritative and cannot permanently block run start.
- Immediate result-screen RESTART defaults to full-map framing without replaying the preparation zoom; this remains testable configuration.
- Product implementation stays blocked until GMB-001 reaches 10/10 and total-planning Gate changes `CODEX_NOT_READY` to `READY_FOR_BUILD`.

---

## Planned File Map

Actual paths must be confirmed against repository structure before implementation; retain these responsibilities even if names move.

```text
game/camera/camera_presentation_state.gd
  - deterministic camera presentation state and idempotent transition completion

game/camera/camera_profile.gd or .tres
  - TEST_VALUE magnification, duration, easing, restart policy

game/camera/game_camera_controller.gd
  - Camera2D framing, skip, recovery, viewport resize handling

game/run/run_controller.gd
  - gates domain start on FULL_MAP_READY; owns run start authority

game/ui/preparation_panel.gd / .tscn
  - START and Help only; board input disabled in PREP

game/settings/accessibility_settings.gd
  - Reduced Motion read-only input to camera presentation

tests/camera/test_camera_presentation_state.gd
  - pure state and idempotency tests

tests/camera/test_game_camera_controller.gd
  - framing, resize, skip, recovery tests

tests/run/test_run_start_camera_gate.gd
  - fuel/timer/difficulty/spawn authority boundary

tests/integration/test_first_session_camera_onboarding_order.gd
  - camera transition cannot overlap first LOAD/switch safe pause

tests/ui/test_preparation_panel_camera_flow.gd
  - START repeat, touch lock, restart behavior
```

---

### Task 1: Lock the camera presentation state contract

**Files:**
- Create: `game/camera/camera_presentation_state.gd`
- Test: `tests/camera/test_camera_presentation_state.gd`

**Interfaces:**
- Consumes: `start_request`, `transition_completed`, `transition_skipped`, `transition_failed`, `restart_requested` events.
- Produces: `request_prep_framing()`, `request_full_map()`, `mark_full_map_ready(reason: StringName)`, `is_full_map_ready() -> bool`, `full_map_ready` signal exactly once per run preparation.

- [ ] **Step 1: Write failing state tests**

Test the exact transitions:

```gdscript
PREP_ZOOM + start_request -> FULL_MAP_TRANSITION
FULL_MAP_TRANSITION + completed -> FULL_MAP_READY
FULL_MAP_TRANSITION + skipped -> FULL_MAP_READY
FULL_MAP_TRANSITION + failed -> FULL_MAP_READY with fallback reason
FULL_MAP_READY + duplicate completion -> no second signal
RESULT + restart_requested -> FULL_MAP_READY
```

- [ ] **Step 2: Run the focused test and confirm failure**

Run the repository's existing Godot test command targeting `test_camera_presentation_state.gd`.
Expected: FAIL because the state object does not exist.

- [ ] **Step 3: Implement the minimal deterministic state object**

Use an enum with no direct Camera2D dependency:

```gdscript
enum Phase {
    SESSION_ENTRY,
    PREP_ZOOM,
    FULL_MAP_TRANSITION,
    FULL_MAP_READY,
    ACTIVE_RUN,
    RESULT,
}
```

Track a per-preparation generation ID and ignore duplicate completion events from older generations.

- [ ] **Step 4: Run the focused test and confirm pass**

Expected: all transition, duplicate, skip, and failure fallback cases PASS.

- [ ] **Step 5: Commit**

```bash
git add game/camera/camera_presentation_state.gd tests/camera/test_camera_presentation_state.gd
git commit -m "feat: add deterministic camera presentation state"
```

---

### Task 2: Add a centralized TEST_VALUE camera profile

**Files:**
- Create: `game/camera/camera_profile.gd`
- Create or modify: matching `.tres` configuration resource
- Test: `tests/camera/test_camera_profile.gd`

**Interfaces:**
- Produces:

```gdscript
prep_magnification: float = 1.20
transition_duration_seconds: float = 0.75
restart_replays_prep: bool = false
reduced_motion_immediate: bool = true
```

- [ ] **Step 1: Write failing validation tests**

Require magnification in `[1.15, 1.25]`, duration in `[0.60, 0.90]`, no overshoot easing, and restart replay OFF by default.

- [ ] **Step 2: Run and confirm failure**

Expected: missing profile/resource failure.

- [ ] **Step 3: Implement profile validation and defaults**

Invalid values must normalize to `1.20`, `0.75`, `false`, and an ease-out curve without overshoot.

- [ ] **Step 4: Run and confirm pass**

Expected: valid, low, high, NaN, and missing-resource cases PASS.

- [ ] **Step 5: Commit**

```bash
git add game/camera/camera_profile.gd game/camera/*.tres tests/camera/test_camera_profile.gd
git commit -m "feat: configure preparation camera test values"
```

---

### Task 3: Implement Camera2D framing without domain authority

**Files:**
- Create: `game/camera/game_camera_controller.gd`
- Modify: the main gameplay scene only to attach the controller and Camera2D references
- Test: `tests/camera/test_game_camera_controller.gd`

**Interfaces:**
- Consumes: `CameraPresentationState`, `CameraProfile`, board bounds, locomotive start transform, viewport safe rect, Reduced Motion.
- Produces: `prep_framing_applied`, `full_map_visual_applied`, and a request to `mark_full_map_ready`; it does not call run-start domain methods.

- [ ] **Step 1: Write failing framing tests**

Cover:

```text
PREP contains locomotive + departure direction + first reachable pickup
FULL_MAP contains complete 15×10 board bounds and HUD safe rect
Reduced Motion applies FULL_MAP immediately
viewport resize recalculates framing without changing domain state
Tween interruption applies FULL_MAP fallback
no camera rotation or overshoot
```

- [ ] **Step 2: Run and confirm failure**

Expected: controller and framing helper absent.

- [ ] **Step 3: Implement pure framing calculation first**

Calculate target center and magnification from bounds. Keep the calculation callable without rendering so it can be tested deterministically.

- [ ] **Step 4: Implement Camera2D application and interrupt path**

On skip, error, suspend recovery, scene teardown, or invalid Tween, apply full-map transform synchronously and report `FULL_MAP_READY` once.

- [ ] **Step 5: Run focused and full camera tests**

Expected: all aspect ratio, resize, Reduced Motion, and interruption cases PASS.

- [ ] **Step 6: Commit**

```bash
git add game/camera/game_camera_controller.gd game/**/*.tscn tests/camera/test_game_camera_controller.gd
git commit -m "feat: add preparation and full-map camera framing"
```

---

### Task 4: Gate run authority behind FULL_MAP_READY

**Files:**
- Modify: actual `RunController` and run-state files discovered in repository
- Test: `tests/run/test_run_start_camera_gate.gd`

**Interfaces:**
- Consumes: one `full_map_ready(generation_id, reason)` event.
- Produces: one authoritative `run_started` transition that enables board input, fuel drain, run timer, difficulty progression, spawn progression, and first-session assist timer.

- [ ] **Step 1: Write failing authority tests**

Before FULL_MAP_READY assert all remain unchanged:

```text
fuel
survival_seconds
run_timer
challenge/difficulty timer
spawn progression
board gameplay input
onboarding assist_elapsed_seconds
```

After the first valid FULL_MAP_READY assert all start together. Duplicate or stale generation signals must not start a second run.

- [ ] **Step 2: Run and confirm failure**

Expected: current run starts independently from camera readiness.

- [ ] **Step 3: Implement the minimal gate in RunController**

RunController owns the state change. Camera code can only emit readiness; it cannot directly alter fuel, timer, spawn, score, or onboarding.

- [ ] **Step 4: Add fallback timeout recovery**

Use a bounded watchdog only to request synchronous full-map fallback; the watchdog itself must not bypass the state object's idempotency.

- [ ] **Step 5: Run focused and full run regression tests**

Expected: no pre-start progression, one run start, and existing run behavior after start remains unchanged.

- [ ] **Step 6: Commit**

```bash
git add game/run tests/run/test_run_start_camera_gate.gd
git commit -m "feat: gate run start on full-map readiness"
```

---

### Task 5: Connect PREP UI and protect touch input

**Files:**
- Modify: actual preparation/start panel scene and script
- Test: `tests/ui/test_preparation_panel_camera_flow.gd`

**Interfaces:**
- START calls the presentation state's `request_full_map()` exactly once.
- Board taps remain disabled until authoritative `run_started`.
- Help and accessibility controls remain usable in PREP.

- [ ] **Step 1: Write failing UI tests**

Cover START double tap, multi-touch, Help open/close, back action, transition skip, Reduced Motion, and board tap during transition.

- [ ] **Step 2: Run and confirm failure**

Expected: PREP-specific input lock not implemented.

- [ ] **Step 3: Implement the minimal UI flow**

Disable START after first accepted request. Do not use button animation completion as acceptance or readiness.

- [ ] **Step 4: Verify touch coordinate mapping after FULL_MAP_READY**

A known switch screen coordinate must resolve to the same world target as the existing full-map input contract.

- [ ] **Step 5: Run UI and input regression tests**

Expected: no accidental switch/load input during transition; normal input after start PASS.

- [ ] **Step 6: Commit**

```bash
git add game/ui tests/ui/test_preparation_panel_camera_flow.gd
git commit -m "feat: connect preparation start camera flow"
```

---

### Task 6: Integrate first-session onboarding order

**Files:**
- Modify: actual onboarding coordinator/state only where needed for run-start event timing
- Test: `tests/integration/test_first_session_camera_onboarding_order.gd`

**Interfaces:**
- Onboarding starts after authoritative `run_started`.
- FIRST_LOAD and FIRST_SWITCH safe pauses never overlap FULL_MAP_TRANSITION.
- Camera remains FULL_MAP throughout onboarding.

- [ ] **Step 1: Write failing sequence tests**

Expected order:

```text
PREP_ZOOM
START_REQUESTED
FULL_MAP_READY
RUN_STARTED
onboarding_started
FIRST_LOAD safe pause
FIRST_SWITCH safe pause
```

Assert no camera zoom request is issued by onboarding events.

- [ ] **Step 2: Run and confirm failure**

Expected: explicit ordering contract absent.

- [ ] **Step 3: Wire onboarding to run_started instead of visual completion**

First-run assist elapsed time begins at RUN_STARTED, not at PREP or START input.

- [ ] **Step 4: Run sequence and existing onboarding regressions**

Expected: no overlap, no duplicate rewards, no safe-pause deadlock.

- [ ] **Step 5: Commit**

```bash
git add game/onboarding tests/integration/test_first_session_camera_onboarding_order.gd
git commit -m "feat: order onboarding after camera-ready run start"
```

---

### Task 7: Implement fast restart and lifecycle recovery

**Files:**
- Modify: result/restart coordinator and camera controller
- Test: `tests/integration/test_restart_camera_lifecycle.gd`

**Interfaces:**
- Result RESTART defaults to `RESTART_FULL_MAP` and does not replay PREP zoom.
- App suspend/resume and scene recreation restore either stable PREP or stable FULL_MAP; never an orphan transition.

- [ ] **Step 1: Write failing lifecycle tests**

Cover restart spam, suspend in PREP, suspend during transition, resume after readiness, viewport resize during transition, scene teardown, and feature flag enabling restart prep replay.

- [ ] **Step 2: Run and confirm failure**

Expected: lifecycle recovery absent.

- [ ] **Step 3: Implement generation-safe restart and recovery**

Clear old Tween callbacks and camera requests. A stale callback must not start or alter the next run.

- [ ] **Step 4: Run lifecycle and 10-minute soak automation**

Expected: no duplicate start, retained Tween, camera drift, or growing callback/event history.

- [ ] **Step 5: Commit**

```bash
git add game/camera game/result tests/integration/test_restart_camera_lifecycle.gd
git commit -m "feat: recover camera state across restart and suspend"
```

---

### Task 8: Android, accessibility, and human validation evidence

**Files:**
- Modify: `기획서/50_제작_검증/PLAYTEST_PLAN.md`
- Add evidence only after actual execution under the repository's evidence directories

**Interfaces:**
- Consumes: representative Android screenshots and telemetry.
- Produces: evidence status without promoting TEST_VALUE to permanent rule.

- [ ] **Step 1: Capture required states**

```text
PREP at 1.15×, 1.20×, 1.25×
FULL_MAP after START
Reduced Motion immediate cut
long/narrow Android aspect ratios
first-session FIRST_LOAD after FULL_MAP_READY
result RESTART direct full map
```

- [ ] **Step 2: Run device checks**

Verify HUD safe area, first pickup/start route visibility, compact token/shape readability, touch parity, and no fuel/timer progression before readiness.

- [ ] **Step 3: Run minimum 5-person validation**

Record whether players identify locomotive/departure direction in PREP, understand the full map before the first decision, notice unfair movement during transition, and prefer or reject prep replay on restart.

- [ ] **Step 4: Compare TEST_VALUE variants**

Select a baseline only from evidence. If 1.20× or 0.75s fails, update config/tests without changing the Decision's preparation-zoom/full-map meaning.

- [ ] **Step 5: Run final automated regression**

Run Project Contract, complete Godot tests, camera/run/onboarding focused suites, and exact changed-file inventory.

- [ ] **Step 6: Commit evidence separately**

```bash
git add 기획서/50_제작_검증 evidence
 git commit -m "test: record preparation camera validation evidence"
```

## Acceptance Criteria

- PREP shows locomotive, departure direction, and first reachable objective without losing orientation.
- ACTIVE_RUN always shows the fixed whole map and never tracks the train.
- No domain progression occurs before FULL_MAP_READY.
- FULL_MAP_READY and run_started occur exactly once per preparation generation.
- transition skip, failure, Reduced Motion, suspend/resume, and restart cannot deadlock.
- first-session onboarding starts only after the full-map run boundary.
- immediate RESTART remains fast and does not replay preparation zoom by default.
- Android and 5-person evidence remain `NOT_RUN` until actually collected.

## Rollback

- If preparation zoom harms orientation or motion comfort, set prep magnification to full-map parity (`1.00×`) while preserving the run-start gate.
- If Tween reliability is poor, use an immediate PREP→FULL_MAP cut for all users.
- If restart policy is disliked, enable `restart_replays_prep` as a config experiment without changing domain rules.
- Camera feature rollback must not remove FULL_MAP_READY idempotency or pre-start progression protection.

현재 계획은 구현 명령이 아니다. `GMB-001` 10/10과 총기획 Gate가 닫혀 `READY_FOR_BUILD`가 되기 전에는 제품 코드를 변경하지 않는다.
