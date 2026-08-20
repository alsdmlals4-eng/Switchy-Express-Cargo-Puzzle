# Roadmap

Last updated: `2026-08-20 KST`

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
→ Phase-C final review / current-canon sync / Codex package preparation
→ BUILD NOT STARTED
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

## M6 · SX-DEC-059 Release-Near First-Session Vertical Slice

`PLANNING COMPLETE · PHASE-C PACKAGE PREP · BUILD NOT STARTED`

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
new_tutorial_maps: 5_TARGET
T1_T2_shared_map: true
capstone: VS_DEMO_01_REUSE
new_core_mechanic: false
new_generated_visual: false
localization: ko/en/ja/zh-*
responsive: pc_standard + pc_wide_or_ultrawide + mobile_landscape
```

### Implementation boundary

- `FirstSessionDirector + FirstSessionStagePolicy` onboarding sidecar.
- `FiniteMapDefinition` schema v2 unchanged.
- existing `ProductFiniteSlice` / finite domain reused.
- exact map coordinates/JSON/witness authored test-first during BUILD.
- StagePolicy blocks hidden command bypass across UI/keyboard/touch.
- Result uses evidence-safe runtime summary only.

### Gate state

```yaml
user_planning_complete: GRANTED_2026_08_20
phase_c_final_review: IN_PROGRESS_UNTIL_CANON_SYNC_CLEAN_EXIT
implementation_package: PREPARING
codex_handoff: NOT_REQUESTED
build: NOT_STARTED
developer_self_run: NOT_RUN
```

## M7 · SX-DEC-059 technical / release-near build evidence

`NOT_STARTED`

When Codex handoff is explicitly requested and package DoR is closed:

```text
Fresh PowerShell / LOCATION FIRST
→ RED-first implementation tasks
→ full automated regression
→ Windows export/package proof
→ developer self-run + screen QA
```

This milestone cannot claim human/player-experience PASS.

## M8 · Physical / first-contact human validation

`NOT_RUN`

```text
exact acceptance build identity
→ physical smoke on that build
→ Five-person first-contact comprehension
→ EXPAND / REWORK / REPEAT_SLICE / HOLD / STOP
```

Android device validation remains separate and is not implied by PC/package evidence.

## M9 · Production cutover

`BLOCKED_DEFERRED`

Requires separate decision after release-near evidence. No automatic store cutover is authorized.

## Holds / exclusions

```text
BMK-R09 Shareable Route Card → POST_VALIDATION_HOLD
BMK-R10 Editor/UGC → POST_VALIDATION_HOLD
endless/fuel/BOOST/capacity-8/cargo-slowdown/pickup-respawn/switch-auto-reset → NON_CURRENT
Base repin → NOT_AUTHORIZED
PR #154 unmerged reusable pilot → READ_ONLY FOR SX-DEC-059
```
