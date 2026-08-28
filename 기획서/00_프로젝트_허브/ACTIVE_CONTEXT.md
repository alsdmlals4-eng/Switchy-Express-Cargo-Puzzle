# Active Context

Last updated: `2026-08-28 KST`

이 문서는 **현재 상태·다음 실행 지점·미검증 경계**를 연결하는 resume locator다. fresh GitHub/Notion/actual runtime이 저장 snapshot보다 우선한다. 새 채팅은 과거 대화를 필수 입력으로 요구하지 않고 Project GitHub + Notion에서 상태를 다시 재구성한다.

## Continuation State

```yaml
repository: alsdmlals4-eng/Switchy-Express-Cargo-Puzzle
default_branch: main
project_live_main_policy: REFRESH_FROM_GITHUB_BEFORE_EXECUTION
engine: Godot 4.7.1-stable
language: GDScript
product_baseline: GMB-002 · AMENDED_BY_SX_DEC_060
current_decisions: SX-DEC-027~061
work_instruction: v4.8 · 2026-08-26-r5.4-superset-final · SWITCHY_THIN_ADAPTER
work_instruction_role: USER_PROVIDED_V4_8_R5_4_SUPERSET_FINAL_CONTRACT
source_r5_4_sha256: fdf238c202cfac6d3a824aae49b8ac525fba023e31bba7df6ece64a2790365a0
historical_r4_revision: 2026-08-24-r4
historical_r4_role: USER_PROVIDED_V4_8_R4_CONTRACT
historical_r2_sha256: 6f0541048e084746f6777223521361d0339dbfb2e223c70947f694f1c050f508
base_runtime_authority: ALWAYS_REFETCH_CURRENT_COMPLETED_MAIN
fresh_read_bootstrap: PROJECT_GITHUB_NOTION_ONLY_RECONSTRUCTION_REQUIRED
skill_coverage: CURRENT_REGISTRY_FULL_INVENTORY_TRIGGERED_PROGRESSIVE_LOAD_WITH_EXECUTION_RECEIPT
gpt_local_codex_orchestration: RETIRED
sx_dec_059_merge_pr: 158
sx_dec_059_merge_main: 162e8a0a5e8ddc8472e74a6152e87dc12008e34c
sx_dec_059_implementation: MERGED_MAIN_VERIFIED · PRE_SX_DEC_060_RUNTIME
playable_poc_pr: 166
playable_poc_merge_main: 1bf798cedf28dffba9185edb62fb1c50c108fe90
physical_preflight_visual_correction_pr: 171
physical_preflight_visual_correction_main: 9d82b004b2ebf3f7d69d0376c79daae1040e94a4
candidate_003_preparation_pr: 172
candidate_003_preparation_main: 2521f3be600ea950f9893ce45940604c2d0ac88a
pre_sx_dec_060_candidate: SX59-POC-ACCEPT-003
candidate_003_role_after_sx_dec_060: HISTORICAL_EXACT_BYTES_ONLY
post_sx_dec_060_candidate_pointer: evidence/acceptance/post_sx_dec_060_candidate.json
post_sx_dec_060_candidate: SX60-POC-ACCEPT-002 · PREPARED_PACKAGE_VERIFIED · SOURCE_MAIN_0e882764b837d13282a7642b115948d4e061d163
sx60_poc_accept_001: SX60-POC-ACCEPT-001 · HISTORICAL_SUPERSEDED_BY_PRODUCT_BYTE_CHANGE · PLAYER_FACING_RUNTIME_ROUTE_READABILITY_CHANGE
candidate_003_package_integrity: PASS
candidate_003_pck_integrity: PASS · 472_OF_472
candidate_003_product_texture_packaging: PASS · 73_OF_73
candidate_003_powershell_51_live_download: PASS
candidate_003_physical_visual_recheck: NOT_RUN
sx_dec_060_user_rule: APPROVED
sx_dec_060_decision_owner: docs/decisions/SX_DEC_060_CARDINAL_STATION_SERVICE_AND_REACHABLE_NETWORK.md
sx_dec_060_design_spec: docs/superpowers/specs/2026-08-26-cardinal-station-service-and-reachable-network-design.md
sx_dec_060_implementation_plan: docs/superpowers/plans/2026-08-26-cardinal-station-service-and-reachable-network.md
sx_dec_060_codex_handoff: 기획서/50_제작_검증/SX_DEC_060_CODEX_HANDOFF_PACKAGE.md
sx_dec_060_implementation_review: FIVE_PASS_AND_INDEPENDENT_REVIEW_CLOSED · SX-AUD-071
sx_dec_060_runtime_implementation: MERGED_MAIN_VERIFIED · PR_188 · main_740b4b9312fa27289fd62baab8dda54c68ead3a7
sx_dec_060_automated_regression: PASS · 111_CASES_13461_ASSERTIONS · CI_7_GREEN
sx_dec_060_notion_readback: PASS
sx_dec_061_visual_refinement: APPROVED · BOARD_FIRST_COZY_NEO_ARCADE · DOCUMENTATION_ONLY · RUNTIME_UNCHANGED
sx_dec_061_decision_owner: docs/decisions/SX_DEC_061_BOARD_FIRST_COZY_NEO_ARCADE_VISUAL_REFINEMENT.md
sx_dec_061_visual_owner: 기획서/40_표현/VISUAL_DIRECTION.md
sx_dec_061_scene_board_owner: 기획서/40_표현/PROJECT_CORE_SCENE_VISUAL_BOARD.md
sx_dec_061_phase5_validation_unit: T1_TO_T6_TO_VS_DEMO_01_TO_RESULT
sx_dec_061_merge: MERGED_MAIN_VERIFIED · PR_229 · main_a8ea00bc70612c4556fc4460dbc819cef249864d
sx_dec_061_notion_home_visual_readback: PASS · 2026-08-28
notion_direction_page: CONFLICT_FOREIGN_PROJECT_NOT_MUTATED · Issue_230
notion_direction_conflict_owner: docs/operations/2026-08-28-notion-direction-project-identity-conflict.md
notion_direction_current_page: 3c91b237-eb1c-8197-bf13-debb96d444c8 · CURRENT_CREATED_READBACK_PASS · 2026-08-28
post_sx_dec_060_candidate_status: SX60-POC-ACCEPT-002 · PREPARED_PACKAGE_VERIFIED · ISOLATED_VISUAL_INPUT_OBSERVED · AUDIO_NOT_OBSERVED · PHYSICAL_AUDIO_QA_NEXT
current_main_live_machine_qa: docs/operations/2026-08-27-sx60-current-main-live-machine-qa.md · MAIN_CF93926 · TITLE_BRIEFING_BUILD_FLOW_OBSERVED · HUMAN_DEVICE_AUDIO_NOT_RUN
title_hero_runtime_asset: MERGED_MAIN_VERIFIED · PR_217 · main_e0044d6c7427a7c199da6bcdcf792e41e2e2f152 · ISSUE_216 · RUNTIME_VERIFIED · DUAL_PRESERVATION_PASS
title_hero_runtime_evidence: docs/operations/2026-08-27-title-hero-art-runtime-verification.md
title_hero_release_rights: CONDITIONAL · SEPARATE_REVIEW_REQUIRED
in_game_visual_consistency: MERGED_MAIN_VERIFIED · PR_220 · main_8c603474083c837f52fe40eae6012427b2ad34ce · ISSUE_219 · RUNTIME_VERIFIED · DUAL_PRESERVATION_PASS
in_game_visual_runtime_assets: SX-INGAME-VISUAL-001 · BUILD_TERRAIN + LESSON_HERO + RESULT_SUCCESS + RESULT_FAILURE
in_game_visual_runtime_evidence: docs/operations/2026-08-27-ingame-visual-consistency-runtime-verification.md
in_game_visual_release_rights: CONDITIONAL · SEPARATE_REVIEW_REQUIRED
t2_cardinal_lesson_hero_v02: MERGED_MAIN_VERIFIED · PR_225 · MAIN_7c92cbf4bb64cc0de5d293c071e954c96af2b175 · ISSUE_224 · T1/T3–T6/CAPSTONE_USE_NEUTRAL_V01 · T2_ONLY_USE_V02 · LOCAL_AND_NOTION_PRESERVED
t2_cardinal_lesson_hero_v02_evidence: docs/operations/2026-08-28-t2-cardinal-lesson-hero-v02.md · HEADLESS_112_CASES_13486_ASSERTIONS_PASS · HERA_T1_AND_T2_CONSUMER_CAPTURE_PASS
screen_visual_coverage: SX-SCREEN-VISUAL-COVERAGE-001 · Issue_222 · SCREEN_INVENTORY_HANDOFF_READY · P0_GAP_BLOCKING_0 · NO_AUTOMATIC_IMAGE_GENERATION_FROM_GAPS
base_work_five_phase_receipt: docs/operations/2026-08-27-sx60-work-five-phase-start-receipt.md
phase5_user_start_authorization: RECORDED · 2026-08-28_KST · GitHub_Issue_233
phase5_execution_plan: docs/superpowers/plans/2026-08-28-phase5-human-validation.md
base_work_current_phase: PHASE_5_USER_VERTICAL_SLICE_VALIDATION · USER_AUTHORIZED · WINDOWS_PHYSICAL_AUDIO_EXECUTION_PENDING
remaining_machine_executable_required_work: 0
windows_physical_post_060: NOT_RUN_CURRENT_EXACT_CANDIDATE_002
android_device_post_060: BLOCKED_UNVERIFIED_NO_EXACT_POST_060_APK_ID
five_person_post_060: NOT_RUN
player_experience_post_060: NOT_RUN
production_cutover: BLOCKED_DEFERRED
sx_dec_056a: PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED
sx_dec_056b: BLOCKED_BY_AUTHORITATIVE_SCORE_COMBO_RUNTIME
sx_dec_057: PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED
sx_dec_058: PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED
pr_174: PRE_EXISTING_DRAFT · READ_ONLY
```

## Current product promise

> 필요한 선로망으로 화물 조우 순서를 설계하고, 적재 선택으로 unlimited LIFO를 구성한 뒤, 운행 중 분기 판단과 역 인접 배송으로 계획을 실행하고 결과를 보고 다시 설계하는 finite cargo puzzle.

## SX-DEC-060 current gameplay delta

User-approved current rule:

```text
station service distance = abs(train_x - station_x) + abs(train_y - station_y)
DELIVER iff distance == 1
```

Therefore:

- station service is exactly `UP / RIGHT / DOWN / LEFT` one tile;
- diagonal is excluded;
- the station footprint itself is not a delivery contact;
- cargo pickup remains exact same-cell Manual / Auto contact;
- unlimited LIFO and contiguous matching TOP-group unload stay unchanged;
- not every placed rail piece has to connect globally;
- preflight must validate the start-reachable RUN component, required cargo reachability, and at least one reachable cardinal service cell for every required station.

Technical implementation default:

```yaml
finite_map_schema_target: 3
station_role: OFF_TRACK_SERVICE_OBJECT
station_cell_player_track: FORBIDDEN
station_service_overlap: FAIL_CLOSED
irrelevant_disconnected_track_island: ALLOWED
renderer: EXISTING_STATION_PNG + PROCEDURAL_SERVICE_INDICATOR
new_bitmap_assets_required: 0
```

This is a core gameplay amendment. It does not authorize arbitrary station radius, diagonal service, 056–058, or new image generation.

## Implemented automated runtime evidence

Before SX-DEC-060, the runtime had the following old semantics:

```text
FiniteDeliveryLoop
→ stations indexed by station.cell
→ unload only when handle_cell_entered() receives the exact station footprint

FiniteMapDefinition schema v2
→ station placement treated as rail/required anchor according to current marker mode

PreflightValidator
→ required anchors expected start-reachable
→ old semantics do not express per-station cardinal service coverage

ProductBoardRenderer
→ already consumes approved station_red / station_blue / station_yellow PNGs
```

The implementation now moves data/schema, delivery, preflight, graph/content, tutorial copy, and presentation together. The complete headless Godot suite passed 111 cases / 13,461 assertions. This is automated runtime evidence only; it does not create a package candidate or physical/human evidence.

## First-session continuity

The release-near first-session shape remains:

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

SX-DEC-060 changes the T2 station mental model:

```text
Cargo = pass through its tile to load.
Station = pass through one of the four cardinal adjacent tiles to deliver.
Diagonal = no delivery.
```

No new tutorial stage is added. Current locales remain `ko / en / ja / zh-Hans`; `zh-Hant` is deferred.

## Asset / visual consumer boundary

The user's current production-image rule is consumer-first:

```text
actual runtime node/key/path consumer exists
→ reuse existing asset if possible
→ procedural drawing if sufficient
→ if a concrete missing texture slot remains, generate the required bitmap automatically
→ preserve the generated bitmap in the tracked project-local path and Notion Visual/Asset destination
→ retain the existing E+D Hybrid / Neo-Arcade visual language
```

```yaml
automatic_consumer_image_policy: USER_APPROVED_2026_08_26
approved_image_dual_storage: PROJECT_LOCAL_AND_NOTION
```

Current renderer already consumes:

```text
art/product_assets/ed_hybrid_v1/core/core_station_red_normal_v01.png
art/product_assets/ed_hybrid_v1/core/core_station_blue_normal_v01.png
art/product_assets/ed_hybrid_v1/core/core_station_yellow_normal_v01.png
```

So `SX_DEC_060_NEW_BITMAP_ASSETS = 0`. The service range is a procedural board overlay first, not an explanatory sheet or new full-screen mockup.

Separate from SX-DEC-060 rule work, GitHub Issue #216/PR #217 adds one user-authorized title-only product bitmap to an already-existing runtime consumer. It does not alter the SX-DEC-060 station asset policy or gameplay semantics:

```yaml
asset_id: SX-TITLE-HERO-001
consumer: TitleScreen/Panel/Content/HeroArt
local_path: art/product_assets/ed_hybrid_v1/shells/shell_title_hero_v01.png
notion_visual_attachment: file-upload://3c91b237-eb1c-81b3-b06d-00b297b2a323
dual_preservation: APPROVED_DUAL_PRESERVED
runtime_machine_verification: PASS
release_rights: CONDITIONAL
```

Separate from the title-only change, GitHub Issue #219/PR #220 adds four user-authorized images only to verified in-game consumers. This does not alter SX-DEC-060 semantics, station asset policy, map data, HUD semantic colors, or first-session structure:

```yaml
asset_set: SX-INGAME-VISUAL-001
manifest: art/product_assets/ed_hybrid_v1/runtime_visual_manifest.json
main: 8c603474083c837f52fe40eae6012427b2ad34ce
consumers:
  - ProductBoardRenderer::PRODUCT_VISUAL_ASSET_PATHS[board_terrain]
  - BriefingScreen/Panel/Content/LessonArt → ProductShellArt::LESSON_HERO_PATH
  - ResultOverlay/Panel/Content/ResultArt → ProductShellArt::RESULT_SUCCESS_PATH
  - ResultOverlay/Panel/Content/ResultArt → ProductShellArt::RESULT_FAILURE_PATH
dual_preservation: APPROVED_DUAL_PRESERVED · local tracked files + Notion Visual attachments
runtime_machine_verification: PASS · Lesson / BUILD / success result / failure result
automated_regression: PASS · 112_CASES_13481_ASSERTIONS · CI_6_GREEN
release_rights: CONDITIONAL
```

## Candidate / evidence transition

Candidate 003 remains exact historical evidence for pre-SX-DEC-060 bytes:

```yaml
candidate_id: SX59-POC-ACCEPT-003
artifact_workflow_run_id: 32715351609
artifact_zip_sha256: 8b4e630c667b5fd88886878e5a07401c1fe6cfd8f1f9d84b2ab39cb8824923d4
windows_exe_sha256: 1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244
windows_pck_sha256: 2e9634cedd6da49793973f4582e2bd58ea4daae2fec246657edcf58ae360af72
pck_integrity: PASS · 472/472
product_texture_packaging: PASS · 73/73
physical_visual_recheck: NOT_RUN
```

Do not spend the next human validation cycle promoting these old gameplay bytes. Post-060 requires a new exact candidate after runtime implementation and automated/package proof.

## Current execution owner

GPT-owned work:

```text
Decision/canon
→ benchmark/trade study
→ design spec
→ implementation plan
→ Codex handoff
→ GitHub/Notion synchronization
→ review/evidence governance
```

Actual GDScript/Scene/Resource/map/runtime implementation:

```text
CODEX_GODOT_PRODUCT_IMPLEMENTATION_HANDOFF
```

The current handoff package is `기획서/50_제작_검증/SX_DEC_060_CODEX_HANDOFF_PACKAGE.md`.

## Current next action

```text
SX-DEC-061 planning direction is recorded; it has not changed runtime bytes
→ use the full T1 → T6 → VS_DEMO_01 → Result sequence for the next Phase 5 human-validation design
→ resolve the foreign-project Notion Direction page only after the user authorizes rehome or replacement
→ use Notion Direction `3c91b237-eb1c-8197-bf13-debb96d444c8` plus the repository owners as current Switchy Direction
→ Windows physical smoke + audio perceptual QA
→ Android device smoke
→ Five-person comprehension
→ product decision
```

## Evidence ceiling now

```text
USER_RULE_APPROVED
DESIGN_RECORDED
TDD_PLAN_RECORDED
CODEX_HANDOFF_EXECUTED
RUNTIME_MERGED_MAIN_VERIFIED_PR_188
AUTOMATED_REGRESSION_PASS_111_CASES_13461_ASSERTIONS
POST_060_CANDIDATE_SX60_POC_ACCEPT_002_PREPARED_PACKAGE_VERIFIED
SX60_POC_ACCEPT_001_HISTORICAL_SUPERSEDED_BY_PRODUCT_BYTE_CHANGE
POST_060_DEVICE_NOT_RUN
POST_060_HUMAN_NOT_RUN
NEW_BITMAP_ASSETS_0
```

## Runtime route readability correction · GitHub Issue #197

```yaml
status: MERGED_MAIN_VERIFIED_LOCAL_EVIDENCE
merge: PR_198 · main_a8eee4f875a95e8da69802c4e60452df3535fe0e
remote_ci: QUEUED_WITHOUT_JOBS · USER_AUTHORIZED_BYPASS
scope: PRESENTATION_ONLY
runtime_consumers:
  - ProductBoardRenderer
  - RouteControlOverlay
new_bitmap_assets: 0
```

- 실제 RUN board에서 rail art가 단일 중립색으로 보여 selected/unselected/occupied state를 빠르게 읽기 어려웠다.
- route trace는 current finite render snapshot과 route-control state를 재구성해 결정하며 domain, map, station/cargo, LIFO/TOP, preflight 의미를 바꾸지 않는다.
- selected = 녹색/굵은 trace + 방향 cue; unselected = 청색/얇은 trace; occupied/locked = 적색 trace + existing lock overlay.
- SUCCESS/FAILURE에도 selected route trace가 유지된다.
- 1280×720 live runtime screenshot/diagnostics와 960×540·1280×720·1920×1080 deterministic width hierarchy checks가 필요한 evidence다. Physical human comprehension remains NOT_RUN.
- exact PR head의 official headless suite 112 cases / 13,480 assertions, Project Contract, GUT, Godot 4.7.1 headless parse는 local PASS다. 원격 CI 4개는 job 없이 queued로 남아 사용자가 병합 우회를 승인했으며, CI GREEN은 아니다.

## Protected boundaries

- GMB-002 finite cargo/LIFO/switch identity remains; only the explicit SX-DEC-060 amendment changes station/preflight meaning.
- no endless/fuel/BOOST/capacity-8/cargo-slowdown/pickup-respawn/switch-auto-reset.
- no 056/057/058 implementation absorption.
- no score/combo formula invention.
- no player-facing solver.
- no Base repin.
- no new generated image without a concrete game consumer.
- no physical/device/audio-perceptual/human PASS inflation.
- PR #174 remains `PRE_EXISTING_DRAFT · READ_ONLY`.
- historical SX-DEC-059/Candidate 003 files remain provenance, not post-060 current-runtime proof.

## Resume read order

1. fresh Base completed `main` + Base `AGENTS.md`.
2. Base `skills/SKILL_REGISTRY.json` + generated active map.
3. fresh Project `main`, latest commit, all Open/Draft PRs.
4. exact Project Notion Home.
5. Project `AGENTS.md` + current r5.4 thin adapter.
6. `CURRENT_CONFIRMED_DECISIONS.md`.
7. `FINITE_DELIVERY_PUZZLE_BASELINE.md`.
8. this `ACTIVE_CONTEXT.md`.
9. `docs/decisions/SX_DEC_060_CARDINAL_STATION_SERVICE_AND_REACHABLE_NETWORK.md`.
10. SX-DEC-060 design/spec/plan/Codex handoff.
11. `DEVELOPMENT_GATES.md` + `ROADMAP.md`.
12. actual finite code/data/tests and first-session/presentation consumers.

Fresh-read current truth always outranks this saved locator.
