# Switchy Express · AI 작업 시작점

한국어 1인 개발 프로젝트다. 결과부터 설명하고 역할·작동 방식·직접 확인 방법을 알려준다.
이 문서는 상시 안전 경계와 읽기 경로만 소유한다. 게임 규칙·진행 상태·패키지 번호를 복제하지 않는다.

## 권위와 current-authority read order

System/developer/security 제약 → 최신 사용자 지시·승인 → 이 문서 → 프로젝트 adapter
→ 현재 Decisions / Active Context → 등록된 분야 정본과 실제 consumer·검증 증거
→ 채택 compatibility 계약 → 선택한 최신 Base 방법 → 외부 사례·과거 기록 순서다.
문서와 구현이 다르면 둘 중 하나를 조용히 정답으로 만들지 말고 승인·실제 파일·증거로 책임 원본을 판정한다.

1. 현재 checkout의 이 문서, 로컬 변경과 원격 최신 main, 관련 Open/Draft PR·작업 중첩을 확인한다.
2. [현재 결정](기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md),
   [Active Context](기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md),
   [프로젝트 adapter](PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md)를 읽는다.
3. [START_HERE](기획서/00_프로젝트_허브/START_HERE.md)에서 이번 작업의 책임 원본만 골라 실제 코드·씬·데이터·자산·테스트 사용처를 확인한다.
4. `python tools/validate_project_contract.py`로 로컬 계약 연결을 검사하고
   [.agents/skills/base-project-router/SKILL.md](.agents/skills/base-project-router/SKILL.md)로 필요한 스킬만 선택한다.
   sibling workflow-router는 잠긴 generator의 호환 산출물이지 현재 실행 진입점이 아니다.
5. Base 원격 최신 completed main을 확인하고 Base AGENTS·START_HERE와 **이번 작업에 해당하는 절만** 읽는다.
   채택 계약과 drift를 구분한다. 최신 Base 관찰 SHA는 영구 기준·release repin·전역 변경 권한이 아니다.

과거 채팅·메모리·PDF·고정 SHA·오래된 phase/PR 번호를 현재 실행 권한으로 추정하지 않는다.
GitHub repository가 단일 정본이다. `GOOGLE_SHEETS: RETIRED_NO_ACTIVE_USE`; Notion도 `RETIRED_NO_ACTIVE_USE`;
역사 감사 요청이 없으면 읽기·쓰기·동기화를 재개하지 않는다.

## 계획·승인·실행

- 새 변경 전 의도·현재 상태·바꿀 것/보호할 것·구현 방향·완료/검증 기준을 짧게 정리하고 승인받는다.
- 같은 승인 범위에서는 재질문·재계획 없이 구현, 필요한 자산 연결, 검증·교정·정본 갱신, 정상 PR 병합·main 재확인까지 진행한다.
- `UNIFIED_WORK_EXECUTION`: 현재 실행면의 실제 capability로 작업한다. GDScript/Scene 수정이라는 이유만으로 다른 AI/세션에 강제 이관하지 않는다. 실제 도구·권한이 없을 때만 필요한 인계 범위를 남긴다.
- 기존 코드·승인 자산·유효한 조사/검증을 먼저 재사용한다. 중요한 새 판단에만 공식/1차 조사와 실무 비교를 추가한다. 매 작업 3개 대안·전면 SWOT·전체 스킬 읽기는 의무가 아니다.
- 같은 승인 계약의 **전체 적대 검토 예산은 2회로 공유**한다. 단계/파일/도구마다 초기화하지 않는다. 이후 지적은 영향 범위 교정·회귀로 닫고, 필요한 독립 검토는 작성자 자기 검토로 대체하지 않는다.
- 새 방향·코어 의미·주요 UX/아트 방향·범위·추가 비용·보안·파괴적 변경은 별도 승인이다.
- 자료/도구가 없으면 그 의존 작업만 미검증으로 남긴다. 독립적이고 승인된 작업은 계속한다. 실패한 검사를 PASS로 우회하지 않는다.

## 보호할 제품·환경

- 유한 화물 퍼즐의 의미는 [FINITE_DELIVERY_PUZZLE_BASELINE](기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md)과 최신 결정이 소유한다.
  SX-DEC-060 cardinal-adjacent station service, exact-cell pickup, LIFO/TOP, free build/refund, occupied switch lock, Retry/Edit를 임의로 바꾸지 않는다.
- 엔진·플러그인 pin, 저장 호환성, 승인 탑뷰 자산과 현재 아트 방향은 보호한다.
  `project.godot` 및 [local tooling state](docs/tooling/local_godot_tooling_state.json)를 실제 편집기/실행 프로젝트와 대조한다.
- 설치 플러그인·전역 설정·외부 서비스를 임의로 변경하지 않는다.
- 기존 dirty/untracked 파일·다른 작업 폴더와 PR을 보호한다. 현재 PR 목록을 다시 확인한다.
  알려진 별도 작업 #174/#254/#281은 별도 승인 없이 수정·흡수·병합·종료하지 않는다.
- 역사적 endless/fuel/BOOST/capacity 8/respawn/auto-reset 및 보류된 score·solver·generator 방향을 자동 부활시키지 않는다.

## 검증·이미지·기록

- `DOC / MACHINE / RUNTIME / HUMAN / USER_APPROVAL / MERGE / RELEASE`는 별개다.
  실행하지 않은 항목은 `NOT_RUN`; 자동 테스트나 AI 검토를 사람의 재미/가독성 PASS로 바꾸지 않는다.
- 머신 검증이 기본이며 5인 이해도·플레이 경험 연구는 의무가 아니다. 사용자 검수는 최종 검수용이다.
  사람 증거가 없다는 이유만으로 승인된 구현을 순환 차단하지 않는다.
- 재미·표현 변경은 [CORE_GAMEPLAY의 재미 검증 연결](기획서/10_경험/CORE_GAMEPLAY.md#재미-검증-연결)과
  [PLAYTEST_PLAN](기획서/50_제작_검증/PLAYTEST_PLAN.md)을 조건부로 따른다. 보편적 재미 점수나 새 보고서/분석 서버를 만들지 않는다.
- 이미지 제작 전 실제 consumer·규격·기존 승인 자산을 확인한다. 실제 이미지 도구를 사용하며 신규 생성은 크로마키 배경 후 배경제거한다.
  후보·승인·정본 등록·런타임 연결·화면 검증을 구분한다. 탑뷰 일관성과 provenance/alpha QA를 보호한다.
- 작업 기록은 기존 정본·Active Context에 짧게 연결한다. 월간 일지는 [AI_WORKLOG_EVIDENCE_POLICY](docs/reporting/AI_WORKLOG_EVIDENCE_POLICY.md)에 따라 **기존 파일에 날짜별 요약을 누적**한다.
  작업일·기록일·캡처일·발행일과 확인 범위를 구분한다.
- 파일을 직접 삭제하지 않는다. 사용처·폐기 근거·소유권·복구 가능성을 확인한 것만 사용자 삭제대기 폴더로 이동하고 원래 경로/해시/이유와 링크를 제공한다. 최종 삭제는 사용자다. 모르는 파일·열린 PR worktree는 보존한다.

## Git과 완료

시작은 fetch와 상태 확인, clean checkout만 fast-forward한다. 작업은 격리 branch → 검사 → push/PR
→ 필수 검사와 승인 조건 → 정상 merge → fresh main과 원격 일치 확인 순서다.
direct main push, force push, admin/ruleset bypass는 금지다.
미완료·차단·증거 한계를 남기며 문서-only 작업을 게임/출시 완료로 보고하지 않는다.

조건부 권리·출시 owner:
[프로필](docs/PLATFORM_RELEASE_AND_ASSET_RIGHTS_PROFILE.md),
[자산 provenance](docs/ASSET_RIGHTS_AND_PROVENANCE_RECORD.md),
[출시 증거](docs/GAME_RELEASE_COMPLIANCE_EVIDENCE_PACK.md).
Base 적용/호환 기준과 이후 읽기 경로는 프로젝트 adapter가 소유한다.
