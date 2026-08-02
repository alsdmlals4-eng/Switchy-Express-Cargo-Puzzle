# Switchy Express Current Vertical Slice Master Plan

```yaml
status: CURRENT · PLANNING_ONLY · CODEX_NOT_READY
supersedes_current_status_of: docs/superpowers/plans/2026-08-01-switchy-express-vertical-slice.md
historical_foundation_preserved: true
baseline_synchronized_main: 867563bb7bb69cfbb7343ef734585dd034ad7a64
current_audit: SX-AUD-004
current_catch_up: SX-DEC-016 + SX-OPS-001
next_batch: GMB-001 · SX-DEC-017 · 0/10
```

> 2026-08-01 계획은 VS-01·VS-02 상세 구현 이력과 TDD 증거를 보존하는 `HISTORICAL_FOUNDATION`이다. 현재 planning status·Decision Queue·VS-03 package 순서는 이 문서와 `CODEX_GOAL_VS_03.md`가 우선한다.

## 목표

실제 첫 run에서 LOAD·compact token·분기·LIFO·Combo를 이해하고, 일반 무한 운행에서 점수·연료·BOOST 위험을 관리한 뒤 결과·기록·재시작까지 연결되는 Android 가로형 Vertical Slice를 만든다.

## 현재 검증된 기반

- Godot 4.7.1 project·headless runner
- 15×10 connected RailGraph·no dead ends
- 2/3-state RailSwitch·straight-first·preview parity·target lock
- continuous train movement·bounded history
- capacity 8 CargoStack·LOAD contract·BOOST priority
- station 6·pickup minimum 4/type·bounded deterministic placement
- LIFO matching group unload·DeliveryLoop runtime respawn recovery
- `9 cases / 6915 assertions / 0 failures`

제품 구현 baseline: `4e435a1a6d10ab146197671049da80709fd18c1f`.

## 승인됐지만 미구현인 기획

### SX-DEC-014

- Combo = one station arrival matching unload-group size
- max_combo = run maximum group
- speed_bonus separate

### SX-DEC-015

- cargo 1 = compact wagon token 1
- front→rear = stack bottom→top
- rear = next LIFO item
- 8-token chain 2.18 cells·trailing footprint <=3 `TEST_VALUE`

### SX-DEC-016

- real first-run contextual onboarding
- `LOAD → token → switch → mixed-stack LIFO → Combo → low-fuel BOOST`
- first LOAD/switch safe pause only
- fuel 0.5×·escalation pause·120s·3s restore `TEST_VALUE`
- UI/animation non-authoritative
- assisted first run separated from standard balance evidence

## 현재 catch-up 완료 순서

```text
1. canonical planning PR exact-head 검증
2. GitHub main·PR·Issue·Goal·Plan·Gate·Skill·Registry·Adapter 전수 대조
3. correct Sheet ID/title와 12 tabs 전수 대조
4. P0/P1 open finding 0·review thread 0·checks success
5. canonical merge with expected head SHA
6. SX-DEC-016·EV-USER-004·SX-OPS-001·EV-USER-005를 merge commit으로 Sheet 기록
7. Sheet 12-tab readback PASS
8. Sync Closure PR checks + merge
9. GMB-001 0/10 시작
```

## VS-03A · Run economy

- RunBalance·RunState·RunController
- time speed/fuel
- cargo slowdown·BOOST cost
- unload group reward·Combo/max_combo/speed_bonus
- no-input finite survival
- fuel-zero single game-over

## VS-03B · Product play surface

- RailBoardView·SwitchView
- compact token ViewModel·fractional path follow·compressed footprint
- HUD·Combo/speed bonus feedback
- result·restart·best score/time/max_combo
- save schema/fallback
- Android safe area·48dp·Reduced Motion·mute·haptic-off

## VS-03C · First-session contextual onboarding

책임 계획: `docs/superpowers/plans/2026-08-02-first-session-contextual-onboarding.md`.

- normalized events·OnboardingState
- FirstRunAssistPolicy
- first LOAD/switch safe pause
- real mixed-stack LIFO and Combo proof
- skip·timeout·resume
- OnboardingPreferences
- overlay·Help·telemetry

## VS-04 · Evidence

- bounded telemetry
- 10-minute soak
- Android export/device performance
- representative captures
- 5+ first-experience users
- assisted/standard run analysis separation
- final adversarial review
- PASS / REVISE / PIVOT / STOP

## Grill Me Batch 운영

책임 정본: `기획서/50_제작_검증/GRILL_ME_BATCH_MERGE_PROTOCOL.md`.

- `SX-DEC-016`까지 current catch-up.
- `GMB-001`은 `SX-DEC-017`부터 10건.
- 각 승인 후 batch branch/draft PR·Sheet `APPROVED_PENDING_BATCH_MERGE`.
- 10번째 승인 후 Freeze·pre-merge adversarial audit.
- canonical merge·Sheet 12-tab readback·Sync Closure까지 batch CLOSED 아님.

## 다음 Decision

`SX-DEC-017` — 연료 0 결과 화면에서 어떤 실패 원인·다음 행동을 가장 먼저 보여줄지.

상태: `NEXT_GRILL_ME · GMB-001 SLOT 1`, 현재 catch-up closure 전에는 질문하지 않는다.

## READY_FOR_BUILD

- [ ] current catch-up canonical merge·Sheet closure
- [ ] GMB-001과 남은 필수 Decision 완료
- [ ] Issue #6·Goal·Plan·canon·Sheet 책임 일치
- [ ] exact code/API review
- [ ] implementation test/rollback contract 확정
- [ ] `CODEX_GOAL_VS_03.md`를 `READY_FOR_BUILD`로 승격

현재 제품 구현을 시작하지 않는다.
