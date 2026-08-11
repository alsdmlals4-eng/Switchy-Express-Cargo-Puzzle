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
| SX-DEC-056A | `DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED` |
| SX-DEC-056B | `BLOCKED_BY_AUTHORITATIVE_SCORE_COMBO_RUNTIME` |
| SX-DEC-057 | `DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED` |
| SX-DEC-057 fast/cheap content | `BLOCKED_BY_STAGE8_TRACK_ATTRIBUTE_RUNTIME` |
| SX-DEC-058 | `DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED` |
| BMK-R01~R08 | `APPROVED · DETAILED_PLANNING_CLOSED` |
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
12. `기획서/50_제작_검증/SX_AUD_051_SX_DEC_056_DELTA_DOR_FINAL_REVIEW.md`
13. `기획서/50_제작_검증/SX_AUD_052_SX_DEC_057_DELTA_DOR_FINAL_REVIEW.md`
14. `기획서/50_제작_검증/SX_AUD_053_SX_DEC_058_DELTA_DOR_FINAL_REVIEW.md`
15. 056/057/058 exact Decision + spec + implementation/content plan owners
16. `docs/decisions/SX_DEC_055_RUNTIME_SEMANTIC_POC.md`
17. `docs/superpowers/specs/2026-08-10-runtime-semantic-poc-design.md`
18. `docs/superpowers/plans/2026-08-10-sx-dec-055-runtime-semantic-poc.md`
19. `docs/superpowers/plans/2026-08-11-sx-dec-055-phase-b-readiness-amendment.md`
20. only after BUILD authority is current, re-read exact implementation files before RED

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

Parallel product-depth planning created after Phase B:

```text
BMK-R01/R02/R03/R07 → SX-DEC-056 → SX-AUD-051 · detailed planning closed
BMK-R04/R05/R06     → SX-DEC-057 → SX-AUD-052 · detailed planning closed
BMK-R08             → SX-DEC-058 → SX-AUD-053 · detailed planning closed
BMK-R09/R10         → POST_VALIDATION_HOLD
```

The detailed planning closure does **not** inherit the already-reviewed SX-DEC-055 Build Authority. 056/057/058 each still require an explicit implementation/content-production authority before code/map/pipeline work.

Dependency-gated portions are also explicit rather than guessed:

- 056B Highest Score / score+max-combo extension waits for authoritative finite score/combo runtime metrics;
- 057 Fast/Cheap Builder/Mastery content waits for authoritative Stage-8 track-attribute runtime representation.

## Post-Phase-B planning package summary

### SX-DEC-056

- request-only current-route Probe;
- exact first-entered-cell, LOOP, DEAD_END, ROUTE_INVALID semantics;
- actual-event-only Encounter Trace/Debrief;
- independent finite Fastest/Cheapest PB;
- score-independent Fingerprint v1;
- no solver/recommended/3-star solution leakage.

### SX-DEC-057

- 12 initial Lab blueprints: SL-01~04, SW-01~04, BL-01~04;
- unlock lanes after Tutorial 5/6/8 without changing Tutorial order;
- lane completion mark only;
- max one optional Mastery per chapter;
- 2 Core clears independently unlock next chapter + current Mastery;
- T/S/E 0..3 authoring rubric;
- request-only bounded hints;
- FS-16/17 human transfer/optionality contract.

### SX-DEC-058

- canonical UTC Daily / ISO-week Weekly identity;
- SHA256_COUNTER_V1 deterministic generation stream;
- CONSTRUCTIVE_WITNESS_REPLAY_V1 legal-success proof;
- deterministic operation budgets;
- nontrivial route/LIFO quality profiles;
- 1000 Daily + 1000 Weekly calibration corpus per release version;
- immutable published identity/archive parity;
- private witness/generator artifacts excluded from runtime packages;
- backend/transport kept separate.

## Phase B export-readiness finding

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
- no SX-DEC-056~058 code/content/pipeline implementation without explicit authority;
- no guessed score/combo formula for 056B;
- no invented fast/cheap TrackPiece field under 057;
- no challenge optimum/player-hint solver under 058;
- no R09/R10 implementation while on post-validation hold;
- no Base repin;
- no `.asset-vault` cleanup;
- automated/export evidence does not imply physical/device/human PASS;
- production cutover remains separately blocked.

## Validation ceiling

```text
FINITE CORE AUTOMATED: PASS
SX-DEC-055 RUNTIME POC: NOT_STARTED · IMPLEMENTATION_AUTHORIZED
SX-DEC-056A: DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
SX-DEC-056B: BLOCKED_DEPENDENCY
SX-DEC-057: DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
SX-DEC-057 FAST/CHEAP CONTENT: BLOCKED_DEPENDENCY
SX-DEC-058: DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
POST-POC ACCEPTANCE BUILD: UNASSIGNED
WINDOWS PHYSICAL RUNTIME: NOT_RUN
ANDROID DEVICE SMOKE: NOT_RUN
CONNECTED PHYSICAL EDITOR: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
PRODUCTION CUTOVER: BLOCKED_DEFERRED
```