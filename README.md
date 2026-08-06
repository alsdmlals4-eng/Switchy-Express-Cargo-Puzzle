# Switchy Express: Cargo Puzzle

**Switchy Express: Cargo Puzzle**는 플레이어가 선로를 건설해 화물을 만나는 순서를 설계하고, 마지막에 실은 화물부터 내리는 LIFO 규칙을 역산해 제한 시간 안에 모든 배송을 끝내는 가로형 물류 퍼즐입니다.

## 핵심 재미

> 선로가 적재 순서를 만들고, LIFO가 역 방문 순서를 만들며, TOP의 연속 동일 화물 하역이 다음 설계를 낳는다.

## 현재 제품 기준선

- 건설 불가 구역을 제외한 자유 선로 건설
- 선로별 건설비와 철거 전액 환급
- 구조적 도달 가능성 검사 뒤 운행 시작
- 수동 적재 기본·자동 적재 토글
- 무제한 CargoStack
- 운행 중 persistent branch·crossing 직접 전환과 점유 잠금
- SWITCH의 세 reciprocal 방향 화살표·직접 선택·진입 방향 U턴 계획
- TOP 연속 동일 화물 자동 하역
- 제한 시간 미배송 실패, 마지막 하역 즉시 성공
- 배송·하역 판정 뒤 이동 불가 시 `FAILURE · ROUTE_END` 계획
- 색상과 무관하게 한쪽 reciprocal 연결만 있는 최종 종착역 허용
- 동일 노선 fresh-runtime 재시도
- BUILD·RUN 중 메뉴에서 현재 플레이 종료 확인 후 타이틀 복귀
- 성능 없는 꾸미기 보상

## 바로 실행하기

현재 제품 권위: `GMB-003 · SX-DEC-027~042`  
현재 기획 감사: `SX-AUD-026 · APPROVED_PENDING_MERGE`

1. GitHub Desktop에서 저장소 `Switchy-Express-Cargo-Puzzle`과 **`main` 브랜치**를 선택한다.
2. `Fetch origin → Pull origin`으로 최신 `main`을 받는다.
3. Godot `4.7.1-stable`에서 저장소 루트의 `project.godot`을 다시 연다.
4. 별도 Scene 선택이나 Project Settings 변경 없이 **Project Play(F5 / ▶)** 를 누른다.

기본 `res://game/main/main.tscn`이 `VerticalSliceDemo`를 직접 부트한다.

```text
Title → Briefing → BUILD → RUN → Result → Retry/Edit/Title
```

### 이번 로컬 재검수의 필수 범위

```text
F5
→ Title 종료 표시
→ Briefing
→ BUILD HUD·도구 표시
→ 파란 한쪽 연결 종착역 판정
→ 배송 전 노선 끝 FAILURE/ROUTE_END
→ SWITCH 세 방향 화살표·진입 방향 U턴·점유 잠금
→ 마지막 화물 하역·SUCCESS 우선순위
→ BUILD 또는 RUN 메뉴 열기
→ 취소 후 동일 플레이 상태 유지
→ 다시 메뉴 열기
→ 종료 확정 후 Title 복귀
```

현재 사용자 수동 증거는 `TITLE_EXIT_VISIBLE_PASS`, `SUCCESS_RESULT_VISIBLE_PASS`, 빨간 한쪽 연결 역 PASS와 파란 한쪽 연결 역 FAIL이다. 파란 역 원인은 자동 parity 테스트 전까지 미확정이며, 새 ROUTE_END·분기 화살표·U턴과 BUILD/RUN 중간 종료는 `IMPLEMENTATION_PENDING` 또는 `RETEST_REQUIRED`다.

### 조작

```text
좌클릭: 설치·선택·분기/교차 전환
우클릭: 선택 취소·선로 철거
1~4: 직선·곡선·분기·교차 도구
R: 회전
Space: 운행 시작·일시정지·재개
Shift: 누르는 동안 수동 적재
A: 자동 적재 전환
Enter: 타이틀·브리핑 확인
Esc: 취소·뒤로
```

## 상태와 증거 경계

기존 자동 계약이 소비하는 기계 판독 상태 토큰은 그대로 유지한다.

```text
CANONICAL MAIN APK EXPORT: PASS
ANDROID DEVICE SMOKE: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
PRODUCTION CUTOVER: BLOCKED
```

```yaml
repository_main_observed: efe0ab7330387d1b411962074b5f91b3043fddc8
latest_automated_verified_product_main: 1339a9467312d0ac680725894a9efb59746ec2cc
pr_83: MERGED
pr_94: CLOSED_ARCHIVED_NOT_MERGED
pr_99: MERGED
pr_100: MERGED
finite_automated_core: PASS
pc_vertical_slice_automated_core: PASS
default_project_play_boot: PASS_AUTOMATED
one_sided_station_terminal_red: PASS_AUTOMATED_AND_USER_LOCAL
one_sided_station_terminal_blue: FAIL_USER_LOCAL_ROOT_CAUSE_UNVERIFIED
success_result_visible: PASS_USER_LOCAL
route_end_game_over: APPROVED_IMPLEMENTATION_PENDING
switch_three_direction_arrows_uturn: APPROVED_IMPLEMENTATION_PENDING
mid_run_exit: PASS_AUTOMATED
title_exit_visible: PASS_USER_LOCAL
pc_local_route_and_mid_run_retest: RETEST_REQUIRED
windows_debug_export_integrity: PASS
windows_artifact_runtime_visual_audio_smoke: NOT_RUN
android_device_smoke: NOT_RUN
five_person_comprehension: NOT_RUN
production_cutover: BLOCKED
```

`repository_main_observed`와 `latest_automated_verified_product_main`은 의도적으로 분리한다. 자동 회귀가 실행되지 않은 후속 문서·UID 커밋을 기존 자동 PASS로 확대하지 않는다.

## Windows artifact

`Windows Demo` debug export에는 다음 두 파일이 같은 폴더에 있어야 한다.

```text
SwitchyExpressVerticalSlice.exe
SwitchyExpressVerticalSlice.pck
```

export·구성·해시 무결성 PASS는 실제 Windows 화면·음향·물리 입력 PASS를 대신하지 않는다.

## Canonical Android validation

```yaml
source_commit: 536911449018a3caf3511bc64e7bf1a66edf2016
apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
package_id: com.alsdmlals4.switchyexpress.validation
android_device_smoke: NOT_RUN
```

PC 기본 진입점과 Android validation feature override의 증거를 섞지 않는다.

## 정본 읽기 순서

1. `기획서/00_프로젝트_허브/START_HERE.md`
2. `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
3. `기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md`
4. `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
5. `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md`
6. `기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md`
7. `기획서/50_제작_검증/SX_AUD_026_ROUTE_END_AND_SWITCH_DIRECTION_PLAN.md`

## 기술

- Godot 4.7.1-stable
- GDScript
- Windows / Android landscape
- GitHub 정본 + Google Sheets 동기화
