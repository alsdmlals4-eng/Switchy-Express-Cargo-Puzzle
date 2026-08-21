# Current Confirmed Decisions

Last updated: `2026-08-21 KST`

이 문서는 Switchy Express의 **현재 승인 Decision과 실행 권위**를 압축한다. 상세 규칙·근거·역사 CI는 각 Decision/Audit owner가 책임진다. Google Sheets는 migration-only이며 active decision authority가 아니다.

## Current authority snapshot

```yaml
current_product_baseline: GMB-002 · FINITE_DELIVERY_PUZZLE_BASELINE
current_decision_span: SX-DEC-027~059
work_instruction: v4.7 · 2026-08-20-r1 · SWITCHY_THIN_ADAPTER
work_instruction_source_sha256: 767bbe3d69e9a0acb0e5706321564ad8c04a451f7c54914a2bbdd7579f642037
project_base_pin: v9.4.3
base_remote_latest_observed: ef0092256be25eaa70a296a76d02f7205934929e · REFERENCE_ONLY
project_main_before_059_implementation: 4b37c154505ed1975735fc305a68b410877a40e0
sx_dec_059_merge_pr: 158
sx_dec_059_merge_main: 162e8a0a5e8ddc8472e74a6152e87dc12008e34c
sx_dec_059_user_planning_complete_gate: GRANTED · explicit "기획완료" · 2026-08-20 KST
sx_dec_059_phase_c_final_review: PASS · SX-AUD-064 · CLEAN_REVIEW_EXIT
sx_dec_059_repository_canon: MERGED_MAIN_VERIFIED
sx_dec_059_notion_sync: PASS · POST_PR_158_READBACK_COMPLETE
sx_dec_059_package_spec_dor: PASS
sx_dec_059_execution_preflight: PASS
sx_dec_059_codex_handoff: USER_REQUESTED_AND_EXECUTED
SX_DEC_059_IMPLEMENTATION: MERGED_MAIN_VERIFIED
sx_dec_059_build: RELEASE_NEAR_VERTICAL_SLICE_AUTOMATED_GREEN
sx_dec_059_review: FIVE_PASS_AND_INDEPENDENT_REVIEW_CLOSED · SX-AUD-066
sx_dec_055_runtime_implementation: MERGED_MAIN_VERIFIED · PR_151
sx_dec_056a: DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
sx_dec_056b: BLOCKED_BY_AUTHORITATIVE_SCORE_COMBO_RUNTIME
sx_dec_057: DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
sx_dec_057_fast_cheap: BLOCKED_BY_STAGE8_TRACK_ATTRIBUTE_RUNTIME
sx_dec_058: DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
semantic_product_assets: 73_TOTAL · PRODUCTION_COMPLETE
acceptance_build: UNASSIGNED
developer_self_run: NOT_RUN
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

| Decision ID | 현재 권위 / 상태 |
|---|---|
| SX-DEC-027 | 유한 고정 화물 배송 퍼즐 · CURRENT |
| SX-DEC-028 | 자유 선로 건설·비용·전액 환급·추천 비용 · CURRENT |
| SX-DEC-029 | 구조 검사·제한 시간·성공/실패·pause · CURRENT |
| SX-DEC-030 | 직선·곡선·분기·교차 · CURRENT |
| SX-DEC-031 | manual hold·auto toggle·unlimited LIFO·TOP 그룹 하역 · CURRENT |
| SX-DEC-032 | 하역 그룹 feedback · CURRENT; 056 max-combo runtime metric은 미확정 |
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
| SX-DEC-045 | Godot Authoring Authority · current boundary, physical authoring NOT_RUN |
| SX-DEC-046 | procedural route-arrow safety · CURRENT |
| SX-DEC-047 | SUPERSEDED by SX-DEC-048 |
| SX-DEC-048 | Standard Hosted Actions Authority · CURRENT |
| SX-DEC-049 | Cargo Pickup Marker Visibility · MERGED_MAIN_VERIFIED |
| SX-DEC-050 | Finite Visual Planning Package · MERGED |
| SX-DEC-051 | E+D Hybrid Production Asset Pack · MERGED_MAIN_VERIFIED |
| SX-DEC-052 | Local Tooling & Asset-Vault · CURRENT EVIDENCE; Godot AI 3.1.4 provenance reverify required |
| SX-DEC-053 | Final E+D Production Visual Direction · 39 baseline assets |
| SX-DEC-054 | Semantic Asset Completion · RUN 20 + BUILD 8 + VFX 6 · 73 TOTAL |
| SX-DEC-055 | Runtime Semantic POC · PR #151 MERGED · physical/human NOT_RUN |
| SX-DEC-056 | Route Causality / Result Feedback · 056A implementation unauthorized; 056B blocked |
| SX-DEC-057 | Yard Labs / Mastery · implementation unauthorized; fast/cheap dependency gated |
| SX-DEC-058 | Fixed-Seed Challenge Quality · implementation/pipeline unauthorized |
| **SX-DEC-059** | **Release-Near First Session · PR #158 MERGED_MAIN_VERIFIED · FIVE_PASS_AND_INDEPENDENT_REVIEW_CLOSED · PHYSICAL/HUMAN NOT_RUN** |

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

- 5 tutorial maps and deterministic witnesses are implemented and included in export proof.
- T1/T2 share one map and preserve the same valid layout across the lesson boundary.
- `VS_DEMO_01` is the capstone and remains unchanged by default.
- Tutorial metadata stays outside `FiniteMapDefinition` schema v2.
- onboarding sidecar: `FirstSessionDefinition + FirstSessionStagePolicy + FirstSessionDirector + FirstSessionCopy`.
- `ProductFiniteSlice` is the policy-enforced command convergence boundary.
- StagePolicy controls visible UI and keyboard/touch/board/route-control command paths.
- standalone `vertical_slice_demo.tscn` remains compatibility default; `main.tscn` is the first-session opt-in target.

### Result evidence

059 baseline Result uses only current runtime truth:

```text
ROUTE_END / TIME_EXPIRED
+ remaining_map_cargo
+ stack_size
```

Station mismatch/encounter trace is not inferred. Full SX-DEC-056A is not implicitly authorized.

### Visual / localization

- existing 73 semantic product assets first.
- image generation not requested / not run.
- locales: `ko / en / ja / zh-Hans`; `zh-Hant` deferred until a release target requires it.
- no text baked into reusable PNG.
- responsive meaning preserved across PC standard/wide and mobile landscape.

### Player evidence

`PLAYTEST_PLAN_V4_7_CURRENT.md` + `SX_DEC_059_FIRST_SESSION_PLAYTEST_DELTA.md`.

```text
AUTOMATED CONTRACT: PASS · MERGED_MAIN_VERIFIED
→ developer self-run / screen QA: NOT_RUN
→ exact acceptance build: UNASSIGNED
→ physical smoke: NOT_RUN
→ Five-person first-contact comprehension: NOT_RUN
→ EXPAND / REWORK / REPEAT_SLICE / HOLD / STOP
```

Human/player-experience evidence is `NOT_RUN`.

## Implementation package

```text
docs/superpowers/plans/2026-08-20-sx-dec-059-first-session-vertical-slice-implementation.md
→ implementation Amendment 01
→ implementation Amendment 02
→ SX_DEC_059_CODEX_HANDOFF_PACKAGE.md
→ handoff Amendment 01
→ handoff Amendment 02
```

The package is implemented and merged through PR #158. The handoff files remain execution-history/rollback material and must not restart Task 1.

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
Phase-C final review PASS
→ USER_REQUESTED_CODEX_HANDOFF
→ isolated workspace / baseline GREEN
→ Codex RED-first BUILD
→ five-pass adversarial review + corrections
→ PR #158 MERGED_MAIN_VERIFIED
→ Notion post-merge implementation readback PASS
→ developer self-run / screen QA
→ exact acceptance build + physical smoke
→ Five-person first-contact comprehension
```

현재 구현·병합·Notion readback은 완료됐고 physical/device/human 검증은 `NOT_RUN`이다.
