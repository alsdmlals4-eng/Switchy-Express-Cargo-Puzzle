# Switchy Express 프로젝트 허브

Last updated: `2026-08-26 KST`

이 문서는 현재 제품 기준선과 **다음 실행 지점**을 빠르게 찾는 허브다. 실행 전에는 항상 fresh Base completed `main`, current Skill Registry/generated map, fresh project `main`, Open/Draft PR, exact Project Notion Home을 다시 읽는다.

## Current State

| 항목 | 현재 값 |
|---|---|
| 제품 기준선 | `GMB-002 · FINITE_DELIVERY_PUZZLE_BASELINE · AMENDED_BY_SX_DEC_060` |
| 결정 범위 | `SX-DEC-027~060` |
| 작업지시문 | `v4.8 · revision 2026-08-26-r5.4-superset-final · Switchy thin adapter` |
| 작업지시문 역할 | `USER_PROVIDED_V4_8_R5_4_SUPERSET_FINAL_CONTRACT` |
| current project adapter | `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md` |
| historical v4.8 r4 predecessor | `2026-08-24-r4 · PROVENANCE_ONLY` |
| SX-DEC-059 implementation | `MERGED_MAIN_VERIFIED · PRE_SX_DEC_060_RUNTIME` |
| SX-DEC-060 | `MERGED_MAIN_VERIFIED · PR #188 · main_740b4b9312fa27289fd62baab8dda54c68ead3a7` |
| station service | `UP/RIGHT/DOWN/LEFT exactly 1 tile · diagonal excluded` |
| network preflight | `START_REACHABLE_RUN_COMPONENT · irrelevant disconnected rail island allowed` |
| map schema target | `FiniteMapDefinition v3` |
| station representation | `OFF_TRACK_SERVICE_OBJECT · station cell player rail forbidden` |
| image requirement | `0 new bitmap · reuse existing station PNG consumers + procedural service overlay` |
| pre-060 Candidate 003 | `SX59-POC-ACCEPT-003 · HISTORICAL_EXACT_BYTES_ONLY after SX-DEC-060` |
| post-060 candidate route | `evidence/acceptance/post_sx_dec_060_candidate.json · SX60-POC-ACCEPT-002 · PREPARED_PACKAGE_VERIFIED · source main 0e882764b837d13282a7642b115948d4e061d163` |
| SX60 Candidate 001 | `HISTORICAL_SUPERSEDED_BY_PRODUCT_BYTE_CHANGE · PLAYER_FACING_RUNTIME_ROUTE_READABILITY_CHANGE · hashes/PCK preserved` |
| post-060 automated regression | `PASS · 111 cases / 13,461 assertions · CI 7 GREEN · SX-AUD-071 CLOSED` |
| post-060 Windows physical | `HISTORICAL_AUTOMATION_OBSERVED_INITIAL_TITLE_AND_BUILD_ENTRY · CURRENT_EXACT_CANDIDATE_002_PACKAGE_VERIFIED_HUMAN_PHYSICAL_NOT_RUN · full human/runtime gate NOT_RUN` |
| post-060 Android device | `NOT_RUN` |
| post-060 five-person | `NOT_RUN` |
| Player experience | `NOT_RUN` |
| Production cutover | `BLOCKED_DEFERRED` |
| SX-DEC-056A | `PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED` |
| SX-DEC-056B | `BLOCKED_BY_AUTHORITATIVE_SCORE_COMBO_RUNTIME` |
| SX-DEC-057 | `PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED` |
| SX-DEC-058 | `PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED` |
| semantic product PNG | `73 · PRODUCTION_COMPLETE · existing runtime consumers` |
| PR #174 | `PRE_EXISTING_DRAFT · READ_ONLY` |

## Fresh-read bootstrap

```text
past conversation not required
→ exact Project GitHub + exact Notion Home
→ reconstruct identity / current goal / quality-stage / protected scope / next safe action / evidence ceiling
→ GitHub↔Notion mismatch => CONTEXT_DRIFT_RECHECK_REQUIRED before mutation
```

## Base authority

```yaml
base_runtime_authority: ALWAYS_REFETCH_CURRENT_COMPLETED_MAIN
base_compatibility_pin: HISTORICAL_COMPATIBILITY_ONLY
skill_coverage: CURRENT_REGISTRY_FULL_INVENTORY_TRIGGERED_PROGRESSIVE_LOAD_WITH_EXECUTION_RECEIPT
```

과거 Base SHA는 compatibility/audit evidence다. 현재 Base SHA를 프로젝트 정본에 고정하지 않는다.

## One-line product promise

> 필요한 선로망으로 화물 조우 순서를 만들고, 적재 선택으로 LIFO를 설계한 뒤, 운행 중 분기 판단과 역 인접 배송으로 계획을 실행하고 결과를 보고 다시 설계하는 finite cargo puzzle.

## SX-DEC-060 rule

Canonical owner: `docs/decisions/SX_DEC_060_CARDINAL_STATION_SERVICE_AND_REACHABLE_NETWORK.md`

```text
station service = abs(dx) + abs(dy) == 1
→ UP / RIGHT / DOWN / LEFT only
→ diagonal no
→ station footprint itself no

cargo pickup = existing exact-cell Manual / Auto contact
LIFO/TOP unload = unchanged

preflight = start-reachable RUN component
→ every required cargo reachable
→ every required station has >= 1 reachable cardinal service cell
→ irrelevant disconnected rail island does not block RUN
```

## Current first-session flow

```text
T1 · Track Connection
→ T2 · Cargo direct-contact + Station cardinal-adjacent delivery
→ T3 · LIFO/TOP reverse planning
→ T4 · selective non-load + revisit
→ T5 · Auto ON safe / OFF decision
→ T6 · switch execution
→ VS_DEMO_01 capstone
→ Result / Retry / Edit
```

No new tutorial stage is added. Locales remain `ko / en / ja / zh-Hans`; `zh-Hant` is deferred.

## Consumer-first image rule

Production image work must start from a real game consumer.

Current `ProductBoardRenderer` already consumes approved station textures. Therefore SX-DEC-060 does **not** create an explanation sheet or new station bitmap. The service range is first represented as procedural, low-priority board feedback.

```text
actual node/key/path consumer
→ existing asset reuse check
→ procedural solution check
→ only then, if a concrete slot is still missing, automatically generate the required bitmap
→ preserve it in the tracked project-local asset path and Notion Visual/Asset destination
→ retain the existing E+D Hybrid / Neo-Arcade visual language
```

```yaml
automatic_consumer_image_policy: USER_APPROVED_2026_08_26
approved_image_dual_storage: PROJECT_LOCAL_AND_NOTION
```

## Candidate evidence boundary

`SX59-POC-ACCEPT-003` remains exact historical evidence for pre-SX-DEC-060 bytes. Its package/PCK/product-texture/live-download facts stay preserved, but it is no longer the efficient next acceptance target because gameplay semantics have changed.

Do not run its old physical Gate 0 as if it validated the new rule. Post-060 requires a new exact candidate after implementation/regression/package proof.

## Current implementation package

```text
docs/decisions/SX_DEC_060_CARDINAL_STATION_SERVICE_AND_REACHABLE_NETWORK.md
docs/superpowers/specs/2026-08-26-cardinal-station-service-and-reachable-network-design.md
docs/superpowers/plans/2026-08-26-cardinal-station-service-and-reachable-network.md
기획서/50_제작_검증/SX_DEC_060_CODEX_HANDOFF_PACKAGE.md
```

Actual GDScript/Scene/Resource/map/runtime implementation is owned by `CODEX_GODOT_PRODUCT_IMPLEMENTATION_HANDOFF` under the active r5.4 contract.

## Mandatory read order

1. fresh Base completed `main` + Base `AGENTS.md`.
2. Base `skills/SKILL_REGISTRY.json` + `docs/generated/BASE_ACTIVE_SKILLS.md`.
3. fresh Project `main`, latest commit, all Open/Draft PRs.
4. exact Switchy Notion Project Home.
5. Project `AGENTS.md` + `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md`.
6. `FINITE_DELIVERY_PUZZLE_BASELINE.md`.
7. `CURRENT_CONFIRMED_DECISIONS.md`.
8. `ACTIVE_CONTEXT.md`.
9. SX-DEC-060 decision/spec/plan/Codex handoff.
10. `ROADMAP.md` + `DEVELOPMENT_GATES.md`.
11. actual code/data/Scene/Resource/assets/tests.

Historical v4.7/r2/r4 adapter/reconciliation materials (including v4.8 `2026-08-24-r4`) and pre-060 Candidate records are rollback/provenance evidence. Google Sheets is migration-only.

## Current next action

```text
SX60-POC-ACCEPT-002 human physical self-run
→ Windows physical smoke
→ Android device smoke
→ Five-person first-contact comprehension
→ product decision
```

Current evidence ceiling is `RUNTIME_MERGED_MAIN_VERIFIED / AUTOMATED_PASS / FIVE_PASS_REVIEW_CLOSED`. Package, physical, device, human, and player-experience PASS for SX-DEC-060 are not yet available.
