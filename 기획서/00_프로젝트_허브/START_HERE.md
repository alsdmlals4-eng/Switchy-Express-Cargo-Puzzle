# Switchy Express 프로젝트 허브

## 프로젝트 요약

| 항목 | 현재 값 |
|---|---|
| 제목 | **Switchy Express: Cargo Puzzle** |
| 장르 | 무한 생존 점수 경쟁형 철도 노선·화물 스택 퍼즐 |
| 플랫폼·엔진 | Android / Google Play · Godot 4.7.1 / GDScript |
| 화면 | 가로형 |
| 현재 단계 | `VERTICAL_SLICE_IN_PROGRESS · VS02_RUNTIME_PASSED` |
| 제품 구현 | `RAIL_TRAIN_CARGO_LIFO_IMPLEMENTED` |
| 현재 Work Mode | `TOTAL_PLANNING · REVIEW` |
| GMB-001 | `CLOSED · SX-DEC-017~026 · 10/10` |
| Decision 정본 | PR #29 · `9b63421a5ab4d57adbfcf69d2b6e1bf8e3d17496` |
| Sheet | `SYNCED · 12탭 readback PASS` |
| 올바른 Sheet | `1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo` |
| 제품 코드 변경 | `0 · PLANNING_ONLY` |
| Codex | `CODEX_NOT_READY` |
| 다음 Gate | `G3P Definition of Ready 재검토` |
| 기존 제품 증거 | Godot headless `9 cases · 6915 assertions · 0 failures` |

## 한 문장 플레이어 약속

> 필요한 화물을 작은 토큰형 화차로 역순 적재하고, 선로 분기기를 바꿔 알맞은 역에서 큰 하역 Combo를 만들며 연료가 다하기 전까지 최고 점수를 갱신한다.

## 현재 읽기 순서

```text
CURRENT_CONFIRMED_DECISIONS.md
→ GMB-001_CANONICAL_DECISIONS.md
→ ACTIVE_CONTEXT.md
→ ../../50_제작_검증/GMB-001_PREMERGE_AUDIT.md
→ ../../50_제작_검증/TOTAL_PLANNING_AUDIT.md
→ ../../../docs/superpowers/plans/2026-08-02-switchy-express-current-vertical-slice.md
→ ../../50_제작_검증/VERTICAL_SLICE_CONTRACT.md
→ ../../50_제작_검증/GRILL_ME_BATCH_MERGE_PROTOCOL.md
→ EXECUTABLE_PROMPTS/CODEX_GOAL_VS_03.md
```

## Gate 상태

- `G0_PROJECT_IDENTIFIED`: PASS
- `G1_CORE_CONFIRMED`: PASS
- `G2_VERTICAL_SLICE_CONTRACT_APPROVED`: PASS
- `G3_CORE_RUNTIME_PROVEN`: PARTIAL
- `G3P_TOTAL_PLANNING_AND_REVIEW_COMPLETE`: `DEFINITION_OF_READY_REVIEW_REQUIRED`
- `G3B_GRILL_ME_BATCH_PREMERGE`: `GMB-001 CLOSED`
- `G4_TARGET_QUALITY_SLICE`: NOT_STARTED
- `G5_PLAYTEST_EVIDENCE`: NOT_STARTED
- `G6_OFFICIAL_CATALOG_PRODUCTION`: `NOT_STARTED · F58_NOT_MET`
- `G7_ONLINE_UGC_PRODUCTION`: NOT_STARTED

## GMB-001 정본 결정

```text
017 result learning
018 PREP camera/full-map gate
019 standard records + cosmetic-only progression
020 goal-or-currency unlock modes
021 bounded cosmetic-currency rewards
022 difficulty prewarning/persistent signal
023 same-map restart + official map catalog
024 undiscovered-first official map selection
025 official global/per-map records + data-only user maps
026 non-economic UGC community signals
```

상세 계약과 VS/Production 단계 분리는 `GMB-001_CANONICAL_DECISIONS.md`를 따른다.

## 현재 작업

```text
GMB-001 CLOSED
→ G3P Definition of Ready 적대적 재검토
→ existing API/file collision·dependency·rollback·save migration 확인
→ 명시적 READY_FOR_BUILD 승인
→ VS-03A/B/C/D 구현
```

GMB-001 종료는 자동 구현 승인이 아니다. `CODEX_GOAL_VS_03.md`는 계속 `PLANNING_DRAFT · CODEX_NOT_READY`다.

## 보호 경계

- VS-03는 로컬 코어와 최소 3개 검증 official maps를 목표로 한다.
- 공식 100+ 맵 완성과 온라인 UGC editor/backend/moderation/community는 Production 후속 Gate다.
- local mock은 online readiness 증거가 아니다.
- runtime·Android·human·online 검증을 실행하지 않고 PASS로 표시하지 않는다.
- 다음 Decision 또는 다음 batch는 별도 사용자 작업으로 시작한다.
