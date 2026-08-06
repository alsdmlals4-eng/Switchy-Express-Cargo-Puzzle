# SX-AUD-020 · PC Vertical Slice Implementation Audit

```yaml
audit_id: SX-AUD-020
decision_authority: SX-DEC-037
evidence_authority: EV-USER-023
scope: PC_VERTICAL_SLICE_DEMO_IMPLEMENTATION_AND_WINDOWS_DEBUG_EXPORT
repository: alsdmlals4-eng/Switchy-Express-Cargo-Puzzle
pull_request: 83
feature_head: 0f36ef9af5d37397e23272c40bb62c3599d2db37
pr_merge_test_sha: c6c9eb1ffcf755845872638478e6c1e431110b41
reviewed_at: 2026-08-06
result: AUTOMATED_AND_PACKAGE_PASS · MANUAL_RUNTIME_OPEN
```

## 1. 결론

```text
PC VERTICAL SLICE AUTOMATED CORE: PASS
PYTHON CONTRACTS: PASS · 56 passed · 1 skipped
GODOT HEADLESS: PASS · 85 cases · 11,258 assertions · 0 failures
LIVE-EDITOR PILOT REGRESSION: PASS
WINDOWS DEBUG EXPORT: PASS
WINDOWS ARTIFACT INTEGRITY: PASS
WINDOWS RUNTIME SMOKE: NOT_RUN
WINDOWS VISUAL·AUDIO REVIEW: NOT_RUN
ANDROID DEVICE SMOKE: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
DEFAULT ENTRYPOINT: LEGACY
PRODUCTION CUTOVER: BLOCKED
P0 OPEN: 0
P1 OPEN IN AUTOMATED SCOPE: 0
```

이 감사는 PC Demo의 자동 계약과 Windows debug 패키징·무결성을 승인한다. Windows 실제 실행, 화면·음향 품질, 물리 입력, Android 실기기, 처음 보는 사용자 이해도 또는 출시 준비를 승인하지 않는다.

## 2. 구현 범위

- `FiniteSliceSessionController`를 공용 application orchestration으로 추출했다.
- 기존 `game/finite/main/finite_slice.tscn`은 같은 controller를 사용하는 validation 호환 wrapper로 유지했다.
- 별도 `game/demo/vertical_slice_demo.tscn`에 Title → Briefing → BUILD → RUN → Result 흐름을 구성했다.
- 결과에서 같은 노선 재실행, 노선 수정, 타이틀 복귀를 지원한다.
- 마우스 중심 입력과 `1~4`, `R`, `Space`, `Shift`, `A`, `Esc`, `Enter` 키를 같은 finite command 경로에 연결했다.
- 기존 touch board/button command path를 유지했다.
- proof map과 분리된 `VS_DEMO_01@1` 및 서로 다른 두 성공 해법을 추가했다.
- 한국어 HUD, 색상+형상+텍스트 화물 표현, TOP 중복 표현, build ghost, 문제 셀, 열차·선로·역·화물 렌더링을 추가했다.
- Shell이 Pause·Result overlay를 단독 소유하도록 중복 화면을 제거했다.
- 우클릭 철거가 활성 도구로 선로를 순간 교체하지 않도록 선택 경로를 정리했다.
- Tween 연출과 `AudioStreamGenerator` 합성 음향은 domain state를 변경하지 않는 비권위 계층으로 고정했다.
- 1280×720, 1600×900, 1920×1080 레이아웃 계약과 최소 48px 조작 영역을 검증했다.
- Android Validation preset을 유지한 채 별도 `Windows Demo` preset과 export workflow를 추가했다.

## 3. 자동 검증 증거

### Godot Tests

```yaml
workflow: Godot Tests
run_id: 31065293026
run_number: 726
result: SUCCESS
engine: 4.7.1.stable.official.a13da4feb
cases: 85
assertions: 11258
failures: 0
```

새 적대적 회귀 계약도 모두 PASS했다.

- build ghost 유효/무효·비권위 계약
- player-facing 한국어 HUD와 영문 진단문 비노출
- Shell 단일 Pause/Result overlay 소유권
- 우클릭 exact-cell 철거
- Title/Briefing Enter·Esc 흐름
- project-owned Theme
- mouse/touch/Shift command parity
- 3개 해상도 responsive layout
- presentation/audio 호출 전후 domain snapshot 불변

### Python Contracts

```yaml
workflow: Windows Demo Export
run_id: 31065293030
result: SUCCESS
pytest: 56 passed · 1 skipped
```

검증 범위에는 Android preset 불변, Windows preset 격리, default entrypoint 불변, workflow pin·artifact 계약과 기존 프로젝트 Python 계약이 포함된다.

### Live-Editor Pilot Regression

```yaml
status: PASS
project_regression_cases: 85
project_regression_assertions: 11258
source_integrity: PASS
network_listener_enabled: false
production_adapter_ready: false
```

Pilot PASS는 외부 transport나 production editor adapter readiness를 의미하지 않는다.

## 4. Windows artifact 증거

```yaml
workflow: Windows Demo Export
run_id: 31065293030
run_number: 22
artifact_id: 8953621440
artifact_name: switchy-express-windows-demo-c6c9eb1ffcf755845872638478e6c1e431110b41
artifact_size_bytes: 35768268
artifact_zip_sha256: 7c44092b3837d84d3f027fc1625aaccaa1543d5307a174eda37824b27889af9e
artifact_expiry: 2026-08-20T02:20:34Z
exe_size_bytes: 102982144
exe_sha256: 1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244
pck_size_bytes: 685844
pck_sha256: 66ffec232a851d1858da6a5bc0b90ca3c3e4b3769dc472fe1e97a15c0a82c741
```

다운로드한 ZIP을 독립적으로 해제해 다음을 확인했다.

1. `SwitchyExpressVerticalSlice.exe`, `SwitchyExpressVerticalSlice.pck`, `SHA256SUMS.txt` 존재
2. ZIP 실제 SHA-256과 GitHub artifact digest 일치
3. EXE/PCK 실제 SHA-256과 `SHA256SUMS.txt` 일치
4. 두 실행 파일이 모두 non-empty

이 증거는 생성·구성·무결성을 증명하지만 Windows에서 실제 프로세스가 정상 실행되고 화면·음향·입력이 적절하다는 사실은 증명하지 않는다.

## 5. 보호 경계 검증

```text
project.godot default run/main_scene: UNCHANGED · LEGACY
Android Validation preset: PRESERVED
Android package ID: PRESERVED
canonical Android APK/hash: PRESERVED
fp_core_proof_01.json: UNCHANGED
finite product rules: UNCHANGED
validation scene path: PRESERVED
```

PC Demo는 Godot `Run Current Scene(F6)` 또는 Windows Demo preset으로만 진입한다. 기본 F5 진입점 전환은 별도 production-cutover 결정이 필요하다.

## 6. 자산 권리

- 보드·마커·UI는 Godot draw primitive와 `StyleBoxFlat`로 repository source에서 생성한다.
- 음향은 `AudioStreamGenerator`로 repository-defined frequency·envelope를 합성한다.
- 외부 이미지, texture, model, font file, music sample, voice, AI-generated media를 포함하지 않는다.
- 권리 원장은 `VS-DEMO-PRESENTATION-001`, `VS-DEMO-AUDIO-001`로 기록한다.

## 7. 적대적 검토 결과

수정 완료:

- Pause/Result overlay 중복 소유권
- 우클릭 철거 중 transient replacement 가능성
- Title/Briefing keyboard confirm/cancel 누락
- preflight 영문 진단문 노출
- 기본 Godot Theme 의존
- build ghost preview 누락
- 숨김 화면 버튼을 responsive 검사에 포함한 fixture 오류
- Base Adapter/Pilot 일회성 CI가 일반 기능 PR을 막는 범위 결함
- 기능 브랜치에 main 소유 Base/Pilot 파일이 섞인 diff 오염

현재 자동 범위에서 Critical/P0 또는 Important/P1 미해결 결함은 발견되지 않았다.

## 8. 미검증·차단 항목

```yaml
windows_runtime_smoke: NOT_RUN
windows_visual_audio_review: NOT_RUN
windows_physical_mouse_keyboard: NOT_RUN
android_device_smoke: NOT_RUN
five_person_comprehension: NOT_RUN
final_art_icon: NOT_RUN
production_default_cutover: BLOCKED
store_release_candidate: NOT_CREATED
```

권장 다음 순서:

```text
Windows artifact 실제 실행
→ Title/Briefing/BUILD/RUN/Result/Retry/Edit 1회 완주
→ 1280×720 이상에서 화면·음향·마우스·키보드 확인
→ 발견 결함을 별도 TDD 수정
→ PR #83 merge review
```

Android Gate는 기존 canonical APK SHA-256을 사용하는 별도 트랙으로 계속 열린다.
