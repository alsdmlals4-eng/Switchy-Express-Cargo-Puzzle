# Android Device Smoke Readiness Closure

```yaml
closure: ANDROID_DEVICE_SMOKE_CANONICAL_FRESHNESS_REPAIR
approval: EV-USER-023
approved_at: 2026-08-05T23:23:00+09:00
implementation_baseline: b2ecc7220f4cad546814bcce43e998a45fff5281
plan_merge: 0bdcdae2092460431f81d383b34b51f725a4ab08
current_audit: SX-AUD-019
current_evidence: EV-FP-APK-001
canonical_export_source: 536911449018a3caf3511bc64e7bf1a66edf2016
canonical_apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
canonical_freshness: PASS
runbook: READY_FOR_EXECUTION
android_device_smoke: NOT_RUN
five_person_comprehension: NOT_RUN
production_cutover: BLOCKED
google_sheet_change: NONE
```

## 1. Closure Question

정식 APK export 이후 활성 프로젝트 Entry Point·Gate·문서 Registry·프로젝트 Skill에 남은 구형 VS03·fuel·BOOST·capacity-eight 권위를 제거하고, 동일 APK hash 기반 Android 실기기 실행 계약을 제품 코드와 APK를 바꾸지 않고 준비했는가?

판정: **PASS for canonical freshness and execution readiness**.

이 판정은 Android 실기기 실행, 사람 이해도 또는 production cutover를 승인하지 않는다. 현재 Android Gate는 계속 `NOT_RUN`이다.

## 2. Approval and TDD Lineage

```text
User approval: EV-USER-023
→ design and plan PR #78
→ plan merge 0bdcdae2092460431f81d383b34b51f725a4ab08
→ implementation PR #79
→ focused RED
→ minimal canonical repair
→ focused GREEN and full regression
```

### RED evidence

```yaml
red_head: 2c8ee20a128a2006cec03324b75b4443ff18031a
project_contract: run 554 · FAIL
focused_contract: FAIL · 1 failure · 3 errors
existing_project_validator: PASS
existing_base_adoption_tests: PASS
godot_tests: run 498 · PASS
```

The focused contract failed for the intended reasons:

- stale finite-DoR/VS03 active hub
- missing Android Runbook and evidence Template
- missing current Registry IDs
- missing finite current Skill sections

### GREEN evidence

```yaml
green_head: b7f34efb56d97d5124de104f9dc081891fa0edfe
project_contract: run 565 · PASS
godot_tests: run 509 · PASS
base_shared_external_ai_adapter: run 15 · PASS
base_v9_4_2_planning_first: run 8 · PASS
base_v9_4_3_first_prompt: run 9 · PASS
godot_summary: 65 cases · 10,792 assertions · 0 failures
```

The focused contract passes all five groups:

- active hub and Gate chain
- one current Android execution authority
- finite project Skill authority
- same-hash fail-closed Runbook and Template
- project Registry raw-byte hash propagation

## 3. Active Consumers Repaired

The repair updated eight active consumers:

1. `기획서/00_프로젝트_허브/START_HERE.md`
2. `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
3. `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md`
4. `기획서/00_프로젝트_허브/DOCUMENTATION_MAP.md`
5. `기획서/00_프로젝트_허브/DESIGN_DOCUMENT_REGISTRY.json`
6. `skills/switchy-express-design/SKILL.md`
7. `skills/SKILL_REGISTRY.json`
8. `skills/PROJECT_BASE_ADAPTER.json`

`SKILL_REGISTRY.json` raw bytes changed, so the Adapter project SHA-256 was recalculated and propagated as required by `tests/test_base_v94_ai_operations_adoption.py`.

## 4. New Execution Surfaces

### Runbook

`ANDROID_DEVICE_SMOKE_RUNBOOK.md` now defines:

- full canonical APK SHA-256 and validation package
- physical Android device requirement
- install, first boot and cold reboot
- `PROOF / STACK 8 / STACK 16 / STACK 32 / Back`
- BUILD·preflight·RUN·pause/resume·result·retry/edit
- LOAD hold·auto-load·branch direct tap·occupied lock
- same-layout fresh-runtime retry
- 8/16/32 rear/TOP readability
- safe area, touch target, clipping, overlap and missed input
- crash, ANR, script error and severe frame degradation
- AND-01~20 fail-closed matrix

### Evidence Template

`ANDROID_DEVICE_SMOKE_EVIDENCE_TEMPLATE.md` remains explicitly:

```yaml
record_state: TEMPLATE_NOT_EXECUTED
overall_gate: NOT_RUN
five_person_comprehension: NOT_RUN
production_cutover: BLOCKED
```

It requires minimal tester/device aliases and prohibits names, accounts, notifications, contact details, IMEI, serial numbers and unrelated screen content.

## 5. Historical Preservation

The following remain in the repository as `HISTORICAL`, `SUPERSEDED` or `LEGACY_IMPLEMENTATION` evidence:

- old VS03 execution plans and audits
- compact capacity-eight design
- fuel·BOOST first-session onboarding design and plan
- endless runtime implementation and tests
- old Codex execution prompts

They were not deleted or rewritten as if they had never existed. They no longer own current product meaning, current package authority or next work.

## 6. Protected Boundary

The package did not intentionally modify:

- `project.godot`
- `game/**`
- `.github/workflows/android-validation-apk.yml`
- APK bytes, manifest, hash or attestation
- product default entrypoint
- gameplay, saves, assets or balance
- PR #74 platform release and asset-rights surfaces
- Google Sheet contents

Correct Sheet remains `1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo`; wrong `19Ff...` remains untouched.

## 7. Gate State After Closure

```text
FINITE AUTOMATED CORE: PASS
VALIDATION PREPARATION: PASS
ON-DEVICE SELECTOR: PASS
CANONICAL MAIN APK EXPORT: PASS
CANONICAL FRESHNESS: PASS
ANDROID DEVICE SMOKE RUNBOOK: READY_FOR_EXECUTION
ANDROID DEVICE SMOKE: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN · BLOCKED_BY_ANDROID
DEFAULT ENTRYPOINT: LEGACY
PRODUCTION CUTOVER: BLOCKED
```

## 8. Next Exact Human Action

1. Artifact expiry 전에 canonical APK와 evidence bundle을 확보한다.
2. APK SHA-256 전체 64자리가 정본 값과 일치하는지 확인한다.
3. 물리 Android landscape 기기에서 Runbook의 AND-01~20을 전부 수행한다.
4. Template에 항목별 상태와 영상·스크린샷·로그 참조를 기록한다.
5. 결과를 GitHub 정본에 반영하기 전에 completeness·privacy·adversarial review를 수행한다.

실제 증거가 reviewed PASS가 되기 전에는 `SX-AUD-020`, Android PASS, Five-person Comprehension, Sheet Android closure 또는 production cutover를 기록하지 않는다.
