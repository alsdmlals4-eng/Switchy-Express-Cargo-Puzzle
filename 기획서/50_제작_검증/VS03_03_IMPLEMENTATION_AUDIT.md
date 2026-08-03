# SX-AUD-010 · VS03-03 Implementation Audit

```yaml
audit_id: SX-AUD-010
status: SYNC_CLOSURE_REVIEW
package: VS03-03
baseline_main: 38878c7ef124f37c36992dbdb9b62d1f88382dc1
implementation_pr: 46
implementation_exact_head: 2bc4d0fcbb310790e6a2e5fd444688cb20f02162
implementation_merge: 53aa4eb5025b8c44db9bdb8e877a93e0266e6765
evidence_id: EV-VS03-03-001
sheet_state: SYNCED_TO_MAIN · CLOSURE_PENDING
sheet_12_tab_readback: PASS
planning_conflict: NONE
user_decision_required: NO
product_scene_runtime: NOT_RUN
android_human_evidence: NOT_RUN
target100: NOT_RUN
F58: NOT_MET
next_authority_after_closure: VS03-R1_ONLY
```

## 목적

승인된 `SX-DEC-023/024`의 Vertical Slice 범위를 실제 Godot domain·data로 구현하고, 구현·GitHub·올바른 Google Sheet를 같은 `SX-AUD-010 / EV-VS03-03-001`로 동기화한다.

```text
3 distinct validated non-fallback official maps
→ immutable semantic map identity and strict reconstruction
→ fully configured fresh RunSession
→ exact same-map restart with fresh identities and mutable services
→ automatic undiscovered-first assignment
→ discovered-map semantic reselection domain
```

Profile 저장, 제품 Scene·HUD·브라우저, 난이도 R1 보정, 온보딩, target100, UGC·온라인은 범위 밖이다.

## 구현 결과

### 공식 맵·재구축

- `data/maps/map_catalog_vs03.json`: seed 1·2·5의 target3 공식 항목.
- `MapDefinition`: stable ID·revision·generator/ruleset version·start/incoming cell·재구축 signature.
- `MapBuildPipeline`: RailGraph·station·initial pickup을 deterministic하게 재구축.
- fallback, incomplete definition, signature mismatch를 명시적으로 거부.
- `MapCatalog`: all-or-nothing load, duplicate identity/layout/content 거부, unavailable revision silent substitution 0.

### RunSession·same-map restart

- `RunIdentity`: map identity와 run/retry/transaction identity 분리.
- `RunSessionFactory`: graph·station·pickup·CargoStack·input·train·compact token·footprint·DeliveryLoop·RunController·DifficultyDirector를 매 시도 신규 구성.
- exact map ID/revision/content signature 유지.
- run ID·transaction namespace·mutable service object·generation은 신규.
- `RunBalance.FUEL_MAX=100`, `FUEL_START=65` 권위 재사용.
- stale generation callback 거부 seam 제공.

### 맵 배정·발견

- semantic modes: `AUTO_NEW_RUN`, `SELECT_DISCOVERED`, `RESTART`.
- target3 첫 3회 automatic start는 고유한 미발견 맵을 사용.
- 전체 발견 뒤 replay bag으로 전환하고 대안이 있으면 즉시 반복 방지.
- manual·restart는 automatic bag을 소비하지 않음.
- selection만으로 발견을 기록하지 않으며 session construction 성공 뒤 receipt commit.
- duplicate request ID, forged/mutated/non-issued receipt, duplicate commit 거부.
- request·receipt·public map/run identity에서 raw seed 비노출.

## TDD 증거

| Cycle | RED | GREEN | 검증 |
|---|---|---|---|
| Map/catalog | `d976d89e...` | `212475087...` | Contract310 · Godot285 · 22 cases/7530 |
| Fresh session/restart | `c9fc94de...` | `b24c2c85...` | Contract318 · Godot293 |
| Selection/discovery | `ed185a44...` | `11aacc3a...` | Contract329 · Godot304 · 28 cases/7629 |
| Selection→session transaction | `25017501...` | `5dddbb83...` | Contract334 · Godot309 |
| Adversarial regression | `0ce02c47...` | `fab692dd...` | Contract340 · Godot315 · 31 cases/7681 |

RED는 각 cycle에서 신규 production seam 부재 또는 재현된 결함으로 실패했고, GREEN은 같은 테스트를 포함한 전체 runner에서 통과했다.

최종 implementation exact head `2bc4d0fcbb310790e6a2e5fd444688cb20f02162`:

```text
Project Contract run 342 · PASS
Godot Tests run 317 · PASS
31 cases · 7681 assertions · 0 failures
behind main 0
changed files 33 · package-owned only
unresolved review threads 0
REQUEST_CHANGES 0
```

## 적대적 검토 Findings

| Finding | 등급 | 최종 판정 | 처리 |
|---|---|---|---|
| F100 fuel max authority drift | P1 MUST_FIX | FIXED | RunBalance constants 재사용 + regression test |
| F101 forged/mutated receipt commit | P1 MUST_FIX | FIXED | issued object·snapshot·duplicate request gate |
| F102 session 실패 후 발견 오염 | P1 | PREVENTED | session 성공 뒤 receipt commit |
| F103 fallback/duplicate catalog inflation | P1 | PREVENTED | strict catalog·signature uniqueness |
| F104 restart mutable-state leakage | P1 | PREVENTED | fresh service graph·identity·generation assertions |
| F105 raw seed player exposure | P1 | PREVENTED | public DTO/request/receipt에서 seed 제외 |
| F106 discovery persistence | P2 FOLLOWUP | ACCEPTED_BOUNDARY | Profile single writer는 VS03-04 소유 |
| F107 replay immediate-repeat policy | TEST_VALUE | ACCEPTED | target3 최소 정책, product/human 검증 후 조정 |

남은 P0/P1 구현 결함: `0`.

## 변경 파일 소유권

제품 domain/data:

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
existing balance values
Profile/save/records/rewards
onboarding
target100
UGC/online
wrong 19Ff... Sheet
```

## Google Sheets 동기화

correct Sheet: `1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo`.

merge SHA `53aa4eb5025b8c44db9bdb8e877a93e0266e6765` 기록 뒤 12개 탭 readback:

```text
00_프로젝트_허브 · PASS
01_작업순서 · PASS
02_현재_확정결정 · PASS
03_근거_라이브러리 · PASS
04_누락_충돌_감사 · PASS
05_GDD_요약 · PASS
06_시각_작업면 · PASS
10_경험 · PASS
20_시스템_콘텐츠 · PASS
30_세계_서사 · PASS
40_표현 · PASS
50_제작_검증 · PASS
```

- `SX-DEC-023/024` 구현 상태와 main SHA 반영.
- `EV-VS03-03-001` ADOPT.
- `SX-AUD-010`은 `SYNCED_TO_MAIN · CLOSURE_PENDING`.
- history 행과 미검증 경계 보존.
- wrong `19Ff...` Sheet 미수정.

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
online_backend: NOT_RUN
```

이 closure가 exact-head Gate를 통과해 main에 병합되고 correct Sheet에 closure SHA가 반영된 뒤에만 `CLOSED`와 `VS03-R1_ONLY`를 최종 확정한다.
