# Android Device Smoke and Canonical Freshness Repair Design

## 1. Purpose

정식 Android Validation APK export Gate 이후, 실제 Android landscape 기기 검증을 시작하기 전에 활성 프로젝트 진입점과 Skill 라우팅에 남은 구형 VS03·fuel·BOOST·capacity-eight 권위를 제거한다.

이 설계는 다음 순서를 고정한다.

```text
canonical freshness repair
→ Android device smoke runbook and evidence template
→ same-APK real-device execution
→ adversarial review
→ GitHub canon and correct Google Sheet closure
→ five-person comprehension
→ separate production cutover review
```

제품 코드, APK bytes, export workflow, production `run/main_scene`, `game/main/main.tscn`, 게임 규칙과 Google Sheet는 이 설계 PR에서 변경하지 않는다.

## 2. Authority and frozen baseline

```yaml
repository: alsdmlals4-eng/Switchy-Express-Cargo-Puzzle
baseline_main: 6cdbda34da61de7b5175ad08d7aaffaf186a0dcf
product_authority: GMB-002 · SX-DEC-027~036
execution_authority: FP-DOR-001 · EV-USER-021 · EV-USER-022
current_audit: SX-AUD-019
current_evidence: EV-FP-APK-001
canonical_export_source: 536911449018a3caf3511bc64e7bf1a66edf2016
validation_apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
validation_apk_size_bytes: 28771631
artifact_expiry: 2026-08-19T13:45:27Z
current_gate: ANDROID_DEVICE_SMOKE
five_person_comprehension: NOT_RUN
production_default: LEGACY_RUNTIME_DEFAULT
production_cutover: BLOCKED
correct_sheet: 1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo
forbidden_sheet: 19Ff... legacy/wrong workspace
```

`CURRENT_CONFIRMED_DECISIONS.md`와 `SX_AUD_019_ANDROID_APK_PIPELINE_PROBE.md`가 현재 Gate의 우선 권위다. Android·HUMAN 증거는 동일 APK SHA-256에만 귀속하며, 새 APK를 생성하면 기존 수동 증거를 자동 승계하지 않는다.

## 3. Problem statement

정식 APK Gate는 닫혔지만 다음 활성 소비자가 과거 VS03 권위를 여전히 현재 상태로 안내한다.

- `기획서/00_프로젝트_허브/START_HERE.md`
- `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
- `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md`
- `기획서/00_프로젝트_허브/DOCUMENTATION_MAP.md`
- `기획서/00_프로젝트_허브/DESIGN_DOCUMENT_REGISTRY.json`
- `skills/switchy-express-design/SKILL.md`
- `skills/SKILL_REGISTRY.json`

현재 충돌은 다음과 같다.

1. 프로젝트 첫 진입 문서가 finite DoR 이전 상태를 현재로 표시한다.
2. Active Context와 Development Gates가 VS03-03을 다음 실행 권위로 표시한다.
3. 활성 프로젝트 Skill이 fuel, BOOST, capacity eight, cargo slowdown과 VS03-03을 현재 불변 조건으로 선언한다.
4. Documentation Map과 Registry가 대체된 VS03·BOOST 온보딩 자료를 `CURRENT` 책임 원본으로 연결한다.
5. 검색과 자동 Skill routing을 따르는 새 작업자가 대체된 제품 계약을 부활시킬 수 있다.

과거 계획·감사·PR 증거 파일의 존재는 결함이 아니다. 역사 자료가 활성 진입점과 Registry에서 현재 권위로 선택되는 것이 결함이다.

## 4. Design alternatives

### A. Repair active canonical consumers before device execution — selected

활성 시작 문서·상태·Gate·Documentation Map·Registry·프로젝트 Skill만 최소 수정하고, 과거 VS03 자료는 역사 증거로 보존한다. 그 뒤 Android Smoke runbook과 기록 template을 추가한다.

장점:

- 잘못된 실행 재개 가능성을 먼저 차단한다.
- 역사 증거와 기존 구현 이력을 보존한다.
- 제품 코드와 APK를 건드리지 않는다.
- 수동 증거가 최신 정본에 연결된다.

비용:

- 실제 기기 테스트 전에 문서·라우팅 복구 PR이 하나 필요하다.

### B. Execute device smoke first

기기 검증은 빠르게 시작할 수 있지만, 결과 기록과 다음 작업자가 구형 실행 권위를 선택할 위험이 남는다. 정본 Gate를 우회하므로 채택하지 않는다.

### C. Delete or rewrite all VS03-era material

활성 혼동은 줄지만 역사 증거 파괴, 범위 폭증, 링크·PR 회귀와 검토 비용이 크다. 현재 목표에 필요하지 않아 채택하지 않는다.

## 5. Package architecture

### Package 1 — Canonical freshness repair

#### 5.1 Active project hub

`START_HERE.md`는 한 화면에서 다음을 정확히 보여야 한다.

```text
FINITE AUTOMATED CORE: PASS
VALIDATION PREPARATION: PASS
ON-DEVICE SELECTOR: PASS
CANONICAL MAIN APK EXPORT: PASS
ANDROID DEVICE SMOKE: NOT_RUN · CURRENT
FIVE-PERSON COMPREHENSION: NOT_RUN
DEFAULT ENTRYPOINT: LEGACY
PRODUCTION CUTOVER: BLOCKED
```

최초 읽기 순서는 finite baseline, current decisions, current validation audit, Android Smoke runbook, Vertical Slice contract, roadmap 순으로 재구성한다.

`ACTIVE_CONTEXT.md`는 VS03-03 실행 지시를 제거하고, 동일 APK 해시 기반 Android Device Smoke를 현재 작업으로 지정한다. 과거 VS03 상태는 현재 실행 권위가 아닌 역사 증거로만 링크한다.

`DEVELOPMENT_GATES.md`는 기존 G0~G3의 상세 이력을 압축 보존하되, 현재 Gate chain을 다음처럼 명시한다.

```text
AUTOMATED CORE PASS
→ VALIDATION PREPARATION PASS
→ CANONICAL APK EXPORT PASS
→ ANDROID DEVICE SMOKE CURRENT
→ FIVE-PERSON COMPREHENSION BLOCKED_BY_ANDROID
→ PRODUCTION CUTOVER BLOCKED
```

#### 5.2 Documentation Map and registry

`DOCUMENTATION_MAP.md`와 `DESIGN_DOCUMENT_REGISTRY.json`은 같은 질문에 하나의 현재 책임 원본만 제공한다.

필수 현재 책임 원본:

- 현재 제품과 Gate: `START_HERE.md`
- 현재 상태와 다음 작업: `ACTIVE_CONTEXT.md`
- 승인 결정: `CURRENT_CONFIRMED_DECISIONS.md`
- 제품 기준선: `FINITE_DELIVERY_PUZZLE_BASELINE.md`
- Android APK 증거: `SX_AUD_019_ANDROID_APK_PIPELINE_PROBE.md`
- Android Smoke 실행: 신규 runbook
- Vertical Slice 품질·cutover 경계: `VERTICAL_SLICE_CONTRACT.md`

과거 VS03 실행 계획, fuel·BOOST 온보딩, compact capacity-eight 설계는 삭제하지 않고 `HISTORICAL`, `SUPERSEDED`, 또는 현재 질문의 비권위 참고로 분류한다.

#### 5.3 Project Skill routing

`skills/switchy-express-design/SKILL.md`는 현 finite 제품 권위에 맞게 정리한다.

현재 핵심:

```text
track construction
→ cargo encounter order
→ manual/automatic loading
→ unlimited LIFO stack
→ route and persistent branch execution
→ TOP contiguous-group unloading
→ finite-time completion
→ time/cost/score redesign
```

현재 제품 불변 조건에서 다음을 제거한다.

- fuel and fuel-zero
- player BOOST
- capacity eight
- cargo-count slowdown
- endless survival
- pickup respawn
- VS03-03 current-package authority

과거 구현을 검토할 때만 `LEGACY_IMPLEMENTATION`으로 인식한다. Android Smoke, five-person comprehension, finite product validation, canonical APK hash 검증을 positive trigger와 output에 추가한다.

`skills/SKILL_REGISTRY.json`은 프로젝트 Skill의 trigger와 output을 같은 finite 권위로 갱신한다. 전체 Base Skill을 복제하거나 새 광역 Skill을 만들지 않는다.

### Package 2 — Android Device Smoke runbook

신규 runbook은 사용자가 물리 Android 기기에서 그대로 실행하고 결과를 기록할 수 있어야 한다.

#### 5.4 Preflight

- artifact expiration 전에 APK와 evidence bundle 확보
- APK 실제 SHA-256 전체 일치
- validation package `com.alsdmlals4.switchyexpress.validation`
- 기기 모델, Android 버전, 화면 해상도, density, 입력 방식 기록
- landscape lock 확인
- 새 APK 또는 수정 build 사용 금지
- 개인정보·기기 고유 식별자·계정 정보 기록 금지

#### 5.5 Required execution matrix

1. 설치, 첫 부팅, 완전 종료 후 재부팅
2. selector에서 `PROOF`, `STACK 8`, `STACK 16`, `STACK 32` 선택과 Back
3. BUILD에서 place, rotate, replace, remove, clear
4. preflight failure reason과 문제 cell 식별
5. BUILD→RUN→pause/resume→SUCCESS/FAILURE→retry/edit
6. LOAD hold, auto-load toggle, branch 직접 탭, occupied switch lock
7. movement와 unload 중 pause integrity
8. failure 뒤 같은 layout 보존과 fresh-runtime retry
9. 8·16·32 stack의 rear/TOP과 순서 식별
10. 48dp-equivalent touch target, safe area, clipping, overlap, touch omission
11. crash, ANR, script error, 심각한 frame degradation 부재
12. 대표 경로 반복 실행

각 항목은 `PASS`, `FAIL`, `BLOCKED`, `NOT_RUN` 중 하나만 사용한다. 필수 항목 하나라도 `FAIL`, `BLOCKED`, `NOT_RUN`이면 전체 Android Gate는 PASS가 아니다.

#### 5.6 Evidence record

기록은 다음을 연결한다.

```yaml
apk_sha256:
source_commit:
device_alias:
device_model:
android_version:
resolution_density:
orientation:
input_method:
executed_at:
tester_alias:
item_results:
recording_references:
screenshot_references:
crash_anr_log_reference:
observations:
overall_gate: PASS | FAIL | BLOCKED | NOT_RUN
```

`device_alias`와 `tester_alias`는 최소 식별자만 사용한다. 영상·스크린샷은 같은 APK와 기기를 식별할 수 있어야 하지만 개인 알림·계정·연락처·기기 ID를 노출하지 않는다.

### Package 3 — Contract tests and adversarial regression

문서·Registry 계약 테스트는 최소 다음을 검사한다.

- 활성 Entry Point가 `SX-AUD-019`, `EV-FP-APK-001`, `ANDROID_DEVICE_SMOKE`를 가리킨다.
- 활성 Entry Point가 finite DoR 이전 상태나 VS03-03을 현재 다음 작업으로 표시하지 않는다.
- 활성 프로젝트 Skill이 fuel, BOOST, capacity eight, cargo slowdown을 현재 제품 불변 조건으로 선언하지 않는다.
- `CURRENT_CONFIRMED_DECISIONS.md`의 manual Gate와 시작 문서·상태·Gate 문서가 일치한다.
- 과거 계획·감사·Changelog의 역사 표현은 허용한다.
- 신규 runbook은 전체 APK SHA-256, fail-closed 판정, 기기·영상·로그 증거 필드를 요구한다.
- product `run/main_scene`, `game/main/main.tscn`, export workflow와 APK source contract는 변경되지 않는다.

검증 순서:

```text
focused RED contract
→ minimal canonical repair
→ focused GREEN
→ full Project Contract
→ full Godot regression
→ canonical reference freshness scan
→ adversarial regression recheck
```

### Package 4 — Real-device closure

실제 기기 실행 전에는 Android PASS 문서나 Sheet 동기화를 만들지 않는다.

실행 결과가 완전하면 별도 closure package에서 다음을 수행한다.

```text
same APK hash verification
→ result completeness and privacy review
→ adversarial review
→ Android audit record
→ current decisions and Vertical Slice contract update
→ correct Google Sheet same-ID synchronization
→ PR checks and merge
→ merged main and Sheet readback
```

실제 Android 감사 ID는 증거 검증 시 확정한다. `SX-AUD-020`을 후보로 사용할 수 있으나, 실행 전 현재 PASS 권위로 선점하거나 표시하지 않는다.

Android Gate가 PASS한 뒤에만 같은 APK hash로 five-person comprehension을 시작한다.

## 6. Open PR and concurrency boundary

Draft PR #74 `docs: add platform release and asset rights workflow`는 별도 목표다.

이번 package는 기본적으로 다음 PR #74 소유 파일을 수정하지 않는다.

- `AGENTS.md`
- `.github/workflows/platform-release-asset-rights.yml`
- `docs/PLATFORM_RELEASE_AND_ASSET_RIGHTS_PROFILE.md`
- `docs/ASSET_RIGHTS_AND_PROVENANCE_RECORD.md`
- `docs/GAME_RELEASE_COMPLIANCE_EVIDENCE_PACK.md`
- `tests/python/test_platform_release_asset_rights_contract.py`

불가피한 공통 문서 충돌이 발견되면 두 PR을 병렬 병합하지 않고 latest main에서 순차 재기반한다.

## 7. Error handling and fail-closed rules

- APK hash가 다르면 설치 여부와 관계없이 `BLOCKED_HASH_MISMATCH`다.
- 일부 모드만 실행하면 전체 Android Gate는 `NOT_RUN` 또는 `BLOCKED`다.
- 화면 녹화만 있고 항목별 판정이 없으면 PASS가 아니다.
- emulator 결과를 물리 실기기 결과로 표현하지 않는다.
- crash·ANR·심각한 frame degradation이 한 번이라도 재현되면 원인 확인과 같은 hash 또는 수정 hash 재검증 전 PASS하지 않는다.
- 수정 APK를 만들면 이전 APK의 device/human 증거를 승계하지 않는다.
- 제품 default entrypoint를 validation 편의를 위해 변경하지 않는다.
- Android PASS를 production cutover PASS로 확대하지 않는다.
- Sheet 접근 또는 재조회가 실패하면 `SYNCED`를 주장하지 않는다.

## 8. Rollback

Canonical freshness repair는 문서·Registry·테스트만 변경한다.

롤백 시:

1. repair PR을 revert한다.
2. 제품 코드·APK·workflow와 저장 데이터에는 영향이 없어야 한다.
3. 구형 VS03 파일은 삭제하지 않으므로 역사 복구 작업은 필요 없다.
4. 실제 기기 증거는 해당 Git SHA와 APK hash에 계속 귀속되지만, 정본 closure 전에는 PASS 권위가 아니다.

## 9. Acceptance criteria

### Design approval

- 현재 Gate와 APK evidence가 정확히 고정됐다.
- active stale consumers와 허용된 history가 구분됐다.
- 제품·APK·Sheet 비변경 경계가 명확하다.
- PR #74와 소유 파일 경계가 명확하다.
- Android matrix, evidence, privacy, fail-closed 조건이 완결됐다.

### Canonical repair completion

- 일곱 활성 소비자가 finite current authority와 일치한다.
- focused contract가 RED→GREEN으로 증명된다.
- Project Contract와 전체 Godot 테스트가 PASS한다.
- current-state 검색에서 활성 VS03-03·fuel·BOOST·capacity-eight 권위가 남지 않는다.
- history-only 자료는 보존된다.
- unresolved review thread와 REQUEST_CHANGES가 0이다.

### Android Gate completion

- 전체 APK SHA-256이 canonical value와 일치한다.
- 필수 matrix 전 항목이 실제 Android landscape 기기에서 PASS한다.
- 기기·환경·영상·스크린샷·로그 증거가 연결된다.
- 적대적 검토에서 P0/P1 finding이 0이다.
- GitHub 정본과 correct Sheet가 같은 audit/evidence ID로 병합·재조회된다.
- default entrypoint와 production cutover는 별도 승인 전 계속 blocked다.

## 10. Non-goals

- production icon or final art
- GitHub Action runtime modernization
- Google Play submission or content rating assignment
- ads, IAP, currency, privacy SDK decisions
- five-person comprehension execution
- production default entrypoint cutover
- legacy code deletion
- historical document rewrite
- new product mechanics, balance or content

## 11. Final design decision

**Selected:** active canonical consumers를 먼저 finite current authority로 복구하고, 같은 APK hash를 강제하는 Android Device Smoke runbook과 fail-closed evidence contract를 추가한다. 실제 기기 증거가 확보된 뒤에만 별도 audit·GitHub·correct Sheet closure를 수행한다.

이 순서는 최신 정본을 보호하고, 역사 증거를 보존하며, Android PASS·HUMAN PASS·production cutover를 분리한다.