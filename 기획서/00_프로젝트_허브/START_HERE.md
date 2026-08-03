# Switchy Express 프로젝트 허브

## 프로젝트 요약

| 항목 | 현재 값 |
|---|---|
| 제목 | **Switchy Express: Cargo Puzzle** |
| 장르 | 무한 생존 점수 경쟁형 철도 노선·화물 스택 퍼즐 |
| 플랫폼·엔진 | Android / Google Play · Godot 4.7.1 / GDScript |
| 현재 단계 | `VERTICAL_SLICE_IN_PROGRESS · VS03_02_HEADLESS_PASSED` |
| 구현 기반 | `RAIL_TRAIN_CARGO_LIFO + VS03_01_RUN_CORE + VS03_02_COMPACT_FOOTPRINT` |
| GMB-001 | `CLOSED · SX-DEC-017~026 · 10/10` |
| Decision 정본 | PR #29 · `9b63421a5ab4d57adbfcf69d2b6e1bf8e3d17496` |
| DoR 감사 | `SX-AUD-005 · PASS · SYNCED` |
| VS03-01 감사 | `SX-AUD-006 · EV-VS03-01-001 · PASS · SYNCED` |
| VS03-01 구현 | PR #37 · `43972d3d23e931af3dbc81ab9b1c7d942fffb201` |
| 핵심 재미 정렬 | `SX-AUD-007 · PASS_WITH_FOLLOWUPS · SYNCED` |
| VS03-02 감사 | `SX-AUD-008 · EV-VS03-02-001 · PASS · MERGED_AND_VERIFIED` |
| VS03-02 구현 | PR #41 · `cfe6d5ca0c76942720c5c12ad5dc59aaa651b915` |
| 올바른 Sheet | `1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo` |
| 현재 Codex 권위 | `READY_FOR_BUILD · VS03-03_ONLY` |
| 다음 package | `VS03-03 · target3 maps / RunSession / restart / selection` |
| 자동 검증 | Godot headless `19 cases · 7499 assertions · 0 failures` |
| 제품 Scene·Android·사람 증거 | `NOT_RUN` |

## 한 문장 플레이어 약속

> 필요한 화물을 작은 토큰형 화차로 역순 적재하고, 선로 분기기를 바꿔 알맞은 역에서 큰 하역 Combo를 만들며 연료가 다하기 전까지 최고 점수를 갱신한다.

## 핵심 재미 위계

```text
LIFO 적재 순서 계획
→ 목적 역까지의 노선 선행 결정
→ 큰 그룹을 위한 위험·생존 판단
→ BOOST와 배송 속도의 전술적 시간 관리
→ 결과 학습·같은 조건 재도전
→ 기록·꾸미기·맵 발견·UGC
```

빠른 탭·BOOST·메타 보상·콘텐츠 수가 적재 순서와 노선 계획보다 앞서면 방향 이탈이다.

## 현재 읽기 순서

```text
CURRENT_CONFIRMED_DECISIONS.md
→ ../10_경험/CORE_FUN_SYSTEM_HIERARCHY.md
→ ACTIVE_CONTEXT.md
→ ../../50_제작_검증/VS03_PACKAGE_STATUS.md
→ ../../50_제작_검증/VS03_02_SYNC_CLOSURE.md
→ ../../50_제작_검증/VS03_02_IMPLEMENTATION_AUDIT.md
→ ../../50_제작_검증/CORE_FUN_ALIGNMENT_SYNC_CLOSURE.md
→ ../../../docs/superpowers/plans/2026-08-03-vs03-core-first-resegmentation.md
→ current package-specific plan
→ ../../50_제작_검증/VS03_01_IMPLEMENTATION_AUDIT.md
→ ../../50_제작_검증/VS03_DEFINITION_OF_READY_AUDIT.md
→ ../../../docs/superpowers/specs/2026-08-02-vs03-execution-architecture-design.md
→ ../../../docs/superpowers/plans/2026-08-02-vs03-build-segmentation.md
→ ../../50_제작_검증/VERTICAL_SLICE_CONTRACT.md
→ EXECUTABLE_PROMPTS/CODEX_GOAL_VS_03.md
```

`VS03_PACKAGE_STATUS.md`가 현재 package 상태를 소유한다. `2026-08-03-vs03-core-first-resegmentation.md`가 승인된 미래 순서를 소유한다.

## Gate 상태

- `G0_PROJECT_IDENTIFIED`: PASS
- `G1_CORE_CONFIRMED`: PASS
- `G2_VERTICAL_SLICE_CONTRACT_APPROVED`: PASS
- `G3_CORE_RUNTIME_PROVEN`: `PARTIAL · VS03_02_HEADLESS_PASSED`
- `G3P_TOTAL_PLANNING_AND_REVIEW_COMPLETE`: PASS
- `G3B_GRILL_ME_BATCH_PREMERGE`: `GMB-001 CLOSED`
- `G3C_CORE_FUN_ALIGNMENT`: `SX-AUD-007 PASS_WITH_FOLLOWUPS · SYNCED · CLOSED`
- `G3I_VS03_IMPLEMENTATION`: `VS03-01/02 MERGED_AND_VERIFIED · VS03-03 READY_FOR_BUILD`
- `G4_TARGET_QUALITY_SLICE`: NOT_STARTED
- `G5_PLAYTEST_EVIDENCE`: NOT_STARTED
- `G6_OFFICIAL_CATALOG_PRODUCTION`: `NOT_STARTED · F58_NOT_MET`
- `G7_ONLINE_UGC_PRODUCTION`: NOT_STARTED

## VS03-02 완료 내용

- CargoStack `0..8`과 compact token `0..8`의 1:1 투영
- front→rear=bottom→top, rear=LIFO top
- token 거리 `0.22 + index×0.28`, capacity 8=`2.18` cell
- route-history 기반 직선·곡선·switch geometry
- conservative unique occupancy, trailing `<=3`
- DeliveryLoop optional occupancy provider
- omitted/null provider의 `train.train_cells()` fallback
- pickup·unload 1회 동기화
- compact spawn/respawn exclusion

Exact-head 증거:

```text
5477ecd8d7c14c73a62a3c666d15aa4e826a92ab
Project Contract 281 PASS
Godot Tests 261 PASS
19 cases · 7499 assertions · 0 failures
behind 0 · thread 0 · REQUEST_CHANGES 0 · P0/P1 0
canonical merge cfe6d5ca0c76942720c5c12ad5dc59aaa651b915
correct Sheet 12-tab readback PASS
```

Headless geometry PASS는 제품 화면·Android·사람 가독성 PASS가 아니다. `F92`는 계속 evidence gap이다.

## 승인된 구현 순서

```text
VS03-01 run lifecycle/economy/difficulty · DONE
→ VS03-02 compact footprint/DeliveryLoop seam · DONE
→ VS03-03 target3 maps/session/restart/selection · READY · CURRENT
→ VS03-R1 difficulty authority alignment · BLOCKED
→ VS03-05A minimal playable core surface · BLOCKED
→ VS03-04 Profile transactions/records/cosmetics/unlocks/rewards · BLOCKED
→ VS03-05B result/collection/map browser · BLOCKED
→ VS03-06 contextual onboarding · BLOCKED
→ VS03-07 integration/evidence handoff · BLOCKED
```

공통 hotspot package는 병렬 실행하지 않는다. 각 package는 이전 package가 병합·정본 동기화된 최신 main에서 시작한다.

## 현재 작업

```text
VS03-02 closure merge
→ correct Sheet closure SHA + final 12-tab readback
→ latest main에서 VS03-03 별도 TDD branch
```

## VS03-03 보호 경계

허용:

- exactly 3 distinct validated official maps
- immutable MapDefinition·strict MapCatalog
- fully configured RunSessionFactory
- same-map restart with fresh mutable services/identities
- automatic undiscovered-first selection
- discovered-map semantic reselection domain

금지:

- VS03-R1 difficulty correction
- product Scene/HUD/result/camera/browser
- Profile/save/records/rewards/unlocks
- onboarding
- target100·UGC·online

## 공통 보호 경계

- 현재 실행 권위는 VS03-03뿐이다.
- Profile/save는 VS03-05A automated Gate 전 시작하지 않는다.
- target100과 online UGC는 Production 후속 Gate다.
- `F58`은 target100 증거 전 `NOT_MET`다.
- runtime·Android·human·online 검증을 실행하지 않고 PASS로 표시하지 않는다.
