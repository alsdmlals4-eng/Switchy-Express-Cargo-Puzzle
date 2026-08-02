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

## Decision Summaries

### SX-DEC-017 — 결과 화면 실패 학습
- 결과 화면은 score·survival time·max Combo·new record를 유지한다.
- immutable `RunSummary` 근거로 실패 원인 1개와 다음 행동 1개를 표시한다.
- 근거가 약하거나 후보가 비슷하면 `NEUTRAL` fallback을 사용한다.
- UI·animation은 결과·저장·reward·restart 권위가 아니다.
- Findings: `F26~F30`.

### SX-DEC-018 — 준비 확대 + 운행 중 전체 맵 고정
- 최초 PREP/READY는 약한 확대, START 뒤 `FULL_MAP_READY` 전에 전체 맵 복귀.
- active run은 고정 전체 맵이며 Camera/Tween은 non-authoritative.
- PREP `1.20×`, transition `0.75s`는 `TEST_VALUE`.
- Findings: `F31~F35`.

### SX-DEC-019 — 표준 기록 + cosmetic-only 영구 진행
- 기록: `best_score`, `longest_survival_seconds`, `best_max_combo`.
- assisted first run·ruleset mismatch·integrity invalid는 표준 기록 비적격.
- cosmetic은 gameplay·collision·camera·record eligibility를 변경하지 않는다.
- Findings: `F36~F40`.

### SX-DEC-020 — 목표 또는 재화 해금 + 재화 전용 꾸미기
- mode: `DEFAULT`, `DUAL_PATH`, `CURRENCY_ONLY`.
- 구매는 목표 완료를 대신하지 않고, 구매 후 목표 완료 compensation은 bounded·one-time.
- debit+unlock과 compensation은 atomic·idempotent.
- Findings: `F41~F45`.

### SX-DEC-021 — bounded run 꾸미기 재화 보상
- completed/current-ruleset/integrity-valid/non-debug/non-assisted이며 배송 1회 이상인 run만 표준 보상 적격.
- `TEST_VALUE`: base10, delivery +2 cap10, Combo 2/5/8, record +5 once, run cap30, intro10 once.
- 생존 시간과 raw score 직접 비례 보상 없음.
- Findings: `F46~F50`.

### SX-DEC-022 — 난이도 상승 사전 경고 + 지속 신호
- authoritative 상승 직전 짧은 경고, commit 뒤 `CALM/BUSY/INTENSE` 지속 신호.
- 정확한 formula·step·spawn interval·multiplier는 기본 HUD에 비공개.
- warning mode와 Reduced Motion은 simulation을 변경하지 않는다.
- Findings: `F51~F55`.

### SX-DEC-023 — 같은 map/seed 재시작 + 100+ 검증 맵 카탈로그
- `RESTART`는 exact map ID/revision/seed/version/signatures를 유지하고 fresh RunIdentity/RunSession을 생성한다.
- 새 seed는 offline 검증 map 제작 입력이며 production 목표는 100+ unique validated layout signatures.
- fallback/duplicate는 map count에서 제외한다.
- Findings: `F56~F60`.

### SX-DEC-024 — 자동 발견 순환 + 발견 맵 직접 재선택
- official `NEW RUN`은 미발견 map을 non-replacement bag으로 먼저 배정한다.
- 발견 map은 RECENT/FAVORITES/ALL DISCOVERED에서 직접 선택한다.
- `RESTART`와 manual selection은 automatic bag을 소비하지 않는다.
- 발견·history·bag 소비는 `FULL_MAP_READY` 뒤 run-start atomic commit.
- Findings: `F61~F65`.

### SX-DEC-025 — 전체+맵별 기록 + 사용자 제작 맵 게시·공유

```yaml
evidence_id: EV-USER-014
evidence_type: CONFIRMED_USER_DECISION
source: 2026-08-02 conversation · recommended option C approved plus user map creation/publication requirement
```

#### Record scopes

```yaml
OFFICIAL_GLOBAL_PERSONAL:
  key: competitive_ruleset_id

OFFICIAL_PER_MAP_PERSONAL:
  key: map_id + competitive_layout_revision + competitive_ruleset_id

UGC_PER_REVISION_PERSONAL:
  key: published_user_map_revision_id + content_hash + ruleset_id
```

- official eligible run은 global+per-map 기록을 한 transaction으로 갱신한다.
- Result는 현재 맵 신기록을 우선하고 실제 global 갱신만 별도 표시한다.
- 두 scope가 갱신돼도 `SX-DEC-021` record bonus는 run당 한 번이다.
- UGC는 official global/per-map records를 갱신하지 않는다.
- editor test/local draft는 standard record·goal·reward에 비적격이다.
- published UGC는 exact immutable revision의 UGC 개인 기록만 가질 수 있다.

#### Map source identity

```yaml
OFFICIAL_SEEDED:
  reconstruction: seed + generator/ruleset versions + signatures

USER_AUTHORED:
  reconstruction: immutable canonical layout payload + content hash + publication receipt
```

- UGC가 official seed contract를 위조하거나 official map count에 포함되지 않는다.
- published revision은 immutable하고 수정은 새 revision이다.
- same-map `RESTART`는 exact source identity와 fresh mutable RunSession을 사용한다.

#### Editor

허용:
- rail·switch·train start·station·pickup·spawn marker 배치,
- bounded title/description/approved tags,
- undo/redo, local save/load, validation, preview, creator test.

금지:
- script/plugin/shader/macro,
- external image/audio/font/model/URL,
- ruleset/score/fuel/speed/reward/record override,
- hidden trigger/network request/arbitrary executable data.

#### Publication lifecycle

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

- client validation은 publish 승인이 아니다.
- 서버가 schema/hash/budget/reconstruction/connectivity/start safety/bounded smoke/duplicate/text moderation/account/rate limit을 재검증한다.
- 동일 upload request ID는 동일 publication result를 반환한다.
- public moderation 운영 준비가 없으면 PRIVATE+UNLISTED만 feature flag로 출시한다.

#### Playback and progression boundary

- creator는 PRIVATE publication을 플레이할 수 있다.
- 다른 사용자는 UNLISTED share 또는 PUBLIC browser를 통해 플레이할 수 있다.
- UGC는 official AUTO_NEW_RUN bag·official discovery progress에 포함되지 않는다.
- content hash·receipt·compatibility 확인 뒤 `FULL_MAP_READY`와 independent RunIdentity를 생성한다.
- unavailable/quarantined map을 다른 map으로 silent substitution하지 않는다.
- UGC progression reward와 community leaderboard는 `SX-DEC-026` 전까지 비활성이다.

#### Moderation·privacy

- publish는 authenticated account를 요구하되 local draft/test는 offline 가능 범위를 유지한다.
- custom text만 moderation하고 custom executable/asset은 금지한다.
- report·block·delist·moderator removal·emergency quarantine을 제공한다.
- public creator identity는 공개 display ID만 사용하고 email·IP·precise location은 metadata/telemetry에 노출하지 않는다.

#### 문서·상태

- 설계: `docs/superpowers/specs/2026-08-02-hybrid-map-records-and-user-published-maps-design.md`
- 계획: `docs/superpowers/plans/2026-08-02-hybrid-map-records-and-user-published-maps.md`
- 구현·editor·backend·moderation·runtime·Android·privacy·사람: `NOT_STARTED / NOT_RUN`

#### Findings

`F66` map 난도와 global record 오해 · `F67` UGC official progression 오염 · `F68` malicious/invalid upload · `F69` revision record identity 혼합 · `F70` moderation/spam/privacy operations 실패

---

## Cross-Decision Protected Contracts

- UI·camera·Tween·animation·result·collection·reward·warning·browser·editor view는 non-authoritative.
- `FULL_MAP_READY` 전 run progression·discovery·record commit 없음.
- active run은 고정 전체 맵.
- assisted first run은 표준 record·goal·variable reward·balance evidence와 분리된다.
- currency·unlock·reward·selection·record·Profile·publication operation은 atomic·idempotent.
- map source identity와 run/transaction/selection/upload identity는 분리한다.
- exact official seed 또는 exact UGC publication revision으로 restart하고 fresh mutable service graph를 생성한다.
- fallback/duplicate official map은 official map count에 포함하지 않는다.
- UGC는 official map count·auto discovery·record·reward를 오염하지 않는다.
- manual/restart/UGC load failure는 silent different-map substitution을 하지 않는다.
- UGC package는 data-only canonical layout이며 executable/custom asset을 포함하지 않는다.
- published UGC revision은 immutable하고 record는 revision-scoped다.
- global record는 all-official-map 개인 최고값이며 online cross-map fairness leaderboard가 아니다.
- 모든 balance/timing/catalog/UI/UGC quota/moderation threshold는 검증 전 `TEST_VALUE`.

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

현재 설계상 알려진 P0는 없다. `F58`은 generator 다양성·target-100 audit 전까지 `NOT_MET`이다. `F61~F70`은 구현·runtime·backend·moderation·UI·Android·privacy·사람 검증 전까지 follow-up 의무다.

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
