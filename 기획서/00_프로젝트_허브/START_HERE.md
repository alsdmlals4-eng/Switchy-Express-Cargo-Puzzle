# Switchy Express 프로젝트 허브

## 프로젝트 요약

| 항목 | 현재 값 |
|---|---|
| 제목 | **Switchy Express: Cargo Puzzle** |
| 장르 | 무한 생존 점수 경쟁형 철도 노선·화물 스택 퍼즐 |
| 플랫폼·엔진 | Android / Google Play · Godot 4.7.1 / GDScript |
| 현재 단계 | `VERTICAL_SLICE_IN_PROGRESS · VS02_RUNTIME_PASSED` |
| 제품 구현 | `RAIL_TRAIN_CARGO_LIFO_IMPLEMENTED` |
| GMB-001 | `CLOSED · SX-DEC-017~026 · 10/10` |
| Decision 정본 | PR #29 · `9b63421a5ab4d57adbfcf69d2b6e1bf8e3d17496` |
| DoR 감사 | `SX-AUD-005 · PASS_WITH_PLANNING_FIXES` |
| DoR 근거 | `EV-USER-016` |
| Sheet | `GMB-001 SYNCED · DoR CANONICAL_SYNC_PENDING` |
| 올바른 Sheet | `1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo` |
| 제품 코드 변경 | `0 · PLANNING_ONLY` |
| Codex | `READY_FOR_BUILD_PENDING_CANONICAL_SYNC` |
| 최초 허용 package | `VS03-01 · run lifecycle/economy/difficulty` |
| 기존 제품 증거 | Godot headless `9 cases · 6915 assertions · 0 failures` |

## 한 문장 플레이어 약속

> 필요한 화물을 작은 토큰형 화차로 역순 적재하고, 선로 분기기를 바꿔 알맞은 역에서 큰 하역 Combo를 만들며 연료가 다하기 전까지 최고 점수를 갱신한다.

## 현재 읽기 순서

```text
CURRENT_CONFIRMED_DECISIONS.md
→ GMB-001_CANONICAL_DECISIONS.md
→ ACTIVE_CONTEXT.md
→ ../../50_제작_검증/VS03_DEFINITION_OF_READY_AUDIT.md
→ ../../../docs/superpowers/specs/2026-08-02-vs03-execution-architecture-design.md
→ ../../../docs/superpowers/plans/2026-08-02-vs03-build-segmentation.md
→ ../../../docs/superpowers/plans/2026-08-02-switchy-express-current-vertical-slice.md
→ ../../50_제작_검증/VERTICAL_SLICE_CONTRACT.md
→ EXECUTABLE_PROMPTS/CODEX_GOAL_VS_03.md
```

## Gate 상태

- `G0_PROJECT_IDENTIFIED`: PASS
- `G1_CORE_CONFIRMED`: PASS
- `G2_VERTICAL_SLICE_CONTRACT_APPROVED`: PASS
- `G3_CORE_RUNTIME_PROVEN`: PARTIAL
- `G3P_TOTAL_PLANNING_AND_REVIEW_COMPLETE`: `PASS_PENDING_CANONICAL_SYNC`
- `G3B_GRILL_ME_BATCH_PREMERGE`: `GMB-001 CLOSED`
- `G4_TARGET_QUALITY_SLICE`: NOT_STARTED
- `G5_PLAYTEST_EVIDENCE`: NOT_STARTED
- `G6_OFFICIAL_CATALOG_PRODUCTION`: `NOT_STARTED · F58_NOT_MET`
- `G7_ONLINE_UGC_PRODUCTION`: NOT_STARTED

## DoR 적대적 보정

`SX-AUD-005`에서 다음 실행 충돌을 폐쇄했다.

- compact footprint와 기존 full-cell spawn occupancy 충돌
- 실제 custom test runner와 계획 예시 불일치
- 빈 Main/composition root와 monolithic controller 위험
- 공통 hotspot 파일의 다중 owner 충돌
- 불완전 RunSessionFactory와 map reconstruction 입력 누락
- movement/event/fuel-zero tie order 누락
- Profile multi-writer·중복 transaction 위험
- 잘못된/존재하지 않는 파일 경로
- target100 작업의 VS scope/test-watchdog 오염
- rollback·evidence 위치 분산

Known open P0/P1 implementation-planning finding after fixes: `0`.

## Canonical 구현 순서

```text
VS03-01 run lifecycle/economy/difficulty
→ VS03-02 compact footprint/DeliveryLoop seam
→ VS03-03 target3 maps/session/restart/selection
→ VS03-04 Profile transactions/records/cosmetics/unlocks/rewards
→ VS03-05 product scene/camera/HUD/result/browsers
→ VS03-06 contextual onboarding
→ VS03-07 integration/evidence handoff
```

첫 package만 최초 승격 대상이며, 공통 파일 package는 병렬 실행하지 않는다.

## 현재 작업

```text
DoR planning PR exact-head 검증
→ 올바른 Sheet SX-AUD-005 / EV-USER-016 pending 반영
→ canonical merge
→ Sheet merge SHA + 12-tab readback
→ Sync Closure
→ Codex READY_FOR_BUILD · VS03-01
```

## 보호 경계

- 제품 구현은 별도 Codex 실행이 시작되기 전까지 `NOT_STARTED`다.
- VS-03는 local core와 최소 3개 validated official maps만 목표로 한다.
- target100 completion과 online UGC는 Production 후속 Gate다.
- `F58`은 target100 증거 전 `NOT_MET`다.
- runtime·Android·human·online 검증을 실행하지 않고 PASS로 표시하지 않는다.
