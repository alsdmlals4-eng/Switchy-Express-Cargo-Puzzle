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
| 제품 구현 | `RAIL_TRAIN_CARGO_LIFO_IMPLEMENTED` |
| 현재 Work Mode | `TOTAL_PLANNING · REVIEW` |
| 현재 Batch | `GMB-001 · SX-DEC-017~026 · 10/10 · FROZEN` |
| 현재 감사 | `GMB-001_PREMERGE_AUDIT · IN_PROGRESS` |
| 제품 코드 변경 | `0 · PLANNING_ONLY` |
| Codex | `CODEX_NOT_READY` |
| 올바른 Sheet | `1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo` |
| Sheet 상태 | `10/10 · FROZEN_PENDING_BATCH_AUDIT · 12탭 readback PASS` |
| 제품 baseline | `4e435a1a6d10ab146197671049da80709fd18c1f` |
| Batch baseline main | `993c3ed1aaee172be52a8a8899685b419f7f6d97` |
| 기존 테스트 증거 | Godot headless `9 cases · 6915 assertions · 0 failures` |

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

상세 Decision별 spec·TDD plan은 `GMB-001_CANONICAL_DECISIONS.md`에서 연결한다.

## 현재 Gate

- `G0_PROJECT_IDENTIFIED`: PASS
- `G1_CORE_CONFIRMED`: PASS
- `G2_VERTICAL_SLICE_CONTRACT_APPROVED`: PASS
- `G3_CORE_RUNTIME_PROVEN`: PARTIAL
- `G3P_TOTAL_PLANNING_AND_REVIEW_COMPLETE`: `GMB-001_CANON_REPAIR_IN_PROGRESS`
- `G3B_GRILL_ME_BATCH_PREMERGE`: `GMB-001 · 10/10 · FROZEN · AUDIT_IN_PROGRESS`
- `G4_TARGET_QUALITY_SLICE`: NOT_STARTED
- `G5_PLAYTEST_EVIDENCE`: NOT_STARTED
- `G6_ONLINE_UGC_PRODUCTION`: NOT_STARTED

## GMB-001 결정 요약

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

## 단계 분리

### VS-03 로컬 구현 후보

- 생존 경제·compact tokens·Combo·HUD·온보딩
- 결과 insight·기록·same-map restart
- PREP camera·difficulty communication
- local cosmetic unlock/reward representative flow
- 최소 3개 검증 official maps와 발견/재선택
- official global+per-map local records

### Production/온라인 후속

- 100+ unique official maps
- full UGC editor·publication backend
- server validation·moderation·privacy
- two-account sharing
- UGC records·community signal event journal·anti-abuse

온라인 후속을 VS-03 즉시 구현 의무로 해석하지 않는다. 반대로 local mock만으로 온라인 준비 완료를 주장하지 않는다.

## 현재 작업

```text
10/10 Sheet frozen readback PASS
→ GitHub current consumer 전파
→ final exact-head CI·inventory·review audit
→ PR #29 canonical merge
→ Sheet canonical merge SHA·12-tab readback
→ Sync Closure PR
```

## 다음 구현 후보

```text
VS-03A · 생존 경제 도메인
→ VS-03B · compact token 제품 화면·result·records·same-map restart
→ VS-03C · contextual onboarding
→ VS-03D · 최소 3 official maps·selection/difficulty/local progression 통합
→ VS-04 · telemetry·Android·playtest·adversarial validation
→ Production · 100+ official maps·online UGC
```

`CODEX_GOAL_VS_03.md`는 여전히 `PLANNING_DRAFT · CODEX_NOT_READY`다. GMB-001 canonical merge와 Sync Closure만으로 자동 승격하지 않는다.
