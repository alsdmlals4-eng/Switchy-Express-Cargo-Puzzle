# GMB-001 Grill Me Decision Ledger

```yaml
batch_id: GMB-001
baseline_main: 993c3ed1aaee172be52a8a8899685b419f7f6d97
branch: batch/gmb-001
draft_pr: 29
batch_size: 10
approved_count: 9/10
status: IN_PROGRESS · APPROVED_PENDING_BATCH_MERGE
canonical_main_sync: NOT_YET_MERGED
sheet_state: APPROVED_PENDING_BATCH_MERGE
codex_state: CODEX_NOT_READY
next_decision: SX-DEC-026
```

## 운영 경계

- 이 파일은 `SX-OPS-001`에 따른 `GMB-001` branch authority다.
- 승인 Decision은 동일 ID로 branch·Draft PR·Issue #6·올바른 Google Sheet에 즉시 기록한다.
- 10/10 전에는 main 병합, `SYNCED`, `READY_FOR_BUILD`, 제품 구현을 금지한다.
- 10번째 승인 뒤 신규 Decision을 동결하고 GitHub·PR·Issue·정본·Registry·Sheet 12탭 적대적 전수감사를 수행한다.
- 현재 batch는 설계·TDD 계획만 포함하며 제품 코드·Scene·Resource·asset·runtime 데이터는 변경하지 않는다.

## Batch Inventory

| Slot | Decision | Evidence | 요약 | 상태 | 책임 설계 |
|---:|---|---|---|---|---|
| 1 | `SX-DEC-017` | `EV-USER-006` | 결과에 검증된 실패 원인 1개와 다음 행동 1개, 불확실하면 중립 fallback | APPROVED_PENDING_BATCH_MERGE | `docs/superpowers/specs/2026-08-02-result-failure-feedback-design.md` |
| 2 | `SX-DEC-018` | `EV-USER-007` | 최초 PREP 약한 확대, START 뒤 전체 맵 복귀, active run 고정 전체 맵 | APPROVED_PENDING_BATCH_MERGE | `docs/superpowers/specs/2026-08-02-preparation-zoom-full-map-camera-design.md` |
| 3 | `SX-DEC-019` | `EV-USER-008` | 표준 개인 기록 3종과 성능 없는 cosmetic-only 영구 진행 | APPROVED_PENDING_BATCH_MERGE | `docs/superpowers/specs/2026-08-02-records-cosmetic-only-progression-design.md` |
| 4 | `SX-DEC-020` | `EV-USER-009` | DEFAULT·DUAL_PATH·CURRENCY_ONLY 해금, 목표와 재화 경로 분리 | APPROVED_PENDING_BATCH_MERGE | `docs/superpowers/specs/2026-08-02-goal-or-currency-cosmetic-unlocks-design.md` |
| 5 | `SX-DEC-021` | `EV-USER-010` | 유효 run 기본 재화와 배송·Combo·신기록 bounded 보너스 | APPROVED_PENDING_BATCH_MERGE | `docs/superpowers/specs/2026-08-02-bounded-run-cosmetic-currency-rewards-design.md` |
| 6 | `SX-DEC-022` | `EV-USER-011` | 난이도 상승 전 짧은 경고와 3단계 지속 신호, 내부 공식은 비공개 | APPROVED_PENDING_BATCH_MERGE | `docs/superpowers/specs/2026-08-02-difficulty-escalation-communication-design.md` |
| 7 | `SX-DEC-023` | `EV-USER-012` | RESTART는 같은 map/seed, 새 seed는 100+ 검증 맵 카탈로그 제작에 사용 | APPROVED_PENDING_BATCH_MERGE | `docs/superpowers/specs/2026-08-02-same-seed-restart-curated-map-catalog-design.md` |
| 8 | `SX-DEC-024` | `EV-USER-013` | NEW RUN은 미발견 맵 우선 자동 순환, 발견 맵은 브라우저에서 직접 재선택 | APPROVED_PENDING_BATCH_MERGE | `docs/superpowers/specs/2026-08-02-automatic-map-discovery-and-reselection-design.md` |
| 9 | `SX-DEC-025` | `EV-USER-014` | 공식 global+맵별 기록 병행, data-only 사용자 맵 제작·검증·업로드·공유 플레이 | APPROVED_PENDING_BATCH_MERGE | `docs/superpowers/specs/2026-08-02-hybrid-map-records-and-user-published-maps-design.md` |
| 10 | — | — | — | OPEN | — |

---

## SX-DEC-017 — 결과 화면 실패 학습

```yaml
evidence_id: EV-USER-006
evidence_type: CONFIRMED_USER_DECISION
source: 2026-08-02 conversation · recommended option A approved
```

### 결정

결과 화면은 score·survival time·max Combo·new record를 유지하고, immutable `RunSummary`가 뒷받침하는 실패 원인 1개와 다음 run 행동 1개를 표시한다. 근거가 약하거나 후보가 비슷하면 `NEUTRAL` fallback을 사용한다.

### 보호 계약

- deterministic analyzer만 cause를 결정한다.
- 비난·가짜 반사실·근거 없는 단정 금지.
- UI·animation은 결과 계산·저장·reward·restart 권위가 아니다.
- assisted first run evidence는 일반 run과 분리한다.
- RESTART는 primary action이다.
- threshold·confidence·margin은 `TEST_VALUE`다.

### 문서·상태

- 설계: `docs/superpowers/specs/2026-08-02-result-failure-feedback-design.md`
- 계획: `docs/superpowers/plans/2026-08-02-result-failure-feedback.md`
- 구현·runtime·Android·사람: `NOT_STARTED / NOT_RUN`

### Findings

`F26` 인과 과장 · `F27` 플레이어 비난 · `F28` UI 권위 · `F29` assist evidence 오염 · `F30` 결과 과밀

---

## SX-DEC-018 — 준비 확대 + 운행 중 전체 맵 고정

```yaml
evidence_id: EV-USER-007
evidence_type: CONFIRMED_USER_DECISION
source: 2026-08-02 conversation · option A with preparation zoom refinement
```

### 결정

최초 PREP/READY에서는 기관차와 출발 주변을 약간 확대한다. START 뒤 fuel·timer·difficulty·spawn·board input을 시작하기 전에 전체 맵으로 복귀하며, `FULL_MAP_READY` 뒤 authoritative run을 시작한다. active run은 고정 전체 맵이다.

### 보호 계약

- PREP `1.20×`, transition `0.75s`는 `TEST_VALUE`.
- active run 추적·자동 zoom·회전·free pan·inset 없음.
- Reduced Motion은 즉시 full-map cut.
- 즉시 RESTART는 준비 확대를 반복하지 않고 full-map direct.
- Camera2D·Tween·animation은 run 권위가 아니다.

### 문서·상태

- 설계: `docs/superpowers/specs/2026-08-02-preparation-zoom-full-map-camera-design.md`
- 계획: `docs/superpowers/plans/2026-08-02-preparation-zoom-full-map-camera.md`
- 구현·runtime·Android·사람: `NOT_STARTED / NOT_RUN`

### Findings

`F31` pre-start 공정성 · `F32` 방향 상실 · `F33` 입력 좌표 · `F34` 멀미/재도전 지연 · `F35` interruption deadlock

---

## SX-DEC-019 — 표준 기록 + cosmetic-only 영구 진행

```yaml
evidence_id: EV-USER-008
evidence_type: CONFIRMED_USER_DECISION
source: 2026-08-02 conversation · hybrid A+B approved
```

### 결정

영구 진행은 표준 개인 기록 3종과 성능 없는 꾸미기 해금·장착만 허용한다.

### 보호 계약

- 기록: `best_score`, `longest_survival_seconds`, `best_max_combo`.
- assisted first run·ruleset mismatch·integrity invalid는 표준 기록 비적격.
- cosmetic metadata에 modifier/stat/multiplier/bonus field 금지.
- gameplay·collision·camera·record eligibility parity 유지.
- 누락 cosmetic ID는 category default fallback.
- versioned atomic Profile과 기록/꾸미기 데이터 격리.

### 문서·상태

- 설계: `docs/superpowers/specs/2026-08-02-records-cosmetic-only-progression-design.md`
- 계획: `docs/superpowers/plans/2026-08-02-records-cosmetic-only-progression.md`
- 구현·asset·runtime·Android·사람: `NOT_STARTED / NOT_RUN`

### Findings

`F36` hidden power · `F37` 가독성/collision · `F38` assisted record · `F39` grind/idempotency · `F40` migration/missing content

---

## SX-DEC-020 — 목표 또는 재화 해금 + 재화 전용 꾸미기

```yaml
evidence_id: EV-USER-009
evidence_type: CONFIRMED_USER_DECISION
source: 2026-08-02 conversation · hybrid A+C approved
```

### 결정

꾸미기 mode는 `DEFAULT`, `DUAL_PATH`, `CURRENCY_ONLY`다. DUAL_PATH는 eligible goal 또는 꾸미기 재화 구매, CURRENCY_ONLY는 재화 구매로만 해금한다.

### 보호 계약

- 구매는 목표 완료·업적 표식을 대신하지 않는다.
- 구매 후 목표 완료 시 bounded compensation을 정확히 한 번 지급한다.
- goal evidence는 completed·non-assisted·current ruleset·integrity VALID run만 사용한다.
- debit+unlock과 compensation은 atomic·idempotent transaction.
- CURRENCY_ONLY는 power·real-money exclusivity·limited FOMO를 암시하지 않는다.
- price·compensation은 `TEST_VALUE`.

### 문서·상태

- 설계: `docs/superpowers/specs/2026-08-02-goal-or-currency-cosmetic-unlocks-design.md`
- 계획: `docs/superpowers/plans/2026-08-02-goal-or-currency-cosmetic-unlocks.md`
- 구현·Profile·runtime·Android·사람: `NOT_STARTED / NOT_RUN`

### Findings

`F41` 목표 의미 침식 · `F42` 이중 차감/보상 · `F43` power/FOMO 오해 · `F44` assisted goal farm · `F45` economy pacing

---

## SX-DEC-021 — bounded run 꾸미기 재화 보상

```yaml
evidence_id: EV-USER-010
evidence_type: CONFIRMED_USER_DECISION
source: 2026-08-02 conversation · recommended option C approved
```

### 결정

completed·current ruleset·integrity VALID·non-debug·non-assisted이며 성공 배송 1회 이상인 run에 기본 재화를 지급하고 배송·최고 Combo 단계·authoritative 표준 신기록에 bounded 보너스를 더한다. 생존 시간과 raw score에는 직접 비례 보상을 주지 않는다.

### Formula v1 `TEST_VALUE`

```yaml
base_reward: 10
delivery_reward_each: 2
delivery_reward_cap: 10
combo_tiers: {3: 2, 5: 5, 8: 8}
new_record_reward: 5
new_record_reward_cap_per_run: 5
run_total_cap: 30
onboarding_intro_grant: 10
```

### 보호 계약

- Combo 보너스는 최고 단계 하나만 지급.
- record bonus는 run당 한 번.
- assisted variable reward는 0, 실제 onboarding 완료+배송의 intro grant만 Profile당 한 번.
- reward event ID와 balance+journal atomic·idempotent commit.
- ResultPanel은 committed receipt만 표시하고 RESTART primary 유지.

### 문서·상태

- 설계: `docs/superpowers/specs/2026-08-02-bounded-run-cosmetic-currency-rewards-design.md`
- 계획: `docs/superpowers/plans/2026-08-02-bounded-run-cosmetic-currency-rewards.md`
- 구현·Profile·경제 simulation·runtime·Android·사람: `NOT_STARTED / NOT_RUN`

### Findings

`F46` short/idle farm · `F47` reward snowball · `F48` duplicate grant · `F49` assisted contamination · `F50` record/UI authority

---

## SX-DEC-022 — 난이도 상승 사전 경고 + 지속 신호

```yaml
evidence_id: EV-USER-011
evidence_type: CONFIRMED_USER_DECISION
source: 2026-08-02 conversation · recommended option C approved
```

### 결정

의미 있는 authoritative 난이도 상승 직전에 짧은 사전 경고를 표시하고, commit 뒤 `CALM/BUSY/INTENSE` 3단계 지속 신호를 유지한다. 정확한 내부 formula·step·spawn interval·multiplier는 기본 HUD에 공개하지 않는다.

### Initial `TEST_VALUE`

```yaml
prewarning_lead_seconds: 5.0
banner_visible_seconds: 1.5
banner_cooldown_seconds: 8.0
bands: {CALM: steps 0-1, BUSY: steps 2-3, INTENSE: steps 4+}
```

### 보호 계약

- `DifficultyDirector`만 schedule·commit 권위 보유.
- presentation은 forecast/event를 읽을 뿐 advance·delay·skip·reroll 금지.
- 경고는 simulation pause·input lock·board 가림을 만들지 않는다.
- assist 종료는 fresh forecast, no catch-up.
- restart는 stale warning/callback을 무효화한다.
- warning mode·Reduced Motion은 simulation을 바꾸지 않는다.

### 문서·상태

- 설계: `docs/superpowers/specs/2026-08-02-difficulty-escalation-communication-design.md`
- 계획: `docs/superpowers/plans/2026-08-02-difficulty-escalation-communication.md`
- 구현·runtime·Android·localization·사람: `NOT_STARTED / NOT_RUN`

### Findings

`F51` UI authority · `F52` forecast drift/late warning · `F53` spam/occlusion · `F54` lifecycle stale/catch-up · `F55` accessibility/localization parity

---

## SX-DEC-023 — 같은 map/seed 즉시 재시작 + 100+ 검증 맵 카탈로그

```yaml
evidence_id: EV-USER-012
evidence_type: CONFIRMED_USER_DECISION
source: 2026-08-02 conversation · option A approved with 100+ map catalog refinement
```

### 결정

`RESTART`는 종료 run과 같은 `map_id`, revision, seed, generator/ruleset version, component/layout/content signatures를 사용한다. 새 seed는 runtime reroll이 아니라 offline 맵 제작 입력이며 production 목표는 100개 이상 고유 validated `layout_signature`다.

### 보호 계약

- retry마다 새 `run_id`, reward namespace, telemetry lineage, mutable service graph를 생성한다.
- fuel·score·Combo·CargoStack·switch·train·station·spawn·difficulty·warning·result·transaction state는 초기화한다.
- fallback·duplicate layout은 제품 map count에 포함하지 않는다.
- generator/ruleset 변경은 새 version과 map revision을 요구한다.
- 현재 generator 약 16 topology 제약 때문에 다양성 확장과 target-100 audit가 필수다.
- VS target은 unique validated map 3개와 same-map restart 증거다.

### 문서·상태

- 설계: `docs/superpowers/specs/2026-08-02-same-seed-restart-curated-map-catalog-design.md`
- 계획: `docs/superpowers/plans/2026-08-02-same-seed-restart-curated-map-catalog.md`
- 구현·catalog asset·runtime·Android·사람: `NOT_STARTED / NOT_RUN`

### Findings

`F56` mutable restart leakage · `F57` seed/transaction identity 충돌 · `F58` duplicate/fallback count 부풀림 · `F59` version drift · `F60` catalog-scale QA 실패

---

## SX-DEC-024 — 자동 발견 순환 + 발견 맵 직접 재선택

```yaml
evidence_id: EV-USER-013
evidence_type: CONFIRMED_USER_DECISION
source: 2026-08-02 conversation · recommended option C approved
```

### 결정

`NEW RUN`은 현재 eligible official catalog에서 아직 발견하지 않은 map을 persisted non-replacement shuffle bag으로 먼저 배정한다. 모든 eligible map이 발견된 뒤에는 최근 map을 피하는 replay bag을 사용한다. authoritative run start를 한 번 완료한 stable `map_id`는 RECENT·FAVORITES·ALL DISCOVERED 브라우저에서 직접 재선택할 수 있다.

### 요청 모드

```yaml
RESTART_SAME_MAP:
  same_map: true
  consumes_auto_cycle: false

AUTO_NEW_RUN:
  undiscovered_first: true
  consumes_auto_cycle: committed_run_start_only

SELECT_DISCOVERED_MAP:
  discovered_required: true
  consumes_auto_cycle: false
```

### 보호 계약

- 모든 eligible official map은 처음부터 자동 발견 후보이며 재화·광고·기간·에너지로 잠그지 않는다.
- 발견은 achievement가 아니라 content exposure다. assisted first run도 발견 가능하지만 표준 record·goal·variable reward는 계속 비적격이다.
- 발견·play count·recent·bag 소비는 reconstruction과 `FULL_MAP_READY` 뒤 authoritative run-start commit에서 atomic·idempotent 처리한다.
- selection receipt는 request ID·catalog revision·map ID/revision을 고정하며 duplicate event가 두 map 또는 두 run을 만들지 못한다.
- raw seed·generator version·signature는 UI에 표시하거나 입력받지 않는다.
- manual selection은 discovered+currently eligible official map만 허용하며 automatic bag을 소비하지 않는다.
- stable `map_id` revision은 발견/즐겨찾기를 유지한다. 실질적으로 새 map이면 새 `map_id`를 사용한다.
- retired/removed/quarantined map은 active bag에서 제거하고 unavailable tombstone으로만 보존한다.
- automatic reconstruction failure는 bounded next-candidate 시도를 허용하지만 discovery/bag을 소비하지 않는다.
- manual/restart failure는 다른 map으로 조용히 대체하지 않는다.
- eligible map이 없으면 `NO_ELIGIBLE_MAP`; runtime seed 또는 fallback map을 생성하지 않는다.
- replay recent exclusion `3`, UI density, retention threshold는 `TEST_VALUE`다.

### 브라우저 계약

- sections: `RECENT`, `FAVORITES`, `ALL DISCOVERED`.
- card: localized name/short label, favorite, play count, availability; raw seed 없음.
- undiscovered map은 이름·layout을 나열하지 않고 `discovered / eligible` aggregate progress만 표시한다.
- Result: `RESTART` primary, `NEW RUN` secondary, `CHOOSE MAP` compact entry.
- 48dp, text+icon/shape, 140% localization, Reduced Motion parity.

### Vertical Slice·Production 경계

- VS 3 map: 첫 3회 AUTO start 무중복 발견, 4번째 immediate-repeat 회피, restart bag 무소비, manual discovered-only, save/reload, duplicate idempotency, invalid auto skip/manual no-substitution.
- Production 100+: 첫 100 successful AUTO discovery start가 catalog 불변 시 100 stable map ID를 정확히 한 번씩 노출, replay starvation 없음, additions 우선, retirement 제외, 100-entry UI·Android·localization·accessibility·human evidence.

### 문서·상태

- 설계: `docs/superpowers/specs/2026-08-02-automatic-map-discovery-and-reselection-design.md`
- 계획: `docs/superpowers/plans/2026-08-02-automatic-map-discovery-and-reselection.md`
- 구현·Profile·browser asset·runtime·Android·localization·사람: `NOT_STARTED / NOT_RUN`

### Findings

`F61` replacement random 반복·starvation · `F62` 100-item 선택 과부하·undiscovered content leakage · `F63` manual selection의 auto cycle/restart semantics 오염 · `F64` catalog revision·retirement·migration discovery 손상 · `F65` duplicate UI/reconstruction failure의 wrong-map start

---

## SX-DEC-025 — 전체+맵별 기록 + 사용자 제작 맵 게시·공유

```yaml
evidence_id: EV-USER-014
evidence_type: CONFIRMED_USER_DECISION
source: 2026-08-02 conversation · recommended option C approved plus user map creation/publication requirement
```

### 결정

공식 맵은 전체 개인 기록 3종과 맵별 개인 기록 3종을 함께 보존한다. 사용자는 제한된 인게임 맵 배치 editor에서 data-only layout을 만들고 local validation·creator test를 거쳐 업로드할 수 있다. 서버 재검증과 moderation 경계를 통과한 immutable publication revision은 creator 본인과 다른 사용자가 PRIVATE·UNLISTED·PUBLIC 경로에서 플레이할 수 있다.

### Record scopes

```yaml
OFFICIAL_GLOBAL_PERSONAL:
  key: competitive_ruleset_id

OFFICIAL_PER_MAP_PERSONAL:
  key: map_id + competitive_layout_revision + competitive_ruleset_id

UGC_PER_REVISION_PERSONAL:
  key: published_user_map_revision_id + content_hash + ruleset_id
```

- official eligible run은 global+per-map을 한 transaction으로 비교·갱신한다.
- Result는 현재 맵 신기록을 우선하고 실제 global 갱신만 별도 표시한다.
- 두 scope가 동시에 갱신돼도 SX-DEC-021 record bonus는 run당 한 번이다.
- UGC run은 official global/per-map record를 갱신하지 않는다.
- editor test/local draft는 모든 standard record·goal·reward에 비적격이다.
- published UGC는 exact revision의 UGC 개인 기록만 가질 수 있다.

### Map source identity

```yaml
OFFICIAL_SEEDED:
  reconstruction: seed + generator/ruleset versions + signatures

USER_AUTHORED:
  reconstruction: immutable canonical layout payload + content hash + publication receipt
```

- UGC가 official seed contract를 위조하거나 official map count에 포함되지 않는다.
- 모든 published revision은 immutable이며 수정은 새 revision이다.
- same-map RESTART는 exact source identity를 유지하면서 새 RunIdentity와 fresh mutable service graph를 생성한다.

### Editor contract

초기 허용:

- rail 배치·삭제·회전
- switch 배치·초기 방향
- train start 위치·방향
- station·pickup·spawn marker 배치
- bounded title·description·approved tags
- undo/redo, local save/load, validation, preview, creator test

금지:

- script·plugin·shader·macro
- external image·audio·font·model·URL
- ruleset·score·fuel·speed·reward·record eligibility override
- hidden trigger·network request·arbitrary executable data

### Publication lifecycle

```text
LOCAL_DRAFT
→ LOCAL_VALID
→ UPLOAD_PENDING
→ SERVER_VALIDATING
→ PRIVATE_VALIDATED
→ UNLISTED or PUBLIC_REVIEW_PENDING
→ PUBLIC

failure/operation:
REJECTED_VALIDATION
REJECTED_MODERATION
QUARANTINED
DELISTED_BY_CREATOR
REMOVED_BY_MODERATOR
INCOMPATIBLE
```

- client validation 성공은 publish 승인이 아니다.
- 서버는 schema, canonical hash, object budget, deterministic reconstruction, connectivity/start safety, bounded headless smoke, duplicate signature, text moderation, account/rate limit을 다시 검증한다.
- 동일 upload request ID 재처리는 동일 publication result를 반환한다.
- public moderation 운영 준비가 없으면 PRIVATE+UNLISTED만 feature-flag release한다.

### Playback contract

- creator는 PRIVATE publication을 플레이할 수 있다.
- 다른 사용자는 UNLISTED share code/link 또는 PUBLIC browser를 통해 플레이할 수 있다.
- UGC는 official AUTO_NEW_RUN bag·official discovery progress에 포함되지 않는다.
- content hash·receipt·compatibility 검증 뒤 `FULL_MAP_READY`와 independent RunIdentity를 생성한다.
- unavailable/quarantined UGC를 다른 map으로 silent substitution하지 않는다.
- official progression reward와 community leaderboard는 SX-DEC-026 전까지 비활성이다.

### Moderation·privacy

- publish는 authenticated account를 요구하되 local draft/test는 offline 가능 범위를 유지한다.
- custom text만 moderation 대상이며 custom executable/asset upload는 금지한다.
- report·block·delist·moderator removal·emergency quarantine을 제공한다.
- public creator identity는 공개 display ID만 사용하며 email·IP·precise location은 metadata/telemetry에 노출하지 않는다.
- quotas·rate limits·text lengths·payload limits·moderation thresholds는 `TEST_VALUE`다.

### 문서·상태

- 설계: `docs/superpowers/specs/2026-08-02-hybrid-map-records-and-user-published-maps-design.md`
- 계획: `docs/superpowers/plans/2026-08-02-hybrid-map-records-and-user-published-maps.md`
- 구현·editor·backend·moderation·runtime·Android·privacy·사람: `NOT_STARTED / NOT_RUN`

### Findings

- `F66` 서로 다른 map 난도를 global record 공정 경쟁으로 오해.
- `F67` farm UGC가 official record·goal·reward를 오염.
- `F68` malicious/invalid layout·resource bomb·forged validation upload.
- `F69` in-place UGC revision 변경으로 record identity 혼합.
- `F70` moderation spam·harassment·privacy·operations capacity 실패.

---

## Cross-Decision Protected Contracts

- UI·camera·Tween·animation·result·collection·reward·warning·map browser·editor view는 non-authoritative.
- `FULL_MAP_READY` 전 run progression·discovery·record commit 없음.
- active run은 고정 전체 맵.
- assisted first run은 표준 record·goal·variable reward·balance evidence와 분리되지만 official map discovery는 가능.
- currency·unlock·reward·selection·record·Profile·publication operation은 atomic·idempotent.
- map source identity와 run/transaction/selection/upload identity는 분리.
- same-map restart는 exact official seed identity 또는 exact UGC publication revision을 유지하고 새 mutable service graph를 만든다.
- fallback/duplicate official map은 제품 map count에 포함하지 않는다.
- UGC는 official map count, official auto discovery bag, official record, official reward를 오염하지 않는다.
- automatic official map policy는 favorites·spending·skill·retention prediction·previous performance를 가중치로 사용하지 않는다.
- manual/restart/UGC load failure는 silent different-map substitution을 하지 않는다.
- UGC package는 data-only canonical layout이며 executable/custom asset을 포함하지 않는다.
- published UGC revision은 immutable하고 record는 revision-scoped다.
- global personal record는 all-official-map 개인 최고값이며 online cross-map fairness leaderboard가 아니다.
- balance·timing·price·reward·camera·difficulty band·catalog·recent-window·UI density·UGC quota·moderation threshold는 검증 전 `TEST_VALUE`.

## Adversarial Finding Register

| 범위 | Finding |
|---|---|
| Result | `F26~F30` |
| Camera | `F31~F35` |
| Profile/Cosmetic | `F36~F40` |
| Unlock Economy | `F41~F45` |
| Currency Reward | `F46~F50` |
| Difficulty Signal | `F51~F55` |
| Restart/Map Catalog | `F56~F60` |
| Map Assignment/Browser | `F61~F65` |
| Scoped Records/UGC Publication | `F66~F70` |

현재 설계상 알려진 P0는 없다. `F58`은 generator 다양성·target-100 audit 전까지 `NOT_MET`이다. `F61~F70`은 구현·runtime·backend·moderation·100-entry/UGC UI·Android·privacy·사람 검증 전까지 follow-up 의무다.

## Verification State

```yaml
planning_spec_review: PASS
implementation_plan_review: PASS
product_code_changed: false
scene_resource_asset_changed: false
runtime_feature_tests: NOT_RUN
android: NOT_RUN
human: NOT_RUN
localization: NOT_RUN
economy_simulation: NOT_RUN
map_catalog_target_3: NOT_RUN
map_catalog_target_100: NOT_RUN
map_assignment_three_map_flow: NOT_RUN
map_browser_100_entry: NOT_RUN
scoped_record_runtime: NOT_RUN
ugc_editor: NOT_STARTED
ugc_backend: NOT_STARTED
ugc_server_validation: NOT_RUN
ugc_moderation_operations: NOT_RUN
ugc_privacy_review: NOT_RUN
ugc_two_account_playback: NOT_RUN
batch_status: APPROVED_PENDING_BATCH_MERGE
codex_state: CODEX_NOT_READY
```

## 다음 Grill Me 후보

`SX-DEC-026` — UGC 플레이·제작에 progression reward와 community signal을 어느 범위까지 허용할지 결정한다.

- UGC는 기록·즐겨찾기만 제공하고 reward 없음,
- 플레이어에게 제한된 UGC completion reward 제공,
- creator에게 bounded engagement reward 제공,
- rating/leaderboard까지 포함,
- 또는 anti-abuse 경계를 둔 조합.

상태: `NEXT_GRILL_ME · GMB-001 SLOT 10`.
