# Current Confirmed Decisions

Last updated: `2026-08-30 KST`

이 문서는 Switchy Express의 **현재 승인 Decision과 실행 권위**를 압축한다. 상세 규칙·근거·역사 CI는 각 Decision/Audit owner가 책임진다. Google Sheets는 migration-only이며 active decision authority가 아니다.

## Current authority snapshot

> **Workspace amendment, 2026-08-28:** GitHub is the sole active project workspace. Notion is `RETIRED_NO_ACTIVE_USE`; prior page and attachment readbacks remain history/audit provenance and are neither fresh-read input nor write/readback completion criteria.

```yaml
current_product_baseline: GMB-002 · FINITE_DELIVERY_PUZZLE_BASELINE · AMENDED_BY_SX_DEC_060
current_decision_span: SX-DEC-027~065
work_instruction: v4.8 · 2026-08-26-r5.4-superset-final · SWITCHY_THIN_ADAPTER
work_instruction_role: USER_PROVIDED_V4_8_R5_4_SUPERSET_FINAL_CONTRACT
source_r5_4_sha256: fdf238c202cfac6d3a824aae49b8ac525fba023e31bba7df6ece64a2790365a0
historical_r4_revision: 2026-08-24-r4
historical_r4_role: USER_PROVIDED_V4_8_R4_CONTRACT
historical_r2_source_sha256: 6f0541048e084746f6777223521361d0339dbfb2e223c70947f694f1c050f508
v4_8_r2_authority_merge_pr: 164
v4_8_r2_authority_merge_main: 98ed1c65d678bfc262c32084bbf0e59368093c2c
v4_7_adapter: HISTORICAL_ROLLBACK_EVIDENCE
project_base_compatibility_pin: v9.4.3 · HISTORICAL_COMPATIBILITY
base_canon_sync_observation: 862938478cfea6c9db16691900c9c4fdc464f9ff · AUDIT_EVIDENCE_ONLY
base_runtime_authority: ALWAYS_REFETCH_CURRENT_COMPLETED_MAIN
fresh_read_bootstrap: PROJECT_GITHUB_ONLY_RECONSTRUCTION_REQUIRED
project_workspace: GITHUB_ONLY · USER_APPROVED_2026-08-28
notion_active_use: RETIRED_NO_ACTIVE_USE · HISTORY_AUDIT_ONLY · NO_NEW_READ_WRITE_SYNC
notion_current_structure_migration: COMPLETE · docs/migrations/2026-08-28-notion-current-workspace-migration.md
sx_dec_059_merge_pr: 158
sx_dec_059_merge_main: 162e8a0a5e8ddc8472e74a6152e87dc12008e34c
SX_DEC_059_IMPLEMENTATION: MERGED_MAIN_VERIFIED · PRE_SX_DEC_060_RUNTIME
sx_dec_059_repository_canon: MERGED_MAIN_VERIFIED
sx_dec_059_notion_sync: PASS · POST_PR_158_READBACK_COMPLETE
sx_dec_059_review: FIVE_PASS_AND_INDEPENDENT_REVIEW_CLOSED · SX-AUD-066
playable_visual_ux_poc: MERGED_MAIN_VERIFIED · PR_166 · main_1bf798cedf28dffba9185edb62fb1c50c108fe90
physical_preflight_visual_correction: MERGED_MAIN_VERIFIED · PR #171 · main_9d82b004b2ebf3f7d69d0376c79daae1040e94a4
candidate_003_preparation: MERGED_MAIN_VERIFIED · PR #172 · main_2521f3be600ea950f9893ce45940604c2d0ac88a
pre_sx_dec_060_candidate_pointer: evidence/acceptance/current_poc_candidate.json
pre_sx_dec_060_candidate: SX59-POC-ACCEPT-003 · HISTORICAL_EXACT_BYTES_AFTER_SX_DEC_060
post_sx_dec_060_candidate_pointer: evidence/acceptance/post_sx_dec_060_candidate.json
post_sx_dec_060_candidate: SX60-POC-ACCEPT-005 · PREPARED_PACKAGE_VERIFIED · MACHINE_PRIMARY_ACCEPTANCE_READY · SOURCE_MAIN_a11dfd1a063e434ee22e8cfb7b073ebc380aa27a · FINAL_USER_REVIEW_NOT_RUN
sx60_poc_accept_001: SX60-POC-ACCEPT-001 · HISTORICAL_SUPERSEDED_BY_PRODUCT_BYTE_CHANGE · PLAYER_FACING_RUNTIME_ROUTE_READABILITY_CHANGE
sx60_poc_accept_002: SX60-POC-ACCEPT-002 · HISTORICAL_SUPERSEDED_BY_SX_DEC_062 · PRIOR_BYTE_ISOLATED_VISUAL_INPUT_OBSERVATION_DOES_NOT_TRANSFER
sx60_poc_accept_003: SX60-POC-ACCEPT-003 · HISTORICAL_SUPERSEDED_BY_SX_DEC_064_PRODUCT_BYTE_CHANGE
sx60_poc_accept_004: SX60-POC-ACCEPT-004 · PREPARED_PACKAGE_VERIFIED · HISTORICAL_SUPERSEDED_BY_SX_DEC_063_CORE_BOARD_V04_PRODUCT_BYTE_CHANGE
sx60_poc_accept_005: SX60-POC-ACCEPT-005 · PREPARED_PACKAGE_VERIFIED · MACHINE_PRIMARY_ACCEPTANCE_READY · FINAL_USER_REVIEW_NOT_RUN
candidate_003_package_integrity: PASS · HISTORICAL_PRE_SX_DEC_060
candidate_003_pck_integrity: PASS · 472_OF_472 · HISTORICAL_PRE_SX_DEC_060
candidate_003_product_textures: PASS · 73_OF_73 · HISTORICAL_PRE_SX_DEC_060
candidate_003_powershell_51_live_download: PASS · HISTORICAL_PRE_SX_DEC_060
candidate_003_physical_visual_recheck: NOT_RUN
sx_dec_060_user_rule: APPROVED
sx_dec_060_design: RECORDED
sx_dec_060_runtime_implementation: MERGED_MAIN_VERIFIED · PR_188 · main_740b4b9312fa27289fd62baab8dda54c68ead3a7
sx_dec_060_automated_regression: PASS · 111_CASES_13461_ASSERTIONS · CI_7_GREEN
sx_dec_060_implementation_review: FIVE_PASS_AND_INDEPENDENT_REVIEW_CLOSED · SX-AUD-071
sx_dec_060_post_change_candidate: SX60-POC-ACCEPT-005 · PREPARED_PACKAGE_VERIFIED · MACHINE_PRIMARY_ACCEPTANCE_READY · PACKAGE_AND_RUNTIME_JSON_VERIFIED
sx_dec_060_notion_sync: PASS · POST_PR_188_READBACK_COMPLETE
sx_dec_061_visual_refinement: APPROVED · BOARD_FIRST_COZY_NEO_ARCADE · DOCUMENTATION_ONLY · RUNTIME_UNCHANGED
sx_dec_062_runtime_composition: MERGED_MAIN_VERIFIED · PR_237 · main_8bce715b5045afebfb04d38108d2e3f7353e1b10 · EXISTING_ASSET_BOARD_FIRST_COMPOSITION · PACKAGE_VERIFIED
sx_dec_063_hybrid_diorama_alignment: USER_APPROVED_DIRECTION · CORE_BOARD_V04_CENTERED_PORT_RAILS_MERGED_MAIN_VERIFIED_PR_255_MAIN_2CF7BB5 · TERRAIN_PLUS_9_NON_RAIL_V02_CORE_ASSETS_PLUS_4_V04_MASTER_DERIVED_RAILS · AUTOMATED_MACHINE_RUNTIME_LOCAL_PACKAGE_AND_REMOTE_RUNTIME_BYTE_CI_7_GREEN_PR_255_F00DE19 · EXACT_GITHUB_CANDIDATE_AND_PHYSICAL_HUMAN_GATES_NOT_RUN
sx_vis_061_core_systems_board: USER_APPROVED_GITHUB_PRESERVED_PLANNING_REFERENCE · ISSUE_246 · docs/visual-references/sx-vis-061-core-systems-board-exploration-002b.png · NO_RUNTIME_CONSUMER · NOT_RUNTIME_PROOF
sx_dec_064_active_route_lighting: MERGED_MAIN_VERIFIED · ISSUE_248 · PR_249 · main_2b98c0b070f2d8670b6432ac769a130bdd83bc39 · CI_7_GREEN · POST_MERGE_GODOT_112_CASES_13513_ASSERTIONS_PASS
sx_dec_065_machine_primary_validation: USER_APPROVED · MACHINE_PRIMARY_FINAL_USER_REVIEW · FIVE_SCOPE_ADVERSARIAL_REVIEW_CLOSED · FIVE_PERSON_COMPREHENSION_NOT_REQUIRED · PLAYER_EXPERIENCE_STUDY_NOT_REQUIRED · FINAL_USER_REVIEW_NOT_RUN
sx_dec_063_historical_notion_readback: PASS · HOME_DIRECTION_VISUAL_PRODUCTION_FLOW · PR_240 · main_f316ee1ba3b641e655facfb3bfaee28b3bc8d64b · HISTORY_AUDIT_ONLY
developer_self_run: HISTORICAL_SX60_POC_ACCEPT_002_ISOLATED_VISUAL_INPUT_OBSERVED_AUDIO_NOT_OBSERVED · NOT_TRANSFERRED_TO_CURRENT_CANDIDATE_004
windows_physical_startup_and_build_entry_automation_observed: HISTORICAL_SX60_POC_ACCEPT_002_ISOLATED_TITLE_BRIEFING_BUILD_VISUAL_AND_BUTTON_INPUT · NOT_TRANSFERRED_TO_CURRENT_CANDIDATE_004
acceptance_build: SX60-POC-ACCEPT-005 · MACHINE_PRIMARY_PACKAGE_VERIFIED · NO_HUMAN_OR_PHYSICAL_EVIDENCE
windows_full_physical_runtime: FINAL_USER_REVIEW_ONLY · NOT_RUN
audio_perceptual_qa: FINAL_USER_REVIEW_ONLY · NOT_RUN
android_device: NOT_RUN_POST_SX_DEC_060
five_person_comprehension: NOT_REQUIRED_BY_USER_VALIDATION_POLICY
player_experience: NOT_REQUIRED_BY_USER_VALIDATION_POLICY
final_user_review: FINAL_USER_REVIEW · NOT_RUN · EXACT_CANDIDATE_REQUIRED
production_cutover: BLOCKED_DEFERRED
sx_dec_055_runtime_implementation: MERGED_MAIN_VERIFIED · PR_151
sx_dec_056a: DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
sx_dec_056b: BLOCKED_BY_AUTHORITATIVE_SCORE_COMBO_RUNTIME
sx_dec_057: DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
sx_dec_057_fast_cheap: BLOCKED_BY_STAGE8_TRACK_ATTRIBUTE_RUNTIME
sx_dec_058: DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
semantic_product_assets: 73_TOTAL · PRODUCTION_COMPLETE · PLUS_6_RUNTIME_PRESENTATION_PNGS · 79_TRACKED_PRODUCT_PNGS_TOTAL
sx_dec_060_new_bitmap_assets_required: 0
```

`base_canon_sync_observation`은 과거 canon-sync 감사 시점의 evidence다. 실행 권위는 SHA snapshot이 아니라 `ALWAYS_REFETCH_CURRENT_COMPLETED_MAIN`이며, 작업 시작마다 fresh Base completed main과 current Skill Registry/generated map을 다시 읽는다. `source_r5_4_sha256`은 이번 사용자 계약 exact identity이고, r4/r2 값은 predecessor/provenance로만 유지한다. r5.4 adoption은 056~058 구현 권한을 넓히지 않는다.

## Current core promise

```text
선로 건설로 필요한 RUN 경로와 화물 조우 순서를 설계
→ 수동/자동 적재로 unlimited LIFO 스택 구성
→ 운행 중 분기 경로를 실행
→ 역의 상·하·좌·우 1칸 서비스 셀을 지나며 TOP 연속 동일 화물 하역
→ 결과를 보고 같은 노선 재도전 또는 재설계
```

핵심 차별점은 **노선을 그리는 행위가 곧 화물 스택의 순서를 설계하는 행위**라는 점이다. 모든 배치 선로를 하나의 전역 네트워크로 연결하는 것 자체는 목표가 아니며, 실제 RUN 가능한 start-reachable network가 필수 화물과 역 서비스 범위를 충족하는지가 중요하다.

## Current Decision Registry

| Decision ID | 현재 권위 / 상태 |
|---|---|
| SX-DEC-027 | 유한 고정 화물 배송 퍼즐 · CURRENT |
| SX-DEC-028 | 자유 선로 건설·비용·전액 환급·추천 비용 · CURRENT |
| SX-DEC-029 | 구조 검사·제한 시간·성공/실패·pause · CURRENT · SX-DEC-060 reachable-network amendment 적용 |
| SX-DEC-030 | 직선·곡선·분기·교차 · CURRENT |
| SX-DEC-031 | manual hold·auto toggle·unlimited LIFO·TOP 그룹 하역 · CURRENT · SX-DEC-060 station-service amendment 적용 |
| SX-DEC-032 | 하역 그룹 feedback · CURRENT; score/max-combo metric은 미확정 |
| SX-DEC-033 | 별·랭킹 · HISTORICAL_FUTURE_DIRECTION · NOT_CURRENT_SLICE · NOT_STARTED |
| SX-DEC-034 | Tutorial 1~10 + 2-of-3 progression · SUPERSEDED_FOR_CURRENT_FIRST_SESSION by SX-DEC-059 T1→T6→Capstone |
| SX-DEC-035 | Daily/Weekly fixed seed · DEFERRED · NOT_CURRENT_SLICE · NOT_RUN |
| SX-DEC-036 | cosmetic-only · power progression 금지 · CURRENT |
| SX-DEC-037 | PC Vertical Slice · IMPLEMENTED · historical automated pass, manual gates open |
| SX-DEC-038 | Demo Route Refinement · IMPLEMENTED · physical gates open |
| SX-DEC-039 | Mid-Run Exit · IMPLEMENTED · full local retest open |
| SX-DEC-040 | Station Color Parity · CURRENT |
| SX-DEC-041 | Route-End Failure · MERGED_MAIN_VERIFIED |
| SX-DEC-042 | Switch Direction Arrows · MERGED_MAIN_VERIFIED |
| SX-DEC-043 | v4.3 Entry Gate · HISTORICAL governance |
| SX-DEC-044 | GUT 9.7.1 · CURRENT_TEST_AUTHORITY |
| SX-DEC-045 | Godot Authoring Authority · current boundary |
| SX-DEC-046 | procedural route-arrow safety · CURRENT |
| SX-DEC-047 | SUPERSEDED by SX-DEC-048 |
| SX-DEC-048 | Standard Hosted Actions Authority · CURRENT |
| SX-DEC-049 | Cargo Pickup Marker Visibility · MERGED_MAIN_VERIFIED |
| SX-DEC-050 | Finite Visual Planning Package · MERGED |
| SX-DEC-051 | E+D Hybrid Production Asset Pack · MERGED_MAIN_VERIFIED |
| SX-DEC-052 | Local Tooling & Asset-Vault · CURRENT EVIDENCE |
| SX-DEC-053 | Final E+D Production Visual Direction · 39 baseline assets |
| SX-DEC-054 | Semantic Asset Completion · RUN 20 + BUILD 8 + VFX 6 · 73 TOTAL |
| SX-DEC-055 | Runtime Semantic POC · PR #151 MERGED · physical/human gates separate |
| SX-DEC-056 | Route Causality / Result Feedback · 056A implementation unauthorized; 056B blocked |
| SX-DEC-057 | Yard Labs / Mastery · implementation unauthorized |
| SX-DEC-058 | Fixed-Seed Challenge Quality · implementation/pipeline unauthorized |
| SX-DEC-059 | Release-Near First Session · implementation/playable POC merged · pre-060 Candidate 003 historical after SX-DEC-060 |
| **SX-DEC-060** | **Cardinal Station Service + Reachable Network · MERGED_MAIN_VERIFIED · PR #188** |
| **SX-DEC-061** | **Board-first Cozy Neo-Arcade visual refinement · APPROVED · documentation/plan board only; runtime unchanged** |
| **SX-DEC-062** | **Board-first runtime composition · MERGED_MAIN_VERIFIED · PR #237 · Candidate 003 is historical after SX-DEC-064; Candidate 004 is current package evidence · human gates remain open** |
| **SX-DEC-063** | **Hybrid miniature-diorama visual production alignment · user-directed v04 centred-port crop correction from the approved connected master is locally implemented on the isolated branch, including the reviewed non-square quarter-turn fix · automated, machine runtime, and local package evidence · remote CI/package-candidate/physical/human gates remain open** |
| **SX-DEC-064** | **Active-route lighting · MERGED_MAIN_VERIFIED · PR #249 · CI 7 green · procedural presentation delta · physical/player gates remain open** |

## SX-DEC-059 retained first-session contract

```text
T1 · Track Connection
→ T2 · Cargo/Station + basic manual pickup prerequisite
→ T3 · LIFO/TOP reverse planning
→ T4 · selective manual non-load + revisit
→ T5 · Auto ON safe segment / OFF decision segment
→ T6 · switch execution
→ VS_DEMO_01 · capstone
→ evidence-safe Result / Retry / Edit
```

SX-DEC-060는 이 단계 수를 늘리지 않는다. T2의 station mental model만 `station exact-cell arrival`에서 `cardinal adjacent service`로 교정한다.

## SX-DEC-061 confirmed visual/validation contract

Canonical owners: `docs/decisions/SX_DEC_061_BOARD_FIRST_COZY_NEO_ARCADE_VISUAL_REFINEMENT.md`, `기획서/40_표현/VISUAL_DIRECTION.md`, and `기획서/40_표현/PROJECT_CORE_SCENE_VISUAL_BOARD.md`.

```text
cozy miniature railway world
→ board-first dark control-deck UI language
→ visible valid / invalid / tutorial / TOP / lock / cardinal-service state
→ the full T1 → T6 → VS_DEMO_01 → Result chain is the Phase 5 human-validation unit
```

This changes neither GMB-002 gameplay, map data, Scene/Resource ownership, the existing 73 runtime PNG consumers, nor the post-SX-DEC-060 evidence ceiling. `SX-VIS-061-CORE-SYSTEMS-BOARD-EXPLORATION-002B` is now a user-approved GitHub-preserved planning reference at `docs/visual-references/sx-vis-061-core-systems-board-exploration-002b.png`; it remains `NOT_RUNTIME_PROOF`, has no runtime consumer, and does not authorize a game asset or UI implementation.

## SX-DEC-062 confirmed runtime-composition contract

Canonical owners: `docs/decisions/SX_DEC_062_BOARD_FIRST_RUNTIME_COMPOSITION.md`, `docs/superpowers/specs/2026-08-28-board-first-runtime-composition-design.md`, `docs/superpowers/plans/2026-08-28-board-first-runtime-composition.md`, and `기획서/50_제작_검증/SX_DEC_062_CODEX_GODOT_PRODUCT_IMPLEMENTATION_HANDOFF.md`.

```text
existing E+D assets and exact consumers
→ BoardRenderer / RouteControl remains the player’s first visual authority
→ named control-deck tokens align HUD and shell without new art
→ T2 v02, first-session flow, and result recovery remain exact
→ a changed runtime requires a new exact candidate and new physical/human evidence
```

This contract excludes all bitmap/manifest/hash changes, Issue #227 T2 replacement, finite rules/data/locales/audio changes, score/economy/progression, Base repin, and PR #174. Implementation merged in PR #237 on exact `main@8bce715b5045afebfb04d38108d2e3f7353e1b10`: RED→GREEN visual composition tests, the full local Godot runner (112 cases / 13,512 assertions), six exact-head CI checks, and an exact-main package candidate are verified. Physical, audio, device, human, and player-experience evidence remain `NOT_RUN`.

## SX-DEC-063 confirmed hybrid miniature-diorama visual-production direction

Canonical owners: `docs/decisions/SX_DEC_063_HYBRID_MINIATURE_DIORAMA_VISUAL_PRODUCTION_ALIGNMENT.md`, `docs/superpowers/specs/2026-08-28-sx-dec-063-hybrid-miniature-diorama-production-design.md`, `docs/superpowers/plans/2026-08-28-sx-dec-063-terrain-runtime-integration.md`, `기획서/40_표현/VISUAL_DIRECTION.md`, `기획서/40_표현/PROJECT_CORE_SCENE_VISUAL_BOARD.md`, `기획서/50_제작_검증/SX_DEC_063_TERRAIN_RUNTIME_INTEGRATION_HANDOFF.md`, and GitHub Issues #239/#243.

```text
rectangular BUILD/RUN grid and exact input mapping stay
→ elevated miniature-diorama depth is expressed inside that geometry
→ new visual bytes are limited to named, versioned actual consumers
→ T2 shell_lesson_hero_v02 and Issue #227 remain protected
→ user-approved v02 terrain plus nine non-rail Core Board sprites and four v04 centred-port derivatives of the approved connected rail master are stored as exact source binaries with provenance
→ the existing fourteen-slot ProductBoardRenderer consumer map is connected; v04 rail textures draw full-cell, pre-swap non-square local bounds for quarter turns, and use no procedural visual seam underlay
```

`SX-VIS-063-CANDIDATE-001` terrain plus `SX-VIS-063-CORE-*` are user-promoted at their v02 paths, while user-approved `SX-VIS-063-RAIL-NETWORK-MASTER-003` deterministically supplies the four current v04 rail paths recorded in `art/product_assets/ed_hybrid_v2/manifest.json` (master SHA-256 `f3a6f070b728e319a15b3fc1b72ac7c4732f3b632e73e5dda202a52e95bb5d5b`; terrain SHA-256 `1b8cdeda06a940e70bf462e0e59b71e4130eeb1b266f606d7cd484ab5d145d0d`). The v04 crop rectifies a measured v03 edge-centre mismatch without changing source artwork or gameplay, while the renderer's reviewed non-square quarter-turn fix preserves the target bounds and edge centres after rotation. Its local automated/machine-runtime/local-package evidence and all seven required remote checks for PR #255 runtime-byte head `4d5c5ef09040c36aa064b8b79ddb69443b465877` are recorded; immutable GitHub package candidate, physical Windows/audio, Android device, accessibility, player comprehension, release rights, and cutover remain open. Source master and review captures are excluded from final PCK proofs. It is not a true isometric conversion, gameplay/data/audio/locale/progression change, Human/Player Experience, or release-rights promotion. Notion is retired from this lifecycle by the 2026-08-28 user decision.

## SX-DEC-065 machine-primary validation policy

Canonical owner: `docs/decisions/SX_DEC_065_MACHINE_PRIMARY_FINAL_USER_REVIEW_VALIDATION_POLICY.md`.

`MACHINE_PRIMARY_FINAL_USER_REVIEW` makes the exact-candidate deterministic/Godot/runtime/export/package/CI route the primary acceptance path. `FIVE_PERSON_COMPREHENSION_NOT_REQUIRED` and `PLAYER_EXPERIENCE_STUDY_NOT_REQUIRED` replace the old mandatory studies. `FINAL_USER_REVIEW` remains `NOT_RUN` until the user asks to inspect the named exact candidate. Machine evidence never becomes human evidence, and release/platform/right obligations retain their separate owners.

## SX-DEC-064 active-route lighting

Canonical owner: `docs/decisions/SX_DEC_064_ACTIVE_ROUTE_LIGHTING.md`. Tracking: GitHub Issue #248.

```text
actual train cell + actual approach cell
→ read only the currently selected deterministic graph continuation
→ lime route glow and direction cue on that route only
→ preserve dim direct-control targets as non-rail-light interaction affordances
→ show occupied lock as a separate crimson overlay
→ stop predictive route glow at SUCCESS / FAILURE
```

This is a `ProductBoardRenderer` presentation projection and `FiniteSliceSessionController.render_snapshot` field addition. It changes no switch-selection, movement, map, station, cargo, LIFO, tutorial, result, asset, locale, audio, score, or solver rule. The renderer reads the actual current selection; it does not compute an optimal route or change a future branch. The RED→GREEN record, exact-head CI (7 required checks), and post-merge main Godot suite passed (112 cases / 13,513 assertions); PR #249 merged as main `2b98c0b070f2d8670b6432ac769a130bdd83bc39`. Same-state render composite, Windows/device, human, Player Experience, release, and production-cutover evidence remain unclaimed until separately run.

### Architecture / evidence boundaries

- T1/T2 share one product instance and valid layout.
- `VS_DEMO_01` remains the capstone but post-060 map bytes/identity require explicit migration and revalidation.
- SX-DEC-059 historical tutorial metadata stays outside its historical `FiniteMapDefinition` schema v2.
- SX-DEC-060 implementation target is explicit `FiniteMapDefinition` schema v3; v2 semantics are not silently reinterpreted.
- `FirstSessionDefinition + FirstSessionStagePolicy + FirstSessionDirector + FirstSessionCopy` remain sidecar owners.
- `ProductFiniteSlice` remains the command convergence boundary.
- Result uses runtime truth only: `ROUTE_END / TIME_EXPIRED + remaining_map_cargo + stack_size`.
- no station mismatch/actual trace fabrication before an authorized observation owner exists.
- existing 73 semantic product assets first; SX-DEC-060 requires zero new bitmap assets at design time.
- locales: `ko / en / ja / zh-Hans`; `zh-Hant` deferred.

## SX-DEC-060 confirmed contract

Canonical owner: `docs/decisions/SX_DEC_060_CARDINAL_STATION_SERVICE_AND_REACHABLE_NETWORK.md`

```text
station delivery service = Manhattan distance exactly 1
→ UP / RIGHT / DOWN / LEFT only
→ diagonal excluded
→ station footprint itself is not the delivery contact

cargo pickup = existing exact-cell Manual / Auto contact
LIFO/TOP = unchanged

preflight = start-reachable RUN component
→ every required cargo reachable
→ every required station has >=1 reachable cardinal service cell
→ irrelevant disconnected rail island does not block RUN
```

Technical implementation default:

```yaml
map_schema_target: 3
station_role: OFF_TRACK_SERVICE_OBJECT
station_cell_player_track: FORBIDDEN
station_service_overlap: FAIL_CLOSED
renderer: EXISTING_STATION_PNG + PROCEDURAL_SERVICE_INDICATOR
new_bitmap_assets: 0
```

SX-DEC-060 runtime implementation and the full headless automated regression are merged-main verified by PR #188 (`740b4b9312fa27289fd62baab8dda54c68ead3a7`): 111 cases / 13,461 assertions, 7 required CI checks, and SX-AUD-071 five-pass review. Package, physical, device, human, and player-experience evidence remain `NOT_RUN`.

## Physical evidence and Candidate transition

### Candidate 002 · historical physical evidence

```yaml
candidate_id: SX59-POC-ACCEPT-002
package_verification: PASS
windows_physical_startup_smoke: PASS
engine: Godot_4_7_1
renderer: OpenGL_3_3_Compatibility
gpu: NVIDIA_GeForce_RTX_3050
result: BLOCKED_BY_CONFIRMED_P1_PREFLIGHT_VISUAL_DEFECTS
acceptance_promotion: PROHIBITED
```

실제 화면에서 preflight badge/text overlap과 problem-cell target identity obscuration risk가 확인됐고, PR #171이 player-visible presentation bytes를 교정했다.

### Candidate 003 · historical pre-SX-DEC-060 exact evidence

```yaml
candidate_id: SX59-POC-ACCEPT-003
historical_pointer: evidence/acceptance/current_poc_candidate.json
corrected_runtime_pr: 171
artifact_workflow_run_id: 32715351609
artifact_zip_sha256: 8b4e630c667b5fd88886878e5a07401c1fe6cfd8f1f9d84b2ab39cb8824923d4
windows_exe_sha256: 1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244
windows_pck_sha256: 2e9634cedd6da49793973f4582e2bd58ea4daae2fec246657edcf58ae360af72
pck_integrity: PASS · 472/472
product_texture_packaging: PASS · 73/73
powershell_51_live_download: PASS
physical_visual_recheck: NOT_RUN
developer_self_run: NOT_RUN
windows_full_physical_runtime: NOT_RUN
audio_perceptual_qa: NOT_RUN
android_device: NOT_RUN
five_person_comprehension: NOT_RUN
player_experience: NOT_RUN
role_after_sx_dec_060: HISTORICAL_PRE_CHANGE_EVIDENCE_ONLY
```

Automated/package/launcher PASS는 corrected physical appearance 또는 player-experience PASS가 아니다. SX-DEC-060가 gameplay bytes를 변경하므로 Candidate 003을 post-060 acceptance로 승격할 수 없다.

## Current execution boundary

```text
pre-SX-DEC-060:
PR #158 implementation → PR #166 playable POC → PR #171 visual correction → PR #172 Candidate 003

current:
SX-DEC-060 merged main PR #188 → SX-DEC-062 merged main PR #237 → SX-DEC-063 Core Board v04 centred-port rail correction merged main PR #255
→ SX-DEC-064 active-route lighting merged main PR #249 with exact-head CI 7 green
→ SX60-POC-ACCEPT-004 remains historical package evidence for pre-v04 product bytes
→ SX-DEC-065 USER_APPROVED · MACHINE_PRIMARY_FINAL_USER_REVIEW
→ mint a new immutable exact candidate and execute deterministic renderer/import/Godot/GUT/export/package/CI evidence
→ machine acceptance decision
→ FINAL_USER_REVIEW only on that exact candidate when requested
→ Android device compatibility only when the Android target is in scope
→ FIVE_PERSON_COMPREHENSION_NOT_REQUIRED / PLAYER_EXPERIENCE_STUDY_NOT_REQUIRED
```

Candidate 003 Gate 0 is retained as historical pre-060 validation instructions but is no longer the next efficient product gate after the user-approved gameplay change.

## Protected future packages

```text
SX-DEC-056A full Route Probe / Actual Trace / PB / Fingerprint → IMPLEMENTATION_NOT_AUTHORIZED
SX-DEC-056B score/max-combo → BLOCKED_BY_AUTHORITATIVE_SCORE_COMBO_RUNTIME
SX-DEC-057 Yard Labs/Mastery → IMPLEMENTATION_NOT_AUTHORIZED
SX-DEC-058 challenge generator/pipeline → IMPLEMENTATION_NOT_AUTHORIZED
BMK-R09 Shareable Route Card → POST_VALIDATION_HOLD
BMK-R10 Editor/UGC → POST_VALIDATION_HOLD
```

Historical endless/fuel/BOOST/capacity-8/cargo-slowdown/pickup-respawn/switch-auto-reset는 current 의미로 재활성화하지 않는다. SX-DEC-060 이외의 새 제품 Decision은 별도 사용자 승인 없이 만들지 않는다.
