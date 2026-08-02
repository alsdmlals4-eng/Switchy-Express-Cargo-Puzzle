# Codex Goal — VS-03 생존 경제·제품 플레이 화면·첫 세션 온보딩

Status: `PLANNING_DRAFT · CODEX_NOT_READY`
GitHub Issue: `#6`
Parent Epic: `#3`
Blocked by implementation: `#5 · COMPLETED`
Blocked by planning: `G3P_TOTAL_PLANNING_AND_REVIEW_COMPLETE · GMB-001`
Latest synchronized planning main: `3cd13ff375a597d4eba9035af5b05e6186fb4853`
Current Master Plan: `docs/superpowers/plans/2026-08-02-switchy-express-current-vertical-slice.md`
Historical foundation: `docs/superpowers/plans/2026-08-01-switchy-express-vertical-slice.md`
Compact token spec: `docs/superpowers/specs/2026-08-02-compact-cargo-wagon-tokens-design.md`
Onboarding spec: `docs/superpowers/specs/2026-08-02-first-session-contextual-onboarding-design.md`
Onboarding plan: `docs/superpowers/plans/2026-08-02-first-session-contextual-onboarding.md`

> 이 문서는 현재 구현 명령이 아니다. GMB-001과 남은 총기획 Gate가 닫힌 뒤 `READY_FOR_BUILD`로 승격한다.

## 플레이어에게 보여야 할 결과

```text
실제 첫 무한 run 시작
→ 첫 LOAD 상황 학습
→ compact wagon token 뒤쪽 추가
→ 첫 분기 preview와 실제 경로 학습
→ rear token부터 mixed-stack LIFO 배송
→ 하역 그룹 Combo·점수·연료 보상
→ 일반 run으로 연속 전환
→ 시간·화물·BOOST의 속도/연료 압박
→ 연료 0
→ 결과·기록
→ 즉시 재시작
```

## 승인·동기화 상태

- `SX-DEC-002`
- `SX-DEC-003`
- `SX-DEC-009`
- `SX-DEC-010`
- `SX-DEC-011`
- `SX-DEC-012`
- `SX-DEC-013`
- `SX-DEC-014` · GitHub/Sheet `SYNCED`
- `SX-DEC-015` · GitHub/Sheet `SYNCED`
- `SX-DEC-016` · PR #27 / `3cd13ff375a597d4eba9035af5b05e6186fb4853` · Sheet 12탭 `PASS · SYNCED`
- `SX-OPS-001` · ACTIVE
- `GMB-001` · `SX-DEC-017`부터 `0/10`

상세 속도·연료·보상·token 기하·onboarding assist 수치는 `TEST_VALUE`이며 사용자 확정 영구 밸런스로 취급하지 않는다.

## Combo 계약 — SX-DEC-014

- `combo_count`는 한 번의 역 도착에서 연속 하역된 동일 `cargo_type` 개수다.
- `max_combo`는 한 판의 최대 `combo_count`다.
- 배송 사이에 유지되는 Combo streak state는 없다.
- 빠른 배송 보너스는 별도 `speed_bonus`이며 Combo와 독립이다.
- 빈 역·타입 불일치는 Combo·점수·연료 보상 0이다.
- HUD는 성공 하역 시 `COMBO ×N`, 상단에는 run 최대 Combo, 결과에는 `MAX COMBO`를 표시한다.

## compact wagon token 계약 — SX-DEC-015

- `compact_wagon_token_count == CargoStack.size()`이고 범위는 0~8이다.
- 0 cargo에서는 기관차만 표시한다.
- front→rear token order는 stack bottom→top이다.
- rear token type은 `CargoStack.top()`과 같다.
- 적재는 rear에 token 1개를 추가하고 유효 하역은 rear matching group을 제거한다.
- token은 cargo_type 색상+shape를 표시한다.
- 권장 시험값: body 0.22칸, spacing 0.28칸, 8 token 2.18칸, trailing footprint 최대 3칸.
- spawn exclusion은 full-size wagon count가 아니라 compressed token footprint를 사용한다.
- CargoStack·token count/order·footprint는 같은 도메인 단계에서 갱신한다.
- animation completion은 cargo·token·occupancy 권위가 아니다.

## first-session contextual onboarding 계약 — SX-DEC-016

- 별도 튜토리얼 맵·가짜 보상·튜토리얼 전용 공식 없음.
- 실제 첫 run 순서: `LOAD → token → switch → mixed-stack LIFO → Combo → low-fuel BOOST`.
- 첫 LOAD와 첫 switch에서만 safe full pause를 요청한다.
- first-run assist 권장 시험값:
  - fuel drain multiplier 0.5
  - difficulty escalation paused
  - max duration 120 seconds
  - restore duration 3 seconds
  - BOOST hint fuel ratio <= 0.35
- core complete·skip·timeout 중 먼저 발생한 시점에 assist를 종료한다.
- OnboardingState는 실제 domain event를 소비하고 gameplay 결과를 직접 변경하지 않는다.
- overlay·animation completion은 step complete·unpause·reward 권위가 아니다.
- Help는 다시 볼 수 있지만 first-run assist를 재활성화하지 않는다.
- `assisted_first_run`을 기록해 일반 balance evidence와 분리한다.

## 보호 범위

- RailGraph·RailSwitch 공개 동작
- 직진 우선과 preview parity
- segment target lock
- capacity 8
- LOAD/BOOST 동시 요청 시 BOOST 우선
- 색상+모양 타입
- LIFO 동일 타입 연속 그룹
- 최소 화물·금지 칸·deferred recovery
- deterministic seed 의미
- 제품 규칙·저장 호환성
- UI 모션 비권위 계약
- compact token을 위해 기존 라우팅·CargoStack 의미를 변경하지 않음
- 온보딩을 위해 실제 LIFO·Combo·점수·연료 공식을 변경하지 않음
- assisted first run 수치를 일반 balance 합격 증거로 사용하지 않음

## 패키지 A — VS-03A 생존 경제 도메인

### 목표

헤드리스 환경에서 속도·연료·하역 그룹 보상·게임오버가 기존 DeliveryLoop와 연결된다.

### 예정 파일

```text
game/run/run_balance.gd
game/run/run_state.gd
game/run/run_controller.gd
tests/run/test_run_balance.gd
tests/run/test_run_controller.gd
tests/run/test_no_input_survival.gd
```

### 권장 인터페이스

```gdscript
RunBalance.speed(elapsed_seconds: float, cargo_count: int, boosting: bool) -> float
RunBalance.fuel_drain_per_second(elapsed_seconds: float, boosting: bool) -> float
RunBalance.delivery_reward(
    unload_group_size: int,
    seconds_since_delivery: float,
    cargo_before_delivery: int
) -> Dictionary

RunController.advance_time(delta_seconds: float) -> Array[Dictionary]
signal run_ended(summary: Dictionary)
```

`delivery_reward()` 권장 반환 필드:

```text
combo_count
base_unload_score
speed_bonus_multiplier
heavy_bonus_multiplier
score_delta
fuel_delta
```

### 필수 테스트

- CORE_SYSTEMS의 시험 공식
- cargo 0~8 경계
- BOOST 중 LOAD 비활성
- 화물 감속이 연료 소모를 낮추지 않음
- `combo_count == unload_group_size == try_unload().count`
- 하역 count가 점수·연료·max_combo에 한 번만 반영
- `speed_bonus`가 Combo를 증가·유지·리셋하지 않음
- 빈 역·무입력 이동에 보상 없음
- 입력 0회 180초 이내 fuel 0·score 0
- fuel 0에서 `run_ended` 한 번
- pause·delta 0·큰 delta 경계
- 빠른 반복 이벤트 중복 없음

## 패키지 B — VS-03B 플레이 화면·compact tokens·결과·기록

### 목표

가로형 Android 기준의 실제 플레이 Scene에서 핵심 상태·compact token 적재량·다음 LIFO 대상과 선택 결과를 읽고 한 세션을 끝까지 재생할 수 있다.

### 예정 파일

```text
game/play/play_scene.tscn
game/play/play_scene.gd
game/rail/rail_board_view.gd
game/rail/switch_view.gd
game/train/compact_wagon_token_view.gd
game/train/train_footprint.gd
game/ui/game_hud.tscn
game/ui/game_hud.gd
game/ui/result_panel.tscn
game/ui/result_panel.gd
game/save/record_store.gd
tests/train/test_compact_wagon_tokens.gd
tests/train/test_train_footprint.gd
tests/ui/test_switch_view_model.gd
tests/ui/test_hud_state.gd
tests/save/test_record_store.gd
```

파일명은 implementation planning에서 기존 구조와 충돌 여부를 재확인한 뒤 조정 가능하다.

### 필수 계약

- 상단: Score, Fuel, Speed, Run Max Combo, Survival Time, Pause
- 중앙: 실제 graph와 같은 선로, 활성 경로 굵기+발광+화살표
- 0~8 compact wagon tokens
- rear token == CargoStack top == HUD first unload item
- 8 token chain 2.18칸, trailing footprint 최대 3칸 `TEST_VALUE`
- fractional path history, corner cutting 0, ordering swap 0
- compressed footprint 안 pickup spawn 0
- 성공 하역: `COMBO ×N` 즉시 피드백
- speed bonus: Combo와 분리된 피드백
- 하단: LOAD, 다음 하역 순서, BOOST
- 색상+별/마름모/삼각형
- 48dp 이상 터치 영역
- Android safe area
- 결과: 점수·생존·최대 Combo·신기록·재시작
- 기록: score/time/max_combo와 schema version
- 저장 실패가 결과를 파괴하지 않음
- 모션 중단·instant complete·Reduced Motion에서도 도메인 결과 동일
- mute·haptic-off에서도 핵심 정보 보존

### compact token 필수 테스트

- token count와 CargoStack size 0~8 parity
- front→rear == stack bottom→top
- load adds one rear token
- unload removes exact rear matching group
- 8 tokens fit within configured chain length and trailing cells
- curve sampling preserves order
- token state changes and spawn footprint update in one domain step
- 0/1/4/8·curve representative captures

## 패키지 C — VS-03C 실제 첫 run 상황형 온보딩

### 목표

별도 튜토리얼 스테이지 없이 실제 첫 run에서 LOAD·분기·LIFO·Combo·BOOST의 의미를 행동 직후 이해시키고, 같은 run을 일반 무한 플레이로 이어간다.

### 예정 파일

```text
game/onboarding/onboarding_event.gd
game/onboarding/onboarding_state.gd
game/onboarding/first_run_assist_policy.gd
game/onboarding/onboarding_preferences.gd
game/ui/onboarding/onboarding_view_model.gd
game/ui/onboarding/onboarding_overlay.tscn
game/ui/onboarding/onboarding_overlay.gd
game/ui/help/help_panel.tscn
game/ui/help/help_panel.gd
tests/onboarding/test_onboarding_state.gd
tests/onboarding/test_first_run_assist_policy.gd
tests/onboarding/test_onboarding_preferences.gd
tests/onboarding/test_onboarding_view_model.gd
tests/integration/test_onboarding_delivery_flow.gd
tests/integration/test_onboarding_skip_resume.gd
tests/ui/test_onboarding_overlay_state.gd
```

### 필수 계약

- 실제 domain events만 step transition을 완료
- out-of-order event 무시·step regression 금지
- first LOAD·first switch만 safe pause
- UI hide·animation complete로 unpause 금지
- real flow: load A → load B → unload B → A remains → load A → unload A×2 → Combo×2
- assist timeout·skip·resume idempotent
- completion preference와 best record 분리
- assist 종료 후 normal balance 복원
- Help는 assist 미활성
- Reduced Motion·mute·haptic-off 정보 보존
- telemetry에 `assisted_first_run`

## Issue #7 책임 경계

Issue #7은 다음을 구현·검증한다.

- telemetry event log
- token_count·rear_token_type·trailing_footprint·onboarding fields
- 기록·onboarding preference 지속성·손상 fallback 통합 검증
- 10분 soak
- Android export·실기 성능
- 실제 캡처
- 첫 경험 사용자 5명+
- assisted first run과 일반 balance 분석 분리
- 최종 P0/P1 적대적 검토
- `PASS / REVISE / PIVOT / STOP`

최초 RecordStore·OnboardingPreferences 구현은 VS-03B/C가 소유한다.

## 아직 닫히지 않은 기획 Gate

- `SX-DEC-017` 결과 화면에서 강조할 실패 원인·다음 행동 정보
- 실제 맵에 필요한 최소 카메라 정책
- 사운드·진동의 실제 제품 테스트
- GMB-001의 나머지 중요 Decision

이 중 프로젝트 방향을 다르게 만드는 항목만 Grill Me로 확정한다. 기술·시험 수치는 GPT 권장안으로 작성한다.

## Grill Me batch 경계 — SX-OPS-001

- `CATCH-UP-001 · SX-DEC-014~016`: CLOSED.
- `GMB-001`: `SX-DEC-017`부터 10건, 현재 0/10.
- batch 중 승인안은 `APPROVED_PENDING_BATCH_MERGE`이며 main `SYNCED`로 표시하지 않는다.
- 10번째 승인 후 main·PR·Issue·Goal·Plan·Gate·Registry·Sheet 12탭 pre-merge adversarial audit를 수행한다.
- exact-head checks 성공, P0/P1 0, review thread 0일 때만 병합한다.
- Sheet canonical merge commit·12탭 readback·Sync Closure PR까지 완료해야 batch CLOSED다.

## READY_FOR_BUILD 조건

- [x] Post-VS02 GitHub·Sheet `SYNCED`
- [x] `SX-DEC-014`, `EV-USER-002`, `SX-AUD-004` GitHub·Sheet `SYNCED`
- [x] `SX-DEC-015`, `EV-USER-003` GitHub·Sheet `SYNCED`
- [x] `SX-DEC-016`, `EV-USER-004`, `SX-OPS-001`, `EV-USER-005` GitHub·Sheet `SYNCED`
- [ ] GMB-001과 전체 필수 기획 Decision 완료
- [ ] MUST_FIX 0 또는 승인 보류
- [ ] Issue #6·Plan·본책 책임 일치
- [ ] 실제 main·Branch·exact file/API 재검수
- [ ] 테스트·수동 검증·롤백 확정
- [ ] `Status: READY_FOR_BUILD`로 정본 승격

현재는 구현을 시작하지 않는다.
