# Codex Goal — VS-03 Local Survival Vertical Slice

```yaml
status: READY_FOR_BUILD_PENDING_CANONICAL_SYNC
issue: 6
parent_epic: 3
product_baseline: 4e435a1a6d10ab146197671049da80709fd18c1f
gmb001: CLOSED · SX-DEC-017~026 · DECISION_MERGE_9b63421a
dor_audit: SX-AUD-005
dor_evidence: EV-USER-016
execution_authority: VS03-01_ONLY_AFTER_CANONICAL_SYNC
online_ugc: OUT_OF_SCOPE_FOR_VS03
product_implementation: NOT_STARTED
```

> 이 문서는 DoR planning PR과 올바른 Sheet readback이 완료된 뒤 `VS03-01`에 한해 실행 권위를 갖는다. VS03-02~07을 병렬로 시작하지 않는다.

## 반드시 먼저 읽기

```text
기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md
기획서/00_프로젝트_허브/GMB-001_CANONICAL_DECISIONS.md
기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md
기획서/50_제작_검증/VS03_DEFINITION_OF_READY_AUDIT.md
docs/superpowers/specs/2026-08-02-vs03-execution-architecture-design.md
docs/superpowers/plans/2026-08-02-vs03-build-segmentation.md
docs/superpowers/plans/2026-08-02-switchy-express-current-vertical-slice.md
```

Decision별 spec/plan은 승인 의미와 세부 테스트 후보를 제공한다. 파일 경로, runner API, package ordering, 공통 hotspot 책임이 위 DoR 정본과 충돌하면 DoR 정본을 따른다.

## 최종 목표 결과

```text
actual first endless run
→ LOAD·compact token·switch·mixed-stack LIFO·Combo onboarding
→ normal survival economy and difficulty communication
→ fixed full-map active play
→ fuel-zero result with evidence-based advice
→ official global/current-map records and bounded cosmetic progress
→ exact same-map restart or another discovered official map
```

## 전체 Package Sequence

```text
VS03-01 run lifecycle/economy/difficulty
→ VS03-02 compact footprint/DeliveryLoop seam
→ VS03-03 target3 maps/session/restart/selection
→ VS03-04 Profile transaction/records/cosmetics/unlocks/rewards
→ VS03-05 product scene/camera/HUD/result/browsers
→ VS03-06 contextual onboarding
→ VS03-07 integration/evidence handoff
```

각 package는 이전 package merge 뒤에만 시작한다.

# 현재 실행 권위 — VS03-01 ONLY

## 목표

기존 RailGraph·TrainController·CargoStack·CargoSpawner·Station·DeliveryLoop 위에 UI/Profile/map catalog와 분리된 authoritative run lifecycle과 difficulty core를 구현한다.

## 생성 파일

```text
game/run/run_balance.gd
game/run/run_state.gd
game/run/run_summary.gd
game/run/run_controller.gd
game/run/run_metrics_accumulator.gd
game/difficulty/difficulty_forecast.gd
game/difficulty/difficulty_event.gd
game/difficulty/difficulty_director.gd

tests/run/test_run_balance.gd
tests/run/test_run_state.gd
tests/run/test_run_controller.gd
tests/run/test_no_input_survival.gd
tests/difficulty/test_difficulty_forecast.gd
tests/difficulty/test_difficulty_director.gd
tests/integration/test_run_delivery_economy.gd
```

## 제한적 수정 파일

```text
game/train/train_controller.gd
tests/test_case.gd
tests/run_tests.gd
```

`TrainController` 수정은 다음 read-only seam으로 제한한다.

- `seconds_to_next_cell()`
- compact path/route-history가 후속 package에서 읽을 수 있는 bounded read API

기존 movement·target lock·preview parity 의미를 변경하지 않는다.

## 실제 Test Runner 계약

모든 suite:

```gdscript
extends "res://tests/test_case.gd"

func run() -> void:
    assert_true(...)
```

명령:

```bash
./Godot_v4.7.1-stable_linux.x86_64 \
  --headless --path . --script res://tests/run_tests.gd
```

금지:

- `tests/run_single.gd`
- `--suite`
- `func run(test)`
- `test.case()`
- 생성되지 않은 test file preload

`tests/test_case.gd`에는 실제 필요가 검증된 최소 helper만 test-first로 추가한다.

## Authoritative Segment Order

`RunController.advance_time(delta)`는 boundary-sliced loop를 사용한다.

1. phase/pause/end guard
2. semantic input snapshot
3. speed·fuel drain rate 계산
4. train speed 설정
5. remaining/max-step/next-cell/fuel-zero boundary 중 최소 segment 선택
6. DeliveryLoop segment advance — 최대 cell event 1개
7. pickup/unload event 적용
8. unload group으로 Combo·score·fuel reward 적용
9. DifficultyDirector advance/commit
10. time fuel drain 적용
11. exact tie에서는 cell event 처리 후 fuel-zero 평가
12. end/summary one-shot 또는 다음 segment

## Required Behavior

- time-based speed/fuel pressure
- cargo slowdown
- BOOST speed increase + extra fuel drain
- LOAD blocked by BOOST priority
- `combo_count == unload_result.count`
- `max_combo` independent update
- speed bonus separate from Combo
- empty/mismatch station reward 0
- no-input finite survival
- fuel-zero run end exactly once
- no movement/pickup/unload after end
- difficulty schedule authority separated from presentation
- pause/assist-ready state stops authoritative clocks without wall-clock catch-up
- restart reset contract anticipated through run generation, but map/session implementation is VS03-03

## Do Not Implement in VS03-01

- compact token View/TrainFootprint/DeliveryLoop provider
- map definition/catalog/session/restart/selection
- Profile/save/records/currency/unlocks
- Scene/HUD/result/camera/browser
- onboarding
- target100 generator work
- UGC/online work

Interfaces may be small and forward-compatible, but placeholder implementations for later packages are forbidden.

## Acceptance Tests

- current 9 suites remain green
- no-input reaches fuel 0 in configured bound and score remains 0
- fuel-zero event and immutable summary occur once
- exact cell/fuel-zero tie follows documented order
- multi-cell frame delta is sliced; no event occurs after death
- cargo slowdown never lowers fuel drain
- BOOST costs extra fuel at every active segment
- one unload event produces one Combo/reward application
- difficulty commit sequence is deterministic with presentation absent
- pause/resume/restart-generation lifecycle has no catch-up or stale event mutation

## PR Gate

```text
branch from latest main
TDD red→green evidence
full custom runner PASS
Project Contract PASS
Godot Tests PASS
behind 0
review threads 0
REQUEST_CHANGES 0
only VS03-01 owned files
```

PR body must record public API changes, tests, rollback, and explicit NOT_RUN items.

## Rollback

VS03-01 writes no Profile, Scene, Resource, asset, catalog, or runtime data. The package must be revertible as one unit while restoring the previous VS-02 product baseline.

## Evidence Boundary

This package cannot claim:

- compact token product completion
- target3/target100 map completion
- Profile/record/reward completion
- Android/localization/accessibility/human PASS
- online/UGC readiness

## Start Condition

```text
DoR PR merged
+ correct Sheet SX-AUD-005 / EV-USER-016 canonical sync
+ exact final readback PASS
= Codex READY_FOR_BUILD · VS03-01
```
