# Switchy Express 프로젝트 허브

Last updated: `2026-08-24 KST`

## Current State

| 항목 | 현재 값 |
|---|---|
| 제품 기준선 | `GMB-002 · FINITE_DELIVERY_PUZZLE_BASELINE` |
| 결정 범위 | `SX-DEC-027~059` |
| 작업지시문 | `v4.8 · revision 2026-08-24-r2 · Switchy thin adapter` |
| 작업지시문 source SHA-256 | `6f0541048e084746f6777223521361d0339dbfb2e223c70947f694f1c050f508` |
| v4.8 authority merge | `PR #164 · main 98ed1c65d678bfc262c32084bbf0e59368093c2c` |
| User planning-complete gate | `GRANTED · 2026-08-20 KST` |
| SX-DEC-059 | `PR #158 MERGED_MAIN_VERIFIED · FIVE_PASS_AND_INDEPENDENT_REVIEW_CLOSED` |
| SX-DEC-059 main | `162e8a0a5e8ddc8472e74a6152e87dc12008e34c` |
| Playable visual/UX POC | `PR #166 MERGED_MAIN_VERIFIED · main 1bf798cedf28dffba9185edb62fb1c50c108fe90` |
| POC visual surface | `board/HUD/title/lesson/result · approved E+D assets consumed at runtime` |
| Current POC candidate | `SX59-POC-ACCEPT-002 · PREPARED · PENDING_DEVELOPER_SELF_RUN` |
| Notion implementation readback | `PASS · POST_PR_158_READBACK_COMPLETE` |
| Phase C | `PASS · SX-AUD-064 · CLEAN_REVIEW_EXIT` |
| Package spec DoR | `PASS` |
| Execution preflight | `PASS · isolated worktree · Godot 4.7.1` |
| Codex handoff | `USER_REQUESTED_AND_EXECUTED` |
| BUILD | `PLAYABLE_VISUAL_UX_POC_AUTOMATED_AND_PACKAGE_GREEN` |
| SX-DEC-055 | `IMPLEMENTED · PR #151 MERGED · runtime_integrated=true` |
| SX-DEC-056A | `PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED` |
| SX-DEC-056B | `BLOCKED_BY_AUTHORITATIVE_SCORE_COMBO_RUNTIME` |
| SX-DEC-057 | `PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED` |
| SX-DEC-058 | `PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED` |
| semantic product PNG | `73 · PRODUCTION_COMPLETE · PLAYABLE_POC_CONSUMED` |
| Base compatibility pin | `v9.4.3 · HISTORICAL_COMPATIBILITY` |
| Base latest observed | `2828a74f60c1ed09546171040f4178c8848ea686 · ALWAYS_REFETCH_CURRENT_COMPLETED_MAIN` |
| PR #154 | `CLOSED_UNMERGED · SUPERSEDED_BY_059` |
| developer self-run | `NOT_RUN` |
| acceptance build | `NOT_YET_DESIGNATED` |
| Windows physical runtime | `NOT_RUN` |
| ANDROID DEVICE SMOKE | `NOT_RUN` |
| FIVE-PERSON COMPREHENSION | `NOT_RUN` |
| Player experience | `NOT_RUN` |
| Production cutover | `BLOCKED_DEFERRED` |

## Stable acceptance compatibility anchors

```text
SX-DEC-055: MERGED_MAIN_VERIFIED
ANDROID DEVICE SMOKE: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
PRODUCTION CUTOVER: BLOCKED_DEFERRED
```

이 literal은 device/human canonical-freshness consumer가 사용하는 안정 locator다. SX-DEC-059가 새 release-near target이 되어도 과거 device gate 이름을 삭제하지 않는다.

## One-line product promise

> 노선을 그려 화물 조우 순서를 만들고, 적재 선택으로 LIFO를 설계한 뒤, 운행 중 분기 판단으로 계획을 실행하고 결과를 보고 다시 설계하는 finite cargo puzzle.

## Mandatory read order

1. fresh Base latest completed `main` + Base root `AGENTS.md`.
2. fresh project `main`, latest commit, all Open/Draft PR.
3. exact Switchy Notion Project Home.
4. `AGENTS.md`.
5. `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md`.
6. `FINITE_DELIVERY_PUZZLE_BASELINE.md`.
7. `CURRENT_CONFIRMED_DECISIONS.md`.
8. `ACTIVE_CONTEXT.md`.
9. `SX_AUD_069_PLAYABLE_VISUAL_UX_POC.md`.
10. `SX_DEC_059_POC_ACCEPTANCE_CANDIDATE_02.md` + `SX_DEC_059_POC_DEVELOPER_SELF_RUN_RECORD_02.md` when executing the current manual gate.
11. `ROADMAP.md`.
12. `DEVELOPMENT_GATES.md`.
13. exact SX-DEC-059 content/UI/localization/visual/playtest owner.
14. actual code/data/Scene/Resource/assets/tests.
15. implementation/handoff package only when historical execution evidence is needed.

`PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.7_SWITCHY_ADAPTER.md`는 2026-08-20~23 작업의 **historical rollback/provenance evidence**이며 current work-instruction authority가 아니다.

Google Sheets는 migration-only이며 새 작업의 active input이 아니다.

## Current core flow

```text
BUILD: 선로로 조우 순서 설계
→ RUN: manual/auto로 적재 여부 결정
→ LIFO TOP으로 배송 가능 순서 형성
→ switch로 계획 실행
→ result
→ Retry same layout 또는 Edit layout
```

## SX-DEC-059 · Release-Near First Session

```text
T1 · Track Connection
→ T2 · Cargo/Station + basic manual pickup
→ T3 · LIFO/TOP reverse planning
→ T4 · selective non-load + revisit
→ T5 · Auto ON safe / OFF decision
→ T6 · switch execution
→ existing VS_DEMO_01 capstone
→ Result / Retry / Edit
```

### Confirmed learning progression

```text
T1: 연결했다
T2: 실어서 보냈다
T3: 거꾸로 생각했다
T4: 안 싣는 것도 선택했다
T5: 자동을 켜고 끄며 계획했다
T6: 운행 중 계획을 실행했다
Capstone: 새 설명 없이 종합했다
```

### Content / architecture boundary

- 5 tutorial map definitions implemented and packaged.
- T1/T2 share one map, ProductFiniteSlice instance, and valid layout.
- exact coordinates/JSON/private witnesses are committed RED-first outputs.
- existing `VS_DEMO_01` remains unchanged by default.
- first-session metadata stays outside `FiniteMapDefinition` schema v2.
- sidecar owners: Definition / StagePolicy / Director / Copy.
- StagePolicy gates UI + keyboard/touch/board/route commands at ProductFiniteSlice.
- standalone demo remains compatibility path; main product opts into first-session mode.

## Current playable visual / UX POC

PR #166은 새 규칙을 추가하지 않고 이미 승인된 E+D Hybrid asset을 실제 player-visible surface에 소비시켰다.

```text
board
→ approved train / rail / station / cargo textures
HUD
→ straight / curve / switch / crossing product icons
title / lesson briefing
→ same product visual language + lesson progress
result
→ existing finite outcome에 따라 approved SUCCESS / FAILURE art
```

절차적 도형·shape/text cue는 texture load 실패 fallback 및 non-color readability 보조로 유지한다.

Exact-head automated/package evidence:

```text
Project Contract: PASS
Thin Adapter: PASS
GUT 9.7.1: PASS
Godot headless: 111 cases PASS
Windows Demo Export: PASS
Windows packaged runtime JSON proof: PASS
Android packaged runtime JSON proof: PASS
```

이 증거는 physical/human/player PASS가 아니다.

## Current visual / localization policy

- E+D Hybrid · Neo-Arcade Readability.
- current 73 semantic PNGs first; playable POC가 핵심 board/HUD/shell에서 실제 consume한다.
- no new generated image currently required; image generation not requested.
- locales: `ko / en / ja / zh-Hans`.
- `zh-Hant` deferred until a release target requires it.
- no raw localization key and no localized text in reusable PNG.

## Current evidence-safe Result

059 Result can use only existing runtime truth:

```text
ROUTE_END | TIME_EXPIRED
remaining_map_cargo
stack_size
```

Do not fabricate detailed station mismatch/trace before an authorized observation owner exists.

## Current execution chain

```text
Phase-C PASS
→ USER_REQUESTED_CODEX_HANDOFF
→ isolated workspace + baseline GREEN
→ Codex RED-first BUILD
→ five-pass adversarial review + corrections
→ PR #158 MERGED_MAIN_VERIFIED
→ Notion implementation readback PASS
→ PR #166 playable visual/UX POC MERGED_MAIN_VERIFIED
→ SX59-POC-ACCEPT-002 prepared
→ developer self-run / screen QA
→ exact acceptance build physical smoke
→ Five-person first-contact evidence
→ separate product decision
```

`SX_DEC_059_IMPLEMENTATION: MERGED_MAIN_VERIFIED`. POC automated/package 증거까지 추가됐지만 물리 실행·사람 이해도 검증은 아직 시작하지 않았다.

## Protected boundaries

- product baseline = GMB-002.
- no endless/fuel/BOOST/capacity-8/cargo-slowdown/pickup-respawn/switch-auto-reset.
- no implicit 056/057/058 implementation.
- no score/combo or fast/cheap TrackPiece invention.
- no player-facing solver.
- no Base repin.
- PR #154 code is not absorbed; it is closed unmerged and superseded by the product-owned implementation.
- automated/package/self-run evidence does not imply human PASS.

## Current detail owners

- `기획서/20_시스템_콘텐츠/FIRST_SESSION_STAGE_CONTENT_SPEC_V1.md`
- `기획서/30_UI_UX/FIRST_SESSION_SCREEN_CONTENT_DATA_CONTRACT.md`
- `기획서/30_UI_UX/FIRST_SESSION_LOCALIZATION_COPY_MATRIX_V1.md`
- `기획서/30_UI_UX/FIRST_SESSION_LOCALIZATION_COPY_ADDENDUM_01.md`
- `기획서/40_표현/SX_DEC_059_VISUAL_REQUIREMENT_BRIEFS.md`
- `기획서/50_제작_검증/SX_DEC_059_RELEASE_NEAR_FIRST_SESSION_VERTICAL_SLICE.md`
- `기획서/50_제작_검증/PLAYTEST_PLAN_V4_7_CURRENT.md`
- `기획서/50_제작_검증/SX_DEC_059_FIRST_SESSION_PLAYTEST_DELTA.md`
- `기획서/50_제작_검증/SX_AUD_064_SX_DEC_059_PHASE_C_FINAL_REVIEW.md`
- `기획서/50_제작_검증/SX_AUD_066_SX_DEC_059_IMPLEMENTATION_AND_FIVE_PASS_REVIEW.md`
- `기획서/50_제작_검증/SX_AUD_069_PLAYABLE_VISUAL_UX_POC.md`
- `기획서/50_제작_검증/SX_DEC_059_POC_ACCEPTANCE_CANDIDATE_02.md`
- `기획서/50_제작_검증/SX_DEC_059_POC_DEVELOPER_SELF_RUN_RECORD_02.md`

## Current next action

```text
SX59-POC-ACCEPT-002 developer self-run / screen QA
→ if clean, designate exact acceptance build
→ Windows physical smoke
→ Android device smoke as separate platform gate
→ Five-person first-contact comprehension
→ EXPAND / REWORK / REPEAT_SLICE / HOLD / STOP
```