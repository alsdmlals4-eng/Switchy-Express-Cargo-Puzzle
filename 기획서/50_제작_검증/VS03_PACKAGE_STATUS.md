# VS-03 Package Status Registry

## 권위

```yaml
status_authority: CURRENT_PACKAGE_STATE_ONLY
implementation_audit: SX-AUD-006
implementation_evidence: EV-VS03-01-001
vs03_01_pr: 37
vs03_01_merge: 43972d3d23e931af3dbc81ab9b1c7d942fffb201
current_authorized_package: VS03-02
```

이 문서는 VS-03 package의 **현재 상태만** 소유한다.

- package별 목표·파일 소유권·TDD 순서·수용 기준은 `docs/superpowers/plans/2026-08-02-vs03-build-segmentation.md`를 따른다.
- 위 상세 계획 안의 오래된 `Status:` 표기가 이 문서와 충돌하면 이 문서를 따른다.
- 승인된 플레이어 의미·Decision은 변경하지 않는다.
- 이전 package merge 전 다음 package를 시작하지 않는다.

## 현재 상태

| Package | 상태 | 권위 증거 | 다음 조건 |
|---|---|---|---|
| VS03-01 | `MERGED_AND_VERIFIED` | PR #37 · merge `43972d3d...` · `SX-AUD-006` | 완료 |
| VS03-02 | `READY_FOR_BUILD · NOT_STARTED` | VS03-01 exact-head Gate PASS | 별도 branch·TDD |
| VS03-03 | `BLOCKED_BY_VS03_02` | — | VS03-02 merge·sync |
| VS03-04 | `BLOCKED_BY_VS03_03` | — | VS03-03 merge·sync |
| VS03-05 | `BLOCKED_BY_VS03_04` | — | VS03-04 merge·sync |
| VS03-06 | `BLOCKED_BY_VS03_05` | — | VS03-05 merge·sync |
| VS03-07 | `BLOCKED_BY_VS03_06` | — | VS03-06 merge·sync |

## VS03-01 완료 증거

```text
exact head af2577eeb8a1c4891a2ca322aa70c4066335cd0e
Project Contract 227 PASS
Godot Tests 214 PASS
16 cases · 7110 assertions · 0 failures
behind main 0
review threads 0
REQUEST_CHANGES 0
package-owned files 18
P0/P1 0
```

검증된 범위:

- authoritative run lifecycle·pause·fuel-zero one-shot
- time speed/fuel pressure·cargo slowdown·BOOST cost
- unload-group Combo·max Combo·speed/heavy bonus 분리
- immutable RunSummary·bounded metrics
- deterministic difficulty forecast/commit/band
- cell event → run clock → difficulty signal → fuel drain/zero 순서
- difficulty signal과 RunState 시간 일치
- TrainController next-boundary/history/fractional path read seam
- 실제 DeliveryLoop·CargoStack·Station 결합

## VS03-02 실행 권위

목표:

```text
compact cargo token state
+ compressed TrainFootprint
+ optional DeliveryLoop occupancy provider
+ spawn/respawn exclusion integration
```

허용 생성:

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

금지:

- map/session/restart/selection
- Profile/save/records/rewards/unlocks
- product Scene/HUD/result/camera/browser
- onboarding
- target100·UGC·online

## 유지되는 미검증 경계

```yaml
product_scene_runtime: NOT_RUN
android_device: NOT_RUN
soak_10_minute: NOT_RUN
localization_accessibility_runtime: NOT_RUN
economy_simulation: NOT_RUN
human_5_plus: NOT_RUN
target100: NOT_RUN
F58: NOT_MET
online_ugc_backend: NOT_RUN
```
