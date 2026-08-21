# Switchy Express 프로젝트 허브

Last updated: `2026-08-21 KST`

## Current State

| 항목 | 현재 값 |
|---|---|
| 제품 기준선 | `GMB-002 · FINITE_DELIVERY_PUZZLE_BASELINE` |
| 결정 범위 | `SX-DEC-027~059` |
| 작업지시문 | `v4.7 · revision 2026-08-20-r1 · Switchy thin adapter` |
| User planning-complete gate | `GRANTED · 2026-08-20 KST` |
| SX-DEC-059 | `IMPLEMENTED_AUTOMATED · FIVE_PASS_AND_INDEPENDENT_REVIEW_CLOSED` |
| Phase C | `PASS · SX-AUD-064 · CLEAN_REVIEW_EXIT` |
| Package spec DoR | `PASS` |
| Execution preflight | `PASS · isolated worktree · Godot 4.7.1` |
| Codex handoff | `USER_REQUESTED_AND_EXECUTED` |
| BUILD | `RELEASE_NEAR_VERTICAL_SLICE_AUTOMATED_GREEN` |
| SX-DEC-055 | `IMPLEMENTED · PR #151 MERGED · runtime_integrated=true` |
| SX-DEC-056A | `PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED` |
| SX-DEC-056B | `BLOCKED_BY_AUTHORITATIVE_SCORE_COMBO_RUNTIME` |
| SX-DEC-057 | `PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED` |
| SX-DEC-058 | `PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED` |
| semantic product PNG | `73 · PRODUCTION_COMPLETE` |
| Base pin | `v9.4.3` |
| Base remote latest observed | `ef0092256be25eaa70a296a76d02f7205934929e · REFERENCE_ONLY` |
| Project main before implementation | `4b37c154505ed1975735fc305a68b410877a40e0` |
| PR #154 | `AUDITED · SUPERSEDED_UNMERGED_BY_059` |
| acceptance build | `UNASSIGNED` |
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

1. fresh Base latest completed `main`.
2. fresh project `main`, latest commit, all Open/Draft PR.
3. exact Switchy Notion Project Home.
4. `AGENTS.md`.
5. `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.7_SWITCHY_ADAPTER.md`.
6. `FINITE_DELIVERY_PUZZLE_BASELINE.md`.
7. `CURRENT_CONFIRMED_DECISIONS.md`.
8. `ACTIVE_CONTEXT.md`.
9. `ROADMAP.md`.
10. `DEVELOPMENT_GATES.md`.
11. exact SX-DEC-059 content/UI/localization/visual/playtest owner.
12. actual code/data/Scene/Resource/assets/tests.
13. implementation/handoff package only when Codex execution is requested.

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

## Current visual / localization policy

- E+D Hybrid · Neo-Arcade Readability.
- current 73 semantic PNGs first.
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
→ exact-head automated/package review
→ GitHub merge + Notion readback
→ developer self-run / screen QA
→ exact acceptance build physical smoke
→ Five-person first-contact evidence
→ separate product decision
```

`SX_DEC_059_IMPLEMENTATION: IMPLEMENTED_AUTOMATED`. 물리 실행·사람 이해도 검증은 아직 시작하지 않았다.

## Protected boundaries

- product baseline = GMB-002.
- no endless/fuel/BOOST/capacity-8/cargo-slowdown/pickup-respawn/switch-auto-reset.
- no implicit 056/057/058 implementation.
- no score/combo or fast/cheap TrackPiece invention.
- no player-facing solver.
- no Base repin.
- PR #154 code is not absorbed; it is superseded by the product-owned implementation.
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
