# Codex Goal — VS-01 Godot 기반·RailGraph·다단계 분기기

Status: `COMPLETED`
GitHub Issue: `#4` — CLOSED
Pull Request: `#9` — MERGED
Implementation Commit: `801632949d28564528e38d83dac59cccc6f06fb2`
Verification: `Project Contract PASS · Godot headless 934 assertions PASS`
Next Goal: `CODEX_GOAL_VS_02.md`

> 이 실행문은 완료 이력이다. 새 Branch에서 다시 실행하지 않는다. 현재 작업은 `ACTIVE_CONTEXT.md`와 `CODEX_GOAL_VS_02.md`를 따른다.

Parent Epic: `#3`
Plan: `docs/superpowers/plans/2026-08-01-switchy-express-vertical-slice.md`

## 완료 결과

1. Godot 4.7.1 프로젝트와 헤드리스 테스트 러너
2. 결정론적인 15×10 전체 연결 철도 그래프
3. 2단계·3단계 분기기 상태·라우팅·5칸 미리보기
4. 직진 가능 시 기본 A노선 직진 우선
5. Godot Script Error CI false-green 방지

## 실제 구현 파일

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
.github/workflows/godot-tests.yml
```

## 검증 결과

- 크기 15×10
- seeds 1~100 전체 연결
- degree-1 막다른길 0
- cycle rank 최소 3
- 2단계 분기 최소 4개
- 3단계 분기 최소 2개
- 분기 후 최소 3칸 이상 경로 차이
- 같은 seed 결과 동일
- 32회 생성 실패 시 결정론적 safe fallback
- 2단계 `A → B → A`
- 3단계 `A → B → C → A`
- 직진 우선 기본 A노선
- 통과 뒤 기본 상태 복귀
- preview 첫 이동과 실제 next cell 일치
- 즉시 180도 반전 금지

## 구현 중 해결한 Finding

- Godot `Object.is_connected(signal, callable)`와 무인자 프로젝트 API 충돌로 `RailGraph.is_fully_connected()`를 사용한다.
- Godot 런타임 Script Error가 종료 코드 0이어도 CI가 실패하도록 로그를 검사한다.
- 좌표 정렬에 의존하던 기본 노선을 직진 우선으로 변경했다.
- 테스트 러너에 watchdog과 CI shell timeout을 적용했다.

## 미구현 범위

- 기차·화차
- 화물 적재·생성
- 스테이션·LIFO 하역
- 연료·점수·속도·BOOST
- 제품 HUD·최종 아트
- Android export·성능·플레이테스트

## 후속

- Issue #5
- `기획서/00_프로젝트_허브/EXECUTABLE_PROMPTS/CODEX_GOAL_VS_02.md`
- `기획서/50_제작_검증/POST_VS01_ADVERSARIAL_AUDIT.md`
