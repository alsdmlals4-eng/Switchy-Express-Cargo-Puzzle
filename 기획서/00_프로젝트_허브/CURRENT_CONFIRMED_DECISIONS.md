# Current Confirmed Decisions

Last updated: `2026-08-26 KST`

이 문서는 Switchy Express의 **현재 승인 Decision과 실행 권위**를 압축한다. 상세 규칙·근거·역사 CI는 각 Decision/Audit owner가 책임진다. Google Sheets는 migration-only이며 active decision authority가 아니다.

## Current authority snapshot

```yaml
current_product_baseline: GMB-002 · FINITE_DELIVERY_PUZZLE_BASELINE · AMENDED_BY_SX_DEC_060
current_decision_span: SX-DEC-027~060
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
fresh_read_bootstrap: PROJECT_GITHUB_NOTION_ONLY_RECONSTRUCTION_REQUIRED
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
candidate_002_windows_physical_startup_smoke: PASS
candidate_002_result: BLOCKED_BY_CONFIRMED_P1_PREFLIGHT_VISUAL_DEFECTS
candidate_002_acceptance_promotion: PROHIBITED
candidate_003_package_integrity: PASS · HISTORICAL_PRE_SX_DEC_060
candidate_003_pck_integrity: PASS · 472_OF_472 · HISTORICAL_PRE_SX_DEC_060
candidate_003_product_textures: PASS · 73_OF_73 · HISTORICAL_PRE_SX_DEC_060
candidate_003_powershell_51_live_download: PASS · HISTORICAL_PRE_SX_DEC_060
candidate_003_physical_visual_recheck: NOT_RUN
sx_dec_060_user_rule: APPROVED
sx_dec_060_design: RECORDED
sx_dec_060_runtime_implementation: NOT_RUN
sx_dec_060_automated_regression: NOT_RUN
sx_dec_060_post_change_candidate: NOT_CREATED
sx_dec_060_notion_sync: PENDING_THIS_CHANGESET
developer_self_run: NOT_RUN_POST_SX_DEC_060
acceptance_build: NOT_YET_DESIGNATED_POST_SX_DEC_060
windows_full_physical_runtime: NOT_RUN_POST_SX_DEC_060
audio_perceptual_qa: NOT_RUN_POST_SX_DEC_060
android_device: NOT_RUN_POST_SX_DEC_060
five_person_comprehension: NOT_RUN_POST_SX_DEC_060
player_experience: NOT_RUN_POST_SX_DEC_060
production_cutover: BLOCKED_DEFERRED
sx_dec_055_runtime_implementation: MERGED_MAIN_VERIFIED · PR_151
sx_dec_056a: DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
sx_dec_056b: BLOCKED_BY_AUTHORITATIVE_SCORE_COMBO_RUNTIME
sx_dec_057: DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
sx_dec_057_fast_cheap: BLOCKED_BY_STAGE8_TRACK_ATTRIBUTE_RUNTIME
sx_dec_058: DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
semantic_product_assets: 73_TOTAL · PRODUCTION_COMPLETE
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
| SX-DEC-033 | 별·랭킹 · APPROVED · NOT_STARTED |
| SX-DEC-034 | Tutorial 1~10 + 2-of-3 progression · APPROVED |
| SX-DEC-035 | Daily/Weekly fixed seed · APPROVED · NOT_RUN |
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
| **SX-DEC-060** | **Cardinal Station Service + Reachable Network · USER_APPROVED_CORE_DELTA · DESIGN_RECORDED · RUNTIME_NOT_RUN** |

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

Runtime implementation, automated regression, package, physical, device, human, and player-experience evidence are all still `NOT_RUN` for SX-DEC-060.

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
SX-DEC-060 user rule APPROVED
→ decision/spec/TDD plan/Codex handoff canon sync
→ Codex Godot runtime implementation from merged current main
→ schema v3 + map/tutorial migration
→ full automated regression + five-pass adversarial review
→ new exact post-060 packaged candidate
→ Windows physical smoke
→ Android device smoke
→ Five-person first-contact comprehension
→ EXPAND / REWORK / REPEAT_SLICE / HOLD / STOP
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
