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
| 코어 상태 | `CORE_CONFIRMED · SX-DEC-014/015/016_SYNCED` |
| 제품 구현 | `RAIL_TRAIN_CARGO_LIFO_IMPLEMENTED` |
| 현재 Gate | `G2 PASS · G3 PARTIAL · G3P IN_PROGRESS` |
| 최근 제품 구현 | PR #13 · `4e435a1a6d10ab146197671049da80709fd18c1f` |
| 최신 synchronized planning main | PR #27 · `3cd13ff375a597d4eba9035af5b05e6186fb4853` |
| 테스트 기준 | Godot headless `9 cases · 6915 assertions · 0 failures` |
| Sheet | `SX-DEC-014/015/016 · SX-OPS-001 · PASS · 12탭 재조회 완료 · SYNCED` |
| 현재 Work Mode | `TOTAL_PLANNING · REVIEW` |
| Codex | `CODEX_NOT_READY` |
| 현행 감사 | `SX-AUD-004 · TOTAL_PLANNING_AUDIT.md` |
| 현재 Batch | `GMB-001 · SX-DEC-017부터 0/10` |
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
→ ../../../docs/superpowers/plans/2026-08-02-switchy-express-current-vertical-slice.md
→ ../../50_제작_검증/GRILL_ME_BATCH_MERGE_PROTOCOL.md
→ ../../../docs/superpowers/specs/2026-08-02-compact-cargo-wagon-tokens-design.md
→ ../../../docs/superpowers/specs/2026-08-02-first-session-contextual-onboarding-design.md
→ ../../10_경험/CORE_GAMEPLAY.md
→ ../../20_시스템_콘텐츠/CORE_SYSTEMS.md
→ ../../40_표현/VISUAL_DIRECTION.md
→ ../../50_제작_검증/VERTICAL_SLICE_CONTRACT.md
→ ../../50_제작_검증/PLAYTEST_PLAN.md
→ ../../../docs/superpowers/plans/2026-08-02-first-session-contextual-onboarding.md
→ EXECUTABLE_PROMPTS/CODEX_GOAL_VS_03.md
```

`docs/superpowers/plans/2026-08-01-switchy-express-vertical-slice.md`는 VS-01·VS-02 상세 실행 이력을 보존하는 `HISTORICAL_FOUNDATION`이다. 그 안의 구형 planning status보다 2026-08-02 Current Plan을 우선한다.

## 현재 Gate

- `G0_PROJECT_IDENTIFIED`: PASS
- `G1_CORE_CONFIRMED`: PASS
- `G2_VERTICAL_SLICE_CONTRACT_APPROVED`: PASS
- `G3_CORE_RUNTIME_PROVEN`: PARTIAL
  - RailGraph·분기·기관차·LOAD·화물·역·LIFO·런타임 재생성: PASSED
  - compact token runtime·경제·제품 UI·결과·기록·상황형 온보딩: NOT_STARTED
- `G3P_TOTAL_PLANNING_AND_REVIEW_COMPLETE`: IN_PROGRESS
  - `SX-DEC-014/015/016`, `SX-OPS-001`: GitHub·Sheet SYNCED
  - `GMB-001`: 0/10
  - 후속 Decision·Definition of Ready: 진행 중
- `G3B_GRILL_ME_BATCH_PREMERGE`: GMB-001_NOT_STARTED
- `G4_TARGET_QUALITY_SLICE`: NOT_STARTED
- `G5_PLAYTEST_EVIDENCE`: NOT_STARTED

## 현재 작업

1. `GMB-001` slot 1인 `SX-DEC-017` 결과 화면 실패 학습 Decision을 한 건만 Grill Me한다.
2. 승인 시 batch branch·draft PR·Sheet에 `APPROVED_PENDING_BATCH_MERGE`로 기록한다.
3. 10번째 승인에서 새 질문을 중단하고 GitHub·PR·Sheet 12탭 전수 감사 후 병합한다.
4. canonical merge·Sheet readback·Sync Closure PR까지 완료해야 GMB-001을 닫는다.

## 다음 구현 후보

```text
VS-03A · 생존 경제 도메인
→ VS-03B · compact token 플레이 화면·HUD·결과·기록·재시작
→ VS-03C · OnboardingState·first-run assist·overlay·Help
→ Issue #7 · 텔레메트리·soak·Android·플레이테스트·최종 적대 검토
```

현재 실행문 `CODEX_GOAL_VS_03.md`는 `PLANNING_DRAFT · CODEX_NOT_READY`이며 GMB-001과 남은 총기획 Gate 전에는 구현에 사용하지 않는다.
