# SX-AUD-068 · SX-DEC-059 Acceptance Candidate Preparation

Date: `2026-08-21 KST`
Status: `PASS · CLOSED · CANDIDATE_PREPARED · SELF_RUN_NOT_RUN`

## Goal

SX-DEC-059의 자동화 구현/정본 closure 다음 단계에서 물리·사람 증거를 오염시키지 않고 **실제로 실행 가능한 Windows acceptance candidate + developer self-run record**를 준비했다.

제품 코드·Scene·Resource·data·asset은 변경하지 않았다.

## Final closure evidence

```yaml
baseline_main: a036aab2b8d9059f10a0bebe7def33da4dd556e7
acceptance_preparation_pr: 161
pr_161_exact_head: 1fded950579f7767849840dd5546dea70d8c995f
pr_161_merge_main: cc676f579ab92edb4c0bf88e9210b36d3aa82ca1
changed_files: 6 · PLAYTEST_EVIDENCE_TEST_ONLY
product_runtime_files_changed: 0
project_contract: PASS · run_1286
godot_tests: PASS · run_1217
gut_9_7_1: PASS · run_335
thin_adapter: PASS · run_405
windows_demo_export: PASS · run_258
branch_behind_main: 0
unresolved_review_threads: 0
request_changes: 0
issue_7: OPEN · CURRENT_GATE_SX_AUD_068
notion_project_home: SYNCED
notion_repo_main_sha: cc676f579ab92edb4c0bf88e9210b36d3aa82ca1
candidate_id: SX59-ACCEPT-001
candidate_status: PREPARED · PENDING_DEVELOPER_SELF_RUN
developer_self_run: NOT_RUN
acceptance_build: NOT_YET_DESIGNATED · BLOCKED_BY_SELF_RUN
windows_physical_runtime: NOT_RUN
android_device: NOT_RUN
five_person_comprehension: NOT_RUN
player_experience: NOT_RUN
production_cutover: BLOCKED_DEFERRED
```

## Candidate artifact evidence

GitHub Windows Demo Export run `32489922889` / #257의 artifact `9449351686`을 다운로드해 독립 재검증했다.

```yaml
artifact_name: switchy-express-windows-demo-61343d2c1062aefcbb59d5ae2ba911a15205f41a
artifact_expires_at: 2026-09-04T14:02:28Z
artifact_zip_bytes: 37009791
artifact_zip_sha256: 30bd8ce9f2e057bede06145c4ff05d46a0cfdb04e239e55f45547862dc3b0264
github_digest_match: PASS
exe_format: PE32+ x86-64 Windows GUI
exe_bytes: 102982144
exe_sha256: 1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244
pck_bytes: 808128
pck_sha256: f8c8f805fe8475a87a3fd5c93a3c461aedc40068d2d43932cfddd44e44ef25b6
windows_runtime_json: PASS · parsed_json=26
android_validation_runtime_json: PASS · parsed_json=26
```

이것은 artifact/package integrity 증거다. Windows physical launch/visual/input 증거가 아니다.

## Cross-run identity check

PR #161 exact head에서도 Windows Demo Export #258이 PASS했다. 새 artifact는 동일한 Windows executable hash를 만들었지만 PCK hash는 docs/test source 변화 때문에 달라졌다.

```yaml
pr_161_export_run: 32493540711 · #258
pr_161_artifact_id: 9450740175
pr_161_zip_sha256: a920d210bf492356cc0ae4b0fdd6fb2e32bb204b12c0ad1e3535dfa53c2657fa
pr_161_exe_sha256: 1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244
pr_161_pck_sha256: 46236f4b7783db6ea658c0268e91d0673f03d22b9060117f064a938afcc045c6
```

따라서 source branch가 비슷하다는 이유로 artifact identity를 추정하지 않는다. 실제 self-run/session evidence는 `SX59-ACCEPT-001`의 exact ZIP/EXE/PCK hash에 묶는다.

## Canon drift fixed during preparation

`SX_DEC_059_FIRST_SESSION_PLAYTEST_DELTA.md`가 current Delta이면서 `implementation_authority: NOT_GRANTED`를 유지하던 상태를 교정했다.

현재 권위:

```text
implementation_authority: EXECUTED · PR_158_MERGED_MAIN_VERIFIED
acceptance_candidate: SX59-ACCEPT-001 · PREPARED · NOT_YET_ACCEPTANCE_BUILD
developer_self_run: NOT_RUN
```

새 implementation authority를 부여한 것이 아니라 이미 실행·병합된 사실을 current playtest owner에 반영한 것이다.

## Adopted evidence chain

```text
SX59-ACCEPT-001 exact artifact identity
→ independent hash verification: PASS
→ Developer Self-Run Record 8 scenarios: NOT_RUN
→ fail-closed blocker check
→ only then ACCEPTANCE_BUILD designation
→ same-build physical smoke
→ Five-person first-contact comprehension
```

Self-run 전 candidate를 `ACCEPTANCE_BUILD`라고 부르지 않는다.

## Adversarial review · five passes

### PASS 1 · Evidence inflation attack · CLOSED

Windows export PASS와 artifact integrity PASS를 physical runtime PASS로 승격하지 않는다.

### PASS 2 · Build identity attack · CLOSED

`SX59-ACCEPT-001`을 current main exact-tree rebuild라고 주장하지 않는다. PR #158 이후 product-owned 경로가 바뀌지 않았다는 bounded equivalence와 exact artifact hash를 함께 기록한다.

### PASS 3 · Stale artifact attack · CLOSED

artifact 만료, hash mismatch, product-affecting change, lesson/UI/input 의미 변경, self-run P0/P1 발견을 candidate invalidation 조건으로 고정했다.

### PASS 4 · False self-run attack · CLOSED

자동 integration test를 developer self-run으로 대체하지 않는다. `SX_DEC_059_DEVELOPER_SELF_RUN_RECORD.md` 8개 시나리오는 실제 실행 전 모두 `NOT_RUN`이다.

### PASS 5 · Human evidence contamination attack · CLOSED

developer self-run은 implementation blocker 제거용 technical/usability evidence다. first-contact 이해도 증거는 exact designated build의 physical smoke 이후 별도로 수집한다.

## Protected boundary

```text
project.godot: unchanged
game/**: unchanged
data/**: unchanged
assets/**: unchanged
art/product_assets/**: unchanged
Scene/Resource: unchanged
GMB-002 rules: unchanged
SX-DEC-056/057/058 implementation authority: unchanged
physical/human evidence: NOT_RUN
```

## Current next gate

```text
verify exact SX59-ACCEPT-001 ZIP/EXE/PCK hashes on Windows
→ execute SX_DEC_059_DEVELOPER_SELF_RUN_RECORD.md scenarios 1~8
→ if blocker counts are all 0, designate exact Windows acceptance build
→ same-build Windows physical smoke
→ separate Android device smoke
→ Five-person first-contact comprehension
→ EXPAND / REWORK / REPEAT_SLICE / HOLD / STOP
```

## Rollback / invalidation

이 preparation은 제품 bytes를 변경하지 않는다. candidate가 무효화되면 `SX59-ACCEPT-001`을 폐기하고 새 artifact identity로 `SX59-ACCEPT-002+`를 만든다. PR #158 제품 구현이나 SX-AUD-067 정본 closure를 되돌리지 않는다.

## Current evidence ceiling

```yaml
candidate_preparation: PASS · CLOSED
candidate_id: SX59-ACCEPT-001
artifact_integrity: PASS
package_runtime_json: PASS
developer_self_run: NOT_RUN
acceptance_build: NOT_YET_DESIGNATED
windows_physical_runtime: NOT_RUN
android_device: NOT_RUN
five_person_comprehension: NOT_RUN
player_experience: NOT_RUN
production_cutover: BLOCKED_DEFERRED
```
