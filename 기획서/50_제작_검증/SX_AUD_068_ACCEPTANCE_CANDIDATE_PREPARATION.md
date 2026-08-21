# SX-AUD-068 · SX-DEC-059 Acceptance Candidate Preparation

Date: `2026-08-21 KST`
Status: `PREPARED · PR_VALIDATION_REQUIRED`

## Goal

SX-DEC-059의 자동화 구현/정본 closure 다음 단계에서 물리·사람 증거를 오염시키지 않고 **실제로 실행 가능한 Windows acceptance candidate + developer self-run record**를 준비한다.

제품 코드·Scene·Resource·data·asset을 변경하지 않는다.

## Fresh baseline

```yaml
current_main: a036aab2b8d9059f10a0bebe7def33da4dd556e7
open_pr_before_work: 0
sx_dec_059_implementation_pr: 158 · MERGED
sx_dec_059_canon_freshness_pr: 159 · MERGED
sx_aud_067_sync_closure_pr: 160 · MERGED
notion_sync: SYNCED
physical_windows: NOT_RUN
android_device: NOT_RUN
five_person_comprehension: NOT_RUN
player_experience: NOT_RUN
```

## Artifact evidence

GitHub Windows Demo Export run `32489922889` / run #257의 artifact `9449351686`을 다운로드하고 독립적으로 다시 검증했다.

```yaml
artifact_name: switchy-express-windows-demo-61343d2c1062aefcbb59d5ae2ba911a15205f41a
artifact_zip_bytes: 37009791
github_digest: sha256:30bd8ce9f2e057bede06145c4ff05d46a0cfdb04e239e55f45547862dc3b0264
recomputed_zip_sha256: 30bd8ce9f2e057bede06145c4ff05d46a0cfdb04e239e55f45547862dc3b0264
digest_match: PASS
exe_format: PE32+ x86-64 Windows GUI
exe_bytes: 102982144
exe_sha256: 1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244
pck_bytes: 808128
pck_sha256: f8c8f805fe8475a87a3fd5c93a3c461aedc40068d2d43932cfddd44e44ef25b6
windows_runtime_json: PASS · parsed_json=26
android_validation_runtime_json: PASS · parsed_json=26
```

이것은 artifact/package integrity 증거다. Windows physical launch/visual/input 증거가 아니다.

## Canon drift found during preparation

`SX_DEC_059_FIRST_SESSION_PLAYTEST_DELTA.md`가 current Delta이면서:

```text
implementation_authority: NOT_GRANTED
```

를 유지했다. 실제 권위는 PR #158 `MERGED_MAIN_VERIFIED`이므로 동일 ID의 current playtest owner를 교정한다.

이 교정은 새 implementation authority를 부여하는 것이 아니라 이미 실행·병합된 사실을 반영한다.

## Adopted structure

```text
SX59-ACCEPT-001 artifact identity
→ independent hash verification
→ Developer Self-Run Record 8 scenarios
→ fail-closed blocker check
→ only then ACCEPTANCE_BUILD designation
→ same-build physical smoke
→ Five-person first-contact comprehension
```

Self-run 전 candidate를 `ACCEPTANCE_BUILD`라고 부르지 않는다.

## Adversarial review · five passes

### PASS 1 · Evidence inflation attack

공격: Windows export PASS를 physical runtime PASS로 오해할 수 있다.

결론: candidate 문서와 Wrapper에 `artifact_integrity: PASS`, `windows_physical_runtime: NOT_RUN`을 분리한다. `PASS` 승격 금지.

### PASS 2 · Build identity attack

공격: current main은 #159/#160 docs closure까지 포함하지만 artifact는 PR #159 workflow에서 생성됐다.

결론: artifact를 current main exact-tree build라고 부르지 않는다. PR #158 이후 product-owned 경로가 변경되지 않았다는 범위에서 **현재 제품 의미의 candidate**로만 사용한다.

### PASS 3 · Stale artifact attack

공격: artifact가 만료되거나 product file이 바뀐 뒤에도 같은 evidence를 재사용할 수 있다.

결론: 만료/hash mismatch/product-affecting change/lesson 의미 변경/self-run P0/P1을 invalidating condition으로 고정한다.

### PASS 4 · False self-run attack

공격: automated integration test가 T1~T6를 통과했다는 이유로 developer self-run을 PASS 처리할 수 있다.

결론: `SX_DEC_059_DEVELOPER_SELF_RUN_RECORD.md`를 별도 owner로 만들고 실제 물리 실행 전 모든 scenario를 `NOT_RUN`으로 둔다.

### PASS 5 · Human evidence contamination attack

공격: developer가 정답을 알고 수행한 self-run 결과를 first-contact 이해 증거로 사용할 수 있다.

결론: self-run은 implementation blocker 제거용 technical/usability evidence에 한정한다. Five-person first-contact는 별도 exact-build physical smoke 이후에만 실행한다.

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

## Completion gate

이 PR은 다음이 모두 참일 때 merge 가능하다.

```text
changed files = playtest/evidence/test docs only
Project Contract PASS
strengthened SX-DEC-059 freshness test PASS
Godot regression PASS
GUT PASS
Thin Adapter PASS
branch behind main 0
unresolved review threads 0
REQUEST_CHANGES 0
```

Merge 후:

1. Issue #7에 `SX59-ACCEPT-001 PREPARED`를 기록한다.
2. Notion Project Home/Handoff에 candidate integrity PASS / self-run NOT_RUN을 최소 동기화한다.
3. 실제 developer self-run 전에는 acceptance build를 지정하지 않는다.

## Current evidence ceiling

```yaml
candidate_preparation: PASS_PENDING_PR_VALIDATION
candidate_id: SX59-ACCEPT-001
developer_self_run: NOT_RUN
acceptance_build: NOT_YET_DESIGNATED
windows_physical_runtime: NOT_RUN
android_device: NOT_RUN
five_person_comprehension: NOT_RUN
player_experience: NOT_RUN
production_cutover: BLOCKED_DEFERRED
```
