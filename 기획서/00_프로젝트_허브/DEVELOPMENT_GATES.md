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
- [x] `SX-DEC-017~026` 사용자 승인

## G2 — VERTICAL_SLICE_CONTRACT_APPROVED

Status: `PASS · GMB001_SCOPE_STAGED`

- [x] representative experience·include/exclude
- [x] Combo/token/onboarding contracts
- [x] result/camera/Profile/reward/difficulty/restart/map-selection contracts
- [x] VS local scope와 Production online UGC scope 분리
- [x] all tuning values marked `TEST_VALUE`

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

`G3P`와 별도 구현 승인 전 Codex Build를 시작하지 않는다.

## G3P — TOTAL_PLANNING_AND_REVIEW_COMPLETE

Status: `IN_PROGRESS · GMB001_PREMERGE_AUDIT`

- [x] latest main·implementation·PR·Issue 복원
- [x] Post-VS02 canon/Sheet recovery
- [x] SX-DEC-014~016·SX-OPS-001 canonical sync
- [x] GMB-001 exactly 10 approvals (`SX-DEC-017~026`)
- [x] EV-USER-006~015
- [x] specs·TDD plans·batch ledger
- [x] Sheet 10/10 frozen 12-tab readback
- [x] VS versus Production/online UGC staging
- [ ] current consumer stale references 0
- [ ] final exact-head PR/CI/inventory/review audit
- [ ] PR #29 canonical merge
- [ ] Sheet canonical merge SHA·12-tab readback
- [ ] Sync Closure PR
- [ ] Definition of Ready explicit promotion

GMB-001 closure alone does not automatically set `READY_FOR_BUILD`.

## G3B — GRILL_ME_BATCH_PREMERGE

Status: `GMB-001 · 10/10 · FROZEN · AUDIT_IN_PROGRESS`

책임 정본:

- `기획서/50_제작_검증/GMB-001_DECISION_LEDGER.md`
- `기획서/50_제작_검증/GMB-001_PREMERGE_AUDIT.md`
- `기획서/50_제작_검증/GRILL_ME_BATCH_MERGE_PROTOCOL.md`

Freeze 확인:

- [x] SX-DEC-017~026 exactly
- [x] EV-USER-006~015 exactly
- [x] no SX-DEC-027
- [x] Sheet frozen, not prematurely SYNCED
- [x] product code/Scene/Resource/asset changes prohibited
- [x] 12-tab readback; history and world/narrative preserved

Merge 전 필수:

- [ ] compare to main: behind 0
- [ ] changed files planning-only
- [ ] exact-head Project Contract success
- [ ] exact-head Godot Tests success
- [ ] unresolved review threads 0
- [ ] REQUEST_CHANGES 0
- [ ] P0/P1 open findings 0
- [ ] PR open/mergeable and expected-head protected

Merge 후 필수:

```text
canonical merge SHA
→ Sheet all relevant rows canonicalized
→ 12-tab readback PASS
→ Sync Closure PR checks + merge
→ GMB-001 CLOSED
```

## G4 — TARGET_QUALITY_SLICE

Status: `NOT_STARTED`

- [ ] survival economy + no-input finite survival
- [ ] product play Scene·HUD·result insight
- [ ] 0~8 compact tokens·rear LIFO·compressed footprint
- [ ] PREP zoom·FULL_MAP_READY·active full map
- [ ] local records·cosmetic/unlock/reward representative flow
- [ ] difficulty prewarning/persistent signal
- [ ] same-map restart
- [ ] minimum 3 validated official maps and discovery/reselection
- [ ] contextual onboarding
- [ ] 48dp·safe area·Reduced Motion·mute/haptic-off

Not in G4:

- official 100+ completion
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
