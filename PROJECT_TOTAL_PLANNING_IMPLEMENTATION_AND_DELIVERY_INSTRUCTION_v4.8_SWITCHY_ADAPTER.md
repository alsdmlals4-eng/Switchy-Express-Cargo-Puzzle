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
base_current_execution_model: FRESH_READ_ONLY_NO_REPIN
base_current_observation_role: TASK_SCOPED_AUDIT_INPUT_NOT_RELEASE_LOCK
adapter_policy: THIN_ADAPTER_DO_NOT_DUPLICATE_BASE_CANON
project_repository: https://github.com/alsdmlals4-eng/Switchy-Express-Cargo-Puzzle
human_workspace: GITHUB_REPOSITORY_ONLY_PROJECT_WORKSPACE
runtime_structured_authority: GITHUB_REPOSITORY_AND_ACTUAL_RUNTIME
google_sheets_policy: RETIRED_NO_ACTIVE_USE
fresh_read_bootstrap_policy: PROJECT_GITHUB_ONLY_RECONSTRUCTION_REQUIRED
past_conversation_dependency_policy: NOT_REQUIRED_FOR_NEW_CHAT_RESUME
context_drift_policy: RECHECK_BEFORE_MUTATION
skill_coverage_policy: TRIGGERED_PROGRESSIVE_LOAD_WITH_EXECUTION_RECEIPT
gpt_local_codex_orchestration_policy: RETIRED
codex_execution_policy: UNIFIED_WORK_EXECUTION_CAPABILITY_BASED
powershell_policy: LOCAL_GODOT_OR_VALIDATION_ONLY_NOT_CODEX_LAUNCHER
fresh_shell_bootstrap_policy: PROJECT_FIRST_CURRENT_AUTHORITY_READ
update_freshness_policy: CHECK_MATERIAL_TOOL_DRIFT_WITHOUT_AUTO_UPDATE
mandatory_preimplementation_evidence_loop: REUSE_VALID_EVIDENCE_THEN_TARGETED_RESEARCH_CONSUMER_CHECK_TWO_SHARED_REVIEWS
safe_auto_update_policy: NO_PLUGIN_GLOBAL_OR_ENGINE_CHANGE_WITHOUT_SEPARATE_APPROVAL
shared_godot_runtime_policy: SHARED_APPROVED_EXACT_PIN_DEFAULT_NO_PER_PROJECT_DUPLICATE_BINARY
shared_godot_ai_port_policy: FIXED_DEFAULT_PORTS_WITH_EXACT_SESSION_ROUTING
slice_delivery_policy: PLAYABLE_MEANINGFUL_SLICE_INCREMENTAL_DELIVERY
requirement_traceability_policy: REQUIREMENT_TO_OWNER_IMPLEMENTATION_EVIDENCE_COMPLETION_REQUIRED
current_base_provider_change: DEFERRED_UNVERIFIED
---

# Switchy Express · current project execution adapter

## 책임·적용 기준

`GOOGLE_SHEETS: RETIRED_NO_ACTIVE_USE`; Notion도 active read/write/sync가 아니다.
현재 진입은 `.agents/skills/base-project-router/SKILL.md`이며 sibling generated workflow-router는
호환 산출물로만 보존한다. 그 오래된 blanket stop/pinned-method 문구보다 AGENTS와 이 adapter가 우선한다.

2026-09-20 사용자가 지침 경량화 적용안에 “승인할게”로 승인했고, 같은 작업에 Base #885 재미 검증 기준 연결을 추가했다.
이 문서는 프로젝트 차이와 채택 경로만 소유한다. Base 본문이나 게임 규칙/패키지 상태를 다시 복제하지 않는다.
위 v4.8 revision과 r5.4 원본 해시는 계약의 출처이며 2026-09-20 사용자 승인에 따른 아래 실행 방법이 우선한다.

- Base latest completed main observed: `23ecad5a3084f97c4e5d1e39a9a6d70d1eeb37ef` (2026-09-20).
- PR #883 지침 경량화 merge `ebfc6c807a0d1582a2df27c518ef60398bf8486c`는 위 main의 ancestor.
- PR #885 재미→표현→consumer→증거 연결을 **선택 채택**한다. 이 관찰은 다음 작업의 영구 SHA가 아니다.
- `skills/PROJECT_BASE_ADAPTER.json`의 Base v9.4.3 release/registry lock은 **HISTORICAL_COMPATIBILITY**로 유지한다.
  generated snapshot은 호환 라우팅 뷰이지 현재 실행 상태 정본이 아니다.
- `docs/BASE_RULES_VERSION.md`와 fixed CI validator snapshot은 schema/호환 재현 기준이다.
  최신 Base 방법 fresh-read와 CI compatibility 검증을 혼동하지 않는다.
- provider migration: `DEFERRED_UNVERIFIED`. 엔진·플러그인·저장 schema·승인 자산 변경 없음.

## 작업 경로와 선택 읽기

`AGENTS.md → 현재 Decisions / Active Context → 이 adapter → 해당 owner + actual consumer + 관련 PR
→ 로컬 계약 검사 → 선택한 Base current method/skill/reference`.

로컬 검사: `python tools/validate_project_contract.py`.
이 검사는 프로젝트 파일·registry hash·local skill·snapshot 연결만 확인한다.
Base 원본의 lock/approved protected diff 검증은 `.github/workflows/validate-project-base-adapter.yml`의
`check_approved_project_operating_contract.py`가 담당한다.
검사 실패의 원인/영향을 기록하고 해당 의존 경로를 멈춘다. 승인된 계약 교정 자체와 독립 작업까지 금지하지 않는다.

| 이번 작업 | 프로젝트 owner | 필요한 Base owner (Base repository 기준) |
|---|---|---|
| 계획·승인·작업 구조 | 이 adapter; Decisions; Active Context | `skills/managing-project-intake-and-work-contract/SKILL.md`; `skills/managing-game-project-operating-system/SKILL.md` |
| 지침·스킬 간소화 | AGENTS; project routing/registry | `docs/knowledge/game-development/AI_INSTRUCTION_AND_CONTEXT_DESIGN_METHOD.md`; `skills/simplifying-skill-bodies/SKILL.md` |
| 코어·재미 가설 | `기획서/10_경험/CORE_GAMEPLAY.md#재미-검증-연결`; baseline; 해당 시스템 | `skills/analyzing-and-refining-game-concepts/references/concept-evidence-and-gates.md#fun-verification-lifecycle` |
| 효과·비주얼·UI | `기획서/40_표현/VISUAL_DIRECTION.md`; 실제 UI/spec owner | `docs/knowledge/game-development/EXPERIENCE_TO_PRESENTATION_GUIDE.md`; `skills/auditing-and-refining-ui-art/references/project-adapter-contract.md` §§10–11 |
| 검증·최종 검수 | `기획서/50_제작_검증/PLAYTEST_PLAN.md`; actual tests/evidence | selected review/validation skill only |
| 이미지 제작 | `docs/design/PROJECT_AI_PRODUCTION_SPEC.md`; 현재 asset manifest/consumer | 해당 image/Aseprite 선택 지침만 |
| 월간 일지 | `docs/reporting/AI_WORKLOG_EVIDENCE_POLICY.md` | 실제 PDF 출력 시 PDF skill |
| 동기화·병합 | 현재 PR·working tree·checks | `skills/synchronizing-local-and-github-state/SKILL.md` |

Base 파일은 `https://github.com/alsdmlals4-eng/Base/blob/main/<path>` 또는 fetch한 `origin/main:<path>`에서 확인한다.
관찰 SHA와 채택 절을 기록하되 자동 repin하지 않는다. 원격 미접속은 `UNVERIFIED`;
유효한 채택 계약 안의 독립 작업을 계속하며 없는 내용을 추정하지 않는다.
전체 inventory를 읽었다는 형식적 영수증 대신 실제 선택 스킬/참조와 재사용 근거만 남긴다.

## 승인·실행·검토 계약

- 승인된 계획의 safe continuation: 조사 → 명세 → 코드/자산 연결 → 검증 → 교정 → 정본 → 허용 PR merge/main readback.
- `UNIFIED_WORK_EXECUTION`: 도구·권한을 가진 현재 실행자가 수행한다. Codex handoff는 실제 capability 경계에만 사용한다.
- 기존 승인·조사·정확한 consumer/환경의 검증은 `REUSED_EVIDENCE`. 중요한 새로운 선택만 대안·벤치마킹·SWOT를 구체화한다.
- 전체 적대 검토 **2회**는 같은 승인 계보 전체에서 공유한다. 후속 수정은 발견 영향 범위만 검사한다.
  독립 검토·필수 CI·병합 후 파일/증거 readback은 생략하지 않되 또 다른 전체 2회 예산으로 초기화하지 않는다.
- 코드 동작 교정은 재현/RED → 수정 → GREEN/회귀. 문서 경로 검사는 링크만, 스킬은 실제 시나리오 선택도 확인한다.
- 새 방향·의미·주요 UX·비용·보안·파괴적 작업만 추가 승인. 실패/자료 부족은 의존 작업에만 `BLOCKED_UNVERIFIED` 또는 `NOT_RUN`.
- 완료는 승인 범위의 미해결 항목과 근거를 재확인한 상태다. 무한 기능 추가나 사람/출시 PASS를 뜻하지 않는다.

## 재미·표현 검증의 프로젝트 적용

Base #885는 방법만 채택한다. 이 퍼즐의 경험 owner는 CORE_GAMEPLAY, 실제 결과 owner는 PLAYTEST_PLAN과 runtime evidence다.
신규/의미 있는 플레이어-facing 변경은 같은 requirement에 **경험 가설·반례 → 규칙/상태/선택·피드백
→ 실제 코드/씬/데이터/자산 consumer → 기계/실행/최종 사용자 관찰 → 교정 판단**을 연결한다.
작은 변경은 기존 기록 1단락, 큰 기능만 기존 상세 spec을 쓴다. 순수 내부 도구는 이유 있는 `NOT_APPLICABLE`.

- 역산 계획·LIFO/TOP·분기 실행·재설계가 핵심이며 자동 solver/최적해 공개는 승인되지 않았다.
- 표시는 domain 결과를 읽는다. 효과에서 적재·배송·비용·저장 상태를 재계산하지 않는다.
- 실제 상태/시점/입력/실패·취소·복귀/가림/반복을 명세한다. 필수 값은 기존 확정 원본을 가리키고 없는 값은 `HYPOTHESIS / PLANNED`.
- 기계 검증과 실제 재미는 별개다. `NO_UNIVERSAL_FUN_SCORE`; AI 자체 평가는 HUMAN 증거가 아니다.
- 5인 이해도·플레이 경험 연구는 `NOT_REQUIRED_BY_USER_VALIDATION_POLICY`; 최종 사용자 검수 때 경험 질문을 함께 확인한다.
  미실시 사람 증거는 `NOT_RUN`, 승인된 구현은 계속한다. Base 문서 채택만으로 `FUN_PASS`를 만들지 않는다.
- 못 봄/오해/규칙·선택 문제/표현 부족/반복 피로/환경 결함을 나누고 `KEEP / CHANGE / DEFER / RETEST`를 기존 Decision에 남긴다.

## 보존·증거·종료

실제 제품·현재 package/evidence는 Active Context를 따라 확인한다. Candidate003/010 등의 과거 exact bytes는
historical evidence이며 현재 빌드 번호를 이 adapter/skill에 고정하지 않는다.
유한 코어·SX-DEC-060 cardinal service·기존 승인 topdown 자산·18-stage 현재 콘텐츠와 저장 호환성을 보호한다.
보류된 SX-DEC-056~058 계획을 이번 운영 개선 승인으로 구현하지 않는다.

기능/MACHINE, 실제 Godot/RUNTIME, 최종 HUMAN, 자산 승인, merge, release를 분리한다.
기계 검사에 필요한 Godot는 설치·tooling owner의 실제 실행 경로와 버전을 확인하며 없는 Linux 파일명을 복사하지 않는다.
Godot 실행 미실시를 PASS로 보고하지 않는다.

월간 PDF는 기존 기록에 날짜 요약을 누적한다. 삭제 후보는 근거·원경로·hash를 갖춘 사용자 삭제대기 폴더에만 정리한다.
최종 삭제는 사용자이며 이 작업에서는 제품 파일·기존 worktree·플러그인·전역 설정을 삭제/변경하지 않는다.
Git 동기화는 AGENTS의 정상 PR 경로를 따른다. #174/#254/#281은 별도 권한 없는 보호 작업이다.

## 적용 증거와 다음 읽기

현재 작업 결과/다음 행동은 Active Context, 세부 교정·검토 증거는
`docs/operations/2026-09-01-switchy-base-operating-adaptation-audit.md`의 2026-09-20 기록을 따른다.
새 대화에서는 AGENTS부터 재시작하며 과거 SHA·채팅·월간 PDF를 현재 실행 권한으로 삼지 않는다.
