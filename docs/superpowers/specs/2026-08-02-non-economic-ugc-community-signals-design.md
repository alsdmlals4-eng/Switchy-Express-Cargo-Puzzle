# SX-DEC-026 — Non-Economic UGC Community Signals Design

```yaml
decision_id: SX-DEC-026
evidence_id: EV-USER-015
status: APPROVED_PENDING_BATCH_MERGE
batch: GMB-001
slot: 10/10
work_mode: TOTAL_PLANNING · REVIEW
implementation_state: NOT_STARTED
runtime_validation: NOT_RUN
backend_validation: NOT_RUN
android_validation: NOT_RUN
human_validation: NOT_RUN
codex_state: CODEX_NOT_READY
```

## 1. Decision

UGC 플레이와 제작에는 초기 progression reward, creator reward, 별점, 댓글, global leaderboard를 제공하지 않는다.

초기 community layer는 다음 비경제적 신호만 허용한다.

- 즐겨찾기
- 서버 검증 고유 플레이어 수
- 서버 검증 유효 플레이 수
- 실제 유효 플레이 뒤 계정당 revision별 1개의 추천
- 신고
- 차단
- 운영 선정 맵

이 신호는 맵을 찾고 다시 플레이하기 위한 탐색 보조이며, 화폐·해금·목표·공식 기록·현금성 보상·제작자 payout의 입력이 아니다.

## 2. Product Rationale

- UGC 경제 보상은 쉬운 맵, self-play, 다계정, 봇, 반복 파밍을 직접 유도한다.
- creator reward는 moderation과 anti-fraud가 준비되지 않은 상태에서 콘텐츠 품질보다 트래픽 조작을 최적화한다.
- 별점과 leaderboard는 작은 초기 표본에서 승자독식 노출과 악성 평가를 만든다.
- Switchy Express는 무한 생존 run이므로 일반 스테이지형 `completion rate`가 핵심 품질 지표가 아니다.
- 초기 목적은 좋은 맵을 저장·공유·발견하는 최소 신뢰 신호를 확보하는 것이다.

## 3. Protected Authority Boundaries

### 3.1 Non-economic invariant

UGC community event는 다음을 직접 또는 간접 갱신할 수 없다.

- cosmetic currency
- unlock state
- goal progress
- official discovery progress
- official global records
- official per-map records
- `SX-DEC-021` run reward
- creator payout or revenue share
- gameplay stats or difficulty
- official automatic map-selection bag

### 3.2 Source separation

```text
OFFICIAL content signals
!=
UGC publication signals
!=
run/reward/record transaction identity
```

UGC signal key:

```text
publication_revision_id
+ content_hash
+ actor_account_id
+ signal_type
```

수정된 사용자 맵은 새 immutable revision이며 이전 revision의 추천·유효 플레이 수·기록을 자동 승계하지 않는다.

### 3.3 UI is non-authoritative

- 버튼 animation은 추천 commit이 아니다.
- optimistic count는 최종 집계가 아니다.
- 클라이언트 로컬 카운터는 공개 수치 권위가 아니다.
- 서버 receipt가 승인한 event만 aggregate에 반영한다.

## 4. Community Signal Model

### 4.1 Favorite

- account-private library signal이다.
- 플레이 전후 어느 시점에도 추가·제거 가능하다.
- 동일 revision에 active favorite는 최대 1개다.
- creator도 자신의 맵을 즐겨찾기할 수 있으나 public popularity 집계에는 사용하지 않는다.
- favorite는 추천과 분리한다.

### 4.2 Verified unique player

고유 플레이어 수는 다음을 모두 충족한 계정만 센다.

- published PRIVATE creator test가 아닌 UNLISTED 또는 PUBLIC revision
- content hash와 publication receipt 검증 성공
- `FULL_MAP_READY` 뒤 authoritative run start 발생
- creator account가 아님
- blocked/quarantined/removed revision이 아님
- 서버 anti-abuse eligibility 통과
- 같은 account+revision은 평생 최대 1회 unique count

IP·device 식별자는 공개 metadata에 포함하지 않는다. 부정행위 탐지에 필요한 privacy-governed backend signal은 별도 보존 정책과 privacy review를 요구한다.

### 4.3 Qualified play

무한 생존 게임이므로 `completion` 대신 `qualified play`를 사용한다.

초기 `TEST_VALUE` 자격은 다음 중 하나 이상을 충족한 정상 종료 run이다.

- authoritative survival time 30초 이상
- successful delivery 1회 이상
- switch interaction과 LOAD 중 각각 1회 이상

추가 조건:

- editor test/local draft/creator PRIVATE test 제외
- assisted/debug/test/integrity-invalid run 제외
- 동일 run event ID 중복 제외
- pause/background time은 survival 자격에 포함하지 않음

이 기준은 품질 판정이 아니라 스팸 클릭을 필터링하는 최소 활동 기준이다.

### 4.4 Recommendation

추천은 다음 조건에서만 가능하다.

- actor는 creator가 아님
- 해당 immutable revision에서 qualified play receipt 보유
- account+revision당 active recommendation 최대 1개
- add/remove는 idempotent
- 반복 run은 추가 추천을 만들지 않음
- blocked account·quarantined map·fraud-ineligible actor는 집계 제외

추천은 “최고 품질”의 절대 평가가 아니라 플레이 후 다른 사람에게 권하고 싶은지 나타내는 단일 신호다.

### 4.5 Report and block

- 신고는 reason code와 bounded optional text를 사용한다.
- 동일 account+revision+reason의 반복 요청은 idempotent하게 처리한다.
- 차단은 actor의 browser/library/share 결과에서 creator와 publication을 숨긴다.
- 신고 수 자체를 공개하지 않는다.
- 신고 급증은 자동 삭제가 아니라 review/quarantine policy 입력이다.

### 4.6 Staff pick

- 운영자가 명시적으로 선정한다.
- UI에 `운영 선정`으로 표시한다.
- 추천 수나 플레이 수의 자동 임계값으로 부여하지 않는다.
- 선정은 재화·creator payout·공식 record 자격을 주지 않는다.
- 선정 취소와 긴급 quarantine이 가능해야 한다.

## 5. Browser and Discovery

초기 PUBLIC browser의 권장 surface:

- NEW: 최근 공개된 검증 revision
- STAFF PICKS: 운영 선정
- SAVED: 사용자 즐겨찾기
- SHARED: UNLISTED 코드·링크로 연 맵
- MY MAPS: 제작자 본인의 draft/publication 상태

초기 제외:

- 별점 평균
- 댓글
- follower count
- most-played leaderboard
- creator leaderboard
- trending algorithm
- 현금성·재화성 추천 보상
- engagement 기반 공식 `NEW RUN` 자동 배정

NEW 목록은 bounded recency와 moderation eligibility만 사용한다. 추천 수·소비·skill·retention prediction을 초기 노출 가중치로 사용하지 않는다.

## 6. Aggregate Rules

서버 authoritative aggregate:

```yaml
unique_players:
  distinct: actor_account_id per publication_revision_id
qualified_plays:
  distinct: run_event_id
recommendations:
  distinct_active: actor_account_id per publication_revision_id
favorites:
  private_to_actor: true
```

- aggregate는 immutable event journal에서 재구축 가능해야 한다.
- event append와 aggregate update는 atomic 또는 replay-safe여야 한다.
- remove recommendation은 새 상태 event로 기록하며 과거 event를 삭제하지 않는다.
- public count는 eventual consistency가 가능하지만 UI는 pending을 final로 표현하지 않는다.
- count가 audit/rebuild 중이면 중립 placeholder를 표시한다.

## 7. Anti-Abuse Boundary

### Required

- authenticated account for public signals
- request ID idempotency
- per-account and per-revision rate limits
- creator self-play exclusion
- duplicate account+revision signal rejection
- bot/sybil risk eligibility layer
- moderation quarantine override
- event journal and aggregate reconciliation
- audit trail for staff pick and moderator actions

### Forbidden shortcuts

- client-declared qualified play
- raw local timer만으로 자격 승인
- 추천 수에 즉시 재화 지급
- 플레이 수에 creator reward 지급
- IP/device fingerprint를 public profile이나 telemetry export에 노출
- 의심 계정이라는 이유로 gameplay result를 조용히 변경
- signal fraud를 official record/reward transaction과 같은 ID로 처리

Anti-abuse rejection은 community aggregate만 제외하며, 정상 gameplay와 개인 UGC record를 silent mutation하지 않는다. 별도 integrity 위반이 검증된 경우에만 해당 run record를 거부한다.

## 8. UX and Accessibility

- `즐겨찾기`와 `추천`을 다른 icon+label로 표시한다.
- 추천 가능 전에는 조건을 짧게 설명한다.
- 추천 성공·취소는 server receipt 후 확정한다.
- 색상만으로 state를 표시하지 않는다.
- 48dp 최소 touch target.
- 140% localization stress.
- Reduced Motion에서는 scale/bounce 없이 static state transition.
- count 변화 animation은 signal authority가 아니다.
- creator 자신의 맵에는 `내 맵` label과 추천 불가 이유를 표시한다.
- quarantined/unavailable map은 다른 맵으로 silent substitution하지 않는다.

## 9. Telemetry

허용 이벤트:

- `ugc_publication_opened`
- `ugc_run_started`
- `ugc_run_qualified`
- `ugc_run_ended`
- `ugc_favorite_added`
- `ugc_favorite_removed`
- `ugc_recommendation_added`
- `ugc_recommendation_removed`
- `ugc_recommendation_rejected`
- `ugc_report_submitted`
- `ugc_creator_blocked`
- `ugc_staff_pick_added`
- `ugc_staff_pick_removed`
- `ugc_signal_aggregate_rebuilt`

금지:

- email·IP·precise location을 gameplay telemetry에 포함
- recommendation으로 reward event 생성
- telemetry callback이 recommendation, record, reward를 직접 commit

## 10. Lifecycle and Failure

### Offline

- favorite는 local pending queue를 허용할 수 있다.
- recommendation은 qualified-play server receipt가 필요하므로 offline final commit을 허용하지 않는다.
- reconnect 시 같은 request ID를 재사용한다.

### Restart and resume

- same-map restart는 새 run ID를 사용한다.
- 이전 run의 qualified status를 새 run에 복사하지 않는다.
- 이미 획득한 recommendation eligibility는 publication revision receipt로 조회할 수 있다.

### Revision update

- 새 revision은 별도 signal aggregate를 시작한다.
- creator가 이전 revision을 delist해도 과거 audit event는 유지한다.
- 새 revision으로 추천을 자동 이전하지 않는다.

### Quarantine

- new starts, recommendations, public discovery를 차단한다.
- 이미 진행 중인 run 처리 정책은 integrity-safe하게 명시한다.
- 공개 aggregate는 숨길 수 있으나 audit log는 유지한다.

## 11. Validation Gates

온라인 community readiness를 주장하려면 최소 다음 증거가 필요하다.

- two-account UNLISTED playback
- creator self-play unique/recommend count 제외
- 동일 account 반복 run unique count 1 유지
- duplicate request idempotency
- recommendation add/remove replay
- qualified play 경계 29.9/30.0초 및 delivery path
- editor test/debug/assisted/integrity-invalid 제외
- quarantine 후 new signal 차단
- event journal→aggregate rebuild parity
- staff-pick audit and removal
- report/block flow
- 100+ publication browser pagination or virtualization
- Android safe area·48dp·140% localization
- privacy review
- moderation operating owner and response procedure
- 5명+ terminology comprehension

Client mock만으로 `ONLINE_READY`, `MODERATION_READY`, `ANTI_ABUSE_READY`를 주장하지 않는다.

## 12. Adversarial Findings

- `F71 SIGNAL_AS_REWARD_LEAK_RISK`: 비경제적 신호가 재화·해금·creator payout으로 새는 위험.
- `F72 SELF_PLAY_SYBIL_BOT_MANIPULATION_RISK`: 제작자·다계정·봇이 플레이와 추천을 조작하는 위험.
- `F73 ENDLESS_COMPLETION_METRIC_MISMATCH`: 무한 생존 run에 completion rate를 적용해 품질을 왜곡하는 위험.
- `F74 EXPOSURE_FEEDBACK_LOOP_RISK`: 초기 추천·플레이 순위가 승자독식 노출을 고착하는 위험.
- `F75 MODERATION_PRIVACY_EVENT_LOG_RISK`: 신고·anti-abuse·운영 log가 개인정보·감사 추적을 훼손하는 위험.

현재 설계상 알려진 P0/P1 open finding은 없다. 모든 finding은 구현·backend·moderation·privacy·Android·사람 검증 전까지 follow-up 의무다.

## 13. Scope Boundary

이번 Decision은 planning only다.

변경하지 않음:

- product code
- Scene/Resource/asset
- runtime rules
- Profile/save data
- UGC backend
- moderation service
- account service
- Android build
- live telemetry

GMB-001 merge는 Decision을 canonicalize할 뿐 기능 완료를 의미하지 않는다.
