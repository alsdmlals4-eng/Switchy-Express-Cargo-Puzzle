# VS-03 Package Status Registry

## 권위

```yaml
status_authority: CURRENT_PACKAGE_STATE_ONLY
vs03_01_audit: SX-AUD-006 · PASS · SYNCED
vs03_01_evidence: EV-VS03-01-001
vs03_01_merge: 43972d3d23e931af3dbc81ab9b1c7d942fffb201
vs03_02_audit: SX-AUD-008 · PASS · MERGED_AND_VERIFIED · SHEET_READBACK_PASS
vs03_02_evidence: EV-VS03-02-001
vs03_02_merge: cfe6d5ca0c76942720c5c12ad5dc59aaa651b915
vs03_03_audit: SX-AUD-010 · PREMERGE_REVIEW
vs03_03_evidence: EV-VS03-03-001 · EXACT_HEAD_GREEN
vs03_03_pr: 46 · MERGE_PENDING
core_fun_audit: SX-AUD-007 · PASS_WITH_FOLLOWUPS · SYNCED
sequencing_evidence: EV-USER-018 · RECOMMENDED_OPTION_C
current_authorized_package: VS03-03
next_authority_after_merge_sync: VS03-R1
future_order_approved: true
```

이 문서는 VS-03 package의 **현재 상태만** 소유한다.

- package 목표·파일 소유권은 `docs/superpowers/plans/2026-08-02-vs03-build-segmentation.md`와 package별 최신 계획을 따른다.
- 승인된 미래 순서는 `docs/superpowers/plans/2026-08-03-vs03-core-first-resegmentation.md`가 소유한다.
- `VS03-R1`은 `docs/superpowers/plans/2026-08-03-vs03-r1-difficulty-authority-alignment.md`를 따른다.
- `VS03-05A`는 `docs/superpowers/plans/2026-08-03-vs03-05a-minimal-playable-core-surface.md`를 따른다.
- 오래된 status/order가 이 문서와 충돌하면 이 문서가 우선한다.
- 이전 package merge·정본 동기화 전 다음 package를 시작하지 않는다.

## 현재 상태

| Package | 상태 | 권위 증거 | 다음 조건 |
|---|---|---|---|
| VS03-01 | `MERGED_AND_VERIFIED · SYNCED` | PR #37/#38 · `SX-AUD-006` | 완료 |
| VS03-02 | `MERGED_AND_VERIFIED · SHEET_SYNCED` | PR #41/#42 · `SX-AUD-008` | 완료 |
| VS03-03 | `IMPLEMENTED_ON_PR · EXACT_HEAD_GREEN · MERGE_PENDING · CURRENT_AUTHORITY` | PR #46 · `SX-AUD-010 · EV-VS03-03-001` | premerge audit·Sheet pending·merge·closure |
| VS03-R1 | `BLOCKED_BY_VS03_03_MERGE_SYNC` | `SX-AUD-007-F87 · EV-USER-018` | VS03-03 merge·Sheet closure |
| VS03-05A | `BLOCKED_BY_VS03_R1` | `EV-USER-018 · OPTION_C` | VS03-R1 merge·sync |
| VS03-04 | `BLOCKED_BY_VS03_05A` | `EV-USER-018 · OPTION_C` | VS03-05A merge·sync |
| VS03-05B | `BLOCKED_BY_VS03_04` | `EV-USER-018 · OPTION_C` | VS03-04 merge·sync |
| VS03-06 | `BLOCKED_BY_VS03_05B` | — | VS03-05B merge·sync |
| VS03-07 | `BLOCKED_BY_VS03_06` | — | VS03-06 merge·sync |

## 승인된 실행 순서

```text
VS03-01 run lifecycle/economy/difficulty · DONE
→ VS03-02 compact token/TrainFootprint/DeliveryLoop occupancy · DONE
→ VS03-03 target3 maps/session/restart/selection · IMPLEMENTED_ON_PR · MERGE_PENDING
→ VS03-R1 difficulty authority alignment
→ VS03-05A minimal playable core surface
→ VS03-04 Profile/records/cosmetics/unlocks/rewards
→ VS03-05B result/collection/map browser
→ VS03-06 contextual onboarding
→ VS03-07 end-to-end integration/evidence handoff
```

공통 hotspot package는 병렬 실행하지 않는다.

## VS03-01 완료 증거

```text
PR #37 merge 43972d3d23e931af3dbc81ab9b1c7d942fffb201
PR #38 closure 9360eff0a97f48f2234fcaf35425f80e94fac445
16 cases · 7110 assertions · 0 failures
```

검증 범위:

- authoritative run lifecycle·pause·fuel-zero one-shot
- time speed/fuel pressure·cargo slowdown·BOOST cost
- unload-group Combo·immutable RunSummary
- deterministic difficulty foundation
- TrainController boundary/history/fractional-path read seam
- 실제 DeliveryLoop 결합

## VS03-02 완료 증거

```text
PR #41 exact head 5477ecd8d7c14c73a62a3c666d15aa4e826a92ab
canonical merge cfe6d5ca0c76942720c5c12ad5dc59aaa651b915
Project Contract 281 PASS
Godot Tests 261 PASS
19 cases · 7499 assertions · 0 failures
changed files 7 · package-owned only
behind 0 · thread 0 · REQUEST_CHANGES 0
```

검증 범위:

- CargoStack `0..8` ↔ compact token `0..8`
- front-to-rear=bottom-to-top, rear=LIFO top
- `0.22 + index×0.28`, capacity 8=`2.18` cell
- 직선·곡선·committed switch route-history sampling
- conservative unique occupancy, trailing `<=3`
- optional DeliveryLoop provider와 exact legacy fallback
- pickup/unload 1회 동기화
- compact spawn/respawn exclusion

상세: `기획서/50_제작_검증/VS03_02_IMPLEMENTATION_AUDIT.md`.

## VS03-03 병합 전 구현 증거

```text
PR #46 · branch agent/vs03-03-map-session-selection
SX-AUD-010 · PREMERGE_REVIEW
EV-VS03-03-001 · EXACT_HEAD_GREEN
31 cases · 7681 assertions · 0 failures
Project Contract 340 PASS
Godot Tests 315 PASS
```

검증 범위:

- target3 checked-in official catalog, distinct layout signatures, fallback 0
- strict identity/revision/layout/content duplicate rejection
- deterministic graph·station·initial pickup reconstruction
- fully configured fresh RunSession service graph
- exact same-map restart with fresh run/transaction/service identities
- automatic undiscovered-first target3 cycle
- manual/restart auto-bag consumption 0
- selection receipt commit after successful session construction only
- duplicate request·forged/mutated receipt rejection
- raw seed public exposure 0
- approved `FUEL_MAX=100`, `FUEL_START=65` authority preservation

상세: `기획서/50_제작_검증/VS03_03_IMPLEMENTATION_AUDIT.md`.

병합·correct Sheet closure 전에는 완료 또는 `VS03-R1_ONLY`를 주장하지 않는다.

## VS03-03 계약

- target3만 VS 범위다. target100은 Production이며 `F58 NOT_MET`를 유지한다.
- `RunSessionFactory`는 완전히 구성된 session만 성공으로 반환한다.
- train start cell과 incoming cell을 명시한다.
- same-map restart는 같은 MapDefinition을 사용하되 run/transaction/service identity는 새로 만든다.
- selected/restarted map을 silent substitution하지 않는다.
- raw seed를 player UI에 노출하지 않는다.
- Profile writer·product Scene·browser presentation은 이 package에서 만들지 않는다.

금지:

- VS03-R1 difficulty authority correction
- product Scene/HUD/result/camera/browser
- Profile/save/records/rewards/unlocks
- onboarding
- generator target100 expansion
- UGC·online

## 유지되는 미검증 경계

```yaml
product_scene_runtime: NOT_RUN
compact_token_visual_assets: NOT_STARTED
compact_token_human_readability: NOT_RUN
F92: EVIDENCE_GAP
android_device: NOT_RUN
soak_10_minute: NOT_RUN
localization_accessibility_runtime: NOT_RUN
economy_simulation: NOT_RUN
monocolor_strategy_validation: NOT_RUN
human_5_plus: NOT_RUN
target100: NOT_RUN
F58: NOT_MET
online_ugc_backend: NOT_RUN
```
