# Codex Goal — VS-03 생존 경제·제품 플레이 화면

Status: `PLANNING_DRAFT · CODEX_NOT_READY`
GitHub Issue: `#6`
Parent Epic: `#3`
Blocked by implementation: `#5 · COMPLETED`
Blocked by planning: `G3P_TOTAL_PLANNING_AND_REVIEW_COMPLETE`
Baseline main: `474bef445c2cf5e501bd7478e26a5b8d0dfe26f1`
Plan: `docs/superpowers/plans/2026-08-01-switchy-express-vertical-slice.md` Task 6~7

> 이 문서는 현재 구현 명령이 아니다. 전체 기획 Coverage·적대적 검토·필수 Grill Me Decision·GitHub/Sheet 동기화가 닫힌 뒤 `READY_FOR_BUILD`로 승격한다.

## 플레이어에게 보여야 할 결과

한 세션에서 다음이 실제로 연결된다.

```text
자동 운행
→ LOAD 선택 적재
→ 분기 판단
→ LIFO 배송
→ 하역 그룹 Combo·점수·연료 보상
→ 시간·화물·BOOST의 속도/연료 압박
→ 연료 0
→ 결과·기록
→ 즉시 재시작
```

## 승인 Decision

- `SX-DEC-002`
- `SX-DEC-003`
- `SX-DEC-009`
- `SX-DEC-010`
- `SX-DEC-011`
- `SX-DEC-012`
- `SX-DEC-013`
- `SX-DEC-014`

상세 수치는 `CORE_SYSTEMS.md`의 `TEST_VALUE`를 사용하며 사용자 확정 밸런스로 취급하지 않는다.

## Combo 계약 — SX-DEC-014

- `combo_count`는 한 번의 역 도착에서 연속 하역된 동일 `cargo_type` 개수다.
- `max_combo`는 한 판의 최대 `combo_count`다.
- 배송 사이에 유지되는 Combo streak state는 없다.
- 빠른 배송 보너스는 별도 `speed_bonus`이며 Combo와 독립이다.
- 빈 역·타입 불일치는 Combo·점수·연료 보상 0이다.
- HUD는 성공 하역 시 `COMBO ×N`, 상단에는 run 최대 Combo, 결과에는 `MAX COMBO`를 표시한다.

## 보호 범위

- RailGraph·RailSwitch 공개 동작
- 직진 우선과 preview parity
- segment target lock
- 최대 8개 화차·capacity 8
- LOAD/BOOST 동시 요청 시 BOOST 우선
- 색상+모양 타입
- LIFO 동일 타입 연속 그룹
- 최소 화물·금지 칸·deferred recovery
- deterministic seed 의미
- 제품 규칙·저장 호환성
- UI 모션 비권위 계약

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

## 패키지 B — VS-03B 플레이 화면·결과·기록

### 목표

가로형 Android 기준의 실제 플레이 Scene에서 핵심 상태와 선택 결과를 읽고 한 세션을 끝까지 재생할 수 있다.

### 예정 파일

```text
game/play/play_scene.tscn
game/play/play_scene.gd
game/rail/rail_board_view.gd
game/rail/switch_view.gd
game/ui/game_hud.tscn
game/ui/game_hud.gd
game/ui/result_panel.tscn
game/ui/result_panel.gd
game/save/record_store.gd
tests/ui/test_switch_view_model.gd
tests/ui/test_hud_state.gd
tests/save/test_record_store.gd
```

### 필수 계약

- 상단: Score, Fuel, Speed, Run Max Combo, Survival Time, Pause
- 중앙: 실제 graph와 같은 선로, 활성 경로 굵기+발광+화살표
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

## Issue #7 책임 경계

Issue #7은 다음을 구현·검증한다.

- telemetry event log
- 기록 지속성·손상 fallback의 통합 검증
- 10분 soak
- Android export·실기 성능
- 실제 캡처
- 첫 경험 사용자 5명+
- 최종 P0/P1 적대적 검토
- `PASS / REVISE / PIVOT / STOP`

`RecordStore`의 최초 구현은 VS-03B가 소유한다.

## 아직 닫히지 않은 기획 Gate

- CargoStack 수량과 화차의 제품 표현 관계
- 첫 세션에서 분기·LOAD·LIFO를 가르치는 순서
- 실패 결과에서 강조할 원인·학습·재도전 정보
- 실제 맵에 필요한 최소 시각 밀도와 카메라 정책
- 사운드·진동의 실제 제품 테스트

이 중 프로젝트 방향을 다르게 만드는 항목만 Grill Me로 확정한다. 기술·시험 수치는 GPT 권장안으로 작성한다.

## READY_FOR_BUILD 조건

- [x] Post-VS02 GitHub·Sheet `SYNCED`
- [ ] 전체 기획 Coverage 감사 완료
- [ ] MUST_FIX 0 또는 승인 보류
- [ ] 필수 Grill Me Decision 완료
- [ ] Issue #6·Plan·본책 책임 일치
- [ ] 실제 main·Branch·exact file/API 재검수
- [ ] 테스트·수동 검증·롤백 확정
- [ ] `Status: READY_FOR_BUILD`로 정본 승격

현재는 구현을 시작하지 않는다.
