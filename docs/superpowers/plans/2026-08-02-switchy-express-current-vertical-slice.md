# Switchy Express Current Vertical Slice Master Plan

```yaml
status: CURRENT · READY_FOR_BUILD_PENDING_CANONICAL_SYNC
product_baseline: 4e435a1a6d10ab146197671049da80709fd18c1f
gmb001_decision_merge: 9b63421a5ab4d57adbfcf69d2b6e1bf8e3d17496
gmb001: CLOSED · SX-DEC-017~026
dor_audit: SX-AUD-005
dor_evidence: EV-USER-016
implementation_state: NOT_STARTED
codex_state: READY_FOR_BUILD_PENDING_CANONICAL_SYNC
first_authorized_package: VS03-01
```

> GMB-001 기획 sync와 G3P Definition of Ready 적대적 검토가 완료됐다. 이 branch의 DoR 정본이 merge되고 올바른 Sheet readback이 끝난 뒤 `VS03-01` 구현만 시작할 수 있다.

## 목표

실제 첫 run에서 LOAD·compact token·분기·LIFO·Combo를 이해하고, 일반 무한 운행에서 점수·연료·BOOST 위험을 관리한다. 결과에서 실패를 학습하고 같은 맵 또는 새 공식 맵으로 재도전하며, 로컬 기록·꾸미기 진행까지 연결되는 Android 가로형 Vertical Slice를 만든다.

## 검증된 기반

- Godot 4.7.1 project·headless runner
- 15×10 connected RailGraph·no dead ends
- 2/3-state RailSwitch·straight-first·preview parity·target lock
- continuous train movement
- capacity 8 CargoStack·LOAD contract·BOOST priority
- station 6·pickup minimum 4/type·bounded deterministic placement
- LIFO matching-group unload·runtime respawn recovery
- historical evidence: `9 cases / 6915 assertions / 0 failures`

## 승인된 Planning Set

`SX-DEC-014~026`은 planning approved·canonical synced다. 상세 의미는 다음 정본을 따른다.

```text
기획서/00_프로젝트_허브/GMB-001_CANONICAL_DECISIONS.md
기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md
```

실행 구조는 다음이 우선한다.

```text
기획서/50_제작_검증/VS03_DEFINITION_OF_READY_AUDIT.md
docs/superpowers/specs/2026-08-02-vs03-execution-architecture-design.md
docs/superpowers/plans/2026-08-02-vs03-build-segmentation.md
```

Decision별 오래된 예시 코드·경로·테스트 명령이 실제 저장소와 충돌하면 위 DoR 문서를 적용한다. Decision 의미는 변경하지 않는다.

## Definition of Ready Result

`SX-AUD-005`에서 다음을 실제 코드와 대조하고 고정했다.

- API/file collision inventory
- custom test runner normalization
- compact footprint occupancy seam
- composition root·RunSession ownership
- authoritative frame/tie order
- MapDefinition reconstruction fields·fully configured session
- Profile single-writer transaction
- package dependency/order and hotspot ownership
- rollback strategy
- exact automated/deferred evidence locations
- target3/target100 scope separation

Known open P0/P1 implementation-planning finding after fixes: `0`.

`F58`은 Production target100 증거 전까지 `NOT_MET`다.

## Scope Staging

### VS-03 local

- survival economy·Combo·difficulty authority
- compact tokens·compressed footprint
- exact same-map restart
- minimum 3 validated official maps
- undiscovered-first selection and discovered-map reselection
- local official global/per-map records
- representative cosmetic/unlock/reward Profile flow
- PREP camera·FULL_MAP_READY·HUD·result
- contextual first-run onboarding
- bounded local telemetry and end-to-end automated evidence

### Production/online

- official target 100+ unique layouts and scale browser
- full UGC editor/publication/backend/server validation
- online sharing·moderation·privacy
- UGC records/community journal·anti-abuse

Local mocks do not prove online readiness.

## Canonical Build Sequence

```text
VS03-01 · authoritative run lifecycle/economy/difficulty
→ VS03-02 · compact footprint + DeliveryLoop occupancy seam
→ VS03-03 · target3 map identity/session/restart/selection
→ VS03-04 · Profile transactions/records/cosmetics/unlocks/rewards
→ VS03-05 · product scene/camera/HUD/result/local browsers
→ VS03-06 · contextual onboarding
→ VS03-07 · end-to-end integration/evidence handoff
```

Packages must not run in parallel when they share hotspot files. Each starts from the previous merged main.

## Initial Build Package — VS03-01

Responsibilities:

```text
RunBalance
RunState
RunSummary
RunController
RunMetricsAccumulator
DifficultyForecast/Event/Director
minimal TestCase helpers
read-only TrainController boundary helpers
```

Required behavior:

- time speed/fuel
- cargo slowdown·BOOST cost
- unload reward·Combo/max_combo/speed_bonus
- boundary-sliced movement and fuel-zero ordering
- no-input finite survival
- fuel-zero end once
- authoritative difficulty schedule/pause/restart
- no UI/Profile/map/catalog/onboarding implementation in this package

## Protected Runtime Contracts

- current custom runner: `tests/run_tests.gd`, suite `func run()` only
- existing RailGraph/RailSwitch/CargoStack/DeliveryLoop meaning preserved
- compact occupancy uses future optional provider; legacy fallback remains
- UI/camera/animation/onboarding non-authoritative
- one fully configured RunSession per attempt
- Profile has one writer when introduced
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
```

VS03-07 creates `기획서/50_제작_검증/VS03_IMPLEMENTATION_AUDIT.md`.

Issue #7 retains Android, 10-minute soak, localization/accessibility runtime, economy simulation, representative captures, and 5명+ human evidence.

## Current Action

```text
merge DoR planning PR
→ synchronize SX-AUD-005 / EV-USER-016 to correct Sheet
→ final readback
→ Codex READY_FOR_BUILD · VS03-01
→ product implementation remains NOT_STARTED until a separate Codex execution starts
```
