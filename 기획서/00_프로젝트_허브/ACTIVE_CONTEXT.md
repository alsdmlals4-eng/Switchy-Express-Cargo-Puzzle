# Active Context

## 현재 상태

```yaml
project: Switchy Express: Cargo Puzzle
product_authority: GMB-002 · SX-DEC-027~036
current_audit: SX-AUD-019
current_evidence: EV-FP-APK-001
automated_core: PASS
validation_preparation: PASS
on_device_selector: PASS
canonical_main_apk_export: PASS
android_device_smoke: NOT_RUN · CURRENT
five_person_comprehension: NOT_RUN · BLOCKED_BY_ANDROID
default_entrypoint: LEGACY_RUNTIME_DEFAULT
production_cutover: BLOCKED
canonical_export_source: 536911449018a3caf3511bc64e7bf1a66edf2016
apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
package_id: com.alsdmlals4.switchyexpress.validation
```

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

## 완료된 Gate

### FINITE AUTOMATED CORE · PASS

- finite map·track layout·preflight·build session
- manual/auto loading·unlimited LIFO·fixed cargo field
- finite lifecycle·pause·result·same-layout retry
- landscape product surface와 integrated proof
- `A → B → A → A` 적재, `2 → 1 → 1` 하역 자동 증명

### VALIDATION PREPARATION · PASS

- isolated validation launcher
- `PROOF`, `STACK 8`, `STACK 16`, `STACK 32`
- selector와 Back
- Android validation export preset
- production entrypoint invariance

### CANONICAL MAIN APK EXPORT · PASS

```yaml
workflow_run_id: 31011620357
source_commit: 536911449018a3caf3511bc64e7bf1a66edf2016
apk_size_bytes: 28771631
apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
artifact_zip_sha256: 1802ca52dd90eb674f89b0a6e4678152d314c5644d135a84033388b4d3ee7193
attestation_id: 39044925
artifact_expiry: 2026-08-19T13:45:27Z
```

Workflow source·APK 실제 hash·`.sha256`·manifest·attestation이 일치한다. 이 증거는 패키징과 provenance만 증명하며 Android 조작성·사람 이해도·production readiness를 증명하지 않는다.

## 현재 실행 권위 — ANDROID DEVICE SMOKE

정본 실행 문서:

- `기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_RUNBOOK.md`
- `기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_EVIDENCE_TEMPLATE.md`
- `기획서/50_제작_검증/SX_AUD_019_ANDROID_APK_PIPELINE_PROBE.md`

현재 작업:

```text
full APK SHA-256 확인
→ physical Android landscape device 준비
→ AND-01~20 전체 실행
→ 영상·스크린샷·로그와 항목별 상태 기록
→ result completeness·privacy·adversarial review
```

필수 범위:

- 설치·첫 부팅·cold reboot
- `PROOF / STACK 8 / STACK 16 / STACK 32 / Back`
- BUILD place·rotate·replace·remove·clear와 preflight
- BUILD→RUN→pause/resume→result→retry/edit
- LOAD hold·auto-load·branch 직접 탭·occupied lock
- movement/unload pause integrity
- same-layout fresh-runtime retry
- 8·16·32 rear/TOP 가독성
- safe area·touch target·잘림·겹침·입력 누락
- crash·ANR·script error·심각한 frame degradation

## 현재 미검증

```yaml
android_device_smoke: NOT_RUN
five_person_comprehension: NOT_RUN
production_default_cutover: BLOCKED
final_art_and_icon: NOT_RUN
platform_submission_and_rating: NOT_RUN
asset_rights_runtime_audit: NOT_RUN
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

과거 구현·계획·테스트는 당시 사실과 migration 참고로 보존하지만 현재 제품·다음 작업 권위를 갖지 않는다.

## 다음 정확한 작업

```text
ANDROID_DEVICE_SMOKE_RUNBOOK.md 실행
→ ANDROID_DEVICE_SMOKE_EVIDENCE_TEMPLATE.md 작성
→ 동일 APK hash와 item completeness 검증
→ 실제 결과에 따른 PASS / FAIL / BLOCKED 판정
```

Android Device Smoke가 reviewed PASS인 경우에만 같은 APK hash로 Five-person Comprehension을 시작한다. 실제 증거 전에는 `SX-AUD-020`, Android PASS, Sheet sync 또는 production cutover를 기록하지 않는다.

## 금지

- 새 APK에 이전 device/human 증거 자동 승계
- emulator를 physical-device PASS로 표현
- 부분 실행을 전체 PASS로 표현
- validation 편의를 위한 production main 진입점 변경
- Android PASS를 HUMAN·cutover PASS로 확대
- wrong `19Ff...` Sheet 변경
- historical VS03·fuel·BOOST 계약을 현재 권위로 재활성화
