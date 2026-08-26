# Roadmap

Last updated: `2026-08-26 KST`

## Current authority

```yaml
current_work_instruction: v4.8 · 2026-08-26-r5.4-superset-final · SWITCHY_THIN_ADAPTER
work_instruction_role: USER_PROVIDED_V4_8_R5_4_SUPERSET_FINAL_CONTRACT
source_r5_4_sha256: fdf238c202cfac6d3a824aae49b8ac525fba023e31bba7df6ece64a2790365a0
historical_r4_revision: 2026-08-24-r4
historical_r4_role: USER_PROVIDED_V4_8_R4_CONTRACT
historical_r2_source_sha256: 6f0541048e084746f6777223521361d0339dbfb2e223c70947f694f1c050f508
v4_8_r2_authority_merge_pr: 164
v4_8_r2_authority_merge_main: 98ed1c65d678bfc262c32084bbf0e59368093c2c
base_latest_policy: ALWAYS_REFETCH_CURRENT_COMPLETED_MAIN
fresh_read_bootstrap: PROJECT_GITHUB_NOTION_ONLY_RECONSTRUCTION_REQUIRED
v4_7_adapter: HISTORICAL_ROLLBACK_EVIDENCE
```

이 authority 갱신은 roadmap 범위를 확장하지 않는다. 현재 제품 게이트는 여전히 SX-DEC-059의 Candidate 003 physical/developer/device/human validation이다. r5.4 adoption은 제품 Decision 추가나 056~058 구현 승인이 아니다.

## Current execution overlay

```text
GMB-002 · SX-DEC-027~055
→ finite delivery core + semantic runtime implemented
→ 73 semantic product PNGs runtime-integrated

SX-DEC-056~058
→ additive product-depth planning closed
→ implementation remains separate / blocked where documented

SX-DEC-059
→ release-near first-session Vertical Slice direction approved
→ GM-SX059-01 A approved
→ user explicit "기획완료" GRANTED · 2026-08-20
→ Phase-C final review PASS · SX-AUD-064
→ implementation package spec DoR PASS
→ historical Codex handoff USER_REQUESTED_AND_EXECUTED
→ SX_DEC_059_IMPLEMENTATION: IMPLEMENTED_AUTOMATED
→ five-pass adversarial review CLOSED · SX-AUD-066
→ PR #158 MERGED_MAIN_VERIFIED · main 162e8a0a5e8ddc8472e74a6152e87dc12008e34c
→ Notion implementation post-merge readback PASS
→ Candidate 003 physical visual recheck / developer / device / human evidence gates
```

## M0 · Product baseline

`PASS`

Finite handcrafted delivery puzzle. Historical endless/fuel/BOOST family remains non-current.

## M1 · Representative buildable map

`PASS`

Finite buildable map, blocked cells, structural reachability/preflight and recommended-layout evidence exist.

## M2 · Finite delivery core

`PASS · AUTOMATED`

Free build/refund, manual/auto load, unlimited LIFO, route controls, contiguous TOP unload, time/failure/success/retry.

## M3 · Historical PC Vertical Slice

`IMPLEMENTED · AUTOMATED CORE PASS · PHYSICAL/HUMAN GATES OPEN`

This build proved the finite product pipeline but is **not** the current player-experience acceptance target after SX-DEC-059.

## M4 · Production visual / semantic package

`PASS · PRODUCTION COMPLETE`

```yaml
SX-DEC-053: 39
SX-DEC-054_RUN_2A: 20
SX-DEC-054_BUILD_2B: 8
SX-DEC-054_VFX_2C: 6
total_product_pngs: 73
runtime_integrated: true
runtime_integration_owner: SX-DEC-055
```

## M5 · SX-DEC-055 Runtime Semantic POC

`IMPLEMENTED · MERGED_MAIN_VERIFIED`

```yaml
merge_pr: 151
merge_main: 534a7318b349cd3e784a3467125f9ebd23124d8a
runtime_integrated: true
automated_and_package_evidence: PASS
physical_windows: NOT_RUN
android_device: NOT_RUN
human_comprehension: NOT_RUN
```

No gameplay/scoring/map/save authority was widened.

## M5A · Post-POC acceptance

`SUPERSEDED_AS_PLAYER_EXPERIENCE_TARGET_BY_SX_DEC_059 · STABLE_DEVICE_GATE_ANCHOR`

The original post-055 acceptance gate remains a stable compatibility locator for device/human evidence. Its evidence has **not** been completed or silently inherited by SX-DEC-059.

```text
Windows physical runtime: NOT_RUN
Android device smoke: NOT_RUN
Five-person comprehension: NOT_RUN
```

The next meaningful first-contact acceptance build contains the merged SX-DEC-059 release-near first-session experience. Historical 055 automation/export evidence remains valid only for its bounded implementation/package claims.

## M5B · Product-depth planning held outside 059

### SX-DEC-056
- 056A planning-ready, implementation not authorized.
- 056B blocked by authoritative score/combo runtime.

### SX-DEC-057
- Yard Lab/Mastery planning-ready, implementation not authorized.
- fast/cheap subset blocked by missing Stage-8 track-attribute authority.

### SX-DEC-058
- deterministic Daily/Weekly quality/publishing plan ready.
- implementation/pipeline not authorized.

R09 Shareable Route Card and R10 Editor/UGC remain `POST_VALIDATION_HOLD`.

## M5C · SX-DEC-059 Release-Near First-Session Vertical Slice

`MERGED_MAIN_VERIFIED · FIVE_PASS_AND_INDEPENDENT_REVIEW_CLOSED · PHYSICAL/HUMAN GATES OPEN`

### Player promise

> 내가 만든 선로와 적재 선택이 화물 스택 순서를 만들고, 그 순서를 읽어 분기와 배송을 해결한다.

### Representative flow

```text
T1 Track Connection
→ T2 Cargo/Station + basic manual pickup
→ T3 LIFO/TOP reverse planning
→ T4 selective non-load + revisit
→ T5 Auto ON safe / OFF decision
→ T6 switch execution
→ existing VS_DEMO_01 capstone
→ Result / Retry / Edit
```

### Production scope

```yaml
new_tutorial_maps: 5_IMPLEMENTED
T1_T2_shared_map: true
capstone: VS_DEMO_01_REUSE
new_core_mechanic: false
new_generated_visual: false
localization: ko/en/ja/zh-Hans
zh_Hant: DEFER_UNTIL_RELEASE_TARGET_REQUIRES
responsive: pc_standard + pc_wide_or_ultrawide + mobile_landscape
```

### Implementation boundary

- `FirstSessionDefinition + FirstSessionStagePolicy + FirstSessionDirector + FirstSessionCopy` sidecar.
- `FiniteMapDefinition` schema v2 unchanged.
- existing `ProductFiniteSlice` / finite domain reused.
- map coordinates/JSON/private witness authored test-first during BUILD.
- StagePolicy blocks hidden command bypass across UI/keyboard/touch/board/route requests.
- standalone demo remains compatibility default; product main opts in.
- Result uses evidence-safe runtime summary only.

### Gate state

```yaml
user_planning_complete: GRANTED_2026_08_20
phase_c_final_review: PASS_SX_AUD_064
repository_canon: MERGED_MAIN_VERIFIED
implementation_merge_pr: 158
implementation_merge_main: 162e8a0a5e8ddc8472e74a6152e87dc12008e34c
notion_sync: PASS_POST_PR_158_READBACK_COMPLETE
implementation_package_spec_dor: PASS
execution_preflight: PASS
codex_handoff: USER_REQUESTED_AND_EXECUTED · HISTORICAL_EXECUTION_RECORD
build: MERGED_MAIN_VERIFIED
adversarial_review: FIVE_PASS_AND_INDEPENDENT_REVIEW_CLOSED
current_candidate: SX59-POC-ACCEPT-003
candidate_003_package_pointer: PASS
candidate_003_physical_visual_recheck: NOT_RUN
developer_self_run: NOT_RUN
acceptance_build: UNASSIGNED
```

## M6 · Physical/device/human validation

`NOT_RUN · CURRENT_NEXT_PRODUCT_GATE`

Stable validation sequence:

```text
Candidate 003 Gate 0 physical visual recheck
→ same exact Candidate 003 developer self-run / screen QA
→ audio perceptual QA
→ exact acceptance build identity
→ Windows full physical smoke
→ Android device smoke as a separate platform gate
→ Five-person first-contact comprehension on the exact designated acceptance build
→ EXPAND / REWORK / REPEAT_SLICE / HOLD / STOP
```

```yaml
CANDIDATE 003 PHYSICAL VISUAL RECHECK: NOT_RUN
DEVELOPER SELF-RUN: NOT_RUN
WINDOWS PHYSICAL RUNTIME: NOT_RUN
ANDROID DEVICE SMOKE: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
PLAYER EXPERIENCE: NOT_RUN
```

Android device validation is not implied by PC/package evidence. Human evidence is not implied by developer self-run. Candidate 002 startup PASS is not Candidate 003 corrected visual PASS.

## M7 · Production cutover

`BLOCKED_DEFERRED`

Requires a separate decision after release-near evidence. No merge/build/export result automatically authorizes store release.

## Holds / exclusions

```text
BMK-R09 Shareable Route Card → POST_VALIDATION_HOLD
BMK-R10 Editor/UGC → POST_VALIDATION_HOLD
endless/fuel/BOOST/capacity-8/cargo-slowdown/pickup-respawn/switch-auto-reset → NON_CURRENT
Base repin → NOT_AUTHORIZED
PR #154 reusable pilot → CLOSED_UNMERGED / SUPERSEDED_BY_SX_DEC_059 / DO_NOT_ABSORB
PR #174 r4 draft → PRE_EXISTING_DRAFT / READ_ONLY
```
