# Switchy Express Current Vertical Slice Master Plan

```yaml
status: CURRENT · PLANNING_ONLY · CODEX_NOT_READY
historical_foundation: docs/superpowers/plans/2026-08-01-switchy-express-vertical-slice.md
product_baseline: 4e435a1a6d10ab146197671049da80709fd18c1f
gmb001_baseline_main: 993c3ed1aaee172be52a8a8899685b419f7f6d97
current_audit: GMB-001_PREMERGE_AUDIT.md
current_batch: GMB-001 · SX-DEC-017~026 · 10/10 · FROZEN
implementation_state: NOT_STARTED_FOR_GMB001
```

> 이 문서는 현재 구현 명령이 아니다. PR #29 canonical merge, Sheet closure, Sync Closure, Definition of Ready의 명시적 승격 전에는 Codex가 제품 구현을 시작하지 않는다.

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

상세 정본:

- `기획서/00_프로젝트_허브/GMB-001_CANONICAL_DECISIONS.md`
- `기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md`

```text
SX-DEC-014 Combo
SX-DEC-015 compact wagon tokens
SX-DEC-016 contextual onboarding
SX-DEC-017 result learning
SX-DEC-018 PREP camera/full-map gate
SX-DEC-019 records/cosmetic-only progression
SX-DEC-020 unlock modes
SX-DEC-021 bounded rewards
SX-DEC-022 difficulty communication
SX-DEC-023 same-map restart/official catalog
SX-DEC-024 official map discovery/reselection
SX-DEC-025 official scoped records/user-map publication design
SX-DEC-026 non-economic UGC community design
```

모든 GMB-001 항목은 planning approved이며 runtime·Android·human·online evidence는 `NOT_STARTED / NOT_RUN`이다.

## Scope Staging

### Vertical Slice local scope

- result insight·neutral fallback
- PREP zoom·`FULL_MAP_READY`·active full map
- local standard records
- representative cosmetic registry/collection/equip
- representative unlock modes and atomic transactions
- bounded local reward calculation/Profile grant
- difficulty warning/persistent signal
- exact same-map restart
- minimum 3 validated official maps
- undiscovered-first selection and discovered-map reselection
- official global/per-map local records

### Production/online scope

- official 100+ unique layout completion
- full official browser at catalog scale
- full UGC editor
- account/upload/publication backend
- server validation·immutable revisions
- online sharing·moderation·privacy
- UGC records/community signal event journal·anti-abuse

Production scope is planned now but not a VS implementation requirement. Local mocks do not prove online readiness.

## Package A — VS-03A Run Economy

### Goal

Existing DeliveryLoop와 연결된 deterministic survival economy를 headless로 증명한다.

### Planned modules

```text
game/run/run_balance.gd
game/run/run_state.gd
game/run/run_controller.gd
game/difficulty/difficulty_director.gd
game/difficulty/difficulty_forecast.gd
game/difficulty/difficulty_step_event.gd
tests/run/*
tests/difficulty/*
```

### Contracts

- time-based speed/fuel
- cargo slowdown·BOOST speed/cost
- unload reward·Combo/max_combo/speed_bonus
- no-input finite survival
- fuel-zero run end once
- difficulty schedule owned by director
- presentation cannot mutate difficulty
- first-run assist/pause stop authoritative difficulty clock without catch-up

### Tests

- cargo 0~8 boundaries
- BOOST/LOAD priority
- Combo parity
- no reward on mismatch/empty
- no-input fuel-zero within bounded `TEST_VALUE`
- duplicate event 0
- warning enabled/disabled simulation trace parity
- pause/assist/restart lifecycle

## Package B — VS-03B Product Surface, Result, Profile

### Planned modules

```text
game/play/*
game/rail/rail_board_view.gd
game/rail/switch_view.gd
game/train/compact_wagon_token_view.gd
game/train/train_footprint.gd
game/camera/*
game/ui/game_hud.*
game/ui/result_panel.*
game/result/*
game/profile/*
game/records/*
game/cosmetics/*
game/progression/*
tests/ui/*
tests/profile/*
tests/records/*
tests/progression/*
```

### Contracts

- fixed active full map; PREP-only slight zoom
- `FULL_MAP_READY` before authoritative progression
- compact token count/order/rear/footprint parity
- result score/time/max Combo/new record + cause/action
- neutral fallback for weak evidence
- RESTART primary
- official global and current-map records atomic
- dual scope update gives at most one record reward component
- cosmetic modifier 0
- DEFAULT/DUAL_PATH/CURRENCY_ONLY semantics
- atomic/idempotent purchase, compensation, reward, record writes
- save failure does not destroy result
- 48dp·safe area·Reduced Motion·mute/haptic-off

## Package C — VS-03C Contextual Onboarding

Responsibility plan: `docs/superpowers/plans/2026-08-02-first-session-contextual-onboarding.md`.

- normalized events·OnboardingState
- FirstRunAssistPolicy
- first LOAD/switch safe pause only
- real mixed-stack LIFO·Combo proof
- low-fuel BOOST hint
- skip·timeout·resume
- versioned preferences
- overlay·Help·telemetry
- assisted standard-record/reward/balance exclusion

## Package D — VS-03D Minimum Official Map Flow

### Goal

최소 3개 official map에서 same-map learning과 new-map variety를 증명한다.

### Planned modules

```text
game/maps/map_definition.gd
game/maps/map_catalog.gd
game/maps/map_identity.gd
game/maps/map_selection_request.gd
game/maps/map_selection_receipt.gd
game/maps/map_selection_service.gd
game/maps/map_discovery_state.gd
game/maps/run_session_factory.gd
game/ui/map_browser_view_model.gd
game/ui/map_browser_panel.gd
tests/maps/*
tests/integration/test_three_map_flow.gd
```

### Contracts

- three distinct validated layout signatures
- fallback/duplicate not counted
- NEW RUN undiscovered-first
- RESTART exact same map and fresh run state
- manual/restart auto-bag consume 0
- discovery after reconstruction + FULL_MAP_READY + run start
- discovered map direct reselection
- official global/per-map record scope
- raw seed/version/signatures hidden from player UI
- load failure never silently chooses another map

### Tests

```text
first 3 eligible starts unique
4th start no immediate repeat under TEST_VALUE policy
restart same identity + fresh run IDs
manual selection no bag mutation
process interruption receipt replay/idempotency
current-map/global record atomicity
```

## Package E — VS-04 Evidence

- bounded telemetry
- 10-minute soak
- Android export/device performance
- representative captures
- 5+ first-experience users
- result/camera/token/map-choice/record comprehension
- assisted/standard run separation
- economy simulation
- target3 map readability/distribution
- final adversarial review
- `PASS / REVISE / PIVOT / STOP`

## Production Follow-Up

### Official catalog

- generator diversity expansion
- 100+ unique validated layouts
- target-100 distribution/reconstruction/browser audits
- `F58` closure

### Online UGC

- data-only editor and local validation
- publication/account backend and real server receipts
- PRIVATE/UNLISTED/PUBLIC
- moderation·quarantine·report·block
- revision-scoped UGC records
- favorites·qualified plays·recommendations·staff picks
- event journal·aggregate rebuild·anti-abuse·privacy
- two-account playback

No UGC rewards, creator payout, rating/comments/followers/trending/leaderboard initially.

## READY_FOR_BUILD Gate

- [x] GMB-001 10 user decisions approved and frozen
- [x] local versus Production scope defined
- [ ] PR #29 premerge audit PASS
- [ ] canonical merge
- [ ] Sheet canonical SHA + 12-tab readback
- [ ] Sync Closure PR merge
- [ ] Issue #6 scope updated and accepted
- [ ] existing API/file collision review
- [ ] final package dependency/order audit
- [ ] rollback and save-migration boundary confirmed
- [ ] explicit `READY_FOR_BUILD` promotion

Until every required item is complete, `CODEX_NOT_READY` remains.

## Current Action

```text
No new Grill Me
No product implementation
Complete GMB-001 premerge audit and closure
```
