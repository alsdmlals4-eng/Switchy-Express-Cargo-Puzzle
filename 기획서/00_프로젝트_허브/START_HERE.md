# Switchy Express 프로젝트 허브

Last updated: `2026-08-11 KST`

## Current State

| 항목 | 현재 값 |
|---|---|
| 제품 기준선 | `GMB-002 · FINITE_DELIVERY_PUZZLE_BASELINE` |
| 결정 범위 | `SX-DEC-027~055` |
| 작업지시문 | `v4.5 r2 · revision 2026-08-11-r2` |
| Phase A | `COMPLETE` |
| 사용자 planning-complete Gate | `GRANTED · explicit "기획 완료" · 2026-08-11 KST` |
| Phase B | `SX-AUD-047 · PASS` |
| BUILD | `AUTHORIZED AFTER PHASE-B CANON-SYNC MERGE` |
| 다음 구현 | `SX-DEC-055 Runtime Semantic POC · Task 1 / Step 1.1 RED` |
| SX-DEC-055 구현 | `NOT_STARTED` |
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
10. `docs/decisions/SX_DEC_055_RUNTIME_SEMANTIC_POC.md`
11. `docs/superpowers/specs/2026-08-10-runtime-semantic-poc-design.md`
12. `docs/superpowers/plans/2026-08-10-sx-dec-055-runtime-semantic-poc.md`
13. `docs/superpowers/plans/2026-08-11-sx-dec-055-phase-b-readiness-amendment.md`
14. only after BUILD authority is current, re-read exact implementation files before RED

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
- no Base repin;
- no `.asset-vault` cleanup;
- automated/export evidence does not imply physical/device/human PASS;
- production cutover remains separately blocked.

## Validation ceiling

```text
FINITE CORE AUTOMATED: PASS
SX-DEC-055 RUNTIME POC: NOT_STARTED
POST-POC ACCEPTANCE BUILD: UNASSIGNED
WINDOWS PHYSICAL RUNTIME: NOT_RUN
ANDROID DEVICE SMOKE: NOT_RUN
CONNECTED PHYSICAL EDITOR: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
PRODUCTION CUTOVER: BLOCKED_DEFERRED
```
