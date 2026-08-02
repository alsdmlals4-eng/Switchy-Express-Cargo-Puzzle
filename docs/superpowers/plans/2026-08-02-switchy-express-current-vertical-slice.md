# Switchy Express Current Vertical Slice Master Plan

```yaml
status: CURRENT · IMPLEMENTATION_IN_PROGRESS
planning: COMPLETE · SX-AUD-005
gmb001: CLOSED · SX-DEC-017~026
dor_merge: 82fd3eeb1915e6ceedb2f5330b27e903064d6eb5
vs03_01_audit: SX-AUD-006 · PASS
vs03_01_evidence: EV-VS03-01-001
vs03_01_merge: 43972d3d23e931af3dbc81ab9b1c7d942fffb201
implementation_state: VS03_01_MERGED
codex_state: READY_FOR_BUILD
current_authorized_package: VS03-02
```

> 총기획과 Definition of Ready가 완료됐고 VS03-01 authoritative run core가 병합됐다. 현재 실행 권위는 `VS03-02`에만 적용한다. package 현재 상태는 `기획서/50_제작_검증/VS03_PACKAGE_STATUS.md`가 소유한다.

## 목표

실제 첫 run에서 LOAD·compact token·분기·LIFO·Combo를 이해하고 일반 무한 운행에서 점수·연료·BOOST 위험을 관리한다. 결과에서 실패를 학습하고 같은 맵 또는 새 공식 맵으로 재도전하며 로컬 기록·꾸미기 진행까지 연결되는 Android 가로형 Vertical Slice를 만든다.

## 검증된 기반

### VS-01/02

- Godot 4.7.1 project·custom headless runner
- 15×10 connected RailGraph·no dead ends
- 2/3-state RailSwitch·straight-first·preview parity·target lock
- continuous train movement
- capacity 8 CargoStack·LOAD contract·BOOST priority
- station 6·pickup minimum 4/type·bounded deterministic placement
- LIFO matching-group unload·runtime respawn recovery

### VS03-01

- pure RunBalance
- authoritative RunState·fuel-zero one-shot
- immutable RunSummary·bounded metrics
- boundary-sliced RunController
- time speed/fuel·cargo slowdown·BOOST cost
- unload-group Combo·score·fuel reward
- deterministic DifficultyDirector·forecast·event·band
- difficulty signal과 RunState 시간 일치
- TrainController next-boundary/history/fractional path read seam
- actual DeliveryLoop·CargoStack·Station integration

Evidence:

```text
PR #37 merge 43972d3d23e931af3dbc81ab9b1c7d942fffb201
exact head af2577eeb8a1c4891a2ca322aa70c4066335cd0e
Project Contract 227 PASS
Godot Tests 214 PASS
16 cases · 7110 assertions · 0 failures
```

## 승인된 Planning Set

`SX-DEC-014~026`은 planning approved·canonical synced다.

```text
기획서/00_프로젝트_허브/GMB-001_CANONICAL_DECISIONS.md
기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md
기획서/50_제작_검증/VS03_DEFINITION_OF_READY_AUDIT.md
기획서/50_제작_검증/VS03_PACKAGE_STATUS.md
docs/superpowers/specs/2026-08-02-vs03-execution-architecture-design.md
docs/superpowers/plans/2026-08-02-vs03-build-segmentation.md
```

- Decision 문서는 승인 의미를 소유한다.
- execution architecture/build plan은 API·파일 책임·테스트·순서를 소유한다.
- package status registry는 현재 승격 상태를 소유한다.
- 충돌 시 승인 의미를 바꾸지 않는 범위에서 위 책임 순서를 따른다.

## Definition of Ready Result

`SX-AUD-005`에서 실제 코드와 대조해 다음을 고정했다.

- API/file collision inventory
- custom test runner normalization
- compact footprint occupancy seam
- composition root·RunSession ownership
- authoritative frame/tie order
- MapDefinition reconstruction fields·fully configured session
- Profile single-writer transaction
- package dependency/order and hotspot ownership
- rollback·evidence locations
- target3/target100 scope separation

Known open P0/P1 implementation-planning finding after fixes: `0`.

`F58`은 Production target100 증거 전까지 `NOT_MET`다.

## Scope Staging

### VS-03 local

- survival economy·Combo·difficulty authority — VS03-01 완료
- compact tokens·compressed footprint — VS03-02 현재
- exact same-map restart·minimum 3 official maps·selection — VS03-03
- official global/per-map records·cosmetic/unlock/reward Profile — VS03-04
- PREP camera·FULL_MAP_READY·HUD·result·browser — VS03-05
- contextual first-run onboarding — VS03-06
- bounded telemetry·end-to-end evidence — VS03-07

### Production/online

- official target 100+ unique layouts and scale browser
- full UGC editor/publication/backend/server validation
- online sharing·moderation·privacy
- UGC records/community journal·anti-abuse

Local mocks do not prove online readiness.

## Canonical Build Sequence

```text
VS03-01 · MERGED_AND_VERIFIED
→ VS03-02 · READY_FOR_BUILD
→ VS03-03 · BLOCKED_BY_VS03_02
→ VS03-04 · BLOCKED_BY_VS03_03
→ VS03-05 · BLOCKED_BY_VS03_04
→ VS03-06 · BLOCKED_BY_VS03_05
→ VS03-07 · BLOCKED_BY_VS03_06
```

Packages do not run in parallel when they share hotspot files. Each starts from the previous merged and synchronized main.

## Current Build Package — VS03-02

Responsibilities:

```text
CompactWagonTokenState
TrainFootprint
fractional compact path geometry
occupied rail cells
DeliveryLoop optional occupancy provider
compact pickup spawn/respawn exclusion integration
```

Required behavior:

- token count equals CargoStack size for 0..8
- front→rear equals stack bottom→top
- rear equals stack top
- no path cutting/order swap on straight/curve/switch
- 8-token trailing footprint `<=3` cells TEST_VALUE
- legacy `train.train_cells()` fallback preserved only without provider
- compact provider excludes occupied and existing forward forbidden cells
- one domain event updates stack/token/footprint once
- VS03-01 behavior and all 16 existing suites remain green

Excluded:

- product token View/final art
- map/session/restart/selection
- Profile/save
- product Scene/HUD/result/camera/browser
- onboarding
- target100/UGC/online

## Protected Runtime Contracts

- custom runner: `tests/run_tests.gd`, suite `func run()` only
- existing RailGraph/RailSwitch/CargoStack/DeliveryLoop semantics preserved
- UI/camera/animation/onboarding non-authoritative
- one fully configured RunSession per attempt when introduced
- Profile one writer when introduced
- selected/restarted map never silently changes
- no runtime/Android/human/online PASS without execution

## Acceptance and Evidence

Each package requires exact-head:

```text
behind 0
Project Contract success
Godot Tests success
review threads 0
REQUEST_CHANGES 0
owned-file scope respected
package acceptance tests registered
rollback and NOT_RUN evidence documented
```

Issue #7 retains Android, 10-minute soak, localization/accessibility runtime, economy simulation, representative captures, and 5명+ human evidence.

## Current Action

```text
VS03-01 GitHub/Sheet Sync Closure
→ latest main
→ VS03-02 dedicated branch
→ actual custom-runner TDD red→green
→ exact-head package Gate
→ merge before VS03-03 promotion
```

`VS03-01_HEADLESS_PASSED`는 product Scene runtime·Android·human 완료가 아니다.
