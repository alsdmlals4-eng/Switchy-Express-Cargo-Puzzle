# Finite Delivery First Vertical Slice Contract

```yaml
status: APK_EXPORT_PASS · MANUAL_ACCEPTANCE_OPEN
product_authority: GMB-002 · SX-DEC-027~036
execution_authority: FP-DOR-001 · EV-USER-021 · EV-USER-022
current_audit: SX-AUD-019
canonical_export_source: 536911449018a3caf3511bc64e7bf1a66edf2016
implementation_state: FP-01_PASS · FP-02_PASS · PRODUCT_SURFACE_PASS · AUTOMATED_INTEGRATION_PASS · VALIDATION_PREP_PASS · APK_EXPORT_PASS
default_entrypoint: LEGACY_RUNTIME_DEFAULT
next_gate: ANDROID_DEVICE_SMOKE → FIVE_PERSON_COMPREHENSION
cutover_status: BLOCKED
```

## 1. 목적과 권위

이 계약은 첫 유한 배송 퍼즐 Slice의 구현·패키징 완료 범위와 제품 전환 조건을 정의한다. 자동 테스트, APK 생성, 실기기 조작성, 처음 보는 사용자의 이해도와 production cutover를 서로 다른 Gate로 유지한다.

권위 문서:

- `기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md`
- `docs/superpowers/specs/2026-08-04-finite-puzzle-definition-of-ready-design.md`
- `docs/superpowers/plans/2026-08-05-finite-puzzle-first-vertical-slice.md`
- `docs/superpowers/specs/2026-08-05-finite-validation-harness-design.md`
- `docs/superpowers/plans/2026-08-05-finite-validation-harness.md`
- `docs/superpowers/specs/2026-08-05-android-validation-apk-ci-design.md`
- `docs/superpowers/plans/2026-08-05-android-validation-apk-ci.md`
- `기획서/50_제작_검증/FP_01_02_IMPLEMENTATION_AUDIT.md`
- `기획서/50_제작_검증/SX_AUD_018_VALIDATION_PREPARATION_AUDIT.md`
- `기획서/50_제작_검증/SX_AUD_019_ANDROID_APK_PIPELINE_PROBE.md`

## 2. 구현 완료 범위

### FP-01 · 선로 건설

- authored `FiniteMapDefinition` schema v2
- `TrackLayout` identity·solution signature
- 직선·곡선·분기·교차 설치, 회전, 교체, 철거, 전체 초기화
- 조각별 비용·철거 전액 환급
- 시작 연결, 역·화물 도달성, dangling edge, crossing, branch exit, permanent trap 구조 검사
- PASS 뒤 정의·배치·비용·graph 봉인

### FP-02 · 유한 배송 런

- 기차 자동 운행
- 수동 LOAD hold·auto-load toggle
- 무제한 LIFO stack과 고정 화물
- cargo point 적재 전용·station 하역 전용
- TOP 연속 동일 화물 그룹 하역·최대 1초 표시
- 정확한 제한 시간·pause·success/failure
- 동일 배치 fresh runtime retry
- map·solution·attempt identity 분리

### 제품 화면·통합

- BUILD/RUNNING/UNLOADING/PAUSED/SUCCESS/FAILURE
- 비용·추천 비용·preflight 문제 표시
- 색상+형상+텍스트와 LIFO TOP 중복 표현
- 최소 48×48dp 상당 조작 영역
- RUNNING/UNLOADING branch 직접 탭과 점유 잠금
- UI 명령으로 `A → B → A → A`, 하역 `2 → 1 → 1`, A역 재방문·성공 증명
- crossing 격리, pause integrity, 실패 후 배치 보존·retry 초기화

## 3. Validation·APK 완료 범위

- 제품과 분리된 validation launcher
- 한 APK의 `PROOF`, `STACK_8`, `STACK_16`, `STACK_32`
- 기기 내 mode selector와 Back
- invalid mode fail-closed
- `validation_harness` custom feature와 격리 package ID
- product main·`game/main/main.tscn` 불변 검사
- 고정된 Godot/JDK/Android SDK·Build Tools·NDK·template workflow
- export 전 전체 테스트와 product invariant 검사
- APK·SHA-256·manifest·summary·14일 artifact·provenance attestation

Canonical APK:

```yaml
source_commit: 536911449018a3caf3511bc64e7bf1a66edf2016
workflow_run_id: 31011620357
artifact_id: 8932725351
artifact_name: switchy-express-validation-53691144
apk_size_bytes: 28771631
apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
artifact_zip_sha256: 1802ca52dd90eb674f89b0a6e4678152d314c5644d135a84033388b4d3ee7193
attestation_id: 39044925
expiry: 2026-08-19T13:45:27Z
```

## 4. 검증 Gate

| Gate | 상태 | 증거/기준 |
|---|---|---|
| AUTOMATED CORE | PASS | Contract #490, Godot #451, `60 cases · 10,382 assertions` |
| VALIDATION PREP | PASS | PR #62/#63, Contract #508, Godot #464, `63 cases · 10,714 assertions` |
| SELECTOR·APK WORKFLOW STATIC | PASS | PR #65/#66/#69/#70/#71와 TDD RED/GREEN |
| APK EXPORT | PASS | main run `31011620357`, `65 cases · 10,792 assertions`, APK hash·manifest·attestation 일치 |
| ANDROID | NOT_RUN | 동일 APK hash로 landscape 실기기 smoke 필요 |
| HUMAN | NOT_RUN | 동일 APK hash로 처음 보는 5명 이해도 검증 필요 |
| BALANCE | NOT_RUN | First Slice cutover 필수 Gate 아님 |
| ONLINE | NOT_RUN | First Slice 범위 밖 |
| FINAL ART | NOT_RUN | 후속 제작 Gate |

## 5. Android Device Smoke 계약

동일 APK SHA-256 `eb49225a...759ea`에서 다음을 기록한다.

1. 기기 모델·Android 버전·해상도·orientation
2. 설치·첫 부팅·재부팅
3. 4개 mode와 Back
4. BUILD→RUN→pause/resume→result→retry
5. LOAD hold·auto-load·branch 직접 탭
6. 8/16/32 stack TOP 가독성
7. safe area·48dp 터치·겹침·잘림
8. crash·ANR·입력 누락·심각한 frame 저하

실패 시 같은 APK 증거를 보존하고 수정 package를 TDD로 분리한다. 새 APK가 생성되면 hash가 바뀌므로 Android·HUMAN 증거를 새 hash로 다시 수행한다.

## 6. 제외·Legacy 격리

후속 범위:

- 가속·저비용·일방통행·회차·터널·교량
- Combo 가속·점수 보상
- 별·랭킹·튜토리얼·캠페인·일일/주간·online·UGC
- 최종 아트와 광범위 balance

`fuel`, `BOOST`, capacity 8, cargo slowdown, timed pressure, pickup respawn, switch auto-reset, endless score는 `[대체됨 · 역사 증거]`다. legacy와 finite 규칙을 한 player-facing session에 혼합하지 않고, old 테스트를 finite PASS 수치에 합산하지 않는다.

## 7. Cutover 조건

별도 production-cutover PR은 다음 모두 충족 후에만 생성한다.

1. AUTOMATED CORE PASS
2. VALIDATION PREP PASS
3. APK EXPORT PASS
4. ANDROID PASS
5. HUMAN PASS
6. Critical/Important 결함 0
7. unresolved review thread 0·REQUEST_CHANGES 0
8. build SHA·APK hash·기기·사람 증거 기록
9. GitHub 권위 문서·correct Google Sheet same-ID 동기화

cutover는 `game/main/main.tscn`과 최소 어댑터만 변경한다. legacy 삭제는 별도 migration package다.

## 8. Rollback·보안 경계

- validation APK는 debug QA artifact이며 release candidate나 store binary가 아니다.
- release key·고정 credential·SDK 사용자 경로를 저장하지 않는다.
- production base main은 계속 `res://game/main/main.tscn`이다.
- cutover 전 장애는 validation workflow/override만 되돌리고 finite core를 보존한다.
- old endless 파일은 삭제하지 않는다.

## 9. 현재 결론

```text
FINITE CORE IMPLEMENTATION: PASS
FINITE PRODUCT SURFACE: PASS
INTEGRATED AUTOMATION: PASS
VALIDATION PREPARATION: PASS
ANDROID APK EXPORT: PASS
ANDROID DEVICE SMOKE: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
DEFAULT ENTRYPOINT: LEGACY
PRODUCTION CUTOVER: BLOCKED
```

다음 권위 작업은 canonical APK hash를 유지한 Android landscape smoke다.
