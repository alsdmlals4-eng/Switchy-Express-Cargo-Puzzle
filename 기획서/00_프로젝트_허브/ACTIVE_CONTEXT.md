# Active Context

## 현재 상태

```yaml
project: Switchy Express: Cargo Puzzle
stage: VERTICAL_SLICE_IN_PROGRESS · VS02_RUNTIME_PASSED
work_mode: TOTAL_PLANNING · REVIEW
product_baseline: 4e435a1a6d10ab146197671049da80709fd18c1f
planning_baseline_main: 993c3ed1aaee172be52a8a8899685b419f7f6d97
current_batch: GMB-001 · SX-DEC-017~026 · 10/10
batch_state: FROZEN · PREMERGE_ADVERSARIAL_AUDIT
product_implementation: NOT_STARTED_FOR_GMB001
codex_state: CODEX_NOT_READY
current_audit: GMB-001_PREMERGE_AUDIT.md
```

- VS-01 Issue #4 / PR #9 완료.
- VS-02 Issue #5 / PR #12 완료.
- VS-02 runtime 화물 재생성 누락은 PR #13에서 복구 완료.
- Base v9.4 운영·UI 모션 계약은 PR #15에서 적용 완료.
- `SX-DEC-014/015/016`과 `SX-OPS-001`은 PR #27 및 올바른 Sheet 12탭 readback으로 `SYNCED`다.
- `GMB-001`의 `SX-DEC-017~026`, `EV-USER-006~015`는 모두 사용자 승인됐고 PR #29에 동결됐다.
- 올바른 Sheet `1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo`는 10/10 frozen 상태로 12탭 readback PASS다.
- 제공된 `19Ff...` Sheet는 다른 프로젝트이며 변경하지 않는다.
- 신규 Decision은 GMB-001 closure 전까지 금지한다.

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

상세 정본: `GMB-001_CANONICAL_DECISIONS.md`.

- `SX-DEC-014`: one-arrival unload-group Combo
- `SX-DEC-015`: 1 cargo = 1 compact token, rear=LIFO top, compressed footprint
- `SX-DEC-016`: actual first-run contextual onboarding
- `SX-DEC-017`: evidence-based result insight
- `SX-DEC-018`: PREP zoom + `FULL_MAP_READY` + active full map
- `SX-DEC-019`: standard records + cosmetic-only progression
- `SX-DEC-020`: DEFAULT/DUAL_PATH/CURRENCY_ONLY unlocks
- `SX-DEC-021`: bounded eligible-run cosmetic-currency reward
- `SX-DEC-022`: difficulty prewarning + persistent pressure band
- `SX-DEC-023`: exact same-map restart + validated official catalog
- `SX-DEC-024`: undiscovered-first official map selection + reselection
- `SX-DEC-025`: official global/per-map records + data-only UGC publication design
- `SX-DEC-026`: non-economic UGC community signals

## 단계 경계

### VS-03 로컬 후보

- 생존 경제·Combo·compact tokens·제품 HUD
- result insight·기록·재시작
- PREP camera와 full-map run gate
- local cosmetic registry/unlock/reward representative flow
- difficulty signal
- same-map restart
- 최소 3개 검증 official maps와 discovery/reselection
- official global+per-map local records
- first-run contextual onboarding

### Production / 온라인 후속

- 100+ unique official layout target와 분포 audit
- 100-entry official browser
- full UGC editor
- publication/account/backend/server validation
- PRIVATE/UNLISTED/PUBLIC sharing
- moderation·report·block·quarantine
- online UGC records
- community signal journal·anti-abuse·privacy·two-account evidence

로컬 mock은 online readiness 증거가 아니다. 온라인 후속 범위가 미완료여도 VS-03 핵심 생존 루프 범위를 불필요하게 팽창시키지 않는다.

## 현재 미구현·미검증

- runtime: `SX-DEC-014~026` 전부 또는 대부분 `NOT_STARTED`
- official map target 3/100: `NOT_RUN`
- scoped record runtime: `NOT_RUN`
- UGC editor/backend/moderation/privacy/community: `NOT_STARTED / NOT_RUN`
- Android·localization·accessibility·5명+ human: `NOT_RUN`
- `F58`: generator 다양성·target-100 audit 전까지 `NOT_MET`

## 현재 실행 순서

```text
GMB-001 10/10 FROZEN
→ stale consumer repair
→ final exact-head GitHub/PR/Issue/Sheet audit
→ P0/P1 0 + checks PASS + thread 0
→ PR #29 canonical merge
→ Sheet canonical merge SHA + 12-tab readback
→ Sync Closure PR
→ GMB-001 CLOSED
```

## 금지

- `SX-DEC-027` 추가
- 제품 코드·Scene·Resource·asset·runtime data 변경
- UGC backend를 VS-03 필수 범위로 끌어오기
- client mock만으로 ONLINE/MODERATION/ANTI_ABUSE/PRIVACY READY 주장
- runtime·Android·사람 검증을 실행하지 않고 PASS 표기
- community signal을 reward·unlock·official map weighting에 연결

## 다음 작업

새 Grill Me가 아니다. `GMB-001_PREMERGE_AUDIT.md`의 Gate를 끝까지 수행하고 canonical merge와 Sheet closure를 완료한다.
