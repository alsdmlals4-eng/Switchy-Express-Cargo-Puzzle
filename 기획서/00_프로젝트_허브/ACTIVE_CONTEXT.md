# Active Context

## 현재 상태

```yaml
project: Switchy Express: Cargo Puzzle
product_authority: GMB-002 · SX-DEC-027~036
demo_authority: SX-DEC-037 · EV-USER-023
current_audit: SX-AUD-020
feature_branch: agent/pc-vertical-slice-demo-design
latest_verified_commit: 8807cdbdd670a0cb67948e97f922c9bd9700e1a7
finite_automated_core: PASS
pc_vertical_slice_automated_core: PASS
default_project_play_boot: PASS · AUTOMATED
pc_windows_debug_export: PASS
pc_windows_artifact_integrity: PASS
pc_local_project_play_retest: FAIL · RETEST_REQUIRED
pc_windows_artifact_runtime_smoke: NOT_RUN
validation_preparation: PASS
canonical_main_apk_export: PASS
android_device_smoke: NOT_RUN · CURRENT_ANDROID_TRACK
five_person_comprehension: NOT_RUN · BLOCKED_BY_ANDROID
production_cutover: BLOCKED
pull_request_83: DRAFT
correct_sheet: 1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo
wrong_sheet: 19Ff... · DO_NOT_MODIFY
```

## Gate Summary

```text
FINITE AUTOMATED CORE: PASS
PC VERTICAL SLICE AUTOMATED CORE: PASS
DEFAULT PROJECT PLAY BOOT: PASS · AUTOMATED
PC WINDOWS DEBUG EXPORT·INTEGRITY: PASS
PC LOCAL PROJECT PLAY RETEST: FAIL · RETEST_REQUIRED
PC WINDOWS ARTIFACT RUNTIME·VISUAL·AUDIO SMOKE: NOT_RUN
ANDROID DEVICE SMOKE: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
PRODUCTION CUTOVER: BLOCKED
```

자동·패키징 PASS는 실제 사용자의 화면·음향·물리 입력·완주 PASS를 증명하지 않는다.

## 기본 사용자 실행 경로

```text
GitHub Desktop
→ repository: Switchy-Express-Cargo-Puzzle
→ branch: agent/pc-vertical-slice-demo-design
→ Fetch origin
→ Pull origin
→ Godot 4.7.1에서 project.godot 열기
→ 별도 Scene 선택 없이 Project Play(F5 / ▶)
→ Title → Briefing → BUILD → RUN → Result → Retry/Edit/Title
```

기본 `res://game/main/main.tscn`이 `VerticalSliceDemo`를 직접 포함한다. `res://game/demo/vertical_slice_demo.tscn`은 개발·테스트용 Scene으로 유지하지만 사용자 실행에 필요하지 않다.

## 최신 자동 증거

```yaml
commit: 8807cdbdd670a0cb67948e97f922c9bd9700e1a7
project_contract: 822 · PASS
godot_tests: 757 · PASS
godot_cases: 85
godot_assertions: 11284
godot_failures: 0
thin_adapter: 82 · PASS
asset_rights: 47 · PASS
windows_export: 40 · PASS
```

검증 범위:

- 기본 Project Play가 타이틀을 부트함
- 타이틀 → 브리핑 → gameplay 진입
- 제품 HUD와 BUILD toolbar가 visible 상태
- 기존 mouse·keyboard·touch command path
- 성공·실패·Retry/Edit/Title E2E
- 1280×720·1600×900·1920×1080 레이아웃
- Android validation feature override·package ID·proof map 보존

## 사용자가 발견한 실제 결함과 현재 판정

이전 로컬 커밋에서 타이틀 이후 보드만 표시되고 HUD·도구·조작 화면이 보이지 않았다.

```text
manual_runtime_result: FAIL · RETEST_REQUIRED
```

조치:

- HUD full anchors 명시
- HUD를 board 위 `z_index=10`에 고정
- 기본 `game/main/main.tscn`을 제품 부트스트랩으로 전환
- 기본 실행에서 gameplay·HUD·toolbar까지 확인하는 회귀 테스트 추가
- 전체 테스트 제한을 60초로 조정해 거짓 timeout 제거

최신 커밋을 사용자가 다시 실행하기 전에는 수동 PASS로 전환하지 않는다.

## 핵심 재미

```text
선로 건설로 화물 조우 순서 설계
→ 수동/자동 적재로 unlimited LIFO 구성
→ persistent branch와 역 방문 순서 실행
→ TOP 연속 동일 화물 하역
→ 제한 시간 안에 모든 배송 완료
→ 시간·건설비 기준으로 재설계
```

## Canonical Android Validation

```yaml
source_commit: 536911449018a3caf3511bc64e7bf1a66edf2016
apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
package_id: com.alsdmlals4.switchyexpress.validation
android_device_smoke: NOT_RUN
```

PC 기본 실행 변경은 Android validation launcher·feature override·package evidence와 분리되어 있다.

## 다음 정확한 작업

```text
1. 사용자 GitHub Desktop Fetch origin → Pull origin
2. 로컬 HEAD가 최신 전달 commit인지 확인
3. Godot 프로젝트 다시 열기
4. Project Play(F5 / ▶)
5. Title·Briefing·BUILD HUD와 도구 표시 확인
6. 선로 설치·운행·성공/실패·Retry/Edit 완주
7. 실제 결과를 PASS 또는 FAIL · RETEST_REQUIRED로 기록
```

Android device smoke와 Five-person Comprehension은 별도 Gate로 계속 열린다.

## 금지

- Fetch만 수행한 상태를 최신 적용으로 간주
- F6 또는 별도 Scene 선택을 사용자 필수 절차로 안내
- 자동·export PASS를 수동 runtime PASS로 확대
- PC Demo가 Android canonical 증거를 대체한다고 표현
- 사용자 실패 증거가 있는데 PR을 Ready 또는 수동 PASS로 유지
- wrong `19Ff...` Sheet 변경
- legacy endless·fuel·BOOST 계약 재활성화
