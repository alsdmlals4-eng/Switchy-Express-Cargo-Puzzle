# Codex Goal — VS-03 Local Survival Vertical Slice

```yaml
status: READY_FOR_BUILD
issue: 6
parent_epic: 3
gmb001: CLOSED · SX-DEC-017~026 · DECISION_MERGE_9b63421a
dor_audit: SX-AUD-005 · PASS · SYNCED
dor_merge: 82fd3eeb1915e6ceedb2f5330b27e903064d6eb5
vs03_01_audit: SX-AUD-006 · PASS
vs03_01_evidence: EV-VS03-01-001
vs03_01_merge: 43972d3d23e931af3dbc81ab9b1c7d942fffb201
execution_authority: VS03-02_ONLY
online_ugc: OUT_OF_SCOPE_FOR_VS03
product_implementation: VS03_01_MERGED · VS03_02_NOT_STARTED
```

> 이 문서는 현재 `VS03-02`에 한해 실행 가능한 Codex Goal이다. VS03-03~07을 병렬로 시작하지 않는다. VS03-01의 run lifecycle·difficulty 의미는 병합된 기반으로 보호한다.

## 반드시 먼저 읽기

```text
기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md
기획서/00_프로젝트_허브/GMB-001_CANONICAL_DECISIONS.md
기획서/50_제작_검증/VS03_PACKAGE_STATUS.md
기획서/50_제작_검증/VS03_01_IMPLEMENTATION_AUDIT.md
기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md
기획서/50_제작_검증/VS03_DEFINITION_OF_READY_AUDIT.md
docs/superpowers/specs/2026-08-02-vs03-execution-architecture-design.md
docs/superpowers/plans/2026-08-02-vs03-build-segmentation.md
docs/superpowers/plans/2026-08-02-switchy-express-current-vertical-slice.md
```

`VS03_PACKAGE_STATUS.md`가 현재 package 상태를 소유한다. 상세 build plan의 오래된 `Status:` 표기와 충돌하면 상태 레지스트리를 우선하고, 목표·파일 소유권·수용 기준은 상세 plan을 유지한다.

## 전체 목표 결과

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
VS03-01 run lifecycle/economy/difficulty · MERGED_AND_VERIFIED
→ VS03-02 compact footprint/DeliveryLoop seam · READY_FOR_BUILD
→ VS03-03 target3 maps/session/restart/selection · BLOCKED
→ VS03-04 Profile transaction/records/cosmetics/unlocks/rewards · BLOCKED
→ VS03-05 product scene/camera/HUD/result/browsers · BLOCKED
→ VS03-06 contextual onboarding · BLOCKED
→ VS03-07 integration/evidence handoff · BLOCKED
```

각 package는 이전 package merge와 정본 동기화 뒤에만 시작한다.

# 현재 실행 권위 — VS03-02 ONLY

## 목표

화물 1개당 작은 token형 화차 1개 의미를 domain state로 표현하고, VS03-01의 fractional path read seam을 사용해 8개 token의 trailing footprint가 최대 약 3칸이 되도록 압축한다. `DeliveryLoop`에는 optional occupancy provider를 주입해 spawn/respawn 금지 영역이 full-size 화차가 아니라 실제 compact footprint를 따르게 한다.

## 생성 파일

```text
game/train/compact_wagon_token_state.gd
game/train/train_footprint.gd

tests/train/test_compact_wagon_tokens.gd
tests/train/test_train_footprint.gd
tests/integration/test_compact_footprint_respawn.gd
```

## 제한적 수정 파일

```text
game/delivery/delivery_loop.gd
game/train/train_controller.gd
tests/integration/test_delivery_loop.gd
tests/run_tests.gd
```

필요성이 테스트로 증명되지 않은 다른 파일은 수정하지 않는다.

## 보호되는 VS03-01 API

다음은 이미 병합된 기반이다.

```text
RunBalance
RunState
RunSummary
RunController
RunMetricsAccumulator
DifficultyForecast / DifficultyEvent / DifficultyDirector
TrainController.seconds_to_next_cell()
TrainController.route_history_cells()
TrainController.sample_trailing_position()
```

VS03-02는 위 API의 승인 의미를 임의 변경하지 않는다. 변경이 필요하면 기존 16-suite 회귀와 material player-facing 영향 여부를 먼저 적대적으로 검토한다.

## Compact Token 의미

- 적재 화물 1개 = 작은 token형 화차 1개
- 화물 0개 = 기관차만
- token 수 = `CargoStack.size()`
- 앞→뒤 token 순서 = stack bottom→top
- 맨 뒤 token = 다음 LIFO unload 대상인 stack top
- pickup/unload 1 event는 stack·token state·footprint를 각각 정확히 1회 갱신
- token state는 표현 데이터와 occupancy 입력을 제공하지만 CargoStack 권위를 대체하지 않음

## TEST_VALUE geometry

- 최대 token: 8
- 8-token 시각 chain 길이: 약 `2.18` cells
- trailing occupied footprint: 최대 `3` cells
- token 간격은 fractional path distance로 계산
- straight/curve/switch에서 path를 자르거나 token 순서가 바뀌면 실패
- 최종 간격·크기는 Android/HUMAN 증거 전 `TEST_VALUE`

## TrainFootprint 계약

`TrainFootprint`는 다음을 읽는다.

```text
TrainController current/target/progress
TrainController fractional path sample
CompactWagonTokenState token distances
```

제공:

- locomotive와 compact token의 fractional positions
- 현재 occupied rail cells의 bounded set
- 필요 시 forward exclusion과 합성 가능한 read-only 결과

금지:

- TrainFootprint가 CargoStack을 수정
- TrainFootprint가 이동·분기 권위를 소유
- View node 위치를 authoritative occupancy로 사용
- full-size wagon cell 목록을 production compact occupancy로 위장

## DeliveryLoop API rule

`DeliveryLoop.configure()`에 optional occupancy provider를 추가한다.

```text
provider 있음 → provider의 occupied cells 사용
provider 없음 → legacy train.train_cells() fallback
```

요구:

- 기존 호출 signature와 기존 9-suite 의미를 깨지 않음
- legacy tests는 provider 없이 계속 PASS
- product composition은 후속 Scene package에서 `TrainFootprint`를 주입 가능
- pickup spawn/respawn은 occupied cells + 기존 forward exclusion을 모두 피함
- provider failure를 silent empty occupancy로 처리하지 않음

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

## TDD 순서

1. latest main과 VS03-01 merge SHA 확인.
2. 기존 16 cases / 7110 assertions baseline 재확인.
3. token count/order/rear tests를 production code 전 추가 — RED.
4. 최소 `CompactWagonTokenState` 구현 — GREEN.
5. straight fractional geometry tests — RED→GREEN.
6. curve/switch path continuity·order tests — RED→GREEN.
7. occupied-cell bound와 8-token `<=3` tests — RED→GREEN.
8. DeliveryLoop provider compatibility tests — RED→GREEN.
9. compact footprint respawn exclusion integration — RED→GREEN.
10. 같은 pickup/unload event의 중복 state update 0 검증.
11. full regression·적대적 review·exact-head Gate.

## Acceptance Tests

- token count equals CargoStack size for 0..8
- front-to-rear equals stack bottom-to-top
- rear token equals stack top
- no token path cutting or order swap on straight/curve/switch
- 8-token trailing footprint `<=3` cells
- legacy `train_cells()` fallback remains green only when provider absent
- provider path excludes every compact occupied cell
- existing forward route exclusion remains active
- deferred respawn never appears inside occupied/forward forbidden cells
- same domain event updates stack/token/footprint once
- existing 16 suites remain green
- VS03-01 run/difficulty behavior is unchanged

## Do Not Implement in VS03-02

- product token View or final art asset
- map definition/catalog/session/restart/selection
- Profile/save/records/currency/unlocks/rewards
- product Scene/HUD/result/camera/browser
- onboarding
- target100 generator work
- UGC/online work

Forward-compatible read APIs는 허용하지만 later package의 placeholder 구현은 금지한다.

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
only VS03-02 owned files
rollback and NOT_RUN documented
```

## Rollback

- occupancy provider는 optional이므로 PR 전체 revert 시 legacy `train.train_cells()` 동작으로 복귀한다.
- save·Scene·Resource·asset·catalog·Profile 변경이 없어 데이터 migration rollback은 없다.
- provider를 주입한 후속 package는 이 package merge를 선행 조건으로 유지한다.

## Evidence Boundary

이 package는 다음을 완료했다고 주장할 수 없다.

- final token art/readability
- product Scene runtime
- target3/target100 map completion
- Profile/record/reward completion
- Android/localization/accessibility/human PASS
- online/UGC readiness

## Start State

```text
VS03-01 PR #37 merged 43972d3d23e931af3dbc81ab9b1c7d942fffb201
+ SX-AUD-006 / EV-VS03-01-001
+ 16 cases / 7110 assertions / 0 failures
+ GitHub/Sheet Sync Closure
= Codex READY_FOR_BUILD · VS03-02
```

별도 branch에서 테스트를 먼저 실패시키고 최소 구현으로 통과시킨다.
