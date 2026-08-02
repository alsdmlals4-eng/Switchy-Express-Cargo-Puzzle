# Switchy Express 프로젝트 허브

## 프로젝트 요약

| 항목 | 현재 값 |
|---|---|
| 제목 | **Switchy Express: Cargo Puzzle** |
| 장르 | 무한 생존 점수 경쟁형 철도 노선·화물 스택 퍼즐 |
| 플랫폼·엔진 | Android / Google Play · Godot 4.7.1 / GDScript |
| 현재 단계 | `VERTICAL_SLICE_IN_PROGRESS · VS03_01_HEADLESS_PASSED` |
| 구현 기반 | `RAIL_TRAIN_CARGO_LIFO + VS03_01_RUN_CORE_IMPLEMENTED` |
| GMB-001 | `CLOSED · SX-DEC-017~026 · 10/10` |
| Decision 정본 | PR #29 · `9b63421a5ab4d57adbfcf69d2b6e1bf8e3d17496` |
| DoR 감사 | `SX-AUD-005 · PASS · SYNCED` |
| DoR 정본 | PR #35 · `82fd3eeb1915e6ceedb2f5330b27e903064d6eb5` |
| VS03-01 감사 | `SX-AUD-006 · EV-VS03-01-001 · PASS` |
| VS03-01 구현 | PR #37 · `43972d3d23e931af3dbc81ab9b1c7d942fffb201` |
| 올바른 Sheet | `1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo` |
| 현재 Codex 권위 | `READY_FOR_BUILD · VS03-02_ONLY` |
| 다음 package | `VS03-02 · compact footprint / DeliveryLoop occupancy seam` |
| 자동 검증 | Godot headless `16 cases · 7110 assertions · 0 failures` |
| 제품 Scene·Android·사람 증거 | `NOT_RUN` |

## 한 문장 플레이어 약속

> 필요한 화물을 작은 토큰형 화차로 역순 적재하고, 선로 분기기를 바꿔 알맞은 역에서 큰 하역 Combo를 만들며 연료가 다하기 전까지 최고 점수를 갱신한다.

## 현재 읽기 순서

```text
CURRENT_CONFIRMED_DECISIONS.md
→ GMB-001_CANONICAL_DECISIONS.md
→ ACTIVE_CONTEXT.md
→ ../../50_제작_검증/VS03_PACKAGE_STATUS.md
→ ../../50_제작_검증/VS03_01_IMPLEMENTATION_AUDIT.md
→ ../../50_제작_검증/VS03_DEFINITION_OF_READY_AUDIT.md
→ ../../../docs/superpowers/specs/2026-08-02-vs03-execution-architecture-design.md
→ ../../../docs/superpowers/plans/2026-08-02-vs03-build-segmentation.md
→ ../../../docs/superpowers/plans/2026-08-02-switchy-express-current-vertical-slice.md
→ ../../50_제작_검증/VERTICAL_SLICE_CONTRACT.md
→ EXECUTABLE_PROMPTS/CODEX_GOAL_VS_03.md
```

`VS03_PACKAGE_STATUS.md`가 package의 현재 상태를 소유한다. 상세 계획의 오래된 `Status:` 표기와 충돌하면 상태 레지스트리를 우선하고, 목표·파일 소유권·수용 기준은 상세 계획을 유지한다.

## Gate 상태

- `G0_PROJECT_IDENTIFIED`: PASS
- `G1_CORE_CONFIRMED`: PASS
- `G2_VERTICAL_SLICE_CONTRACT_APPROVED`: PASS
- `G3_CORE_RUNTIME_PROVEN`: `PARTIAL · VS03_01_HEADLESS_PASSED`
- `G3P_TOTAL_PLANNING_AND_REVIEW_COMPLETE`: PASS
- `G3B_GRILL_ME_BATCH_PREMERGE`: `GMB-001 CLOSED`
- `G3I_VS03_IMPLEMENTATION`: `VS03-01 MERGED_AND_VERIFIED · VS03-02 READY_FOR_BUILD`
- `G4_TARGET_QUALITY_SLICE`: NOT_STARTED
- `G5_PLAYTEST_EVIDENCE`: NOT_STARTED
- `G6_OFFICIAL_CATALOG_PRODUCTION`: `NOT_STARTED · F58_NOT_MET`
- `G7_ONLINE_UGC_PRODUCTION`: NOT_STARTED

## VS03-01 완료 내용

- 시간 기반 속도·연료 압력
- 화물 수 기반 이동 감속과 연료 소모 분리
- BOOST 속도 증가·추가 연료 비용·LOAD 배제
- unload-group Combo·점수·연료 보상
- fuel-zero 1회 종료·immutable summary·종료 후 mutation 차단
- deterministic difficulty forecast/commit/band
- event/run-clock/difficulty/fuel-zero 권위 순서
- TrainController next-boundary·history·fractional path read seam
- 실제 DeliveryLoop·CargoStack·Station 결합 테스트

Exact-head 증거:

```text
af2577eeb8a1c4891a2ca322aa70c4066335cd0e
Project Contract 227 PASS
Godot Tests 214 PASS
16 cases · 7110 assertions · 0 failures
behind 0 · thread 0 · REQUEST_CHANGES 0 · P0/P1 0
```

## Canonical 구현 순서

```text
VS03-01 run lifecycle/economy/difficulty · DONE
→ VS03-02 compact footprint/DeliveryLoop seam · READY
→ VS03-03 target3 maps/session/restart/selection · BLOCKED
→ VS03-04 Profile transactions/records/cosmetics/unlocks/rewards · BLOCKED
→ VS03-05 product scene/camera/HUD/result/browsers · BLOCKED
→ VS03-06 contextual onboarding · BLOCKED
→ VS03-07 integration/evidence handoff · BLOCKED
```

공통 hotspot package는 병렬 실행하지 않는다. 각 package는 이전 package가 병합·정본 동기화된 최신 main에서 시작한다.

## 현재 작업

```text
VS03-01 merge 43972d3d...
→ GitHub/Sheet Sync Closure
→ VS03-02 별도 branch
→ compact token·TrainFootprint·occupancy provider TDD
→ exact-head package Gate
```

## 보호 경계

- headless PASS는 product Scene runtime·Android·사람 검증 완료가 아니다.
- VS03-02는 compact token·compressed footprint·DeliveryLoop occupancy seam만 다룬다.
- map/session/restart는 VS03-03 전까지 시작하지 않는다.
- Profile/save는 VS03-04 전까지 시작하지 않는다.
- target100과 online UGC는 Production 후속 Gate다.
- `F58`은 target100 증거 전 `NOT_MET`다.
- runtime·Android·human·online 검증을 실행하지 않고 PASS로 표시하지 않는다.
