---
contract_name: PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION
contract_version: '4.8'
status: ACTIVE_PROJECT_THIN_ADAPTER
revision: '2026-08-24-r4'
current_user_contract_role: USER_PROVIDED_V4_8_R4_CONTRACT
historical_r2_sha256: 6f0541048e084746f6777223521361d0339dbfb2e223c70947f694f1c050f508
historical_r2_hash_is_not_r4_hash: true
base_repository: https://github.com/alsdmlals4-eng/Base
base_snapshot_policy: ALWAYS_REFETCH_CURRENT_COMPLETED_MAIN
adapter_policy: THIN_ADAPTER_DO_NOT_DUPLICATE_BASE_CANON
project_repository: https://github.com/alsdmlals4-eng/Switchy-Express-Cargo-Puzzle
human_workspace: NOTION_DEFAULT_PROJECT_WORKSPACE
runtime_structured_authority: GITHUB_REPOSITORY_AND_ACTUAL_RUNTIME
google_sheets_policy: COMPATIBILITY_ONLY_MIGRATION_SOURCE_UNTIL_REMOVAL
fresh_shell_bootstrap_policy: LOCATION_THEN_GIT_FETCH_SAFE_FF_PULL_THEN_UPDATE_THEN_EDITOR
update_freshness_policy: CHECK_OFFICIAL_UPSTREAM_BEFORE_LOCAL_BUILD_AND_RUNTIME
safe_auto_update_policy: REVIEW_CANARY_ROLLBACK_THEN_AUTO_APPLY_AND_EXACT_PIN
shared_godot_runtime_policy: SHARED_APPROVED_EXACT_PIN_DEFAULT_NO_PER_PROJECT_DUPLICATE_BINARY
shared_godot_ai_port_policy: FIXED_DEFAULT_PORTS_WITH_EXACT_SESSION_ROUTING
---

# Switchy Express · v4.8 r4 project thin adapter

이 문서는 사용자가 2026-08-24 제공한 v4.8 revision r4 계약을 Switchy Express에 연결하는 **프로젝트 전용 얇은 adapter**다. Base의 Work Mode·Skill·CI·검증·Godot 운영 playbook을 다시 복사하지 않는다. 매 작업 시작 시 최신 Base completed `main`, 프로젝트 실제 상태, 현재 Notion Home을 다시 읽는다.

`historical_r2_sha256`은 과거 r2 계약의 provenance다. **r4 파일 자체의 hash라고 주장하지 않는다.**

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
current_decision_span: SX-DEC-027~059
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
- **Google Sheets**: 과거 고유 미이관 자료를 위한 compatibility-only migration source. 신규 입력면이나 current GDD workspace가 아니다.

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
- 이미지 생성은 사용자 explicit request와 text brief 승인 없이는 시작하지 않는다.
- physical/human/player evidence가 없으면 automated/package evidence를 해당 PASS로 올리지 않는다.

## 4. Current implementation / evidence ceiling

현재 validation locator의 세부 exact evidence는 `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`와 `evidence/acceptance/current_poc_candidate.json`이 소유한다.

```yaml
implementation_execution_state: MERGED_MAIN_VERIFIED
implementation_merge_pr: 158
implementation_merge_main: 162e8a0a5e8ddc8472e74a6152e87dc12008e34c
implementation_notion_readback: PASS
current_candidate: SX59-POC-ACCEPT-003
candidate_003_package_integrity: PASS
candidate_003_pck_integrity: PASS · 472_OF_472
candidate_003_product_texture_packaging: PASS · 73_OF_73
candidate_003_powershell_51_live_download: PASS
candidate_003_physical_visual_recheck: NOT_RUN
sx_dec_059_developer_self_run: NOT_RUN
audio_perceptual_qa: NOT_RUN
acceptance_build: NOT_YET_DESIGNATED
windows_full_physical_runtime: NOT_RUN
android_device_smoke: NOT_RUN
five_person_comprehension: NOT_RUN
player_experience: NOT_RUN
production_cutover: BLOCKED_DEFERRED
```

Candidate 002의 Windows startup PASS는 역사적 physical evidence지만 P1 visual defect 때문에 acceptance 승격이 금지됐다. Candidate 003 package integrity는 corrected physical appearance PASS가 아니다.

현재 next validation route:

```text
Candidate 003 physical visual recheck
→ same exact Candidate 003 developer self-run / screen QA
→ audio perceptual QA
→ exact acceptance build identity
→ Windows full physical smoke
→ Android device smoke as separate platform gate
→ Five-person first-contact comprehension on the same build
→ product decision
```

## 5. r4 local bootstrap / toolchain overlay

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

이 섹션은 Base의 상세 Godot 운영 계약을 복제하지 않는다. 실제 실행 시 current Base owner와 프로젝트 `docs/tooling/local_godot_tooling_state.json`을 다시 읽는다.

## 6. Deferred package authorization boundary

```text
SX-DEC-056A: PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED
SX-DEC-056B: BLOCKED_BY_AUTHORITATIVE_SCORE_COMBO_RUNTIME
SX-DEC-057: PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED
SX-DEC-058: PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED
```

v4.8 r4 adoption은 위 package의 구현 권한을 추가하지 않는다. 056A Route Probe/PB/Fingerprint, 056B score/max-combo, 057 Yard Labs/Mastery, 058 challenge generator/pipeline은 별도 승인/의존성 Gate를 유지한다.

## 7. Current owner read order

1. latest Base completed `main` + Base root `AGENTS.md`.
2. project `AGENTS.md`.
3. `기획서/00_프로젝트_허브/START_HERE.md`.
4. `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`.
5. `기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md`.
6. `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`.
7. `evidence/acceptance/current_poc_candidate.json` when acceptance identity matters.
8. `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md`.
9. current Goal의 exact owner documents.
10. actual code/data/Scene/Resource/assets/tests/runtime evidence.
11. historical v4.7/r2 adapter/handoff/audit only when provenance or rollback evidence is needed.

## 8. Current task safety / PR boundary

- pre-existing/unrelated Open/Draft/Ready PR: `READ_ONLY`.
- 사용자가 현재 작업으로 연속 승인한 하나의 current-task PR만 exact-head 검증 뒤 merge 가능.
- force push/direct-main/ruleset bypass 금지.
- product runtime scope를 바꾸는 finding은 authority/planning package에 흡수하지 않는다.

Historical concurrency closure:

- PR #154 `feat: pilot reusable grid and semantic UI modules` = **CLOSED_UNMERGED · SUPERSEDED_BY_SX_DEC_059**; do not reopen or absorb `game/reuse/*` without a new approved need and fresh evidence.
- PR #155/#156 = `CLOSED_UNMERGED · HISTORICAL_ACCIDENT`.

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

`PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.7_SWITCHY_ADAPTER.md`와 과거 v4.8 r2 provenance는 삭제하지 않는다. history/rollback evidence이며 **current work-instruction authority가 아니다**.
