# Finite Puzzle First Vertical Slice Plan Clarifications

```yaml
status: NORMATIVE_PLAN_COMPANION
parent_plan: docs/superpowers/plans/2026-08-05-finite-puzzle-first-vertical-slice.md
spec_id: FP-DOR-001
approval_evidence: EV-USER-020
```

이 문서는 parent plan 자체 검토에서 발견한 구현 해석 여지를 닫는다. 충돌 시 이 문서의 더 구체적인 규칙을 적용한다.

## 1. FP_CORE_PROOF_01 buildability

`data/maps/fp_core_proof_01.json`은 다음 authoring 필드를 추가한다.

```json
"buildable_rects": [
  {"minimum": [1, 1], "maximum": [9, 7]}
]
```

`FiniteMapLoader`는 사각형을 양 끝 포함으로 확장하고 다음 셀을 제거해 canonical `buildable_cells`를 만든다.

- `blocked_cells`
- `start_cell`
- `incoming_cell`
- 모든 `station_placements[].cell`
- 모든 `cargo_placements[].cell`

확장 결과를 좌표 `y`, `x` 순으로 정렬한다. 중복 rect가 있더라도 canonical 목록에는 셀 하나만 남긴다. `FiniteMapDefinition`은 `buildable_rects`를 보존하지 않고 확장된 `buildable_cells`만 소유한다.

## 2. Authored anchor pieces

시작점·incoming·역·화물의 `rail_anchor`는 플레이어가 편집할 수 없는 fixed piece다.

- start/incoming은 수평 `STRAIGHT rotation 0`
- placement에 명시된 geometry와 rotation을 그대로 사용
- fixed piece와 인접 player piece의 port가 대칭 연결돼야 함
- fixed piece가 blocked 또는 buildable 목록에 동시에 존재하면 map validation 실패

## 3. Switch geometry

rotation 0의 switch는 다음 포트를 사용한다.

```text
approach = LEFT
exit 0 = RIGHT
exit 1 = UP
missing = DOWN
```

회전은 시계 방향이다. approach에서 진입하면 현재 선택 exit로 나간다. 두 exit 중 하나에서 진입하면 approach로 합류한다. exit에서 다른 exit로 직접 통과할 수 없다.

## 4. Proof-map solution fixtures

`fp_core_solution_alpha.gd`와 `fp_core_solution_beta.gd`는 제품 정답 노선이 아니라 자동 수용 검사용 fixture다.

- 각 fixture는 명시적 `TrackPiece` 배열을 반환한다.
- 두 fixture의 `layout_signature`는 달라야 한다.
- 둘 다 preflight PASS여야 한다.
- 둘 다 A/B/A/A 적재와 A역 재방문이 가능한 분기 순환망이어야 한다.
- fixture 좌표를 조정해야 할 경우 맵 정본 조건과 위 수용 기준은 바꾸지 않는다.
- fixture는 런타임 UI·힌트·추천 노선에서 읽거나 노출하지 않는다.

## 5. Legacy movement reuse boundary

기존 `TrainController`를 재사용할 때 허용되는 호출은 다음뿐이다.

```text
configure
set_speed
advance_time
advance_one_cell
movement_progress
seconds_to_next_cell
target_cell
current_cell
previous_cell
forward_cells
```

finite runtime은 wagon count와 capacity를 화물 domain 권위로 사용하지 않는다. `FiniteTrackGraph.commit_switch_passage()`는 no-op이므로 기존 `TrainController` 호출이 switch state를 초기화하지 않는다.
