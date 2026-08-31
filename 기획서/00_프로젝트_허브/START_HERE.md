# Switchy Express 프로젝트 허브

Last updated: `2026-08-31 KST`

이 문서는 현재 제품 기준선과 **다음 실행 지점**을 빠르게 찾는 허브다. 실행 전에는 항상 fresh Base completed `main`, current Skill Registry/generated map, fresh project `main`, Open/Draft PR, current GitHub owners와 actual runtime evidence를 다시 읽는다. Notion의 current structure는 GitHub에 이관됐고 historical audit-only다.

## Current State

| 항목 | 현재 값 |
|---|---|
| 제품 기준선 | `GMB-002 · FINITE_DELIVERY_PUZZLE_BASELINE · AMENDED_BY_SX_DEC_060` |
| 결정 범위 | `SX-DEC-027~067` |
| 작업지시문 | `v4.8 · revision 2026-08-26-r5.4-superset-final · Switchy thin adapter` |
| 작업지시문 역할 | `USER_PROVIDED_V4_8_R5_4_SUPERSET_FINAL_CONTRACT` |
| current project adapter | `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md` |
| historical v4.8 r4 predecessor | `2026-08-24-r4 · PROVENANCE_ONLY` |
| SX-DEC-059 implementation | `MERGED_MAIN_VERIFIED · PRE_SX_DEC_060_RUNTIME` |
| SX-DEC-060 | `MERGED_MAIN_VERIFIED · PR #188 · main_740b4b9312fa27289fd62baab8dda54c68ead3a7` |
| SX-DEC-062 | `MERGED_MAIN_VERIFIED · PR #237 · Board-first existing-asset runtime composition · historical pre-v04 Candidate 004 preserved` |
| SX-DEC-063 | `CORE_BOARD_V02_V04_MERGED_MAIN_VERIFIED · PR #255 · v2 terrain/non-rail plus v4 rails connected to ProductBoardRenderer · Candidate 005 exact package preserved` |
| station service | `UP/RIGHT/DOWN/LEFT exactly 1 tile · diagonal excluded` |
| network preflight | `START_REACHABLE_RUN_COMPONENT · irrelevant disconnected rail island allowed` |
| map schema target | `FiniteMapDefinition v3` |
| station representation | `OFF_TRACK_SERVICE_OBJECT · station cell player rail forbidden` |
| image requirement | `SX-DEC-060 station-service overlay: no new bitmap; SX-DEC-063 core board: user-approved v2/v4 fourteen-slot asset map connected` |
| pre-060 Candidate 003 | `SX59-POC-ACCEPT-003 · HISTORICAL_EXACT_BYTES_ONLY after SX-DEC-060` |
| post-060 candidate route | `evidence/acceptance/post_sx_dec_060_candidate.json · SX60-POC-ACCEPT-008 is the exact post-SX-DEC-068 machine package · Candidates 001–007 are historical · FINAL_USER_REVIEW_NOT_RUN · TITLE_WORDMARK_PIXEL_REVIEW_PENDING` |
| SX60 Candidate 001 | `HISTORICAL_SUPERSEDED_BY_PRODUCT_BYTE_CHANGE · PLAYER_FACING_RUNTIME_ROUTE_READABILITY_CHANGE · hashes/PCK preserved` |
| post-060 automated regression | `PASS · 111 cases / 13,461 assertions · CI 7 GREEN · SX-AUD-071 CLOSED` |
| post-060 Windows physical | `FINAL_USER_REVIEW_ONLY · unchanged SX60-POC-ACCEPT-008 required · NOT_RUN` |
| post-060 Android device | `NOT_REQUIRED_FOR_MACHINE_PRIMARY_ACCEPTANCE · NOT_RUN` |
| validation strategy | `SX-DEC-065 · MACHINE_PRIMARY_FINAL_USER_REVIEW` |
| post-060 five-person | `FIVE_PERSON_COMPREHENSION_NOT_REQUIRED` |
| Player experience | `PLAYER_EXPERIENCE_STUDY_NOT_REQUIRED` |
| final user review | `FINAL_USER_REVIEW · NOT_RUN · exact candidate required` |
| Production cutover | `BLOCKED_DEFERRED` |
| SX-DEC-056A | `PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED` |
| SX-DEC-056B | `BLOCKED_BY_AUTHORITATIVE_SCORE_COMBO_RUNTIME` |
| SX-DEC-057 | `PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED` |
| SX-DEC-058 | `PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED` |
| semantic product PNG | `73 semantic product PNGs plus the connected fourteen-slot v2/v4 core-board visual map` |
| PR #174 | `PRE_EXISTING_DRAFT · READ_ONLY` |

## Fresh-read bootstrap

```text
past conversation not required
→ exact Project GitHub + actual runtime evidence
→ reconstruct identity / current goal / quality-stage / protected scope / next safe action / evidence ceiling
→ GitHub owner↔actual runtime mismatch => CONTEXT_DRIFT_RECHECK_REQUIRED before mutation
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
→ preserve it in a tracked project-local GitHub asset path with SHA-256 provenance
→ retain the existing E+D Hybrid / Neo-Arcade visual language
```

```yaml
automatic_consumer_image_policy: USER_APPROVED_2026_08_26
approved_image_preservation: PROJECT_LOCAL_GITHUB_ONLY
```

## Candidate evidence boundary

`SX59-POC-ACCEPT-003` remains exact historical evidence for pre-SX-DEC-060 bytes. Its package/PCK/product-texture/live-download facts stay preserved, but it is no longer the efficient next acceptance target because gameplay semantics have changed.

Do not run its old physical Gate 0 as if it validated the new rule. `SX60-POC-ACCEPT-006` is historical Route Book 01 evidence and `SX60-POC-ACCEPT-007` is historical post-SX-DEC-067 evidence; `SX60-POC-ACCEPT-008` is the exact post-SX-DEC-068 machine-primary package and remains exact-byte-specific.

## Current implementation package

```text
docs/decisions/SX_DEC_060_CARDINAL_STATION_SERVICE_AND_REACHABLE_NETWORK.md
docs/superpowers/specs/2026-08-26-cardinal-station-service-and-reachable-network-design.md
docs/superpowers/plans/2026-08-26-cardinal-station-service-and-reachable-network.md
기획서/50_제작_검증/SX_DEC_060_CODEX_HANDOFF_PACKAGE.md
```

Actual GDScript/Scene/Resource/map/runtime implementation is owned by `CODEX_GODOT_PRODUCT_IMPLEMENTATION_HANDOFF` under the active r5.4 contract.

## SX-DEC-062 implementation contract

```text
docs/decisions/SX_DEC_062_BOARD_FIRST_RUNTIME_COMPOSITION.md
docs/superpowers/specs/2026-08-28-board-first-runtime-composition-design.md
docs/superpowers/plans/2026-08-28-board-first-runtime-composition.md
기획서/50_제작_검증/SX_DEC_062_CODEX_GODOT_PRODUCT_IMPLEMENTATION_HANDOFF.md
```

The user approved a board-first composition adjustment that preserves the existing E+D visual assets and their consumers. It does not authorize a bitmap batch, Issue #227’s separate T2 replacement, gameplay/data/audio change, or human-evidence promotion. Any runtime change requires a new exact package candidate before Phase 5 physical/human evidence is interpreted.

## Mandatory read order

1. fresh Base completed `main` + Base `AGENTS.md`.
2. Base `skills/SKILL_REGISTRY.json` + `docs/generated/BASE_ACTIVE_SKILLS.md`.
3. fresh Project `main`, latest commit, all Open/Draft PRs.
4. Project `AGENTS.md` + `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md`.
5. `FINITE_DELIVERY_PUZZLE_BASELINE.md`.
6. `CURRENT_CONFIRMED_DECISIONS.md`.
7. `ACTIVE_CONTEXT.md`.
8. SX-DEC-060 decision/spec/plan/Codex handoff.
9. `ROADMAP.md` + `DEVELOPMENT_GATES.md`.
10. actual code/data/Scene/Resource/assets/tests.

Historical v4.7/r2/r4 adapter/reconciliation materials (including v4.8 `2026-08-24-r4`) and pre-060 Candidate records are rollback/provenance evidence. Google Sheets is migration-only.

## SX-DEC-063 planning direction

```text
docs/decisions/SX_DEC_063_HYBRID_MINIATURE_DIORAMA_VISUAL_PRODUCTION_ALIGNMENT.md
docs/superpowers/specs/2026-08-28-sx-dec-063-hybrid-miniature-diorama-production-design.md
```

The user selected Hybrid Miniature-Diorama Alignment: the rectangular grid and input mapping stay, while only actual consumers receive versioned candidate art. The approved terrain, nine non-rail v2 assets, and four v04 rail crops are now connected to the existing `ProductBoardRenderer` fourteen-slot map by PR #255. This bounded implementation protects T2 `shell_lesson_hero_v02.png`, Issue #227, gameplay/data/audio, and the exact Candidate 005 package evidence. The separate planning-board binary remains `NOT_RUNTIME_PROOF`.

## Current next action

```text
SX-DEC-063 core-board terrain v02, nine non-rail v02 assets, and four v04 rails are connected to the live fourteen-slot renderer map
→ Issue #246 planning board remains a no-consumer explanatory asset and is not runtime proof
→ SX60-POC-ACCEPT-006 exact package is historical Route Book 01 byte evidence; Candidates 002–005 remain prior-byte evidence only
→ SX-DEC-068 changed player-facing title-shell bytes; Candidate 008 now binds its exact package, while Candidates 006–007 stay historical
→ FINAL_USER_REVIEW only if the user requests final inspection of unchanged Candidate 008 bytes; title wordmark pixel approval remains separate
→ FIVE_PERSON_COMPREHENSION_NOT_REQUIRED / PLAYER_EXPERIENCE_STUDY_NOT_REQUIRED
```

Current evidence ceiling is `RUNTIME_MERGED_MAIN_VERIFIED / AUTOMATED_PASS / PACKAGE_MACHINE_VERIFIED / FINAL_USER_REVIEW_NOT_RUN`. Machine evidence does not provide physical, device, human, player-experience, or release PASS.
