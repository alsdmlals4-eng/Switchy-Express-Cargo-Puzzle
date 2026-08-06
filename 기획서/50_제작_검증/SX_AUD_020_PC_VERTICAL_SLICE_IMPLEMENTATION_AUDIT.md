# SX-AUD-020 · PC Vertical Slice Implementation Audit

```yaml
audit_id: SX-AUD-020
decision_authority: SX-DEC-037
evidence_authority: EV-USER-023
scope: PC_VERTICAL_SLICE · DEFAULT_PROJECT_PLAY · WINDOWS_DEBUG_EXPORT
repository: alsdmlals4-eng/Switchy-Express-Cargo-Puzzle
pull_request: 83
feature_branch: agent/pc-vertical-slice-demo-design
latest_verified_commit: 8807cdbdd670a0cb67948e97f922c9bd9700e1a7
reviewed_at: 2026-08-06
result: AUTOMATED_AND_PACKAGE_PASS · LOCAL_RUNTIME_RETEST_REQUIRED
```

## 1. 결론

```text
PC VERTICAL SLICE AUTOMATED CORE: PASS
DEFAULT PROJECT PLAY BOOT: PASS · AUTOMATED
GODOT HEADLESS: PASS · 85 cases · 11,284 assertions · 0 failures
PROJECT CONTRACT: PASS · #822
THIN ADAPTER: PASS · #82
ASSET RIGHTS: PASS · #47
WINDOWS DEBUG EXPORT: PASS · #40
PC LOCAL PROJECT PLAY: FAIL · RETEST_REQUIRED
WINDOWS ARTIFACT RUNTIME SMOKE: NOT_RUN
ANDROID DEVICE SMOKE: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
PRODUCTION CUTOVER: BLOCKED
PR #83: DRAFT
```

자동 계약과 Windows 패키징은 통과했다. 그러나 사용자가 이전 로컬 커밋에서 타이틀 이후 HUD·도구·입력 표면 누락을 직접 확인했으므로 실제 로컬 실행 Gate는 `FAIL · RETEST_REQUIRED`다. 최신 커밋을 Fetch/Pull한 뒤 F5로 다시 완주하기 전에는 수동 PASS 또는 PR Ready를 주장하지 않는다.

## 2. 구현 범위

- 공용 `FiniteSliceSessionController`와 validation wrapper parity
- `VS_DEMO_01@1` 및 서로 다른 두 성공 해법
- Title → Briefing → BUILD → RUN → Result → Retry/Edit/Title
- mouse-first, keyboard shortcuts, touch command parity
- 한국어 HUD, Theme, TOP, build ghost, 문제 셀, 선로·열차·역·화물 렌더링
- Shell 단일 Pause·Result overlay
- 비권위 Tween·procedural audio
- 1280×720·1600×900·1920×1080 responsive contract
- 별도 Windows Demo export
- Android validation feature override·package ID·proof map 보존

## 3. One-click Project Play 전환

기본 `project.godot`은 계속 다음 entrypoint를 사용한다.

```text
res://game/main/main.tscn
```

`game/main/main.tscn`은 이제 `VerticalSliceDemo`를 직접 포함한다.

```text
Godot 프로젝트 열기
→ Project Play(F5 / ▶)
→ TITLE
→ BRIEFING
→ GAMEPLAY
→ HUD·BUILD toolbar
→ RUN·Result·Retry/Edit/Title
```

사용자는 별도 Scene을 선택하거나 Project Settings를 바꿀 필요가 없다. `res://game/demo/vertical_slice_demo.tscn`은 개발·테스트용 독립 Scene으로만 유지한다.

## 4. 사용자가 발견한 결함

```yaml
finding: HUD_AND_INTERACTION_SURFACE_MISSING_AFTER_BUILD_ENTRY
observed_environment: USER_LOCAL_GODOT
previous_result: FAIL
current_status: RETEST_REQUIRED
```

관찰:

- 타이틀은 표시됨
- 데모 시작 뒤 board grid는 표시됨
- HUD, 선로 도구, 상태표시, 입력 표면이 보이지 않음

수정:

1. `ProductHUD` full anchors 명시
2. HUD를 board보다 높은 `z_index=10`에 고정
3. 기본 `Main` Scene을 제품 부트스트랩으로 전환
4. 기본 실행에서 TITLE→BRIEFING→GAMEPLAY·HUD·toolbar를 확인하는 테스트 추가
5. 기존 성공·실패·Retry/Edit E2E와 결합
6. 늘어난 회귀 suite가 거짓 timeout되지 않도록 외부 제한 30초→60초

## 5. 최신 자동 증거

```yaml
commit: 8807cdbdd670a0cb67948e97f922c9bd9700e1a7
project_contract_run_number: 822
godot_tests_run_number: 757
godot_cases: 85
godot_assertions: 11284
godot_failures: 0
thin_adapter_run_number: 82
asset_rights_run_number: 47
windows_export_run_number: 40
```

자동 검증은 다음을 포함한다.

- default `application/run/main_scene`
- `Main/VerticalSliceDemo` 생성
- TITLE state
- BRIEFING·GAMEPLAY 전환
- product HUD와 BUILD toolbar visible
- mouse·keyboard·touch 명령
- 대표 성공·실패·Retry/Edit/Title
- responsive layout와 HUD z-order
- Android validation entrypoint·preset·package ID 보존

## 6. 보호 경계

```text
finite product rules: UNCHANGED
fp_core_proof_01.json: UNCHANGED
Android validation launcher: PRESERVED
Android validation feature override: PRESERVED
Android package ID: PRESERVED
canonical Android APK/hash: PRESERVED
store production cutover: NOT_PERFORMED
```

기본 PC Project Play 전환은 일반 사용자 검수 진입점만 바꾸며 Android validation evidence를 대체하지 않는다.

## 7. 자산 권리

- Godot draw primitive·StyleBoxFlat 기반 UI/보드
- `AudioStreamGenerator` 기반 procedural audio
- 외부 이미지·모델·폰트·음원·AI media 없음
- 권리 원장: `VS-DEMO-PRESENTATION-001`, `VS-DEMO-AUDIO-001`

## 8. 사용자 재검수 절차

```text
1. Godot 실행 종료
2. GitHub Desktop에서 Switchy-Express-Cargo-Puzzle 선택
3. branch: agent/pc-vertical-slice-demo-design
4. Fetch origin
5. Pull origin
6. Godot 4.7.1에서 project.godot 다시 열기
7. 별도 Scene 선택 없이 Project Play(F5 / ▶)
8. Title → Briefing → BUILD
9. 상단 상태·하단 도구·오른쪽 TOP 패널 확인
10. 선로 설치 → 운행 → 성공/실패 → Retry/Edit 확인
```

재검수 결과:

```yaml
result: NOT_RETESTED_YET
allowed_next_values: PASS | FAIL · RETEST_REQUIRED | BLOCKED
```

## 9. 남은 Gate

```yaml
pc_local_project_play_retest: FAIL · RETEST_REQUIRED
windows_artifact_runtime_visual_audio_input: NOT_RUN
android_device_smoke: NOT_RUN
five_person_comprehension: NOT_RUN
production_cutover: BLOCKED
```

PR #83은 Draft를 유지한다.
