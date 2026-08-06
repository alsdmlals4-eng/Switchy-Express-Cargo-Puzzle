# Active Context

## 현재 상태

```yaml
project: Switchy Express: Cargo Puzzle
product_authority: GMB-002 · SX-DEC-027~036
demo_authority: SX-DEC-037 · EV-USER-023
current_audit: SX-AUD-020
finite_automated_core: PASS
pc_vertical_slice_automated_core: PASS
pc_windows_debug_export: PASS
pc_windows_artifact_integrity: PASS
pc_windows_runtime_smoke: NOT_RUN
validation_preparation: PASS
canonical_main_apk_export: PASS
android_device_smoke: NOT_RUN · CURRENT_ANDROID_TRACK
five_person_comprehension: NOT_RUN · BLOCKED_BY_ANDROID
default_entrypoint: LEGACY_RUNTIME_DEFAULT
production_cutover: BLOCKED
canonical_android_export_source: 536911449018a3caf3511bc64e7bf1a66edf2016
canonical_android_apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
android_package_id: com.alsdmlals4.switchyexpress.validation
```

## Gate Summary

```text
FINITE AUTOMATED CORE: PASS
PC VERTICAL SLICE AUTOMATED CORE: PASS
PC WINDOWS DEBUG EXPORT: PASS
PC WINDOWS ARTIFACT INTEGRITY: PASS
PC WINDOWS RUNTIME·VISUAL·AUDIO SMOKE: NOT_RUN
VALIDATION PREPARATION: PASS
CANONICAL MAIN APK EXPORT: PASS
ANDROID DEVICE SMOKE: NOT_RUN · CURRENT_ANDROID_TRACK
FIVE-PERSON COMPREHENSION: NOT_RUN · BLOCKED_BY_ANDROID
DEFAULT ENTRYPOINT: LEGACY
PRODUCTION CUTOVER: BLOCKED
```

PC 자동·패키징 PASS는 Windows 실제 실행, Android 실기기, 사람 이해도 또는 production readiness를 증명하지 않는다.

## 현재 핵심 재미

```text
선로 건설로 화물 조우 순서 설계
→ 수동/자동 적재로 unlimited LIFO 구성
→ persistent branch와 역 방문 순서 실행
→ TOP 연속 동일 화물 하역
→ 제한 시간 안에 모든 배송 완료
→ 시간·건설비·점수별 재설계와 기록 경쟁
```

자동화·메타·콘텐츠 양은 이 순서를 학습·반복·확장해야 하며 대체하면 안 된다.

## PC Vertical Slice · AUTOMATED AND PACKAGE PASS

Authority:

- `docs/superpowers/specs/2026-08-06-pc-vertical-slice-demo-design.md`
- `docs/superpowers/plans/2026-08-06-pc-vertical-slice-demo.md`
- `기획서/50_제작_검증/SX_DEC_037_PC_VERTICAL_SLICE_APPROVAL_LEDGER.md`
- `기획서/50_제작_검증/SX_AUD_020_PC_VERTICAL_SLICE_IMPLEMENTATION_AUDIT.md`

Implemented:

- Title → Briefing → BUILD → RUN → Result → Retry/Edit/Title
- 공용 `FiniteSliceSessionController`와 validation wrapper parity
- `VS_DEMO_01@1` 및 서로 다른 두 성공 해법
- 마우스·키보드·기존 touch command parity
- 한국어 HUD, TOP 표현, Theme, build ghost, responsive layout
- 비권위 Tween 연출과 procedural audio
- 별도 Windows Demo preset과 artifact
- Android preset·proof map·default main 불변

Evidence:

```yaml
feature_head: 0f36ef9af5d37397e23272c40bb62c3599d2db37
project_contract_run: 31065293042
Godot_tests_run: 31065293026
Godot_cases: 85
Godot_assertions: 11258
Python_contracts: 56_passed · 1_skipped
windows_export_run: 31065293030
windows_artifact_id: 8953621440
windows_artifact_zip_sha256: 7c44092b3837d84d3f027fc1625aaccaa1543d5307a174eda37824b27889af9e
windows_exe_sha256: 1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244
windows_pck_sha256: 66ffec232a851d1858da6a5bc0b90ca3c3e4b3769dc472fe1e97a15c0a82c741
```

## Canonical Android Validation · EXPORT PASS

```yaml
workflow_run_id: 31011620357
source_commit: 536911449018a3caf3511bc64e7bf1a66edf2016
apk_size_bytes: 28771631
apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
artifact_zip_sha256: 1802ca52dd90eb674f89b0a6e4678152d314c5644d135a84033388b4d3ee7193
attestation_id: 39044925
artifact_expiry: 2026-08-19T13:45:27Z
```

이 증거는 Android 패키징과 provenance만 증명한다.

## 현재 수동 실행 권위

### PC Track

```text
Windows artifact 다운로드·해시 확인
→ EXE와 PCK를 같은 폴더에 유지
→ Title/Briefing/BUILD/RUN/Result/Retry/Edit 완주
→ 화면·음향·마우스·키보드·종료 확인
→ 실제 결과에 따른 PASS / FAIL / BLOCKED 판정
```

### Android Track

정본 실행 문서:

- `기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_RUNBOOK.md`
- `기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_EVIDENCE_TEMPLATE.md`
- `기획서/50_제작_검증/SX_AUD_019_ANDROID_APK_PIPELINE_PROBE.md`

```text
full canonical APK SHA-256 확인
→ physical Android landscape device에서 AND-01~20
→ 영상·스크린샷·로그 completeness·privacy review
→ reviewed Gate decision
```

## 현재 미검증

```yaml
windows_runtime_smoke: NOT_RUN
windows_visual_audio_review: NOT_RUN
windows_physical_input: NOT_RUN
android_device_smoke: NOT_RUN
five_person_comprehension: NOT_RUN
production_default_cutover: BLOCKED
final_art_and_icon: NOT_RUN
platform_submission_and_rating: NOT_RUN
release_asset_rights_audit: NOT_RUN
official_map_target_100: NOT_RUN
online_challenge_and_ugc: NOT_RUN
```

## Historical implementation boundary

```text
old VS03 package order: HISTORICAL_REPLACED
endless survival: LEGACY_IMPLEMENTATION
fuel and fuel-zero: LEGACY_IMPLEMENTATION
player BOOST: LEGACY_IMPLEMENTATION
capacity eight: LEGACY_IMPLEMENTATION
cargo-count slowdown: LEGACY_IMPLEMENTATION
pickup respawn: LEGACY_IMPLEMENTATION
switch auto-reset: LEGACY_IMPLEMENTATION
```

## 다음 정확한 작업

```text
PC Windows runtime smoke
+ Android canonical APK device smoke는 독립적으로 계속 진행
→ 각각의 evidence review
→ Android PASS 뒤 Five-person Comprehension
→ 별도 production cutover review
```

## 금지

- Windows export PASS를 Windows runtime PASS로 표현
- PC Demo가 Android canonical 증거를 대체한다고 표현
- 새 APK에 이전 device/human 증거 자동 승계
- emulator를 physical-device PASS로 표현
- 부분 실행을 전체 PASS로 표현
- 기본 진입점 변경을 현재 package에 포함
- Android PASS를 HUMAN·cutover PASS로 확대
- wrong `19Ff...` Sheet 변경
- historical VS03·fuel·BOOST 계약 재활성화
