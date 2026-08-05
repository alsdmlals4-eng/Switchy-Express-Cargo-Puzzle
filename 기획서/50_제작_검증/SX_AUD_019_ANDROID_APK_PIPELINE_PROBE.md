# SX-AUD-019 · Android Validation APK Pipeline Probe Audit

```yaml
audit_id: SX-AUD-019
evidence_id: EV-FP-APK-PROBE-001
product_authority: GMB-002 · SX-DEC-027~036
execution_authority: FP-DOR-001 · EV-USER-021 · EV-USER-022
source_main: 536911449018a3caf3511bc64e7bf1a66edf2016
status: APK_PIPELINE_RUNTIME_PROBE_PASS · CANONICAL_APK_EXPORT_NOT_RUN
validation_prep: PASS
android_device_smoke: NOT_RUN
five_person_comprehension: NOT_RUN
production_cutover: BLOCKED
default_entrypoint: LEGACY_RUNTIME_DEFAULT
sheet_state: SYNC_PENDING
```

## 1. 감사 질문

승인된 단일 QA APK 설계가 GitHub-hosted Android runner에서 실제로 SDK 설치, Godot export, APK 서명, SHA-256·manifest 생성, provenance attestation, artifact 업로드까지 재현 가능한가?

판정: **Probe 범위 PASS**. 비병합 전용 Probe 브랜치에서 동일한 도구 체인과 export preset으로 실제 APK를 생성했고, 독립 검산으로 artifact ZIP digest·APK SHA-256·manifest를 일치 확인했다.

단, 정식 `Android Validation APK` workflow를 `main`에서 수동 실행한 기록은 아직 0건이다. 따라서 `APK_EXPORT` 정본 Gate는 계속 **NOT_RUN**이다. Probe 성공은 Android 기기 조작성, 5명 이해도, 제품 전환을 승인하지 않는다.

## 2. 승인·구현 계보

| 단계 | 증거 |
|---|---|
| 설계·계획 승인 | EV-USER-022 |
| 설계·계획 PR | PR #65 · `fd23f39750d3e12dec6dc8a5f186e1f263421907` |
| 기기 내 mode selector | PR #66 · `16297ea79e9f450b00273bd6ee937b185fa3b321` |
| 동시 main workflow 구현 | `06eddc1c75f8f8dbf4339f297317a9f034595d07` |
| workflow hardening | PR #70 · `0ba12414b2a7301b073ab2f20cbca881ba6ce5ce` |
| ETC2/ASTC Android export 수정 | PR #71 · `536911449018a3caf3511bc64e7bf1a66edf2016` |

PR #67은 동시 main 구현과 기능이 중복돼 병합하지 않고 종료했다. 해당 PR에서 발견한 재현성·서명·경로 결함만 PR #70으로 분리 반영했다.

## 3. TDD·적대적 검토 증거

### Selector

| 단계 | Project Contract | Godot Tests | 판정 |
|---|---:|---:|---|
| Selector RED | #516 PASS | #469 FAIL | 기존 63 cases PASS, selector scene 부재만 실패 |
| Selector GREEN | #518 PASS | #471 PASS | selector component PASS |
| Navigation RED | #519 PASS | #472 FAIL | selector-first launcher 계약만 실패 |
| Navigation GREEN | #522 PASS | #475 PASS | mode 선택·Back·fail-closed·child 해제 PASS |

### Android workflow

| 단계 | Project Contract | Godot Tests | 판정 |
|---|---:|---:|---|
| Workflow initial RED | #524 PASS | #476 FAIL | workflow 부재만 실패 |
| Workflow first GREEN | #526 PASS | #478 PASS | 정적 계약 PASS |
| License-pipe RED | #527 PASS | #479 FAIL | `pipefail` 아래 license 승인 SIGPIPE 위험 재현 |
| License-pipe GREEN | #530 PASS | #482 PASS | SDK 설치 실패는 차단하고 prompt pipe만 허용 |
| Main hardening RED | #532 PASS | #483 FAIL | SDK/JDK 경로·임시 서명·Scene hash 누락 재현 |
| Main hardening GREEN | #533 PASS | #484 PASS | 재현 가능한 export 준비 계약 PASS |
| ETC2/ASTC RED | #535 PASS | #485 FAIL | 실제 Probe export 오류를 회귀 테스트로 고정 |
| ETC2/ASTC GREEN | #536 PASS | #486 PASS | Android texture import 조건 PASS |

## 4. 실제 runner Probe

Probe는 정본 workflow를 변경하지 않기 위해 `ci/android-validation-probe` 브랜치에만 존재하는 push-trigger workflow로 실행했다. 이 branch와 Probe workflow 파일은 제품 main에 병합하지 않는다.

```yaml
probe_branch: ci/android-validation-probe
probe_head: 56980c0d420df39da79c95a4d9393037a6f9be07
workflow_run_id: 31010824827
workflow_run_attempt: 1
artifact_id: 8932389596
artifact_name: switchy-express-validation-probe-56980c0d
artifact_zip_sha256: 76601acb25e64e76e4961f90142150674bb95cdf77619bc005f3bf4d4189787a
apk_size_bytes: 28771631
apk_sha256: c0a1359cace25dd90e354f4cd235cf2042435785d92ed036ec81bc0cadfdc9b7
artifact_expiry: 2026-08-19T13:35:48Z
```

### 실제 PASS 단계

1. checkout
2. Temurin Java 17
3. `android-actions/setup-android@v3`
4. Android platform 35·Build Tools 35.0.1·NDK `28.1.13356709`
5. 임시 랜덤 debug keystore
6. Godot Java/Android SDK editor paths
7. Godot 4.7.1과 동일 버전 Android export templates
8. 전체 headless 테스트
9. production entrypoint·Scene SHA-256 불변 검사
10. `Android Validation` debug APK export
11. SHA-256·manifest·summary 생성
12. `actions/attest@v4` provenance attestation
13. 14일 artifact 업로드

## 5. 독립 artifact 검산

다운로드한 ZIP을 별도로 해제해 다음을 확인했다.

| 검사 | 결과 |
|---|---|
| GitHub artifact digest와 로컬 ZIP SHA-256 | 일치 · `76601acb...9787a` |
| APK 존재·크기 | PASS · 28,771,631 bytes |
| APK 실제 SHA-256과 `.sha256` 파일 | 일치 · `c0a1359c...c9b7` |
| manifest `source_commit` | Probe head와 일치 |
| manifest `workflow_run_id/attempt` | `31010824827 / 1` 일치 |
| manifest modes | `PROOF`, `STACK_8`, `STACK_16`, `STACK_32` |
| manifest package | `com.alsdmlals4.switchyexpress.validation` |
| manifest product main | `res://game/main/main.tscn` |
| Probe 구분 | `probe_only: true` |
| Summary Gate | `PROBE_ARTIFACT_CREATED_NOT_CANONICAL_PASS` |
| Android/HUMAN/cutover | 모두 미승인 유지 |

## 6. 닫은 중요 결함

| Finding | 위험 | 수정 |
|---|---|---|
| F134 · Android mode가 command-line 의존 | 실제 기기에서 8/16/32 전환 불가능 | 기기 내 selector·Back overlay 추가 |
| F135 · mutable runner SDK 의존 | 미래 runner 변경 시 비재현 실패 | SDK·Build Tools·NDK 명시 설치·검증 |
| F136 · debug signing 경로 불명확 | unsigned export 또는 local credential 의존 | 매 run 임시 random keystore와 공식 Godot env 사용 |
| F137 · Godot SDK/JDK editor path 누락 | 도구 설치 후에도 exporter가 경로를 못 찾음 | EditorSettings 경로 명시 |
| F138 · `yes | sdkmanager` SIGPIPE | 정상 license 승인도 `141`로 오탐 실패 | prompt pipeline만 허용, 실제 설치·경로는 fail-closed |
| F139 · ETC2/ASTC import 미설정 | Android export 즉시 차단 | `textures/vram_compression/import_etc2_astc=true`와 회귀 테스트 |
| F140 · 정적 workflow PASS 과신 | 실제 APK 생성 불가를 놓침 | 실제 hosted-runner Probe와 artifact 독립 검산 |

## 7. 현재 Gate

```text
AUTOMATED CORE: PASS
VALIDATION PREPARATION: PASS
ON-DEVICE SELECTOR: PASS
APK PIPELINE STATIC CONTRACT: PASS
APK PIPELINE RUNTIME PROBE: PASS
CANONICAL MAIN APK EXPORT: NOT_RUN
ANDROID DEVICE SMOKE: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
DEFAULT ENTRYPOINT: LEGACY
PRODUCTION CUTOVER: BLOCKED
```

정본 `Android Validation APK` workflow run 목록은 현재 0건이다. 연결된 GitHub 도구에는 `workflow_dispatch` 실행 기능이 없어 자동으로 수동 workflow를 시작할 수 없었다.

## 8. 다음 정확한 작업

GitHub UI에서 다음 1회 실행이 필요하다.

```text
Actions
→ Android Validation APK
→ Run workflow
→ Branch: main
→ Run workflow
```

실행 후 반드시 다음을 검증한다.

1. source SHA가 당시 `main`과 일치
2. 모든 workflow step PASS
3. artifact가 non-empty
4. artifact ZIP digest 기록
5. APK SHA-256 독립 재계산 일치
6. manifest 필드·source SHA·run ID 일치
7. provenance attestation PASS

이 일곱 조건이 충족된 경우에만 `APK_EXPORT: PASS`로 승격한다. 이후 Android landscape smoke와 5명 comprehension을 같은 APK hash로 수행한다.

## 9. 정본 경계

- Probe branch와 `android-validation-probe.yml`은 병합 금지다.
- Probe APK를 canonical device acceptance binary로 사용하지 않는다.
- Probe 성공을 `APK_EXPORT`, `ANDROID`, `HUMAN`, `CUTOVER` PASS로 해석하지 않는다.
- production `run/main_scene`과 `game/main/main.tscn`은 변경하지 않는다.
- wrong `19Ff...` Sheet는 계속 변경 금지다.
