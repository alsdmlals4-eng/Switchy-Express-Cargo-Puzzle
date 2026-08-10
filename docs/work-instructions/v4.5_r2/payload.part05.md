가능하면 Windows·Android 각 delivery profile에서 확인한다.

### 35.1 완성형 Vertical Slice 기준 — v4.4 보호 계약

Vertical Slice가 완료되려면 최소 다음이 실제로 연결되어야 한다.

```yaml
vertical_slice_complete:
  representative_problem:
  representative_player_action:
  meaningful_choice:
  system_response:
  first_result:
  success_failure_or_resolution:
  feedback_and_reward:
  return_or_next_flow:
  save_or_state_continuity_when_applicable:
  windows_run:
  android_run_or_explicit_not_run:
  tech_evidence:
  ui_evidence:
  human_usability_evidence:
  player_experience_evidence:
```

개별 Scene·기능·mock 화면만 동작하는 상태는 Vertical Slice 완료가 아니다.

### 35.2 로컬 접근이 없는 에이전트

사용자 Windows 로컬에는 접근할 수 없지만 GitHub에는 접근 가능한 경우:

1. 원격 조사·PR·CI·병합·merged-main readback까지만 실제 수행한다.
2. 로컬 Fetch/Pull·PowerShell·Godot 실행을 했다고 주장하지 않는다.
3. `LOCAL_SYNC_BLOCKED_NO_LOCAL_ACCESS`, `GODOT_RUN_BLOCKED_NO_LOCAL_ACCESS`를 기록한다.
4. 정확한 사용자 작업 명령·기대 SHA·성공 판정을 **최종 User Action Required 섹션에 모아** 제공한다.
5. 사용자가 결과를 제공하면 그 증거로 후속 판정을 한다.

---

## 36. Base 승격

프로젝트에서 발견한 재사용 후보:

```text
project evidence
→ function-level classification
→ repeated/generalizable pattern
→ [수정제안서]/BCP - [프로젝트명] project-source proposal
→ evidence pack
→ proposal/index registration
→ proposal PR
→ review/approval
→ separate approved Base implementation PR when active rules must change
→ Base Registry change only when that implementation is separately authorized
→ Base tests / freshness / adversarial review
→ merge
```

### 36.1 프로젝트 출처형 BCP 규칙

수정제안서를 작성할 때 **Base 활성 규칙을 proposal 단계에서 직접 건드리지 않는다.**

권장 구조:

```text
[수정제안서]/
└─ BCP - [프로젝트명] - [개선주제]/
   ├─ PROPOSAL.md
   └─ evidence/
      ├─ PROJECT_VALIDATION.md
      ├─ BEFORE_AFTER.md
      ├─ COUNTEREXAMPLES.md
      └─ TRACEABILITY.md
```

```yaml
bcp_project_source:
  source_project:
  source_decision_ids: []
  source_commits_or_prs: []
  problem_observed:
  validated_improvement:
  evidence:
  reusable_boundary:
  project_specific_values_removed:
  existing_base_owner:
  conflict_analysis:
  proposed_absorption:
  rollback:
```

### 36.2 “Registry 등록”의 충돌 방지 해석

`Base 활성 규칙은 건드리지 않는다`와 `Registry 등록 → PR → 검증 → 병합`을 동시에 만족시키기 위해 다음을 구분한다.

```text
PROPOSAL PHASE
→ BCP proposal/index/registry 성격의 등록
→ [수정제안서] 범위
→ active Skill/Rule Registry 변경 금지

APPROVED IMPLEMENTATION PHASE
→ 별도 승인 reference
→ 필요한 경우 active skills/SKILL_REGISTRY.json 또는 owner 변경
→ 별도 implementation PR
→ TDD/freshness/adversarial/ci-gate
→ merge
```

즉 proposal-only PR에서 active `skills/SKILL_REGISTRY.json`을 미리 바꾸지 않는다.
현재 Base의 BCP 프로토콜이 별도 proposal registry/index를 제공하면 그것을 사용한다.
그런 surface가 없으면 proposal 안에 registration metadata를 남기고 active Registry는 구현 PR까지 기다린다.

proposal 등록과 active Base 구현을 같은 단계로 합치지 않는다.

프로젝트 고유 값·경로·아트를 Base에 승격하지 않는다.

---

## 37. Skill 변화·부분 흡수

### 37.1 전체 Skill을 가져오지 않아도 부분 흡수

외부/프로젝트 Skill을 검토할 때 “전체 채택 또는 전체 거부” 이분법을 금지한다.

흡수 후보:

- 특정 mode
- review lens
- checklist
- test pattern
- failure classification
- prompt 구조
- reference 문서
- evidence schema
- debugging step
- tool integration pattern

```yaml
skill_absorption:
  source_skill_or_framework:
  feature_or_function:
  source_license_or_usage_boundary:
  classification:
  reusable_part:
  rejected_part:
  target_existing_base_skill_or_doc:
  why_partial_absorption_is_better:
  regression_needed:
```

기존 Base owner에 자연스럽게 흡수되면 새 Skill을 만들지 않는다.

### 37.2 기능 단위 분해·상태 분류

Skill·기능·규칙·문서·workflow를 다음처럼 **기능 단위**로 쪼갠다.

```text
ALREADY_INTEGRATED
CURRENTLY_VALID
CONFLICTING_OR_OUTDATED
PARTIALLY_REUSABLE
MISSING_AND_NEEDED
DEFERRED_WITH_REASON
```

| 기능 단위 | 현재 Base/프로젝트 위치 | 상태 | 충돌/구형 이유 | 흡수/유지/제거 권장 | 증거 |
|---|---|---|---|---|---|
|  |  |  |  |  |  |

### 37.3 새 Skill 후보

```text
existing Skill mode/ref로 해결 가능
→ 통합/부분 흡수

독립 reusable input/output/authority/validation boundary 존재
→ 새 Skill 후보
```

Skill 숫자 목표는 없다.

---

### 37.4 최적 작업에 필요한 요소가 없을 때

최적 작업에 필요한 핵심 요소가 없으면 **해당 의존 단계는 중단**한다.
그러나 독립적으로 진행 가능한 조사·기획·검토까지 불필요하게 멈추지 않는다.

```yaml
missing_requirement:
  item:
  why_needed:
  benefit_if_available:
  can_gpt_resolve_directly:
  safe_auto_install_or_config_possible:
  dependent_stage_blocked:
  independent_work_can_continue:
  user_action_required:
  exact_steps:
  verification_after_action:
```

원칙:

1. GPT가 현재 권한·도구로 안전하게 해결 가능하면 직접 해결한다.
2. 사용자만 할 수 있는 설치·로그인·권한·로컬 UI 조작이면 dependent stage를 `BLOCKED_USER_ACTION`으로 둔다.
3. 사용자 요청은 가능하면 현재 응답의 **마지막 `User Action Required`**에 모은다.
4. 보안·데이터 손실·과금·법률 위험 때문에 즉시 확인이 필요한 경우만 즉시 중단·질문한다.
5. 예: GitHub CLI가 없으면 왜 필요한지, 설치 시 장점, 공식 설치 방법, `gh --version` / `gh auth status` 확인법을 제공한다.
6. 설치가 “있으면 좋은 것”인지 “없으면 진행 불가”인지 구분한다.

## 38. 증거 Manifest

```yaml
evidence_manifest:
  base:
    current_main_sha:
    registry_read:
    selected_skills: []
    executed_skill_modes: []
    external_process_overlay:

  project:
    repository:
    base_sha:
    head_sha:
    approval_reference:
    decisions: []
    protected_items: []

  planning:
    core_game_model:
    requirement_traceability:
    benchmark_sources: []
    professional_comparisons: []
    existing_solution_disposition:
    grill_me_decisions: []
    grill_me_batch_checkpoint:
    planning_complete_user_declaration:
    final_planning_review:

  implementation:
    phase: GPT_PLANNING | FINAL_REVIEW | POWERSHELL_CODEX_BUILD
    powershell_codex_command:
    powershell_approval_prompts_used:
    fresh_execution_identity:
    changed_files: []
    tests_red:
    tests_green:
    runtime:

  player_experience:
    TECH_EVIDENCE:
    UI_EVIDENCE:
    HUMAN_USABILITY_EVIDENCE: NOT_RUN
    PLAYER_EXPERIENCE_EVIDENCE: NOT_RUN
    first_session:
    decision_screen:
    minigame_gate:

  assets:
    images:
    audio:
    provenance:
    asset_vault:
    local_reference_library:

  godot:
    version:
    higodot:
    gut:
    hera:
    clean_import:
    application_run_main_scene:
    project_play:
    tracked_source_delta_after_qa:

  platforms:
    windows:
    android:
    build_size:

  github:
    open_draft_pr_inventory:
    pr:
    review_head_sha:
    base_sha:
    ci_validation_target_sha:
    required_check:
    unresolved_threads:
    strict_up_to_date:
    merge_commit:
    new_main_sha:
    branch_cleanup:

  sheet:
    decision_sync:
    reread:

  skill_absorption:
    function_classification:
    partial_absorptions: []

  blockers:
    user_action_required: []

  local_delivery:
    fetch:
    pull:
    local_main_sha:
    godot_run:
```

---

## 39. 완료 판정

최상위 성공은 다음처럼 단계별 증거가 있어야 한다.

```text
BASE_CURRENT_AUTHORITY_RECOVERED
→ PROJECT_STATE_RECONCILED
→ PLANNING_COMPLETE
→ DECISIONS_SYNCED
→ IMPLEMENTATION_COMPLETE
→ TECH_EVIDENCE_RECORDED
→ UI_EVIDENCE_RECORDED_WHEN_APPLICABLE
→ HUMAN/PLAYER_EVIDENCE_RECORDED_OR_EXPLICIT_NOT_RUN
→ ADVERSARIAL_REVIEW_COMPLETE
→ EXACT_CURRENT_VALIDATION_TARGET_PASSED
→ CI_GATE_PASSED
→ MERGED_MAIN_VERIFIED
→ POST_MERGE_RECHECK_COMPLETE
→ LOCAL_SYNCED_OR_EXPLICIT_BLOCKED
→ PROJECT_PLAY_VALIDATED_OR_EXPLICIT_BLOCKED
```

`NOT_RUN`을 숨기지 않는다.

---

## 40. 실패 조건

다음 중 하나라도 있으면 완료를 선언하지 않는다.

### Base·권위

- instruction 작성 요청인데 실제 Base/프로젝트 작업까지 실행
- Base current main 재조회 없음
- recursive inventory 또는 미검증 범위 표시 없음
- Registry 없이 임의 Skill 선택
- v4.5의 snapshot을 영구 current authority로 사용
- v4.5의 Base 절차 복사본을 current Base보다 우선

### External Process

- 외부 process overlay가 project/Base canon을 덮어씀
- overlay가 안전 Gate를 약화
- 같은 승인 범위를 재승인 요구
- Skill을 읽기만 했는데 실행했다고 보고
- `OVERLAY_CONFLICT`를 숨김

### 프로젝트·기획

- PHASE A/B 완료 전에 PowerShell/Codex/Godot BUILD 시작
- 사용자 “기획 완료” 선언 없이 구현 단계 진입
- 핵심 요구 추적 누락
- 프로젝트 코어/핵심 재미 복원 없음
- benchmark 없이 중요한 권장안 확정
- 출처 사실과 추론 혼합
- Planning conflict를 사용자 승인 없이 결정
- 10개 Decision 최대 배치/early checkpoint 무시
- Grill Me에 벤치마킹·현업 비교가 필요한데 근거 없이 선택지 제시
- 승인 Decision을 GitHub 정본·계획 데이터·연결 Sheet에 가능한 즉시 동기화하지 않음
- 같은 Decision ID 연결 누락

### BCP-020 경험

- 자동 test/UI render로 HUMAN_USABILITY PASS 주장
- 사람 관찰 없이 PLAYER_EXPERIENCE PASS 주장
- 첫 세션에 대표 문제/행동/선택/결과/다음 질문 없음
- decision screen에서 비용·위험·결과가 읽히지 않음
- 코어 퍼즐/전투를 부당하게 minigame으로 강등

### PowerShell·Codex·Godot

- 사용자 지정 기본 Codex command 검증 없이 임의 변형
- PowerShell 사용자 승인 프롬프트를 불필요하게 2개 초과 생성
- `-a never` 운영인데 Codex 내부 approval 의존 workflow 설계
- 이전 PowerShell/Codex/Godot session/PID를 다음 블록의 current truth로 사용
- Godot 버전 추측
- HiGodot 채택 계약을 우회한 persistent authoring
- GUT 0 test discovery를 성공 처리
- Hera QA 후 tracked source delta 존재
- clean import 미검증
- actual main scene 실행 없음

### 자산

- Draft/placeholder 최종화
- provenance/license 미검증
- shared audio 원본 무단 변경
- 외부 절대 경로 production dependency
- local-only asset 후보가 tracked production 참조

### CI·PR

- 작업 시작/배치 종료/병합 후 모든 Open/Draft PR 감사 누락
- proposal-only/reference-only/DO_NOT_MERGE PR 자동 병합
- stale/duplicate PR 후속 정리 누락
- mutable Action tag/branch를 고위험 workflow에서 사용
- 과도한 `GITHUB_TOKEN` 권한
- Required Check 실패/미실행
- wrong SHA 검증
- strict up-to-date 우회
- unresolved thread
- Draft 상태인데 merge ready 주장
- `main` 이동 후 이전 GREEN으로 병합
- 승인 범위 밖 diff
- adversarial finding 미해결

### 병합 후

- 새 main readback 없음
- affected canon/consumer 재검토 없음
- 안전조건 없는 branch 삭제
- dirty/diverged local을 force/reset
- 사용자가 받을 수 없는 로컬 상태를 “전달 완료”로 주장

---

## 41. 최종 보고 형식

```markdown
# 최종 작업 보고

## 1. 작업 대상
- Base main:
- Project:
- Approved scope:
- Approval reference:
- Work Mode:

## 2. Base 라우팅
- Registry:
- Selected Skills:
- Executed modes:
- External process overlay:
- Read-only vs actually executed:

## 3. 프로젝트 복원
- Current decisions:
- Actual implementation:
- Sheet:
- Entry reconciliation:

## 4. 기획
- Planning phase:
- User planning-complete declaration:
- Requirement traceability:
- Goal:
- Pointed fun:
- Core loop:
- Core/support systems:
- Benchmark:
- Existing Solution First:
- Grill Me decisions:
- Grill Me batch checkpoint:
- Canon/Sheet Decision sync:
- Final planning review:

## 5. 플레이어 경험
- TECH_EVIDENCE:
- UI_EVIDENCE:
- HUMAN_USABILITY_EVIDENCE:
- PLAYER_EXPERIENCE_EVIDENCE:
- First session:
- Decision screen:
- Minigame narrative function:

## 6. Visual / Asset / Audio
- Visual Requirement:
- Asset Vault:
- Reference Library:
- Shared Audio:
- Provenance:

## 7. Godot
- Version:
- HiGodot:
- GUT:
- Hera:
- Clean import:
- Main scene:
- Project Play:

## 8. Windows / Android
- Shared core:
- Platform adapters:
- Size:
- Performance:

## 9. 변경
- PowerShell/Codex execution command:
- Manual approval prompts used:
- Fresh execution identity:
- Files:
- Protected items preserved:

## 10. TDD / 검증
- RED:
- GREEN:
- Static:
- Runtime:
- Accessibility:
- Performance:
- Regression:
- NOT_RUN:

