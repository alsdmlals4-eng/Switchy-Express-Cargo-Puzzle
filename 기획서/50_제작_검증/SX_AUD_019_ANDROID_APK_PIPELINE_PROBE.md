# SX-AUD-019 · Android Validation APK Pipeline and Canonical Export Audit

```yaml
audit_id: SX-AUD-019
evidence_ids: EV-FP-APK-PROBE-001 · EV-FP-APK-001
product_authority: GMB-002 · SX-DEC-027~036
execution_authority: FP-DOR-001 · EV-USER-021 · EV-USER-022
canonical_export_source: 536911449018a3caf3511bc64e7bf1a66edf2016
status: APK_PIPELINE_RUNTIME_PROBE_PASS · CANONICAL_APK_EXPORT_PASS
validation_prep: PASS
apk_export: PASS
android_device_smoke: NOT_RUN
five_person_comprehension: NOT_RUN
production_cutover: BLOCKED
default_entrypoint: LEGACY_RUNTIME_DEFAULT
sheet_state: SYNC_PENDING
```

## 1. 감사 질문과 판정

승인된 단일 QA APK 설계가 정식 `main`의 수동 `Android Validation APK` workflow에서 실제 APK·해시·manifest·provenance를 재현 가능하게 생성했는가?

판정: **PASS**.

비병합 Probe가 먼저 runner·SDK·서명·ETC2/ASTC 문제를 발견하고 닫았으며, 이후 사용자가 정식 workflow를 `main`에서 실행했다. 정식 run의 source SHA, 모든 job 단계, artifact ZIP digest, APK SHA-256, manifest, 14일 보관 기간과 provenance attestation을 독립 검산했다.

이 판정은 APK 패키징과 증거 체인의 성공만 승인한다. Android 조작성, 성능, 화면 안전영역, 5명 이해도, 최종 아트와 production cutover는 승인하지 않는다.

## 2. 승인·구현 계보

| 단계 | 증거 |
|---|---|
| 설계·계획 승인 | EV-USER-022 |
| 설계·계획 | PR #65 · `fd23f39750d3e12dec6dc8a5f186e1f263421907` |
| 기기 내 mode selector | PR #66 · `16297ea79e9f450b00273bd6ee937b185fa3b321` |
| 정본 workflow 구현 | `06eddc1c75f8f8dbf4339f297317a9f034595d07` |
| workflow hardening | PR #70 · `0ba12414b2a7301b073ab2f20cbca881ba6ce5ce` |
| ETC2/ASTC export 수정 | PR #71 · `536911449018a3caf3511bc64e7bf1a66edf2016` |
| hosted-runner Probe 기록 | `ff50097f014cea51ccebb54f53ac832212112853` |
| 정식 main workflow 실행 | run `31011620357` · attempt `1` |

PR #67·#68·#72는 동시 작업과 중복되거나 stale base에서 생성돼 병합하지 않았다. 유효한 결함과 검증 증거만 정본 PR·감사에 흡수했다.

## 3. TDD·적대적 검토 증거

| 단계 | Project Contract | Godot Tests | 판정 |
|---|---:|---:|---|
| Selector RED | #516 PASS | #469 FAIL | selector scene 부재만 실패 |
| Selector/Navigate GREEN | #522 PASS | #475 PASS | 4모드·Back·fail-closed PASS |
| Workflow RED | #524 PASS | #476 FAIL | workflow 부재만 실패 |
| Workflow first GREEN | #526 PASS | #478 PASS | 정적 계약 PASS |
| License pipeline RED/GREEN | #527 PASS | #479 FAIL → #530/#482 PASS | SIGPIPE 오탐 제거 |
| Main hardening RED/GREEN | #532 PASS | #483 FAIL → #533/#484 PASS | SDK/JDK·서명·Scene hash 고정 |
| ETC2/ASTC RED/GREEN | #535 PASS | #485 FAIL → #536/#486 PASS | 실제 export 차단 원인 회귀 고정 |
| Canonical workflow tests | runtime job PASS | `65 cases · 10,792 assertions · 0 failures` | export 전 전체 회귀 PASS |

## 4. 역사 Probe 증거

Probe는 정식 workflow 실행 전 재현성 위험을 찾기 위한 비병합 branch evidence다.

```yaml
probe_branch: ci/android-validation-probe
probe_head: 56980c0d420df39da79c95a4d9393037a6f9be07
workflow_run_id: 31010824827
artifact_id: 8932389596
artifact_zip_sha256: 76601acb25e64e76e4961f90142150674bb95cdf77619bc005f3bf4d4189787a
apk_sha256: c0a1359cace25dd90e354f4cd235cf2042435785d92ed036ec81bc0cadfdc9b7
status: HISTORICAL_PREREQUISITE_EVIDENCE
```

Probe APK는 canonical device acceptance binary가 아니다.

## 5. 정식 main export 증거

```yaml
workflow: Android Validation APK
workflow_run_number: 1
workflow_run_id: 31011620357
workflow_run_attempt: 1
event: workflow_dispatch
branch: main
source_commit: 536911449018a3caf3511bc64e7bf1a66edf2016
job_id: 92324988427
job_result: SUCCESS
artifact_id: 8932725351
artifact_name: switchy-express-validation-53691144
artifact_zip_size_bytes: 28483514
artifact_zip_sha256: 1802ca52dd90eb674f89b0a6e4678152d314c5644d135a84033388b4d3ee7193
artifact_expiry: 2026-08-19T13:45:27Z
apk_filename: switchy-express-validation.apk
apk_size_bytes: 28771631
apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
attestation_id: 39044925
attestation_subject: sha256:eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
```

### 독립 검산

| 검사 | 결과 |
|---|---|
| run source와 manifest source | `536911449018a3caf3511bc64e7bf1a66edf2016` 일치 |
| 모든 workflow 단계 | PASS |
| 전체 테스트 | `65 cases · 10,792 assertions · 0 failures` |
| product main 불변 | `res://game/main/main.tscn` PASS |
| artifact ZIP GitHub digest·로컬 SHA-256 | 일치 |
| APK 존재·크기 | PASS · `28,771,631` bytes |
| APK 실제 SHA-256·`.sha256`·manifest | 세 값 일치 |
| manifest run ID/attempt | `31011620357 / 1` 일치 |
| manifest modes | `PROOF`, `STACK_8`, `STACK_16`, `STACK_32` |
| validation package | `com.alsdmlals4.switchyexpress.validation` |
| provenance | APK SHA-256 대상 attestation 실제 발급 PASS |
| summary Gate | APK artifact 생성, Android/HUMAN/cutover 미승인 유지 |

## 6. 적대적 검토 결과

### 닫은 중요 결함

| Finding | 위험 | 처리 |
|---|---|---|
| F134 · mode가 command-line 의존 | 실기기에서 fixture 전환 불가 | 기기 내 selector·Back 추가 |
| F135 · mutable runner SDK 의존 | runner 변경 시 비재현 | SDK·Build Tools·NDK 고정 |
| F136 · debug signing 경로 불명확 | unsigned/local credential 의존 | run별 임시 debug 서명 |
| F137 · Godot SDK/JDK path 누락 | exporter가 도구를 찾지 못함 | EditorSettings에 명시 |
| F138 · license SIGPIPE | 정상 설치를 실패로 오판 | prompt pipeline만 제한 허용 |
| F139 · ETC2/ASTC 미설정 | Android export 차단 | 설정과 회귀 테스트 추가 |
| F140 · 정적 workflow PASS 과신 | 실제 APK 실패 누락 | Probe와 정식 main run 검증 |

### 비차단 후속 위험

| Finding | 현재 영향 | 후속 권장 |
|---|---|---|
| F141 · project icon 미지정 | export는 성공했으나 기본 아이콘 사용 | production art Gate 전에 validation/product icon 지정 |
| F142 · 일부 GitHub Action runtime 노후화 경고 | 현재 run 성공, 미래 runner 호환성 위험 | 별도 CI 유지보수 package에서 action major version 갱신·TDD |

F141·F142는 APK 증거 무결성·서명·실행 파일 생성에 영향을 주지 않아 `APK_EXPORT`를 차단하지 않는다. Android/HUMAN 검증 중 관련 문제가 나타나면 즉시 승격해 수정한다.

## 7. 현재 Gate

```text
AUTOMATED CORE: PASS
VALIDATION PREPARATION: PASS
ON-DEVICE SELECTOR: PASS
APK PIPELINE STATIC CONTRACT: PASS
APK PIPELINE RUNTIME PROBE: PASS · HISTORICAL
CANONICAL MAIN APK EXPORT: PASS
ANDROID DEVICE SMOKE: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
DEFAULT ENTRYPOINT: LEGACY
PRODUCTION CUTOVER: BLOCKED
```

## 8. 다음 정확한 작업

동일 APK SHA-256 `eb49225a...759ea`를 기준으로 Android landscape smoke를 수행한다.

필수 항목:

1. APK 설치·첫 부팅·재부팅
2. `PROOF`, `STACK 8`, `STACK 16`, `STACK 32` 터치 선택과 Back
3. 48dp 조작 영역과 화면 안전영역
4. BUILD→RUN→pause/resume→result→retry
5. branch 직접 탭·LOAD hold·auto-load
6. 8/16/32 LIFO TOP 가독성
7. 크래시·ANR·입력 누락·심각한 프레임 저하 없음
8. 기기 모델·Android 버전·orientation·결과를 APK hash와 함께 기록

Android PASS 뒤 같은 APK hash로 처음 보는 5명의 comprehension 검증을 수행한다.

## 9. 정본 경계

- `APK_EXPORT: PASS`는 이 정식 main artifact에만 적용한다.
- Android·HUMAN·cutover는 계속 `NOT_RUN/BLOCKED`다.
- production `run/main_scene`과 `game/main/main.tscn`은 변경하지 않는다.
- legacy 기본 진입점은 유지한다.
- wrong `19Ff...` Sheet는 계속 변경 금지다.
