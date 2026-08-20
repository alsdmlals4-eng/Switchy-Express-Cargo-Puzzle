# Current Confirmed Decisions

Last updated: `2026-08-20 KST`

이 문서는 Switchy Express의 **현재 승인 Decision과 실행 권위**를 압축한다. 상세 규칙·근거·역사 CI는 각 Decision/Audit owner가 책임진다. Google Sheets는 migration-only이며 active decision authority가 아니다.

## Current authority snapshot

```yaml
current_product_baseline: GMB-002 · FINITE_DELIVERY_PUZZLE_BASELINE
current_decision_span: SX-DEC-027~059
work_instruction: v4.7 · 2026-08-20-r1 · SWITCHY_THIN_ADAPTER
work_instruction_source_sha256: 767bbe3d69e9a0acb0e5706321564ad8c04a451f7c54914a2bbdd7579f642037
latest_visual_asset_authority: SX-DEC-053
latest_visual_semantic_strategy: SX-DEC-054
latest_runtime_semantic_poc_authority: SX-DEC-055
latest_route_learning_authority: SX-DEC-056
latest_curriculum_authority: SX-DEC-057
latest_challenge_quality_authority: SX-DEC-058
latest_first_session_vertical_slice_authority: SX-DEC-059
latest_tooling_authority: SX-DEC-052
project_base_pin: v9.4.3
base_remote_latest_observed: ef0092256be25eaa70a296a76d02f7205934929e · REFERENCE_ONLY
project_main_at_059_planning_complete: 0a88f707e1e4131ae4372929f2871d2b8a3a74b7
phase_a_state: COMPLETE
sx_dec_059_user_planning_complete_gate: GRANTED · explicit "기획완료" · 2026-08-20 KST
sx_dec_059_phase_c_final_review: IN_PROGRESS_UNTIL_CANON_SYNC_CLEAN_EXIT
sx_dec_059_implementation_scope: APPROVED_CANON · EXECUTION_NOT_STARTED
sx_dec_059_codex_handoff: NOT_REQUESTED
sx_dec_055_runtime_implementation: MERGED_MAIN_VERIFIED
sx_dec_055_merge_pr: 151
sx_dec_055_merge_main: 534a7318b349cd3e784a3467125f9ebd23124d8a
runtime_integrated: true
sx_dec_056a_planning: DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
sx_dec_056b_planning: BLOCKED_BY_AUTHORITATIVE_SCORE_COMBO_RUNTIME
sx_dec_057_planning: DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
sx_dec_057_attribute_content: BLOCKED_BY_STAGE8_TRACK_ATTRIBUTE_RUNTIME
sx_dec_058_planning: DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
benchmark_approved_planning: R01~R08 · DETAILED_PLANNING_CLOSED
benchmark_hold: BMK-R09/R10 · POST_VALIDATION_HOLD
semantic_product_assets: 73_TOTAL · PRODUCTION_COMPLETE
acceptance_build: UNASSIGNED
windows_physical_runtime: NOT_RUN
android_device: NOT_RUN
five_person_comprehension: NOT_RUN
player_experience: NOT_RUN
production_cutover: BLOCKED_DEFERRED
```

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

| Decision ID | 분야 | 현재 권위 / 상태 |
|---|---|---|
| SX-DEC-027 | 제품 핵심 | 유한 고정 화물 배송 퍼즐 · CURRENT |
| SX-DEC-028 | 건설 | 자유 선로 건설·비용·전액 환급·추천 비용 · CURRENT |
| SX-DEC-029 | 운행·판정 | 구조 검사·제한 시간·성공/실패·pause · CURRENT |
| SX-DEC-030 | 선로 | 직선·곡선·분기·교차 · CURRENT |
| SX-DEC-031 | 적재·LIFO | manual hold·auto toggle·unlimited stack·TOP 그룹 하역 · CURRENT |
| SX-DEC-032 | Combo | 하역 그룹 feedback · CURRENT; 056용 max-combo runtime metric은 미확정 |
| SX-DEC-033 | 별·랭킹 | APPROVED · NOT_STARTED |
| SX-DEC-034 | 캠페인 | Tutorial 1~10 + 2-of-3 progression protected · APPROVED |
| SX-DEC-035 | 반복 도전 | Daily/Weekly fixed seed · APPROVED · NOT_RUN |
| SX-DEC-036 | 공정성 | cosmetic-only, power progression 금지 · CURRENT |
| SX-DEC-037 | PC Vertical Slice | IMPLEMENTED · AUTOMATED_CORE_PASS · manual gates open |
| SX-DEC-038 | Demo Route Refinement | IMPLEMENTED · automated pass · physical gates open |
| SX-DEC-039 | Mid-Run Exit | IMPLEMENTED · feature-scoped evidence; full local retest open |
| SX-DEC-040 | Station Color Parity | CURRENT · AUTOMATED_PARITY_PASS |
| SX-DEC-041 | Route-End Failure | MERGED_MAIN_VERIFIED · AUTOMATED_PASS |
| SX-DEC-042 | Switch Direction Arrows | MERGED_MAIN_VERIFIED · AUTOMATED_PASS |
| SX-DEC-043 | v4.3 Entry Gate | APPROVED_GOVERNANCE · HISTORICAL |
| SX-DEC-044 | GUT 9.7.1 | CURRENT_TEST_AUTHORITY |
| SX-DEC-045 | Godot Authoring Authority | CURRENT_BOUNDARY · connected physical authoring NOT_RUN |
| SX-DEC-046 | Focused Visual/Audio Component | route procedural arrow safety · CURRENT |
| SX-DEC-047 | Validation Execution Fallback | SUPERSEDED by SX-DEC-048 |
| SX-DEC-048 | Standard Hosted Actions Authority | CURRENT_VALIDATION_EXECUTION_AUTHORITY |
| SX-DEC-049 | Cargo Pickup Marker Visibility | MERGED_MAIN_VERIFIED |
| SX-DEC-050 | Finite Visual Planning Package | PLANNING_PACKAGE_MERGED |
| SX-DEC-051 | E+D Hybrid Production Asset Pack | MERGED_MAIN_VERIFIED |
| SX-DEC-052 | Local Tooling & Asset-Vault | CURRENT TOOLING EVIDENCE · Godot AI 3.1.4 provenance reverify required |
| SX-DEC-053 | Final E+D Production Visual Direction | 39 baseline product assets · CURRENT |
| SX-DEC-054 | Semantic Asset Completion | RUN 20 + BUILD 8 + VFX 6 · 73 TOTAL · PRODUCTION_COMPLETE |
| SX-DEC-055 | Runtime Semantic POC | IMPLEMENTED · PR #151 MERGED · automated/export proof PASS · physical/human NOT_RUN |
| SX-DEC-056 | Route Causality / Result Feedback | 056A planning-ready but implementation unauthorized · 056B dependency blocked |
| SX-DEC-057 | Yard Labs / Mastery | planning-ready but implementation unauthorized · fast/cheap dependency gated |
| SX-DEC-058 | Fixed-Seed Challenge Quality | planning-ready but implementation/pipeline unauthorized |
| **SX-DEC-059** | **Release-Near First Session Vertical Slice** | **USER_APPROVED · PLANNING_COMPLETE_GRANTED · PHASE_C_PACKAGE_PREP · BUILD_NOT_STARTED** |

## SX-DEC-059 confirmed contract

### First-session flow

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

### GM-SX059-01

`A · PREREQUISITE_ACTION_EARLY · STRATEGY_LATER` approved.

- T2 teaches how to perform manual pickup when first needed.
- T4 teaches when **not** to load, then revisit.
- manual=false / auto=false default remains unchanged.

### Content / architecture

- 5 new tutorial maps target; exact coordinates/JSON bytes are BUILD-time RED-first outputs.
- T1/T2 share one map and preserve the valid layout across the lesson boundary.
- `VS_DEMO_01` is the capstone and remains unchanged by default.
- Tutorial metadata stays outside `FiniteMapDefinition` schema v2.
- onboarding/presentation sidecar: `FirstSessionDirector + FirstSessionStagePolicy`.
- StagePolicy controls both visible UI and allowed command paths including keyboard/touch.

### Result evidence

059 baseline Result uses only current runtime truth:

```text
ROUTE_END / TIME_EXPIRED
+ remaining_map_cargo
+ stack_size
```

Station mismatch sentences such as `B역에서 TOP=A` are not produced until an authorized observation owner actually exists. Full SX-DEC-056A is not implicitly authorized.

### Visual / localization

- existing 73 semantic product assets first.
- image generation not requested; no new generated image is required by current plan.
- new first-session copy uses localization keys for ko/en/ja/zh-*.
- no text baked into reusable PNG.
- responsive meaning preserved across PC standard/wide and mobile landscape.

### Player evidence

`SX_DEC_059_FIRST_SESSION_PLAYTEST_DELTA.md` extends, not replaces, `PLAYTEST_PLAN.md`.

```text
AUTOMATED CONTRACT
→ developer self-run / screen QA
→ exact acceptance build + physical smoke
→ first-contact Five-person Comprehension
→ EXPAND / REWORK / REPEAT_SLICE / HOLD / STOP
```

Human/player-experience evidence is still `NOT_RUN`.

## Protected future packages

```text
SX-DEC-056A full Route Probe / Actual Trace / PB / Fingerprint → NOT AUTHORIZED BY 059
SX-DEC-056B score/max-combo → BLOCKED
SX-DEC-057 Yard Labs/Mastery → NOT AUTHORIZED BY 059
SX-DEC-058 challenge generator/pipeline → NOT AUTHORIZED BY 059
BMK-R09 Shareable Route Card → POST_VALIDATION_HOLD
BMK-R10 Editor/UGC → POST_VALIDATION_HOLD
```

Historical endless/fuel/BOOST/capacity-8/cargo-slowdown/pickup-respawn/switch-auto-reset는 current 의미로 재활성화하지 않는다.

## Current execution boundary

```text
SX-DEC-059 user planning complete
→ fresh Phase-C final review + canon/Notion reconciliation
→ implementation package DoR
→ USER_REQUESTED_CODEX_HANDOFF
→ Fresh PowerShell/Codex BUILD
```

현재는 **implementation package 준비 단계**이며 실제 Godot/Codex BUILD는 시작하지 않았다.
