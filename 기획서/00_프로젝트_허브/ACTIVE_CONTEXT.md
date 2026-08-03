# Active Context

## 현재 상태

```yaml
project: Switchy Express: Cargo Puzzle
stage: VERTICAL_SLICE_IN_PROGRESS · VS03_02_HEADLESS_PASSED
work_mode: IMPLEMENTATION_IN_PROGRESS · SEQUENTIAL_PACKAGES
vs03_01_audit: SX-AUD-006 · PASS · SYNCED
vs03_01_merge: 43972d3d23e931af3dbc81ab9b1c7d942fffb201
core_fun_audit: SX-AUD-007 · PASS_WITH_FOLLOWUPS · SYNCED
core_fun_merge: a9368617102420639cc2bb83ee2b0c45505958a6
vs03_02_audit: SX-AUD-008 · PASS · MERGED_AND_VERIFIED · SYNCED
vs03_02_evidence: EV-VS03-02-001
vs03_02_merge: cfe6d5ca0c76942720c5c12ad5dc59aaa651b915
product_implementation: VS03_01_AND_02_MERGED
headless_evidence: 19 cases · 7499 assertions · 0 failures
codex_state: READY_FOR_BUILD
current_authorized_package: VS03-03
```

## 핵심 재미

```text
LIFO 적재 순서 계획
→ 목적 역까지의 노선 선행 결정
→ 큰 그룹을 위한 위험·생존 판단
→ BOOST·배송 속도의 전술적 시간 관리
```

보조 시스템은 위 핵심을 학습·반복·확장해야 하며 대체하면 안 된다.

## 완료된 기반

- VS-01/02 철도·열차·화물·LIFO 기반 구현·headless 검증.
- `SX-DEC-014~026`, `SX-OPS-001`, GMB-001 canonical sync.
- `SX-AUD-005 / EV-USER-016` DoR canonical sync.
- VS03-01 PR #37·closure PR #38·Sheet sync.
- RunBalance·RunState·RunSummary·RunController·DifficultyDirector·Combo·BOOST·fuel-zero 기반.
- `SX-AUD-007 / EV-USER-017~018` PR #39/#40 canonical sync.
- VS03-02 PR #41 merge `cfe6d5ca...`와 올바른 Sheet 12-tab readback.
- CompactWagonTokenState·TrainFootprint·DeliveryLoop occupancy provider·respawn exclusion.
- Godot headless `19 cases · 7499 assertions · 0 failures`.

## VS03-02 완료 계약

```text
CargoStack 0..8
→ compact token 0..8
→ front-to-rear = bottom-to-top
→ rear = LIFO top
→ route-history TrainFootprint
→ conservative compressed occupancy
→ optional DeliveryLoop provider
```

- capacity 8 geometry=`2.18` cell, trailing occupied cells=`<=3`.
- 직선·곡선·committed switch path를 따른다.
- null provider는 exact `train.train_cells()` fallback이다.
- pickup·unload mutation마다 compact state를 정확히 1회 sync한다.
- trailing-segment 과소 예약을 RED→GREEN으로 수정했다.

## 현재 실행 권위 — VS03-03

```text
exactly 3 distinct validated official maps
→ immutable MapDefinition / strict MapCatalog
→ fully configured RunSessionFactory
→ same-map restart with fresh mutable services and identities
→ automatic undiscovered-first selection
→ discovered-map semantic reselection domain
```

VS03-03 필수:

- target3와 target100을 분리한다.
- train start cell과 incoming cell을 명시한다.
- session success는 모든 dependency가 구성된 뒤에만 반환한다.
- restart는 같은 map definition을 사용하지만 run/transaction/service identity는 새로 만든다.
- selected/restarted map을 silent substitution하지 않는다.
- raw seed를 player UI에 노출하지 않는다.

VS03-03에서 금지:

- difficulty union schedule 교정
- Profile/records/rewards/unlocks
- product Scene/HUD/result/camera/browser
- onboarding
- target100 generator expansion
- UGC/online

## 승인된 미래 순서

```text
VS03-01 · MERGED_AND_VERIFIED
→ VS03-02 · MERGED_AND_VERIFIED
→ VS03-03 · READY_FOR_BUILD · CURRENT
→ VS03-R1 · BLOCKED_BY_VS03_03
→ VS03-05A · BLOCKED_BY_VS03_R1
→ VS03-04 · BLOCKED_BY_VS03_05A
→ VS03-05B · BLOCKED_BY_VS03_04
→ VS03-06 · BLOCKED_BY_VS03_05B
→ VS03-07 · BLOCKED_BY_VS03_06
```

정본:

```text
기획서/50_제작_검증/VS03_PACKAGE_STATUS.md
기획서/50_제작_검증/VS03_02_IMPLEMENTATION_AUDIT.md
기획서/50_제작_검증/VS03_02_SYNC_CLOSURE.md
docs/superpowers/plans/2026-08-03-vs03-core-first-resegmentation.md
docs/superpowers/plans/2026-08-03-vs03-r1-difficulty-authority-alignment.md
docs/superpowers/plans/2026-08-03-vs03-05a-minimal-playable-core-surface.md
```

## Finding 추적

- F87 difficulty authority split: VS03-R1 plan complete, implementation not started.
- F89 mono-color dominant strategy: evidence gap.
- F90 landscape input: device not run.
- F92 compact token product readability: domain geometry passed; device/human not run.
- F58 target100: NOT_MET.

## 현재 미구현·미검증

```yaml
official_map_target_3: NOT_STARTED
run_session_restart_selection: NOT_STARTED
difficulty_union_schedule: NOT_STARTED
minimal_playable_surface: NOT_RUN
compact_token_product_view: NOT_STARTED
compact_token_human_readability: NOT_RUN
profile_records_rewards: NOT_STARTED
result_collection_browser: NOT_STARTED
android_localization_accessibility_human: NOT_RUN
official_map_target_100: NOT_RUN
F58: NOT_MET
ugc_editor_backend_moderation_privacy_community: NOT_STARTED_OR_NOT_RUN
```

## 다음 작업

```text
latest main에서 VS03-03 별도 TDD branch
→ target3 map identity/catalog
→ fresh RunSession/restart/selection
→ exact-head package Gate
```

## 금지

- VS03-R1 이후 package 병렬 시작.
- target100을 VS03-03 완료 조건으로 끌어오기.
- Profile을 VS03-05A보다 먼저 구현.
- presentation이 gameplay/Profile/map authority를 소유.
- selected/restarted map silent substitution.
- local mock/headless PASS를 Android·human·online readiness로 표현.
