# VS-03 Definition of Ready Adversarial Audit

```yaml
audit_id: SX-AUD-005
evidence_id: EV-USER-016
status: PASS_WITH_PLANNING_FIXES · READY_FOR_BUILD_CANDIDATE
review_date: 2026-08-02
product_baseline: 4e435a1a6d10ab146197671049da80709fd18c1f
planning_baseline: aac3ed870a8ff5e5c5f38d647f8a3ae91f8c0574
product_implementation: NOT_STARTED
sheet_state: CANONICAL_SYNC_PENDING
codex_state: READY_FOR_BUILD_PENDING_CANONICAL_SYNC
first_authorized_package: VS03-01
```

## 1. 결론

저장소 실제 코드, test runner, current plans, Issue #6, GMB-001 canon을 대조한 결과, 최초 상태는 `NOT_READY`였다. 기존 승인 계획에는 실행자가 그대로 복사할 경우 발생하는 P1 충돌이 있었다.

본 감사에서 제품 의도를 바꾸지 않는 planning fix를 적용했다.

- 실제 custom test runner로 테스트 계약 통일
- compact footprint와 기존 `train_cells()` 점유 가정 사이에 backward-compatible seam 정의
- composition root·RunController·RunSession 책임 분리
- MapDefinition 재구성 입력과 fully-configured RunSession 계약 추가
- authoritative frame/tie order 정의
- Profile single-writer transaction 계약 정의
- 공통 hotspot owner와 7개 순차 PR 고정
- target3와 target100 범위 재분리
- 잘못된/존재하지 않는 파일 경로를 실행 정본에서 교정
- rollback과 evidence 위치 고정

이 문서, 실행 아키텍처, build segmentation이 canonical merge되고 올바른 Sheet에 같은 Audit/Evidence ID와 merge SHA가 반영된 뒤 `G3P PASS · READY_FOR_BUILD`로 승격할 수 있다.

승격 범위는 `VS03-01`뿐이다. 제품 구현은 아직 시작되지 않았다.

## 2. 검토한 실제 기준

### Existing code

```text
game/main/main.gd / main.tscn
game/rail/rail_graph.gd / rail_generator.gd / rail_switch.gd
game/train/train_state.gd / train_controller.gd / wagon_view.gd
game/cargo/cargo_stack.gd / cargo_spawner.gd
game/station/station.gd / station_placer.gd
game/delivery/delivery_loop.gd
game/input/gameplay_input_state.gd
```

### Existing verification

```text
tests/test_case.gd
tests/run_tests.gd
tests/integration/test_delivery_loop.gd
.github/workflows/godot-tests.yml
historical 9 cases / 6915 assertions / 0 failures
```

### Planning/canon

```text
GMB-001_CANONICAL_DECISIONS.md
VERTICAL_SLICE_CONTRACT.md
2026-08-02-switchy-express-current-vertical-slice.md
CODEX_GOAL_VS_03.md
Decision-specific specs/plans for SX-DEC-014~026
Issue #6
```

## 3. Findings

| ID | Severity | Finding | Evidence | Planning fix | State |
|---|---|---|---|---|---|
| SX-AUD-005-F76 | P1 | `DeliveryLoop`가 `train.train_cells()`를 spawn occupancy로 직접 사용하여 full-cell wagon을 전제한다. compact footprint 계약과 충돌한다. | DeliveryLoop/TrainState/TrainController/current integration test | optional occupancy provider + `TrainFootprint`; legacy fallback 보존 | CLOSED_IN_DOR |
| SX-AUD-005-F77 | P1 | 여러 계획이 `run(test)`, `test.case`, `assert_not_equal`, `run_single.gd`, `--suite`를 전제하지만 실제 runner는 `func run()`과 제한된 assertion만 지원한다. | `tests/run_tests.gd`, `tests/test_case.gd`, Decision plans | current runner canonical; 최소 helper만 추가; unsupported commands 금지 | CLOSED_IN_DOR |
| SX-AUD-005-F78 | P1 | `main.gd/main.tscn`이 비어 있고 composition owner가 없어 단일 controller/main에 모든 책임이 집중될 위험이 있다. | actual main files | Main→PlayScene→RunController/RunSession composition boundary | CLOSED_IN_DOR |
| SX-AUD-005-F79 | P1 | 여러 계획이 `run_controller`, `run_summary`, `profile_schema/store`, `result_panel`, `tests/run_tests`를 독립적으로 수정한다. 순서 없이 병렬 실행하면 overwrite/API drift가 발생한다. | GMB plans file maps | 7 package owner matrix; previous merge required | CLOSED_IN_DOR |
| SX-AUD-005-F80 | P1 | map plan의 `RunSessionFactory` 예시는 service를 생성만 하고 Train/Delivery/Difficulty를 완전 configure하지 않는다. MapDefinition도 start/incoming을 명시하지 않는다. | same-seed restart plan | explicit reconstruction fields + MapBuildResult + fully-configured success only | CLOSED_IN_DOR |
| SX-AUD-005-F81 | P1 | movement, pickup/unload, fuel drain, difficulty, fuel-zero의 frame/tie order가 없어서 post-death event 또는 reward timing drift 가능성이 있다. | existing DeliveryLoop + future RunController plans | boundary-sliced loop; max one cell event/segment; event-before-zero exact tie | CLOSED_IN_DOR |
| SX-AUD-005-F82 | P1 | records, reward, unlock, discovery, onboarding plans이 각각 Profile write를 암시해 multi-writer와 duplicate commit 위험이 있다. | Profile/progression/map/onboarding plans | ProfileStore serializer + ProfileTransactionService single writer | CLOSED_IN_DOR |
| SX-AUD-005-F83 | P1 | onboarding plan의 `game/cargo/delivery_loop.gd`, cosmetic plan의 존재하지 않는 `game/train/train_view.gd` 등 경로가 실제 repo와 맞지 않는다. | repo search and plans | actual DeliveryLoop path correction; TrainView creation owner VS03-05 | CLOSED_IN_DOR |
| SX-AUD-005-F84 | P1 | target100 diversity/scan을 10초 unit watchdog에 넣으면 VS scope와 test runtime이 오염된다. | RailGenerator current diversity, runner watchdog, map plan | VS target3 only; target100 separate G6/M5 tool and audit | CLOSED_IN_DOR · F58_OPEN |
| SX-AUD-005-F85 | P2 | rollback, evidence location, package failure stop conditions이 분산되어 completion claim이 불명확하다. | current master/Decision plans | package-specific rollback/evidence/stop gates | CLOSED_IN_DOR |

Known open P0/P1 implementation-planning finding after fixes: `0`.

`F58`은 P1 planning defect가 아니라 Production implementation evidence gap으로 계속 `NOT_MET`이다.

## 4. API Collision Inventory

### Protected existing APIs

| API | Rule |
|---|---|
| `RailGenerator.generate(seed, max_attempts, force_candidate_failure)` | VS target3에서 유지; target100 확장 금지 |
| `RailGraph.next_cell/preview_route/signature` | routing authority unchanged |
| `TrainController.configure/set_speed/advance_time` | movement meaning unchanged; read-only boundary helpers만 추가 |
| `CargoStack.push/peek/pop_matching_group` | LIFO authority unchanged |
| `Station.try_unload` result Dictionary | `count`가 Combo authority input |
| `CargoSpawner.configure/process/signature` | deterministic population meaning unchanged |
| `DeliveryLoop.configure/advance_time` | optional footprint seam만 추가; legacy null fallback 유지 |
| `GameplayInputState.is_loading/is_boosting` | BOOST priority unchanged |

### New seams

```text
TrainController.seconds_to_next_cell()
TrainController route-history/path-sampling read API
TrainFootprint.occupied_cells()
DeliveryLoop optional occupancy provider
MapBuildResult explicit reconstruction inputs
RunSessionFactory fully configured success
ProfileTransactionService single writer
```

No approved core API is deleted in VS03-01/02.

## 5. Package Dependency Audit

```text
VS03-01 run lifecycle/difficulty/test helpers
  ↓
VS03-02 compact footprint + DeliveryLoop seam
  ↓
VS03-03 target3 map identity/session/restart/selection
  ↓
VS03-04 Profile transactions/records/cosmetics/unlocks/rewards
  ↓
VS03-05 product scene/camera/HUD/result/browsers
  ↓
VS03-06 contextual onboarding
  ↓
VS03-07 end-to-end integration/evidence handoff
```

병렬 작업 금지 대상:

- `game/run/run_controller.gd`
- `game/run/run_summary.gd`
- `game/profile/profile_schema.gd`
- `game/profile/profile_store.gd`
- `game/ui/result_panel.*`
- `game/play/play_scene.gd`
- `tests/run_tests.gd`

각 package는 이전 package merge SHA에서 시작한다.

## 6. Test Contract Audit

Canonical runner:

```bash
./Godot_v4.7.1-stable_linux.x86_64 \
  --headless --path . --script res://tests/run_tests.gd
```

Canonical suite shape:

```gdscript
extends "res://tests/test_case.gd"

func run() -> void:
    assert_true(...)
```

실행 계획에서 금지:

- `tests/run_single.gd`
- `--suite`
- `func run(test)`
- `test.case`
- 파일 생성 전 preload

필요 assertion helper는 VS03-01에서 repository TestCase에 test-first로 추가한다.

## 7. Save/Profile Boundary Audit

Current product save implementation: `none`.

따라서:

- VS03-04가 첫 Profile schema v1과 writer를 소유한다.
- production path는 `user://profile_v1.json`.
- tests는 injectable temp backend/path를 사용한다.
- records/reward/unlock/discovery/onboarding가 개별 파일 save를 하지 않는다.
- one operation = one ProfileTransactionService commit.
- no prior released save migration PASS claim.
- v1→future migration hooks/corruption tests는 구현한다.
- save failure는 result/restart와 RunState를 막거나 변경하지 않는다.

## 8. Exact Acceptance Evidence

### Package automated evidence

- tests under package-specific directories
- all new suites listed in `tests/run_tests.gd`
- exact-head Project Contract and Godot Tests
- PR body API/rollback inventory

### Integration evidence

`기획서/50_제작_검증/VS03_IMPLEMENTATION_AUDIT.md`가 VS03-07에서 생성된다.

### Deferred evidence

Issue #7 owns:

- 10-minute soak
- Android export/device performance
- safe area/48dp/Reduced Motion runtime
- localization 140%
- accessibility runtime
- economy simulation
- 5명+ human comprehension
- representative captures

DoR PASS는 위 항목의 PASS가 아니다.

## 9. Rollback Audit

- VS03-01/02: no save or Scene; full PR revert.
- VS03-03: code + target3 manifest together; no silent map fallback.
- VS03-04: first schema v1; later package revert must retain reader.
- VS03-05: camera instant full-map, result neutral-only, default cosmetic, browser entry hidden.
- VS03-06: onboarding skip/disable assist; standard run remains.
- VS03-07: telemetry non-blocking; evidence docs independent.

Rollback cannot change rail/LIFO/Combo/record/reward approved semantics.

## 10. Scope Audit

### Authorized local build

- run economy/difficulty
- compact token/footprint
- target3 official maps
- same-map restart and local selection
- local Profile/records/cosmetics/unlocks/rewards
- camera/HUD/result/local browsers
- contextual onboarding
- bounded local telemetry

### Not authorized in VS-03

- target100 completion or F58 closure
- 100-entry product browser audit
- UGC editor/backend/publication
- moderation/privacy/anti-abuse
- online records/community
- Android/human/soak PASS claim

## 11. Definition of Ready Checklist

- [x] existing API/file collision inventory
- [x] package dependency/order audit
- [x] implementation PR segmentation
- [x] rollback strategy
- [x] Profile/save migration boundary
- [x] exact acceptance tests and evidence locations
- [x] scope budget and deferral enforcement
- [x] actual test runner normalization
- [x] composition/session ownership
- [x] authoritative frame order
- [x] user instruction to proceed (`EV-USER-016`)
- [ ] canonical PR merge
- [ ] correct Sheet Audit/Evidence/ready status + final readback

## 12. Promotion Rule

After the final two items pass:

```yaml
G3P: PASS · READY_FOR_BUILD
codex_state: READY_FOR_BUILD
initial_package: VS03-01
product_implementation: NOT_STARTED
```

This does not authorize VS03-02~07 in parallel and does not mark any runtime/device/human evidence as passed.
