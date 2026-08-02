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

Status: `PASS · GMB001_SCOPE_STAGED`

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
- [ ] records/Profile/cosmetics/unlocks/rewards
- [ ] difficulty signal
- [ ] same-map restart
- [ ] minimum 3 official maps·selection/reselection
- [ ] contextual onboarding

## G3P — TOTAL_PLANNING_AND_REVIEW_COMPLETE

Status: `DEFINITION_OF_READY_REVIEW_REQUIRED`

완료:

- [x] Post-VS02 canon/Sheet recovery
- [x] SX-DEC-014~016·SX-OPS-001 sync
- [x] GMB-001 exactly 10 approvals (`SX-DEC-017~026`)
- [x] EV-USER-006~015
- [x] specs·TDD plans·ledger·canonical consumer
- [x] VS versus Production/online UGC staging
- [x] pre-merge adversarial audit PASS
- [x] PR #29 expected-head canonical merge
- [x] Decision merge SHA `9b63421a5ab4d57adbfcf69d2b6e1bf8e3d17496`
- [x] correct Sheet canonical SHA·12-tab readback PASS
- [x] GMB-001 Sync Closure metadata

남음:

- [ ] existing API/file collision review for implementation
- [ ] package dependency/order audit
- [ ] rollback·save-migration boundary confirmation
- [ ] exact acceptance-test/evidence locations review
- [ ] explicit `READY_FOR_BUILD` promotion

GMB-001 closure alone does not set `READY_FOR_BUILD`.

## G3B — GRILL_ME_BATCH_PREMERGE

Status: `GMB-001 CLOSED`

Closure evidence:

- [x] exactly `SX-DEC-017~026`, `EV-USER-006~015`
- [x] no `SX-DEC-027`
- [x] behind 0
- [x] 33 planning-only files; product files 0
- [x] Project Contract run 195 success
- [x] Godot Tests run 186 success
- [x] unresolved review threads 0
- [x] REQUEST_CHANGES 0
- [x] known open P0/P1 design findings 0
- [x] PR #29 expected-head merge
- [x] Sheet canonical SHA + 12-tab readback PASS
- [x] history preserved·`30_세계_서사` unchanged

Responsibility:

- `GMB-001_DECISION_LEDGER.md`
- `GMB-001_PREMERGE_AUDIT.md`
- `GRILL_ME_BATCH_MERGE_PROTOCOL.md`
- `../00_프로젝트_허브/GMB-001_CANONICAL_DECISIONS.md`

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

- official target 100+ completion
- full UGC editor/backend/publication
- moderation/community backend

## G5 — PLAYTEST_EVIDENCE

Status: `NOT_STARTED`

- [ ] 10-minute soak
- [ ] Android device performance
- [ ] 5명+ first experience
- [ ] LIFO·Combo·token·result insight·map choice comprehension
- [ ] assisted/standard evidence separation
- [ ] target3 map readability/distribution
- [ ] economy simulation
- [ ] PASS / REVISE / PIVOT / STOP

## G6 — OFFICIAL_CATALOG_PRODUCTION

Status: `NOT_STARTED · F58_NOT_MET`

- [ ] generator diversity expansion
- [ ] 100+ unique validated official layouts
- [ ] fallback/duplicate exclusion
- [ ] first-100 non-replacement audit
- [ ] 100-entry browser QA
- [ ] version migration

## G7 — ONLINE_UGC_PRODUCTION

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
- [ ] Android/localization/accessibility/human evidence

Forbidden initial claims/features:

- no ONLINE/MODERATION/ANTI_ABUSE/PRIVACY READY from mocks
- no UGC currency/creator payout
- no rating/comments/followers/trending/leaderboards
- no engagement-weighted official map assignment

## Current Transition

```text
GMB-001 CLOSED
→ G3P Definition of Ready review
→ explicit READY_FOR_BUILD approval
→ VS-03A/B/C/D
```

`CODEX_NOT_READY` remains until explicit promotion.
