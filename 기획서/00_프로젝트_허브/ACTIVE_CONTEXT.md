# Active Context

## 현재 상태

```yaml
project: Switchy Express: Cargo Puzzle
stage: VERTICAL_SLICE_IN_PROGRESS · VS02_RUNTIME_PASSED
work_mode: TOTAL_PLANNING · REVIEW
product_baseline: 4e435a1a6d10ab146197671049da80709fd18c1f
gmb001_decision_merge: 9b63421a5ab4d57adbfcf69d2b6e1bf8e3d17496
current_batch: GMB-001 · SX-DEC-017~026 · 10/10
batch_state: CLOSED
sheet_state: SYNCED · 12_TABS_READBACK_PASS
product_implementation: NOT_STARTED_FOR_GMB001
codex_state: CODEX_NOT_READY
next_gate: G3P_DEFINITION_OF_READY_REVIEW
```

## 완료된 운영 동기화

- `SX-DEC-014~016`과 `SX-OPS-001`: PR #27·Sheet closure 완료.
- `SX-DEC-017~026`, `EV-USER-006~015`: PR #29에서 canonical merge 완료.
- PR #29 Decision 정본 SHA: `9b63421a5ab4d57adbfcf69d2b6e1bf8e3d17496`.
- 올바른 Sheet `1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo`: canonical SHA 반영 후 12탭 readback PASS.
- 역사 행 보존, `30_세계_서사` 무변경, 잘못된 `19Ff...` Sheet 미변경.
- pre-merge 기준: behind 0, planning-only 33 files, Project Contract/Godot success, thread 0, REQUEST_CHANGES 0, P0/P1 0.

## 검증된 제품 기반

- Godot 4.7.1 project·headless runner
- 15×10 connected RailGraph·막다른길 0
- 2/3-state RailSwitch·straight-first·preview parity·target lock
- continuous train movement
- capacity 8 LIFO CargoStack
- LOAD contract·BOOST priority
- station 6·pickup minimum 4/type
- bounded deterministic placement·deferred respawn recovery
- LIFO matching group unload
- 기존 증거: `9 cases / 6915 assertions / 0 failures`

## 확정됐지만 미구현인 계약

정본: `GMB-001_CANONICAL_DECISIONS.md`.

- `SX-DEC-014`: one-arrival unload-group Combo
- `SX-DEC-015`: compact wagon tokens·rear=LIFO top·compressed footprint
- `SX-DEC-016`: actual first-run contextual onboarding
- `SX-DEC-017`: evidence-based result insight
- `SX-DEC-018`: PREP zoom + `FULL_MAP_READY` + active full map
- `SX-DEC-019`: standard records + cosmetic-only progression
- `SX-DEC-020`: DEFAULT/DUAL_PATH/CURRENCY_ONLY unlocks
- `SX-DEC-021`: bounded eligible-run cosmetic-currency reward
- `SX-DEC-022`: difficulty prewarning + persistent pressure band
- `SX-DEC-023`: exact same-map restart + validated official catalog target
- `SX-DEC-024`: undiscovered-first official map selection + reselection
- `SX-DEC-025`: official global/per-map records + data-only UGC publication design
- `SX-DEC-026`: non-economic UGC community signals

Planning approval is not implementation success.

## 단계 경계

### VS-03 로컬 후보

- 생존 경제·Combo·compact tokens·제품 HUD
- result insight·기록·재시작
- PREP camera·full-map run gate
- local cosmetic registry/unlock/reward representative flow
- difficulty signal
- exact same-map restart
- 최소 3개 validated official maps와 discovery/reselection
- official global+per-map local records
- contextual onboarding

### Production / 온라인 후속

- 100+ unique official layout target·분포 audit·scale browser
- full UGC editor
- publication/account/backend/server validation
- PRIVATE/UNLISTED/PUBLIC sharing
- moderation·report·block·quarantine
- online UGC records
- community journal·anti-abuse·privacy·two-account evidence

## 현재 미구현·미검증

```yaml
runtime_SX_DEC_014_026: NOT_STARTED_OR_NOT_RUN
official_map_target_3: NOT_RUN
official_map_target_100: NOT_RUN
F58: NOT_MET
scoped_record_runtime: NOT_RUN
ugc_editor_backend: NOT_STARTED
moderation_privacy_two_account: NOT_RUN
community_anti_abuse: NOT_RUN
android_localization_accessibility_human: NOT_RUN
```

## 다음 실행 순서

```text
G3P Definition of Ready 적대적 재검토
→ existing API/file collision audit
→ package dependency/order audit
→ rollback·save migration boundary 확인
→ 명시적 READY_FOR_BUILD 승인
→ VS-03A → VS-03B → VS-03C → VS-03D
```

## 금지

- GMB-001 closure를 제품 구현 완료 또는 `READY_FOR_BUILD`로 해석
- 제품 코드·Scene·Resource·asset 변경을 별도 승인 없이 시작
- UGC backend를 VS-03 필수 범위로 확장
- client mock만으로 ONLINE/MODERATION/ANTI_ABUSE/PRIVACY READY 주장
- runtime·Android·사람 검증을 실행하지 않고 PASS 표기
- community signal을 reward·unlock·official map weighting에 연결

## 다음 작업

새 Decision을 자동 생성하지 않는다. 다음 단계는 `G3P Definition of Ready` 검토이며, 구현 시작 전 사용자 승인과 상태 승격이 필요하다.
