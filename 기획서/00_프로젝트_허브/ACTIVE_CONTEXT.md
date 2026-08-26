# Active Context

Last updated: `2026-08-26 KST`

이 문서는 **현재 상태·다음 실행 지점·미검증 경계**를 연결하는 resume locator다. fresh GitHub/Notion/actual runtime이 저장 snapshot보다 우선한다. 새 채팅은 과거 대화를 필수 입력으로 요구하지 않고 Project GitHub + Notion에서 상태를 다시 재구성한다.

## Continuation State

```yaml
repository: alsdmlals4-eng/Switchy-Express-Cargo-Puzzle
default_branch: main
project_live_main_policy: REFRESH_FROM_GITHUB_BEFORE_EXECUTION
engine: Godot 4.7.1-stable
language: GDScript
product_baseline: GMB-002 · AMENDED_BY_SX_DEC_060
current_decisions: SX-DEC-027~060
work_instruction: v4.8 · 2026-08-26-r5.4-superset-final · SWITCHY_THIN_ADAPTER
work_instruction_role: USER_PROVIDED_V4_8_R5_4_SUPERSET_FINAL_CONTRACT
source_r5_4_sha256: fdf238c202cfac6d3a824aae49b8ac525fba023e31bba7df6ece64a2790365a0
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
sx_dec_060_runtime_implementation: NOT_RUN
sx_dec_060_automated_regression: NOT_RUN
post_sx_dec_060_candidate: NOT_CREATED
windows_physical_post_060: NOT_RUN
android_device_post_060: NOT_RUN
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

## Why current runtime is not yet evidence

Fresh-read of current implementation before SX-DEC-060 showed:

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

Therefore SX-DEC-060 is not a one-line visual change. Data/schema, delivery, preflight, graph/content, tutorial copy, and presentation must move together.

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
→ new bitmap only if a concrete missing texture slot remains and is separately approved
```

Current renderer already consumes:

```text
art/product_assets/ed_hybrid_v1/core/core_station_red_normal_v01.png
art/product_assets/ed_hybrid_v1/core/core_station_blue_normal_v01.png
art/product_assets/ed_hybrid_v1/core/core_station_yellow_normal_v01.png
```

So `SX_DEC_060_NEW_BITMAP_ASSETS = 0`. The service range is a procedural board overlay first, not an explanatory sheet or new full-screen mockup.

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
merge/sync SX-DEC-060 canon package
→ Codex fresh-read merged main + exact Project Notion Home
→ RED schema/service tests
→ FiniteMapDefinition v3 + off-track station semantics
→ cardinal service delivery
→ start-reachable preflight
→ active map/tutorial migration + witnesses
→ procedural service overlay using existing station PNGs
→ full regression
→ five-pass adversarial review
→ new exact post-060 package candidate
→ Windows physical smoke
→ Android device smoke
→ Five-person comprehension
→ product decision
```

## Evidence ceiling now

```text
USER_RULE_APPROVED
DESIGN_RECORDED
TDD_PLAN_RECORDED
CODEX_HANDOFF_READY
RUNTIME_NOT_RUN
AUTOMATED_REGRESSION_NOT_RUN
POST_060_PACKAGE_NOT_RUN
POST_060_PHYSICAL_NOT_RUN
POST_060_DEVICE_NOT_RUN
POST_060_HUMAN_NOT_RUN
NEW_BITMAP_ASSETS_0
```

## Protected boundaries

- GMB-002 finite cargo/LIFO/switch identity remains; only the explicit SX-DEC-060 amendment changes station/preflight meaning.
- no endless/fuel/BOOST/capacity-8/cargo-slowdown/pickup-respawn/switch-auto-reset.
- no 056/057/058 implementation absorption.
- no score/combo formula invention.
- no player-facing solver.
- no Base repin.
- no new generated image without a concrete game consumer and separate user approval.
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
