# SX-AUD-010 · VS03-03 Implementation Audit

```yaml
audit_id: SX-AUD-010
status: PREMERGE_REVIEW
package: VS03-03
baseline_main: 38878c7ef124f37c36992dbdb9b62d1f88382dc1
implementation_pr: 46
working_branch: agent/vs03-03-map-session-selection
exact_head: fab692dd96bdffbc89e757a06672a9cbe82fa187
evidence_id: EV-VS03-03-001
planning_conflict: NONE
user_decision_required: NO
product_scene_runtime: NOT_RUN
android_human_evidence: NOT_RUN
target100: NOT_RUN
F58: NOT_MET
next_authority_after_merge_sync: VS03-R1_ONLY
```

## 목적

승인된 `SX-DEC-023/024`의 Vertical Slice 범위만 구현한다.

```text
exactly 3 distinct validated non-fallback official maps
→ immutable map identity and strict catalog reconstruction
→ fully configured fresh RunSession
→ exact same-map restart with fresh mutable services and identities
→ automatic undiscovered-first assignment
→ discovered-map semantic reselection domain
```

Profile 저장, 제품 Scene·HUD·브라우저, 난이도 R1 보정, 온보딩, target100, UGC·온라인은 범위 밖이다.

## 구현 범위

### 공식 맵·재구축

- `data/maps/map_catalog_vs03.json`: seed 1·2·5의 target3 공식 항목.
- `MapDefinition`: stable ID·revision·generator/ruleset version·start/incoming cell·재구축 signature.
- `MapBuildPipeline`: RailGraph·station·initial pickup을 deterministic하게 재구축하고 fallback·signature mismatch를 명시적으로 거부.
- `MapCatalog`: strict all-or-nothing load, duplicate identity/layout/content 거부, unavailable revision silent substitution 0.

### RunSession·재시작

- `RunIdentity`: map identity와 run/retry/transaction identity 분리.
- `RunSessionFactory`: graph·station·pickup·CargoStack·input·train·compact token·footprint·DeliveryLoop·RunController·DifficultyDirector를 매 시도 새로 구성.
- same-map restart: exact map ID/revision/content signature 유지, mutable service object와 run identity는 전부 신규.
- 승인된 `RunBalance.FUEL_MAX=100`, `FUEL_START=65` 재사용.
- stale generation callback 거부 seam.

### 맵 배정·발견

- semantic request: `AUTO_NEW_RUN`, `SELECT_DISCOVERED`, `RESTART`.
- automatic first cycle은 undiscovered bag을 우선하며 target3 첫 3회가 고유하다.
- 모든 맵 발견 뒤 replay bag으로 전환하고 대안이 있으면 즉시 반복을 피한다.
- manual·restart는 automatic bag을 소비하지 않는다.
- selection만으로 discovery를 기록하지 않으며, session construction 성공 뒤 `RunSessionStartService`가 receipt를 commit한다.
- raw seed는 request·receipt·public map/run identity에서 노출하지 않는다.

## TDD 증거

### Cycle 1 — MapDefinition·MapCatalog·reconstruction

```text
RED d976d89e0b646cdbfdbe8f2268d0cef26a8de244
Project Contract 298 PASS
Godot Tests 273 FAIL · production files absent

GREEN 2124750874342456a96892d9a7cd79895d1f1185
Project Contract 310 PASS
Godot Tests 285 PASS
22 cases · 7530 assertions · 0 failures
```

### Cycle 2 — fresh RunIdentity·RunSessionFactory·restart

```text
RED c9fc94de769ca36a28c64ff3d9425e534b679c56
Project Contract 313 PASS
Godot Tests 288 FAIL · session production files absent

GREEN b24c2c8556b7f670adb65e5b997299fe78197081
Project Contract 318 PASS
Godot Tests 293 PASS
```

### Cycle 3 — selection request·bag·discovery·commit

```text
RED ed185a446431b0bdb0486a5e7f9a40616ae5b907
Project Contract 323 PASS
Godot Tests 298 FAIL · selection production files absent

GREEN 11aacc3a885a826a9edc1994050b00961a44427a
Project Contract 329 PASS
Godot Tests 304 PASS
28 cases · 7629 assertions · 0 failures
```

### Cycle 4 — checked-in catalog and selection→session transaction

```text
RED 2501750105ecd930467b93968fd43d086102dca4
Project Contract 333 PASS
Godot Tests 308 FAIL · RunSessionStartService absent

GREEN 5dddbb837027659580a6f4a28e3e39b75ae2bd85
Project Contract 334 PASS
Godot Tests 309 PASS
```

### Adversarial regression cycle

RED에서 실제 P1 두 건을 재현했다.

- `F100`: RunSessionFactory가 `FUEL_MAX=100` 대신 65를 max로 전달.
- `F101`: service가 발급하지 않은 forged/mutated receipt와 duplicate request ID를 방어하지 못함.

```text
RED 0ce02c4701484acf38a448b6e1b811c64b4ad649
Project Contract 337 PASS
Godot Tests 312 FAIL
31 cases · 2 failed · 7681 assertions

GREEN fab692dd96bdffbc89e757a06672a9cbe82fa187
Project Contract 340 PASS
Godot Tests 315 PASS
31 cases · 7681 assertions · 0 failures
```

수정:

- RunSessionFactory는 `RunBalance.FUEL_MAX/FUEL_START`를 직접 재사용.
- MapSelectionService는 request ID 단일 사용, issued object identity, immutable snapshot을 검증한 receipt만 한 번 commit.
- MapDiscoveryState는 replay/manual/restart가 이미 발견된 맵에만 적용되도록 defense-in-depth 추가.

## 적대적 검토 Findings

| Finding | 등급 | 판정 | 처리 |
|---|---|---|---|
| F100 fuel max authority drift | P1 MUST_FIX | FIXED | RunBalance constants 재사용 + regression test |
| F101 forged/mutated receipt commit | P1 MUST_FIX | FIXED | issued receipt registry·snapshot·duplicate request gate |
| F102 selection 후 session 실패 시 발견 오염 | P1 | PREVENTED | session 성공 뒤 commit, failing factory integration test |
| F103 fallback/duplicate catalog count inflation | P1 | PREVENTED | strict all-or-nothing catalog + signature uniqueness |
| F104 restart mutable state leakage | P1 | PREVENTED | fresh service graph·identity·generation assertions |
| F105 raw seed player exposure | P1 | PREVENTED | public DTO/request/receipt에서 seed 제외 |
| F106 in-memory discovery persistence | P2 FOLLOWUP | ACCEPTED_BOUNDARY | Profile writer는 VS03-04 소유, 이 package는 domain state만 제공 |
| F107 replay exclusions limited to immediate recent map | TEST_VALUE | ACCEPTED | target3에서 모든 후보 starvation을 피하는 최소 정책; human/product validation 후 조정 |

남은 P0/P1 구현 결함: `0`.

## 변경 파일 소유권

허용된 제품 변경:

```text
data/maps/map_catalog_vs03.json
game/map/**
game/run/run_id_factory.gd
game/run/run_identity.gd
game/run/run_session.gd
game/run/run_session_factory.gd
game/run/run_session_start_service.gd
```

테스트:

```text
tests/map/**
tests/run/test_run_identity.gd
tests/run/test_run_session_factory.gd
tests/integration/test_three_map_discovery_flow.gd
tests/integration/test_map_run_session_flow.gd
tests/support/map_fixture.gd
tests/support/failing_run_session_factory.gd
tests/run_tests.gd
```

불변:

```text
project.godot
product Scene/UI/assets
existing run balance values
Profile/save/records/rewards
onboarding
target100
UGC/online
```

## 검증 한계

이번 증거는 headless domain·data·integration 증거다.

```yaml
product_scene_runtime: NOT_RUN
android_device: NOT_RUN
human_5_plus: NOT_RUN
compact_token_visual_readability: NOT_RUN
soak_10_minute: NOT_RUN
economy_simulation: NOT_RUN
target100: NOT_RUN
F58: NOT_MET
online_backend: NOT_RUN
```

## 병합 Gate

- latest main 대비 behind 0
- exact-head Project Contract PASS
- exact-head Godot Tests PASS
- changed-file ownership PASS
- unresolved review threads 0
- REQUEST_CHANGES 0
- correct Sheet `APPROVED_PENDING_MERGE · SX-AUD-010` readback
- wrong `19Ff...` Sheet untouched

병합·Sheet closure 뒤에만 `VS03-03 MERGED_AND_VERIFIED · SYNCED`와 `VS03-R1_ONLY`를 확정한다.
