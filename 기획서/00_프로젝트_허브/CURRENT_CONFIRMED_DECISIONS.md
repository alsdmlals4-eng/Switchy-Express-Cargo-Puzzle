# Current Confirmed Decisions

Last updated: `2026-08-06`

```yaml
current_product_baseline: FINITE_DELIVERY_PUZZLE_BASELINE
current_decision_batch: GMB-003
current_product_decisions: SX-DEC-027~036
current_demo_decisions: SX-DEC-037 · SX-DEC-038 · SX-DEC-039 · SX-DEC-040 · SX-DEC-041 · SX-DEC-042
current_execution_authority: FP-DOR-001 · EV-USER-021 · EV-USER-022 · EV-USER-023 · EV-USER-024 · EV-USER-025 · EV-USER-026 · EV-USER-027 · EV-USER-028 · EV-USER-029
current_android_evidence: EV-FP-APK-001
current_audit: SX-AUD-026
planning_state: APPROVED_PENDING_MERGE
implementation_state: FINITE_CORE_PASS · PC_VERTICAL_SLICE_AUTOMATED_PASS · RECOMMENDED_ROUTE_AUTOMATED_PASS · ROUTE_CONTROL_AUTOMATED_PASS · CURVE_RENDER_PORT_PARITY_PASS · ONE_SIDED_STATION_TERMINAL_PASS · MID_RUN_EXIT_AUTOMATED_PASS · DEFAULT_PROJECT_PLAY_BOOT_PASS · WINDOWS_EXPORT_PASS · ROUTE_END_AND_SWITCH_DIRECTION_IMPLEMENTATION_PENDING
verified_code_main: 1339a9467312d0ac680725894a9efb59746ec2cc
manual_gate_state: TITLE_EXIT_VISIBLE_PASS · SUCCESS_RESULT_VISIBLE_PASS · RED_ONE_SIDED_STATION_USER_PASS · BLUE_ONE_SIDED_STATION_USER_FAIL · PC_LOCAL_ROUTE_AND_MID_RUN_RETEST_REQUIRED · WINDOWS_ARTIFACT_RUNTIME_NOT_RUN · ANDROID_NOT_RUN · HUMAN_NOT_RUN
cutover_state: BLOCKED
next_pc_gate: GMB003_PLAN_MERGE → TDD_IMPLEMENTATION → MAIN_FETCH_PULL → GODOT_REOPEN → F5_BLUE_TERMINAL_ROUTE_END_SWITCH_ARROW_RETEST → WINDOWS_RUNTIME_VISUAL_AUDIO_SMOKE
next_android_gate: ANDROID_DEVICE_SMOKE → FIVE_PERSON_COMPREHENSION
correct_sheet: 1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo
wrong_sheet: 19Ff... · DO_NOT_MODIFY
```

## Current Core Fun Authority

```text
선로 건설로 화물 조우 순서 설계
→ 수동/자동 적재로 LIFO 스택 구성
→ 운행 중 분기·교차 경로 전환
→ 연결된 모든 분기 방향을 화살표로 확인하고 필요 시 진입 방향으로 U턴
→ TOP 연속 동일 화물 하역
→ 제한 시간 안에 모든 필수 배송 완료
→ 사용하지 않는 열린 노선 끝과 색상 대칭 한쪽 연결 종착역 허용
→ 배송 완료 전 이동 불가 시 ROUTE_END 게임 오버
→ 필요 시 메뉴에서 현재 플레이를 안전하게 종료
→ 후속 재설계
```

## Current Decision Registry

| Decision ID | 분야 | 현재 결정 | 상태 |
|---|---|---|---|
| SX-DEC-027 | 제품 핵심 | 제한 시간 안에 모든 고정 화물을 배송하는 유한 수작업 퍼즐 | PASS |
| SX-DEC-028 | 건설 | 자유 선로 건설·비용·전액 환급·추천 비용 | PASS |
| SX-DEC-029 | 운행·판정 | 구조 검사·제한 시간·성공/실패·pause | PASS |
| SX-DEC-030 | 선로 | 직선·곡선·분기·교차 | PASS |
| SX-DEC-031 | 적재·LIFO | 수동 hold·auto toggle·무제한 stack·TOP 그룹 하역 | PASS |
| SX-DEC-032 | Combo | 하역 그룹과 최대 1초 표시 | PASS |
| SX-DEC-033 | 별·랭킹 | 신속·절약·점수 별과 leaderboard | NOT_STARTED |
| SX-DEC-034 | 캠페인 | tutorial·theme chapter | NOT_STARTED |
| SX-DEC-035 | 반복 도전 | 일일·주간 fixed-seed challenge | NOT_RUN |
| SX-DEC-036 | 공정성 | cosmetic-only, power progression·타인 route 공개 금지 | CURRENT |
| SX-DEC-037 | PC Vertical Slice | 마우스+키보드, touch 보존, 대표 스테이지, F5 기본 Project Play, Windows Demo, Android validation 보존 | AUTOMATED_PASS · LOCAL_RETEST_REQUIRED |
| SX-DEC-038 | Demo Route Refinement | 권장 배치, 15×11 균형 맵, 열린 종착, 한쪽 연결 종착역, 운행 중 분기·교차 표시·전환, 화면/판정 포트 동등성 | AUTOMATED_PASS · STATION_TERMINAL_PASS · LOCAL_RETEST_REQUIRED |
| SX-DEC-039 | Mid-Run Exit | BUILD·RUN 상시 메뉴에서 Pause→종료 확인→타이틀 복귀, 취소 시 동일 플레이 유지, shell input lock | AUTOMATED_PASS · TITLE_EXIT_VISIBLE_PASS · MID_RUN_RETEST_REQUIRED |
| SX-DEC-040 | Station Color Parity | 모든 역 색상은 reciprocal 이웃 1개 이상이면 동일하게 한쪽 연결 종착역으로 인정 | APPROVED · IMPLEMENTATION_PENDING |
| SX-DEC-041 | Route-End Failure | 배송·하역 판정 뒤 이동 불가면 FAILURE/ROUTE_END, 마지막 배송 SUCCESS 우선 | APPROVED · IMPLEMENTATION_PENDING |
| SX-DEC-042 | Switch Direction Arrows | 분기의 세 연결 방향을 화살표로 표시·직접 선택하며 진입 방향 선택 시 U턴 허용 | APPROVED · IMPLEMENTATION_PENDING |

## SX-DEC-037 One-click Direction

- 기본 `project.godot`의 `run/main_scene`은 `res://game/main/main.tscn`이다.
- `game/main/main.tscn`은 `VerticalSliceDemo`를 직접 포함해 Project Play(F5 / ▶)로 대표 데모를 부트한다.
- 사용자는 별도 Scene 선택이나 editor 설정 없이 Title → Briefing → BUILD → RUN → Result → Retry/Edit/Title을 진행한다.
- Android Validation feature override·package ID·canonical APK evidence는 변경하지 않는다.

## SX-DEC-038 Current Route Direction

- 대표 맵 권위는 `VS_DEMO_01@2`, 보드는 `15×11`, 제한시간은 `150초`다.
- 역·화물 마커는 넓은 가로·세로 범위를 사용하며 해당 칸 선로는 설치·회전·철거 대상이다.
- `권장 배치`는 경고 0개이며 실제 완주 가능한 노선을 설치한다.
- 모든 필수 화물을 적재·하역하면 사용하지 않는 열린 종착선은 허용한다.
- 역 칸은 시작점에서 도달 가능하고 상호 연결된 이웃 선로가 한쪽 이상이면 연결된 역으로 판정한다.
- 역은 반대편까지 관통하는 두 번째 연결을 요구하지 않으며 최종 종착역으로 사용할 수 있다.
- 마지막 필수 화물을 한쪽 연결 역에서 하역하면 선로 끝 실패보다 하역·성공 판정을 먼저 확정한다.
- 화물 칸과 일반 선로의 기존 연결 규칙은 완화하지 않는다.
- 중간 종착역에서의 자동 반전은 이번 결정에 포함하지 않는다.
- 분기·교차는 운행 중 상태를 표시하고 클릭으로 전환하되 열차 점유 중에는 잠근다.
- 화면 렌더러의 직선·곡선·분기·교차 포트는 권위 모델 `TrackPiece.ports()`와 같은 회전 의미를 사용한다.
- 새 맵·권장 노선·선로 표현·종착역 규칙은 자동 완주 또는 포트·연결 동등성 테스트 후 구현한다.

## SX-DEC-039 Mid-Run Exit Direction

- Product HUD 상단의 `메뉴`는 BUILD·RUN·UNLOADING·PAUSED에서 접근 가능하다.
- BUILD에서는 finite phase를 `BUILD`로 유지하고 Shell만 일시정지한다.
- RUNNING·UNLOADING에서는 공용 finite `PAUSE` 명령을 사용한다.
- `현재 플레이 종료`는 별도 확인 화면을 열고 초기 포커스는 `계속 플레이`다.
- 취소는 동일 gameplay instance와 진행 상태를 유지한다.
- 확정은 현재 gameplay instance와 stale result를 폐기하고 TITLE로 돌아간다.
- Pause·Exit Confirmation·Result 중에는 제품 키보드 입력을 잠근다.
- 현재 플레이 종료와 애플리케이션 종료를 분리한다.
- 사용자가 타이틀 화면의 종료 표시를 확인했으므로 `TITLE_EXIT_VISIBLE_PASS`다.
- BUILD/RUN 메뉴의 취소·확정 전체 흐름은 별도 로컬 재검수 전까지 PASS로 확대하지 않는다.

## SX-DEC-040 Station Color Parity Direction

- 역 연결 판정은 cargo type과 색상에 무관하다.
- RED_STAR와 BLUE_DIAMOND는 같은 선로 구조에서 같은 Preflight·하역 결과를 가져야 한다.
- 기존 자동 회귀가 RED_STAR만 명시하므로 두 색상 대칭 테스트를 추가한다.
- 파란 역 테스트가 현재 코드에서 이미 통과하면 사용자 관찰의 원인을 임의로 색상 코드라고 단정하지 않고 정확한 로컬 SHA·선로 회전·런타임 재현을 계속 요구한다.

## SX-DEC-041 Route-End Failure Direction

- RUNNING 중 현재 칸의 접촉·하역 처리를 마친 뒤 합법적인 다음 칸이 없으면 `FAILURE · ROUTE_END`다.
- 마지막 필수 배송의 pending SUCCESS는 같은 위치의 ROUTE_END보다 우선한다.
- 비최종 하역 중 노선 끝에 도달하면 하역 연출 완료 후 ROUTE_END를 확정한다.
- 제한 시간 실패는 `TIME_EXPIRED`로 구분한다.
- 동일 배치 재시도와 편집 복구를 유지한다.

## SX-DEC-042 Switch Direction Arrow Direction

- SWITCH의 reciprocal 세 연결 방향을 모두 절차적 화살표로 표시한다.
- 선택 방향은 굵기·채움으로 강조하고 나머지 방향도 계속 보인다.
- 원하는 화살표를 직접 클릭·터치해 선택하며 진입 방향 선택은 U턴을 의미한다.
- 분기 점유 중 잠금과 BUILD/RUN 권위는 유지한다.
- CROSSING의 기존 STRAIGHT/RIGHT/LEFT 모드는 이번 배치에서 변경하지 않는다.
- 새 바이너리 자산은 필요하지 않으며 기존 RouteControlOverlay를 안전하게 확장한다.

## Latest Automated Evidence

```yaml
verified_code_main: 1339a9467312d0ac680725894a9efb59746ec2cc
project_contract:
  workflow: 922
  result: PASS
godot_tests:
  workflow: 853
  run_id: 31097301981
  result: PASS
  cases: 92
  assertions: 11457
  failures: 0
one_sided_station_terminal:
  test: res://tests/finite/integration/test_one_sided_station_terminal.gd
  assertions: 20
  preflight: PASS
  one_reciprocal_neighbor: PASS
  final_unload_success: PASS
live_editor_pilot:
  result: PASS
  temporary_plugin_cleanup_before_regression: PASS
mid_run_exit_contract: PASS
curve_render_domain_port_parity_0_1_2_3: PASS
recommended_route_full_delivery: PASS
android_identity_invariance: PASS
```

```text
PC AUTOMATED CORE: PASS
DEFAULT PROJECT PLAY BOOT: PASS · AUTOMATED
RECOMMENDED ROUTE: PASS · AUTOMATED
ROUTE CONTROL UI/DOMAIN SYNC: PASS · AUTOMATED
CURVE RENDER/DOMAIN PORT PARITY: PASS · AUTOMATED
ONE-SIDED FINAL STATION: PASS · AUTOMATED
MID-RUN EXIT: PASS · AUTOMATED
TITLE EXIT VISIBLE: PASS · USER LOCAL
WINDOWS DEMO EXPORT: PASS
PC LOCAL ROUTE/MID-RUN FLOW: RETEST_REQUIRED
PC WINDOWS ARTIFACT RUNTIME: NOT_RUN
ANDROID DEVICE SMOKE: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
PRODUCTION CUTOVER: BLOCKED
```

## Current Manual Runtime Boundary

사용자 실기동에서 HUD 누락, JSON 좌표 오류, 시작점·마커 선로 표시·편집, 회전, 과도한 고정 선로와 경고 판정, 중간 종료 부재, 화면상 연결과 내부 곡선 포트 불일치가 순차 확인됐다.

사용자는 타이틀 화면의 종료 표시가 정상임을 확인했다. 이는 타이틀 종료 표시만의 수동 PASS이며 BUILD/RUN 중간 종료, 종착역 실제 클릭·운행, Windows artifact runtime에 대한 PASS가 아니다.

`main → Fetch origin → Pull origin → Godot reopen → F5`로 한쪽 연결 역 판정과 BUILD/RUN 종료 흐름을 재검수하기 전에는 해당 수동 Gate를 PASS로 올리지 않는다.

## Canonical Android Evidence

```yaml
source_commit: 536911449018a3caf3511bc64e7bf1a66edf2016
workflow_run_id: 31011620357
apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
package_id: com.alsdmlals4.switchyexpress.validation
```

PC 기본 진입점과 Android validation feature override의 증거를 섞지 않는다.

## Open Gates

- Red one-sided station runtime: `PASS · USER LOCAL · EV-USER-028`
- Blue one-sided station runtime: `FAIL · USER LOCAL · EV-USER-028 · ROOT_CAUSE_UNVERIFIED`
- SUCCESS result visibility: `PASS · USER LOCAL · EV-USER-029`
- Route-end game over: `APPROVED · IMPLEMENTATION_PENDING`
- Switch three-direction arrows and U-turn: `APPROVED · IMPLEMENTATION_PENDING`
- PC local route and mid-run retest: `RETEST_REQUIRED`
- Windows artifact runtime·visual·audio·physical input smoke: `NOT_RUN`
- Android landscape device smoke: `NOT_RUN`
- five-person comprehension: `NOT_RUN`
- production cutover: `BLOCKED`

## Preserved Decisions

- SX-DEC-001: 정식 제목 `Switchy Express: Cargo Puzzle`
- SX-DEC-008: LIFO와 TOP 연속 동일 종류 그룹 하역
- SX-DEC-011: 프리미엄 캐주얼 3D 카툰·토끼 기관사
- SX-DEC-012: Godot 4.7.1·GDScript·PC/Android 가로형
- SX-DEC-014: 한 역 도착의 연속 동일 화물 하역 수가 Combo
- SX-DEC-015: rear/TOP을 읽는 compact token 의미
- SX-DEC-019: cosmetic-only 공정성
- SX-DEC-023: 같은 조건 재도전과 immutable identity

## Historical Boundary

무한 생존, fuel, BOOST, capacity 8, cargo slowdown, pickup respawn, switch auto-reset은 현재 제품 권위가 아니다.

## Current Execution Authority

```text
PC: GMB-003 plan merge → TDD implementation → main Fetch/Pull → Godot reopen → F5 → 파란 한쪽 연결 역 → ROUTE_END 실패 문구 → 분기 세 방향 화살표·U턴 → 마지막 배송 SUCCESS 우선순위 재검수
Android: canonical APK export PASS → Android device smoke → Five-person Comprehension
Both: 별도 production cutover review
```

수동 증거 전에는 해당 Gate를 PASS로 표시하지 않는다.
