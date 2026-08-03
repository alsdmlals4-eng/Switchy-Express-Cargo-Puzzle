# SX-AUD-011 · VS03-R1 Difficulty Authority Alignment Audit

```yaml
audit_id: SX-AUD-011
status: PREMERGE_REVIEW
package: VS03-R1
baseline_main: 1e306ea74f856c654b1b77b56ee2ba72e4ed5440
implementation_pr: 49
working_branch: agent/vs03-r1-difficulty-authority
exact_head_before_docs: 201dff55fe3b36b80ee88492ec9cabccbc6906e0
evidence_id: EV-VS03-R1-001
source_finding: SX-AUD-007-F87
sequencing_evidence: EV-USER-018
planning_conflict: NONE
user_decision_required: NO
balance_constant_change: NONE
product_scene_runtime: NOT_RUN
android_human_evidence: NOT_RUN
next_authority_after_merge_sync: VS03-05A_ONLY
```

## 목적

기존 수치 의미를 바꾸지 않고 `DifficultyDirector`를 시간 압력의 단일 권위로 만든다.

```text
speed pressure · every 30 seconds
+ fuel pressure · every 45 seconds
→ ordered union boundary commits
→ immutable pressure snapshot
→ RunController consumes committed snapshot
```

UI·Scene·Profile·map·asset·online과 `VS03-05A` 제품 화면은 범위 밖이다.

## 보존한 수치

```yaml
SPEED_STEP_SECONDS: 30.0
SPEED_STEP_AMOUNT: 0.08
SPEED_START: 1.8
SPEED_MAX: 3.4
FUEL_STEP_SECONDS: 45.0
FUEL_STEP_AMOUNT: 0.12
FUEL_DRAIN_START: 1.0
FUEL_MAX: 100.0
FUEL_START: 65.0
WARNING_LEAD_SECONDS: 5.0
```

## 구현 범위

### DifficultyPressureSnapshot

- `speed_step`, `fuel_step`, `effective_at`을 불변 read API로 제공.
- equality와 deterministic dictionary 제공.

### DifficultyDirector union schedule

- speed cursor 30초, fuel cursor 45초를 별도로 소유.
- commit 순서: `30, 45, 60, 90, 120, 135, 150, 180...`.
- 같은 시각에는 하나의 event만 emit하고 axes는 `SPEED → FUEL` 순서.
- forecast/event는 from/to snapshot과 changed axes를 제공.
- legacy `current_level`, `from_level`, `to_level`, pressure band는 speed step 호환 의미를 유지.

### RunBalance compatibility

- `base_speed_for_step`·`base_fuel_drain_for_step` 추가.
- `current_speed_for_snapshot`·`fuel_drain_rate_for_snapshot` 추가.
- 기존 elapsed API는 step을 계산한 뒤 새 API로 위임하는 호환 wrapper.
- 상수·공식·Combo·reward 의미 변경 0.

### RunController consumption

- 각 simulation segment는 director의 current snapshot으로 speed·fuel rate를 계산.
- old snapshot이 boundary까지 적용되고, run clock과 director commit 뒤 다음 segment가 새 snapshot을 소비.
- pause 중 run clock·director·fuel consumption 모두 정지.
- injected 10/20-second schedule test로 elapsed wrapper와 snapshot authority를 구분.

## TDD 증거

### Cycle 1 — immutable snapshot

```text
RED 1d99efa107cf0bf6023c5ccefd61ce0a0783896c
Project Contract 348 PASS
Godot Tests 320 FAIL · snapshot script absent

GREEN d9921a4e8a91005de8556488a39d9d128201f928
Project Contract 349 PASS
Godot Tests 321 PASS
```

### Cycle 2 — union schedule

```text
RED 58577e3c98de6862c0694ded906dfb05fc3f322a
Project Contract 350 PASS
Godot Tests 322 FAIL · old 30-second-only director

INTERMEDIATE 24c4b03646c1362c3a1bfa59c3225e26884e8147
Project Contract 354 PASS
Godot Tests 326 FAIL · legacy controller event expectation exposed

GREEN 0e73931bf2dc8334743f472ec3f57c64b2845ccc
Project Contract 355 PASS
Godot Tests 327 PASS
```

### Cycle 3 — snapshot-based balance/controller

```text
RED 32220e4761dd740ed1e164f29c9f8d541c10ddfc
Project Contract 358 PASS
Godot Tests 330 FAIL · snapshot balance APIs absent and controller still elapsed-based

GREEN 201dff55fe3b36b80ee88492ec9cabccbc6906e0
Project Contract 362 PASS
Godot Tests 334 PASS
33 cases · 7755 assertions · 0 failures
```

## 적대적 검토 Findings

| Finding | 등급 | 판정 | 처리 |
|---|---|---|---|
| F108 speed/fuel boundary split authority | P1 MUST_FIX | FIXED | two cursors·one union director |
| F109 combined timestamp duplicate events | P1 | PREVENTED | one event with ordered axes |
| F110 RunController elapsed-time pressure consumption | P1 MUST_FIX | FIXED | snapshot APIs only in production consumer |
| F111 boundary retroactive fuel application | P1 | PREVENTED | old snapshot applies through segment boundary |
| F112 pause wall-time catch-up | P1 | PREVENTED | inactive controller advances neither clock nor director |
| F113 balance constant drift | HARD_CONSTRAINT | PREVENTED | constants unchanged; parity tests |
| F114 legacy level API ambiguity | COMPATIBILITY | ACCEPTED | level remains speed-step compatibility surface |

남은 P0/P1 구현 결함: `0`.

## 변경 파일 소유권

```text
game/difficulty/difficulty_pressure_snapshot.gd
game/difficulty/difficulty_director.gd
game/difficulty/difficulty_event.gd
game/difficulty/difficulty_forecast.gd
game/run/run_balance.gd
game/run/run_controller.gd
tests/difficulty/test_difficulty_director.gd
tests/difficulty/test_difficulty_pressure_schedule.gd
tests/run/test_run_balance.gd
tests/run/test_run_controller_difficulty_events.gd
tests/run/test_run_controller_pressure_authority.gd
tests/run_tests.gd
```

불변:

```text
balance constant values
project.godot
map/session/Profile/save
product Scene/UI/assets
onboarding
target100
UGC/online
wrong 19Ff... Sheet
```

## 검증 한계

```yaml
product_scene_runtime: NOT_RUN
android_device: NOT_RUN
human_5_plus: NOT_RUN
compact_token_visual_readability: NOT_RUN
soak_10_minute: NOT_RUN
economy_simulation: NOT_RUN
target100: NOT_RUN
F58: NOT_MET
```

## 병합 Gate

- latest main 대비 behind 0
- exact-head Project Contract PASS
- exact-head Godot Tests PASS
- changed-file ownership PASS
- unresolved review threads 0
- REQUEST_CHANGES 0
- correct Sheet `APPROVED_PENDING_MERGE · SX-AUD-011` readback
- wrong `19Ff...` Sheet untouched

병합·Sheet closure 뒤에만 `VS03-R1 MERGED_AND_VERIFIED · SYNCED`와 `VS03-05A_ONLY`를 확정한다.
