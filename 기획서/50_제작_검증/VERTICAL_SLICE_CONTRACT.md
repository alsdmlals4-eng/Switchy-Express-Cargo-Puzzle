# Vertical Slice Contract

```yaml
status: APPROVED_CONTRACT · GMB001_LOCAL_SCOPE_STAGED
product_implementation: NOT_STARTED_FOR_GMB001
codex_state: CODEX_NOT_READY
online_ugc: DEFERRED_TO_PRODUCTION_GATE
```

## 목표

한 판에서 실제 첫 세션 학습, 적재 선택, 2·3단계 분기 전환, compact token LIFO 하역, 하역 그룹 Combo, 연료 생존, 화물 감속, BOOST 위험 선택이 연결된다. 결과에서 실패를 이해하고 같은 맵 또는 새 공식 맵을 선택하며, 로컬 기록·꾸미기 진행이 다음 판 동기로 이어지는지 목표 품질로 검증한다.

## 포함 — VS-03 Local Scope

### 기존 코어

- Godot 4.7.1 / Android 가로형 기준
- 15×10 connected railway·no dead ends
- 2-state switch 최소 4개·3-state switch 최소 2개
- 색상별 station 2개·pickup 최소 4개
- automatic train movement·LOAD·BOOST
- capacity 8 LIFO CargoStack
- `SX-DEC-014` one-arrival unload-group Combo
- `SX-DEC-015` compact wagon tokens 0~8·rear=LIFO top·compressed footprint
- score·fuel·speed·cargo slowdown·BOOST cost
- fuel-zero end·result·restart
- `SX-DEC-016` actual first-run contextual onboarding

### GMB-001 local integration

- `SX-DEC-017`: immutable RunSummary 기반 실패 원인 1개·다음 행동 1개·neutral fallback
- `SX-DEC-018`: first PREP slight zoom, explicit `FULL_MAP_READY`, active-run fixed full map
- `SX-DEC-019`: local standard records 3종과 gameplay power 없는 대표 cosmetic registry/collection/equip
- `SX-DEC-020`: 대표 `DEFAULT / DUAL_PATH / CURRENCY_ONLY` unlock flow와 atomic local transaction
- `SX-DEC-021`: eligible standard run의 bounded cosmetic-currency calculation·idempotent Profile grant
- `SX-DEC-022`: authoritative difficulty forecast/commit 기반 prewarning와 `CALM/BUSY/INTENSE` signal
- `SX-DEC-023`: exact same-map restart와 fresh mutable RunSession
- `SX-DEC-023/024`: 최소 3개 validated official maps, undiscovered-first selection, discovered-map reselection
- `SX-DEC-025`: official all-map global personal records + official per-map personal records의 atomic local commit
- assisted first run과 standard record/reward/balance evidence 분리
- Android safe area·48dp·Reduced Motion·mute·haptic-off
- headless tests·10-minute soak·representative captures·5명+ first-experience validation 계획

## 제외 — Production / Online Gate

- official 100+ unique layout 목표 완료와 전체 분포 audit
- 100-entry official browser의 최종 제품화
- full user-map editor
- account·upload·publication backend
- server recanonicalization·hash·smoke validation
- PRIVATE/UNLISTED/PUBLIC online publication
- moderation·report·block·quarantine 운영
- online UGC revision-scoped records
- `SX-DEC-026` community signal backend·event journal·anti-abuse
- creator payout·UGC currency reward·rating·comments·followers·leaderboards
- client mock만으로 ONLINE/MODERATION/ANTI_ABUSE/PRIVACY READY 주장
- 광고·결제·에너지·가챠·PvP·guild·실시간 ranking
- iOS 출시 작업

VS-03에서 data model 또는 interface seam을 마련할 수 있으나 online service 완료를 수용 기준으로 삼지 않는다.

## Core Authority Contracts

- gameplay domain이 score·fuel·cargo·route·Combo·difficulty·run end를 소유한다.
- UI·camera·Tween·animation·tutorial·result·collection·browser는 non-authoritative다.
- `FULL_MAP_READY` 전 authoritative run progression·discovery·record commit을 시작하지 않는다.
- animation completion은 cargo·occupancy·record·reward·restart 권위가 아니다.
- map identity, run identity, record transaction, reward event, selection request를 분리한다.
- same-map restart는 이전 mutable object graph를 reset 재사용하지 않고 fresh services를 생성한다.
- currency·unlock·reward·selection·record·Profile writes는 atomic·idempotent 또는 replay-safe다.
- assisted first run은 standard record·goal·variable reward·balance evidence에 비적격이다.
- UI failure나 save retry가 reward·record를 중복 commit하지 않는다.

## Combo Contract — SX-DEC-014

- `combo_count == unload_group_size == try_unload().count`.
- 한 번의 station arrival 안에서 stack top부터 연속 하역된 동일 cargo type 개수다.
- `max_combo`는 run 최대 group size다.
- delivery streak는 없다.
- `speed_bonus`는 독립 `TEST_VALUE`다.
- empty/mismatch arrival은 Combo·score·fuel reward 0이다.
- HUD·result·telemetry·save가 같은 의미를 사용한다.

## Compact Wagon Token Contract — SX-DEC-015

- token count == CargoStack size, 범위 0~8.
- cargo 0이면 locomotive만 표시한다.
- front→rear == stack bottom→top.
- rear token == CargoStack top == HUD first unload item.
- token은 color+shape 이중 부호다.
- load/unload 뒤 count/order/footprint를 같은 domain step에서 갱신한다.
- 권장 `TEST_VALUE`: body 0.22 cell, spacing 0.28, 8-token chain 2.18, trailing footprint ≤3 cells.
- spawn exclusion은 full-size 8-cell wagon이 아니라 실제 compressed footprint intersection을 사용한다.
- curve sampling은 token order를 보존하고 corner cutting을 만들지 않는다.

## First-Session Onboarding — SX-DEC-016

- 실제 첫 endless run: `LOAD → token → first switch → mixed-stack LIFO → Combo → low-fuel BOOST`.
- first LOAD와 first switch 전에만 safe full pause를 요청할 수 있다.
- 일반 run에 branch slow motion을 추가하지 않는다.
- assist `TEST_VALUE`: fuel drain 0.5×, escalation paused, max 120 sec, restore 3 sec, BOOST hint fuel≤35%.
- core complete·skip·timeout 중 먼저 발생한 조건에서 종료한다.
- OnboardingState는 normalized domain events를 소비하고 gameplay를 직접 변경하지 않는다.
- overlay hide·copy advance·animation complete는 step/unpause/reward 조건이 아니다.
- Help는 안내를 재생하지만 assist를 재활성화하지 않는다.

## Result Learning — SX-DEC-017

- score·survival time·max Combo·new record를 유지한다.
- evidence가 충분할 때 cause 1개와 next action 1개만 표시한다.
- weak/tied/damaged/too-short/assisted evidence는 neutral fallback을 사용한다.
- copy는 플레이어를 비난하거나 확률적 사건을 확정 원인으로 단정하지 않는다.
- restart는 primary action이다.

## Camera and Run Gate — SX-DEC-018

- first PREP/READY에서 locomotive 주변 slight zoom `1.20× TEST_VALUE`.
- transition `0.75s TEST_VALUE` 뒤 전체 맵으로 복귀한다.
- `FULL_MAP_READY`를 확인한 뒤 authoritative run clock·spawn·difficulty를 시작한다.
- active run은 고정 전체 맵이며 free pan/zoom을 제공하지 않는다.
- Reduced Motion은 instant/static transition을 사용해도 run timing이 같다.
- restart는 기본적으로 PREP zoom을 반복하지 않는 `TEST_VALUE`다.

## Local Profile / Cosmetics / Unlock / Rewards — SX-DEC-019~021

### Standard records

- `best_score`
- `longest_survival_seconds`
- `best_max_combo`

Eligibility: completed, current ruleset, integrity valid, non-debug/test, non-assisted.

### Cosmetic integrity

- gameplay/stat/collision/camera/readability/record modifier 0.
- representative collection/equip만 VS에서 증명한다.

### Unlock modes

- `DEFAULT`
- `DUAL_PATH`: eligible goal 또는 cosmetic currency
- `CURRENCY_ONLY`: currency only

구매는 goal completion/achievement를 위조하지 않는다. Purchase-first then legitimate goal completion compensation은 bounded·one-time·idempotent다.

### Reward `TEST_VALUE`

- standard eligibility + successful delivery ≥1
- base 10
- delivery +2, cap 10
- highest Combo tier +2/+5/+8
- authoritative standard record update +5 once
- run cap 30
- assisted onboarding completion + delivery: fixed intro 10 once
- no direct survival-time or raw-score currency component
- global+per-map record 동시 갱신도 record reward component는 run당 최대 1회

## Difficulty Communication — SX-DEC-022

- DifficultyDirector 또는 existing equivalent가 schedule·commit을 단독 소유한다.
- immutable forecast/event만 presentation이 소비한다.
- exact internal formula, spawn intervals, multipliers, next threshold timing은 default HUD에 숨긴다.
- `TEST_VALUE`: lead 5s, banner 1.5s, cooldown 8s, CALM/BUSY/INTENSE.
- warning은 최대 2줄이며 board·station·switch·token·fuel·LIFO info를 가리지 않는다.
- assist/pause는 authoritative timers도 멈추고 resume에 wall-clock catch-up을 하지 않는다.
- warning on/off와 Reduced Motion은 같은 authoritative simulation trace를 보존한다.

## Same-Map Restart and Minimum Official Map Set — SX-DEC-023~024

### Restart

- exact official map ID/revision/seed/generator+ruleset versions/signatures 유지.
- new run ID·reward IDs·record transaction·presentation generation 생성.
- score/fuel/cargo/switch/train/spawn/combo/difficulty/warning/onboarding-local/result state 전부 fresh reset.
- incompatible map은 다른 map으로 silent substitution하지 않는다.

### Minimum set for VS

- 최소 3개 official map은 서로 다른 validated layout signatures를 사용한다.
- first eligible `NEW RUN` cycle은 미발견 map을 우선 배정한다.
- `RESTART`와 manual reselection은 automatic bag을 소비하지 않는다.
- discovery는 reconstruction + `FULL_MAP_READY` + authoritative run start 뒤 atomic commit.
- discovered maps는 최소 compact browser/list에서 직접 재선택 가능하다.

100+ official target은 Production Gate이며 fallback/duplicate는 count에서 제외한다. `F58`은 target-100 audit 전 `NOT_MET`다.

## Scoped Official Records — SX-DEC-025 Local Portion

- official global scope: all eligible official maps의 개인 최고값.
- official per-map scope: exact official map identity의 개인 최고값.
- 한 eligible run이 두 scope를 한 atomic transaction으로 평가한다.
- result는 current-map record를 우선 표시하고 실제 global update만 별도로 표시한다.
- global record는 cross-map online fairness leaderboard가 아니다.
- UGC draft/publication data는 VS local official records에 들어오지 않는다.

## Quality Bar

### Readability

- first 3 sec: train/cargo/station/switch 구분.
- active route·preview 판별.
- HUD unload order와 rear token parity.
- color vision 조건에서도 shape 식별.
- Combo와 speed bonus 구분.
- 0/1/4/8 token cargo count와 rear target 식별.
- result cause/action/current-map/global record label 구분.
- difficulty warning과 persistent band가 critical board/HUD를 가리지 않음.
- PREP zoom과 active full map의 차이를 이해.

### Input

- LOAD/BOOST 한 손 입력.
- switch target ≥48dp.
- first LOAD/switch safe pause만 domain action·skip·teardown으로 해제.
- transition 동안 authoritative input/progression race 0.
- restart/new run/choose discovered map semantics 혼동 0.

### System

- 기존 RailGraph/CargoStack/DeliveryLoop regression 0.
- token count/order/rear/footprint parity.
- `combo_count` parity.
- no-input finite survival.
- BOOST always-on not optimal.
- reward/record duplicate commit 0.
- assisted run standard record/reward update 0.
- difficulty presentation simulation mutation 0.
- same-map restart authoritative trace parity for same input sequence.
- first three official eligible NEW RUN starts unique.
- manual/restart consumes auto bag 0.
- global/per-map record transaction atomic.

### Human targets — `TEST_VALUE`

Minimum 5 participants:

- 4/5 LOAD·switch independent within 3 min.
- 4/5 rear-token LIFO explanation.
- 4/5 one-arrival Combo explanation.
- 4/5 result advice understood as evidence/fallback, not blame.
- 4/5 same-map restart versus new-map distinction.
- 4/5 current-map versus all-map personal record distinction.
- 3/5 onboarding not overly interruptive.

### Performance / Accessibility

- target Android 60 FPS, 1% low ≥45 FPS `TARGET`.
- 10-minute run no sustained memory growth.
- no per-frame full graph/Scene-tree scan.
- 48dp·safe area.
- color+shape+text/outline.
- 140% localization stress for new labels.
- Reduced Motion/mute/haptic-off semantic parity.

## Evidence Boundary

- planning approval ≠ runtime implementation.
- headless test ≠ Android/human/product quality.
- assisted first-run metrics ≠ standard balance evidence.
- 3-map VS evidence ≠ 100+ official catalog completion.
- local data model/mock ≠ online UGC readiness.
- current GMB-001 product code·Scene·Resource·asset change is not authorized.

## Decision Gate

- `PASS`: local core and three-map representative flow prove repeat intent and comprehension.
- `REVISE`: core works but economy, map readability, result advice, signal timing, or onboarding needs adjustment.
- `PIVOT`: players do not recognize load-order·route planning·large unload group as the core.
- `STOP`: comprehension and repeat intent remain absent after bounded revisions.

Online UGC has its own later Production Gate and cannot change the VS decision result without separate evidence.
