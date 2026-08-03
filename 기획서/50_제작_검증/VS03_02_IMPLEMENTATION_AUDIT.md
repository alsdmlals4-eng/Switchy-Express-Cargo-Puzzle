# VS03-02 Compact Footprint Implementation Audit

```yaml
audit_id: SX-AUD-008
evidence_id: EV-VS03-02-001
decision: SX-DEC-015
implementation_pr: 41
implementation_merge: cfe6d5ca0c76942720c5c12ad5dc59aaa651b915
state: PASS · MERGED_AND_VERIFIED · SHEET_READBACK_PASS · SYNCED · CLOSED
next_authority: VS03-03_ONLY
player_rule_change: NONE
```

## 1. 범위

VS03-02는 다음 도메인 계약만 구현했다.

```text
CargoStack 0~8
→ CompactWagonTokenState 0~8
→ front-to-rear = stack bottom-to-top
→ rear = LIFO top
→ route-history 기반 TrainFootprint
→ optional DeliveryLoop occupancy provider
→ compact spawn/respawn exclusion
```

제품 Scene·HUD·카메라·자산·Profile·맵 세션·난이도 교정·온보딩은 포함하지 않았다.

## 2. 변경 파일

생성:

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
tests/run_tests.gd
```

`TrainController`는 VS03-01의 `route_history_cells()`와 `sample_trailing_position()` seam이 충분했으므로 수정하지 않았다. 기존 5인자 `DeliveryLoop.configure` 호출도 그대로 통과해 null provider fallback을 증명한다.

## 3. 구현 결과

### CompactWagonTokenState

- CargoStack size `0..8`을 compact token count `0..8`로 1:1 투영한다.
- front-to-rear 순서는 stack bottom-to-top과 같다.
- rear token은 항상 stack top이다.
- changed snapshot마다 revision이 정확히 1회 증가한다.
- unchanged synchronization은 revision을 증가시키지 않는다.

### TrainFootprint

- token 거리: `0.22 + index × 0.28` cell.
- capacity 8 최후미 token 거리: `2.18` cell.
- 위치는 route-history sampler를 사용해 직선·곡선·선택된 switch 경로를 따른다.
- occupied rail cells는 locomotive-first·unique·front-to-rear이다.
- capacity 8 trailing occupied cells는 `<= 3`이다.
- token이 다음 뒤쪽 segment에 일부라도 걸치면 해당 cell을 보수적으로 예약한다.

### DeliveryLoop integration

- `configure(..., occupancy_provider = null)` optional seam을 제공한다.
- provider가 없으면 기존 `train.train_cells()`를 그대로 사용한다.
- provider가 있으면 compact `occupied_cells()`를 CargoSpawner에 전달한다.
- 기존 forward two-cell exclusion은 유지한다.
- pickup·unload로 CargoStack이 변경될 때 compact state를 정확히 1회 동기화한다.
- runtime respawn은 compact occupied cells와 forward cells를 피한다.

## 4. TDD 증거

```text
Token state RED    4cb918abe46211af568e4d97c93979b54c4f2fd4
Token state GREEN  4df47c3ce7c804d6bd167db236566179ec59a813

Footprint RED      ba8424f2c6d1d9803f35f70bc88673c7ca0fa06f
Footprint GREEN    66c2cf0359a64fc0272a65e519620686ed19ca88

Provider RED       57597a06c83701a7be03392d87b89546150630e0
Provider GREEN     6f896c538dbecc01e6ffd641dcef75f702154e9c

Under-reservation RED   f32fb65d7351a621b2a3e721cbd0c9060a135652
Conservative GREEN      c215bfc263f08796c24476de622dd1ed684f17b8
```

각 RED는 새 계약만 실패했고 기존 suite는 통과했다.

## 5. 적대적 검토

발견된 중요 문제:

- 최초 occupancy 계산은 nearest-cell rounding을 사용해 token이 걸친 farther trailing segment를 과소 예약할 수 있었다.
- 실패 테스트로 재현한 뒤 conservative `ceil` reservation으로 수정했다.

최종 판정:

```text
Critical 0
Important 0
P0/P1 0
```

## 6. Exact-head Gate

```text
exact head 5477ecd8d7c14c73a62a3c666d15aa4e826a92ab
Project Contract 281 PASS
Godot Tests 261 PASS
19 cases · 7499 assertions · 0 failures
changed files 7 · package-owned only
behind main 0
unresolved review threads 0
REQUEST_CHANGES 0
canonical squash merge cfe6d5ca0c76942720c5c12ad5dc59aaa651b915
```

## 7. Sheet 증거

올바른 Sheet에 `SX-AUD-008 / EV-VS03-02-001 / cfe6d5ca...`를 기록하고 12개 탭을 재조회했다.

확인 사항:

- VS03-02 domain implementation과 VS03-03 next authority가 일치한다.
- Decision merge `9b63421...`, DoR `82fd3eeb...`, VS03-01 `43972d3d...`/`9360eff0...`, SX-AUD-007 `a9368617...`/`0aaa9005...`가 보존됐다.
- `30_세계_서사`는 변경되지 않았다.
- wrong `19Ff...` Sheet는 수정하지 않았다.

Closure PR merge SHA는 올바른 Sheet에 후속 기록하고 최종 12-tab readback으로 봉인한다.

## 8. 미검증 경계

```yaml
product_scene_runtime: NOT_RUN
compact_token_visual_assets: NOT_STARTED
android_device: NOT_RUN
compact_token_human_readability: NOT_RUN
F92: EVIDENCE_GAP
soak_10_minute: NOT_RUN
localization_accessibility_runtime: NOT_RUN
economy_simulation: NOT_RUN
target100: NOT_RUN
F58: NOT_MET
online_ugc_backend: NOT_RUN
```

Headless geometry PASS는 제품 화면 가독성·Android·사람 검증 완료가 아니다.

## 9. 다음 권위

현재 구현 권위는 오직 `VS03-03_ONLY`다.

```text
exactly 3 validated official maps
+ MapDefinition/Catalog
+ fully configured RunSessionFactory
+ same-map restart/fresh mutable services
+ automatic undiscovered-first selection
+ discovered-map reselection domain
```

VS03-R1·VS03-05A·Profile·result/browser·onboarding·target100·online UGC는 계속 차단한다.
