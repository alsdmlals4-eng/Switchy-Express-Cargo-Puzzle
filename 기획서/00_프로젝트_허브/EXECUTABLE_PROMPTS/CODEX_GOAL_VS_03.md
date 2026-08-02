# Codex Goal — VS-03 Local Survival Vertical Slice

```yaml
status: PLANNING_DRAFT · CODEX_NOT_READY
issue: 6
parent_epic: 3
product_baseline: 4e435a1a6d10ab146197671049da80709fd18c1f
gmb001: CLOSED · SX-DEC-017~026 · DECISION_MERGE_9b63421a
execution_authority: NONE_UNTIL_READY_FOR_BUILD_PROMOTION
online_ugc: OUT_OF_SCOPE_FOR_VS03
next_gate: G3P_DEFINITION_OF_READY_REVIEW
```

> 이 문서는 현재 실행 명령이 아니다. GMB-001 planning sync는 완료됐지만 Definition of Ready 검토와 명시적 `READY_FOR_BUILD` 승인 전에는 코드·Scene·Resource·asset을 변경하지 않는다.

## 목표 결과

```text
actual first endless run
→ LOAD·compact token·switch·mixed-stack LIFO·Combo onboarding
→ normal survival economy
→ fixed full-map active play and difficulty signals
→ fuel-zero result with evidence-based advice
→ official global/current-map record and bounded cosmetic progress
→ exact same-map restart or another discovered official map
```

## 책임 정본

```text
기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md
기획서/00_프로젝트_허브/GMB-001_CANONICAL_DECISIONS.md
기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md
기획서/50_제작_검증/GMB-001_PREMERGE_AUDIT.md
docs/superpowers/plans/2026-08-02-switchy-express-current-vertical-slice.md
```

## 보호 계약

- 기존 RailGraph·RailSwitch·CargoStack·DeliveryLoop 의미를 보존한다.
- `combo_count`는 one-arrival unload-group size다.
- compact token count == CargoStack size; rear == CargoStack top.
- compressed footprint만 spawn exclusion에 사용한다.
- UI·camera·Tween·animation·onboarding·result·browser는 non-authoritative다.
- `FULL_MAP_READY` 전 run progression·discovery·record commit을 시작하지 않는다.
- assisted first run은 standard record·goal·variable reward·balance evidence에 비적격이다.
- same-map restart는 exact identity와 fresh mutable services를 사용한다.
- Profile/record/reward/unlock/selection writes는 atomic·idempotent 또는 replay-safe다.
- runtime/Android/human/online 검증을 실행하지 않고 PASS로 표시하지 않는다.

## VS-03A — Run Economy and Difficulty

Planned responsibility:

```text
RunBalance
RunState
RunController
DifficultyDirector
DifficultyForecast / DifficultyStepEvent
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

- first PREP slight zoom; active fixed full map
- 0~8 token count/order/rear/footprint parity
- score/fuel/speed/max Combo/time HUD
- result cause 1 + action 1; neutral fallback when weak
- RESTART primary
- official global + current-map records atomic
- cosmetic gameplay modifier 0
- DEFAULT/DUAL_PATH/CURRENCY_ONLY semantics
- bounded rewards; no direct survival/raw-score currency
- dual record update gives record reward once maximum
- save failure/retry no duplicate transaction
- 48dp·safe area·Reduced Motion·mute/haptic-off

## VS-03C — Contextual Onboarding

```text
LOAD
→ token meaning
→ first switch
→ mixed-stack LIFO
→ Combo
→ low-fuel BOOST
```

- normalized events·OnboardingState
- first LOAD/switch safe pause only
- assist 0.5×/120s/3s `TEST_VALUE`
- skip·timeout·resume·Help·preferences
- UI hide/animation completion cannot finish steps or unpause
- assisted standard-record/reward/balance exclusion

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
- discovery after reconstruction + FULL_MAP_READY + authoritative start
- discovered map direct reselection
- no raw seed UI
- no silent different-map substitution
- official global/per-map record scope

## Explicitly Not in VS-03

- official target 100+ completion
- full 100-entry official browser Production QA
- full user-map editor
- account/upload/publication backend
- server UGC validation
- PRIVATE/UNLISTED/PUBLIC online sharing
- moderation/report/block/quarantine operations
- UGC records backend
- community signal backend/event journal/anti-abuse/privacy
- creator reward·UGC currency·rating·comments·followers·leaderboards

Interfaces may anticipate future compatibility, but fake online-complete implementation or readiness claims are forbidden.

## Definition of Ready — Still Required

Completed:

- [x] SX-DEC-017~026 approved and synced
- [x] GMB-001 audit/canonical merge/Sheet closure
- [x] VS versus Production scope staged

Required:

- [ ] existing API/file collision audit
- [ ] VS-03A/B/C/D package dependency/order audit
- [ ] implementation PR segmentation
- [ ] rollback strategy
- [ ] Profile/save migration boundary
- [ ] exact acceptance tests and evidence locations
- [ ] explicit `READY_FOR_BUILD` approval

## Current Instruction

```text
STOP
Do not implement.
Do not create product files.
Do not modify Scene/Resource/asset/runtime data.
Perform G3P Definition of Ready review first.
CODEX_NOT_READY
```
