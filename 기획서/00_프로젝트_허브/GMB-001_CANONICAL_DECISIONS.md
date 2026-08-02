# GMB-001 Canonical Decisions — SX-DEC-017~026

```yaml
batch_id: GMB-001
operation: SX-OPS-001
decisions: SX-DEC-017~026
evidence: EV-USER-006~015
approval_count: 10/10
status: FROZEN · PREMERGE_AUDIT
implementation_authority: PLANNING_ONLY
codex_state: CODEX_NOT_READY
```

## 권위

이 문서는 `GMB-001_DECISION_LEDGER.md`의 10개 승인 내용을 실행 소비자가 읽기 쉽도록 정리한 canonical consumer다. 상세 계약과 TDD task는 각 spec·plan이 소유한다.

Decision을 병합하는 것은 기능 구현 완료나 `READY_FOR_BUILD` 승격을 의미하지 않는다.

## Decision Set

| Decision | Evidence | 확정 내용 | 상세 정본 |
|---|---|---|---|
| `SX-DEC-017` | `EV-USER-006` | 결과 화면은 기록과 함께 근거 있는 실패 원인 1개·다음 행동 1개를 보여주고 근거가 약하면 중립 fallback을 사용한다. | `docs/superpowers/specs/2026-08-02-result-failure-feedback-design.md` |
| `SX-DEC-018` | `EV-USER-007` | 최초 PREP는 약하게 확대하고 `FULL_MAP_READY` 뒤 실제 run을 시작하며 active run은 고정 전체 맵을 유지한다. | `docs/superpowers/specs/2026-08-02-preparation-zoom-full-map-camera-design.md` |
| `SX-DEC-019` | `EV-USER-008` | 표준 개인 기록 3종과 gameplay power 없는 cosmetic collection/equip만 영구 진행으로 허용한다. | `docs/superpowers/specs/2026-08-02-records-cosmetic-only-progression-design.md` |
| `SX-DEC-020` | `EV-USER-009` | 꾸미기 해금은 `DEFAULT / DUAL_PATH / CURRENCY_ONLY`이며 구매가 목표 달성을 위조하지 않는다. | `docs/superpowers/specs/2026-08-02-goal-or-currency-cosmetic-unlocks-design.md` |
| `SX-DEC-021` | `EV-USER-010` | 유효 일반 run에 기본 재화와 상한 있는 배송·최고 Combo·표준 신기록 보너스를 지급한다. | `docs/superpowers/specs/2026-08-02-bounded-run-cosmetic-currency-rewards-design.md` |
| `SX-DEC-022` | `EV-USER-011` | 난이도 상승은 authoritative forecast 기반 짧은 사전 경고와 `CALM/BUSY/INTENSE` 지속 신호로 전달한다. | `docs/superpowers/specs/2026-08-02-difficulty-escalation-communication-design.md` |
| `SX-DEC-023` | `EV-USER-012` | `RESTART`는 exact same map/seed를 fresh run state로 재구성하고 새 seed는 검증된 공식 맵 카탈로그 제작에 사용한다. | `docs/superpowers/specs/2026-08-02-same-seed-restart-curated-map-catalog-design.md` |
| `SX-DEC-024` | `EV-USER-013` | `NEW RUN`은 미발견 공식 맵을 먼저 무중복 배정하고 발견 맵은 직접 재선택할 수 있다. | `docs/superpowers/specs/2026-08-02-automatic-map-discovery-and-reselection-design.md` |
| `SX-DEC-025` | `EV-USER-014` | 공식 맵은 global+per-map 개인 기록을 병행하고, data-only 사용자 맵은 검증·불변 revision·공유 플레이 구조를 사용한다. | `docs/superpowers/specs/2026-08-02-hybrid-map-records-and-user-published-maps-design.md` |
| `SX-DEC-026` | `EV-USER-015` | UGC는 비경제적 favorite·검증된 play·1추천·report/block·staff pick만 우선 제공하고 reward·rating·leaderboard를 제외한다. | `docs/superpowers/specs/2026-08-02-non-economic-ugc-community-signals-design.md` |

## 공통 보호 계약

- UI·camera·Tween·animation·tutorial·result·browser·editor·community view는 non-authoritative다.
- `FULL_MAP_READY` 전 run progression·discovery·record·community play qualification을 commit하지 않는다.
- official map, UGC publication, run, reward, record, selection, upload, signal identity를 분리한다.
- assisted first run은 표준 기록·목표·변동 보상·밸런스 증거에서 분리한다.
- currency·unlock·reward·selection·record·publication·signal operation은 atomic·idempotent 또는 replay-safe다.
- exact same-map restart는 fresh mutable service graph를 만든다.
- fallback·duplicate official map은 100+ 목표에 포함하지 않는다.
- manual/restart/UGC load failure는 다른 맵으로 silent substitution하지 않는다.
- UGC package는 canonical data only이며 executable/custom asset/ruleset override를 허용하지 않는다.
- UGC record와 community signal은 immutable publication revision에 귀속된다.
- UGC는 official map count·discovery·records·goals·rewards를 갱신하지 않는다.
- community signal은 비경제적이며 wallet·unlock·reward·official selection weight를 변경하지 않는다.
- 모든 balance·timing·catalog·UI·quota·moderation threshold는 검증 전 `TEST_VALUE`다.

## 단계별 구현 범위

### VS-03 / 로컬 Vertical Slice 후보

- `SX-DEC-017`: result insight와 중립 fallback
- `SX-DEC-018`: PREP camera·`FULL_MAP_READY` gate·active full map
- `SX-DEC-019`: local standard records와 cosmetic-only registry/collection의 최소 대표 범위
- `SX-DEC-020`: 대표 unlock mode와 atomic local transaction
- `SX-DEC-021`: bounded local reward calculation·Profile journal
- `SX-DEC-022`: difficulty forecast/commit signal
- `SX-DEC-023`: same-map restart와 **최소 3개** 검증 공식 맵
- `SX-DEC-024`: 최소 3개 공식 맵의 undiscovered-first 흐름과 발견 맵 재선택
- `SX-DEC-025`: official global+per-map **로컬 개인 기록**

### Production / 온라인 후속 Gate

- 공식 카탈로그 100+ unique layout 달성·분포 audit
- 100-entry official browser의 성능·가독성
- UGC data-only editor 전체 기능
- account·upload·publication backend
- server recanonicalization·hash·smoke validation
- PRIVATE/UNLISTED/PUBLIC publication
- moderation·report·block·quarantine 운영
- UGC revision-scoped records의 실제 온라인 저장
- `SX-DEC-026` community signal backend·event journal·anti-abuse
- two-account playback·privacy review·100+ UGC browser

Production 범위가 준비되지 않았다는 이유로 VS-03 로컬 생존 루프 구현을 불필요하게 막지 않는다. 반대로 로컬 mock만으로 온라인 준비 완료를 주장하지 않는다.

## 검증 경계

```yaml
planning: APPROVED
product_code: NOT_CHANGED
runtime: NOT_RUN
android: NOT_RUN
human: NOT_RUN
map_target_3: NOT_RUN
map_target_100: NOT_RUN
ugc_backend: NOT_STARTED
moderation: NOT_RUN
privacy: NOT_RUN
two_account_playback: NOT_RUN
anti_abuse: NOT_RUN
```

## Finding 범위

- `F26~F30`: result learning
- `F31~F35`: camera/run gate
- `F36~F40`: records/cosmetic integrity
- `F41~F45`: unlock economy
- `F46~F50`: bounded rewards
- `F51~F55`: difficulty communication
- `F56~F60`: restart/catalog
- `F61~F65`: assignment/browser
- `F66~F70`: scoped records/UGC publication
- `F71~F75`: community signals/anti-abuse/privacy

`F58`은 공식 generator 다양성·target-100 audit 전까지 `NOT_MET`이다. 다른 runtime/backend/Android/human 항목도 실제 증거 전까지 `NOT_RUN`이다.
