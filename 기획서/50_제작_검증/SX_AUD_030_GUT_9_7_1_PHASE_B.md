# SX-AUD-030 — GUT 9.7.1 Phase B Formal Authority Audit

```yaml
audit_id: SX-AUD-030
date: 2026-08-07 KST
decision_id: SX-DEC-044
approval_source: GMB-004
baseline_main: 281bc7b3aa8d66b8f39547475540ab8fcd88b4c5
branch: test/gut-9-7-1-phase-b
validated_head: a556d58abc68aa1b4885a34e806443301bafd7a0
state: EXACT_HEAD_GREEN_ATTACK_REVIEW_PENDING
```

## Objective

Add GUT 9.7.1 as a formal exact-head test authority in parallel with the existing custom runner. Phase B covers framework configuration, real consumers, JUnit, pinned-vendor reconciliation, and a production mutation guard. It does not implement new gameplay behavior.

## Scope readback

### Added

- `.gutconfig.json`;
- four GUT consumer scripts with eight tests;
- tracked `tests/gut/regression/` discovery directory;
- `tools/gut_phase_b_guard.py`;
- 19 Python guard/suite/workflow contract tests;
- `.github/workflows/gut-9-7-1-tests.yml`;
- vendor reconciliation manifest and implementation plan;
- `test-results/` ignore rule.

### Retained

- `res://tests/run_tests.gd`;
- `.github/workflows/godot-tests.yml`;
- existing production behavior and live-editor Pilot.

### Explicitly unchanged

- production gameplay `.gd`;
- `project.godot`;
- product and vendor `.tscn`, `.tres`, `.res` files;
- signals, InputMap, autoload, Node ownership;
- binary assets.

## Formal consumers

1. RED_STAR one-sided station final success.
2. BLUE_DIAMOND one-sided station final success.
3. exact-limit final delivery SUCCESS priority after unloading.
4. post-limit final delivery FAILURE.
5. switch approach traffic follows selected exit.
6. both branch directions are reciprocal to the approach.
7. occupied route control rejects input and reports lock state.
8. route-control state round-trips through the overlay snapshot contract.

Route-end gameplay and direct three-direction selection remain later production TDD under `SX-DEC-041` and `SX-DEC-042`.

## Vendor reconciliation result

```yaml
run: 31134358839
local_file_count: 259
official_file_count: 259
exact_byte_match_count: 241
normalized_first_line_load_steps_paths: 17
pinned_binary_divergence:
  path: source_code_pro.fnt
  local_sha256: e1149f403f4aba18913fb500e4b34aa45f44afe9e36a3e7aed923c11aacf4686
  official_sha256: 404094d0aae3de496a64fca1795bed8bd60c2411a3d992551f9e8f00789b71fe
  local_size: 42799
  official_size: 42799
missing_local: []
extra_local: []
source_divergence: []
vendor_scene_resource_overwrite: NOT_PERFORMED
```

The font divergence is frozen evidence, not a byte-identical or semantic-equivalence claim. Every other unlisted difference remains a failure.

## TDD evidence

```yaml
static_contract_tests:
  total: 19
  result: PASS
compileall:
  paths: [tools, tests/python]
  result: PASS
red_green_cycles:
  - missing guard module → guard implementation
  - missing GUT config/consumers → four scripts and eight tests
  - missing workflow → dedicated exact-head check
  - vendor divergence without evidence → per-path hash/size evidence
  - overly narrow vendor policy → explicit 17-path and frozen-font policy
  - missing class-name import → import-before-GUT contract
  - GUT framework false positive → directory/error-summary rejection
```

## Exact-head hosted evidence

```yaml
head: a556d58abc68aa1b4885a34e806443301bafd7a0
GUT_9_7_1_Tests:
  run: 31134358839
  result: PASS
  scripts: 4
  tests: 8
  passing_tests: 8
  asserts: 60
  junit_tests: 8
  junit_failures: 0
  junit_errors: 0
  junit_skipped: 0
  junit_artifact: 8977314352
  evidence_artifact: 8977314810
Godot_Tests:
  run: 31134358827
  result: PASS
Project_Contract:
  run: 31134358833
  result: PASS
Validate_Thin_Adapter_Migration:
  run: 31134358837
  result: PASS
```

## Mutation guard result

```yaml
protected_before_count: 173
protected_after_count: 173
changed: []
added: []
removed: []
result: PASS
```

The protected set covers `project.godot`, `game/`, `scenes/`, `data/`, and `assets/` when present. Verification runs with `if: always()` so a failed GUT run cannot skip mutation evidence.

## Independent attack finding and correction

The first runtime-green diagnostic HEAD was not accepted. Its log contained:

```text
[GUT ERROR]: The path [res://tests/gut/regression] does not exist.
Errors 1
```

All eight tests passed and JUnit reported zero errors, exposing a false-positive gap. The final head:

- tracks the regression discovery directory;
- statically validates every configured directory;
- rejects `GUT ERROR` output;
- rejects non-zero framework `Errors` summaries;
- reruns JUnit and mutation gates.

The final exact-head artifact contains no GUT framework error and all GUT steps succeed.

## Merge gates remaining

- final changed-file and diff review;
- review submissions and unresolved inline-thread readback;
- PR mergeability readback;
- exact-head identity recheck after this evidence-document commit;
- same-ID Sheet update;
- expected-head merge and merged-main readback.

## Evidence ceiling

This audit does not claim:

- physical Windows runtime PASS;
- Android device PASS;
- human comprehension PASS;
- connected HiGodot authoring PASS;
- route-end or direct-selection gameplay completion;
- merged-main Phase B authority before PR #105 is merged.
