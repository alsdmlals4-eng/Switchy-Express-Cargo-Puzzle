# GMB-001 Pre-Merge Adversarial Audit

```yaml
audit_id: GMB-001-PREMERGE-AUDIT
protocol: SX-OPS-001
batch: GMB-001
decisions: SX-DEC-017~026
evidence: EV-USER-006~015
baseline_main: 993c3ed1aaee172be52a8a8899685b419f7f6d97
status: IN_PROGRESS · CANON_CONSUMER_REPAIR
sheet: 10/10_FROZEN_READBACK_PASS
product_implementation: NOT_STARTED
codex_state: CODEX_NOT_READY
```

## 목적

10개 사용자 승인을 대화·branch 문서·PR body에만 남기지 않고 GitHub 권위 문서·Issue·계획·Gate·올바른 Google Sheet 12탭에 같은 의미와 경계로 전파했는지 병합 전에 공격적으로 검증한다.

## Batch Inventory

| Slot | Decision | Evidence | Spec | Plan |
|---:|---|---|---|---|
| 1 | SX-DEC-017 | EV-USER-006 | result-failure-feedback-design | result-failure-feedback |
| 2 | SX-DEC-018 | EV-USER-007 | preparation-zoom-full-map-camera-design | preparation-zoom-full-map-camera |
| 3 | SX-DEC-019 | EV-USER-008 | records-cosmetic-only-progression-design | records-cosmetic-only-progression |
| 4 | SX-DEC-020 | EV-USER-009 | goal-or-currency-cosmetic-unlocks-design | goal-or-currency-cosmetic-unlocks |
| 5 | SX-DEC-021 | EV-USER-010 | bounded-run-cosmetic-currency-rewards-design | bounded-run-cosmetic-currency-rewards |
| 6 | SX-DEC-022 | EV-USER-011 | difficulty-escalation-communication-design | difficulty-escalation-communication |
| 7 | SX-DEC-023 | EV-USER-012 | same-seed-restart-curated-map-catalog-design | same-seed-restart-curated-map-catalog |
| 8 | SX-DEC-024 | EV-USER-013 | automatic-map-discovery-and-reselection-design | automatic-map-discovery-and-reselection |
| 9 | SX-DEC-025 | EV-USER-014 | hybrid-map-records-and-user-published-maps-design | hybrid-map-records-and-user-published-maps |
| 10 | SX-DEC-026 | EV-USER-015 | non-economic-ugc-community-signals-design | non-economic-ugc-community-signals |

Exact filenames are under `docs/superpowers/specs/` and `docs/superpowers/plans/` with the `2026-08-02-` prefix.

## Audit Attacks and Results

### A1 — 승인 왜곡

- 모든 Decision은 사용자의 선택과 추가 조건을 별도 Evidence ID로 보존한다.
- `SX-DEC-023`은 단순 retry seed 선택이 아니라 same-map retry와 100+ 공식 카탈로그 목표를 함께 기록한다.
- `SX-DEC-025`는 기록 정책과 사용자 맵 제작·다른 사용자 플레이 요구를 함께 보존한다.
- `SX-DEC-026`은 C안 그대로 비경제적 신호만 허용한다.

판정: `PASS`.

### A2 — 단계 범위 폭증

공식 100+ 맵, UGC editor/backend/moderation/community를 모두 즉시 VS-03에 넣으면 기존 생존 루프 구현이 온라인 플랫폼 구축으로 팽창한다.

보정:

- VS-03: result/camera/local records/cosmetics/rewards/difficulty/same-map retry/최소 3 official maps/official local per-map records.
- Production/Online: official 100+ target, full UGC editor/publication/backend/moderation/community.

판정: `AUTO_FIX_APPLIED`.

### A3 — 기록 공정성

- official global record는 all-official-map 개인 최고값이며 cross-map 온라인 경쟁 leaderboard가 아니다.
- 공정한 비교 단위는 official per-map record다.
- UGC record는 exact immutable publication revision으로 분리한다.
- 한 run의 global+per-map 동시 갱신은 record reward를 한 번만 발생시킨다.

판정: `PASS_WITH_RUNTIME_FOLLOWUP`.

### A4 — 경제 오염

- editor test/local draft/UGC play/community signal은 official reward·goal·discovery·record를 변경하지 않는다.
- `SX-DEC-026`의 favorite/play/recommend/staff pick은 wallet·unlock·creator payout에 연결하지 않는다.

판정: `PASS_WITH_ARCHITECTURAL_TEST_REQUIRED`.

### A5 — 권위 혼선

UI·animation·camera·tutorial·result·browser·editor·community view는 gameplay, record, reward, publication, signal aggregate 권위를 갖지 않는다.

판정: `PASS`.

### A6 — identity 충돌

분리 대상:

```text
official map identity
UGC publication revision identity
run identity
record transaction identity
reward event identity
selection request identity
upload request identity
community signal request identity
```

판정: `PASS_WITH_IMPLEMENTATION_TEST_REQUIRED`.

### A7 — generator 다양성 과장

현재 generator가 약 16 topology 조합만 제공한다는 분석을 숨기지 않는다. fallback·duplicate layout은 100+ 목표에서 제외한다.

판정: `F58 NOT_MET · MERGE_ALLOWED_AS_PLANNING_FOLLOWUP`.

### A8 — endless game metric mismatch

Switchy Express는 무한 생존형이므로 일반 stage completion rate를 UGC 품질 지표로 사용하지 않는다. `qualified play`는 실제 활동의 최소 anti-spam 자격일 뿐 품질 점수가 아니다.

판정: `F73 AUTO_FIXED`.

### A9 — moderation/privacy 과장

client mock·local UI로 online, moderation, anti-abuse, privacy readiness를 주장하지 않는다. 실제 backend·두 계정·quarantine·event rebuild·privacy review가 필요하다.

판정: `PASS_WITH_PRODUCTION_GATES`.

### A10 — 역사 손실

- SX-DEC-001~016과 기존 구현 evidence를 보존한다.
- 관련 없는 `30_세계_서사` Sheet 행을 변경하지 않는다.
- 다른 프로젝트의 `19Ff...` Sheet를 변경하지 않는다.

판정: `PASS`.

### A11 — stale consumer

초기 검사에서 다음 문서가 `GMB-001 0/10`·`NEXT SX-DEC-017`을 가리켰다.

- START_HERE
- ACTIVE_CONTEXT
- CURRENT_CONFIRMED_DECISIONS
- ROADMAP
- DEVELOPMENT_GATES
- TOTAL_PLANNING_AUDIT
- current Vertical Slice plan
- CODEX_GOAL_VS_03
- GRILL_ME_BATCH_MERGE_PROTOCOL

판정: `P1 STALE_REFERENCE · AUTO_FIX_IN_PROGRESS`.

### A12 — 승인되지 않은 구현 잠입

현재 batch의 허용 변경은 planning 문서뿐이다. product code·Scene·Resource·asset·runtime data가 있으면 병합을 중단한다.

판정: `PENDING_FINAL_CHANGED_FILE_INVENTORY`.

## Google Sheet Audit

Workbook:

```text
ID: 1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo
Title: Switchy Express: Cargo Puzzle
Locale: ko_KR
Timezone: Asia/Seoul
```

10/10 frozen pre-audit readback:

- 12 tabs reread: PASS
- SX-DEC-017~026 present: PASS
- EV-USER-006~015 present: PASS
- branch head recorded: PASS at readback time
- historical rows preserved: PASS
- `30_세계_서사` unchanged: PASS
- wrong Sheet untouched: PASS
- status remains pending/frozen, not prematurely SYNCED: PASS

Final branch-head commit changes after this readback require one final re-sync before merge.

## Open Evidence — Not Merge-Blocking for Planning

- runtime feature tests
- Android device evidence
- localization and accessibility
- economy simulation
- map target 3 and target 100 audits
- three-map discovery flow
- 100-entry official browser
- UGC editor/backend/server validation
- moderation operations
- privacy review
- two-account playback
- community signal backend and anti-abuse
- 5명+ comprehension

These remain `NOT_STARTED / NOT_RUN`; none may be called PASS by this planning merge.

## Merge Gate

Required before authorization:

- [x] exactly 10 Decision/Evidence pairs
- [x] batch frozen; no SX-DEC-027
- [x] Sheet 12-tab frozen readback
- [ ] stale current consumers repaired
- [ ] final exact head captured and Sheet re-synced
- [ ] compare to main behind 0
- [ ] changed files planning-only
- [ ] Project Contract success
- [ ] Godot Tests success
- [ ] unresolved review threads 0
- [ ] REQUEST_CHANGES 0
- [ ] PR open, mergeable, exact-head protected
- [ ] P0/P1 open findings 0

Final result will be recorded as `PASS · MERGE_AUTHORIZED` only after these checks run on the final head.
