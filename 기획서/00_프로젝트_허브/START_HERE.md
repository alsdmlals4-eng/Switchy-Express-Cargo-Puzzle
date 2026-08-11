# Switchy Express 프로젝트 허브

Last updated: `2026-08-11 KST`

## Current State

| 항목 | 현재 값 |
|---|---|
| 제품 기준선 | `GMB-002 · FINITE_DELIVERY_PUZZLE_BASELINE` |
| 결정 범위 | `SX-DEC-027~058` |
| 작업지시문 | `v4.5 r2 · revision 2026-08-11-r2` |
| Phase A | `COMPLETE` |
| 사용자 planning-complete Gate | `GRANTED · explicit "기획 완료" · 2026-08-11 KST` |
| Phase B | `SX-AUD-047 · PASS` |
| BUILD | `AUTHORIZED AFTER PHASE-B CANON-SYNC MERGE · SX-DEC-055 SCOPE ONLY` |
| 다음 구현 | `SX-DEC-055 Runtime Semantic POC · Task 1 / Step 1.1 RED` |
| SX-DEC-055 구현 | `NOT_STARTED` |
| SX-DEC-056~058 | `USER_APPROVED · PLANNING_CANON · DELTA_DOR_REQUIRED_BEFORE_IMPLEMENTATION` |
| BMK-R09/R10 | `POST_VALIDATION_HOLD · NO_DECISION_ID` |
| semantic product PNG | `73 · PRODUCTION_COMPLETE` |
| runtime_integrated | `false` |
| Base pin | `v9.4.3` |
| Base main | fresh-read every session · `REFERENCE_ONLY` |
| acceptance build | `UNASSIGNED` |
| Windows/Android/connected editor/human | `NOT_RUN` |
| Production cutover | `BLOCKED_DEFERRED` |
| configured Sheet | `1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo` |

저장된 SHA·PR 값은 snapshot이다. 새 세션은 Base/project default branch, 모든 Open/Draft PR, latest commit, configured Sheet를 다시 읽는다.

## One-line product promise

> 선로를 건설해 화물 조우 순서를 설계하고, 수동·자동 적재로 LIFO 스택을 구성하며, 운행 중 분기 경로를 조절해 제한 시간 안에 모든 필수 배송을 완료하는 퍼즐.

추가 승인된 제품 깊이의 내부 문장:

> 노선을 그리는 순간 화물 스택의 순서가 정해지고, 운행은 그 계획을 실행한다.

## Mandatory read order

1. `AGENTS.md`
2. `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.5_r2.md`
3. fresh Base/project main + open/draft PR + latest commit
4. configured Google Sheet current rows
5. `FINITE_DELIVERY_PUZZLE_BASELINE.md`
6. `CURRENT_CONFIRMED_DECISIONS.md`
7. `ACTIVE_CONTEXT.md`
8. `DEVELOPMENT_GATES.md`
9. `기획서/50_제작_검증/SX_AUD_047_PHASE_B_FINAL_PLANNING_REVIEW.md`
10. `기획서/10_경험/SX_BMK_001_APPROVAL_STATUS.md`
11. `기획서/50_제작_검증/SX_AUD_049_BENCHMARK_APPROVAL_AND_POST_PHASE_B_SCOPE_RECONCILIATION.md`
12. `docs/decisions/SX_DEC_055_RUNTIME_SEMANTIC_POC.md`
13. `docs/superpowers/specs/2026-08-10-runtime-semantic-poc-design.md`
14. `docs/superpowers/plans/2026-08-10-sx-dec-055-runtime-semantic-poc.md`
15. `docs/superpowers/plans/2026-08-11-sx-dec-055-phase-b-readiness-amendment.md`
16. only after BUILD authority is current, re-read exact implementation files before RED

When planning the post-Phase-B product-depth packages, also read their exact Decision and design owner files for `SX-DEC-056`, `SX-DEC-057`, and `SX-DEC-058`.

## Current execution chain

```text
PHASE A COMPLETE
→ USER "기획 완료" GRANTED
→ PHASE B FINAL PLANNING REVIEW PASS · SX-AUD-047
→ PHASE-B CANON/SHEET SYNC
→ SX-DEC-055 Task 1 / Step 1.1 RED
→ RED/GREEN implementation through existing presentation seams
→ non-resource JSON export contract + exported-pack proof
→ exact-head automated PR evidence
→ merged-main same-ID SX-DEC-055 closure
→ exact post-POC acceptance build identity
→ physical smoke
→ FIVE-PERSON COMPREHENSION
→ separate production cutover decision
```

The user has temporarily deferred this execution chain because Codex quota is unavailable. The authorization remains valid for SX-DEC-055.

Parallel planning authority created after Phase B:

```text
BMK-R01/R02/R03/R07 → SX-DEC-056
BMK-R04/R05/R06     → SX-DEC-057
BMK-R08             → SX-DEC-058
BMK-R09/R10         → POST_VALIDATION_HOLD
```

`SX-DEC-056~058` require a separate delta DoR/final planning review before implementation and must not be inserted into the existing SX-DEC-055 implementation plan by default.

## Phase B finding that changed implementation readiness

Godot JSON sidecars are non-resource runtime files. Current presets had an empty non-resource export filter, so source-tree/headless success alone could not prove the finite map and semantic manifests would exist in exported packages.

Phase B therefore added a narrow readiness amendment requiring runtime-owned JSON export inclusion and exported-pack proof before POC packaging acceptance:

`docs/superpowers/plans/2026-08-11-sx-dec-055-phase-b-readiness-amendment.md`

This does not add gameplay scope or change the first RED step.

## Protected boundaries

- current product baseline is `GMB-002`; old `GMB-003` route-end/switch package is historical implementation context, not product baseline;
- no endless/fuel/BOOST/capacity-8/cargo-slowdown/pickup-respawn/switch-auto-reset reactivation;
- no new gameplay/domain signal solely for VFX;
- route direction/cycle/hit/lock geometry remains procedural authority;
- no product PNG/semantic sidecar rewrite;
- historical `runtime_integrated=false` provenance remains unchanged;
- Reduced Motion preserves the same information identity while reducing motion only;
- existing Korean text/procedural presentation remains fallback/redundancy during POC;
- SX-DEC-034 Tutorial 1~10 exact order remains protected;
- SX-DEC-035 fixed-seed procedural Daily/Weekly contract remains protected;
- SX-DEC-036 cosmetic-only/no-power fairness remains protected;
- no SX-DEC-056~058 code/content implementation before delta DoR;
- no R09/R10 implementation while on post-validation hold;
- no Base repin;
- no `.asset-vault` cleanup;
- automated/export evidence does not imply physical/device/human PASS;
- production cutover remains separately blocked.

## Validation ceiling

```text
FINITE CORE AUTOMATED: PASS
SX-DEC-055 RUNTIME POC: NOT_STARTED
SX-DEC-056~058 IMPLEMENTATION: NOT_STARTED · DELTA_DOR_REQUIRED
POST-POC ACCEPTANCE BUILD: UNASSIGNED
WINDOWS PHYSICAL RUNTIME: NOT_RUN
ANDROID DEVICE SMOKE: NOT_RUN
CONNECTED PHYSICAL EDITOR: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
PRODUCTION CUTOVER: BLOCKED_DEFERRED
```
