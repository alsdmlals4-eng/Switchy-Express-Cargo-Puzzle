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
| 코어 상태 | `CORE_CONFIRMED · SX-DEC-014/015_SYNCED · SX-DEC-016_CANON_IN_PROGRESS` |
| 제품 구현 | `RAIL_TRAIN_CARGO_LIFO_IMPLEMENTED` |
| 현재 Gate | `G2 PASS · G3 PARTIAL · G3P IN_PROGRESS` |
| 최근 제품 구현 | PR #13 · `4e435a1a6d10ab146197671049da80709fd18c1f` |
| 최근 synchronized planning main | PR #25 · `867563bb7bb69cfbb7343ef734585dd034ad7a64` |
| 테스트 기준 | Godot headless `9 cases · 6915 assertions · 0 failures` |
| Sheet | `SX-DEC-014/015 · 12탭 readback PASS · SYNCED`; `SX-DEC-016` canonical merge 대기 |
| 현재 Work Mode | `TOTAL_PLANNING · REVIEW` |
| Codex | `CODEX_NOT_READY` |
| 현행 감사 | `SX-AUD-004 · TOTAL_PLANNING_AUDIT.md` |
| 현재 승인 | `SX-DEC-016 상황형 첫 run 온보딩 · SX-OPS-001 10건 배치 병합` |
| 다음 정규 Batch | `GMB-001 · SX-DEC-017부터 0/10` |
| Sheet ID | Adapter의 `1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo` |
| Base | v9.4.0 (`a728712cb776ec98f4875914a580fcf7d0156593`) |

## 한 문장 플레이어 약속

> 필요한 화물을 작은 토큰형 화차로 역순 적재하고, 선로 분기기를 바꿔 알맞은 역에서 큰 하역 Combo를 만들며 연료가 다하기 전까지 최고 점수를 갱신한다.

## 핵심 정의

> `Combo`는 한 번의 역 도착에서 stack top부터 연속 하역한 동일 화물 타입의 개수이며, 빠른 연속 배송은 별도 `speed_bonus`다.

> 화물 1개는 작은 토큰형 화차 1개로 표시한다. 최대 8개 token chain은 권장 시험값 2.18칸으로 압축하며 가장 뒤 token이 다음 LIFO 하역 대상이다.

> 첫 세션은 별도 튜토리얼 맵이 아니라 실제 첫 무한 run에서 `LOAD → token → 분기 → LIFO → Combo → BOOST` 순서로 학습한다.

## 현재 읽기 순서

```text
CURRENT_CONFIRMED_DECISIONS.md
→ ACTIVE_CONTEXT.md
→ ../../50_제작_검증/TOTAL_PLANNING_AUDIT.md
→ ../../../docs/superpowers/specs/2026-08-02-compact-cargo-wagon-tokens-design.md
→ ../../../docs/superpowers/specs/2026-08-02-first-session-contextual-onboarding-design.md
→ ../../50_제작_검증/GRILL_ME_BATCH_MERGE_PROTOCOL.md
→ ../../10_경험/CORE_GAMEPLAY.md
→ ../../20_시스템_콘텐츠/CORE_SYSTEMS.md
→ ../../40_표현/VISUAL_DIRECTION.md
→ ../../50_제작_검증/VERTICAL_SLICE_CONTRACT.md
→ ../../50_제작_검증/PLAYTEST_PLAN.md
→ ../../../docs/superpowers/plans/2026-08-01-switchy-express-vertical-slice.md
→ ../../../docs/superpowers/plans/2026-08-02-first-session-contextual-onboarding.md
→ EXECUTABLE_PROMPTS/CODEX_GOAL_VS_03.md
```

Post-VS02 구현·정본 복구의 역사 감사는 `POST_VS02_ADVERSARIAL_AUDIT.md`에서 확인한다.

## 현재 Gate

- `G0_PROJECT_IDENTIFIED`: PASS
- `G1_CORE_CONFIRMED`: PASS
- `G2_VERTICAL_SLICE_CONTRACT_APPROVED`: PASS
- `G3_CORE_RUNTIME_PROVEN`: PARTIAL
  - Godot 기반·RailGraph·2/3단계 분기: PASSED
  - 기관차 이동·LOAD·화물·역·LIFO: PASSED
  - 기존 full-cell wagon position foundation: PASSED · compact token adaptation pending
  - 런타임 최소 화물 재생성: PASSED
  - 연료·속도·점수·BOOST·게임오버·기록: NOT_STARTED
  - 상황형 첫 run 온보딩: PLANNING_SPEC_APPROVED · IMPLEMENTATION_NOT_STARTED
- `G3P_TOTAL_PLANNING_AND_REVIEW_COMPLETE`: IN_PROGRESS
  - Post-VS02 GitHub·Sheet 동기화: PASSED
  - Combo: `SX-DEC-014 SYNCED`
  - compact wagon token: `SX-DEC-015 SYNCED`
  - 상황형 첫 run 온보딩: `SX-DEC-016 CANON_IN_PROGRESS`
  - 10건 배치 운영: `SX-OPS-001 APPROVED`
  - 후속 Decision·Definition of Ready: 진행 중
- `G4_TARGET_QUALITY_SLICE`: NOT_STARTED
- `G5_PLAYTEST_EVIDENCE`: NOT_STARTED

## 현재 작업

1. `SX-DEC-016`·`SX-OPS-001` 소비자를 정본·Issue #6·Plan·VS-03 Goal에 반영
2. canonical PR 병합 직전 main·PR·Sheet 12탭을 다시 전수 대조
3. 적대적 Finding P0/P1 0, exact-head checks 성공, review thread 0에서만 병합
4. canonical merge commit을 Sheet에 기록하고 12탭 readback PASS
5. Sync Closure PR을 검증·병합한 뒤 `GMB-001`을 0/10으로 시작

## 다음 구현 후보

Issue #6 / VS-03을 순차 패키지로 준비한다.

```text
VS-03A · 생존 경제 도메인
→ VS-03B · compact token 플레이 화면·HUD·결과·기록·재시작
→ SX-DEC-016 구현 package · OnboardingState·first-run assist·overlay·Help
→ Issue #7 · 텔레메트리·soak·Android·플레이테스트·최종 적대 검토
```

현재 실행문 `CODEX_GOAL_VS_03.md`는 `PLANNING_DRAFT · CODEX_NOT_READY`이며 총기획·Grill Me batch Gate 전에는 구현에 사용하지 않는다.
