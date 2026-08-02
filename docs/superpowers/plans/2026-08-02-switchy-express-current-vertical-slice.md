# Switchy Express Current Vertical Slice Master Plan

```yaml
status: CURRENT · PLANNING_ONLY · DEFINITION_OF_READY_REVIEW_REQUIRED
historical_foundation: docs/superpowers/plans/2026-08-01-switchy-express-vertical-slice.md
product_baseline: 4e435a1a6d10ab146197671049da80709fd18c1f
gmb001_decision_merge: 9b63421a5ab4d57adbfcf69d2b6e1bf8e3d17496
gmb001: CLOSED · SX-DEC-017~026
implementation_state: NOT_STARTED_FOR_GMB001
codex_state: CODEX_NOT_READY
```

> 이 문서는 현재 구현 명령이 아니다. GMB-001 planning sync는 끝났지만 Definition of Ready 적대적 검토와 명시적 `READY_FOR_BUILD` 승격 전에는 Codex가 제품 구현을 시작하지 않는다.

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

- `SX-DEC-014`: one-arrival Combo
- `SX-DEC-015`: compact wagon tokens
- `SX-DEC-016`: contextual onboarding
- `SX-DEC-017`: result learning
- `SX-DEC-018`: PREP camera/full-map gate
- `SX-DEC-019`: records/cosmetic-only progression
- `SX-DEC-020`: unlock modes
- `SX-DEC-021`: bounded rewards
- `SX-DEC-022`: difficulty communication
- `SX-DEC-023`: same-map restart/official catalog
- `SX-DEC-024`: official map discovery/reselection
- `SX-DEC-025`: official scoped records/user-map publication design
- `SX-DEC-026`: non-economic UGC community design

정본:

- `기획서/00_프로젝트_허브/GMB-001_CANONICAL_DECISIONS.md`
- `기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md`

모든 항목은 planning approved이며 runtime·Android·human·online evidence는 `NOT_STARTED / NOT_RUN`이다.

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
- survival economy·compact tokens·contextual onboarding

### Production/online scope

- official target 100+ unique layouts and scale browser
- full UGC editor
- account/upload/publication backend
- server validation·immutable revisions
- online sharing·moderation·privacy
- UGC records/community event journal·anti-abuse

Local mocks do not prove online readiness.

## VS-03A — Run Economy and Difficulty

Planned responsibility:

```text
RunBalance / RunState / RunController
DifficultyDirector / Forecast / StepEvent
DifficultySignalPolicy / PresentationState
focused unit and lifecycle tests
```

Required behavior:

- time speed/fuel
- cargo slowdown·BOOST cost
- unload reward·Combo/max_combo/speed_bonus
- no-input finite survival
- fuel-zero end once
- authoritative difficulty schedule
- forecast prewarning + persistent band
- presentation cannot mutate simulation
- pause/assist/restart deterministic lifecycle

## VS-03B — Product Surface, Result, Profile

Planned responsibility:

```text
RailBoardView / SwitchView
CompactWagonTokenView / TrainFootprint
CameraPresentationState / FULL_MAP_READY gate
GameHUD / ResultPanel / ResultInsightAnalyzer
ProfileStore / ScopedRecordStore
CosmeticRegistry / UnlockRegistry / Wallet
RewardEligibility / RewardCalculator / ProgressionService
```

Required behavior:

- fixed active full map; PREP-only slight zoom
- compact token count/order/rear/footprint parity
- score/fuel/speed/max Combo/time HUD
- result cause 1 + action 1; neutral fallback
- RESTART primary
- official global + current-map records atomic
- cosmetic gameplay modifier 0
- DEFAULT/DUAL_PATH/CURRENCY_ONLY semantics
- bounded rewards; no direct raw-score/survival currency
- dual record update gives one record reward component max
- save retry produces no duplicate transaction
- 48dp·safe area·Reduced Motion·mute/haptic-off

## VS-03C — Contextual Onboarding

- normalized events·OnboardingState
- FirstRunAssistPolicy
- first LOAD/switch safe pause only
- real mixed-stack LIFO·Combo proof
- low-fuel BOOST hint
- skip·timeout·resume
- versioned preferences
- overlay·Help·telemetry
- assisted/standard record/reward/balance separation

## VS-03D — Minimum Official Map Flow

Planned responsibility:

```text
MapDefinition / MapIdentity / MapCatalog
RunIdentity / RunSessionFactory
MapSelectionRequest / Receipt / Service
MapDiscoveryState / replay bag
compact discovered-map browser
```

Required behavior:

- minimum 3 distinct validated official layout signatures
- NEW RUN undiscovered-first
- RESTART exact same map and fresh IDs/state
- manual/restart auto-bag consumption 0
- discovery after reconstruction + FULL_MAP_READY + run start
- discovered map direct reselection
- no raw seed UI
- no silent different-map substitution
- official global/per-map record scope

## VS-04 Evidence

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

## Definition of Ready Gate

Completed:

- [x] GMB-001 10 user Decisions approved
- [x] pre-merge audit PASS
- [x] PR #29 canonical merge
- [x] correct Sheet canonical SHA + 12-tab readback
- [x] VS versus Production scope staged

Required before Build:

- [ ] existing API/file collision inventory
- [ ] package dependency/order audit
- [ ] rollback strategy
- [ ] Profile/save migration boundary
- [ ] exact acceptance tests and evidence locations
- [ ] implementation PR segmentation
- [ ] explicit `READY_FOR_BUILD` promotion

## Current Action

```text
GMB-001 CLOSED
Perform G3P Definition of Ready review
Do not implement yet
CODEX_NOT_READY
```
