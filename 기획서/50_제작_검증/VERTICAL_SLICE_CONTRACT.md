# Vertical Slice Contract

```yaml
status: APPROVED_CONTRACT · IMPLEMENTATION_IN_PROGRESS
core_fun_authority: CORE_FUN_SYSTEM_HIERARCHY.md
vs03_01: MERGED_AND_VERIFIED
current_package_authority: VS03-02_ONLY
product_scene_runtime: NOT_RUN
android_human_evidence: NOT_RUN
online_ugc: DEFERRED_TO_PRODUCTION_GATE
```

현재 package 상태는 `VS03_PACKAGE_STATUS.md`가 소유한다. 이 문서는 제품 의미·Vertical Slice 범위·품질 기준을 소유한다.

## 핵심 재미

> 자동으로 달리는 열차에서 앞으로 필요한 하역 순서를 역산해 화물을 골라 싣고, 분기기를 미리 바꾸며, 무게와 연료 압박을 감수해 큰 LIFO 하역 그룹을 성공시키는 계획형 생존 퍼즐.

우선순위:

```text
LIFO 적재 순서 계획
→ 노선 선행 결정
→ 큰 그룹을 위한 위험·생존 판단
→ BOOST·배송 tempo
→ 결과 학습·재도전
→ records/cosmetics/maps/UGC
```

보조 시스템은 위 핵심 판단을 학습·반복·확장하며 대체하지 않는다.

## 목표

한 판에서 실제 첫 세션 학습, 선택 적재, 2/3단계 분기 전환, compact token LIFO 하역, 하역 그룹 Combo, 연료 생존, 화물 감속, BOOST 위험 선택이 연결된다. 결과에서 실패를 이해하고 같은 맵 또는 새 공식 맵을 선택하며, local records·cosmetic progression이 다음 판 동기로 이어지는지 목표 품질로 검증한다.

## 포함 — VS-03 Local Scope

### 구현 기반

- Godot 4.7.1 / Android landscape
- 15×10 connected railway·no dead ends
- 2-state switch 최소 4개·3-state 최소 2개
- 색상별 station 2개·pickup 최소 4개
- automatic movement·LOAD·BOOST input contract
- capacity 8 LIFO CargoStack
- deterministic placement·deferred recovery

### VS03-01 — 구현·headless 검증 완료

- `SX-DEC-009`: score·fuel·time pressure·fuel-zero end
- `SX-DEC-010`: cargo slowdown·BOOST speed/cost
- `SX-DEC-014`: one-arrival unload-group Combo
- RunBalance·RunState·RunSummary·RunController
- RunMetricsAccumulator
- DifficultyForecast/Event/Director core
- boundary-sliced event/run-clock/difficulty/fuel-zero order
- actual DeliveryLoop·CargoStack·Station integration

증거:

```text
PR #37 merge 43972d3d23e931af3dbc81ab9b1c7d942fffb201
Project Contract 227 PASS
Godot Tests 214 PASS
16 cases · 7110 assertions · 0 failures
```

### 현재 package — VS03-02

- `SX-DEC-015` compact wagon tokens 0~8
- rear=LIFO top
- compressed footprint
- optional DeliveryLoop occupancy provider
- full-cell legacy fallback
- spawn/respawn exclusion integration
- minimum Android viewport readability evidence hook

### 후속 VS-03 local integration

- `SX-DEC-016`: actual first-run contextual onboarding
- `SX-DEC-017`: evidence-based result cause/action and neutral fallback
- `SX-DEC-018`: PREP camera·FULL_MAP_READY·active full map
- `SX-DEC-019`: standard records and cosmetic-only collection/equip
- `SX-DEC-020`: DEFAULT/DUAL_PATH/CURRENCY_ONLY unlock
- `SX-DEC-021`: bounded cosmetic currency
- `SX-DEC-022`: authoritative difficulty prewarning and persistent signal
- `SX-DEC-023`: exact same-map restart and fresh RunSession
- `SX-DEC-023/024`: minimum 3 validated official maps and discovery/reselection
- `SX-DEC-025`: official global + per-map personal records atomic commit
- assisted first run separated from standard evidence
- Android safe area·48dp·Reduced Motion·mute·haptic-off contracts
- headless tests·soak·captures·5+ first-experience validation plan

## 제외 — Production / Online Gate

- official 100+ unique layout completion and distribution audit
- final 100-entry browser
- full user-map editor
- account/upload/publication backend
- server recanonicalization/hash/smoke validation
- PRIVATE/UNLISTED/PUBLIC publication
- moderation·report·block·quarantine operations
- online UGC records
- community backend·event journal·anti-abuse
- creator payout·UGC reward·rating·comments·followers·leaderboards
- ads·payment·energy·gacha·PvP·guild·real-time ranking
- iOS release work

VS-03 may add seams/data boundaries but cannot claim online readiness from local mocks.

## Core Authority Contracts

- gameplay domain owns score·fuel·cargo·route·Combo·difficulty·run end.
- UI·camera·Tween·animation·tutorial·result·collection·browser are non-authoritative.
- `FULL_MAP_READY` precedes authoritative progression/discovery/record commit.
- animation completion never owns cargo·occupancy·record·reward·restart.
- map identity, run identity, record transaction, reward event, selection request are distinct.
- same-map restart creates fresh mutable services.
- currency·unlock·reward·selection·record·Profile operations are atomic/idempotent or replay-safe.
- assisted first run is ineligible for standard record·goal·variable reward·balance evidence.
- UI failure/save retry cannot duplicate commits.
- DifficultyDirector must align with every meaningful player-facing pressure change; unannounced speed/fuel boundary changes are not accepted.

## Combo Contract — SX-DEC-014

- `combo_count == unload_group_size == try_unload().count`.
- one station arrival, stack top부터 같은 type 연속 하역 수.
- `max_combo` is run maximum group size.
- no delivery streak Combo.
- speed bonus is independent `TEST_VALUE`.
- empty/mismatch arrival gives Combo·score·fuel reward 0.
- domain·HUD·result·telemetry·save use identical meaning.

상태: domain implementation `PASSED`; presentation/save consumers later package.

## Compact Wagon Token Contract — SX-DEC-015

- token count == CargoStack size, 0~8.
- cargo 0이면 locomotive only.
- front→rear == stack bottom→top.
- rear == stack top == HUD first unload item.
- color+shape dual encoding.
- load/unload count·order·footprint commit in same domain step.
- body 0.22 cell, spacing 0.28, chain 2.18, trailing footprint ≤3 cells `TEST_VALUE`.
- spawn exclusion uses actual compressed footprint, not 8 full cells.
- curve sampling preserves order and prevents corner cutting.

상태: `VS03-02 READY_FOR_BUILD`.

## First-Session Onboarding — SX-DEC-016

- actual endless run: `LOAD → token → switch → mixed-stack LIFO → Combo → low-fuel BOOST`.
- safe full pause only before first LOAD and first switch.
- no general branch slow motion.
- assist `TEST_VALUE`: fuel drain 0.5×, escalation paused, max120 sec, restore3 sec, BOOST hint fuel≤35%.
- finish on core complete/skip/timeout first condition.
- OnboardingState consumes normalized domain events.
- overlay/copy/animation are not step/unpause/reward authority.
- Help replay does not reactivate assist.

상태: planned, VS03-06.

## Result Learning — SX-DEC-017

- score·survival·max Combo·new record.
- when evidence is sufficient, one cause and one next action.
- weak/tied/damaged/too-short/assisted uses neutral fallback.
- no blame or false causality.
- restart primary.

상태: planned, VS03-05.

## Camera and Run Gate — SX-DEC-018

- first PREP slight zoom `1.20× TEST_VALUE`.
- transition `0.75 sec TEST_VALUE`.
- authoritative run begins only after `FULL_MAP_READY`.
- active run fixed full map, no free pan/zoom.
- Reduced Motion may use instant/static transition with identical timing.
- restart usually skips PREP zoom `TEST_VALUE`.

상태: planned, VS03-05.

## Local Profile / Cosmetics / Unlock / Rewards — SX-DEC-019~021

Standard records:

- `best_score`
- `longest_survival_seconds`
- `best_max_combo`

Eligibility: completed/current ruleset/integrity valid/non-debug/non-assisted.

Cosmetics:

- gameplay/stat/collision/camera/readability/record modifiers 0.
- representative collection/equip only in VS.

Unlock modes:

- `DEFAULT`
- `DUAL_PATH`: eligible goal or currency
- `CURRENCY_ONLY`: currency only

Purchase does not fake goal completion. Purchase-first then legitimate goal compensation is bounded·one-time·idempotent.

Reward `TEST_VALUE`:

- standard eligibility + successful delivery≥1
- base10
- delivery +2 cap10
- highest Combo tier +2/+5/+8
- authoritative record update +5 once
- run cap30
- assisted onboarding completion+delivery fixed intro10 once
- no raw score/survival currency
- global+per-map update still grants record component max once

상태: planned, VS03-04.

## Difficulty Communication — SX-DEC-022

- DifficultyDirector/equivalent owns schedule·commit.
- immutable forecast/event only consumed by presentation.
- exact internal formula/interval/multiplier/threshold hidden by default.
- lead5 sec, banner1.5 sec, cooldown8 sec, CALM/BUSY/INTENSE `TEST_VALUE`.
- warning ≤2 lines and cannot obscure board/station/switch/token/fuel/LIFO info.
- assist/pause stop authoritative timers; no wall-clock catch-up.
- warning/motion preference cannot mutate simulation trace.

Current core implements a 30-sec DifficultyDirector commit, while RunBalance fuel pressure changes at 45-sec boundaries. `SX-AUD-007-F87` requires schedule alignment before presentation acceptance.

## Same-Map Restart and Minimum Official Map Set — SX-DEC-023~024

Restart:

- exact map ID/revision/seed/generator+ruleset versions/signatures.
- new run/reward/record/presentation identities.
- fresh score/fuel/cargo/switch/train/spawn/combo/difficulty/result state.
- no silent substitution.

VS minimum:

- 3 official maps with distinct validated layout signatures.
- first eligible NEW RUN cycle prioritizes undiscovered maps.
- restart/manual consumes automatic bag 0.
- discovery commits after reconstruction + FULL_MAP_READY + authoritative start.
- discovered maps selectable in compact browser/list.

100+ target is Production; fallback/duplicates excluded; `F58 NOT_MET` until audit.

상태: planned, VS03-03.

## Scoped Official Records — SX-DEC-025 Local Portion

- global official personal best across eligible official maps.
- per-map official personal best for exact stable identity.
- one eligible run evaluates both in one atomic transaction.
- result prioritizes current-map record and separately shows real global update.
- global personal best is not cross-map online fairness leaderboard.
- UGC does not enter VS local official records.

상태: planned, VS03-04/05.

## Core-Fun Guardrails

- mono-color selective loading may not become an almost universal optimal strategy.
- speed/heavy bonus may not outweigh load-order/group-size planning.
- BOOST always-on may not dominate both survival and score.
- carrying irrelevant cargo for heavy bonus may not dominate.
- difficulty may raise decision frequency/opportunity cost, not only reflex precision.
- meta rewards/content volume may not become the primary repeat reason before core fun is proven.

Required evidence:

- mixed-stack and distinct-type distribution
- mono-color delivery ratio
- Combo distribution
- base/speed/heavy score contribution
- route preparation and recovery behavior
- BOOST uptime and lost LOAD opportunity

## Quality Bar

### Readability

- first 3 sec: train/cargo/station/switch distinction.
- active route and preview distinction.
- HUD unload order and rear token parity.
- color+shape identification.
- Combo versus speed bonus distinction.
- 0/1/4/8 tokens and rear target readable.
- result cause/action/current/global labels distinct.
- difficulty UI does not obscure critical information.
- PREP versus active camera understood.

### Input

- LOAD/BOOST single-pointer friendly.
- switch target ≥48dp.
- no simultaneous chord requirement.
- safe pause release only by domain action/skip/teardown.
- no authoritative race during transitions.
- restart/new-run/select-map semantics distinct.
- landscape full-map reach tested on actual devices.

### System

- existing RailGraph/CargoStack/DeliveryLoop regression 0.
- token count/order/rear/footprint parity.
- Combo parity.
- no-input finite survival.
- BOOST always-on not optimal.
- reward/record duplicate 0.
- assisted standard update 0.
- presentation simulation mutation 0.
- same-map restart trace parity for same input.
- first 3 eligible NEW RUN starts unique.
- manual/restart auto-bag consume 0.
- global/per-map record transaction atomic.
- actual pressure boundary without forecast/commit 0.

### Human targets — TEST_VALUE

Minimum 5 participants:

- 4/5 LOAD·switch independent within 3 min.
- 4/5 rear-token LIFO explanation.
- 4/5 one-arrival Combo explanation.
- 4/5 success attributed to load-order/route planning, not only fast tapping.
- 4/5 result advice understood as evidence/fallback, not blame.
- 4/5 restart versus new-map distinction.
- 4/5 current-map versus all-map record distinction.
- 3/5 onboarding not overly interruptive.

### Performance / Accessibility

- Android target 60 FPS, 1% low ≥45 `TARGET`.
- 10-minute no sustained memory growth.
- no per-frame full graph/Scene-tree scan.
- 48dp·safe area.
- color+shape+text/outline.
- 140% localization stress.
- Reduced Motion/mute/haptic-off semantic parity.

## Benchmark Positioning

Reference patterns:

- Mini Metro: escalating survival pressure and learnable failure.
- Conduct THIS!: few inputs and immediate route feedback.
- Railbound: readable carriage-order and route causality.
- Train Valley 2: staged official/user-created content.
- Rail Route: authoritative routing systems separated from presentation.

Do not copy network construction, collision-reflex focus, tycoon depth, automation, or UGC scale before LIFO-route core proof.

## Evidence Boundary

- planning approval ≠ runtime implementation.
- headless pass ≠ product Scene/Android/human quality.
- assisted first-run metrics ≠ standard balance evidence.
- target3 ≠ target100 completion.
- local model/mock ≠ online UGC readiness.
- VS03-01 is implemented; VS03-02~07 remain staged according to package status.

## Decision Gate

- `PASS`: local core and target3 flow prove load-order/route planning, repeat intent, and comprehension.
- `REVISE`: core works but economy, readability, result, signals, maps, or onboarding need adjustment.
- `PIVOT`: players do not recognize load-order·route planning·large unload group as the core.
- `STOP`: comprehension and repeat intent remain absent after bounded revisions.

Online UGC has a separate Production Gate and cannot change the VS result without separate evidence.
