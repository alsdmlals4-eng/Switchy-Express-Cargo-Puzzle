# Switchy Express 프로젝트 허브

## 프로젝트 요약

| 항목 | 현재 값 |
|---|---|
| 제목 | **Switchy Express: Cargo Puzzle** |
| 장르 | 무한 생존 점수 경쟁형 철도 노선·화물 스택 퍼즐 |
| 플랫폼 | Android / Google Play |
| 엔진 | Godot 4.7.1 / GDScript |
| 화면 | 가로형 |
| 현재 단계 | VERTICAL_SLICE_IN_PROGRESS |
| 코어 상태 | CORE_CONFIRMED |
| 제품 구현 | DELIVERY_SUBLOOP_IMPLEMENTED |
| 현재 Gate | G2 PASS · G3 PARTIAL |
| Rail foundation | PR #9 · `801632949d28564528e38d83dac59cccc6f06fb2` |
| VS-02 구현 | PR #12 · `0738d9c10e431a43e7a2f34590369c3f17d1f8a5` |
| runtime 보완 | PR #13 · `4e435a1a6d10ab146197671049da80709fd18c1f` |
| 테스트 | Godot headless 9 cases · 6915 assertions · 0 failures |
| POC | HTML 규칙 검증 완료, 제품 증거 아님 |
| Sheet | `https://docs.google.com/spreadsheets/d/1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo/edit` |
| Base | v9.3.0 (`30ca6c7b5f93521f0eb0eed42d01437cd43c50ae`) |

## 한 문장 플레이어 약속

> 필요한 화물을 선택해 열차에 역순으로 쌓고, 선로 분기기를 바꿔 알맞은 역에서 콤보 하역하며 연료가 다하기 전까지 최고 점수를 갱신한다.

## 현재 읽기 순서

```text
CURRENT_CONFIRMED_DECISIONS.md
→ ACTIVE_CONTEXT.md
→ ../../50_제작_검증/POST_VS02_ADVERSARIAL_AUDIT.md
→ ../../10_경험/CORE_GAMEPLAY.md
→ ../../20_시스템_콘텐츠/CORE_SYSTEMS.md
→ ../../40_표현/VISUAL_DIRECTION.md
→ ../../50_제작_검증/VERTICAL_SLICE_CONTRACT.md
→ EXECUTABLE_PROMPTS/CODEX_GOAL_VS_03.md
→ ../../../docs/superpowers/plans/2026-08-01-switchy-express-vertical-slice.md
```

## 현재 Gate

- `G0_PROJECT_IDENTIFIED`: PASS
- `G1_CORE_CONFIRMED`: PASS
- `G2_VERTICAL_SLICE_CONTRACT_APPROVED`: PASS
- `G3_CORE_RUNTIME_PROVEN`: PARTIAL
  - Godot 기반·RailGraph·2/3단계 분기: PASSED
  - 기관차·최대 8개 화차·화물·역·LIFO 배송 하위 루프: PASSED
  - 속도 곡선·화물 감속·연료·점수·BOOST 효과·게임오버: NOT_STARTED
- `G4_TARGET_QUALITY_SLICE`: NOT_STARTED

## 다음 작업

1. Issue #6 / VS-03: RunBalance 속도·화물 감속·연료·BOOST 공식
2. 배송 이벤트를 점수·연료·combo로 연결
3. 연료 0 게임오버·입력 정지·결과 요약
4. 재시작·로컬 최고 기록
5. 기능적 1920×1080 가로형 gameplay scene·HUD
6. 무입력 180초·10분 soak 검증
7. Issue #7: 목표 시각 품질·Android·접근성·플레이테스트

현재 실행문:

`기획서/00_프로젝트_허브/EXECUTABLE_PROMPTS/CODEX_GOAL_VS_03.md`
