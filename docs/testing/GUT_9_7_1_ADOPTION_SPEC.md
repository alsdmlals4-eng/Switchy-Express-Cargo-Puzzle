# GUT 9.7.1 Formal Adoption Specification

## Status

```yaml
spec_id: GUT-SPEC-001
approval_batch_id: GMB-004
decision_id: SX-DEC-044
audit_id: SX-AUD-027
contract: PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.3
state: GUT_SPEC_DRAFT_PR_OPEN
spec_only: true
installation_authorized: false
```

이 문서는 GUT 애드온을 설치하거나 재설치하지 않는다. 현재 저장소에 이미 존재하는 `res://addons/gut`는 v4.3 이전에 반입된 `PRE_CONTRACT_EXISTING_INSTALL_UNVERIFIED`로 취급하며, 이 명세의 병합만으로 정식 채택 완료를 주장하지 않는다.

## Pinned source

```yaml
framework: GUT
version: "9.7.1"
canonical_repository: "bitwes/Gut"
source_branch_or_release: "godot_4_7"
pinned_commit_sha: aeb5d4f3f7f0a6c9b5e178876d6c99b791fda605
pinned_addon_tree_sha: 5d6893836af4917ee62b1a395125a7530b1f239d
license: MIT
official_license_path: addons/gut/LICENSE.md
official_license_blob_sha: a38ac231fed3febe257c9e5fc31efb8ec7a39f90
godot_target: "4.7.x"
project_expected_godot: "4.7.1-stable"
plugin_install_path: "res://addons/gut"
```

공식 `godot_4_7` 고정 커밋은 9.7.1 버전 상승 커밋이며 공식 README의 지원 표는 GUT 9.7.1을 Godot 4.7.x에 연결한다.

## Existing project readback

```yaml
project_main_at_audit: 4c626513f55a0d180d90882ebe3ccbd314c08827
project_plugin_version: "9.7.1"
project_addon_tree_sha: 09d040309bbed0e07420ad72c4aa69cbd0e58190
project_license_blob_sha: a38ac231fed3febe257c9e5fc31efb8ec7a39f90
project_license_matches_official: true
project_addon_tree_matches_official: false
plugin_enabled_in_project_godot: true
formal_project_gut_consumers_found: false
current_ci_test_authority: res://tests/run_tests.gd
current_ci_is_formal_gut: false
```

공식 addon tree와 프로젝트 addon tree가 다르므로 현재 반입본을 byte-identical official vendor라고 주장하지 않는다. Phase B에서 경로별 diff를 산출하고 허용되는 Godot UID/import 보조 파일과 실제 source divergence를 구분한다.

## Authority and non-overlap

```text
Codex
- production `.gd`, GUT test `.gd`, GUT config, CI, mutation guard와 문서를 작성한다.
- `project.godot`, `.tscn`, `.tres`, `.res`, signal, NodePath, owner, autoload, InputMap을 직접 수정하지 않는다.

HiGodot
- Scene·Node·Resource·Theme·Animation·signal wiring·project settings의 단일 저작 권위다.
- 대상 변경마다 HIGODOT_AUTHORING_MANIFEST를 남긴다.

GUT 9.7.1
- production 결과를 읽고 실행·assert하는 정식 단위·통합·회귀 테스트 권위다.
- production 파일을 수정하지 않는다.

CI
- exact HEAD에서 GUT discovery, exit code, report, mutation guard와 정적 Gate를 실행한다.
- production 파일을 자동 수정하지 않는다.
```

HiGodot 자체 test 기능은 연결 직후 self-diagnostic 또는 제한 smoke에만 사용하며 GUT Required Check를 대체하지 않는다. 같은 요구를 두 프레임워크에 중복 작성하지 않는다.

## Adoption method

Phase B의 권장 vendor 방식은 공식 고정 커밋의 `addons/gut` 디렉터리를 출처 보존 방식으로 반입하는 것이다.

```yaml
download_or_vendor_method: PINNED_SOURCE_TREE_COPY_AFTER_DIFF_RECONCILIATION
integrity_hash: PHASE_B_TO_RECORD_ARCHIVE_SHA256_AND_PATH_MANIFEST
license_file_path: addons/gut/LICENSE.md
plugin_enablement: HIGODOT_ONLY_IF_PROJECT_SETTING_CHANGE_IS_REQUIRED
existing_install_policy: DO_NOT_DELETE_OR_OVERWRITE_BEFORE_DIFF_AND_ROLLBACK_MANIFEST
```

현재 파일을 무단 삭제·대량 덮어쓰기하지 않는다. Phase B는 먼저 현재 tree와 공식 tree를 비교하고, 동일 파일은 보존하며, 차이가 있는 파일만 source provenance와 rollback commit을 가진 변경으로 처리한다.

## Actual consumers

첫 정식 소비자는 `SX-DEC-040~042`의 공유 게임 코어다.

```yaml
test_root_paths:
  - res://tests/gut/unit
  - res://tests/gut/integration
  - res://tests/gut/regression
test_naming_rules:
  - test_*.gd
actual_consumers:
  - one-sided RED_STAR/BLUE_DIAMOND station parity
  - route-end FAILURE/ROUTE_END ordering
  - final-delivery SUCCESS priority
  - switch reciprocal three-direction selection
  - incoming-direction U-turn
  - occupied switch input lock
  - route-control overlay state/input contract
```

기존 `res://tests/run_tests.gd` 회귀는 GUT 전환 중 삭제하지 않는다. Phase B에서 동일 요구의 중복 책임을 피하기 위해 다음 중 하나를 명시적으로 적용한다.

1. GUT로 이관한 테스트는 기존 runner에서 제거하고 GUT 단일 책임으로 둔다.
2. 이관하지 않은 기존 regression은 legacy suite로 표기하고 GUT consumer 수에 포함하지 않는다.

## Configuration and commands

```yaml
gut_config_path: res://.gutconfig.json
minimum_discovered_test_count_initial: 6
minimum_discovered_test_count_after_migration: TO_BE_RAISED_WITH_MIGRATION_MANIFEST
junit_or_report_artifact: test-results/gut/junit.xml
production_mutation_guard: SHA256_BEFORE_AFTER_PROJECT_GODOT_TSCN_TRES_RES_PRODUCTION_DATA_ASSETS
```

Phase B에서 exact Godot executable의 `--help`와 GUT 고정 소스의 실제 CLI를 확인한 뒤 명령을 확정한다. 아래는 계약 형태이며 검증 전 실행 문자열을 추측하지 않는다.

```text
<Godot-4.7.1-exact> --headless --path <project> -s <verified-gut-cli> <verified-options>
```

필수 결과:

- discovery가 명세 최소값보다 작으면 실패
- test failure가 non-zero exit 또는 CI failure로 전달됨
- JUnit/report artifact 생성
- 실행 전후 production hash 불변
- test artifact는 허용 경로 또는 `user://`에만 생성
- Windows와 Android가 공유하는 core consumer를 동일 GUT suite로 검증

## CI design

Phase B에서 별도 Required Check 후보 `GUT 9.7.1 Tests`를 추가한다.

```text
checkout exact HEAD
→ install exact Godot 4.7.1
→ verify GUT plugin version/source manifest/license
→ record production hashes
→ run GUT CLI
→ assert minimum discovery
→ publish JUnit/report even on failure
→ recompute production hashes
→ fail on mutation or forbidden artifact
→ run existing static/import/shared-core checks
```

CI가 `.tscn`, `.tres`, `.res`, `project.godot`, production data·asset을 수정하면 실패한다.

## Windows and Android shared-core coverage

GUT는 플랫폼 중립 도메인과 상태 전이를 검증한다. Windows·Android 차이는 입력 변환, responsive UI, back/safe-area, export·lifecycle adapter에 제한한다.

```yaml
windows_execution: HEADLESS_SHARED_CORE_PLUS_WINDOWS_EXPORT_AND_RUNTIME_SEPARATE_GATE
android_shared_core_coverage: SAME_GUT_CORE_TESTS_PLUS_ANDROID_DEVICE_ADAPTER_SMOKE
platform_logic_duplication: FORBIDDEN
```

## HiGodot prerequisites

Scene·Resource·project setting 변경이 필요한 Phase B/게임 구현 전에 다음이 필요하다.

- canonical source `hi-godot/godot-ai`
- pinned tag/commit `v3.1.2 / 678b16a6a0a335cf80cbb7d3f85c183cd3e616de`의 provenance 검증
- Godot 4.7.x 호환성 및 telemetry 설정 검토
- 실제 authoring tool 연결
- 대상 파일 lock와 pre/post hash
- `HIGODOT_AUTHORING_MANIFEST`

도구 연결을 실제 확인하지 못하면 Scene·Resource·project setting 작업은 `BLOCKED_BY_HIGODOT_AUTHORITY`다.

## Upgrade process

1. 새 공식 release와 Godot 호환 표를 확인한다.
2. 별도 Decision과 spec 변경 PR에서 source commit·tree·license를 갱신한다.
3. 현재 GUT suite와 rollback dry-run을 exact HEAD에서 실행한다.
4. 승인 전에는 vendor 파일과 Required Check를 변경하지 않는다.

## Removal process

1. 별도 제거 Decision과 보호 범위를 승인한다.
2. GUT 전용 test를 대체·보관·삭제한다.
3. GUT CI job, report 경로와 Required Check를 제거한다.
4. HiGodot으로 plugin enablement를 해제한다.
5. `addons/gut`, config와 문서 참조를 제거한다.
6. `project.godot`, docs, scripts, workflows의 잔여 참조를 검색한다.
7. clean import, 기존 production 실행, shared-core regression을 재검증한다.
8. 제거 전후 diff와 rollback commit을 기록한다.

## Rollback conditions

- official source/tree/integrity를 재현하지 못함
- Godot 4.7.1에서 plugin parse/import 실패
- discovery 0 또는 minimum 미달
- failure exit code가 CI에 전달되지 않음
- production mutation 발생
- HiGodot 권위 침범
- 기존 핵심 regression을 동등하게 보존하지 못함
- Windows·Android shared-core 결과가 분기됨

## Phase gates

```text
GUT_SPEC_DRAFT_PR_OPEN
→ official source/license/tree evidence complete
→ current install divergence documented
→ consumer/CI/mutation/removal/non-overlap review complete
→ GUT_SPEC_APPROVED_EXACT_HEAD
→ GUT_SPEC_MERGED_MAIN_VERIFIED
→ GUT_INSTALLATION_AUTHORIZED
→ Phase B implementation branch
```

이 명세 PR에서는 `GUT_SPEC_MERGED_MAIN_VERIFIED` 이후 단계의 완료를 선언하지 않는다.
