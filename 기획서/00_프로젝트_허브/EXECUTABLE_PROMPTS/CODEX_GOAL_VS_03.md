# Codex Goal — VS-03 연료·속도·점수·BOOST·게임 HUD

Status: `READY_FOR_BUILD`
GitHub Issue: `#6`
Parent Epic: `#3`
Blocked by: `#5` — `COMPLETED`
Implementation baseline: `4e435a1a6d10ab146197671049da80709fd18c1f`
Plan: `docs/superpowers/plans/2026-08-01-switchy-express-vertical-slice.md` Task 6~7

## 역할

당신은 이 저장소의 Godot/GDScript 구현 담당자다. 승인된 정본과 Issue #6 범위만 테스트 우선으로 구현한다. 이번 Goal은 기존 배송 하위 루프에 생존 경제와 기능 HUD를 연결한다. 최종 아트·오디오·광고·메타·Android 품질을 발명하거나 완료로 주장하지 않는다.

## 먼저 읽기

1. `AGENTS.md`
2. `기획서/00_프로젝트_허브/START_HERE.md`
3. `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
4. `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
5. `기획서/10_경험/CORE_GAMEPLAY.md`
6. `기획서/20_시스템_콘텐츠/CORE_SYSTEMS.md`
7. `기획서/40_표현/VISUAL_DIRECTION.md`
8. `기획서/50_제작_검증/POST_VS02_ADVERSARIAL_AUDIT.md`
9. `기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md`
10. `docs/superpowers/plans/2026-08-01-switchy-express-vertical-slice.md`
11. GitHub Issue #6
12. 실제 `game/rail/**`, `game/train/**`, `game/cargo/**`, `game/station/**`, `game/delivery/**`, `tests/**`

## 이번 Goal

다음 결과만 구현한다.

1. 시간·화물·BOOST에 따른 속도와 연료 소비 순수 계산
2. 배송 이벤트를 점수·연료·combo로 변환하는 RunController
3. 연료 0 게임오버·입력/이동 정지·결과 요약
4. 재시작과 최고 점수·최장 시간·최대 combo 로컬 저장
5. 기능적 가로형 gameplay scene과 HUD
6. LOAD·BOOST·분기 입력과 기존 DeliveryLoop의 연결

최종 캐릭터·역·선로 아트, 오디오, 진동, Android 실기 성능, 광고·과금, 플레이테스트는 이번 Goal 범위가 아니다.

## 필수 격리

- 최신 `main`에서 독립 Branch/worktree를 사용한다.
- 권장 Branch: `feature/vs-03-run-economy-hud`
- `main` 직접 Push·force push·amend 금지
- 다른 작업자의 미커밋 변경을 덮어쓰지 않는다.

## 확정 초기 시험값

아래는 Vertical Slice 시험 기준이다. 코어 의미를 바꾸지 않고, 플레이테스트 전에는 임의 변경하지 않는다.

```text
fuel_max = 100
fuel_start = 65
base_speed(t) = min(3.4, 1.8 + 0.08 × floor(t / 30초))
cargo_multiplier(n) = max(0.64, 1.0 - 0.045 × n)
boost_multiplier = 1.45
base_drain(t) = 1.0 + 0.12 × floor(t / 45초)
boost_drain_multiplier = 2.4
```

하역 보상:

| 연속 하역 | 기본 점수 | 연료 |
|---:|---:|---:|
| 1 | 100 | 5 |
| 2 | 260 | 12 |
| 3 | 540 | 21 |
| 4 | 960 | 32 |
| 5+ | `300 × 개수` | `8 × 개수` |

점수 배율:

```text
fast_delivery_bonus = 1.25 if 이전 성공 배송 후 8초 이내 else 1.0
heavy_bonus = 1.15 if 배송 직전 화물 6개 이상 else 1.0
final_score = round(base_score × fast_delivery_bonus × heavy_bonus)
```

부스터 사용 시간 자체에는 점수를 주지 않는다. 화물 감속은 연료 drain을 낮추지 않는다.

## TDD 실행 순서

### Task 1 — RunBalance 순수 함수

먼저 실패 테스트를 작성한다.

- 0초·29.9초·30초·90초·장기 상한 속도
- 화물 0~8개 감속과 0.64 하한
- BOOST 배율 적용
- 화물 수가 연료 drain을 낮추지 않음
- 44.9초·45초·180초 drain 단계
- BOOST drain 2.4배
- 하역 1~8개 보상 표
- 빠른 배송 8초 경계
- 배송 직전 화물 6개 heavy 경계
- 같은 입력은 frame delta와 무관하게 같은 결과

그 후 최소 구현한다.

```text
game/run/run_balance.gd
tests/run/test_run_balance.gd
```

권장 API:

```gdscript
RunBalance.speed(elapsed: float, cargo_count: int, boosting: bool) -> float
RunBalance.fuel_drain_rate(elapsed: float, boosting: bool) -> float
RunBalance.delivery_reward(combo_count: int, seconds_since_delivery: float, cargo_before: int) -> Dictionary
```

### Task 2 — RunState·RunController 통합

먼저 실패 테스트를 작성한다.

- 시작 연료 65·점수 0·combo 0·상태 RUNNING
- 매 frame 실제 시간 기준 연료 감소
- RunBalance 속도가 TrainController에 적용
- LOAD/BOOST 동시 요청 시 BOOST 우선
- DeliveryLoop의 성공 하역만 점수·연료 보상
- 하역 0개는 점수·연료 없음
- 연료는 100 초과 불가
- 성공 배송 간격은 DeliveryLoop의 실제 event time 사용
- 연료 0에서 상태 ENDED, 기차 속도 0, 입력 clear
- 종료 뒤 점수·연료·이동 변화 없음
- 여러 칸 frame과 작은 frame 분할 결과가 허용 오차 안에서 동일

그 후 최소 구현한다.

```text
game/run/run_state.gd
game/run/run_controller.gd
tests/run/test_run_controller.gd
```

DeliveryLoop 이벤트를 다시 계산하지 말고 단일 입력으로 소비한다.

### Task 3 — 무입력·중량·BOOST 시뮬레이션

먼저 실패 테스트를 작성한다.

- 180초 무입력 시 연료 0·점수 0·게임 종료
- 기본 노선만 반복해도 자동 점수 증가 없음
- 화물 8개 감속 상태가 무화물보다 연료 생존 시간을 늘리지 않음
- 상시 BOOST는 일반 운행보다 연료를 빠르게 소모
- 단기 BOOST는 같은 route 도착 시간을 줄임
- LOAD 없는 접촉은 계속 수거하지 않음
- 10분 시뮬레이션에서 route history·pending respawn·event buffer가 무한 증가하지 않음

그 후 필요한 최소 보조 시뮬레이터를 추가한다.

```text
tests/run/test_no_input_survival.gd
tools/run_soak_test.gd
```

이번 Task는 밸런스 값이 재미있다고 증명하지 않는다. 영구 생존·메모리 증가·상태 오류가 없음을 증명한다.

### Task 4 — 결과·로컬 기록

먼저 실패 테스트를 작성한다.

- 현재 run summary: score, survival_time, delivered_count, max_combo, end_reason
- 최고 점수·최장 시간·최대 combo만 저장
- 더 낮은 기록은 기존 최고 기록을 덮어쓰지 않음
- 새 run 시작 시 현재 상태만 초기화되고 최고 기록은 유지
- 손상·누락 save 데이터는 안전한 기본값으로 복구

그 후 최소 구현한다.

```text
game/save/record_store.gd
game/run/run_summary.gd
tests/save/test_record_store.gd
```

파일 I/O와 record 비교 로직을 분리해 headless 테스트가 가능하게 한다.

### Task 5 — 기능 HUD ViewModel

먼저 실패 테스트를 작성한다.

- score, fuel/max, speed, combo, time, unload order, cargo count, LOAD/BOOST 상태
- 연료 20% 이하 low-fuel 상태
- BOOST 중 LOAD 비활성 표시
- 게임 종료 시 result summary 표시
- 색상+모양 화물 아이콘 데이터
- 같은 RunState 입력에서 동일 ViewModel

그 후 최소 구현한다.

```text
game/ui/game_hud_view_model.gd
game/ui/result_view_model.gd
tests/ui/test_game_hud_view_model.gd
```

### Task 6 — 기능적 가로형 gameplay scene

먼저 scene boot·binding 테스트를 작성한다.

- `game/play/play_scene.tscn` 로드 가능
- `RailGraph`, TrainController, DeliveryLoop, RunController, HUD가 하나의 composition root에서 생성
- main scene가 play scene를 표시
- LOAD와 BOOST press/release 입력이 GameplayInputState에 연결
- 분기기 탭은 기존 RailGraph switch state를 순환
- RunController 종료 후 입력 차단·result panel 표시
- restart가 새 seed·새 run 또는 명시된 동일 seed 정책으로 재구성
- 1920×1080에서 HUD가 safe area 밖으로 나가지 않음

그 후 placeholder 벡터/Control 화면을 최소 구현한다.

```text
game/play/play_scene.tscn
game/play/play_scene.gd
game/rail/rail_board_view.gd
game/rail/switch_view.gd
game/ui/game_hud.tscn
game/ui/game_hud.gd
game/ui/result_panel.tscn
game/ui/result_panel.gd
tests/ui/test_play_scene_binding.gd
```

시각 요구:

- 상단: 점수·연료·속도·combo·생존 시간
- 중앙: 15×10 전체 선로·기차·화차·역·화물·분기 상태
- 하단 왼쪽: LOAD
- 하단 중앙: 다음 하역 순서
- 하단 오른쪽: BOOST
- 활성 경로는 굵기+화살표, 비활성 경로는 낮은 강조
- 색상+별/마름모/삼각형을 함께 사용
- 모든 주요 터치 영역 48dp 이상

최종 아트처럼 꾸미지 않는다. 기능적 placeholder임을 명시한다.

## 보호 범위

변경 금지 또는 별도 Change Proposal 필요:

- `SX-DEC-001`~`SX-DEC-013` 의미
- 15×10 맵·전체 연결·막다른길 없음
- 직진 우선 A노선·분기 통과 reset·현재 구간 target lock
- 화물 타입·capacity 8·색상별 최소 4개·역 6개
- LIFO를 FIFO로 변경
- 부스터가 LOAD와 동시에 동작하도록 변경
- 화물 감속이 연료 drain을 감소시키도록 변경
- 게임오버 원인을 연료 0에서 다른 주 조건으로 변경
- 최종 아트·광고·메타·과금을 이번 Goal에 추가
- Base pin·Google Sheets 구조 변경

## 적대적 검토 체크

- 화물 8개를 실어 속도를 낮추면 오히려 생존 시간이 증가하는가
- 상시 BOOST가 점수와 생존 모두에서 항상 정답인가
- 부스터가 실제 도착 시간을 줄이지 못하는가
- frame delta에 따라 연료·점수·배송 시각이 달라지는가
- 성공하지 않은 역 통과로 점수·연료를 얻는가
- 연료 0 뒤 입력·이동·스폰·점수가 계속 변하는가
- 재시작 시 이전 signal 연결이나 event buffer가 중복되는가
- result summary와 저장 기록이 실제 RunState와 어긋나는가
- HUD의 unload order가 실제 CargoStack과 다르게 표시되는가
- 분기 강조와 실제 target lock이 불일치하는가
- 작은 화면에서 LOAD·BOOST·분기 터치 영역이 겹치는가

## 검증 명령

```bash
python tools/validate_project_contract.py
godot --headless --path . --script res://tests/run_tests.gd
godot --headless --path . --script res://tools/run_soak_test.gd
git diff --check
git status --short
```

실제 출력과 assertion 수를 보고한다. Android·최종 시각·실기 성능·외부 플레이테스트는 실행하지 않았다면 `NOT_RUN`으로 남긴다.

## 커밋 경계

권장:

1. `feat: add run balance and survival state`
2. `feat: integrate delivery rewards boost and game over`
3. `feat: save records and expose run summaries`
4. `feat: bind functional landscape gameplay HUD`
5. `test: add no-input and soak regressions`

각 Task는 RED→GREEN 확인 뒤 다음 Task로 이동한다.

## PR 완료 보고

- Issue #6, Parent #3, Decision IDs
- 변경 파일과 책임
- Task별 RED→GREEN 증거
- 전체 headless 테스트·soak 결과
- 무입력 종료 시간과 score 0 증거
- 일반/중량/BOOST 비교 결과
- HUD·result scene boot 증거
- 실제 캡처가 있다면 첨부, 없으면 `NOT_CAPTURED`
- 미검증 Android·최종 아트·플레이테스트
- 적대적 검토 Finding과 회귀 테스트
- 다음 Issue #7을 막는 사항

## 중단 조건

다음은 임의 해결하지 않고 Finding으로 반환한다.

- 현재 시험값으로 무입력 180초 종료를 만족하지 못함
- 화물 감속이 실제 시간 연료 drain과 충돌해 영구 생존 exploit를 만듦
- BOOST가 정답/무가치 중 하나로 고정되어 코어 선택이 성립하지 않음
- DeliveryLoop 이벤트 구조를 깨야만 경제 통합 가능
- functional HUD를 위해 최종 아트나 Issue #7 범위가 필수
- 정본과 실제 코드 사이에 속도·연료·보상 규칙 충돌 발견
