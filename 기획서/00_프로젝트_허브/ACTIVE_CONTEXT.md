# Active Context

## 현재 상태

```yaml
project: Switchy Express: Cargo Puzzle
stage: VERTICAL_SLICE_IN_PROGRESS · VS02_RUNTIME_PASSED
work_mode: IMPLEMENTATION_READY · STAGED
product_baseline: 4e435a1a6d10ab146197671049da80709fd18c1f
gmb001_decision_merge: 9b63421a5ab4d57adbfcf69d2b6e1bf8e3d17496
gmb001: CLOSED · SX-DEC-017~026
dor_audit: SX-AUD-005 · PASS · SYNCED
dor_merge: 82fd3eeb1915e6ceedb2f5330b27e903064d6eb5
dor_evidence: EV-USER-016
product_implementation: NOT_STARTED
codex_state: READY_FOR_BUILD
first_authorized_package: VS03-01
sheet_state: DOR_CANONICAL_READBACK_PASS
```

## 완료된 운영·기획

- VS-01/02 철도·열차·화물·LIFO 기반 구현과 기존 headless 증거 완료.
- `SX-DEC-014~026`, `SX-OPS-001` canonical sync 완료.
- GMB-001 PR #29·closure PR #34·올바른 Sheet closure 완료.
- `SX-AUD-005 / EV-USER-016` PR #35·Sheet canonical readback 완료.
- 올바른 Sheet는 `1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo`다.
- 잘못된 `19Ff...` Sheet는 변경하지 않는다.

## 검증된 제품 기반

- Godot 4.7.1 project·custom headless runner
- 15×10 connected RailGraph·no dead ends
- 2/3-state RailSwitch·straight-first·preview parity·target lock
- continuous train movement
- capacity 8 LIFO CargoStack
- LOAD contract·BOOST priority
- station 6·pickup minimum 4/type
- deterministic placement·deferred respawn recovery
- LIFO matching-group unload
- historical `9 cases / 6915 assertions / 0 failures`

## DoR 결과 — SX-AUD-005

실제 code/test/plan/Issue를 대조해 P1 실행 충돌을 정본에서 폐쇄했다.

1. compact footprint와 `train.train_cells()` spawn occupancy 충돌
2. 실제 test runner와 unsupported 계획 예시 불일치
3. empty Main과 composition owner 부재
4. 공통 hotspot의 다중 plan owner
5. 불완전 RunSessionFactory·map start/incoming 누락
6. movement/event/fuel-zero authoritative order 누락
7. Profile multi-writer·중복 transaction 위험
8. 잘못된/존재하지 않는 file path
9. target100 scan의 VS scope/watchdog 오염
10. rollback/evidence 위치 분산

Known open P0/P1 implementation-planning finding after fixes: `0`.

Fix canon:

```text
기획서/50_제작_검증/VS03_DEFINITION_OF_READY_AUDIT.md
docs/superpowers/specs/2026-08-02-vs03-execution-architecture-design.md
docs/superpowers/plans/2026-08-02-vs03-build-segmentation.md
```

## 현재 실행 권위 — VS03-01

```text
RunBalance / RunState / RunSummary / RunController
RunMetricsAccumulator
DifficultyForecast / DifficultyEvent / DifficultyDirector
minimal TestCase helpers
read-only TrainController timing/path seam
```

VS03-01에서 금지:

- compact footprint 구현은 VS03-02
- map/session/restart/selection은 VS03-03
- Profile/records/rewards/unlocks는 VS03-04
- Scene/HUD/result/camera/browser는 VS03-05
- onboarding은 VS03-06
- target100/UGC/online은 Production

## Canonical package order

```text
VS03-01
→ VS03-02
→ VS03-03
→ VS03-04
→ VS03-05
→ VS03-06
→ VS03-07
```

공통 hotspot package는 병렬 실행하지 않는다. 각 package는 이전 merged main에서 시작한다.

## 현재 미구현·미검증

```yaml
runtime_SX_DEC_014_026: NOT_STARTED_OR_NOT_RUN
official_map_target_3: NOT_RUN
official_map_target_100: NOT_RUN
F58: NOT_MET
profile_records_rewards: NOT_STARTED
android_localization_accessibility_human: NOT_RUN
ugc_editor_backend_moderation_privacy_community: NOT_STARTED_OR_NOT_RUN
```

## 다음 실행 순서

```text
별도 Codex 작업에서 latest main 확인
→ VS03-01 전용 branch
→ actual runner 기반 TDD
→ package-owned files only
→ Project Contract + Godot + review Gate
→ merge 전 사용자/Decision 의미 재검토
```

## 금지

- VS03-02~07 병렬 시작
- unsupported test runner API 복사
- Profile 다중 writer
- selected/restarted map silent substitution
- target100을 VS-03 완료 조건으로 끌어오기
- local mock으로 Android/human/online readiness 주장
- `READY_FOR_BUILD`를 구현 완료로 표현

## 다음 작업

제품 구현은 별도 Codex 실행에서 `VS03-01`부터 시작한다. 새 Decision은 구현이 material player-facing choice를 드러낼 때만 추가한다.
