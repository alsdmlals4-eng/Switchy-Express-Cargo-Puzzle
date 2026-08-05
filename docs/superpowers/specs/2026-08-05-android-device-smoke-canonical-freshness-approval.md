# Android Device Smoke Canonical Freshness Approval Addendum

```yaml
approval_id: EV-USER-023
approved_by: user
approved_at: 2026-08-05T23:23:00+09:00
approved_design: docs/superpowers/specs/2026-08-05-android-device-smoke-canonical-freshness-design.md
implementation_plan: docs/superpowers/plans/2026-08-05-android-device-smoke-canonical-freshness-repair.md
approval_statement: 권장안대로 진행 · 승인
original_design_base: 6cdbda34da61de7b5175ad08d7aaffaf186a0dcf
implementation_baseline: b2ecc7220f4cad546814bcce43e998a45fff5281
current_audit: SX-AUD-019
current_evidence: EV-FP-APK-001
canonical_export_source: 536911449018a3caf3511bc64e7bf1a66edf2016
canonical_apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
android_device_smoke: NOT_RUN
five_person_comprehension: NOT_RUN
production_cutover: BLOCKED
google_sheet_change: NONE
```

## Approved scope

1. 활성 프로젝트 허브·Gate·문서 책임 경로를 finite 현재 정본과 Android Device Smoke로 복구한다.
2. 프로젝트 Skill과 Registry에서 구형 VS03·fuel·BOOST·capacity-eight 권위를 제거하고 역사 증거로만 보존한다.
3. 동일 APK 전체 SHA-256을 강제하는 Android 실기기 Runbook과 fail-closed 증거 Template을 추가한다.
4. focused Python contract를 RED→GREEN으로 구현하고 Project Contract·Godot 전체 회귀를 수행한다.
5. 실제 기기 증거 전에는 Android PASS, `SX-AUD-020`, Five-person PASS, production cutover 또는 Google Sheet 변경을 기록하지 않는다.

## Post-approval adversarial corrections

승인 직후 latest `main`과 실제 검사를 다시 비교해 다음 기술적 전파 누락을 추가했다.

- PR #74는 승인 시점 전에 `main`에 병합됐으므로 구현 기준선을 `b2ecc7220f4cad546814bcce43e998a45fff5281`로 재고정한다.
- `skills/SKILL_REGISTRY.json` 변경은 `tests/test_base_v94_ai_operations_adoption.py`의 raw-byte hash 계약에 따라 `skills/PROJECT_BASE_ADAPTER.json#/skill_registry/project/sha256` 갱신을 요구한다.
- 따라서 활성 복구 대상은 기존 7개에서 `PROJECT_BASE_ADAPTER.json`을 포함한 8개다.
- PR #74가 추가한 플랫폼 출시·에셋 권리 문서와 Workflow는 보존하며 이번 구현에서 수정하지 않는다.

이 보정은 제품 방향이나 승인 범위를 변경하지 않는 필수 정본 전파 수정이다.

## Boundary

이 Addendum과 구현 계획은 문서·Registry·검사 계약만 승인한다. 제품 코드, Scene, APK, Android export workflow, 기본 진입점, 자산, 게임 규칙, Google Sheet와 실제 기기 상태는 변경하지 않는다.
