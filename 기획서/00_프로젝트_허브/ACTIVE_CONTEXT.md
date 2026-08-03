# Active Context

## 현재 상태

```yaml
project: Switchy Express: Cargo Puzzle
stage: VERTICAL_SLICE_IN_PROGRESS · VS03_01_HEADLESS_PASSED
work_mode: IMPLEMENTATION_IN_PROGRESS · SEQUENTIAL_PACKAGES
vs03_01_audit: SX-AUD-006 · PASS · SYNCED
vs03_01_merge: 43972d3d23e931af3dbc81ab9b1c7d942fffb201
core_fun_audit: SX-AUD-007 · PASS_WITH_FOLLOWUPS · SYNCED
core_fun_evidence: EV-USER-017~018
core_fun_merge: a9368617102420639cc2bb83ee2b0c45505958a6
product_implementation: VS03_01_MERGED
codex_state: READY_FOR_BUILD
current_authorized_package: VS03-02
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
- `SX-AUD-007 / EV-USER-017~018` PR #39 canonical merge·correct Sheet 12-tab readback.
- Godot headless `16 cases · 7110 assertions · 0 failures`.

## 현재 실행 권위 — VS03-02

```text
compact cargo token state
→ fractional path 기반 compressed TrainFootprint
→ DeliveryLoop optional occupancy provider
→ pickup spawn/respawn exclusion integration
```

VS03-02에서 금지:

- map/session/restart/selection
- 난이도 union schedule 교정
- Profile/records/rewards/unlocks
- Scene/HUD/result/camera/browser
- onboarding
- target100/UGC/online

## 승인된 미래 순서 — EV-USER-018

```text
VS03-01 · MERGED_AND_VERIFIED
→ VS03-02 · READY_FOR_BUILD · CURRENT
→ VS03-03 · BLOCKED_BY_VS03_02
→ VS03-R1 · BLOCKED_BY_VS03_03
→ VS03-05A · BLOCKED_BY_VS03_R1
→ VS03-04 · BLOCKED_BY_VS03_05A
→ VS03-05B · BLOCKED_BY_VS03_04
→ VS03-06 · BLOCKED_BY_VS03_05B
→ VS03-07 · BLOCKED_BY_VS03_06
```

정본:

```text
기획서/50_제작_검증/CORE_FUN_ALIGNMENT_SYNC_CLOSURE.md
docs/superpowers/specs/2026-08-03-playable-core-before-meta-sequencing-design.md
docs/superpowers/plans/2026-08-03-vs03-core-first-resegmentation.md
docs/superpowers/plans/2026-08-03-vs03-r1-difficulty-authority-alignment.md
docs/superpowers/plans/2026-08-03-vs03-05a-minimal-playable-core-surface.md
```

## 패키지 분리

### VS03-R1

- 30초 speed boundary와 45초 fuel boundary의 union schedule.
- DifficultyDirector가 모든 실제 pressure forecast/commit을 소유.
- 제품 수치·UI·Profile 변경 없음.

### VS03-05A

- board·train·compact token·switch.
- LOAD·BOOST·switch semantic input.
- 최소 HUD·PREP·FULL_MAP_READY·active fixed full-map camera.
- Profile·result·records·rewards·collection·browser 없음.

### VS03-04 / VS03-05B

- 05A 자동 Gate 뒤 Profile single-writer와 장기 진행 구현.
- transaction receipt 준비 뒤 result·collection·map browser 연결.

## Finding 추적

- F86 current consumer drift: fixed.
- F87 difficulty authority split: VS03-R1 plan complete, implementation not started.
- F89 mono-color dominant strategy: evidence gap.
- F90 landscape input: single-pointer/no-chord, device not run.
- F91 meta-before-playable: resolved by approved option C.
- F92 compact token readability: device/human not run.
- F93 benchmark-backed Grill Me process: project Skill updated.

## 현재 미구현·미검증

```yaml
compact_tokens_footprint: NOT_STARTED
official_map_target_3: NOT_RUN
difficulty_union_schedule: NOT_STARTED
minimal_playable_surface: NOT_RUN
profile_records_rewards: NOT_STARTED
result_collection_browser: NOT_STARTED
android_localization_accessibility_human: NOT_RUN
official_map_target_100: NOT_RUN
F58: NOT_MET
ugc_editor_backend_moderation_privacy_community: NOT_STARTED_OR_NOT_RUN
```

## 다음 작업

```text
Sync Closure merge
→ correct Sheet closure SHA + final 12-tab readback
→ latest main에서 VS03-02 TDD 시작
```

## 금지

- VS03-03 이후 package 병렬 시작.
- Profile을 VS03-05A보다 먼저 구현.
- VS03-05A에서 임시 Profile·wallet·record 형식 생성.
- full-cell `train_cells()`를 compact production footprint로 사용.
- presentation이 gameplay/Profile 권위를 소유.
- target100을 VS-03 완료 조건으로 끌어오기.
- local mock/headless PASS를 Android·human·online readiness로 표현.
