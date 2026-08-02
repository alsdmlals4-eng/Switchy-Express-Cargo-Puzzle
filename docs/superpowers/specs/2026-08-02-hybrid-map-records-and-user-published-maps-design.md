# Hybrid Map Records and User-Published Maps Design

```yaml
decision_id: SX-DEC-025
evidence_id: EV-USER-014
batch_id: GMB-001
batch_slot: 9/10
status: APPROVED_PENDING_BATCH_MERGE
authority: USER_APPROVED_RECOMMENDED_C_PLUS_UGC_PUBLICATION
scope: planning_only
implementation_status: NOT_STARTED
validation_status: NOT_RUN
```

## 결정 요약

1. 공식 맵 기록은 **전체 개인 기록 3종 + 맵별 개인 기록 3종**을 함께 유지한다.
2. 결과 화면에서는 현재 맵의 신기록을 우선 표시하고, 전체 개인 기록도 실제로 갱신된 경우에만 별도로 표시한다.
3. 사용자는 제한된 인게임 맵 배치 편집기에서 맵을 만들고 로컬 테스트할 수 있다.
4. 사용자 맵은 임의 코드·외부 asset이 아닌 canonical layout data로만 업로드한다.
5. 업로드된 맵은 서버 재검증과 moderation 경계를 통과한 뒤 creator 본인, 공유받은 사용자, 또는 public catalog 사용자가 플레이할 수 있다.
6. 공식 맵과 사용자 제작 맵은 catalog, record, discovery, reward namespace를 분리한다.
7. published UGC run은 해당 불변 publication revision의 맵별 개인 기록만 갱신할 수 있으며 공식 전체 기록·공식 맵별 기록을 갱신하지 않는다.
8. editor test run과 local draft run은 어떤 표준 기록·목표·재화 보상도 갱신하지 않는다.
9. UGC progression reward와 community leaderboard는 이번 결정에서 활성화하지 않고 `SX-DEC-026`에서 별도로 결정한다.

## 제품 의도

- 서로 다른 100+ 공식 맵에서 현재 맵 숙련과 장기 개인 최고 기록을 동시에 보존한다.
- 난도가 다른 맵의 점수를 동일한 공정 경쟁으로 오해하지 않도록 record scope를 명시한다.
- 플레이어가 선로·역·분기·시작 배치를 직접 구성하고 다른 사람과 공유할 수 있게 한다.
- 악성 데이터, 성능 폭탄, 무한 재화 파밍, 부적절한 metadata, revision 덮어쓰기로부터 공식 진행과 기록을 보호한다.
- UGC를 공식 검증 맵 수나 공식 자동 발견 순환에 섞지 않는다.

## 용어

### Official Map

`SX-DEC-023`의 offline validated catalog에 포함된 seed 기반 `MapDefinition`이다.

### User Map Draft

creator 기기에서 편집 중인 mutable local layout이다. 서버 권위와 공개 ID가 없으며 표준 run evidence로 사용할 수 없다.

### Published User Map Revision

서버가 canonical payload, compatibility, signatures, moderation state를 승인하고 불변 revision ID를 부여한 사용자 맵이다.

### Map Source Kind

```yaml
OFFICIAL_SEEDED:
  reconstruction_authority: seed + generator/ruleset versions + signatures

USER_AUTHORED:
  reconstruction_authority: immutable canonical layout payload + content hash + ruleset/editor schema versions
```

### Record Scope

```yaml
OFFICIAL_GLOBAL_PERSONAL:
  key: competitive_ruleset_id

OFFICIAL_PER_MAP_PERSONAL:
  key: official_map_competition_key

UGC_PER_REVISION_PERSONAL:
  key: published_user_map_revision_id
```

UGC와 official record는 저장·표시·telemetry에서 서로 다른 namespace를 사용한다.

## 전체 기록 + 맵별 기록 계약

### 기록 필드

각 record scope는 동일한 세 값을 사용한다.

```yaml
best_score: int
longest_survival_seconds: float
best_max_combo: int
```

### Official record commit

적격 공식 run 종료 시 한 번의 transaction으로 다음을 비교·갱신한다.

1. `OFFICIAL_PER_MAP_PERSONAL`
2. `OFFICIAL_GLOBAL_PERSONAL`
3. processed run-summary event journal

한 scope의 저장만 성공하고 다른 scope가 실패한 부분 commit은 허용하지 않는다.

### UGC record commit

적격 published UGC run 종료 시 다음만 갱신한다.

1. `UGC_PER_REVISION_PERSONAL`
2. processed run-summary event journal

다음은 갱신하지 않는다.

- official global records
- official per-map records
- official map discovery count
- official automatic discovery/replay bags

### Record eligibility

```text
common_record_eligible =
    run_completed
    AND integrity_state == VALID
    AND NOT debug_or_test_run
    AND NOT assisted_first_run
    AND ruleset_id == required_ruleset_id

OFFICIAL = common_record_eligible
           AND map_source == OFFICIAL_SEEDED
           AND official_map_is_currently_competitive

UGC = common_record_eligible
      AND map_source == USER_AUTHORED
      AND publication_state == PUBLISHED
      AND exact_published_revision_loaded
      AND server_validation_receipt_valid
      AND NOT creator_editor_test_session
```

### Competition key

공식 맵별 기록은 표시용 revision 숫자만으로 묶지 않는다.

```yaml
official_map_competition_key:
  map_id
  competitive_layout_revision
  competitive_ruleset_id
```

가독성·metadata만 바뀐 revision은 같은 competition key를 유지할 수 있다. 선로·역·pickup·spawn·시작 조건처럼 실제 결과에 영향을 주는 변경은 새 competition key 또는 새 `map_id`를 요구한다.

UGC는 모든 published revision을 불변 경쟁 단위로 본다.

```yaml
ugc_competition_key:
  published_user_map_revision_id
  content_hash
  ruleset_id
```

기존 published revision을 덮어쓰지 않는다. 수정된 사용자 맵은 새 revision으로 publish되며 기록도 분리된다.

## Result UX

결과 화면 우선순위:

1. 핵심 run 결과
2. 현재 맵 신기록
3. 전체 개인 신기록(공식 run에서 실제 갱신된 경우만)
4. 실패 insight
5. committed reward receipt
6. actions

표시 예:

```text
현재 맵 신기록
점수 12,480

전체 개인 신기록
최대 Combo 9
```

UGC 결과는 `사용자 맵 기록`으로 명시하고 `전체 개인 신기록`을 표시하지 않는다.

### 중복 보상 방지

`SX-DEC-021`의 record reward는 run당 최대 한 번이다.

- 현재 맵 기록만 갱신: record bonus 1회
- 전체 기록만 갱신: record bonus 1회
- 두 scope 모두 갱신: record bonus 1회
- UGC 기록 갱신: 현재는 official cosmetic-currency record bonus 0

UGC 보상 활성화 여부는 `SX-DEC-026` 전까지 `DISABLED`다.

## Profile 데이터 계약

```yaml
competitive_records:
  official_global_by_ruleset: Dictionary
  official_per_map_by_competition_key: Dictionary
  ugc_per_revision: Dictionary

processed_record_event_ids: bounded Array[String]

user_map_metadata:
  local_draft_ids: Array[String]
  owned_publication_ids: Array[String]
  bookmarked_publication_ids: Array[String]
  recently_played_publication_ids: Array[String]
```

제약:

- official과 UGC dictionary는 별도 namespace다.
- record 값은 비음수·유한 값으로 정규화한다.
- unknown official key나 removed UGC revision은 tombstone metadata만 유지하고 게임 시작을 막지 않는다.
- migration은 기존 SX-DEC-019 global records를 official global namespace로 보존한다.
- per-map record가 없던 기존 Profile은 빈 dictionary로 시작한다.
- UGC record history는 bounded retention 또는 explicit cleanup policy가 필요하며 exact threshold는 `TEST_VALUE`다.

## User Map Editor 경계

### 허용 기능

초기 editor는 프로젝트의 고정 board 규격과 승인된 tile/tool만 사용한다.

- rail tile 배치·삭제·회전
- switch 배치와 초기 방향
- train start 위치·방향
- station 배치와 승인된 station type
- pickup/spawn marker 배치
- map title·짧은 description·approved tags
- undo/redo
- local validation
- preview
- creator test run

### 금지 기능

- GDScript·shader·binary plugin·macro 업로드
- arbitrary executable data
- 외부 image·audio·font·3D model 업로드
- 임의 URL·HTML·Markdown embedding
- ruleset, score, fuel, speed, reward formula override
- collision·camera·onboarding·record eligibility override
- hidden object·invisible trigger·network request 정의

UGC package는 layout data와 제한된 text metadata만 포함한다.

### Draft identity

```yaml
local_draft_id: locally_unique_uuid
owner_account_id: optional_until_publish
editor_schema_version: string
base_ruleset_id: string
layout_payload: canonical_structured_data
local_content_hash: string
last_saved_at: local_timestamp
```

local draft ID는 publication ID나 record event ID가 아니다.

## Canonical User Map Schema

권장 package:

```yaml
schema_version: ugc_map_v1
board_size: {width: 15, height: 10}
rail_tiles: []
switches: []
train_start: {}
stations: []
pickup_markers: []
spawn_markers: []
metadata:
  title: moderated_text
  description: moderated_text
  tags: approved_enum_list
editor_version: string
ruleset_id: string
```

Canonicalization 규칙:

- 좌표·방향·ID 정렬 순서를 고정한다.
- floating point가 필요한 값은 허용 범위와 정규화 precision을 고정한다.
- dictionary iteration order에 의존하지 않는다.
- unknown field는 reject하거나 versioned migration 후 제거한다.
- canonical bytes에서 `content_hash`와 layout signatures를 계산한다.

## Local Validation

publish 버튼이 활성화되기 전 최소 검사:

- board bounds 준수
- tile/object count cap
- cell overlap 금지
- train start 유일성과 유효 방향
- rail graph connectivity
- switch 연결 유효성
- station·pickup·spawn marker의 허용 cell/rail 관계
- 시작 즉시 충돌·정지·out-of-bounds가 없는지
- 최소 station/pickup 수
- known infinite validation loop·pathological graph 금지
- deterministic reconstruction/signature repeatability
- mobile memory·node budget 예상치 이하
- metadata 길이·허용 문자·tag enum 검사

local validation 성공은 publish 승인이 아니다.

## Creator Test Run

```yaml
run_mode: USER_MAP_EDITOR_TEST
map_source: USER_AUTHORED_LOCAL_DRAFT
record_eligible: false
goal_eligible: false
reward_eligible: false
discovery_eligible: false
telemetry_segment: UGC_EDITOR_TEST
```

creator는 publish 전 draft를 직접 플레이해야 한다. 초기 `TEST_VALUE`는 최소 1회의 authoritative local test-run start와 일정 시간 또는 성공 배송 1회 evidence를 요구할 수 있으나, 자동 validator를 대체하지 않는다.

## Publication Lifecycle

```text
LOCAL_DRAFT
→ LOCAL_VALID
→ UPLOAD_PENDING
→ SERVER_VALIDATING
→ PRIVATE_VALIDATED
→ UNLISTED or PUBLIC_REVIEW_PENDING
→ PUBLIC

failure/abuse paths:
REJECTED_VALIDATION
REJECTED_MODERATION
QUARANTINED
DELISTED_BY_CREATOR
REMOVED_BY_MODERATOR
INCOMPATIBLE
```

### Visibility

- `PRIVATE_VALIDATED`: creator 본인만 서버 사본 플레이 가능.
- `UNLISTED`: publication code/link를 받은 사용자가 플레이 가능.
- `PUBLIC`: moderation과 public eligibility를 통과해 UGC browser에서 발견 가능.

첫 배포에서 public moderation 운영 준비가 부족하면 `PRIVATE + UNLISTED`만 출시하고 `PUBLIC`을 feature flag로 잠글 수 있다.

### Upload request

```yaml
upload_request_id: unique_id
owner_account_id: authenticated_account
local_draft_id: local_reference
canonical_payload: structured_data
content_hash: sha256
client_editor_version: string
ruleset_id: string
requested_visibility: PRIVATE|UNLISTED|PUBLIC
metadata: moderated_fields
```

동일 `upload_request_id` 재처리는 동일 publication result를 반환해야 한다.

### Server authority

서버는 client validation result를 신뢰하지 않고 다음을 다시 수행한다.

- schema/version validation
- canonicalization and hash verification
- object/tile/resource budget
- deterministic reconstruction
- graph/connectivity and start safety
- bounded headless simulation smoke
- duplicate/exact-copy signature check
- text moderation
- account/rate-limit/ban state
- publication quota

서버 승인 receipt 없이 UGC run은 published record-eligible이 아니다.

## Published Identity and Revision

```yaml
user_map_id: ugc:<owner_public_id>:<stable_map_uuid>
published_revision: positive_integer
published_user_map_revision_id: ugc:<owner_public_id>:<stable_map_uuid>@<revision>
content_hash: sha256
server_validation_receipt_id: immutable_id
published_at: server_time
visibility: PRIVATE|UNLISTED|PUBLIC
moderation_state: state
```

- published revision은 immutable.
- 수정은 새 revision upload.
- creator는 visibility 변경·delist를 요청할 수 있지만 과거 run identity와 record tombstone은 보존한다.
- ownership 이전·공동 편집·fork license는 이번 범위가 아니다.

## UGC Playback

### Entry paths

- creator의 `MY MAPS`
- share code/link의 `UNLISTED`
- moderation된 `PUBLIC` UGC browser
- bookmarked/recent UGC

### Start contract

```text
UGC publication reference
→ fetch immutable revision manifest
→ verify content hash and server receipt
→ compatibility check
→ reconstruct USER_AUTHORED map
→ FULL_MAP_READY
→ independent RunIdentity
→ authoritative run start
```

- UGC는 official `AUTO_NEW_RUN` bag에 들어가지 않는다.
- UGC는 official discovered/eligible progress를 늘리지 않는다.
- published revision download 실패 시 다른 UGC나 official map으로 silent substitution하지 않는다.
- same-map `RESTART`는 동일 published revision과 content hash를 사용한다.
- deleted/quarantined revision은 새 run을 시작할 수 없고 neutral unavailable state를 표시한다.

## UGC Browser and Creator UX

### Creator

- local drafts
- validation findings
- test-play status
- upload progress
- publication visibility/state
- revision history
- play count와 bounded aggregate feedback
- delist/report appeal entry

### Player

- map title
- creator display identity
- published revision
- approved tags
- last compatibility status
- personal per-revision records
- bookmark
- report/block controls

초기 public browser는 rating/ranking manipulation을 피하기 위해 chronological·featured·following 등의 최종 ranking을 확정하지 않는다. 구체 discovery/rating 정책은 별도 Decision 대상이다.

## Moderation, Abuse, Privacy

### Content safety

- custom text는 길이 제한, profanity/safety moderation, report queue를 통과한다.
- custom asset과 executable content를 금지해 저작권·malware surface를 줄인다.
- exact official/UGC duplicate, spam upload, misleading title/tag를 탐지한다.
- report reason과 moderator action은 bounded enum으로 기록한다.

### Account and rate limits

- publish에는 authenticated account가 필요하다.
- draft 작성과 local test는 offline account 없이 가능할 수 있다.
- upload/day, active public maps, metadata edit 빈도에 rate limit을 둔다.
- banned/quarantined account publication은 새 public exposure를 얻지 못한다.
- exact quotas는 backend capacity와 moderation staffing 검증 전 `TEST_VALUE`다.

### Privacy

- public creator identity는 account의 공개 display ID만 사용한다.
- email, raw platform identifier, IP, precise location은 map metadata나 telemetry에 노출하지 않는다.
- block은 해당 creator의 public/unlisted recommendations를 숨기되 이미 다운로드된 local cache 정책은 별도 정의한다.

## Compatibility and Takedown

### Compatibility

- publication manifest는 editor schema, ruleset, required feature flags를 포함한다.
- client가 지원하지 않는 revision은 download/start 전에 `INCOMPATIBLE`로 표시한다.
- migration이 gameplay layout을 바꾸면 기존 revision을 변환해 덮어쓰지 않고 새 compatible revision을 만든다.

### Takedown

- creator delist: 새 discovery 차단, 기존 history tombstone 유지.
- moderator removal: download/start 차단, report/audit evidence 보존.
- emergency quarantine: 즉시 start 차단, cached content도 실행 금지.
- record UI는 removed revision의 title 대신 neutral unavailable label로 복구할 수 있다.

## Existing Decision Integration

### SX-DEC-019

기존 global records는 `OFFICIAL_GLOBAL_PERSONAL`로 migration한다. UGC는 별도 namespace이며 cosmetic-only parity를 변경하지 않는다.

### SX-DEC-020 / SX-DEC-021

UGC run은 초기에는 goal, standard currency, record reward에 비적격이다. UGC progression reward는 `SX-DEC-026` 전까지 0이다.

### SX-DEC-023

official map은 seed reconstruction을 유지한다. UGC는 immutable canonical payload와 content hash로 reconstruction한다. 두 source 모두 exact identity restart와 fresh mutable RunSession을 요구한다.

### SX-DEC-024

official automatic discovery bag은 official eligible catalog만 사용한다. UGC browser·bookmarks·recent는 별도 collection이다.

### SX-DEC-017 / SX-DEC-022

result insight와 difficulty presentation은 source와 무관하게 non-authoritative다. UGC가 difficulty schedule이나 warning rule을 override할 수 없다.

## Telemetry

Bounded events:

```yaml
record_commit_evaluated:
  run_id
  map_source
  global_updated_fields
  per_map_updated_fields
  rejection_reason

user_map_draft_validated:
  local_draft_id_hash
  result
  finding_codes

user_map_upload_requested:
  upload_request_id
  requested_visibility
  schema_version

user_map_publication_state_changed:
  publication_revision_id
  previous_state
  next_state
  reason_code

user_map_run_started:
  publication_revision_id
  creator_is_player
  entry_source

user_map_reported:
  publication_revision_id
  reason_code
```

- raw map payload를 ordinary analytics에 저장하지 않는다.
- creator email·IP·private account ID를 product telemetry에 넣지 않는다.
- moderation audit log는 product analytics와 분리한다.

## Validation Gates

### Record Vertical Slice

- official eligible run이 per-map과 global record를 atomic 갱신한다.
- 두 scope가 갱신돼도 reward record bonus는 한 번만 계산된다.
- assisted/debug/integrity-invalid run은 양쪽 official record를 갱신하지 않는다.
- UGC draft/test run은 모든 standard record와 reward를 갱신하지 않는다.
- published UGC run은 exact revision의 UGC per-map record만 갱신한다.
- save migration이 기존 global record를 보존한다.

### UGC Vertical Slice

최소 1개 creator account와 2개 player account, 3개 draft를 사용한다.

- valid draft의 local save/load, undo/redo, deterministic hash.
- invalid overlap/disconnected/start-failure draft publish 차단.
- valid draft creator test run.
- idempotent upload request.
- server validation receipt와 immutable revision.
- private creator playback.
- unlisted share를 통한 다른 사용자 playback.
- public moderation feature flag 경계.
- revision 2 publish 후 revision 1 record/history 보존.
- delist/quarantine 후 새 start 차단.
- custom code/asset/unknown field upload 거부.

### Production Gate

- backend auth/storage/CDN/API availability and retry evidence.
- publish/download p95 latency and payload size budget.
- abuse rate, report handling SLA, moderator capacity.
- rate-limit and ban evasion tests.
- 100+ official maps and growing UGC catalog browser performance.
- Android low-memory download/reconstruction tests.
- localization 140%, screen reader, 48dp, Reduced Motion.
- privacy/data retention review and terms/policy readiness.
- rollback, quarantine, incompatible-version drills.

All quotas, text lengths, payload limits, simulation duration, retention counts, moderation thresholds, and launch visibility remain `TEST_VALUE` until evidence is collected.

## Adversarial Findings

### F66 — MAP_DIFFICULTY_GLOBAL_RECORD_MISLEADING_RISK

서로 다른 난도의 맵에서 나온 전체 최고 기록을 공정한 맵 간 경쟁처럼 오해할 수 있다.

Mitigation: global은 개인 all-map best로만 표시하고 현재 map record를 우선한다. online global leaderboard는 승인하지 않는다.

### F67 — UGC_OFFICIAL_RECORD_REWARD_CONTAMINATION_RISK

쉬운 farm map이 official global record, goals, currency를 오염할 수 있다.

Mitigation: UGC는 official record/discovery/reward namespace에서 완전히 분리하고 `SX-DEC-026` 전까지 progression reward를 0으로 둔다.

### F68 — MALICIOUS_INVALID_MAP_UPLOAD_RISK

비정상 graph, node 폭탄, arbitrary code/asset, forged validation 결과가 client나 backend를 공격할 수 있다.

Mitigation: data-only schema, strict caps, server recanonicalization, deterministic rebuild, bounded simulation, no executable/custom asset upload.

### F69 — UGC_REVISION_RECORD_IDENTITY_RISK

published map을 in-place 수정하면 이전 기록과 다른 layout이 같은 leaderboard/record에 섞인다.

Mitigation: immutable published revisions, content hash, revision-scoped records, no in-place gameplay mutation.

### F70 — MODERATION_SPAM_PRIVACY_OPERATION_RISK

부적절한 text, spam, harassment, creator identity leakage, report backlog가 public UGC를 운영 불가능하게 만들 수 있다.

Mitigation: authenticated publishing, rate limits, moderated text only, report/block/takedown, public display ID, feature-flagged public launch, staffing gate.

## Deferred Decisions

- UGC run의 cosmetic currency·goal·achievement 자격
- creator 보상
- likes/ratings/comments
- public ranking/recommendation algorithm
- per-map online leaderboard and anti-cheat
- collaboration, fork, remix, ownership transfer
- custom visual/audio assets
- offline shared-map cache and download retention
- legal terms, license wording, age/parental controls의 최종 문구

다음 material Decision은 `SX-DEC-026`: UGC 플레이·제작에 progression reward, creator reward, rating/leaderboard를 어느 범위까지 허용할지 결정하는 것이다.
