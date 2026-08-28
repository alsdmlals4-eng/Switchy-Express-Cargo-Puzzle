---
contract_name: PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION
contract_version: '4.8'
status: ACTIVE_PROJECT_THIN_ADAPTER
revision: '2026-08-26-r5.4-superset-final'
current_user_contract_role: USER_PROVIDED_V4_8_R5_4_SUPERSET_FINAL_CONTRACT
source_r5_4_sha256: fdf238c202cfac6d3a824aae49b8ac525fba023e31bba7df6ece64a2790365a0
historical_r4_revision: 2026-08-24-r4
historical_r4_role: USER_PROVIDED_V4_8_R4_CONTRACT
historical_r2_sha256: 6f0541048e084746f6777223521361d0339dbfb2e223c70947f694f1c050f508
base_repository: https://github.com/alsdmlals4-eng/Base
base_snapshot_policy: ALWAYS_REFETCH_CURRENT_COMPLETED_MAIN
adapter_policy: THIN_ADAPTER_DO_NOT_DUPLICATE_BASE_CANON
project_repository: https://github.com/alsdmlals4-eng/Switchy-Express-Cargo-Puzzle
human_workspace: NOTION_DEFAULT_PROJECT_WORKSPACE
runtime_structured_authority: GITHUB_REPOSITORY_AND_ACTUAL_RUNTIME
google_sheets_policy: RETIRED_NO_ACTIVE_USE
fresh_read_bootstrap_policy: PROJECT_GITHUB_NOTION_ONLY_RECONSTRUCTION_REQUIRED
past_conversation_dependency_policy: NOT_REQUIRED_FOR_NEW_CHAT_RESUME
context_drift_policy: RECHECK_BEFORE_MUTATION
skill_coverage_policy: CURRENT_REGISTRY_FULL_INVENTORY_TRIGGERED_PROGRESSIVE_LOAD_WITH_EXECUTION_RECEIPT
gpt_local_codex_orchestration_policy: RETIRED
codex_execution_policy: INDEPENDENT_GODOT_PRODUCT_IMPLEMENTATION_HANDOFF_ONLY
powershell_policy: LOCAL_GODOT_OR_VALIDATION_ONLY_NOT_CODEX_LAUNCHER
fresh_shell_bootstrap_policy: LOCATION_THEN_GIT_FETCH_SAFE_FF_PULL_THEN_UPDATE_THEN_EDITOR
update_freshness_policy: CHECK_OFFICIAL_UPSTREAM_BEFORE_LOCAL_BUILD_AND_RUNTIME
safe_auto_update_policy: REVIEW_CANARY_ROLLBACK_THEN_AUTO_APPLY_AND_EXACT_PIN
shared_godot_runtime_policy: SHARED_APPROVED_EXACT_PIN_DEFAULT_NO_PER_PROJECT_DUPLICATE_BINARY
shared_godot_ai_port_policy: FIXED_DEFAULT_PORTS_WITH_EXACT_SESSION_ROUTING
slice_delivery_policy: PLAYABLE_MEANINGFUL_SLICE_INCREMENTAL_DELIVERY
requirement_traceability_policy: REQUIREMENT_TO_OWNER_IMPLEMENTATION_EVIDENCE_COMPLETION_REQUIRED
---

# Switchy Express · v4.8 r5.4 project thin adapter

이 문서는 사용자가 2026-08-26 제공한 v4.8 revision `r5.4-superset-final` 계약을 Switchy Express에 연결하는 **프로젝트 전용 얇은 adapter**다. Base의 Work Mode·Skill·CI·검증·Godot 운영 playbook을 다시 복사하지 않는다. 매 작업 시작 시 최신 Base completed `main`, current Skill Registry/generated map, 프로젝트 실제 상태, 현재 Notion Home을 다시 읽는다.

`source_r5_4_sha256`은 이번 사용자 제공 계약 파일의 exact identity다. `historical_r4_revision`과 `historical_r2_sha256`은 각각 이전 r4/r2 계약 provenance이며 current authority가 아니다.

## 1. Project Profile

```yaml
project_name: Switchy Express: Cargo Puzzle
project_key: SWITCHY_EXPRESS
project_repository: alsdmlals4-eng/Switchy-Express-Cargo-Puzzle
project_default_branch: main
project_notion_home: Switchy Express · Home
engine: Godot 4.7.1-stable
language: GDScript
project_base_compatibility_pin: v9.4.3
project_base_pin_role: HISTORICAL_COMPATIBILITY_AND_PROJECT_ADOPTION_EVIDENCE
base_current_policy: ALWAYS_REFETCH_CURRENT_COMPLETED_MAIN
product_baseline: GMB-002 · FINITE_DELIVERY_PUZZLE_BASELINE
current_decision_span: SX-DEC-027~060
```

`Base v9.4.3` pin은 과거 project compatibility evidence일 뿐 current Base 실행 방법론 pin이 아니다.

## 2. Authority / domain split

```text
사용자의 최신 명시 지시
→ project AGENTS / Active Context / Current Decisions
→ 실제 code/data/Scene/Resource/assets/tests/runtime
→ 이 project adapter
→ latest Base completed main
→ 외부 근거
```

- **Notion**: 사람용 Project Home, Flow, Visual, 핵심 시스템 설명, 사람이 비교·수정하는 기획 표면.
- **GitHub/runtime**: structured canon, code, data, Scene/Resource, tracked assets, tests, CI, runtime truth.
- **Google Sheets**: `GOOGLE_SHEETS: RETIRED_NO_ACTIVE_USE`. 일반 작업에서 읽기·쓰기·동기화·결정 입력·기본 탐색에 사용하지 않는다. 과거 ID/URL/sync 기록이 필요한 감사·provenance만 legacy migration evidence에서 확인한다.

새 채팅은 과거 대화를 필수 입력으로 사용하지 않고 exact Project GitHub + Notion Home에서 `project identity → current goal → current quality/stage → protected scope → next safe action → evidence ceiling`을 재구성한다. GitHub↔Notion 의미가 충돌하면 `CONTEXT_DRIFT_RECHECK_REQUIRED`로 mutation 전에 되돌린다.

## 3. Protected product baseline

현재 제품은 `GMB-002` finite delivery cargo puzzle이다.

```text
선로 건설로 화물 조우 순서 설계
→ manual/auto 적재 선택
→ unlimited LIFO stack 형성
→ 운행 중 persistent switch/branch 실행
→ TOP 연속 동일 화물 하역
→ 제한 시간/ROUTE_END 결과
→ same-layout fresh-runtime Retry 또는 Edit
```

보호 규칙:

- endless survival / fuel / BOOST / capacity-8 / cargo slowdown / pickup respawn / switch auto-reset을 current 제품으로 되살리지 않는다.
- UI/presentation은 gameplay outcome, score, save, identity authority를 소유하지 않는다.
- 이미지 생성은 verified runtime consumer가 있고 기존 E+D Hybrid / Neo-Arcade visual language를 지킬 때만 자동으로 시작할 수 있으며, 결과는 project-local과 Notion Visual/Asset에 함께 보존·readback한다.
- physical/human/player evidence가 없으면 automated/package evidence를 해당 PASS로 올리지 않는다.
- r5.4 authority adoption은 새로운 gameplay/UX/economy/content authorization이 아니다.

## 2A. Mandatory startup reconciliation and execution loop

모든 meaningful task는 mutation 전에 아래 checklist를 실제 GitHub/runtime/Notion evidence로 채운다. 과거 대화·추정·이미지 reference만으로 항목을 PASS 처리하지 않는다.

```yaml
startup_checklist: CORE_FUN_SYSTEM_SWOT_REMAINING_WORK_ORDER_CHECK
required_readback:
  - player_promise_and_core_fun
  - core_systems_and_protected_product_meaning
  - task_relevant_swot_risks
  - exact_main_candidate_and_open_pr_state
  - ready_deferred_and_high_risk_remaining_work
  - work_order_and_evidence_ceiling
```

핵심 재미·핵심 시스템·SWOT·남은 작업·작업 순서가 GitHub current owner, Notion human-facing owner, 실제 runtime evidence 사이에서 충돌하면 `CONTEXT_DRIFT_RECHECK_REQUIRED`로 기록하고 해당 충돌을 교정한 뒤에만 다음 mutation을 한다.

```yaml
workflow_order: GPT_NON_CODING_PREPARATION → CODEX_SINGLE_IMPLEMENTATION_WINDOW → HUMAN_QA_DEFERRED
machine_runtime_validation: GODOT_HERA_GUT_REQUIRED; HUMAN_QA_DEFERRED
```

- GPT 단계는 current slice의 기획·검수·consumer-backed 이미지·사운드 specification·UI/VFX/data/copy·Notion/GitHub production input을 먼저 완결한다.
- 실제 GDScript/Scene/Resource/map/runtime 구현은 준비된 입력을 하나의 bounded Codex window에서 수행한다. 작은 finding마다 GPT/Codex를 왕복하지 않는다.
- Human QA는 현재 보류한다. 다만 GPT/Codex는 Godot를 실제 실행하고 Hera, GUT, headless/runtime state, representative screenshots를 사용해 화면·상태·consumer를 확인한다. 이 machine observation은 human/player PASS가 아니다.

## 2B. Delegated routine action and delay recovery

```yaml
delegated_routine_approval: APPROVED_BY_DEFAULT_UNLESS_DANGEROUS_CHANGE
bounded_fallback_route: REQUIRED_ON_DELAY_OR_BLOCKER
```

현재 slice 안의 reversible 기술 선택, 국소 bug fix, test/consumer/reference 교정, bounded asset production, GitHub/Notion 정본 동기화, exact-head CI가 GREEN인 current-task PR merge는 반복 승인 없이 진행한다.

다음은 `HIGH_RISK_DEFERRED`로 분리하며 실행하지 않는다: irreversible data loss, security/permission expansion, new paid cost, legal/rights uncertainty, public release/publication, force/direct-main/admin bypass, broad engine/save migration, core identity/narrative/art-direction replacement.

지연·실패는 한 경로를 무한 반복하지 않는다.

```text
state readback
→ root-cause classification
→ bounded safe retry
→ approved fallback A
→ approved fallback B
→ evidence-equivalent local/manual route
→ local defer only for the blocked task
→ continue independent ready work
```

Fallback은 security, rights, exactness, or validation strength를 낮추는 우회가 될 수 없다.

## 2C. Exact candidate freshness and completion boundary

```yaml
candidate_freshness_invalidation: PLAYER_FACING_BYTES_CHANGE → INVALIDATE_EXACT_CANDIDATE
completion_gate: REQUIRED_WORK_REMAINING: 0
```

candidate가 pin한 exact source 이후 player-facing GDScript, Scene, Resource, map, localization, runtime consumer asset/path, renderer/HUD/route/switch presentation, export/package configuration 중 하나라도 바뀌면 그 candidate는 current acceptance evidence가 아니다. 기존 candidate의 hash/package/provenance는 지우지 않고 `HISTORICAL_SUPERSEDED_BY_PLAYER_FACING_BYTE_CHANGE`로 보존한다.

tooling-only, test-only, documentation-only 변경은 candidate를 무효화하지 않는다. candidate pointer, current GitHub owner, Notion Home/Direction/Production/Visual 중 candidate ID/source/status/next action이 하나라도 다르면 새 candidate 생성이나 physical gate 승격 전에 `CONTEXT_DRIFT_RECHECK_REQUIRED` reconciliation을 완료한다.

종료 전 ready/deferred/high-risk queue를 재계산한다. `REQUIRED_WORK_REMAINING: 0`이 되기 전에는 자동화 가능한 current-slice work를 중단하지 않는다. `0`은 machine-executable work의 종료 조건일 뿐 physical/human/player evidence를 PASS로 승격하지 않는다.

## 3A. SX-DEC-060 current amendment

- Station delivery is exactly one cardinal tile from the station: UP, RIGHT, DOWN, or LEFT.
- Diagonal cells and the station footprint itself never trigger delivery.
- Cargo stays an exact-cell Manual / Auto contact; unlimited LIFO and contiguous matching TOP-group delivery stay unchanged.
- Preflight validates the start-reachable RUN component, including required cargo and at least one cardinal service cell per required station.
- An irrelevant disconnected rail island is allowed; reachable malformed rail remains fail-closed.
- The implementation target is FiniteMapDefinition schema v3 with off-track, player-non-buildable station cells.
- Existing station PNG consumers plus a procedural service indicator are the default; new bitmap assets: 0.
- SX-DEC-060 runtime and automated regression are merged-main verified by PR #188 (`740b4b9312fa27289fd62baab8dda54c68ead3a7`); package, physical, device, and human evidence remain NOT_RUN.

## 4. Current implementation / evidence ceiling

현재 post-060 validation locator의 세부 exact state는 `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`와 `evidence/acceptance/post_sx_dec_060_candidate.json`이 소유한다. `evidence/acceptance/current_poc_candidate.json`은 Candidate 003의 pre-060 historical exact-byte pointer일 뿐 current acceptance locator가 아니다.

```yaml
pre_sx_dec_060_implementation_execution_state: MERGED_MAIN_VERIFIED
pre_sx_dec_060_implementation_merge_pr: 158
pre_sx_dec_060_implementation_merge_main: 162e8a0a5e8ddc8472e74a6152e87dc12008e34c
pre_sx_dec_060_implementation_notion_readback: PASS
pre_sx_dec_060_candidate: SX59-POC-ACCEPT-003
pre_sx_dec_060_candidate_role: HISTORICAL_PRE_CHANGE_EVIDENCE_ONLY
pre_sx_dec_060_candidate_003_package_integrity: PASS
pre_sx_dec_060_candidate_003_pck_integrity: PASS · 472_OF_472
pre_sx_dec_060_candidate_003_product_texture_packaging: PASS · 73_OF_73
pre_sx_dec_060_candidate_003_powershell_51_live_download: PASS
pre_sx_dec_060_candidate_003_physical_visual_recheck: NOT_RUN
sx_dec_060_user_rule: APPROVED
sx_dec_060_design_tdd_handoff: PREPARED
sx_dec_060_runtime: MERGED_MAIN_VERIFIED · PR_188 · main_740b4b9312fa27289fd62baab8dda54c68ead3a7
sx_dec_060_automated_regression: PASS · 111_CASES_13461_ASSERTIONS · CI_7_GREEN
sx_dec_060_five_pass_review: CLOSED · SX-AUD-071
sx_dec_060_notion_readback: PASS
post_sx_dec_060_candidate: SX60-POC-ACCEPT-003 · PREPARED_PACKAGE_VERIFIED · PACKAGE_ONLY
post_sx_dec_060_candidate_minimum_product_source_main: 8bce715b5045afebfb04d38108d2e3f7353e1b10
sx60_poc_accept_001: HISTORICAL_SUPERSEDED_BY_PLAYER_FACING_BYTE_CHANGE · PLAYER_FACING_RUNTIME_ROUTE_READABILITY_CHANGE
windows_physical_post_060: NOT_RUN
android_device_post_060: NOT_RUN
five_person_post_060: NOT_RUN
player_experience: NOT_RUN
production_cutover: BLOCKED_DEFERRED
```

Candidate 002의 Windows startup PASS는 역사적 physical evidence지만 P1 visual defect 때문에 acceptance 승격이 금지됐다. Candidate 003 package integrity와 남은 physical visual recheck도 pre-SX-DEC-060 exact bytes의 역사 evidence이며 post-060 acceptance를 증명하지 않는다.

현재 post-060 implementation route:

```text
NoLaunch verification PASS on SX60-POC-ACCEPT-003, then the exact post-060 candidate physical self-run after package proof
→ Windows physical smoke and audio perceptual QA
→ Android device smoke as a separate platform gate
→ Five-person first-contact comprehension on that post-060 build
→ product decision
```

## 5. r5.4 execution / toolchain overlay

Godot authoring·runtime이 실제 acceptance에 필요한 작업에서만 최신 Base의 Godot/fresh-shell owner를 progressive-load한다.

```text
fresh shell
→ exact repository/project LOCATION verification
→ git fetch/prune
→ clean + safe fast-forward reconciliation only
→ official upstream update check
→ reviewed safe auto-update only when compatibility + rollback + canary PASS
→ exact pin readback
→ exact Godot Editor/project/session identity
→ authoring/test/runtime
→ readback
```

프로젝트별 동일 Godot binary나 전용 포트를 기본적으로 증식시키지 않는다. compatible host에서는 shared approved exact Godot/Godot-AI pin과 provider default fixed ports를 사용하고, project isolation은 exact path/editor/session identity로 보장한다. 충돌·breaking migration·추가 비용·권한 확대가 있으면 자동 update하지 않는다.

`GPT_LOCAL_CODEX_ORCHESTRATION_RETIRED`: 사용자 PowerShell이나 GPT one-shot launcher로 local Codex를 띄우는 경로는 사용하지 않는다. 실제 Godot 제품 구현이 새로 필요할 때만 `CODEX_GODOT_PRODUCT_IMPLEMENTATION_HANDOFF`로 전환하고 Codex가 Project GitHub+Notion을 독립 fresh-read한 뒤 자신의 구현환경에서 구현/test/runtime evidence를 만든다.

이 섹션은 Base의 상세 Godot 운영 계약을 복제하지 않는다. 실제 실행 시 current Base owner와 프로젝트 `docs/tooling/local_godot_tooling_state.json`을 다시 읽는다.

## 6. Deferred package authorization boundary

```text
SX-DEC-056A: PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED
SX-DEC-056B: BLOCKED_BY_AUTHORITATIVE_SCORE_COMBO_RUNTIME
SX-DEC-057: PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED
SX-DEC-058: PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED
```

v4.8 r5.4 adoption은 위 package의 구현 권한을 추가하지 않는다. 056A Route Probe/PB/Fingerprint, 056B score/max-combo, 057 Yard Labs/Mastery, 058 challenge generator/pipeline은 별도 승인/의존성 Gate를 유지한다.

## 7. Current owner read order

1. latest Base completed `main` + Base root `AGENTS.md`.
2. Base `skills/SKILL_REGISTRY.json` + `docs/generated/BASE_ACTIVE_SKILLS.md` trigger coverage.
3. project `AGENTS.md`.
4. exact Project Notion Home.
5. `기획서/00_프로젝트_허브/START_HERE.md`.
6. `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`.
7. `기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md`.
8. `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`.
9. `evidence/acceptance/post_sx_dec_060_candidate.json` when post-060 acceptance identity matters.
10. `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md`.
11. current Goal의 exact owner documents.
12. actual code/data/Scene/Resource/assets/tests/runtime evidence.
13. `evidence/acceptance/current_poc_candidate.json` only when Candidate 003 pre-060 provenance is needed.
14. historical v4.7/r2/r4 adapter/handoff/audit only when provenance or rollback evidence is needed.

Google Sheet는 이 current owner read order에 포함하지 않는다.

## 8. Current task safety / PR boundary

- pre-existing/unrelated Open/Draft/Ready PR: `READ_ONLY`.
- 사용자가 현재 작업으로 연속 승인한 하나의 current-task PR만 exact-head 검증 뒤 merge 가능.
- force push/direct-main/ruleset bypass 금지.
- product runtime scope를 바꾸는 finding은 authority/planning package에 흡수하지 않는다.

Historical concurrency closure:

- PR #154 `feat: pilot reusable grid and semantic UI modules` = **CLOSED_UNMERGED · SUPERSEDED_BY_SX_DEC_059**; do not reopen or absorb `game/reuse/*` without a new approved need and fresh evidence.
- PR #155/#156 = `CLOSED_UNMERGED · HISTORICAL_ACCIDENT`.
- PR #174 = pre-existing r4 Draft workstream; `READ_ONLY` for this r5.4 reconciliation.

## 9. Verification invariants / Implementation Reality Gate

현재 계약/정본 수정은 RED → expected failure → minimal GREEN → related regression으로 검증한다.

```text
file exists / capability discovered
≠ consumer aligned
≠ execution PASS
≠ durable readback
≠ physical/human/player PASS
```

완료 전에:

```text
exact current-task head
→ repository actual relevant checks
→ minimum five full adversarial loops
→ unresolved blocking finding 0
→ merge gate
→ new main readback
→ Notion destination readback
```

을 확인한다. `REQUIRED_WORK_REMAINING: 0`은 completion candidate일 뿐 physical/human/player evidence를 대신하지 않는다.

## 10. Historical adapter boundary

`PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.7_SWITCHY_ADAPTER.md`, 과거 v4.8 r2 provenance, 2026-08-24 r4 reconciliation plan/spec/audit는 삭제하지 않는다. history/rollback evidence이며 **current work-instruction authority가 아니다**.
