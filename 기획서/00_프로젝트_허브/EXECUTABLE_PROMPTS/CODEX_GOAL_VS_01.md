# Codex Goal — VS-01 Godot 기반·RailGraph·다단계 분기기

GitHub Issue: `#4`
Parent Epic: `#3`
Plan: `docs/superpowers/plans/2026-08-01-switchy-express-vertical-slice.md`

## 역할

당신은 이 저장소의 실제 Godot/GDScript 구현 담당자다. 기획을 다시 발명하지 말고 승인된 정본과 Issue #4의 범위만 테스트 우선으로 구현한다.

## 먼저 읽기

1. `AGENTS.md`
2. `기획서/00_프로젝트_허브/START_HERE.md`
3. `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
4. `기획서/10_경험/CORE_GAMEPLAY.md`
5. `기획서/20_시스템_콘텐츠/CORE_SYSTEMS.md`
6. `기획서/40_표현/VISUAL_DIRECTION.md`
7. `기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md`
8. `docs/superpowers/plans/2026-08-01-switchy-express-vertical-slice.md`
9. GitHub Issue #4

## 이번 Goal

다음 세 결과만 구현한다.

1. Godot 4.7.1 프로젝트와 헤드리스 테스트 러너
2. 결정론적인 15×10 전체 연결 철도 그래프
3. 2단계·3단계 분기기 상태·라우팅·5칸 미리보기

기차 화차, 화물 적재, 스테이션, 연료, 점수, BOOST, 목표 품질 HUD는 이번 Goal 범위가 아니다.

## 필수 Worktree

- `main`에서 새 작업 브랜치와 독립 worktree를 만든다.
- 권장 브랜치: `feature/vs-01-rail-foundation`
- 기존 작업 디렉터리나 다른 브랜치의 미커밋 변경을 덮어쓰지 않는다.

## TDD 실행 순서

### Task 1 — 프로젝트와 테스트 기반

- boot smoke test를 먼저 작성하고 실패를 확인한다.
- `project.godot`, 1920×1080 landscape main scene, 테스트 runner를 최소 구현한다.
- 다음 명령이 통과해야 한다.

```bash
godot --headless --path . --script res://tests/run_tests.gd
```

### Task 2 — RailGraph

테스트를 먼저 작성한다.

- 크기 15×10
- seeds 1~100에서 전체 연결
- degree-1 막다른길 0
- cycle rank 최소 3
- 분기기 최소 6개
- 분기 후 최소 3칸 이상 경로 차이
- 같은 seed의 결과가 동일
- 32회 생성 실패 시 결정론적 safe fallback

그 후 `RailCell`, `RailGraph`, `RailGenerator`를 최소 구현한다.

### Task 3 — RailSwitch

테스트를 먼저 작성한다.

- 2단계: `A → B → A`
- 3단계: `A → B → C → A`
- 미입력 시 현재 기본 방향 유지
- 기관차가 통과한 뒤 기본 상태로 복귀할 수 있는 API
- incoming 방향에 따라 유효 exit 선택
- 선택 상태와 5칸 preview의 첫 이동이 항상 동일
- 즉시 180도 반전 금지

그 후 `RailSwitch`와 `RailGraph.next_cell()`을 구현한다.

## 필수 파일

```text
project.godot
game/main/main.tscn
game/main/main.gd
game/rail/rail_cell.gd
game/rail/rail_graph.gd
game/rail/rail_generator.gd
game/rail/rail_switch.gd
tests/test_case.gd
tests/run_tests.gd
tests/smoke/test_project_boot.gd
tests/rail/test_rail_generator.gd
tests/rail/test_switch_routing.gd
```

필요한 최소 보조 파일은 추가할 수 있지만, 아키텍처를 확대하지 않는다.

## 보호 범위

변경 금지 또는 승인 필요:

- `SX-DEC-001`~`SX-DEC-012`의 의미
- 15×10 맵 크기
- 전체 연결·막다른길 없음
- 2단계·3단계 이상 분기기
- LIFO 하역과 연료·부스터 규칙
- Google Sheets 구조
- Base v9.3 pin과 Adapter 계약
- 광고·과금·성장·PvP 등 제외 범위

## 구현 원칙

- 경로 판단은 충돌 물리가 아니라 격자 그래프가 책임진다.
- 프레임마다 전체 그래프 BFS를 실행하지 않는다.
- 생성과 라우팅은 seed로 재현 가능해야 한다.
- 테스트를 통과시키기 위한 hard-coded seed 예외를 만들지 않는다.
- safe fallback은 유효한 15×10 연결 맵이어야 한다.
- 현재 단계에서는 임시 벡터·디버그 렌더만 허용하며 최종 아트처럼 꾸미지 않는다.

## 검증

반드시 실제 출력과 함께 보고한다.

```bash
python tools/validate_project_contract.py
godot --headless --path . --script res://tests/run_tests.gd
git status --short
git diff --check
```

추가 확인:

- 100 seed 전체 통과 수
- 생성 실패 후 fallback 테스트 결과
- 2단계·3단계 상태 순환 결과
- preview와 실제 next cell 불일치 0건

## 커밋 경계

권장:

1. `test: add Godot project and headless harness`
2. `feat: generate connected rail graph`
3. `feat: add multi-state rail switches`

Task별 테스트가 통과하기 전에 다음 Task로 넘어가지 않는다.

## PR 완료 보고

PR 본문에 다음을 포함한다.

- Issue #4와 Decision ID
- 생성·수정 파일
- Red→Green 테스트 증거
- 실행 명령과 실제 결과
- 미검증 항목
- 다음 Issue #5를 막는 사항
- 적대적 검토: 가짜 분기, 비연결 맵, preview 불일치, 180도 반전, seed 비결정성

## 중단 조건

다음 중 하나가 발생하면 임의 해결하지 말고 finding과 선택지를 보고한다.

- Godot 4.7.1에서 계획 API가 성립하지 않음
- 15×10에서 요구한 연결성과 분기 수를 동시에 안정적으로 보장할 수 없음
- 현재 정본 사이에 서로 다른 코어 규칙 발견
- Base Adapter·Skill Registry 검사가 실패하고 원인이 이번 Goal 밖에 있음
- 기존 main에 사용자 미승인 제품 코드가 발견됨
