# Finite Delivery First Vertical Slice Contract

```yaml
status: PC_AUTOMATED_AND_PACKAGE_PASS · ANDROID_APK_EXPORT_PASS · MANUAL_ACCEPTANCE_OPEN
product_authority: GMB-002 · SX-DEC-027~036
pc_demo_authority: SX-DEC-037 · EV-USER-023
execution_authority: FP-DOR-001 · EV-USER-021 · EV-USER-022
current_audits: SX-AUD-019 · SX-AUD-020
canonical_android_export_source: 536911449018a3caf3511bc64e7bf1a66edf2016
implementation_state: FINITE_CORE_PASS · VALIDATION_PREP_PASS · ANDROID_APK_EXPORT_PASS · PC_VERTICAL_SLICE_AUTOMATED_PASS · WINDOWS_EXPORT_INTEGRITY_PASS
default_entrypoint: LEGACY_RUNTIME_DEFAULT
next_pc_gate: WINDOWS_RUNTIME_VISUAL_AUDIO_SMOKE
next_android_gate: ANDROID_DEVICE_SMOKE → FIVE_PERSON_COMPREHENSION
cutover_status: BLOCKED
```

## 1. 목적과 권위

이 계약은 유한 배송 퍼즐 코어, Android validation package, 별도 PC Vertical Slice Demo의 구현·패키징 완료 범위와 제품 전환 조건을 정의한다. 자동 테스트, export 생성, 실제 기기 실행, 처음 보는 사용자의 이해도와 production cutover는 서로 다른 Gate다.

권위 문서:

- `기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md`
- `docs/superpowers/specs/2026-08-06-pc-vertical-slice-demo-design.md`
- `docs/superpowers/plans/2026-08-06-pc-vertical-slice-demo.md`
- `기획서/50_제작_검증/SX_DEC_037_PC_VERTICAL_SLICE_APPROVAL_LEDGER.md`
- `기획서/50_제작_검증/SX_AUD_020_PC_VERTICAL_SLICE_IMPLEMENTATION_AUDIT.md`
- `기획서/50_제작_검증/SX_AUD_019_ANDROID_APK_PIPELINE_PROBE.md`
- `기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_RUNBOOK.md`

## 2. Finite Product Contract

### BUILD

- authored `FiniteMapDefinition` schema v2
- 직선·곡선·분기·교차 설치, 회전, 교체, 철거, 전체 초기화
- 조각별 비용·철거 전액 환급
- 시작 연결, 역·화물 도달성, dangling edge, crossing, branch exit, permanent trap 구조 검사
- PASS 뒤 정의·배치·비용·graph 봉인

### RUN

- 기차 자동 운행
- 수동 LOAD hold·auto-load toggle
- 무제한 LIFO stack과 고정 화물
- cargo point 적재 전용·station 하역 전용
- TOP 연속 동일 화물 그룹 하역·최대 1초 표시
- 정확한 제한 시간·pause·success/failure
- 동일 배치 fresh-runtime retry
- map·solution·attempt identity 분리

Legacy `fuel`, `BOOST`, capacity 8, cargo slowdown, timed pressure, pickup respawn, switch auto-reset, endless score는 current contract가 아니다.

## 3. PC Vertical Slice Demo Contract

### Product shell

- Scene: `res://game/demo/vertical_slice_demo.tscn`
- flow: Title → Briefing → BUILD → RUN → Result
- result actions: Retry same layout · Edit layout · Title
- Run Current Scene(F6) 전용
- default F5 entrypoint는 legacy 유지

### Presentation·input

- mouse-first + keyboard shortcuts + existing touch path
- Korean player-facing HUD
- 색상+형상+텍스트 cargo/station 표현
- LIFO TOP 중복 표현
- build ghost, hover, selection, problem cells, train, track, switch
- Shell 단일 Pause/Result overlay 소유권
- 1280×720, 1600×900, 1920×1080 responsive contract
- 최소 48px 상당 조작 영역
- project-owned Theme, Tween effects, procedural audio
- UI·effects·audio는 domain result를 결정하지 않는다.

### Content

- map: `res://data/maps/vs_demo_01.json`
- identity: `VS_DEMO_01@1`
- one representative stage
- two authored successful solution variants
- proof map `fp_core_proof_01.json` 불변

## 4. Automated Evidence

| Gate | 상태 | 증거 |
|---|---|---|
| FINITE AUTOMATED CORE | PASS | 기존 SX-AUD-017~019 + current regression |
| PC VERTICAL SLICE AUTOMATED | PASS | Godot run `31065293026`, `85 cases · 11,258 assertions` |
| PYTHON CONTRACTS | PASS | Windows run `31065293030`, `56 passed · 1 skipped` |
| LIVE-EDITOR REGRESSION | PASS | source integrity + same `85/11,258` project regression |
| WINDOWS DEBUG EXPORT | PASS | Windows run `31065293030` |
| WINDOWS ARTIFACT INTEGRITY | PASS | ZIP/EXE/PCK actual hashes independently matched |
| WINDOWS RUNTIME | NOT_RUN | Windows machine execution required |
| ANDROID APK EXPORT | PASS | canonical Android run `31011620357` |
| ANDROID DEVICE | NOT_RUN | physical landscape device required |
| HUMAN | NOT_RUN | Android reviewed PASS 뒤 first-contact 5명 |
| PRODUCTION CUTOVER | BLOCKED | manual Gates and separate approval required |

## 5. Windows Artifact Contract

```yaml
workflow_run_id: 31065293030
artifact_id: 8953621440
artifact_name: switchy-express-windows-demo-c6c9eb1ffcf755845872638478e6c1e431110b41
artifact_expiry: 2026-08-20T02:20:34Z
artifact_zip_sha256: 7c44092b3837d84d3f027fc1625aaccaa1543d5307a174eda37824b27889af9e
exe_file: SwitchyExpressVerticalSlice.exe
exe_sha256: 1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244
pck_file: SwitchyExpressVerticalSlice.pck
pck_sha256: 66ffec232a851d1858da6a5bc0b90ca3c3e4b3769dc472fe1e97a15c0a82c741
```

EXE와 PCK는 같은 디렉터리에 있어야 한다. 이 계약은 package integrity까지만 승인하며 process launch·화면·음향·물리 입력을 승인하지 않는다.

## 6. Canonical Android Contract

```yaml
source_commit: 536911449018a3caf3511bc64e7bf1a66edf2016
workflow_run_id: 31011620357
artifact_id: 8932725351
apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
artifact_zip_sha256: 1802ca52dd90eb674f89b0a6e4678152d314c5644d135a84033388b4d3ee7193
package_id: com.alsdmlals4.switchyexpress.validation
```

PC Demo preset·artifact는 canonical Android APK와 device/HUMAN evidence를 대체하지 않는다.

## 7. Manual Gate Contracts

### PC Windows Runtime Smoke

- [ ] EXE/PCK 동일 디렉터리
- [ ] 실행·종료
- [ ] Title/Briefing/BUILD/RUN/Result
- [ ] Retry same layout·Edit layout·Title
- [ ] mouse·keyboard physical input
- [ ] clipping·overlap·readability
- [ ] audio cue·train loop·pause·success/failure
- [ ] crash·script error·severe frame degradation 없음

### Android Device Smoke

- [ ] full canonical APK SHA-256 match
- [ ] physical Android landscape device
- [ ] AND-01~20 all executed
- [ ] `PROOF / STACK 8 / STACK 16 / STACK 32 / Back`
- [ ] BUILD→RUN→pause/resume→result→retry/edit
- [ ] LOAD hold·auto-load·branch direct tap
- [ ] safe area·48dp touch·clipping·overlap
- [ ] crash·ANR·입력 누락·심각한 frame 저하 없음

### Five-person Comprehension

Android reviewed PASS 뒤 동일 APK SHA-256으로 수행한다.

- [ ] P01~P05 first-contact sessions
- [ ] 4/5+ explain last-loaded cargo as TOP
- [ ] 4/5+ explain A revisit requirement
- [ ] failure recovery and retry comprehension
- [ ] shape/text identification without color-only dependence

## 8. Cutover Conditions

별도 production-cutover PR은 다음 모두 충족 후에만 생성한다.

1. finite automated core PASS
2. Android validation prep/export PASS
3. Android Device Smoke PASS
4. Five-person Comprehension PASS
5. Critical/Important 결함 0
6. unresolved review thread 0·REQUEST_CHANGES 0
7. build/hash/device/human evidence 기록
8. GitHub 정본·correct Google Sheet same-ID sync
9. 별도 사용자 승인

PC Demo merge는 default cutover가 아니다. `game/main/main.tscn` 전환은 이 계약에 포함되지 않는다.

## 9. Rollback·Security·Rights

- debug artifacts는 store release candidate가 아니다.
- release key·credential·사용자 SDK 경로를 저장하지 않는다.
- validation package ID와 Android preset을 유지한다.
- external image, texture, model, font file, music sample, voice, AI media를 PC Demo에 포함하지 않는다.
- procedural presentation/audio rights는 `VS-DEMO-PRESENTATION-001`, `VS-DEMO-AUDIO-001`로 기록한다.

## 10. Current Conclusion

```text
FINITE CORE IMPLEMENTATION: PASS
PC VERTICAL SLICE AUTOMATED CORE: PASS
PC WINDOWS DEBUG EXPORT·INTEGRITY: PASS
PC WINDOWS RUNTIME SMOKE: NOT_RUN
ANDROID VALIDATION PREPARATION: PASS
ANDROID APK EXPORT: PASS
ANDROID DEVICE SMOKE: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
DEFAULT ENTRYPOINT: LEGACY
PRODUCTION CUTOVER: BLOCKED
```

다음 실행은 PC Windows smoke와 Android canonical APK device smoke를 서로 독립적으로 수행하는 것이다.
