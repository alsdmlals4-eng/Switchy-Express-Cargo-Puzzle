  expected_version_when_godot_4_7_x: "9.7.1"
  source_branch_or_release: "godot_4_7"
  pinned_source_commit:
  license_expected: "MIT"
  authority: DETERMINISTIC_GDSCRIPT_TEST_AUTHORITY_WHEN_ADOPTED
  adoption_record:
  adoption_status: NOT_VERIFIED

hera_agent:
  canonical_asset_store: "https://store.godotengine.org/asset/notnull92/hera-agent-godot/"
  canonical_source:
  exact_cli_version:
  exact_addon_version:
  role: LIVE_QA_AND_OBSERVABILITY_ONLY
  persistent_source_mutation: FORBIDDEN
  transport: LOCALHOST_ONLY
  acceptance_source_delta: NONE
  adoption_status: NOT_VERIFIED

github:
  gh_cli_expected_installed: true
  gh_version:
  gh_auth_status:
  repository_visibility:
  actions_budget_usd: 0
  default_ci_mode: REMOTE_CI
  allowed_runner_class: STANDARD_GITHUB_HOSTED
  forbidden_by_budget:
    - LARGER_RUNNER
    - GPU_RUNNER
    - PAID_CUSTOM_IMAGE
  required_check: ci-gate
  merge_method_preference: squash
  local_user_handoff: FETCH_ORIGIN_THEN_PULL_ORIGIN

target_platforms:
  - Windows
  - Android

shared_core_policy: SINGLE_GAME_LOGIC_AND_DATA_CORE
platform_separation_policy: INPUT_UI_PLATFORM_INTEGRATION_AND_DELIVERY_PROFILE_ONLY
windows_export_required: true
android_export_required: true
target_resolutions: []
target_aspect_ratios: []
input_methods:
  - keyboard_mouse
  - gamepad_when_applicable
  - touch
  - android_back
accessibility_requirements: []

build_size_policy:
  objective: PRESERVE_PERCEIVED_QUALITY_WHILE_REMOVING_WASTED_BYTES
  measure_separately:
    - DOWNLOAD
    - INSTALLED
    - RUNTIME
    - PATCH
  font_policy: UNIFY_FAMILY_AND_THEME_ROLES_NOT_FORCE_SINGLE_FILE
  platform_delivery_profiles: WINDOWS_AND_ANDROID_SEPARATE

project_google_sheet:
google_sheet_required_tabs_or_ranges: []
decision_ledger_source:
unresolved_items_source:
image_review_sheet_tab_or_range:
entry_state_reconciliation_required: true

project_asset_vault:
  local_root: "<project-root>/.asset-vault/"
  godot_local_projection: "res://assets/_vault_local/"
  tracked_manifest: "ASSET_MANIFEST.yml"
  approval_boundary: PROJECT_ASSET_APPROVED
  tracked_promotion_required: true

local_godot_reference_library:
  path: "C:/Users/user/Documents/GitHub/Godot_Reference"
  authority: REFERENCE_ONLY
  expected_categories:
    - Templates
    - Official_Demos
    - Plugins_Reference
    - Sandbox
    - Archive/Source_Zips
  known_reference_candidates:
    - godot-demo-projects-master
    - loading_serialization
    - gui_multiple_resolutions
    - 3d_graphics_settings
    - Global-Asset-Manager-2.0.1
    - Maaack_Game_Template_if_present

shared_audio_vault_path: "C:/Users/user/Documents/GitHub/shered audio vault"
shared_audio_vault_access: READ_ONLY_SOURCE_LIBRARY
shared_audio_vault_first: true
audio_runtime_reference_policy: COPY_APPROVED_ASSETS_INTO_RES_NOT_ABSOLUTE_PATH

current_goal:
requested_deliverables:
vertical_slice_scope:

protected_decisions: []
protected_behaviors: []
protected_files_or_assets: []
explicit_exclusions: []

planning_first: true
test_first_every_task: true
numeric_detail_policy: GPT_RECOMMENDED_WITH_EVIDENCE_AND_TUNING_RANGE
planning_conflict_policy: GRILL_ME_AND_REQUIRE_USER_APPROVAL
grill_me_approval_batch_max: 10
benchmark_policy: OFFICIAL_AND_PROFESSIONAL_RESEARCH_REQUIRED_WHEN_DECISION_RELEVANT

codex_handoff_policy: ON_DEMAND_CODEX_HANDOFF
codex_handoff_trigger: USER_REQUESTED_CODEX_HANDOFF
codex_package_definition_of_ready: REQUIRED
codex_preflight_policy: OPTIONAL_RISK_BASED
gpt_godot_preproduction_allowed: true

new_skill_policy: CONSOLIDATION_FIRST_BUT_ALLOWED_WITH_INDEPENDENT_BOUNDARY
base_promotion_policy: BCP_PROPOSAL_THEN_SEPARATE_APPROVED_IMPLEMENTATION_PR

implementation_authority: APPROVED_CANON_AND_RECOMMENDED_NON_CONFLICTING_DETAILS
merge_authority: APPROVED_ITEM_INHERITS_MERGE_AUTHORITY
merge_reapproval_required_for_same_approved_scope: false
post_merge_local_sync_authority: AUTHORIZED_AFTER_MERGE
godot_launch_authority: AUTHORIZED_AFTER_LOCAL_SYNC
```

### 4.1 경로 해석

- `project_local_path` = Git 저장소 루트.
- `godot_project_path` = 실제 `project.godot`이 존재하는 폴더.
- 둘이 같아도 정상.
- 로컬 경로는 사용자 환경 입력이며 Base 공용 정본으로 승격하지 않는다.
- `shared_audio_vault_path`의 `shered` 표기는 v4.4의 사용자 원문을 그대로 보존한다.

### 4.2 보호 입력

```text
[핵심 내용]

```

프로젝트 목적·확정 방향·필수 경험·기능·콘텐츠·금지 사항·완료 기준은 의미를 삭제하거나 약화하지 않는다.

---

## 5. Work Mode·Skill 라우팅

Base current Registry를 자동 라우팅 권위로 사용한다.

```text
요청
→ PLAN | BUILD | REVIEW
→ 작업 수준 L0~L4
→ primary discipline 최대 1개
→ 필요한 foundation/validation/handoff만 추가
→ 각 Skill에서 필요한 mode만 실행
→ 실제 사용한 Skill/mode와 결과 기록
```

규칙:

- 사용자가 Skill 이름을 기억할 필요가 없다.
- `load_by_default=false`는 자동 선택 금지가 아니다.
- trigger 불일치 Skill을 관성적으로 로드하지 않는다.
- Skill을 읽은 것과 실행한 것을 구분한다.
- 새 범위·새 실패·정본 변경이 생기면 라우팅을 재계산한다.
- 외부 process overlay는 Base Skill 라우팅을 대체하지 않는다.

---

## 6. 전체 생명주기

```text
CURRENT BASE RECOVERY
→ PROJECT WHOLE-STATE RECOVERY
→ ENTRY STATE RECONCILIATION
→ PLAN
→ BENCHMARK
→ EXISTING SOLUTION FIRST
→ GRILL ME ONLY FOR MATERIAL PLANNING CONFLICT
→ APPROVED DECISION SYNC
→ BUILD
→ TEST-FIRST / VALIDATION
→ PLAYER-EXPERIENCE EVIDENCE AS APPLICABLE
→ ADVERSARIAL ATTACK
→ VALIDATE CRITIQUE
→ APPROVED MINIMAL FIX
→ REGRESSION RECHECK
→ EXACT CURRENT PR VALIDATION TARGET
→ REQUIRED CI-GATE
→ MERGE WITH REUSED APPROVAL
→ NEW MAIN READBACK
→ POST-MERGE ADVERSARIAL RECHECK
→ SAFE BRANCH CLEANUP
→ LOCAL FETCH/PULL
→ GODOT PROJECT PLAY
→ FINAL EVIDENCE REPORT
```

한 시점의 주 Work Mode는 하나다.
복합 작업은 `PLAN → BUILD → REVIEW`로 전환한다.

---

## 7. 프로젝트 전체 복원

작업 시작 전에 다음을 서로 대조한다.

```yaml
repository:
  current_main_sha:
  current_branch:
  working_tree_state:
  open_same_goal_prs:
  recently_merged_same_goal_prs:

project:
  current_confirmed_decisions:
  active_context:
  current_goal:
  next_work:
  blocked_items:
  actual_code_data_scene_resource_state:

sheet:
  exact_url:
  relevant_tabs_or_ranges:
  decision_ids:
  unresolved_items:
  image_review_status:
  reread_status:

entry_reconciliation:
  claimed_state:
  observed_state:
  result: READY | REVISE | BLOCKED_UNVERIFIED
```

검색·대화 기록만으로 프로젝트 전체 상태를 추정하지 않는다.

---

### 7.1 핵심 요구 추적표 — v4.4 보호 계약 복원

모든 핵심 요구·승인 Decision·보호 항목을 구현·검증·병합·로컬 실행까지 추적한다.

| 요구/Decision ID | 원문 요구·결정 | 책임 정본 | 계획/데이터 | 실제 구현 | 시각/컴포넌트 | 테스트·실행 증거 | 상태 |
|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  | `PENDING` |

허용 상태:

```text
CONFIRMED
SPECIFIED
APPROVED
CANON_SYNCED
SHEET_SYNCED
IMPLEMENTED
RUNTIME_VALIDATED
HUMAN_VALIDATED
MERGED
LOCAL_RUN_VALIDATED
DEFERRED_WITH_REASON
OUT_OF_SCOPE_CONFIRMED
USER_DECISION_REQUIRED
BLOCKED_UNVERIFIED
```

모든 핵심 요구가 위 상태 중 하나로 닫히지 않으면 전체 완료가 아니다.
`CANON_SYNCED`와 `SHEET_SYNCED`는 가능한 경우 같은 Decision ID를 사용한다.

## 8. 기획 우선·핵심 게임 모델

구현 전에 최소 다음을 닫는다.

```yaml
project_goal:
pointed_fun:
core_loop:
session_loop:
meta_loop:
core_systems: []
supporting_systems: []
player_verbs: []
meaningful_choices: []
failure_learning:
reward_structure:
protected_identity:
```

### 8.1 기획 우선 Hard Gate

기획이 미완료인 상태에서는 구현 편의를 이유로 세부 방향을 확정하지 않는다.

```text
기획 구조
→ 핵심 재미·목표·시스템
→ 기능 단위 명세
→ 데이터·수치 권장안
→ 충돌 Decision
→ 이미지/UX 근거
→ 승인·정본 동기화
→ 전체 기획 완료 선언
→ 최종 검수
→ 구현
```

### 8.2 상세 데이터·수치 — GPT 권장안 기본

세부 수치·밸런스·간격·쿨다운·보상량·확률·UI dimension 등 **프로젝트 코어를 바꾸지 않는 조정 가능 수치**는 GPT가 권장안을 만든다.

```yaml
numeric_recommendation:
  decision_or_feature_id:
  recommended_value:
  recommended_range:
  benchmark_or_industry_basis:
  player_experience_rationale:
  risk:
  tuning_signal:
  rollback_or_adjustment_rule:
```

수치가 핵심 재미·경제 구조·플레이어 약속·보호 동작과 충돌하면 `PLANNING_CONFLICT`로 승격하고 Grill Me 승인을 받는다.

질문:

- 이 기능이 핵심 재미를 강화하는가?
- 플레이어의 행동·선택·결과가 명확한가?
- 핵심 시스템과 보조 시스템을 혼동하지 않았는가?
- 기능 제거 시 프로젝트 정체성이 깨지는가?
- 단순 기능 추가보다 더 작은 해법이 있는가?

---

## 9. 벤치마킹·현업 조사

중요 결정은 최신 외부 근거를 사용한다.

우선순위:

1. 공식 문서·공식 릴리스·공식 저장소
2. 유지되는 오픈소스/업스트림
3. 현업 엔지니어링 문서·공개 postmortem
4. 유사 게임 실제 플레이·패치·개발자 설명
5. 플레이어 행동/리뷰
6. 커뮤니티 의견

앞으로 **Grill Me 질문을 만들 때와 중요한 작업 권장안을 만들 때마다** 관련 벤치마킹·현업 비교를 함께 검토한다.

```yaml
benchmark_recommendation:
  feature_or_decision_id:
  project_current_direction:
  comparable_titles_or_products: []
  official_or_professional_sources: []
  industry_pattern:
  player_response_when_available:
  what_to_copy: []
  what_not_to_copy: []
  gpt_recommendation:
  why_this_fits_project:
  uncertainty:
```

단순 유행 추종이 아니라 현재 프로젝트의 강점·비용·플랫폼·제작 규모와 비교한다.
Grill Me 선택지에는 가능한 경우 각 선택의 **벤치마크 근거 / 현업 관행 / 프로젝트 적합성 / 비용·위험**을 짧게 붙인다.

각 근거는 다음을 분리한다.

```yaml
evidence:
  source:
  date:
  claim:
  fact_or_inference: FACT | INFERENCE
  project_applicability:
  conflict_with_current_canon:
  decision_changed:
```

`BENCHMARK_ONLY_DECISION`은 금지한다.
비교 대상의 기능을 그대로 복사하지 않는다.

### 9.1 v4.5 작성 시 재확인한 공개 기준

아래는 **2026-08-11 관찰값**이며 실행 시 재검증한다.

- Godot 4.7.1-stable: 2026-07-14 maintenance stable.
- Godot 4.8: v4.5 작성 시 archive에서 dev 계열.
- GUT 9.7.1 `godot_4_7`: Godot 4.7.x 대상.
- public repository + standard GitHub-hosted runner: GitHub Actions 사용은 무료.
- GitHub Actions는 full-length commit SHA pin이 immutable 사용의 권장 안전 경계.
- Required status check는 현재 요구되는 최신 validation target에서 성공해야 한다.

공식 재검증 출발점:

```text
GitHub Actions billing
https://docs.github.com/en/billing/concepts/product-billing/github-actions

GitHub-hosted runners
https://docs.github.com/en/actions/reference/runners/github-hosted-runners

GitHub Actions secure use
https://docs.github.com/en/actions/reference/security/secure-use

GitHub required status checks
https://docs.github.com/en/pull-requests/how-tos/merge-and-close-pull-requests/troubleshooting-required-status-checks

Godot 4.7.1 release
https://godotengine.org/article/maintenance-release-godot-4-7-1/

Godot release archive
https://godotengine.org/download/archive/

GUT
https://github.com/bitwes/Gut
```

---

## 10. Existing Solution First

새 MCP·addon·CLI·framework·Skill·mode·tool·system을 만들기 전에 다음을 조사한다.

```text
프로젝트 기존 구현
→ Base current owner/mode/reference
→ Local Godot Reference Library
→ Godot 공식 데모·템플릿
→ Godot Asset Library
→ 유지되는 외부 대안
→ LICENSE / maintenance / compatibility / adoption cost
→ REUSE | EXTEND | TRIAL | REJECT | BUILD_NEW
```

`BUILD_NEW`는 기본값이 아니다.

필수 기록:

```yaml
existing_solution_disposition:
  searched_sources: []
  candidates: []
  selected:
  rejected_with_reason: []
  build_new_justification:
  rollback:
```

---

## 11. Grill Me·Decision 승인

사용자에게 올리는 것은 **중요 기획 충돌·방향 선택**이다.

자동 권장 가능:

- 가역적 수치
- 기술 기본값
- 범위 안의 구현 세부
- 명백한 오류 수정

사용자 결정 필요:

- 프로젝트 코어 변경
- 핵심 재미 방향 변경
- MVP/Vertical Slice 범위 의미 변화
- 중요한 UX·보상·경제·서사 선택
- 호환성 파괴
- 보호 대상 삭제
- 승인 범위 확대

Decision batch:

```yaml
max_decisions_per_batch: 10
early_checkpoint_allowed: true
early_checkpoint_when:
  - high_risk_conflict
  - core_direction_changed
  - session_or_context_end_risk
  - canon_impact_is_large
  - contradictions_accumulate
  - next_decision_depends_on_prior_user_choice
```

### 11.1 Grill Me 질문 규칙

각 중요한 충돌 질문에는 가능하면 다음을 제공한다.

1. 현재 프로젝트 정본의 상태
