# Android Device Smoke Runbook

```yaml
runbook_state: HISTORICAL_VALIDATION_APK_RUNBOOK · NOT_CURRENT_PHASE_5_EXECUTION
execution_state: NOT_RUN · HISTORICAL_ARTIFACT_ONLY
current_audit: SX-AUD-019
current_evidence: EV-FP-APK-001
canonical_export_source: 536911449018a3caf3511bc64e7bf1a66edf2016
apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
package_id: com.alsdmlals4.switchyexpress.validation
orientation: landscape
required_device: PHYSICAL_ANDROID_DEVICE
five_person_comprehension: HISTORICAL_CONTRACT_ONLY
production_cutover: BLOCKED
```

이 문서는 historical validation APK의 Android 실기기 검증 절차다. Runbook 존재, 자동 테스트, Emulator 실행 또는 화면 녹화만으로 Android Gate를 통과하지 않는다.

> Current Phase 5 notice: 이 runbook의 APK hash/package ID는 pre-SX-DEC-060 validation artifact다. `SX60-POC-ACCEPT-003`는 현재 Windows exact candidate만 지정하며, Android runtime JSON proof가 이 APK를 post-060 human/device candidate로 승격하지 않는다. Current Phase 5 Android Gate는 `PLAYTEST_PLAN.md`와 `docs/superpowers/plans/2026-08-28-phase5-human-validation.md`를 먼저 읽고, exact post-060 Android artifact ID·hash·source를 지정한 뒤 별도 runbook으로 재개한다.

## 1. 검증 경계

```text
AUTOMATED CORE: PASS
VALIDATION PREPARATION: PASS
CANONICAL MAIN APK EXPORT: PASS
ANDROID DEVICE SMOKE: NOT_RUN · CURRENT
FIVE-PERSON COMPREHENSION: NOT_RUN · BLOCKED_BY_ANDROID
DEFAULT ENTRYPOINT: LEGACY
PRODUCTION CUTOVER: BLOCKED
```

- 이 APK는 debug validation 전용이며 출시용 APK가 아니다.
- 제품 `run/main_scene`과 production entrypoint를 변경하지 않는다.
- 모든 Android 결과는 위의 전체 64자리 APK SHA-256에 귀속한다.
- 수정되거나 새로 생성된 APK는 이전 Android·HUMAN 증거를 승계하지 않는다.
- Android PASS는 Five-person Comprehension 또는 Production Cutover PASS가 아니다.

## 2. Preflight

실행 전에 다음을 모두 확인하고 증거 Template에 기록한다.

1. APK 실제 SHA-256이 `eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea`와 완전히 일치한다.
2. Package ID가 `com.alsdmlals4.switchyexpress.validation`이다.
3. 물리 Android 기기를 사용한다. Emulator 결과는 보조 증거일 수 있지만 실기기 PASS를 대체하지 않는다.
4. 기기 별칭, 모델명, Android 버전, 해상도·density, landscape 방향과 touch 입력을 기록한다.
5. 알림, 계정명, 연락처, 사진, 메시지와 다른 앱 화면을 숨긴다.
6. IMEI, 시리얼 번호, 광고 ID, 전화번호, 이메일, 실명과 계정 식별자를 기록하지 않는다.
7. 녹화·스크린샷·로그 파일은 APK hash, 기기 별칭과 항목 ID로 연결한다.

APK hash나 package가 다르면 설치 성공 여부와 관계없이 `BLOCKED_HASH_MISMATCH` 또는 `BLOCKED_PACKAGE_MISMATCH`다.

## 3. 실행 순서

1. 이전 validation package가 설치되어 있으면 제거한다.
2. canonical APK를 설치한다.
3. 첫 부팅을 확인한다.
4. 앱을 완전히 종료하고 cold reboot한다.
5. Selector의 네 모드와 Back을 확인한다.
6. `PROOF`에서 BUILD·RUN·결과·재시도 전체 흐름을 수행한다.
7. `STACK 8/16/32`에서 TOP·rear·순서를 확인한다.
8. 레이아웃, safe area, touch target, crash·ANR·프레임 저하를 기록한다.
9. 대표 경로를 반복 실행한다.
10. 항목별 상태와 근거를 Template에 기록한다.

## 4. 필수 Android Matrix

상태는 `PASS`, `FAIL`, `BLOCKED`, `NOT_RUN` 중 하나만 사용한다.

| ID | Procedure | PASS criterion | Status | Evidence / Observation |
|---|---|---|---|---|
| AND-01 | install | canonical APK가 오류 없이 설치되고 validation package로 식별된다. | NOT_RUN | |
| AND-02 | first_boot | 설치 직후 첫 부팅에서 Selector가 정상 표시되고 crash·script error가 없다. | NOT_RUN | |
| AND-03 | cold_reboot | 앱 완전 종료 뒤 재실행해 동일 Selector 상태로 진입한다. | NOT_RUN | |
| AND-04 | selector_proof | `PROOF` 터치가 실제 finite proof Slice를 연다. | NOT_RUN | |
| AND-05 | selector_stack_8 | `STACK 8` 터치가 정확히 8개 token fixture를 연다. | NOT_RUN | |
| AND-06 | selector_stack_16 | `STACK 16` 터치가 정확히 16개 token fixture를 연다. | NOT_RUN | |
| AND-07 | selector_stack_32 | `STACK 32` 터치가 정확히 32개 token fixture를 연다. | NOT_RUN | |
| AND-08 | selector_back | 각 모드에서 Back으로 Selector에 복귀하고 이전 child가 중복 유지되지 않는다. | NOT_RUN | |
| AND-09 | build_place_rotate_replace_remove_clear | BUILD에서 place·rotate·replace·remove·clear가 한 번씩 정확히 반영되고 비용·graph와 일치한다. | NOT_RUN | |
| AND-10 | preflight_feedback | 불완전 배치에서 Start가 비활성이고 주 실패 이유와 문제 cell을 식별할 수 있다. | NOT_RUN | |
| AND-11 | build_run_result_retry_edit | 완성 배치에서 BUILD→RUN→SUCCESS/FAILURE→retry/edit 경로를 수행할 수 있다. | NOT_RUN | |
| AND-12 | load_hold | 화물 접촉 중 LOAD hold가 필요한 시점에 적재되고 release 후 불필요한 적재가 없다. | NOT_RUN | |
| AND-13 | auto_load_toggle | 운행 중 auto-load ON/OFF 상태가 읽히고 다음 접촉부터 적용된다. | NOT_RUN | |
| AND-14 | branch_direct_tap | RUNNING/UNLOADING 중 비점유 branch 직접 탭으로 다음 경로를 사전 설정한다. | NOT_RUN | |
| AND-15 | occupied_switch_lock | 열차가 branch를 점유하는 동안 탭해도 현재 경로가 바뀌지 않는다. | NOT_RUN | |
| AND-16 | pause_resume_movement_and_unload | 이동·하역 중 pause가 시계·열차·표시를 동결하고 resume 뒤 중복 commit 없이 계속한다. | NOT_RUN | |
| AND-17 | same_layout_fresh_runtime_retry | 실패 뒤 같은 sealed layout을 유지하면서 새 runtime identity로 재시도한다. | NOT_RUN | |
| AND-18 | top_readability_8_16_32 | 8·16·32 모두에서 rear/TOP과 bottom-to-TOP 순서를 색상 외 형상·텍스트로 식별한다. | NOT_RUN | |
| AND-19 | landscape_safe_area_touch_targets | 가로 화면에서 HUD·보드·버튼 잘림·겹침이 없고 핵심 touch target을 반복 조작할 수 있다. | NOT_RUN | |
| AND-20 | stability_repeat_crash_anr_frame | 대표 경로 반복 실행 중 crash·ANR·script error·심각한 프레임 저하·입력 누락이 없다. | NOT_RUN | |

## 5. Gate 판정

```text
PASS: AND-01~20 all PASS on one physical Android device with the canonical full APK SHA-256 and linked evidence.
FAIL: at least one executable required item fails.
BLOCKED: hash/package/device/evidence prerequisites prevent a valid run.
NOT_RUN: execution is possible but one or more required items were not performed.
```

- 하나라도 `FAIL`, `BLOCKED`, `NOT_RUN`이면 전체 Android Gate는 PASS가 아니다.
- 일부 모드만 실행하거나 영상만 남기고 항목 판정을 생략하면 전체 Gate는 `NOT_RUN` 또는 `BLOCKED`다.
- crash·ANR·심각한 프레임 저하가 재현되면 원인 확인과 재검증 전 PASS하지 않는다.
- 새 APK가 필요하면 이전 APK의 실기기·사람 증거를 자동 승계하지 않는다.
- 실제 결과 검토 전 `SX-AUD-020`을 확정하거나 GitHub·Google Sheet에 Android PASS를 기록하지 않는다.
- Android PASS와 reviewed evidence closure 뒤에만 같은 APK hash로 Five-person Comprehension을 시작한다.

## 6. 증거 연결

필수 기록:

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

`device_alias`와 `tester_alias`는 `D01`, `T01` 같은 최소 식별자만 사용한다. 증거 파일은 항목 ID를 포함하고 개인 알림·계정·연락처·기기 고유번호를 노출하지 않는다.

## 7. 결과 이후

```text
same APK hash verification
→ item completeness and privacy review
→ adversarial review
→ Android audit record
→ current decisions and Vertical Slice contract update
→ correct Google Sheet same-ID sync
→ merged main and Sheet readback
```

Correct Sheet는 `1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo`다. Wrong `19Ff...` Sheet는 변경하지 않는다.
