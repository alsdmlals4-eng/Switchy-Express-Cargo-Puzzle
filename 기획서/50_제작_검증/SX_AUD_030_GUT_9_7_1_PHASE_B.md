# SX-AUD-030 — GUT 9.7.1 Phase B Formal Authority Audit

```yaml
audit_id: SX-AUD-030
date: 2026-08-07 KST
decision_id: SX-DEC-044
approval_source: GMB-004
baseline_main: 281bc7b3aa8d66b8f39547475540ab8fcd88b4c5
branch: test/gut-9-7-1-phase-b
state: PR_PREPARATION_STATIC_GREEN_RUNTIME_PENDING
```

## Objective

GUT 9.7.1을 기존 custom runner와 병행하는 formal exact-head test authority로 추가한다. Phase B는 테스트 프레임워크·consumer·JUnit·vendor reconciliation·production mutation guard만 다루며 gameplay 신규 동작은 구현하지 않는다.

## Scope

### Added

- `.gutconfig.json`
- focused GUT consumers under `tests/gut/`
- `tools/gut_phase_b_guard.py`
- Python guard/suite/workflow contract tests
- dedicated `.github/workflows/gut-9-7-1-tests.yml`
- vendor reconciliation manifest and implementation plan
- generated `test-results/` ignore rule

### Retained

- `res://tests/run_tests.gd`
- `.github/workflows/godot-tests.yml`
- existing production behavior and existing live-editor Pilot

### Explicitly unchanged

- `project.godot`
- product `.tscn`, `.tres`, `.res` files
- GUT vendor Scene files
- signals, InputMap, autoload, Node ownership
- production gameplay `.gd`
- binary assets

## Formal consumers

The initial GUT suite contains eight `test_` functions across four scripts:

1. RED_STAR one-sided station final success.
2. BLUE_DIAMOND one-sided station final success.
3. exact-limit final delivery SUCCESS priority after unloading.
4. post-limit final delivery FAILURE.
5. switch approach traffic follows selected exit.
6. both branch directions are reciprocal to the approach.
7. occupied route control rejects input and reports lock state.
8. route-control state round-trips through the overlay snapshot contract.

Direct three-direction selection UI and route-end gameplay behavior remain later gameplay TDD work under `SX-DEC-041` and `SX-DEC-042`; Phase B does not silently implement them.

## Vendor reconciliation

```yaml
official_repository: bitwes/Gut
official_branch: godot_4_7
official_commit: aeb5d4f3f7f0a6c9b5e178876d6c99b791fda605
official_addon_tree: 5d6893836af4917ee62b1a395125a7530b1f239d
project_addon_tree: 09d040309bbed0e07420ad72c4aa69cbd0e58190
allowed_normalized_metadata:
  - GutScene.tscn first-line load_steps token
  - UserFileViewer.tscn first-line load_steps token
other_divergence: FORBIDDEN
vendor_scene_replacement: NOT_PERFORMED
```

The exact-head workflow downloads the pinned official archive and compares every path. The full-tree result remains pending until the workflow artifact is produced.

## Mutation guard

Before GUT runs, SHA-256 hashes are captured for existing paths:

- `project.godot`
- `game/`
- `scenes/`
- `data/`
- `assets/` when present

After GUT completes, any changed, added, or removed protected file fails the check.

## Static TDD evidence

A temporary isolated development workspace was used for RED→GREEN cycles.

```yaml
python_contract_tests:
  total: 16
  result: PASS
compileall:
  paths:
    - tools
    - tests/python
  result: PASS
limitations:
  - no local Godot binary was available
  - no GUT runtime result is claimed
  - no JUnit result is claimed
  - no hosted exact-head result is claimed yet
```

## Required hosted gates

The PR may merge only when its exact HEAD succeeds in:

- GUT 9.7.1 Tests
- Godot Tests
- Project Contract
- Validate Thin Adapter Migration

The GUT check must additionally prove:

- complete pinned-vendor comparison PASS;
- at least six JUnit tests discovered;
- zero JUnit failures and errors;
- protected production tree unchanged;
- evidence artifacts uploaded.

## Evidence ceiling

This audit does not claim:

- GUT hosted runtime PASS before the exact-head workflow completes;
- Windows runtime PASS;
- Android device PASS;
- human comprehension PASS;
- connected HiGodot authoring PASS;
- route-end or direct-selection gameplay completion.
