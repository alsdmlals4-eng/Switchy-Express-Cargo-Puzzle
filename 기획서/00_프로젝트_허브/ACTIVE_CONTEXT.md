# Active Context

## 현재 상태

```yaml
project: Switchy Express: Cargo Puzzle
product_authority: GMB-003 · SX-DEC-027~036
demo_authority: SX-DEC-037 · SX-DEC-038 · SX-DEC-039 · SX-DEC-040 · SX-DEC-041 · SX-DEC-042
current_audit: SX-AUD-026
active_user_branch: main
repository_main_observed: efe0ab7330387d1b411962074b5f91b3043fddc8
latest_automated_verified_product_main: 1339a9467312d0ac680725894a9efb59746ec2cc
pull_request_83: MERGED · 4189cd13bebc34649cdca39aa78bfd045805b7c8
pull_request_94: CLOSED · ARCHIVED · NOT_MERGED
pull_request_99: MERGED · dff1653738f1eead3cacff303080924d662767e2
pull_request_100: MERGED · efe0ab7330387d1b411962074b5f91b3043fddc8
finite_automated_core: PASS
pc_vertical_slice_automated_core: PASS
default_project_play_boot: PASS · AUTOMATED
recommended_route: PASS · AUTOMATED
one_sided_station_terminal: PASS · AUTOMATED
mid_run_exit: PASS · AUTOMATED
title_exit_visible: PASS · USER_LOCAL
success_result_visible: PASS · USER_LOCAL
red_one_sided_station_runtime: PASS · USER_LOCAL
blue_one_sided_station_runtime: FAIL · USER_LOCAL · ROOT_CAUSE_UNVERIFIED
route_end_game_over: APPROVED · IMPLEMENTATION_PENDING
switch_direction_arrows_and_uturn: APPROVED · IMPLEMENTATION_PENDING
pc_local_route_and_mid_run_retest: RETEST_REQUIRED
pc_windows_debug_export_integrity: PASS
pc_windows_artifact_runtime_smoke: NOT_RUN
validation_preparation: PASS
canonical_main_apk_export: PASS
android_device_smoke: NOT_RUN
five_person_comprehension: NOT_RUN · BLOCKED_BY_ANDROID
production_cutover: BLOCKED
correct_sheet: 1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo
wrong_sheet: 19Ff... · DO_NOT_MODIFY
```

## 증거 해석 규칙

- `repository_main_observed`는 감사 시작 시점의 실제 `main` HEAD다.
- `latest_automated_verified_product_main`은 92 cases·11,457 assertions의 자동 회귀가 확인된 제품 커밋이다.
- 두 SHA가 다르다고 자동 PASS가 무효가 되는 것은 아니지만, 후속 문서·UID 커밋까지 자동 검증됐다고 확대하지 않는다.
- 자동·export PASS는 실제 화면·음향·물리 입력·완주 PASS를 증명하지 않는다.

## Gate Summary

```text
FINITE AUTOMATED CORE: PASS
PC VERTICAL SLICE AUTOMATED CORE: PASS
DEFAULT PROJECT PLAY BOOT: PASS · AUTOMATED
PR #83/#99/#100 MERGE: PASS
ONE-SIDED FINAL STATION RED: PASS · AUTOMATED/USER LOCAL
ONE-SIDED FINAL STATION BLUE: USER LOCAL FAIL · AUTOMATED PARITY PENDING
SUCCESS RESULT VISIBLE: PASS · USER LOCAL
ROUTE-END GAME OVER: IMPLEMENTATION_PENDING
SWITCH THREE-DIRECTION ARROWS/UTURN: IMPLEMENTATION_PENDING
MID-RUN EXIT: PASS · AUTOMATED
TITLE EXIT VISIBLE: PASS · USER LOCAL
PC LOCAL ROUTE/MID-RUN FLOW: RETEST_REQUIRED
PC WINDOWS DEBUG EXPORT·INTEGRITY: PASS
PC WINDOWS ARTIFACT RUNTIME·VISUAL·AUDIO SMOKE: NOT_RUN
CANONICAL MAIN APK EXPORT: PASS
ANDROID DEVICE SMOKE: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
PRODUCTION CUTOVER: BLOCKED
```

## 기본 사용자 실행 경로

```text
GitHub Desktop
→ repository: Switchy-Express-Cargo-Puzzle
→ branch: main
→ Fetch origin
→ Pull origin
→ Godot 완전 종료 후 project.godot 다시 열기
→ 별도 Scene 선택 없이 Project Play(F5 / ▶)
→ Title → Briefing → BUILD → RUN → Result → Retry/Edit/Title
```

`res://game/main/main.tscn`이 `VerticalSliceDemo`를 직접 포함한다. `res://game/demo/vertical_slice_demo.tscn`은 개발·테스트용이며 사용자 필수 경로가 아니다.

## 최신 자동 제품 증거

```yaml
commit: 1339a9467312d0ac680725894a9efb59746ec2cc
project_contract: 922 · PASS
godot_tests: 853 · PASS
godot_cases: 92
godot_assertions: 11457
godot_failures: 0
one_sided_station_assertions: 20
recommended_route_full_delivery: PASS
curve_render_domain_port_parity: PASS
mid_run_exit_contract: PASS
live_editor_pilot_at_that_boundary: PASS
```

## 현재 수동 경계

사용자가 확인한 범위:

```yaml
title_exit_visible: PASS
```

아직 확인하지 않은 범위:

```yaml
one_sided_station_final_unload_runtime: RETEST_REQUIRED
mid_run_menu_visible: RETEST_REQUIRED
mid_run_cancel_state_preservation: RETEST_REQUIRED
mid_run_confirm_title_return: RETEST_REQUIRED
windows_artifact_runtime: NOT_RUN
android_device: NOT_RUN
human_comprehension: NOT_RUN
```

## 핵심 재미

```text
선로 건설로 화물 조우 순서 설계
→ 수동/자동 적재로 unlimited LIFO 구성
→ persistent branch·crossing과 역 방문 순서 실행
→ TOP 연속 동일 화물 하역
→ 제한 시간 안에 모든 배송 완료
→ 시간·건설비 기준으로 재설계
```

## Base·Pilot 경계

- 프로젝트의 채택 release pin은 Base `v9.4.3`으로 유지한다.
- 최신 Base `main`은 별도 비교 대상이지 자동 승격된 release pin이 아니다.
- PR #94는 설명의 C0.2와 실제 C0.3 candidate pin이 불일치하고 Pilot workflow가 실패해 병합 없이 `CLOSED · ARCHIVED`됐다.
- HiGodot 단일 저작 권위와 중복되지 않는 실제 소비 경로가 증명되기 전에는 새 Pilot을 시작하지 않는다.

## 다음 정확한 작업

```text
1. GMB-003 기획 PR exact-HEAD 검수·병합
2. merged main에서 station color parity RED/characterization 실행
3. ROUTE_END·three-way switch·arrow interaction RED 확인
4. 최소 구현과 전체 회귀
5. 구현 PR exact-HEAD 검수·병합
6. main Fetch origin → Pull origin
7. Godot 완전 종료 후 다시 열기 → F5
8. 파란 한쪽 연결 종착역 재검수
9. 배송 전 노선 끝 ROUTE_END와 마지막 배송 SUCCESS 우선순위 확인
10. 분기 세 화살표·진입 방향 U턴·점유 잠금 확인
```

Android device smoke와 Five-person Comprehension은 별도 Gate로 계속 열린다.

## 금지

- `agent/pc-vertical-slice-demo-design`을 현재 사용자 실행 브랜치로 안내
- 이미 병합된 PR #83을 Draft·MAIN_PENDING으로 표시
- Fetch만 수행한 상태를 최신 파일 적용으로 간주
- F6 또는 별도 Scene 선택을 사용자 필수 절차로 안내
- 자동·export PASS를 수동 runtime PASS로 확대
- PC Demo 증거를 Android·HUMAN 증거로 대체
- 미병합 Base candidate SHA를 release pin으로 승격
- wrong `19Ff...` Sheet 변경
- legacy endless·fuel·BOOST 계약 재활성화
