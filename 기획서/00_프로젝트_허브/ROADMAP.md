# Roadmap

## M0 — 운영체계 설치 · COMPLETE

- [x] GitHub 정본·Registry·Base Adapter·Google Sheets 연결
- [x] 저장소만으로 현재 결정과 다음 작업 복원
- [x] Base v9.4 운영 계약 적용

## M1 — 철도·열차·화물 기반 · COMPLETE

- [x] Godot 4.7.1 project·headless runner
- [x] 15×10 connected RailGraph·no dead ends
- [x] 2/3-state switches·straight-first·preview parity
- [x] continuous train movement
- [x] capacity 8 LIFO CargoStack
- [x] station 6·pickup minimum 4/type
- [x] bounded spawn and deferred recovery
- [x] matching-group unload

증거: PR #9/#12/#13, product baseline `4e435a1a6d10ab146197671049da80709fd18c1f`, 기존 Godot `9 cases / 6915 assertions / 0 failures`.

## M2 — 총기획·정본 복구 · COMPLETE

- [x] Post-VS02 implementation/canon drift 감사·복구
- [x] 올바른 Sheet 식별·잘못된 `19Ff...` 제외
- [x] `SX-DEC-014~016`과 `SX-OPS-001` sync
- [x] GMB-001 사용자 승인 10건: `SX-DEC-017~026`
- [x] `EV-USER-006~015`
- [x] specs·TDD plans·batch ledger·canonical consumer
- [x] VS/Production 범위 분리
- [x] pre-merge adversarial audit PASS
- [x] PR #29 expected-head canonical merge
- [x] Decision merge SHA `9b63421a5ab4d57adbfcf69d2b6e1bf8e3d17496`
- [x] correct Sheet canonical SHA·12-tab readback PASS
- [x] history preserved·`30_세계_서사` unchanged
- [x] GMB-001 Sync Closure metadata

M2/GMB-001은 `CLOSED`다. 이는 제품 구현 완료나 자동 Build 승격을 의미하지 않는다.

## M2.5 — Definition of Ready Review · NEXT

- [ ] existing API/file collision review
- [ ] VS-03A/B/C/D dependency and order audit
- [ ] rollback strategy
- [ ] Profile/save schema migration boundary
- [ ] exact acceptance tests and evidence locations
- [ ] implementation PR segmentation
- [ ] explicit `READY_FOR_BUILD` user approval

현재 `CODEX_NOT_READY`.

## M3 — VS-03 Local Core · NOT_STARTED

### VS-03A — 생존 경제·Combo

- [ ] time speed/fuel
- [ ] cargo slowdown·BOOST cost
- [ ] unload reward·Combo/max_combo/speed_bonus
- [ ] no-input finite survival
- [ ] fuel-zero single end

### VS-03B — 제품 화면·result·Profile

- [ ] RailBoardView·SwitchView·HUD
- [ ] compact tokens·fractional path·compressed footprint
- [ ] result insight with neutral fallback
- [ ] PREP zoom·`FULL_MAP_READY`·active full map
- [ ] official local global/per-map records
- [ ] cosmetic-only registry/collection
- [ ] representative unlock modes and atomic transaction
- [ ] bounded cosmetic-currency reward
- [ ] same-map restart
- [ ] save schema/fallback

### VS-03C — contextual onboarding

- [ ] OnboardingState·normalized events
- [ ] first LOAD/switch safe pause
- [ ] assist 0.5×/120s/3s `TEST_VALUE`
- [ ] mixed-stack LIFO·Combo proof
- [ ] skip·resume·Help·preferences
- [ ] assisted/standard evidence separation

### VS-03D — local map variety·difficulty

- [ ] difficulty forecast/commit signal
- [ ] minimum 3 validated official maps
- [ ] undiscovered-first selection
- [ ] discovered map reselection
- [ ] same-map exact reconstruction
- [ ] global/per-map record transaction parity

M3 종료는 로컬 한 세션이 onboarding→run→delivery→result→same-map/new-map flow로 연결되고 자동 테스트가 통과하는 것이다. Android·사람·온라인 PASS는 별도다.

## M4 — 목표 품질·플레이테스트 · NOT_STARTED

- [ ] bounded telemetry
- [ ] 10-minute soak
- [ ] Android export·device performance
- [ ] 48dp·safe area·Reduced Motion·localization
- [ ] first-experience 5명+
- [ ] LIFO·Combo·token·result insight·map choice 이해
- [ ] target3 map distribution/readability
- [ ] economy simulation
- [ ] PASS / REVISE / PIVOT / STOP

## M5 — Official Catalog Production · NOT_STARTED

- [ ] generator diversity expansion
- [ ] unique layout signature audit
- [ ] fallback/duplicate count 0
- [ ] 100+ validated official layouts
- [ ] first-100 non-replacement start audit
- [ ] 100-entry browser performance/readability
- [ ] version migration

`F58`은 M5 증거 전까지 `NOT_MET`이다.

## M6 — Online UGC Production · NOT_STARTED

### Publication

- [ ] data-only editor
- [ ] local canonicalization/validation
- [ ] account/upload/publication backend
- [ ] server recanonicalization·hash·graph/start/budget/smoke validation
- [ ] immutable revisions
- [ ] PRIVATE/UNLISTED/PUBLIC
- [ ] two-account playback
- [ ] UGC revision-scoped records

### Moderation/community

- [ ] report·block·quarantine
- [ ] favorite·verified unique/qualified play
- [ ] one recommendation/account/revision
- [ ] explicit staff picks
- [ ] event journal·aggregate rebuild
- [ ] sybil/bot/self-play protection
- [ ] privacy review·retention owner
- [ ] 100+ UGC browser

초기 금지: UGC currency/creator payout, rating, comments, followers, trending/creator leaderboard, engagement-weighted official map assignment.

## GMB 운영

```text
CATCH-UP-001 · SX-DEC-014~016 · CLOSED
GMB-001 · SX-DEC-017~026 · CLOSED
next batch: NOT_STARTED
next Decision: NOT_ASSIGNED
```

다음 batch는 별도 사용자 작업으로 시작한다.

## 현재 실행 순서

```text
M2.5 Definition of Ready review
→ explicit READY_FOR_BUILD approval
→ VS-03A → VS-03B → VS-03C → VS-03D
→ VS-04 evidence
→ M5 official catalog
→ M6 online UGC
```
