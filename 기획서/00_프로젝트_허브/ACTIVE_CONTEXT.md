# Active Context

Last updated: `2026-08-26 KST`

이 문서는 **현재 상태·다음 실행 지점·미검증 경계**를 연결하는 resume locator다. fresh GitHub/Notion/actual runtime이 저장 snapshot보다 우선한다. 새 채팅은 과거 대화를 필수 입력으로 요구하지 않고 Project GitHub + Notion에서 상태를 다시 재구성한다.

## Continuation State

```yaml
repository: alsdmlals4-eng/Switchy-Express-Cargo-Puzzle
default_branch: main
project_main_snapshot_before_r4_reconciliation: cf207f29cd4dcabc5796769f0eb0ca6764c2370e
project_live_main_policy: REFRESH_FROM_GITHUB_BEFORE_EXECUTION
engine: Godot 4.7.1-stable
language: GDScript
product_baseline: GMB-002
current_decisions: SX-DEC-027~059
work_instruction: v4.8 · 2026-08-26-r5.4-superset-final · SWITCHY_THIN_ADAPTER
work_instruction_role: USER_PROVIDED_V4_8_R5_4_SUPERSET_FINAL_CONTRACT
source_r5_4_sha256: fdf238c202cfac6d3a824aae49b8ac525fba023e31bba7df6ece64a2790365a0
historical_r4_revision: 2026-08-24-r4
historical_r4_role: USER_PROVIDED_V4_8_R4_CONTRACT
historical_r2_source_sha256: 6f0541048e084746f6777223521361d0339dbfb2e223c70947f694f1c050f508
v4_8_r2_authority_merge_pr: 164
v4_8_r2_authority_merge_main: 98ed1c65d678bfc262c32084bbf0e59368093c2c
v4_7_adapter: HISTORICAL_ROLLBACK_EVIDENCE
base_compatibility_pin: v9.4.3 · HISTORICAL_COMPATIBILITY
base_canon_sync_observation: 862938478cfea6c9db16691900c9c4fdc464f9ff · AUDIT_EVIDENCE_ONLY
base_runtime_authority: ALWAYS_REFETCH_CURRENT_COMPLETED_MAIN
fresh_read_bootstrap: PROJECT_GITHUB_NOTION_ONLY_RECONSTRUCTION_REQUIRED
skill_coverage: CURRENT_REGISTRY_FULL_INVENTORY_TRIGGERED_PROGRESSIVE_LOAD_WITH_EXECUTION_RECEIPT
gpt_local_codex_orchestration: RETIRED
sx_dec_059_merge_pr: 158
sx_dec_059_merge_main: 162e8a0a5e8ddc8472e74a6152e87dc12008e34c
SX_DEC_059_IMPLEMENTATION: MERGED_MAIN_VERIFIED
sx_dec_059_notion_sync: PASS · POST_PR_158_READBACK_COMPLETE
sx_dec_059_adversarial_review: FIVE_PASS_AND_INDEPENDENT_REVIEW_CLOSED · SX-AUD-066
playable_poc_pr: 166
playable_poc_pr_head: 159a3a741ef79b6207be290cc284bd63a5979e72
playable_poc_merge_main: 1bf798cedf28dffba9185edb62fb1c50c108fe90
playable_poc_tree: b3fa0ad93721d7f99614fb6f0bf594c7ce068127
playable_poc_audit: SX-AUD-069 · CLEAN_REVIEW_EXIT
physical_preflight_visual_correction_pr: 171
physical_preflight_visual_correction_main: 9d82b004b2ebf3f7d69d0376c79daae1040e94a4
candidate_003_preparation_pr: 172
candidate_003_preparation_main: 2521f3be600ea950f9893ce45940604c2d0ac88a
current_candidate_pointer: evidence/acceptance/current_poc_candidate.json
historical_candidate: SX59-ACCEPT-001 · SUPERSEDED_FOR_CURRENT_POC
candidate_002: SX59-POC-ACCEPT-002 · HISTORICAL_PHYSICAL_EVIDENCE
candidate_002_windows_physical_startup_smoke: PASS
candidate_002_result: BLOCKED_BY_CONFIRMED_P1_PREFLIGHT_VISUAL_DEFECTS
candidate_002_acceptance_promotion: PROHIBITED
current_candidate: SX59-POC-ACCEPT-003
candidate_003_package_integrity: PASS
candidate_003_pck_integrity: PASS · 472_OF_472
candidate_003_product_texture_packaging: PASS · 73_OF_73
candidate_003_powershell_51_live_download: PASS
candidate_003_physical_visual_recheck: NOT_RUN
acceptance_build: NOT_YET_DESIGNATED
developer_self_run: NOT_RUN
windows_full_physical_runtime: NOT_RUN
audio_perceptual_qa: NOT_RUN
android_device: NOT_RUN
five_person_comprehension: NOT_RUN
player_experience: NOT_RUN
production_cutover: BLOCKED_DEFERRED
sx_dec_056a: PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED
sx_dec_056b: BLOCKED_BY_AUTHORITATIVE_SCORE_COMBO_RUNTIME
sx_dec_057: PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED
sx_dec_058: PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED
pr_154: CLOSED_UNMERGED · SUPERSEDED_BY_059
pr_174: PRE_EXISTING_DRAFT · READ_ONLY
```

`base_canon_sync_observation`은 과거 감사 증거일 뿐 current Base pin이 아니다. 실제 Base 권위는 실행할 때마다 `ALWAYS_REFETCH_CURRENT_COMPLETED_MAIN`으로 다시 결정한다. `source_r5_4_sha256`은 현재 사용자 계약 identity이고 r4/r2 값은 predecessor/provenance다.

## r5.4 execution overlay

r5.4의 Godot/local bootstrap은 실제 authoring/runtime 작업에서만 적용한다.

```text
fresh shell
→ exact LOCATION
→ git fetch/prune + safe ff-only reconciliation when clean
→ official upstream update check
→ compatibility/rollback/canary를 통과한 safe update만 exact pin으로 적용
→ exact Godot Editor/project/session identity
→ authoring/test/runtime/readback
```

동일 Godot binary·프로젝트별 전용 포트를 기본적으로 증식시키지 않는다. compatible host에서는 shared approved exact pins와 provider default fixed ports를 사용하고 exact project/editor/session identity로 격리한다. PowerShell은 local Codex launcher로 사용하지 않는다. 실제 Godot 제품 구현이 새로 필요해지면 `CODEX_GODOT_PRODUCT_IMPLEMENTATION_HANDOFF`로 전환한다. 세부 절차는 최신 Base owner와 project thin adapter가 소유한다.

## Stable Phase-B / post-merge compatibility aliases

```yaml
user_planning_complete_gate: GRANTED
phase_b_final_planning_review: SX-AUD-047 · PASS
build_authority: AUTHORIZED_AFTER_PHASE_B_CANON_SYNC_MERGE
sx_dec_055_runtime_implementation: MERGED_MAIN_VERIFIED
runtime_integrated: true
sx_dec_055_merge_main: 534a7318b349cd3e784a3467125f9ebd23124d8a
canonical_freshness_audit: SX-AUD-025
latest_automated_verified_product_main: 1339a9467312d0ac680725894a9efb59746ec2cc
pc_local_route_and_mid_run_retest: RETEST_REQUIRED
```

059는 이 완료된 055 이력을 덮어쓰지 않고 이후 player-experience target을 추가한다.

## Stable acceptance compatibility anchors

```text
SX-DEC-055: MERGED_MAIN_VERIFIED
ANDROID DEVICE SMOKE: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
PRODUCTION CUTOVER: BLOCKED_DEFERRED
```

## Current product promise

> 선로를 건설해 화물 조우 순서를 설계하고, 적재 선택으로 LIFO를 구성한 뒤, 운행 중 분기 판단으로 계획을 실행하고 결과를 보고 다시 설계하는 finite cargo puzzle.

## Current first-session

```text
T1 Track Connection
→ T2 Cargo/Station + manual pickup prerequisite
→ T3 LIFO/TOP reverse planning
→ T4 selective non-load + revisit
→ T5 Auto ON safe / OFF decision
→ T6 switch execution
→ VS_DEMO_01 Capstone
→ Result / Retry / Edit
```

5 tutorial maps와 deterministic witnesses는 구현·package proof에 포함되어 있다. `VS_DEMO_01`의 기존 capstone 의미와 `FiniteMapDefinition` schema v2는 유지한다.

## Playable POC / physical evidence state

PR #166에서 approved E+D Hybrid product assets를 board/HUD/title/lesson/result에 실제 연결했고, automated baseline은 Godot 111 cases와 Windows/Android packaged runtime proof를 통과했다.

Candidate 002 (`SX59-POC-ACCEPT-002`)는 이후 실제 사용자 Windows 환경에서 exact package verification 뒤 실행됐다.

```yaml
candidate_002_engine: Godot 4.7.1-stable
candidate_002_renderer: OpenGL_3_3_Compatibility
candidate_002_gpu: NVIDIA_GeForce_RTX_3050
candidate_002_windows_physical_startup_smoke: PASS
```

그러나 실제 화면에서 두 P1이 발견됐다.

- top preflight semantic art stretch → Korean problem copy overlap.
- full preflight composition on problem cells → station/cargo identity obscuration risk.

PR #171은 banner를 `HBoxContainer`로 분리해 badge를 112×48 lane에 제한하고, problem cell은 5px outline만 유지하도록 교정했다. gameplay/domain/map/audio/image asset 자체는 변경하지 않았다.

이 player-visible correction 때문에 Candidate 002는 acceptance promotion이 금지되고, 수정된 exact bytes를 가진 Candidate 003이 current validation target이다.

## Candidate 003 exact evidence

```yaml
candidate_id: SX59-POC-ACCEPT-003
corrected_runtime_pr: 171
corrected_runtime_tree: e3b6154a3042808fbc2fc62d5a3c6487e3d2a40f
artifact_workflow_run_id: 32715351609
artifact_zip_sha256: 8b4e630c667b5fd88886878e5a07401c1fe6cfd8f1f9d84b2ab39cb8824923d4
windows_exe_sha256: 1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244
windows_pck_sha256: 2e9634cedd6da49793973f4582e2bd58ea4daae2fec246657edcf58ae360af72
pck_integrity: PASS · 472/472
product_texture_packaging: PASS · 73/73
windows_powershell_5_1_pointer_selected_live_download: PASS
physical_visual_recheck: NOT_RUN
```

Package integrity와 Windows CI/launcher verification은 corrected **physical appearance PASS가 아니다**.

## Playtest / evidence state

Use current owners:
- `evidence/acceptance/current_poc_candidate.json`
- `SX_DEC_059_POC_ACCEPTANCE_CANDIDATE_03.md`
- `SX_DEC_059_POC_DEVELOPER_SELF_RUN_RECORD_03.md`
- `PLAYTEST_PLAN_V4_7_CURRENT.md`
- `SX_DEC_059_FIRST_SESSION_PLAYTEST_DELTA.md`

Historical comparison only:
- `SX_DEC_059_POC_ACCEPTANCE_CANDIDATE_02.md`
- `SX_DEC_059_POC_DEVELOPER_SELF_RUN_RECORD_02.md`
- `SX_AUD_069_PLAYABLE_VISUAL_UX_POC.md`

```text
Candidate 002 physical startup: PASS → blocked by P1 visual findings
→ PR #171 correction: MERGED
→ Candidate 003 package/pointer verification: PASS
→ Candidate 003 physical visual recheck: NOT_RUN
→ developer self-run 8 scenarios: NOT_RUN
→ audio perceptual QA: NOT_RUN
→ exact acceptance build: NOT_YET_DESIGNATED
→ Windows full physical smoke: NOT_RUN
→ Android device smoke: NOT_RUN
→ Five-person first-contact comprehension: NOT_RUN
→ player-experience decision gate: NOT_RUN
```

## Current execution entry

```powershell
$repo = "C:\Users\user\Documents\GitHub\Ninza\Switchy-Express-Cargo-Puzzle"
git -C $repo switch main
git -C $repo pull --ff-only
powershell -ExecutionPolicy Bypass -File "$repo\RUN_SX59_POC_SELF_RUN.ps1"
```

Launcher는 `current_poc_candidate.json`을 읽어 exact current candidate를 선택한다. Candidate ID를 하드코딩하거나 newest build를 추론하지 않는다.

## Candidate 003 Gate 0

```text
A. preflight badge가 compact lane에 있고 Korean problem copy와 겹치지 않는가
B. disconnected station/cargo의 색+shape+text identity가 보이고 problem reinforcement는 outline뿐인가
```

둘 중 하나라도 실패하면 `BLOCKED_P1_VISUAL`; 이후 Scenario를 진행하지 않는다. 둘 다 PASS일 때만 같은 exact Candidate 003으로 8개 Scenario + actual audio perceptual QA를 계속한다.

## Protected boundaries

- GMB-002 core unchanged.
- no endless/fuel/BOOST/capacity-8/cargo-slowdown/pickup-respawn/switch-auto-reset.
- no 056/057/058 implementation absorption.
- no score/combo formula invention.
- no player-facing solver.
- no Base repin.
- no generated visual without explicit user image request.
- no physical/device/audio-perceptual/human PASS inflation.
- PR #154 remains `CLOSED_UNMERGED · SUPERSEDED_BY_SX_DEC_059`.
- PR #174 remains `PRE_EXISTING_DRAFT · READ_ONLY` unless explicitly authorized by number and action.

## Resume read order

1. fresh Base completed `main` + Base `AGENTS.md`.
2. Base `skills/SKILL_REGISTRY.json` + `docs/generated/BASE_ACTIVE_SKILLS.md`.
3. fresh Project `main`, latest commit, all Open/Draft PR.
4. exact Project Notion Home.
5. `AGENTS.md`.
6. `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md`.
7. `FINITE_DELIVERY_PUZZLE_BASELINE.md`.
8. `CURRENT_CONFIRMED_DECISIONS.md`.
9. this `ACTIVE_CONTEXT.md`.
10. `evidence/acceptance/current_poc_candidate.json`.
11. `SX_DEC_059_POC_ACCEPTANCE_CANDIDATE_03.md` + `SX_DEC_059_POC_DEVELOPER_SELF_RUN_RECORD_03.md`.
12. `DEVELOPMENT_GATES.md` + `ROADMAP.md`.
13. actual code/tests and 059 content/UI/localization/visual/playtest owners.

Historical `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.7_SWITCHY_ADAPTER.md`, v4.8 r2 provenance, 2026-08-24 r4 reconciliation 자료는 rollback/history용이다.

## Current next action

```text
SX59-POC-ACCEPT-003 physical visual recheck
→ if PASS, same exact Candidate 003 developer self-run / screen QA + audio perceptual QA
→ if blocker 0, designate exact acceptance build
→ Windows full physical smoke
→ Android device smoke
→ Five-person first-contact comprehension
→ EXPAND / REWORK / REPEAT_SLICE / HOLD / STOP
```

**Candidate 002 Windows physical startup smoke는 PASS지만 acceptance는 P1 visual defect로 차단됐다. Candidate 003의 corrected physical visual recheck / developer self-run / audio / device / human / player-experience는 여전히 NOT_RUN이다.**
