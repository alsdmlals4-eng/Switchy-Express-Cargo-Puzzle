# Switchy Express 프로젝트 허브

## 프로젝트 요약

| 항목 | 현재 값 |
|---|---|
| 제목 | **Switchy Express: Cargo Puzzle** |
| 장르 | 무한 생존 점수 경쟁형 철도 노선·화물 스택 퍼즐 |
| 플랫폼 | Android / Google Play |
| 엔진 | Godot 4.7.1 / GDScript |
| 화면 | 가로형 |
| 현재 단계 | `VERTICAL_SLICE_IN_PROGRESS · VS02_RUNTIME_PASSED` |
| 코어 상태 | `CORE_CONFIRMED · SX-DEC-014_CONFIRMED` |
| 제품 구현 | `RAIL_TRAIN_CARGO_LIFO_IMPLEMENTED` |
| 현재 Gate | `G2 PASS · G3 PARTIAL · G3P IN_PROGRESS` |
| 최근 제품 구현 | PR #13 · `4e435a1a6d10ab146197671049da80709fd18c1f` |
| 최근 Sheet 종료 | PR #17 · `474bef445c2cf5e501bd7478e26a5b8d0dfe26f1` |
| 테스트 | Godot headless `9 cases · 6915 assertions · 0 failures` |
| 현재 Work Mode | `TOTAL_PLANNING · REVIEW` |
| Codex | `CODEX_NOT_READY` |
| 현행 감사 | `SX-AUD-004 · TOTAL_PLANNING_AUDIT.md` |
| 현재 Decision | `SX-DEC-014 Combo 확정 · Sheet 동기화 대기` |
| 다음 Grill Me | `SX-DEC-015 화물–화차 관계` |
| Sheet | Adapter의 `1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo` |
| Base | v9.4.0 (`a728712cb776ec98f4875914a580fcf7d0156593`) |

## 한 문장 플레이어 약속

> 필요한 화물을 선택해 열차에 역순으로 쌓고, 선로 분기기를 바꿔 알맞은 역에서 큰 하역 Combo를 만들며 연료가 다하기 전까지 최고 점수를 갱신한다.

## Combo 한 문장 정의

> `Combo`는 한 번의 역 도착에서 stack top부터 연속 하역한 동일 화물 타입의 개수이며, 빠른 연속 배송은 별도 `speed_bonus`다.

## 현재 읽기 순서

```text
CURRENT_CONFIRMED_DECISIONS.md
→ ACTIVE_CONTEXT.md
→ ../../50_제작_검증/TOTAL_PLANNING_AUDIT.md
→ ../../10_경험/CORE_GAMEPLAY.md
→ ../../20_시스템_콘텐츠/CORE_SYSTEMS.md
→ ../../40_표현/VISUAL_DIRECTION.md
→ ../../50_제작_검증/VERTICAL_SLICE_CONTRACT.md
→ ../../50_제작_검증/PLAYTEST_PLAN.md
→ ../../../docs/superpowers/plans/2026-08-01-switchy-express-vertical-slice.md
→ EXECUTABLE_PROMPTS/CODEX_GOAL_VS_03.md
```

Post-VS02 구현·정본 복구의 역사 감사는 `POST_VS02_ADVERSARIAL_AUDIT.md`에서 확인한다.

## 현재 Gate

- `G0_PROJECT_IDENTIFIED`: PASS
- `G1_CORE_CONFIRMED`: PASS
- `G2_VERTICAL_SLICE_CONTRACT_APPROVED`: PASS
- `G3_CORE_RUNTIME_PROVEN`: PARTIAL
  - Godot 기반·RailGraph·2/3단계 분기: PASSED
  - 기관차·최대 8개 화차·LOAD·화물·역·LIFO: PASSED
  - 런타임 최소 화물 재생성: PASSED
  - 연료·속도·점수·BOOST·게임오버·기록: NOT_STARTED
- `G3P_TOTAL_PLANNING_AND_REVIEW_COMPLETE`: IN_PROGRESS
  - Post-VS02 GitHub·Sheet 동기화: PASSED
  - Combo 의미: `SX-DEC-014 CONFIRMED`
  - 화물–화차 관계: `SX-DEC-015 USER_DECISION_REQUIRED`
  - 전체 기획 Coverage·후속 Grill Me: 진행 중
- `G4_TARGET_QUALITY_SLICE`: NOT_STARTED
- `G5_PLAYTEST_EVIDENCE`: NOT_STARTED

## 현재 작업

1. `SX-DEC-014`를 PR 병합 commit으로 확정
2. 같은 Decision·Evidence·Audit ID를 Google Sheets에 기록·재조회
3. `SX-DEC-015` 화물–화차 관계를 Grill Me로 확정
4. 검증된 `SAFE_PLANNING_FIXES` 즉시 반영
5. 상세 수치는 `RECOMMENDED_DEFAULT / TEST_VALUE`로 설계
6. 전체 기획 Gate가 닫힌 뒤 VS-03 Codex 구현 계약 확정

## 다음 구현 후보

Issue #6 / VS-03을 두 개의 순차 패키지로 준비한다.

```text
VS-03A · 생존 경제 도메인
→ VS-03B · 플레이 화면·HUD·결과·기록·재시작
→ Issue #7 · 텔레메트리·soak·Android·플레이테스트·최종 적대 검토
```

현재 실행문 `CODEX_GOAL_VS_03.md`는 `PLANNING_DRAFT · CODEX_NOT_READY`이며 총기획·Grill Me Gate 전에는 구현에 사용하지 않는다.
