# Active Context

## 현재 상태

```yaml
project: Switchy Express: Cargo Puzzle
stage: VERTICAL_SLICE_IN_PROGRESS · VS03_01_HEADLESS_PASSED
work_mode: IMPLEMENTATION_IN_PROGRESS · SEQUENTIAL_PACKAGES
gmb001_decision_merge: 9b63421a5ab4d57adbfcf69d2b6e1bf8e3d17496
gmb001: CLOSED · SX-DEC-017~026
dor_audit: SX-AUD-005 · PASS · SYNCED
dor_merge: 82fd3eeb1915e6ceedb2f5330b27e903064d6eb5
vs03_01_audit: SX-AUD-006 · PASS
vs03_01_evidence: EV-VS03-01-001
vs03_01_merge: 43972d3d23e931af3dbc81ab9b1c7d942fffb201
product_implementation: VS03_01_MERGED
codex_state: READY_FOR_BUILD
current_authorized_package: VS03-02
sheet_state: VS03_01_SYNC_CLOSURE_REQUIRED
```

## 완료된 운영·기획

- VS-01/02 철도·열차·화물·LIFO 기반 구현과 기존 headless 증거 완료.
- `SX-DEC-014~026`, `SX-OPS-001` canonical sync 완료.
- GMB-001 PR #29·closure PR #34·올바른 Sheet closure 완료.
- `SX-AUD-005 / EV-USER-016` DoR·PR #35/#36·Sheet canonical readback 완료.
- VS03-01 시작 전 추가 P0/P1 제품 기획 Decision 필요 여부를 재검토했고 차단 항목 `0`으로 판정했다.
- 올바른 Sheet는 `1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo`다.
- 잘못된 `19Ff...` Sheet는 변경하지 않는다.

## VS03-01 구현 결과

구현 merge:

```text
PR #37
exact head af2577eeb8a1c4891a2ca322aa70c4066335cd0e
merge 43972d3d23e931af3dbc81ab9b1c7d942fffb201
```

구현된 기반:

- pure RunBalance
- authoritative RunState READY/ACTIVE/PAUSED/ENDED
- immutable RunSummary
- bounded RunMetricsAccumulator
- boundary-sliced RunController
- time speed/fuel pressure·cargo slowdown·BOOST cost
- unload-group Combo·score·fuel reward
- fuel-zero one-shot·post-end mutation guard
- deterministic DifficultyForecast/Event/Director
- CALM/BUSY/INTENSE pressure band
- difficulty commit signal과 RunState 시간 일치
- read-only TrainController next-boundary/history/fractional path seam
- actual DeliveryLoop·CargoStack·Station integration

검증:

```text
Project Contract 227 PASS
Godot Tests 214 PASS
16 cases · 7110 assertions · 0 failures
existing 9 suites PASS
behind main 0
review threads 0
REQUEST_CHANGES 0
adversarial P0/P1 0
```

상세 증거:

```text
기획서/50_제작_검증/VS03_01_IMPLEMENTATION_AUDIT.md
기획서/50_제작_검증/VS03_PACKAGE_STATUS.md
```

## 현재 실행 권위 — VS03-02

목표:

```text
compact cargo token state
→ fractional path 기반 compressed TrainFootprint
→ DeliveryLoop optional occupancy provider
→ pickup spawn/respawn exclusion integration
```

생성 권위:

```text
game/train/compact_wagon_token_state.gd
game/train/train_footprint.gd
tests/train/test_compact_wagon_tokens.gd
tests/train/test_train_footprint.gd
tests/integration/test_compact_footprint_respawn.gd
```

제한 수정:

```text
game/delivery/delivery_loop.gd
game/train/train_controller.gd
tests/integration/test_delivery_loop.gd
tests/run_tests.gd
```

VS03-02에서 금지:

- map/session/restart/selection은 VS03-03
- Profile/records/rewards/unlocks는 VS03-04
- Scene/HUD/result/camera/browser는 VS03-05
- onboarding은 VS03-06
- target100/UGC/online은 Production

## Canonical package order

```text
VS03-01 · MERGED_AND_VERIFIED
→ VS03-02 · READY_FOR_BUILD
→ VS03-03 · BLOCKED_BY_VS03_02
→ VS03-04 · BLOCKED_BY_VS03_03
→ VS03-05 · BLOCKED_BY_VS03_04
→ VS03-06 · BLOCKED_BY_VS03_05
→ VS03-07 · BLOCKED_BY_VS03_06
```

상태 권위는 `VS03_PACKAGE_STATUS.md`가 소유한다. 상세 계획은 package 목표·파일 소유권·수용 기준을 제공한다.

## 현재 미구현·미검증

```yaml
compact_tokens_footprint: NOT_STARTED
official_map_target_3: NOT_RUN
official_map_target_100: NOT_RUN
F58: NOT_MET
profile_records_rewards: NOT_STARTED
product_scene_runtime: NOT_RUN
android_localization_accessibility_human: NOT_RUN
ugc_editor_backend_moderation_privacy_community: NOT_STARTED_OR_NOT_RUN
```

## 다음 실행 순서

```text
VS03-01 GitHub/Sheet Sync Closure
→ latest main 확인
→ VS03-02 전용 branch
→ actual runner 기반 TDD red→green
→ package-owned files only
→ Project Contract + Godot + review Gate
→ merge 후 VS03-03 승격 검토
```

## 금지

- VS03-03~07 병렬 시작
- unsupported test runner API 복사
- full-cell `train_cells()`를 compact production footprint로 계속 사용
- token View가 authoritative occupancy를 소유
- selected/restarted map silent substitution
- target100을 VS-03 완료 조건으로 끌어오기
- local mock으로 Android/human/online readiness 주장
- headless PASS를 product runtime 완료로 표현

## 다음 작업

Sync Closure와 올바른 Sheet 반영을 마친 뒤 `VS03-02`를 별도 TDD package로 시작한다. 새 Decision은 구현이 material player-facing choice를 드러내거나 승인 의미 변경을 요구할 때만 추가한다.
