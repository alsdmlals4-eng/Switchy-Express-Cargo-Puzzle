# Development Gates

## G0 — PROJECT_IDENTIFIED

Status: `PASS`

- [x] 프로젝트·플랫폼·엔진 확정
- [x] 저장소와 올바른 Switchy Express Sheet 확인
- [x] 잘못 제공된 `19Ff...` Sheet 제외

## G1 — CORE_CONFIRMED

Status: `PASS`

- [x] 자동 운행·LOAD·분기·LIFO·연료·점수 구조
- [x] 15×10 connected railway
- [x] visual direction
- [x] Combo·compact token·actual-run onboarding
- [x] `SX-DEC-017~026` 사용자 승인·canonical sync

## G2 — VERTICAL_SLICE_CONTRACT_APPROVED

Status: `PASS · LOCAL/PRODUCTION_SCOPE_STAGED`

- [x] representative experience·include/exclude
- [x] Combo/token/onboarding contracts
- [x] result/camera/Profile/reward/difficulty/restart/map-selection contracts
- [x] VS local scope와 Production online UGC scope 분리
- [x] tuning values marked `TEST_VALUE`

## G3 — CORE_RUNTIME_PROVEN

Status: `PARTIAL`

완료:

- [x] Godot project/headless tests
- [x] RailGraph·switch·preview parity
- [x] continuous train movement
- [x] CargoStack·station·pickup·LIFO unload
- [x] deferred pickup recovery
- [x] historical automated evidence `9 cases / 6915 assertions / 0 failures`

남음:

- [ ] survival economy·Combo
- [ ] compact token runtime·footprint
- [ ] product HUD/result/camera
- [ ] Profile/records/cosmetics/unlocks/rewards
- [ ] difficulty signal
- [ ] same-map restart
- [ ] minimum 3 official maps·selection/reselection
- [ ] contextual onboarding

## G3P — TOTAL_PLANNING_AND_REVIEW_COMPLETE

Status: `PASS · READY_FOR_BUILD · SX-AUD-005`

- [x] GMB-001 canonical Decision/Sheet closure
- [x] actual code/API/file inventory
- [x] custom test runner audit
- [x] compact footprint occupancy integration seam
- [x] composition root·RunSession ownership
- [x] authoritative frame/event/fuel-zero order
- [x] MapDefinition reconstruction inputs·fully configured session contract
- [x] Profile single-writer transaction boundary
- [x] package dependency/order and hotspot ownership
- [x] rollback strategy
- [x] exact acceptance/evidence locations
- [x] target3/target100 scope separation
- [x] user instruction `EV-USER-016`
- [x] known open P0/P1 implementation-planning findings 0 after fixes
- [x] PR #35 canonical merge `82fd3eeb1915e6ceedb2f5330b27e903064d6eb5`
- [x] correct Sheet `SX-AUD-005 / EV-USER-016` canonical readback PASS
- [x] Sync Closure metadata prepared

승격 의미:

```text
Codex READY_FOR_BUILD · VS03-01_ONLY
product implementation NOT_STARTED until execution begins
VS03-02~07 BLOCKED_BY_PREVIOUS_PACKAGE
```

## G3B — GRILL_ME_BATCH_PREMERGE

Status: `GMB-001 CLOSED`

- [x] exactly `SX-DEC-017~026`, `EV-USER-006~015`
- [x] PR #29 expected-head merge `9b63421a...`
- [x] closure PR #34 `aac3ed87...`
- [x] correct Sheet final readback PASS
- [x] history preserved·`30_세계_서사` unchanged

## G3I — VS-03 IMPLEMENTATION PACKAGES

Status: `VS03-01 READY_FOR_BUILD · NOT_STARTED`

Canonical order:

```text
VS03-01 run lifecycle/economy/difficulty
→ VS03-02 compact footprint/DeliveryLoop seam
→ VS03-03 target3 maps/session/restart/selection
→ VS03-04 Profile transactions/records/cosmetics/unlocks/rewards
→ VS03-05 product scene/camera/HUD/result/browsers
→ VS03-06 contextual onboarding
→ VS03-07 integration/evidence handoff
```

Rules:

- current authority is VS03-01 only
- previous package must merge before the next package starts
- shared hotspot packages do not run in parallel
- every PR requires behind 0, Project Contract/Godot success, thread 0, REQUEST_CHANGES 0
- package ownership, rollback, and explicit NOT_RUN evidence are mandatory

## G4 — TARGET_QUALITY_SLICE

Status: `NOT_STARTED`

- [ ] survival economy + no-input finite survival
- [ ] product Scene·HUD·result insight
- [ ] compact tokens·rear LIFO·compressed footprint
- [ ] PREP zoom·FULL_MAP_READY·active full map
- [ ] local records·cosmetic/unlock/reward representative flow
- [ ] difficulty prewarning/persistent signal
- [ ] same-map restart
- [ ] minimum 3 validated official maps and discovery/reselection
- [ ] contextual onboarding
- [ ] 48dp·safe area·Reduced Motion·mute/haptic-off

Not in G4:

- official target100 completion
- full UGC editor/backend/publication
- moderation/community backend

## G5 — PLAYTEST EVIDENCE

Status: `NOT_STARTED`

- [ ] 10-minute soak
- [ ] Android device performance
- [ ] localization/accessibility runtime
- [ ] 5명+ first experience
- [ ] LIFO·Combo·token·result insight·map choice comprehension
- [ ] assisted/standard evidence separation
- [ ] target3 map readability/distribution
- [ ] economy simulation
- [ ] PASS / REVISE / PIVOT / STOP

## G6 — OFFICIAL CATALOG PRODUCTION

Status: `NOT_STARTED · F58_NOT_MET`

- [ ] generator diversity expansion
- [ ] 100+ unique validated official layouts
- [ ] fallback/duplicate exclusion
- [ ] first-100 non-replacement audit
- [ ] 100-entry browser QA
- [ ] version migration

Target100 tests do not run inside the 10-second VS unit watchdog.

## G7 — ONLINE UGC PRODUCTION

Status: `NOT_STARTED`

- [ ] data-only editor
- [ ] publication/account backend
- [ ] server validation·immutable revisions
- [ ] PRIVATE/UNLISTED/PUBLIC
- [ ] moderation·report·block·quarantine
- [ ] UGC records
- [ ] non-economic community signals
- [ ] event journal·aggregate rebuild·anti-abuse
- [ ] privacy review·two-account playback

Forbidden initial claims/features:

- no ONLINE/MODERATION/ANTI_ABUSE/PRIVACY READY from mocks
- no UGC currency/creator payout
- no rating/comments/followers/trending/leaderboards
- no engagement-weighted official map assignment

## Current Transition

```text
G3P PASS · READY_FOR_BUILD
→ separate Codex execution for VS03-01
→ TDD + exact-head package Gate
→ merge before VS03-02 promotion
```
