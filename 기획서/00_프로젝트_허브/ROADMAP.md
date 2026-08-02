# Roadmap

## M0 — 운영체계 설치 · COMPLETE

- [x] GitHub 정본·Registry·Base Adapter·Google Sheets 연결
- [x] 저장소만으로 현재 결정과 다음 작업 복원
- [x] Base v9.4 운영 계약 적용

## M1 — 철도·열차·화물 기반 · COMPLETE

- [x] Godot 4.7.1 project·custom headless runner
- [x] 15×10 connected RailGraph·no dead ends
- [x] 2/3-state switches·straight-first·preview parity
- [x] continuous train movement
- [x] capacity 8 LIFO CargoStack
- [x] station 6·pickup minimum 4/type
- [x] bounded spawn and deferred recovery
- [x] matching-group unload

증거: PR #9/#12/#13, product baseline `4e435a1a6d10ab146197671049da80709fd18c1f`, historical `9 cases / 6915 assertions / 0 failures`.

## M2 — 총기획·정본 복구 · COMPLETE

- [x] Post-VS02 implementation/canon drift 감사·복구
- [x] 올바른 Sheet 식별·잘못된 `19Ff...` 제외
- [x] `SX-DEC-014~016`, `SX-OPS-001` sync
- [x] GMB-001 `SX-DEC-017~026`, `EV-USER-006~015`
- [x] specs·TDD plans·canonical consumer
- [x] VS/Production scope staging
- [x] PR #29 Decision merge `9b63421a...`
- [x] PR #34 closure `aac3ed87...`
- [x] correct Sheet final 12-tab readback PASS

## M2.5 — Definition of Ready · PASS PENDING CANONICAL SYNC

Audit: `SX-AUD-005`; Evidence: `EV-USER-016`.

- [x] actual API/file collision inventory
- [x] custom test runner normalization
- [x] compact footprint occupancy seam
- [x] composition root·RunSession boundary
- [x] authoritative frame/event/fuel-zero order
- [x] explicit map reconstruction inputs
- [x] Profile single-writer transaction boundary
- [x] 7-package dependency/order and hotspot owners
- [x] rollback strategy
- [x] exact acceptance/evidence locations
- [x] target3/target100 separation
- [x] known open P0/P1 implementation-planning finding 0 after fixes
- [ ] canonical DoR merge
- [ ] Sheet Audit/Evidence/ready closure

After closure:

```text
G3P PASS · READY_FOR_BUILD
initial authorization VS03-01 only
```

## M3 — VS-03 Local Core · NOT_STARTED

### VS03-01 — Run Lifecycle, Economy and Difficulty

- [ ] minimal TestCase helpers using current runner
- [ ] RunBalance·RunState·RunSummary·RunController
- [ ] boundary-sliced movement/event/fuel-zero order
- [ ] time speed/fuel·cargo slowdown·BOOST cost
- [ ] unload reward·Combo/max_combo/speed_bonus
- [ ] no-input finite survival·fuel-zero once
- [ ] DifficultyForecast/Event/Director
- [ ] existing 9 suites regression

### VS03-02 — Compact Footprint

- [ ] compact token state 0~8
- [ ] rear=LIFO top and fractional path order
- [ ] TrainFootprint occupied cells
- [ ] optional DeliveryLoop occupancy provider
- [ ] legacy `train_cells()` fallback
- [ ] compressed respawn exclusion integration

### VS03-03 — Minimum Official Map Flow

- [ ] explicit MapDefinition reconstruction fields
- [ ] strict MapCatalog and target3 manifest
- [ ] fully configured RunSessionFactory
- [ ] exact same-map restart + fresh identities/services
- [ ] undiscovered-first automatic selection
- [ ] discovered map reselection
- [ ] no raw seed·no silent substitution

Target100 generator expansion is not included. `F58` remains `NOT_MET`.

### VS03-04 — Profile and Local Progression

- [ ] Profile schema v1 and atomic store
- [ ] ProfileTransactionService single writer
- [ ] official global/per-map records
- [ ] cosmetic-only registry/collection
- [ ] DEFAULT/DUAL_PATH/CURRENCY_ONLY
- [ ] bounded cosmetic-currency reward
- [ ] record→reward ordering and idempotency

### VS03-05 — Product Surface

- [ ] PlayScene composition root and main integration
- [ ] RailBoardView·SwitchView·TrainView·compact token view
- [ ] PREP camera·FULL_MAP_READY·active full map
- [ ] GameHUD
- [ ] result insight/neutral fallback/RESTART
- [ ] collection and discovered-map browser
- [ ] Reduced Motion·safe area·48dp state tests

### VS03-06 — Contextual Onboarding

- [ ] OnboardingState·normalized events
- [ ] first LOAD/switch safe pause
- [ ] mixed-stack LIFO·Combo proof
- [ ] low-fuel BOOST hint
- [ ] skip·timeout·Help·preferences
- [ ] assisted/standard evidence separation

### VS03-07 — Integration and Handoff

- [ ] end-to-end first run→result→restart/new map
- [ ] bounded telemetry
- [ ] save/retry duplicate transaction 0
- [ ] three-map deterministic flow
- [ ] `VS03_IMPLEMENTATION_AUDIT.md`
- [ ] Issue #7 evidence handoff

M3 종료는 local automated flow를 증명하는 것이다. Android·human·online PASS가 아니다.

## M4 — Target Quality and Playtest · NOT_STARTED

- [ ] 10-minute soak
- [ ] Android export·device performance
- [ ] safe area·48dp·Reduced Motion runtime
- [ ] localization/accessibility runtime
- [ ] economy simulation
- [ ] first-experience 5명+
- [ ] representative captures
- [ ] PASS / REVISE / PIVOT / STOP

## M5 — Official Catalog Production · NOT_STARTED

- [ ] generator diversity expansion
- [ ] 100+ unique validated layouts
- [ ] fallback/duplicate count 0
- [ ] first-100 non-replacement audit
- [ ] 100-entry browser QA
- [ ] version migration

`F58`은 M5 증거 전까지 `NOT_MET`다.

## M6 — Online UGC Production · NOT_STARTED

- [ ] data-only editor
- [ ] account/upload/publication backend
- [ ] server recanonicalization·validation
- [ ] immutable revisions and visibility states
- [ ] moderation·report·block·quarantine
- [ ] revision-scoped UGC records
- [ ] non-economic community signals
- [ ] journal·aggregate rebuild·anti-abuse·privacy
- [ ] two-account playback

## Current Execution Order

```text
DoR canonical sync
→ VS03-01
→ VS03-02
→ VS03-03
→ VS03-04
→ VS03-05
→ VS03-06
→ VS03-07
→ M4 evidence
→ M5 catalog100
→ M6 online UGC
```

Next batch/Decision remains `NOT_STARTED / NOT_ASSIGNED` unless a material player-facing choice appears.
