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

- `SX-DEC-014` Combo: GitHub/Sheet `SYNCED`
- `SX-DEC-015` compact wagon token: GitHub/Sheet `SYNCED`
- `SX-DEC-016` contextual onboarding: PR #27 / `3cd13ff375a597d4eba9035af5b05e6186fb4853`, Sheet 12탭 `PASS · SYNCED`
- `SX-OPS-001`: ACTIVE
- `GMB-001`: `SX-DEC-017`부터 `0/10`

상세 속도·연료·보상·token 기하·onboarding assist 수치는 `TEST_VALUE`이며 사용자 확정 영구 밸런스로 취급하지 않는다.

## 핵심 계약

### Combo — SX-DEC-014

- `combo_count`는 한 번의 역 도착에서 연속 하역된 동일 `cargo_type` 개수다.
- `max_combo`는 한 판의 최대 `combo_count`다.
- 빠른 배송은 별도 `speed_bonus`이며 Combo와 독립이다.
- 빈 역·타입 불일치는 Combo·점수·연료 보상 0이다.

### compact wagon tokens — SX-DEC-015

- `token_count == CargoStack.size()`이고 범위는 0~8이다.
- front→rear는 stack bottom→top이며 rear는 `CargoStack.top()`이다.
- 권장 시험값: body 0.22칸, spacing 0.28칸, 8 token 2.18칸, trailing footprint 최대 3칸.
- spawn exclusion은 compressed footprint를 사용한다.
- animation completion은 cargo·token·occupancy 권위가 아니다.

### contextual onboarding — SX-DEC-016

- 별도 튜토리얼 맵·가짜 보상·튜토리얼 전용 공식 없음.
- 실제 첫 run: `LOAD → token → switch → mixed-stack LIFO → Combo → low-fuel BOOST`.
- 첫 LOAD와 첫 switch에서만 safe full pause.
- assist 권장 시험값: fuel 0.5×, escalation pause, max 120s, restore 3s, BOOST hint fuel≤35%.
- OnboardingState는 실제 domain event를 소비하고 gameplay 결과를 직접 변경하지 않는다.
- overlay·animation completion은 step complete·unpause·reward 권위가 아니다.
- Help는 first-run assist를 재활성화하지 않는다.
- `assisted_first_run`을 일반 balance evidence와 분리한다.

## 보호 범위

- RailGraph·RailSwitch 공개 동작
- 직진 우선·preview parity·segment target lock
- capacity 8·LOAD/BOOST 우선 계약
- 색상+모양 타입·LIFO 연속 그룹
- 최소 화물·금지 칸·deferred recovery
- deterministic seed 의미
- 제품 규칙·저장 호환성
- UI·tutorial·animation 비권위
- 온보딩을 위해 실제 LIFO·Combo·점수·연료 공식을 변경하지 않음
- assisted first run을 일반 balance 합격 증거로 사용하지 않음

## VS-03A — 생존 경제 도메인

예정 책임:

```text
RunBalance · RunState · RunController
speed/fuel over time
cargo slowdown · BOOST cost
unload reward · Combo/max_combo/speed_bonus
no-input finite survival
fuel-zero single game-over
```

필수 테스트:

- cargo 0~8 경계
- BOOST 중 LOAD 비활성
- 화물 감속이 연료 소모를 낮추지 않음
- `combo_count == unload_group_size == try_unload().count`
- 보상·max_combo 한 번만 반영
- `speed_bonus`가 Combo state를 변경하지 않음
- 입력 0회 180초 이내 fuel 0·score 0
- fuel 0에서 `run_ended` 한 번

## VS-03B — compact token 제품 화면·결과·기록

예정 책임:

```text
RailBoardView · SwitchView
compact token ViewModel · TrainFootprint
HUD · result · restart
best score/time/max_combo · save fallback
```

필수 계약:

- 상단 Score/Fuel/Speed/Run Max Combo/Time/Pause
- 하단 LOAD/Unload Order/BOOST
- rear token == CargoStack top == HUD first item
- 8 token chain 2.18칸·trailing≤3 `TEST_VALUE`
- curve ordering swap·corner cutting·pickup overlap 0
- Combo와 speed bonus 피드백 분리
- 48dp·safe area·Reduced Motion·mute·haptic-off

## VS-03C — 실제 첫 run 상황형 온보딩

예정 책임:

```text
OnboardingEvent · OnboardingState
FirstRunAssistPolicy · OnboardingPreferences
OnboardingViewModel · Overlay · Help
integration and telemetry tests
```

필수 계약:

- 실제 domain events만 step transition 완료
- first LOAD·first switch만 safe pause
- UI hide·animation complete로 unpause 금지
- real flow: load A → load B → unload B → A remains → load A → unload A×2 → Combo×2
- timeout·skip·resume idempotent
- assist 종료 후 normal balance 복원
- Help는 assist 미활성
- `assisted_first_run` telemetry

## Issue #7 책임 경계

- telemetry event log
- records/onboarding preference 지속성·손상 fallback 통합 검증
- 10분 soak
- Android export·실기 성능
- 실제 캡처
- 첫 경험 사용자 5명+
- assisted first run과 일반 balance 분석 분리
- 최종 P0/P1 적대적 검토
- `PASS / REVISE / PIVOT / STOP`

## 아직 닫히지 않은 기획 Gate

- `SX-DEC-017` 결과 화면의 실패 원인·다음 행동 우선순위 — `GMB-001 SLOT 1`
- GMB-001의 나머지 중요 Decision
- 실제 카메라·사운드·진동 제품 시험

## Grill Me batch 경계 — SX-OPS-001

- `CATCH-UP-001 · SX-DEC-014~016`: CLOSED.
- `GMB-001`: `SX-DEC-017`부터 10건, 현재 0/10.
- batch 중 승인안은 `APPROVED_PENDING_BATCH_MERGE`이며 main `SYNCED`로 표시하지 않는다.
- 10번째 승인 후 main·PR·Issue·Goal·Plan·Gate·Registry·Sheet 12탭 pre-merge adversarial audit를 수행한다.
- exact-head checks 성공, P0/P1 0, review thread 0일 때만 병합한다.
- Sheet canonical merge commit·12탭 readback·Sync Closure까지 완료해야 batch CLOSED다.

## READY_FOR_BUILD 조건

- [x] Post-VS02 GitHub·Sheet `SYNCED`
- [x] `SX-DEC-014/015/016`, `EV-USER-002~004`, `SX-OPS-001`, `EV-USER-005` GitHub·Sheet `SYNCED`
- [ ] GMB-001과 전체 필수 기획 Decision 완료
- [ ] MUST_FIX 0 또는 승인 보류
- [ ] Issue #6·Plan·본책 책임 일치
- [ ] 실제 main·Branch·exact file/API 재검수
- [ ] 테스트·수동 검증·롤백 확정
- [ ] `Status: READY_FOR_BUILD`로 정본 승격

현재는 구현을 시작하지 않는다.
