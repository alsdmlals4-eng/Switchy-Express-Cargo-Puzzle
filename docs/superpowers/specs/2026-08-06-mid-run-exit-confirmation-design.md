# Mid-Run Exit Confirmation Design

- Date: `2026-08-06`
- Project: `Switchy Express: Cargo Puzzle`
- Approval: user instructed `권장안대로 진행해` and identified the missing mid-run exit button.
- Scope: PC Vertical Slice Demo shell only. Core delivery, LIFO, map, Android validation, scoring, and export identity remain unchanged.

## Problem

The current gameplay shell exposes a pause action and a `계속 운행` button, but it has no visible way to abandon the current stage before a terminal result. A player who enters BUILD or RUN must finish or force-close the application.

## Decision

Use a safe two-step exit flow:

1. A persistent `메뉴` button is visible in the product HUD during BUILD, RUNNING, UNLOADING, and PAUSED gameplay.
2. Opening the menu shows the existing shell-owned Pause overlay.
3. The Pause overlay adds `현재 플레이 종료`.
4. Pressing it opens a separate confirmation overlay.
5. `계속 플레이` returns to the Pause overlay without changing layout, cargo, time, or route state.
6. `종료하고 타이틀로` discards the gameplay instance and returns to TITLE.

This is a stage-abandon action, not an application quit action. The title screen's existing `종료` button remains the only application quit action.

## State Model

Add one shell state:

```text
GAMEPLAY → PAUSED → EXIT_CONFIRM
                 ↘ GAMEPLAY
EXIT_CONFIRM → PAUSED
EXIT_CONFIRM → TITLE
```

`PAUSED` may wrap either:

- a BUILD controller phase, where no simulation pause command is needed; or
- a RUNNING/UNLOADING controller phase, where the shell first requests the existing `PAUSE` command.

Resuming queries the underlying controller phase:

- controller `PAUSED` → request `RESUME`;
- controller `BUILD` → return shell state to `GAMEPLAY` without a domain command.

## Components

### ProductHUD

- Add `signal menu_requested()`.
- Add `TopStatus/MenuButton` with copy `메뉴`.
- The button remains visible in BUILD and RUN phases.

### ProductFiniteSlice

- Re-emit the HUD menu request as `signal menu_requested()`.
- Add `set_shell_input_locked(locked: bool) -> void`.
- The desktop adapter is enabled only when the controller is non-terminal and the shell has not locked gameplay input.

### DemoFlowController

Add:

```gdscript
const EXIT_CONFIRM: StringName = &"EXIT_CONFIRM"
func open_pause_menu() -> void
func request_exit_confirmation() -> void
func cancel_exit_confirmation() -> void
func confirm_exit_to_title() -> void
```

The controller owns visibility, gameplay input locking, confirmation focus, and gameplay disposal.

### VerticalSliceDemo Scene

- Add `PauseOverlay/.../ExitButton` with copy `현재 플레이 종료`.
- Add full-screen `ExitConfirmOverlay` with:
  - title `현재 플레이를 종료할까요?`
  - explanation `현재 노선과 진행 상황은 저장되지 않습니다.`
  - `ContinueButton`: `계속 플레이`
  - `ConfirmButton`: `종료하고 타이틀로`

The Continue button receives initial focus so keyboard users cannot confirm a destructive action with one accidental Enter press.

## Input and Safety

- While Pause or Exit Confirm overlays are open, ProductFiniteSlice desktop input is locked.
- Mouse input is intercepted by the full-screen shell overlay.
- `Esc` in EXIT_CONFIRM cancels back to PAUSED.
- `Enter` does not directly confirm stage abandonment; normal focus navigation is required.
- Confirming exit clears `_last_result`, frees the gameplay instance, stops gameplay audio/effects through the existing `_exit_tree`, and transitions to TITLE.

## Validation

Automated tests must prove:

1. `메뉴` exists and opens Pause during BUILD.
2. Opening menu during RUNNING pauses the finite controller.
3. Pause exposes `현재 플레이 종료`.
4. Exit confirmation locks product input.
5. Cancel preserves the same gameplay instance and returns to PAUSED.
6. Confirm frees the gameplay instance, clears result state, and returns to TITLE.
7. Existing Pause/Result ownership, keyboard flow, responsive layout, delivery, Android validation, and Pilot tests remain green.

## Non-Goals

- Save/resume support.
- Operating-system quit from gameplay.
- New pause rules in the finite domain.
- Changes to Android validation launcher, canonical APK, map rules, or production cutover status.
