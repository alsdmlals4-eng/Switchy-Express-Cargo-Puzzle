# Current Confirmed Decisions

Last updated: `2026-08-24 KST`

이 문서는 Switchy Express의 **현재 승인 Decision과 실행 권위**를 압축한다. 상세 규칙·근거·역사 CI는 각 Decision/Audit owner가 책임진다. Google Sheets는 migration-only이며 active decision authority가 아니다.

## Current authority snapshot

```yaml
current_product_baseline: GMB-002 · FINITE_DELIVERY_PUZZLE_BASELINE
current_decision_span: SX-DEC-027~059
work_instruction: v4.8 · 2026-08-24-r2 · SWITCHY_THIN_ADAPTER
work_instruction_source_sha256: 6f0541048e084746f6777223521361d0339dbfb2e223c70947f694f1c050f508
v4_8_authority_merge_pr: 164
v4_8_authority_merge_main: 98ed1c65d678bfc262c32084bbf0e59368093c2c
v4_7_adapter: HISTORICAL_ROLLBACK_EVIDENCE
project_base_compatibility_pin: v9.4.3 · HISTORICAL_COMPATIBILITY
base_v4_8_authority_time_snapshot: 2828a74f60c1ed09546171040f4178c8848ea686
base_latest_observed: 7a8b1c596f9cf1e8da8d2652be076a0624e0b4a2
base_latest_policy: ALWAYS_REFETCH_CURRENT_COMPLETED_MAIN
sx_dec_059_merge_pr: 158
sx_dec_059_merge_main: 162e8a0a5e8ddc8472e74a6152e87dc12008e34c
SX_DEC_059_IMPLEMENTATION: MERGED_MAIN_VERIFIED
sx_dec_059_repository_canon: MERGED_MAIN_VERIFIED
sx_dec_059_notion_sync: PASS · POST_PR_158_READBACK_COMPLETE
sx_dec_059_review: FIVE_PASS_AND_INDEPENDENT_REVIEW_CLOSED · SX-AUD-066
playable_visual_ux_poc: MERGED_MAIN_VERIFIED · PR_166 · main_1bf798cedf28dffba9185edb62fb1c50c108fe90
physical_preflight_visual_correction: MERGED_MAIN_VERIFIED · PR #171 · main_9d82b004b2ebf3f7d69d0376c79daae1040e94a4
candidate_003_preparation: MERGED_MAIN_VERIFIED · PR #172 · main_2521f3be600ea950f9893ce45940604c2d0ac88a
current_candidate_pointer: evidence/acceptance/current_poc_candidate.json
current_candidate: SX59-POC-ACCEPT-003
candidate_002_windows_physical_startup_smoke: PASS
candidate_002_result: BLOCKED_BY_CONFIRMED_P1_PREFLIGHT_VISUAL_DEFECTS
candidate_002_acceptance_promotion: PROHIBITED
candidate_003_package_integrity: PASS
candidate_003_pck_integrity: PASS · 472_OF_472
candidate_003_product_textures: PASS · 73_OF_73
candidate_003_powershell_51_live_download: PASS
candidate_003_physical_visual_recheck: NOT_RUN
developer_self_run: NOT_RUN
acceptance_build: NOT_YET_DESIGNATED
windows_full_physical_runtime: NOT_RUN
audio_perceptual_qa: NOT_RUN
android_device: NOT_RUN
five_person_comprehension: NOT_RUN
player_experience: NOT_RUN
production_cutover: BLOCKED_DEFERRED
sx_dec_055_runtime_implementation: MERGED_MAIN_VERIFIED · PR_151
sx_dec_056a: DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
sx_dec_056b: BLOCKED_BY_AUTHORITATIVE_SCORE_COMBO_RUNTIME
sx_dec_057: DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
sx_dec_057_fast_cheap: BLOCKED_BY_STAGE8_TRACK_ATTRIBUTE_RUNTIME
sx_dec_058: DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
semantic_product_assets: 73_TOTAL · PRODUCTION_COMPLETE
```

`2828a74...`는 v4.8 protected-canon migration 당시 Base snapshot이다. 현재 작업 시에는 `ALWAYS_REFETCH_CURRENT_COMPLETED_MAIN`에 따라 fresh Base completed main을 다시 읽으며, latest observed는 `7a8b1c596f9cf1e8da8d2652be076a0624e0b4a2`다.

## Current core promise

```text
선로 건설로 화물 조우 순서를 설계
→ 수동/자동 적재로 unlimited LIFO 스택 구성
→ 운행 중 분기 경로를 실행
→ TOP 연속 동일 화물 하역
→ 결과를 보고 같은 노선 재도전 또는 재설계
```

핵심 차별점은 **노선을 그리는 행위가 곧 화물 스택의 순서를 설계하는 행위**라는 점이다.

## Current Decision Registry

| Decision ID | 현재 권위 / 상태 |
|---|---|
| SX-DEC-027 | 유한 고정 화물 배송 퍼즐 · CURRENT |
| SX-DEC-028 | 자유 선로 건설·비용·전액 환급·추천 비용 · CURRENT |
| SX-DEC-029 | 구조 검사·제한 시간·성공/실패·pause · CURRENT |
| SX-DEC-030 | 직선·곡선·분기·교차 · CURRENT |
| SX-DEC-031 | manual hold·auto toggle·unlimited LIFO·TOP 그룹 하역 · CURRENT |
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
| **SX-DEC-059** | **Release-Near First Session · implementation/playable POC merged · Candidate 003 current · physical/human acceptance open** |

## SX-DEC-059 confirmed contract

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

### Architecture / evidence boundaries

- T1/T2 share one product instance and valid layout.
- `VS_DEMO_01` remains the capstone.
- tutorial metadata stays outside `FiniteMapDefinition` schema v2.
- `FirstSessionDefinition + FirstSessionStagePolicy + FirstSessionDirector + FirstSessionCopy` are sidecar owners.
- `ProductFiniteSlice` remains the command convergence boundary.
- Result uses current runtime truth only: `ROUTE_END / TIME_EXPIRED + remaining_map_cargo + stack_size`.
- no station mismatch/actual trace fabrication before an authorized observation owner exists.
- existing 73 semantic product assets first; no new generated image is required for the current gate.
- locales: `ko / en / ja / zh-Hans`; `zh-Hant` deferred.

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

### Candidate 003 · current validation target

```yaml
candidate_id: SX59-POC-ACCEPT-003
current_pointer: evidence/acceptance/current_poc_candidate.json
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
```

Automated/package/launcher PASS는 corrected physical appearance 또는 player-experience PASS가 아니다.

## Current manual validation owners

```text
evidence/acceptance/current_poc_candidate.json
기획서/50_제작_검증/SX_DEC_059_POC_ACCEPTANCE_CANDIDATE_03.md
기획서/50_제작_검증/SX_DEC_059_POC_DEVELOPER_SELF_RUN_RECORD_03.md
```

Historical Candidate 002 docs/evidence는 비교·회귀 증거로만 유지한다.

## Current execution boundary

```text
PR #158 SX-DEC-059 implementation MERGED_MAIN_VERIFIED
→ PR #166 playable visual/UX POC MERGED_MAIN_VERIFIED
→ Candidate 002 actual Windows startup PASS / P1 visual findings
→ PR #171 physical preflight visual correction MERGED_MAIN_VERIFIED
→ PR #172 Candidate 003 + explicit current pointer MERGED_MAIN_VERIFIED
→ Candidate 003 physical visual recheck: NOT_RUN
→ if clean, same exact Candidate 003 developer self-run / screen QA + audio perceptual QA
→ exact acceptance build designation
→ Windows full physical smoke
→ Android device smoke
→ Five-person first-contact comprehension
→ EXPAND / REWORK / REPEAT_SLICE / HOLD / STOP
```

## Candidate 003 Gate 0

1. preflight semantic badge가 compact lane에 있고 Korean problem copy와 겹치지 않는지 확인.
2. disconnected station/cargo의 color+shape+text identity가 유지되고 problem reinforcement가 outline만 사용하는지 확인.

하나라도 실패하면 `BLOCKED_P1_VISUAL`로 중단한다.

## Protected future packages

```text
SX-DEC-056A full Route Probe / Actual Trace / PB / Fingerprint → IMPLEMENTATION_NOT_AUTHORIZED
SX-DEC-056B score/max-combo → BLOCKED_BY_AUTHORITATIVE_SCORE_COMBO_RUNTIME
SX-DEC-057 Yard Labs/Mastery → IMPLEMENTATION_NOT_AUTHORIZED
SX-DEC-058 challenge generator/pipeline → IMPLEMENTATION_NOT_AUTHORIZED
BMK-R09 Shareable Route Card → POST_VALIDATION_HOLD
BMK-R10 Editor/UGC → POST_VALIDATION_HOLD
```

Historical endless/fuel/BOOST/capacity-8/cargo-slowdown/pickup-respawn/switch-auto-reset는 current 의미로 재활성화하지 않는다. 새 `SX-DEC-060`은 존재하지 않는다.
