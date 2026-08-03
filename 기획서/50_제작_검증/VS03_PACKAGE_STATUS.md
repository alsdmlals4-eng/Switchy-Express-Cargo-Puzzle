# VS-03 Package Status Registry

## 권위

```yaml
status_authority: CURRENT_PACKAGE_STATE_ONLY
vs03_01_audit: SX-AUD-006 · PASS · SYNCED
vs03_01_evidence: EV-VS03-01-001
vs03_01_merge: 43972d3d23e931af3dbc81ab9b1c7d942fffb201
vs03_02_audit: SX-AUD-008 · PASS · MERGED_AND_VERIFIED · SHEET_READBACK_PASS
vs03_02_evidence: EV-VS03-02-001
vs03_02_merge: cfe6d5ca0c76942720c5c12ad5dc59aaa651b915
vs03_03_audit: SX-AUD-010 · MERGED_AND_VERIFIED · SHEET_READBACK_PASS
vs03_03_evidence: EV-VS03-03-001 · ADOPT
vs03_03_merge: 53aa4eb5025b8c44db9bdb8e877a93e0266e6765
core_fun_audit: SX-AUD-007 · PASS_WITH_FOLLOWUPS · SYNCED
sequencing_evidence: EV-USER-018 · RECOMMENDED_OPTION_C
current_authorized_package: VS03-R1
next_authority_after_merge_sync: VS03-05A
future_order_approved: true
```

이 문서는 VS-03 package의 **현재 상태만** 소유한다.

- package 목표·파일 소유권은 `docs/superpowers/plans/2026-08-02-vs03-build-segmentation.md`와 package별 최신 계획을 따른다.
- 승인된 미래 순서는 `docs/superpowers/plans/2026-08-03-vs03-core-first-resegmentation.md`가 소유한다.
- `VS03-R1`은 `docs/superpowers/plans/2026-08-03-vs03-r1-difficulty-authority-alignment.md`를 따른다.
- `VS03-05A`는 `docs/superpowers/plans/2026-08-03-vs03-05a-minimal-playable-core-surface.md`를 따른다.
- 오래된 status/order가 이 문서와 충돌하면 이 문서가 우선한다.
- 이전 package merge·정본·Sheet 동기화 전 다음 package를 시작하지 않는다.

## 현재 상태

| Package | 상태 | 권위 증거 | 다음 조건 |
|---|---|---|---|
| VS03-01 | `MERGED_AND_VERIFIED · SYNCED` | PR #37/#38 · `SX-AUD-006` | 완료 |
| VS03-02 | `MERGED_AND_VERIFIED · SHEET_SYNCED` | PR #41/#42 · `SX-AUD-008` | 완료 |
| VS03-03 | `MERGED_AND_VERIFIED · SHEET_READBACK_PASS` | PR #46 · `SX-AUD-010 · EV-VS03-03-001` | 완료 |
| VS03-R1 | `READY_FOR_BUILD · CURRENT_AUTHORITY` | `SX-AUD-007-F87 · EV-USER-018` | latest-main TDD implementation |
| VS03-05A | `BLOCKED_BY_VS03_R1` | `EV-USER-018 · OPTION_C` | VS03-R1 merge·sync |
| VS03-04 | `BLOCKED_BY_VS03_05A` | `EV-USER-018 · OPTION_C` | VS03-05A merge·sync |
| VS03-05B | `BLOCKED_BY_VS03_04` | `EV-USER-018 · OPTION_C` | VS03-04 merge·sync |
| VS03-06 | `BLOCKED_BY_VS03_05B` | — | VS03-05B merge·sync |
| VS03-07 | `BLOCKED_BY_VS03_06` | — | VS03-06 merge·sync |

## 승인된 실행 순서

```text
VS03-01 run lifecycle/economy/difficulty · DONE
→ VS03-02 compact token/TrainFootprint/DeliveryLoop occupancy · DONE
→ VS03-03 target3 maps/session/restart/selection · DONE
→ VS03-R1 difficulty authority alignment · CURRENT
→ VS03-05A minimal playable core surface
→ VS03-04 Profile/records/cosmetics/unlocks/rewards
→ VS03-05B result/collection/map browser
→ VS03-06 contextual onboarding
→ VS03-07 end-to-end integration/evidence handoff
```

공통 hotspot package는 병렬 실행하지 않는다.

## VS03-01 완료 증거

```text
PR #37 merge 43972d3d23e931af3dbc81ab9b1c7d942fffb201
PR #38 closure 9360eff0a97f48f2234fcaf35425f80e94fac445
16 cases · 7110 assertions · 0 failures
```

검증 범위:

- authoritative run lifecycle·pause·fuel-zero one-shot
- time speed/fuel pressure·cargo slowdown·BOOST cost
- unload-group Combo·immutable RunSummary
- deterministic difficulty foundation
- TrainController boundary/history/fractional-path read seam
- 실제 DeliveryLoop 결합

## VS03-02 완료 증거

```text
PR #41 exact head 5477ecd8d7c14c73a62a3c666d15aa4e826a92ab
canonical merge cfe6d5ca0c76942720c5c12ad5dc59aaa651b915
Project Contract 281 PASS
Godot Tests 261 PASS
19 cases · 7499 assertions · 0 failures
changed files 7 · package-owned only
behind 0 · thread 0 · REQUEST_CHANGES 0
```

검증 범위:

- CargoStack `0..8` ↔ compact token `0..8`
- front-to-rear=bottom-to-top, rear=LIFO top
- `0.22 + index×0.28`, capacity 8=`2.18` cell
- 직선·곡선·committed switch route-history sampling
- conservative unique occupancy, trailing `<=3`
- optional DeliveryLoop provider와 exact legacy fallback
- pickup/unload 1회 동기화
- compact spawn/respawn exclusion

상세: `기획서/50_제작_검증/VS03_02_IMPLEMENTATION_AUDIT.md`.

## VS03-03 완료 증거

```text
PR #46 exact head 2bc4d0fcbb310790e6a2e5fd444688cb20f02162
canonical merge 53aa4eb5025b8c44db9bdb8e877a93e0266e6765
Project Contract 342 PASS
Godot Tests 317 PASS
31 cases · 7681 assertions · 0 failures
changed files 33 · package-owned only
behind 0 · thread 0 · REQUEST_CHANGES 0
correct Sheet 12-tab readback PASS
```

검증 범위:

- target3 checked-in official catalog, distinct layout signatures, fallback 0
- strict identity/revision/layout/content duplicate rejection
- deterministic graph·station·initial pickup reconstruction
- fully configured fresh RunSession service graph
- exact same-map restart with fresh run/transaction/service identities
- automatic undiscovered-first target3 cycle
- manual/restart auto-bag consumption 0
- selection receipt commit after successful session construction only
- duplicate request·forged/mutated receipt rejection
- failed session construction discovery/bag mutation 0
- raw seed public exposure 0
- approved `FUEL_MAX=100`, `FUEL_START=65` authority preservation

상세: `기획서/50_제작_검증/VS03_03_IMPLEMENTATION_AUDIT.md`.

## VS03-R1 현재 계약

- 현재 권위는 `VS03-R1_ONLY`다.
- `RunBalance`와 `DifficultyDirector` 사이의 난이도 권위·공식 baseline 정합만 수정한다.
- core-fun audit `F87`의 승인된 계획을 따른다.
- VS03-05A 제품 Scene·HUD·카메라·compact token view는 R1 merge·sync 후 시작한다.
- VS03-04 Profile persistence를 앞당기지 않는다.
- 새로운 기획 의미 충돌이 생기면 Grill Me 사용자 승인을 요구한다.
- 상세 수치는 승인된 의미를 보존하는 `TEST_VALUE`로 TDD·simulation evidence와 함께 조정할 수 있다.

## 유지되는 미검증 경계

```yaml
product_scene_runtime: NOT_RUN
compact_token_visual_assets: NOT_STARTED
compact_token_human_readability: NOT_RUN
F92: EVIDENCE_GAP
android_device: NOT_RUN
soak_10_minute: NOT_RUN
localization_accessibility_runtime: NOT_RUN
economy_simulation: NOT_RUN
monocolor_strategy_validation: NOT_RUN
human_5_plus: NOT_RUN
target100: NOT_RUN
F58: NOT_MET
online_ugc_backend: NOT_RUN
```
