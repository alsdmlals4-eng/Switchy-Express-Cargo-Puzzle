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
- [x] station·pickup·bounded recovery·matching-group unload

## M2 — 총기획·정본 · COMPLETE

- [x] `SX-DEC-014~026`, `SX-OPS-001`, GMB-001 canonical sync
- [x] 올바른 Sheet 식별·wrong `19Ff...` 제외
- [x] VS/Production scope staging
- [x] PR #29/#34 and final Sheet readback

## M2.5 — Definition of Ready · COMPLETE

Audit: `SX-AUD-005`; Evidence: `EV-USER-016`.

- [x] actual API/file/test/save/order/rollback review
- [x] compact occupancy seam·RunSession·Profile writer boundaries
- [x] target3/target100 separation
- [x] package ownership and exact evidence gates

## M2.6 — Core-Fun Alignment · COMPLETE

Audit: `SX-AUD-007`; Evidence: `EV-USER-017~018`.

- [x] core/support system hierarchy
- [x] benchmark-backed Grill Me process
- [x] current-consumer drift review
- [x] F91 core-before-meta option C user approval
- [x] VS03-R1 and VS03-05A executable plans
- [x] 05A/04/05B responsibility split
- [x] PR #39/#40 and correct Sheet closure

## M3 — VS-03 Local Core · IN_PROGRESS

Current state authority:

```text
기획서/50_제작_검증/VS03_PACKAGE_STATUS.md
```

### VS03-01 — Run Lifecycle, Economy and Difficulty · COMPLETE

- [x] RunBalance·RunState·RunSummary·RunController
- [x] boundary-sliced movement/event/fuel-zero order
- [x] speed/fuel pressure·cargo slowdown·BOOST cost
- [x] unload reward·Combo/max_combo/speed/heavy bonus
- [x] deterministic difficulty foundation and actual DeliveryLoop integration

Evidence:

```text
PR #37 merge 43972d3d23e931af3dbc81ab9b1c7d942fffb201
16 cases · 7110 assertions · 0 failures
```

### VS03-02 — Compact Tokens and Footprint · COMPLETE

- [x] token state 0~8, front→rear=bottom→top, rear=LIFO top
- [x] route-history fractional path continuity
- [x] TrainFootprint geometry 2.18 cell and trailing footprint `<=3`
- [x] optional DeliveryLoop occupancy provider and legacy fallback
- [x] compact pickup spawn/respawn exclusion
- [x] conservative farther-segment reservation

Evidence:

```text
PR #41 merge cfe6d5ca0c76942720c5c12ad5dc59aaa651b915
Project Contract 281 PASS
Godot Tests 261 PASS
19 cases · 7499 assertions · 0 failures
```

Product-view/Android/human readability remains `NOT_RUN` under `F92`.

### VS03-03 — Official Target-3 and RunSession · READY_FOR_BUILD

- [ ] exactly 3 distinct validated non-fallback official maps
- [ ] immutable MapDefinition and strict target3 catalog
- [ ] fully configured RunSessionFactory
- [ ] explicit train start/incoming cells
- [ ] exact same-map restart with fresh identities/services
- [ ] undiscovered-first and discovered-map reselection
- [ ] no raw seed or silent substitution

`F58` remains `NOT_MET`; target100 is Production.

### VS03-R1 — Difficulty Authority Alignment · BLOCKED_BY_VS03_03

- [ ] immutable pressure snapshot
- [ ] 30/45-second union schedule
- [ ] combined 90-second commit
- [ ] snapshot-based RunBalance consumption
- [ ] pause/reset/large-delta/event-time parity

No balance-value or player-rule change.

### VS03-05A — Minimal Playable Core Surface · BLOCKED_BY_VS03_R1

- [ ] PlayScene composition root and main host
- [ ] board·train·compact token·switch views
- [ ] semantic LOAD·BOOST·switch input
- [ ] minimal HUD and rear-item parity
- [ ] PREP camera·FULL_MAP_READY·active fixed full map
- [ ] Reduced Motion/presentation-off simulation parity
- [ ] Profile/result/record/reward/collection/browser dependencies 0

### VS03-04 — Profile and Local Progression · BLOCKED_BY_VS03_05A

- [ ] Profile schema v1 and single writer
- [ ] global/per-map records
- [ ] cosmetics·unlock modes·bounded reward
- [ ] atomic/idempotent run-end transaction

### VS03-05B — Result and Local Browsers · BLOCKED_BY_VS03_04

- [ ] result cause 1 + action 1 + neutral fallback
- [ ] committed record/reward receipt display
- [ ] collection/equip presentation
- [ ] discovered-map browser and semantic actions
- [ ] direct Profile mutation from presentation 0

### VS03-06 — Contextual Onboarding · BLOCKED_BY_VS03_05B

- [ ] real-run LOAD→token→switch→LIFO→Combo→BOOST learning
- [ ] safe pause·skip·timeout·Help
- [ ] assisted/standard evidence separation

### VS03-07 — Integration and Handoff · BLOCKED_BY_VS03_06

- [ ] full local deterministic flow
- [ ] bounded telemetry and retry idempotency
- [ ] Issue #7 evidence handoff

M3 completion proves automated local flow, not Android·human·online readiness.

## M4 — Target Quality and Playtest · NOT_STARTED

- [ ] Android export/device performance
- [ ] 10-minute soak
- [ ] safe area·48dp·Reduced Motion·localization/accessibility
- [ ] economy and mono-color strategy simulation
- [ ] compact token product readability and 5+ first-experience playtest
- [ ] representative captures and PASS/REVISE/PIVOT/STOP

## M5 — Official Catalog Production · NOT_STARTED

- [ ] generator diversity and 100+ unique layouts
- [ ] fallback/duplicate exclusion and first-100 audit
- [ ] browser QA and version migration

`F58` remains `NOT_MET` until M5 evidence.

## M6 — Online UGC Production · NOT_STARTED

- [ ] data-only editor and publication backend
- [ ] server validation·immutable revisions·visibility
- [ ] moderation·privacy·anti-abuse·community signals

## Current Execution Order

```text
VS03-03
→ VS03-R1
→ VS03-05A
→ VS03-04
→ VS03-05B
→ VS03-06
→ VS03-07
→ M4 evidence
→ M5 target100
→ M6 online UGC
```
