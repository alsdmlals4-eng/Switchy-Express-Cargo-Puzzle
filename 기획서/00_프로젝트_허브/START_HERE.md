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
| SX-DEC-055 | `IMPLEMENTED · PR #151 MERGED · runtime_integrated=true` |
| SX-DEC-055 merged main | `534a7318b349cd3e784a3467125f9ebd23124d8a` |
| SX-DEC-056A | `DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED` |
| SX-DEC-056B | `BLOCKED_BY_AUTHORITATIVE_SCORE_COMBO_RUNTIME` |
| SX-DEC-057 | `DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED` |
| SX-DEC-057 fast/cheap content | `BLOCKED_BY_STAGE8_TRACK_ATTRIBUTE_RUNTIME` |
| SX-DEC-058 | `DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED` |
| BMK-R01~R08 | `APPROVED · DETAILED_PLANNING_CLOSED` |
| BMK-R09/R10 | `POST_VALIDATION_HOLD · NO_DECISION_ID` |
| semantic product PNG | `73 · PRODUCTION_COMPLETE` |
| Base pin | `v9.4.3` |
| Base main | fresh-read every session · `REFERENCE_ONLY` |
| acceptance build | `UNASSIGNED` |
| Windows physical runtime | `NOT_RUN` |
| Android device smoke | `NOT_RUN` |
| connected physical editor | `NOT_RUN` |
| Five-person comprehension | `NOT_RUN` |
| Production cutover | `BLOCKED_DEFERRED` |
| configured Sheet | `1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo` |

저장된 SHA·PR은 snapshot이다. 새 작업은 Base current main, project default branch/all Open-Draft PR/latest commit, configured Sheet를 다시 읽는다.

## One-line product promise

> 선로를 건설해 화물 조우 순서를 설계하고, 수동·자동 적재로 LIFO 스택을 구성하며, 운행 중 분기 경로를 조절해 제한 시간 안에 모든 필수 배송을 완료하는 퍼즐.

내부 설계 문장:

> 노선을 그리는 순간 화물 스택의 순서가 정해지고, 운행은 그 계획을 실행한다.

## Mandatory read order

1. `AGENTS.md`
2. `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.5_r2.md`
3. fresh Base/project current state + configured Sheet
4. `FINITE_DELIVERY_PUZZLE_BASELINE.md`
5. `CURRENT_CONFIRMED_DECISIONS.md`
6. `ACTIVE_CONTEXT.md`
7. `ROADMAP.md`
8. `기획서/50_제작_검증/SX_AUD_054_SX_DEC_055_RUNTIME_POC_POST_MERGE_RECONCILIATION.md`
9. exact Decision/spec/plan owner for the separately authorized next package.

## SX-DEC-055 merged runtime

PR #151 exact head `63b0ed331e043db7d677ca097bdb209003bda4be` was squash-merged to main `534a7318b349cd3e784a3467125f9ebd23124d8a`.

Player-visible/runtime result:

- semantic Stack/manual-auto/preflight HUD reinforcement;
- BUILD placement/preflight semantic reinforcement;
- route-control selected/unselected/occupied-locked semantic reinforcement;
- pickup/unload/route/result semantic feedback;
- Reduced Motion information equivalence;
- existing Korean text, input/hit geometry, gameplay/domain rules, score, maps, save, product PNGs and semantic manifests preserved.

Automated/package evidence:

```text
Project Contract #1242 PASS
GUT 9.7.1 #291 PASS
Godot Tests #1173 PASS
Thin Adapter #369 PASS
Windows Demo Export #241 PASS
custom suite 97 / 0 failed / 11923 assertions
Windows proof PCK parsed_json=13
Android Validation preset proof PCK parsed_json=13
review threads 0
```

## Current execution chain

```text
SX-DEC-055 PR #151 MERGED
→ same-ID current canon + Sheet reconciliation
→ exact post-POC acceptance build identity when physical validation is prepared
→ Windows physical runtime/visual/audio/input smoke
→ Android device smoke
→ physical Reduced Motion/readability evidence
→ Five-person comprehension on the same acceptance build
→ separate production cutover decision
```

The old `SX-DEC-055 Task 1 / Step 1.1 RED` is completed TDD history, not the next action.

## Parallel approved planning

```text
BMK-R01/R02/R03/R07 → SX-DEC-056 → SX-AUD-051 · detailed planning closed
BMK-R04/R05/R06     → SX-DEC-057 → SX-AUD-052 · detailed planning closed
BMK-R08             → SX-DEC-058 → SX-AUD-053 · detailed planning closed
BMK-R09/R10         → POST_VALIDATION_HOLD
```

These packages do not inherit SX-DEC-055 implementation authority.

- 056A: planning-ready, implementation not authorized.
- 056B: waits for authoritative score/combo runtime truth.
- 057: planning-ready, implementation/content production not authorized; fast/cheap subset waits for Stage-8 track attribute authority.
- 058: planning-ready, implementation/pipeline authority not granted.

## Protected boundaries

- current product baseline = `GMB-002`;
- no endless/fuel/BOOST/capacity-8/cargo-slowdown/pickup-respawn/switch-auto-reset;
- no new gameplay/domain signal solely for VFX;
- route direction/cycle/hit/lock geometry stays procedural authority;
- product PNG/semantic provenance rewrite is out of scope;
- Reduced Motion keeps the same information identity;
- Korean text/procedural presentation remains redundant fallback;
- Tutorial 1~10 order, fixed-seed Daily/Weekly, cosmetic-only/no-power fairness remain protected;
- no 056~058 implementation without separate authority;
- no guessed score/combo formula, invented fast/cheap field, or player-facing challenge solver;
- no R09/R10 implementation while held;
- no Base repin;
- automated/package evidence does not imply physical/device/human PASS;
- production cutover remains separate.

## Validation ceiling

```text
FINITE CORE AUTOMATED: PASS
SX-DEC-055 RUNTIME POC: MERGED_MAIN_VERIFIED
runtime_integrated: true
POST-POC ACCEPTANCE BUILD: UNASSIGNED
WINDOWS PHYSICAL RUNTIME/VISUAL/AUDIO/INPUT: NOT_RUN
ANDROID DEVICE SMOKE: NOT_RUN
CONNECTED PHYSICAL GODOT/HERA: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
PRODUCTION CUTOVER: BLOCKED_DEFERRED
```
