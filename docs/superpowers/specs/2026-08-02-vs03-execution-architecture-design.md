# VS-03 Execution Architecture Design

```yaml
audit_id: SX-AUD-005
evidence_id: EV-USER-016
scope: DEFINITION_OF_READY
status: APPROVED_RECOMMENDED_ARCHITECTURE · CANONICAL_SYNC_PENDING
product_implementation: NOT_STARTED
product_baseline: 4e435a1a6d10ab146197671049da80709fd18c1f
planning_baseline: aac3ed870a8ff5e5c5f38d647f8a3ae91f8c0574
```

## 1. 목적

`SX-DEC-014~026`의 승인 의미를 바꾸지 않고, 현재 저장소에서 VS-03 구현을 충돌 없이 시작할 수 있는 실행 아키텍처를 고정한다.

이 문서는 개별 Decision 설계·TDD 계획보다 **파일 책임, 기존 API 접점, 패키지 순서, 테스트 방식, 저장 권위, 롤백 경계**에서 우선한다. 개별 계획의 예시 코드·경로·명령이 실제 저장소와 충돌하면 이 문서와 `2026-08-02-vs03-build-segmentation.md`를 따른다.

## 2. 실제 구현 기준선

현재 제품 기반:

```text
game/main/main.gd                 empty composition entry
game/main/main.tscn               root Node2D only
game/rail/rail_graph.gd           graph/switch/preview/signature authority
game/rail/rail_generator.gd       deterministic generator + safe fallback
game/train/train_state.gd         full-cell route history foundation
game/train/train_controller.gd    continuous movement/target lock
game/cargo/cargo_stack.gd         capacity-8 LIFO authority
game/cargo/cargo_spawner.gd       deterministic pickup population/respawn
game/station/station_placer.gd    deterministic station placement/signature
game/station/station.gd           matching top-group unload
game/delivery/delivery_loop.gd    movement/pickup/unload/spawn integration
game/input/gameplay_input_state.gd LOAD/BOOST semantic state
tests/run_tests.gd                static custom headless runner
tests/test_case.gd                repository assertion API
```

보호 기준:

- 기존 공개 API와 9개 테스트 suite는 각 패키지에서 회귀 없이 유지한다.
- `main.gd`에 모든 도메인·Profile·UI 책임을 몰아넣지 않는다.
- `RunController`는 run lifecycle 권위지만 map 생성, Profile 직렬화, UI animation을 소유하지 않는다.
- GMB-001의 승인 의미와 VS/Production 단계 경계를 변경하지 않는다.

## 3. Composition Root

### Main

`game/main/main.gd`는 앱 진입·최상위 scene 호스팅만 담당한다.

허용:

- `PlayScene` 인스턴스 생성 또는 등록된 main child 연결
- 앱 수준 설정·종료 전달

금지:

- 점수·연료·Combo 계산
- map 생성·selection
- Profile transaction
- result·onboarding step 완료
- UI animation을 통한 run 시작·종료

### PlayScene

`game/play/play_scene.gd`는 runtime composition root다.

책임:

- catalog/Profile/settings를 로드한다.
- semantic start request를 `MapSelectionService`에 전달한다.
- `RunSessionFactory`가 반환한 **완전 구성된** session을 `RunController`에 연결한다.
- 도메인 event를 presentation ViewModel과 OnboardingState에 전달한다.
- UI intent를 도메인 명령으로 변환하되 결과 권위를 갖지 않는다.

### RunSession

`RunSession`은 한 attempt의 mutable service graph다.

필수 구성 요소:

```text
RunIdentity
RailGraph
stations
initial pickup snapshot + CargoSpawner
CargoStack
GameplayInputState
TrainController
TrainFootprint
DeliveryLoop
RunState
DifficultyDirector
bounded RunMetricsAccumulator
```

`RunSessionFactory.create()`는 모든 구성·연결·signature 검증이 끝난 session만 성공으로 반환한다. 부분 구성 session을 외부에 노출하지 않는다.

## 4. Compact Footprint 통합 경계

현재 `DeliveryLoop`는 spawn occupancy를 `TrainController.train_cells()`로 직접 전달하고, 기존 `TrainState`는 화차를 full-cell spacing으로 표현한다. 이는 `SX-DEC-015`의 compressed footprint와 충돌한다.

해결 계약:

1. `TrainFootprint`가 CargoStack 크기·compact geometry·열차 route history를 읽어 authoritative occupied rail cells를 산출한다.
2. `DeliveryLoop.configure()`에 optional occupancy provider를 추가한다.
3. provider가 있으면 `occupied_cells()`를 사용한다.
4. provider가 없으면 기존 `train.train_cells()` fallback을 유지하여 기존 테스트와 API를 보호한다.
5. VS-03 production composition은 항상 `TrainFootprint` provider를 주입한다.
6. `TrainController.set_wagon_count(cargo_count)`를 compact-token 점유 권위로 사용하지 않는다.
7. `TrainController`는 read-only route-history/path-sampling seam만 제공한다.
8. CargoStack 변경, token ViewModel, footprint 갱신은 같은 authoritative event 처리 단계에서 수행한다.

테스트:

- 기존 full-cell compatibility test 유지
- compact footprint 0/1/4/8
- 8개 trailing occupied cells `<=3`
- straight/curve/switch order parity
- respawn이 compressed footprint와 forward exclusion을 침범하지 않음

## 5. Authoritative Run Step Order

`RunController.advance_time(delta)`는 큰 frame delta를 그대로 한 번에 처리하지 않는다.

### Boundary-sliced loop

각 반복에서 다음 중 가장 짧은 시간을 선택한다.

```text
remaining frame delta
MAX_SIMULATION_STEP_SECONDS TEST_VALUE
TrainController.seconds_to_next_cell()
predicted time to fuel zero
next authoritative difficulty boundary when exposed
```

한 segment에는 최대 한 cell-entry event만 허용한다.

### Segment 순서

1. phase·pause·ended guard
2. semantic input snapshot
3. current cargo/input/difficulty로 speed·fuel drain rate 계산
4. `TrainController.set_speed()`
5. segment duration 결정
6. `DeliveryLoop.advance_time(segment)`
7. cell event를 시간순으로 적용
   - pickup/unload mutation은 기존 DeliveryLoop/Station/CargoStack 의미 보존
   - unload 결과로 Combo·score·fuel reward 적용
   - CargoStack 변화 직후 footprint/view model 갱신
8. `DifficultyDirector.advance(segment)` 및 committed events 적용
9. time fuel drain 적용
10. fuel clamp·end condition 평가
11. exact timestamp에서 cell event와 fuel-zero가 같으면 **cell event를 먼저 적용한 뒤** fuel-zero를 평가
12. remaining delta가 있으면 새 상태로 다음 segment 계산

보호:

- fuel 0 이후 이동·pickup·unload 없음
- 한 run generation에서 end/summary/Profile commit 한 번
- speed bonus는 Combo를 변경하지 않음
- presentation on/off가 authoritative trace를 변경하지 않음

## 6. Map Reconstruction Contract

`MapDefinition`은 hash만이 아니라 재구성 입력을 명시적으로 가진다.

필수 필드:

```text
map_id
map_revision
map_seed
generator_version
ruleset_version
train_start_cell
train_incoming_cell
switch_default_signature
graph_signature
station_signature
initial_pickup_signature
layout_signature
content_signature
validation_status
used_fallback
```

초기 시작 예시는 `start=(0,0)`, `incoming=(0,1)`로 직진 RIGHT를 만든다. `INITIAL_DIRECTION` 같은 모호한 표현 대신 `TrainController.configure()`가 실제 소비하는 incoming cell을 저장한다.

`MapBuildResult`는 다음을 포함한다.

```text
definition
graph
stations
initial_pickup_snapshot
spawner
train_start_cell
train_incoming_cell
```

`RunSessionFactory`는:

- exact definition 재구성
- graph/station/initial pickup/layout/content signatures 비교
- TrainController configure
- CargoStack/Input/Spawner/Footprint configure
- DeliveryLoop configure + footprint provider 연결
- RunState/DifficultyDirector reset
- 모든 mutable service 새 인스턴스 확인

을 완료한 뒤에만 `SESSION_CREATED`를 반환한다.

`RunSession.immutable_signatures()`는 mutable live spawner를 다시 읽지 않고 session 생성 시 저장한 initial signature snapshot을 사용한다.

## 7. VS Map Scope

VS-03은 현재 generator로 얻을 수 있는 **서로 다른 3개 non-fallback layout**만 요구한다.

- generator 100+ 다양성 확장은 G6/M5 Production 작업이다.
- VS-03 PR에서 target-100 scan·100-entry manifest·100-entry browser를 실행하거나 완료로 표시하지 않는다.
- 3개 manifest도 graph/station/pickup/layout/content signature와 reconstruction test를 통과해야 한다.
- fallback·duplicate는 3개에도 포함하지 않는다.
- `F58`은 계속 `NOT_MET`다.

## 8. Profile Single-Writer Contract

Profile은 여러 서비스가 직접 저장하지 않는다.

### ProfileStore

- production path: `user://profile_v1.json`
- temp path: `user://profile_v1.tmp`
- injectable storage/path backend for tests
- normalize·migrate·atomic replace만 소유
- RunState를 save 성공 여부로 변경하지 않음

### ProfileTransactionService

Profile mutation의 단일 authority다.

```text
commit(operation_id, mutation) -> immutable receipt
```

한 transaction 안에서 필요한 조합을 처리한다.

- official global/per-map record update
- bounded reward grant
- goal/unlock/provenance
- map discovery/recent/favorite
- onboarding preference

보호:

- namespaced stable operation ID
- processed operation journal bounded
- 같은 operation 재시도는 기존 receipt와 동일 결과
- record commit 뒤 reward 계산
- global+per-map 동시 갱신도 record reward component 1회
- UI/animation은 commit을 시작하지 않음

### Schema boundary

- 첫 제품 Profile schema는 v1로 시작한다.
- 아직 배포 save가 없으므로 “기존 사용자 save migration 완료”를 주장하지 않는다.
- v1 내부에 VS-03 local fields를 한 번에 정의해 PR 간 version 폭증을 피한다.
- 이후 schema 변경은 migration test와 함께 version 증가.
- corrupt JSON은 default recovery + reason code; unrelated valid field 부분 복구 규칙을 테스트한다.
- Profile PR 이후 presentation PR은 schema를 변경하지 않는다.

## 9. Test Harness Contract

실제 저장소 runner를 유지한다.

```text
tests/run_tests.gd
→ static TEST_SCRIPTS
→ each suite extends res://tests/test_case.gd
→ func run() -> void
→ repository assertion methods
```

실행 명령:

```bash
./Godot_v4.7.1-stable_linux.x86_64 \
  --headless --path . --script res://tests/run_tests.gd
```

금지:

- 존재하지 않는 `tests/run_single.gd`
- 지원되지 않는 `--suite`를 성공 기준으로 사용
- `func run(test)` 또는 `test.case()`를 그대로 복사
- 새 파일 생성 전 static preload 등록

첫 구현 PR에서 `TestCase`에 필요한 최소 helper만 추가할 수 있다.

```text
assert_not_equal
assert_less_equal
assert_almost_equal
```

runner 교체·외부 test framework 도입은 VS-03 범위 밖이다.

Target-100 audit은 10초 unit watchdog에 넣지 않고 별도 Production tool/Gate에서 실행한다.

## 10. File Ownership Rules

공통 hotspot은 한 PR에서 한 owner만 수정한다.

| File/Responsibility | Canonical owner package |
|---|---|
| `tests/test_case.gd`, runner conventions | VS03-01 |
| `game/run/run_state.gd`, `run_controller.gd`, `run_summary.gd` | VS03-01, later packages consume/add narrow adapters only |
| difficulty authority | VS03-01 |
| TrainFootprint + DeliveryLoop occupancy seam | VS03-02 |
| MapDefinition/Catalog/SessionFactory/selection | VS03-03 |
| Profile schema/store/transaction/records/rewards/unlocks | VS03-04 |
| `game/play/**`, main scene, camera, HUD, result, collection, map browser | VS03-05 |
| onboarding domain/preferences/UI integration | VS03-06 |
| end-to-end integration/telemetry handoff | VS03-07 |

`game/train/train_view.gd`는 현재 존재하지 않는다. 필요하면 VS03-05가 최초 생성하며 cosmetic plan은 그 이전에 해당 파일을 수정하지 않는다.

Onboarding 계획의 `game/cargo/delivery_loop.gd` 표기는 실제 `game/delivery/delivery_loop.gd`로 정정한다.

## 11. Rollback

- 각 package PR은 이전 main 위에서 독립 검증 후 squash merge한다.
- package 실패 시 해당 PR 전체를 revert할 수 있어야 한다.
- VS03-01/02는 save를 쓰지 않는다.
- VS03-03 target3 catalog는 code+manifest를 같은 PR에서 되돌린다.
- VS03-04 이후 v1 Profile은 후속 UI/onboarding revert에도 계속 읽혀야 한다.
- result insight 실패: `NEUTRAL_ONLY` presentation fallback.
- camera 실패: instant full-map fallback.
- cosmetic asset 실패: default cosmetic fallback.
- map browser 실패: manual entry 숨김; validated AUTO_NEW_RUN/RESTART 유지.
- onboarding 실패: skip/disabled assist; standard run 유지.
- map reconstruction 실패: 다른 맵으로 silent substitution 금지.

Feature fallback은 코어 rail/LIFO/record/reward 의미를 바꾸지 않는다.

## 12. Scope Budget

VS-03 구현 허용:

- local run/core/UI/Profile
- exactly 3 representative official maps
- local official global/per-map records
- representative cosmetics/unlock/reward
- contextual onboarding

금지:

- generator target100 완료
- 100-map browser QA
- UGC editor/backend/publication
- moderation/privacy/anti-abuse
- online records/community
- Android/human/soak PASS 주장

## 13. Ready 판정

이 아키텍처와 build segmentation이 canonical merge되고 올바른 Sheet readback이 통과하면:

```text
G3P = PASS · READY_FOR_BUILD
Codex = READY_FOR_BUILD · VS03-01_ONLY
product implementation = NOT_STARTED
```

승격은 전체 VS-03을 한 번에 구현하라는 뜻이 아니다. `VS03-01`부터 순서대로 시작하고 각 package의 merge Gate를 통과한 뒤 다음 package로 이동한다.
