# Switchy Express 공용 AI 작업 규칙

> **2026-08-28 사용자 권위 변경 - GitHub-only project workspace:** Notion은 active read/write, 결정 입력, asset storage, destination readback, 완료 조건에서 제외한다. 기존 Notion page/attachment/readback은 삭제하지 않는 역사·감사 evidence다. 현재 정본, Decision, asset provenance, human-facing GDD와 검수 기록은 GitHub repository가 단일 owner다. 아래의 Notion 의무 문구가 이 선언과 충돌하면 이 선언이 우선한다.

이 저장소는 `alsdmlals4-eng/Base` v9.4.3 project compatibility pin을 역사적으로 보존하면서, **사용자가 2026-08-26 제공한 v4.8 r5.4 Superset Final 작업 계약**과 최신 Base completed `main`을 현재 실행 방법론으로 사용하는 Godot 프로젝트다.

## 1. 권위 순서

1. 사용자의 최신 지시와 승인
2. 현재 환경 system/developer/security 제약
3. 이 `AGENTS.md`
4. `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md`
5. `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
6. `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
7. 등록된 분야 책임 원본
8. 실제 code/data/Scene/Resource/assets/tests/runtime evidence
9. 프로젝트가 채택한 compatibility lock/adapter
10. Base remote latest completed `main`
11. 외부 사례·과거 대화·추정

프로젝트 문서와 실제 runtime/code가 충돌하면 숨기지 않는다. 실행하지 않은 test/build/render/physical/human 검증은 PASS라고 쓰지 않는다.

### 작업 목표

모든 프로젝트 작업은 **가장 효율적이고 장기적으로 유지되는 출시 수준에 가까운 버티컬 슬라이스**를 목표로 한다. 빠른 답이나 국소 패치보다 현재 코드·모든 PR·GitHub 정본을 먼저 읽고, 공식 자료·동종 제품 벤치마킹·현업 구현 사례를 비교한 뒤 최적의 구조를 선택한다. 시간과 토큰보다 결과 품질, 증거, 회귀 방지, 장기 유지비를 우선한다.

구현·병합 작업은 다음을 기본 완료 조건으로 삼는다.

```text
fresh authority recovery
→ benchmark / industry comparison
→ RED-first implementation
→ exact automated/package evidence
→ minimum five-pass adversarial review
→ corrections and full regression
→ GitHub merge
→ GitHub post-merge readback
```

## 2. 매 작업 시작 fresh-read

```text
Base latest completed main
→ Base root AGENTS.md
→ Base current Skill Registry + generated active map
→ Project main/latest commit
→ all Open/Draft PR
→ this AGENTS.md
→ v4.8 Switchy adapter
→ CURRENT_CONFIRMED_DECISIONS
→ ACTIVE_CONTEXT
→ exact owner docs
→ actual code/data/Scene/Resource/assets/tests
```

새 채팅은 과거 대화를 필수 입력으로 사용하지 않는다. Project GitHub에서 current identity / goal / quality-stage / protected scope / next safe action / evidence ceiling을 재구성한다. historical Notion은 explicit audit/migration request가 없는 한 읽거나 쓰지 않는다.

`GOOGLE_SHEETS: RETIRED_NO_ACTIVE_USE`

사용자 2026-08-25 지시에 따라 기존 Google Sheet는 **일반 작업에서 읽기·쓰기·동기화·결정 입력 대상으로 사용하지 않는다.** 과거 Sheet ID·URL·sync 기록은 역사/감사 provenance가 필요한 경우에만 legacy migration evidence에서 확인하며, active workspace나 기본 탐색면으로 되살리지 않는다. Figma, external HTML, Tool Hub, QA Evidence Studio도 기본/필수 프로젝트 경로가 아니다.

## 3. 현재 작업지시문 / 엔진

```yaml
work_instruction_canon: PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md
contract_version: 4.8
revision: 2026-08-26-r5.4-superset-final
source_role: USER_PROVIDED_V4_8_R5_4_SUPERSET_FINAL_CONTRACT
source_r5_4_sha256: fdf238c202cfac6d3a824aae49b8ac525fba023e31bba7df6ece64a2790365a0
adapter_policy: THIN_ADAPTER_DO_NOT_DUPLICATE_BASE_CANON
engine: Godot 4.7.1-stable
language: GDScript
project_base_pin: v9.4.3 · HISTORICAL_COMPATIBILITY
base_remote_policy: ALWAYS_REFETCH_CURRENT_COMPLETED_MAIN
fresh_read_bootstrap_policy: PROJECT_GITHUB_ONLY_RECONSTRUCTION_REQUIRED
skill_coverage_policy: CURRENT_REGISTRY_FULL_INVENTORY_TRIGGERED_PROGRESSIVE_LOAD_WITH_EXECUTION_RECEIPT
gpt_local_codex_orchestration_policy: RETIRED
current_validation_locator: 기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md
current_product_decision: SX-DEC-063 · HYBRID_MINIATURE_DIORAMA_VISUAL_PRODUCTION_ALIGNMENT
pre_sx_dec_060_candidate: SX59-POC-ACCEPT-003 · HISTORICAL_EXACT_BYTES_ONLY
post_sx_dec_060_candidate: NOT_CREATED
```

v4.7 Switchy adapter, v4.5 r2 bundle, v4.8 r2 provenance와 2026-08-24 r4 전환 자료는 역사·rollback/provenance evidence로 보존하며 current work-instruction authority가 아니다. r5.4의 fresh-read/Skill coverage/복구/Godot 상세는 thin adapter와 최신 Base owner를 progressive-load한다.

## 4. 현재 제품 기준선 — GMB-002 · SX-DEC-060 amendment

Stable finite identity:

- handcrafted finite delivery puzzle
- free rail build + cost / full refund
- automatic train movement
- manual load default + auto-load toggle
- unlimited LIFO stack
- contiguous matching TOP group unload
- direct route-control/switch interaction with occupied lock
- time failure / all-delivered success / `ROUTE_END`
- same-layout fresh-runtime Retry + Edit layout
- color + shape + text redundant information
- cosmetic-only progression boundary

Current SX-DEC-060 amendment:

```text
station service = abs(train_x - station_x) + abs(train_y - station_y) == 1
→ UP / RIGHT / DOWN / LEFT exactly one tile
→ diagonal excluded
→ station footprint itself excluded

cargo pickup = existing exact-cell Manual / Auto contact

preflight = start-reachable RUN component
→ every required cargo reachable
→ every required station has >=1 reachable cardinal service cell
→ irrelevant disconnected rail island does not block RUN
```

Technical implementation default:

```yaml
FiniteMapDefinition_target: schema_v3
station_role: OFF_TRACK_SERVICE_OBJECT
station_cell_player_track: FORBIDDEN
station_service_overlap: FAIL_CLOSED
renderer: EXISTING_STATION_PNG + PROCEDURAL_SERVICE_INDICATOR
new_bitmap_assets: 0
```

다음 historical family는 current product로 되살리지 않는다.

```text
endless survival
fuel drain/recovery/fuel-zero
player BOOST
cargo capacity 8
cargo-count slowdown
pickup respawn
switch auto-reset
```

추가 코어 의미 변경은 `USER_DECISION_REQUIRED`다.

## 5. 현재 Decision / 기획 상태

```yaml
current_decision_span: SX-DEC-027~063
sx_dec_055_runtime_semantic: MERGED_MAIN_VERIFIED · PR_151
sx_dec_056a: DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
sx_dec_056b: BLOCKED_BY_AUTHORITATIVE_SCORE_COMBO_RUNTIME
sx_dec_057: DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
sx_dec_057_fast_cheap: BLOCKED_BY_STAGE8_TRACK_ATTRIBUTE_RUNTIME
sx_dec_058: DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
sx_dec_059: MERGED_MAIN_VERIFIED · PRE_SX_DEC_060_RUNTIME
sx_dec_059_build: PR_158 · main_162e8a0a5e8ddc8472e74a6152e87dc12008e34c
sx_dec_059_review: FIVE_PASS_AND_INDEPENDENT_REVIEW_CLOSED · SX-AUD-066
sx_dec_060: MERGED_MAIN_VERIFIED · PR_188 · main_740b4b9312fa27289fd62baab8dda54c68ead3a7
sx_dec_060_runtime: MERGED_MAIN_VERIFIED · schema_v3/cardinal_service/reachable_preflight
sx_dec_060_automated_regression: PASS · 111_CASES_13461_ASSERTIONS
sx_dec_060_ci: PASS · 7_REQUIRED_CHECKS
sx_dec_060_review: FIVE_PASS_AND_INDEPENDENT_REVIEW_CLOSED · SX-AUD-071
sx_dec_060_notion_readback: PASS
sx_dec_060_post_change_candidate: NOT_CREATED
sx_dec_061: APPROVED · BOARD_FIRST_COZY_NEO_ARCADE · DOCUMENTATION_ONLY · RUNTIME_UNCHANGED
sx_dec_062: MERGED_MAIN_VERIFIED · PR_237 · main_8bce715b5045afebfb04d38108d2e3f7353e1b10 · EXISTING_ASSET_BOARD_FIRST_COMPOSITION
sx_dec_063: USER_APPROVED_DIRECTION · FIRST_CANDIDATE_GENERATED_REVIEW_PENDING · RUNTIME_UNCHANGED
```

Current first-session shape remains:

```text
T1 Track Connection
→ T2 Cargo direct-contact + Station cardinal-adjacent delivery
→ T3 LIFO/TOP reverse planning
→ T4 selective non-load + revisit
→ T5 Auto ON safe / OFF decision
→ T6 switch execution
→ VS_DEMO_01 Capstone
→ Result / Retry / Edit
```

No new tutorial stage is authorized by SX-DEC-060.

## 6. SX-DEC-060 implementation boundary

### Reuse/adapt current owners

- `FiniteMapDefinition` / `FiniteMapLoader`
- `FiniteTrackGraphBuilder`
- `Station`
- `FiniteDeliveryLoop`
- `PreflightValidator`
- `FiniteRunSessionFactory`
- current `ProductFiniteSlice`
- existing HUD/Board/RouteControl/SemanticEvent/DemoEffects/Audio
- existing 73 semantic product PNGs
- `FirstSessionDefinition/Director/StagePolicy/Copy`
- existing T1→T6→capstone structure

### Current implementation package

```text
docs/decisions/SX_DEC_060_CARDINAL_STATION_SERVICE_AND_REACHABLE_NETWORK.md
docs/superpowers/specs/2026-08-26-cardinal-station-service-and-reachable-network-design.md
docs/superpowers/plans/2026-08-26-cardinal-station-service-and-reachable-network.md
기획서/50_제작_검증/SX_DEC_060_CODEX_HANDOFF_PACKAGE.md
```

Actual GDScript/Scene/Resource/map/runtime implementation must use `CODEX_GODOT_PRODUCT_IMPLEMENTATION_HANDOFF` after merged GitHub canon readback.

### Prohibited expansion

- SX-DEC-056A Route Probe/PB/Fingerprint/observation implementation
- SX-DEC-056B score/max-combo
- SX-DEC-057 Yard Lab/Mastery
- SX-DEC-058 Daily/Weekly generator/pipeline
- arbitrary station radius, diagonal service, per-station service shape
- multi-station priority invention
- new solver/optimal route reveal
- Base repin
- new generated image without a concrete game consumer

## 7. Consumer-first image rule

Production image work is allowed only when a real game consumer exists.

```yaml
automatic_consumer_image_policy: USER_APPROVED_2026_08_26
approved_image_storage: PROJECT_LOCAL_GITHUB_TRACKED
visual_continuity: existing E+D Hybrid / Neo-Arcade visual language
```

When a verified runtime node/key/path has a genuinely missing bitmap slot, generate only the required image without a per-image approval request. Preserve a user-approved final image in a tracked project-local asset path, record provenance and SHA-256 in GitHub, and use the existing E+D Hybrid / Neo-Arcade visual language. A concrete consumer remains mandatory. A generated candidate remains `NOT_RUNTIME_PROOF` until the user decides to promote it.

Current `ProductBoardRenderer` already consumes station texture paths for red/blue/yellow stations, so SX-DEC-060 must:

```text
reuse existing station PNGs
→ use procedural cardinal service indication first
→ add zero new bitmap assets in the approved implementation
```

Explanation sheets, full-screen concept mockups, or images with no runtime node/key/path consumer are not production assets.

## 8. 별도 PR 보호

PR #154 is `CLOSED_UNMERGED · SUPERSEDED_BY_SX_DEC_059`. PR #155/#156 are `CLOSED_UNMERGED · HISTORICAL_ACCIDENT`.

Draft PR #174 is a pre-existing r4 workstream and remains:

```text
PRE_EXISTING_DRAFT · READ_ONLY
```

Do not modify, rebase, merge, close, or absorb it without separate explicit authorization.

## 9. Tooling authority

```yaml
godot: 4.7.1-stable
gut: 9.7.1
project_godot_ai_plugin_cfg: 3.2.0
project_3_2_0_project_tree: 66a9df59a92f0029efcd35c22fea355c93e8fe49
project_3_2_0_external_upstream_parity: UNVERIFIED
```

`docs/tooling/local_godot_tooling_state.json` is evidence owner. Fresh local authoring must re-check repo/project identity, dirty/diverged state, exact tool pins, and runtime session before mutation.

Persistent Godot authoring follows the current adopted authoring authority. GUT is deterministic test authority; live QA/observability does not own acceptance source delta.

`GPT_LOCAL_CODEX_ORCHESTRATION_RETIRED`: GPT does not launch local Codex through PowerShell. New Godot product implementation switches to the Codex handoff route; Codex independently fresh-reads Project GitHub.

## 10. Platform / Release / Asset Rights routing

For platform/rating/store/ads/IAP/rights/provenance/reference-independence work, read the current registered owners:

- `docs/PLATFORM_RELEASE_AND_ASSET_RIGHTS_PROFILE.md`
- `docs/ASSET_RIGHTS_AND_PROVENANCE_RECORD.md`
- `docs/GAME_RELEASE_COMPLIANCE_EVIDENCE_PACK.md`
- `기획서/50_제작_검증/PLATFORM_RELEASE_AND_ASSET_RIGHTS_PLAN.md`

No SX-DEC-060 design/implementation/package result implies store/legal/release PASS.

## 11. Evidence ceiling

```text
FINITE CORE PRE-SX-DEC-060 AUTOMATED: PASS · HISTORICAL_EXACT_SEMANTICS
SX-DEC-055 RUNTIME SEMANTIC: MERGED_MAIN_VERIFIED
SX-DEC-059 IMPLEMENTATION: MERGED_MAIN_VERIFIED · PRE_SX_DEC_060
CANDIDATE 003 PACKAGE/PCK/TEXTURE POINTER: PASS · HISTORICAL_PRE_SX_DEC_060
CANDIDATE 003 PHYSICAL VISUAL RECHECK: NOT_RUN
SX-DEC-060 USER RULE: APPROVED
SX-DEC-060 DESIGN/TDD/HANDOFF: PREPARED
SX-DEC-060 RUNTIME: MERGED_MAIN_VERIFIED · PR #188 · main_740b4b9312fa27289fd62baab8dda54c68ead3a7
SX-DEC-060 AUTOMATED REGRESSION: PASS · 111_CASES_13461_ASSERTIONS · CI_7_GREEN
SX-DEC-060 FIVE-PASS REVIEW: CLOSED · SX-AUD-071
SX-DEC-060 NOTION READBACK: PASS
POST-060 CANDIDATE: NOT_CREATED
WINDOWS PHYSICAL POST-060: NOT_RUN
AUDIO PERCEPTUAL POST-060: NOT_RUN
ANDROID DEVICE POST-060: NOT_RUN
FIVE-PERSON POST-060: NOT_RUN
PLAYER EXPERIENCE POST-060: NOT_RUN
PRODUCTION CUTOVER: BLOCKED_DEFERRED
```

Automated/export/package/self-run does not imply HUMAN/PLAYER EXPERIENCE PASS. Pre-change Candidate 003 evidence does not transfer to post-060 bytes.

## 12. Current Codex / Build Gate

Current next gate:

```text
SX-DEC-063 first terrain candidate final disposition
→ selected candidate family and Phase 2 Godot implementation contract
→ new exact post-062 package candidate
→ physical/device/human gates
```

Physical Windows/Android and human comprehension remain separate gates.

## 13. GitHub-only project workspace

- GitHub: structured canon / code / data / Scene / Resource / assets / tests / runtime evidence / human-facing GDD.
- Notion: `RETIRED_NO_ACTIVE_USE`; historical page/attachment/readback only, no new read/write/sync/destination requirement.
- Google Sheets: `RETIRED_NO_ACTIVE_USE` except legacy provenance/migration evidence.
- Every approved Decision is recorded in required GitHub owners.
- If historical Notion conflicts with GitHub runtime truth, preserve it as history and correct GitHub canon; do not reactivate a Notion sync path.

## 14. 현재 핵심 정본

- `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md`
- `기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md`
- `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
- `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
- `기획서/00_프로젝트_허브/ROADMAP.md`
- `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md`
- `docs/decisions/SX_DEC_060_CARDINAL_STATION_SERVICE_AND_REACHABLE_NETWORK.md`
- `docs/superpowers/specs/2026-08-26-cardinal-station-service-and-reachable-network-design.md`
- `docs/superpowers/plans/2026-08-26-cardinal-station-service-and-reachable-network.md`
- `기획서/50_제작_검증/SX_DEC_060_CODEX_HANDOFF_PACKAGE.md`
- `docs/decisions/SX_DEC_062_BOARD_FIRST_RUNTIME_COMPOSITION.md`
- `docs/superpowers/specs/2026-08-28-board-first-runtime-composition-design.md`
- `docs/superpowers/plans/2026-08-28-board-first-runtime-composition.md`
- `기획서/50_제작_검증/SX_DEC_062_CODEX_GODOT_PRODUCT_IMPLEMENTATION_HANDOFF.md`
- `docs/decisions/SX_DEC_063_HYBRID_MINIATURE_DIORAMA_VISUAL_PRODUCTION_ALIGNMENT.md`
- `docs/design/PROJECT_AI_PRODUCTION_SPEC.md`
- current first-session content/UI/localization owners
- current platform/release/asset-rights owners

Historical v4.7/r2/r4 reconciliation docs, SX-DEC-059 implementation plans/audits, and Candidate 003 records remain history/rollback/provenance evidence. Current execution locator is `ACTIVE_CONTEXT.md`.
