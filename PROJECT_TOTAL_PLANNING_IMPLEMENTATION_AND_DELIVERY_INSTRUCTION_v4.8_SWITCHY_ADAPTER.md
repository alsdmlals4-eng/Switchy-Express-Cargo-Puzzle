---
contract_name: PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION
contract_version: '4.8'
status: ACTIVE_PROJECT_THIN_ADAPTER
revision: '2026-08-24-r2'
source_v4_8_sha256: 6f0541048e084746f6777223521361d0339dbfb2e223c70947f694f1c050f508
base_repository: https://github.com/alsdmlals4-eng/Base
base_snapshot_observed_when_v4_8_adopted: 2828a74f60c1ed09546171040f4178c8848ea686
base_snapshot_policy: ALWAYS_REFETCH_CURRENT_COMPLETED_MAIN
adapter_policy: THIN_ADAPTER_DO_NOT_DUPLICATE_BASE_CANON
project_repository: https://github.com/alsdmlals4-eng/Switchy-Express-Cargo-Puzzle
human_workspace: NOTION_DEFAULT_PROJECT_WORKSPACE
runtime_structured_authority: GITHUB_REPOSITORY_AND_ACTUAL_RUNTIME
google_sheets_policy: COMPATIBILITY_ONLY_MIGRATION_SOURCE_UNTIL_REMOVAL
---

# Switchy Express · v4.8 project thin adapter

이 문서는 사용자 제공 v4.8 r2 계약을 Switchy Express에 연결하는 **프로젝트 전용 얇은 adapter**다. Base의 Work Mode/Skill/CI/검증 절차를 복사하지 않는다. 매 작업 시작 시 최신 Base completed `main`과 프로젝트 실제 상태를 다시 읽는다.

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

`Base v9.4.3` pin은 이 저장소가 과거 채택한 project compatibility evidence다. 현재 실행 방법론을 그 snapshot으로 고정하지 않으며, v4.8 계약에 따라 최신 Base owner를 progressive-load한다.

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
- physical/human/player evidence가 없으면 자동화 결과를 해당 PASS로 올리지 않는다.

## 4. Current implementation / evidence ceiling

```yaml
implementation_execution_state: MERGED_MAIN_VERIFIED
implementation_merge_pr: 158
implementation_merge_main: 162e8a0a5e8ddc8472e74a6152e87dc12008e34c
implementation_notion_readback: PASS
sx_dec_059_developer_self_run: NOT_RUN
acceptance_candidate: SX59-ACCEPT-001
acceptance_build: NOT_YET_DESIGNATED
windows_physical_runtime: NOT_RUN
android_device_smoke: NOT_RUN
five_person_comprehension: NOT_RUN
player_experience: NOT_RUN
production_cutover: BLOCKED_DEFERRED
```

PR #154는 `CLOSED_UNMERGED · SUPERSEDED_BY_SX_DEC_059`이며 재흡수하지 않는다. PR #155/#156은 `CLOSED_UNMERGED · HISTORICAL_ACCIDENT`다.

현재 next validation route:

```text
developer self-run / screen QA
→ exact acceptance build identity
→ Windows physical smoke
→ Android device smoke as separate platform gate
→ Five-person first-contact comprehension on the same acceptance build
→ product decision
```

`SX59-ACCEPT-001`의 artifact integrity는 준비 증거일 뿐 acceptance build 지정이나 physical/human PASS가 아니다.

## 5. Deferred package authorization boundary

```text
SX-DEC-056A: PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED
SX-DEC-056B: BLOCKED_BY_AUTHORITATIVE_SCORE_COMBO_RUNTIME
SX-DEC-057: PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED
SX-DEC-058: PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED
```

v4.8 adoption은 위 package의 구현 권한을 추가하지 않는다. 056A Route Probe/PB/Fingerprint, 056B score/max-combo, 057 Yard Labs/Mastery, 058 challenge generator/pipeline은 별도 승인/의존성 Gate를 유지한다.

## 6. Current owner read order

1. latest Base completed `main` + Base root `AGENTS.md`.
2. project `AGENTS.md`.
3. `기획서/00_프로젝트_허브/START_HERE.md`.
4. `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`.
5. `기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md`.
6. `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`.
7. `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md`.
8. current Goal의 exact owner documents.
9. actual code/data/Scene/Resource/assets/tests/runtime evidence.
10. historical v4.7 adapter/handoff/audit only when provenance or rollback evidence is needed.

## 7. Current task safety / PR boundary

- pre-existing/unrelated Open/Draft/Ready PR: `READ_ONLY`.
- 사용자가 현재 작업으로 연속 승인한 하나의 current-task PR만 exact-head 검증 뒤 merge 가능.
- force push/direct-main/ruleset bypass 금지.
- product runtime scope를 바꾸는 finding은 이 authority-migration package에 흡수하지 않는다.

## 8. Verification invariants

현재 계약/정본 수정은 RED → expected failure → minimal GREEN → related regression으로 검증한다.

완료 전에:

```text
exact current-task head
→ Project Contract / relevant repository checks
→ five full adversarial loops minimum
→ unresolved blocking finding 0
→ merge gate
→ new main readback
→ Notion destination readback
```

을 확인한다. `REQUIRED_WORK_REMAINING: 0`은 completion candidate일 뿐 physical/human/player evidence를 대신하지 않는다.

## 9. Historical adapter boundary

`PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.7_SWITCHY_ADAPTER.md`는 삭제하지 않는다. 해당 파일은 2026-08-20~23 작업의 history/rollback evidence이며 **current work-instruction authority가 아니다**.
