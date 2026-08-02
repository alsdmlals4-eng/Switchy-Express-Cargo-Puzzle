# Codex Goal — VS-02 기차·화차·화물·스테이션·LIFO

Status: `COMPLETE · HISTORICAL_EXECUTION_CONTRACT`
GitHub Issue: `#5 · CLOSED`
Parent Epic: `#3`
Blocked by: `#4` — `COMPLETED`
Original implementation baseline: `801632949d28564528e38d83dac59cccc6f06fb2`
Implementation PR: `#12`
Implementation main: `0738d9c10e431a43e7a2f34590369c3f17d1f8a5`
Runtime recovery PR: `#13`
Validated recovery main: `4e435a1a6d10ab146197671049da80709fd18c1f`
Plan: `docs/superpowers/plans/2026-08-01-switchy-express-vertical-slice.md` Task 4~5

> 이 파일은 완료된 VS-02의 역사 실행 계약이다. 아래의 원래 범위·TDD 순서·보호 조건·중단 조건을 감사와 회귀 근거로 보존하며 새 구현에 다시 사용하지 않는다. 현재 기획·Codex 준비 상태는 `CODEX_GOAL_VS_03.md`가 책임진다.

## 역할

당신은 이 저장소의 Godot/GDScript 구현 담당자다. 승인된 정본과 Issue #5 범위만 테스트 우선으로 구현한다. 새로운 게임 규칙·밸런스·아트·HUD·메타 시스템을 발명하지 않는다.

## 먼저 읽기

1. `AGENTS.md`
2. `기획서/00_프로젝트_허브/START_HERE.md`
3. `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
4. `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
5. `기획서/10_경험/CORE_GAMEPLAY.md`
6. `기획서/20_시스템_콘텐츠/CORE_SYSTEMS.md`
7. `기획서/50_제작_검증/POST_VS01_ADVERSARIAL_AUDIT.md`
8. `docs/superpowers/plans/2026-08-01-switchy-express-vertical-slice.md`
9. GitHub Issue #5
10. 실제 `game/rail/**`, `tests/rail/**`

## 이번 Goal

다음 결과만 구현한다.

1. 선택된 RailGraph 경로를 따르는 기관차와 최대 8개 화차
2. LOAD 상태에서만 동작하는 화물 적재와 색상별 최소 4개 스폰
3. 일반 선로의 색상별 역 2개, 총 6개 배치
4. 마지막 적재부터 같은 색 연속 그룹만 내리는 LIFO 하역
5. 실제 스택과 동일한 하역 순서 ViewModel

연료·점수·속도 공식·BOOST 효과·제품 HUD·최종 아트는 이번 Goal 범위가 아니다. 단, 다음 Goal에서 LOAD와 BOOST가 상호 배타적으로 연결될 수 있도록 입력 상태 API만 노출한다.

## 필수 격리

- `main` 최신 HEAD에서 독립 Branch/worktree를 사용한다.
- 권장 Branch: `feature/vs-02-train-cargo-lifo`
- `main` 직접 Push·force push·amend 금지
- 다른 작업자의 미커밋 변경을 덮어쓰지 않는다.

## TDD 실행 순서

### Task 1 — 기관차와 화차 경로 이력

먼저 실패 테스트를 작성한다.

- 기관차가 `RailGraph.next_cell()`이 선택한 exit를 사용
- 즉시 180도 반전 없음
- 분기 통과 뒤 해당 분기 기본 상태 복귀
- 이동 거리 기준 1칸 간격의 화차 위치
- 최대 8개 화차가 직선·곡선·분기에서 같은 위치를 점유하지 않음
- 경로 이력은 최대 필요 길이+안전 여유로 제한되어 무한 증가하지 않음

그 후 최소 구현한다.

```text
game/train/train_state.gd
game/train/train_controller.gd
game/train/wagon_view.gd
tests/train/test_train_movement.gd
```

`TrainController`는 충돌 물리가 아니라 RailGraph와 이동 거리 이력을 사용한다. 렌더링은 테스트 가능한 상태와 분리한다.

### Task 2 — 화물 타입·스택·LOAD 입력

먼저 실패 테스트를 작성한다.

- 타입: `RED_STAR`, `BLUE_DIAMOND`, `YELLOW_TRIANGLE`
- capacity 8
- LOAD 비활성 시 접촉 화물 적재 없음
- LOAD 활성 시에만 적재
- 가득 찬 스택은 추가 적재 거부
- 입력 상태에서 LOAD/BOOST 동시 요청 시 BOOST 우선으로 LOAD 비활성
- 적재 `R,R,B,R`의 하역 ViewModel은 `R,B,R,R`

그 후 최소 구현한다.

```text
game/cargo/cargo_type.gd
game/cargo/cargo_stack.gd
game/input/gameplay_input_state.gd
tests/cargo/test_cargo_stack.gd
```

이번 Goal에서 BOOST 속도·연료 계산은 구현하지 않는다.

### Task 3 — 스테이션 배치

먼저 실패 테스트를 작성한다.

- 빨강·파랑·노랑 각 2개, 총 6개
- 분기기 칸 금지
- 일반 선로에만 배치
- 같은 색 두 역의 그래프 최단거리 5칸 이상
- 기차 시작 칸과 겹치지 않음
- 동일 seed 결과 동일
- 유효 배치 실패 시 결정론적 fallback 또는 명시적 실패 결과

그 후 최소 구현한다.

```text
game/station/station.gd
game/station/station_placer.gd
tests/station/test_station_placement.gd
```

완전 무작위 재시도를 무한 반복하지 않는다. 최대 시도 횟수와 검증 가능한 실패 상태를 둔다.

### Task 4 — 화물 스폰과 최소 수량 유지

먼저 실패 테스트를 작성한다.

- 게임 시작 시 색상별 최소 4개
- 적재 뒤 동일 색 신규 화물이 1초 지연 후 생성 가능
- 기차·화차·역·분기기·기존 화물·기차 전방 2칸·직전 위치 금지
- 한 칸에 화물 최대 1개
- 동일 seed·동일 점유 상태에서 결과 재현
- 유효 후보가 없으면 기존 화물을 덮어쓰지 않고 `SPAWN_DEFERRED`

그 후 최소 구현한다.

```text
game/cargo/cargo_spawner.gd
tests/cargo/test_cargo_spawner.gd
```

색상별 최소 4개는 맵 위 pickup 수다. 화차에 실린 화물은 이 수에 포함하지 않는다.

### Task 5 — 스테이션 LIFO 하역 통합

먼저 실패 테스트를 작성한다.

적재 순서:

```text
R → R → B → R
```

하역 순서와 결과:

```text
RED 역: R 1개
BLUE 역: B 1개
RED 역: R 2개 연속
```

추가 계약:

- 스택 top과 역 타입이 다르면 0개 하역
- top부터 같은 타입인 연속 그룹만 하역
- 하역 ViewModel과 실제 pop 결과 일치
- 하역 결과는 향후 점수·연료 시스템이 소비할 수 있는 구조체/Dictionary로 반환

그 후 최소 구현한다.

```text
tests/station/test_station_unloading.gd
```

## 필수 API 방향

정확한 내부 이름은 Godot 표준과 기존 코드에 맞춰 조정할 수 있지만 아래 책임은 유지한다.

```gdscript
TrainController.set_speed(cells_per_second: float) -> void
CargoStack.push(cargo_type) -> bool
CargoStack.peek()
CargoStack.unload_order() -> Array
CargoStack.pop_matching_group(cargo_type) -> Array
CargoSpawner.ensure_minimum(cargo_type, count := 4)
Station.try_unload(stack)
```

## 보호 범위

변경 금지 또는 별도 Change Proposal 필요:

- `SX-DEC-001`~`SX-DEC-013` 의미
- 15×10 맵과 전체 연결·막다른길 없음
- 직진 우선 기본 A노선과 5칸 preview 계약
- LIFO를 FIFO로 변경
- 스테이션 수·화물 최소 수·capacity 8 변경
- 연료·점수·BOOST 최종 동작을 이번 Goal에 선행 구현
- 제품 HUD·최종 아트·마스코트 서사 추가
- Google Sheets 구조와 Base pin 변경

## 적대적 검토 체크

- 화차가 분기에서 순간 이동하거나 겹치지 않는가
- 경로 이력이 무한 증가하지 않는가
- 스테이션 배치가 특정 seed에서 영원히 재시도되지 않는가
- 화물이 접근 불가능하거나 금지 칸에 생성되지 않는가
- 화물을 주운 같은 위치에서 반복 파밍할 수 없는가
- LIFO ViewModel과 실제 하역 순서가 어긋나지 않는가
- 색상만으로 타입을 구분하는 API/데이터가 생기지 않는가
- 현재 단순 RailGenerator의 제한된 다양성을 구현 완료로 과장하지 않는가

## 검증 명령

```bash
python tools/validate_project_contract.py
godot --headless --path . --script res://tests/run_tests.gd
git diff --check
git status --short
```

실제 Godot 실행 출력과 assertion 수를 보고한다. 실행하지 못한 Android·시각·성능 검사는 `NOT_RUN`으로 남긴다.

## 커밋 경계

권장:

1. `feat: move train and follow route history`
2. `feat: add cargo stack and input state`
3. `feat: place stations and maintain cargo population`
4. `feat: unload LIFO cargo at stations`

각 Task는 RED→GREEN을 확인한 뒤 다음 Task로 이동한다.

## PR 완료 보고

- Issue #5, Parent #3, Decision IDs
- 변경 파일과 책임
- Task별 RED→GREEN 증거
- 전체 headless 테스트 결과와 assertion 수
- seed 재현성·fallback/deferred 결과
- 미검증 항목
- 적대적 검토 finding과 회귀 테스트
- 다음 Issue #6를 막는 사항

## 중단 조건

다음은 임의 해결하지 않고 Finding으로 반환한다.

- 기존 RailGraph API를 깨야만 구현 가능
- 15×10에서 역 6개·동색 거리 5·화물 최소 12를 안정적으로 배치할 수 없음
- 화차 8개 이력 요구가 메모리·정확성 계약과 충돌
- 정본과 실제 구현 사이의 LIFO·스폰 금지 규칙 충돌
- 현재 Goal 밖의 연료·점수·HUD 변경이 필요

## 완료 기록

- PR #12: `9 cases / 6908 assertions / 0 failures`
- PR #13: `9 cases / 6915 assertions / 0 failures`
- Project Contract: PASS
- 범위 내 제품 계약: 구현·검증 완료
- Android·제품 UI·성능·사람 검수: 이 Goal 범위 밖이며 `NOT_RUN`
