# Codex Goal — VS03-03 Map Identity, Target-3 Catalog and Fresh Sessions

```yaml
status: READY_FOR_BUILD
issue: 6
parent_epic: 3
gmb001: CLOSED · SX-DEC-017~026 · DECISION_MERGE_9b63421a
dor_audit: SX-AUD-005 · PASS · SYNCED
vs03_01_audit: SX-AUD-006 · PASS · SYNCED
vs03_01_merge: 43972d3d23e931af3dbc81ab9b1c7d942fffb201
vs03_02_audit: SX-AUD-008 · PASS · MERGED_AND_VERIFIED · SHEET_READBACK_PASS
vs03_02_evidence: EV-VS03-02-001
vs03_02_merge: cfe6d5ca0c76942720c5c12ad5dc59aaa651b915
execution_authority: VS03-03_ONLY
product_implementation: VS03_01_AND_02_MERGED
online_ugc: OUT_OF_SCOPE_FOR_VS03
target100: OUT_OF_SCOPE · F58_NOT_MET
```

> 이 문서는 현재 `VS03-03`에 한해 실행 가능한 Codex Goal이다. VS03-R1 이후 package를 병렬로 시작하지 않는다. VS03-01 run authority와 VS03-02 compact footprint contract를 병합된 기반으로 보호한다.

## 반드시 먼저 읽기

```text
기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md
기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md
기획서/50_제작_검증/VS03_PACKAGE_STATUS.md
기획서/50_제작_검증/VS03_02_SYNC_CLOSURE.md
기획서/50_제작_검증/VS03_02_IMPLEMENTATION_AUDIT.md
기획서/50_제작_검증/VS03_01_IMPLEMENTATION_AUDIT.md
기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md
기획서/50_제작_검증/VS03_DEFINITION_OF_READY_AUDIT.md
docs/superpowers/specs/2026-08-02-vs03-execution-architecture-design.md
docs/superpowers/plans/2026-08-02-vs03-build-segmentation.md
docs/superpowers/plans/2026-08-03-vs03-core-first-resegmentation.md
actual code and tests
```

`VS03_PACKAGE_STATUS.md`가 현재 package 상태를 소유한다. 오래된 status/order와 충돌하면 상태 레지스트리를 우선하고, 승인된 player-facing meaning은 변경하지 않는다.

## 전체 Package Sequence

```text
VS03-01 run lifecycle/economy/difficulty · MERGED_AND_VERIFIED
→ VS03-02 compact footprint/DeliveryLoop seam · MERGED_AND_VERIFIED
→ VS03-03 target3 maps/session/restart/selection · READY_FOR_BUILD · CURRENT
→ VS03-R1 difficulty authority alignment · BLOCKED
→ VS03-05A minimal playable core surface · BLOCKED
→ VS03-04 Profile transaction/records/cosmetics/unlocks/rewards · BLOCKED
→ VS03-05B result/collection/map browser · BLOCKED
→ VS03-06 contextual onboarding · BLOCKED
→ VS03-07 integration/evidence handoff · BLOCKED
```

각 package는 이전 package merge와 정본 동기화 뒤에만 시작한다.

# 현재 실행 권위 — VS03-03 ONLY

## 목표

정확히 3개의 검증된 official map을 immutable identity로 구성하고, 한 run마다 완전히 새로운 mutable service graph를 만드는 `RunSessionFactory`를 구현한다. 같은 맵 재시작은 동일한 `MapDefinition`을 사용하되 run·transaction·service identity를 새로 만들며, 자동 새 run은 미발견 map을 우선하고 수동 재선택은 명시적 discovered map만 사용한다.

## Decisions

```text
SX-DEC-023 · same-map restart / validated official catalog
SX-DEC-024 · automatic discovery / semantic reselection
SX-DEC-025 · local per-map identity prerequisite only
```

Profile persistence·record commit·browser UI는 이 package에서 구현하지 않는다.

## 생성 파일

```text
game/map/map_definition.gd
game/map/map_catalog.gd
game/map/map_build_result.gd
game/map/map_build_pipeline.gd
game/map/map_selection_request.gd
game/map/map_selection_receipt.gd
game/map/map_shuffle_bag.gd
game/map/map_discovery_state.gd
game/map/map_selection_service.gd
game/run/run_identity.gd
game/run/run_id_factory.gd
game/run/run_session.gd
game/run/run_session_factory.gd
data/maps/map_catalog_vs03.json
tests/support/map_fixture.gd
tests/map/**
tests/run/test_same_map_restart.gd
tests/integration/test_three_map_discovery_flow.gd
```

## 제한적 수정 파일

```text
game/run/run_controller.gd
tests/run_tests.gd
```

필요성이 실패 테스트로 증명되지 않은 다른 파일은 수정하지 않는다.

## 명시적 제외

```text
generator target100 expansion
target100 scan or 100-entry browser
F58 closure
Profile schema/store/writer
record/reward/unlock/currency
product Scene/HUD/result/camera/browser
VS03-R1 difficulty union schedule
onboarding
UGC/backend/online
```

## MapDefinition 계약

각 definition은 최소 다음 immutable 데이터를 소유한다.

```text
map_id
map_revision
seed
generator_version
content_version
grid size
train_start_cell
train_incoming_cell
rail topology/layout signature
station signature
pickup/spawn signature 또는 reconstruction contract
fallback flag
```

요구:

- 같은 definition은 같은 authoritative signatures를 재구성한다.
- start cell과 incoming cell은 유효한 인접 rail이다.
- raw seed는 player-facing request/receipt에 포함하지 않는다.
- definition 생성 후 mutable service state를 포함하지 않는다.
- selected map의 invalidity를 다른 map으로 silent substitute하지 않는다.

## MapCatalog·Build Pipeline 계약

VS03 catalog는 정확히 3개 entry만 가진다.

거부:

- invalid graph
- fallback generation
- duplicate `map_id/revision`
- duplicate layout signature
- mismatched seed/version reconstruction
- invalid start/incoming cells
- missing required station/pickup guarantees

`map_catalog_vs03.json`은 검증 pipeline 결과만 기록한다. runtime에서 임의 seed를 추가하거나 target100을 생성하지 않는다.

## RunIdentity 계약

- new run마다 unique `run_id`.
- same-map retry는 이전 run을 가리키는 retry lineage를 가질 수 있지만 같은 run ID를 재사용하지 않는다.
- reward/profile transaction ID placeholder가 필요하면 run identity와 분리된 namespace를 사용하되 Profile writer를 만들지 않는다.
- deterministic tests는 injectable ID factory를 사용한다.

## RunSession 계약

`RunSession`은 한 attempt의 mutable object graph다.

최소 포함:

```text
MapDefinition / RunIdentity
RailGraph
TrainController with explicit start+incoming
CargoStack
CompactWagonTokenState
TrainFootprint
CargoSpawner
stations
GameplayInputState
DeliveryLoop with TrainFootprint provider
RunState / RunMetricsAccumulator / DifficultyDirector / RunController
selection receipt or origin metadata
```

`RunSessionFactory`는 모든 dependency와 callback이 구성되기 전 success를 반환하지 않는다. partial session을 반환하거나 caller가 추가 configure를 수행하게 하지 않는다.

## Same-Map Restart 계약

```text
same immutable MapDefinition
+ new RunIdentity
+ new CargoStack
+ new token state / TrainFootprint
+ new Spawner / DeliveryLoop / RunState / DifficultyDirector / RunController
+ score/fuel/stack/events/input reset
```

금지:

- mutable service object reuse
- stale callbacks from previous generation
- previous score/fuel/cargo/difficulty state leakage
- unavailable map을 다른 map으로 대체

## Selection 계약

Request modes:

```text
AUTO_NEW_RUN
RESTART_CURRENT_MAP
SELECT_DISCOVERED_MAP
```

Receipt는 semantic identity와 result를 제공하고 raw seed를 노출하지 않는다.

- AUTO_NEW_RUN은 eligible undiscovered map을 우선하고 한 cycle 안에서 중복을 피한다.
- first three AUTO_NEW_RUN starts는 서로 다른 target3 map이어야 한다.
- RESTART_CURRENT_MAP은 automatic bag을 소비하지 않는다.
- SELECT_DISCOVERED_MAP은 automatic bag을 소비하지 않는다.
- unavailable manual/restart는 explicit failure를 반환한다.
- discovery persistence는 VS03-04 Profile에서 수행하므로 이 package의 `MapDiscoveryState`는 injectable domain state다.

## 보호되는 VS03-01/02 API

```text
RunBalance / RunState / RunSummary / RunController
DifficultyDirector
TrainController.seconds_to_next_cell()
TrainController.route_history_cells()
TrainController.sample_trailing_position()
CompactWagonTokenState
TrainFootprint
DeliveryLoop optional occupancy provider
```

VS03-03은 run order·balance·compact geometry·legacy fallback을 임의 변경하지 않는다.

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
- target100 scan inside the 10-second unit watchdog

## TDD 순서

1. latest main과 PR #41 merge SHA 확인.
2. 기존 `19 cases / 7499 assertions` baseline 재확인.
3. explicit MapDefinition reconstruction fields/validation — RED→GREEN.
4. strict duplicate/fallback catalog rejection — RED→GREEN.
5. current generator로 3 distinct non-fallback map build — RED→GREEN.
6. same seed/version signature reconstruction — RED→GREEN.
7. RunIdentity fresh ID/retry lineage — RED→GREEN.
8. fully configured RunSessionFactory — RED→GREEN.
9. restart recreates all mutable services — RED→GREEN.
10. stale callbacks/state leakage 0 — RED→GREEN.
11. selection request/receipt semantics — RED→GREEN.
12. first three AUTO_NEW_RUN starts unique — RED→GREEN.
13. RESTART/manual automatic bag consumption 0 — RED→GREEN.
14. unavailable manual/restart explicit failure and no substitution — RED→GREEN.
15. full regression·adversarial review·exact-head Gate.

## Acceptance Tests

- exact map ID/revision/seed/version/start/incoming/signatures on reconstruction and restart
- exactly 3 distinct non-fallback layouts
- duplicate/fallback/invalid entries rejected
- new run ID and fresh service object identities
- score/fuel/stack/spawner/difficulty/input/events reset
- session cannot return success while any dependency is unconfigured
- DeliveryLoop receives the session TrainFootprint provider
- first three AUTO_NEW_RUN starts unique
- RESTART/manual consume automatic bag zero
- unavailable request fails explicitly without silent substitution
- raw seed absent from UI-facing request/receipt
- existing 19 suites remain green
- `F58` remains NOT_MET

## PR Gate

```text
behind main 0
Project Contract success
Godot Tests success
unresolved review threads 0
REQUEST_CHANGES 0
package-owned file inventory
RED/GREEN evidence
rollback documented
runtime/Android/human/online NOT_RUN explicit
```

## Rollback

Catalog manifest, map/session/selection domain code, narrow RunController adapter, and tests revert together as one package. Runtime generation fallback may not silently replace a selected map.
