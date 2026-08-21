# SX-DEC-059 · Acceptance Candidate 01

Date: `2026-08-21 KST`
Status: `PREPARED · PENDING_DEVELOPER_SELF_RUN · NOT_YET_ACCEPTANCE_BUILD`

## Purpose

SX-DEC-059 release-near first-session을 물리/사람 검증으로 넘기기 전에 사용할 **exact artifact 후보**를 고정한다.

이 문서는 artifact 무결성·제품 의미 동등성·self-run 시나리오를 묶는 evidence record다. **Developer self-run, Windows physical runtime, Android device, Five-person comprehension을 PASS로 선언하지 않는다.**

## Candidate identity

```yaml
candidate_id: SX59-ACCEPT-001
product_implementation_pr: 158
product_implementation_merge: 162e8a0a5e8ddc8472e74a6152e87dc12008e34c
current_canon_main_at_preparation: a036aab2b8d9059f10a0bebe7def33da4dd556e7
artifact_workflow: Windows Demo Export
artifact_workflow_run_id: 32489922889
artifact_workflow_run_number: 257
artifact_workflow_head: e773266b76bd19de60b8d53363c8cf820484f3eb
artifact_pr_merge_test_sha: 61343d2c1062aefcbb59d5ae2ba911a15205f41a
artifact_id: 9449351686
artifact_name: switchy-express-windows-demo-61343d2c1062aefcbb59d5ae2ba911a15205f41a
artifact_expires_at: 2026-09-04T14:02:28Z
artifact_zip_bytes: 37009791
artifact_zip_sha256: 30bd8ce9f2e057bede06145c4ff05d46a0cfdb04e239e55f45547862dc3b0264
```

## Independent artifact verification

Artifact ZIP을 다운로드해 컨테이너에서 다시 해시·압축 해제했다.

```yaml
zip_sha256_recomputed: 30bd8ce9f2e057bede06145c4ff05d46a0cfdb04e239e55f45547862dc3b0264
zip_digest_matches_github: PASS
windows_exe: SwitchyExpressVerticalSlice.exe
windows_exe_format: PE32+ x86-64 Windows GUI
windows_exe_bytes: 102982144
windows_exe_sha256: 1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244
windows_pck: SwitchyExpressVerticalSlice.pck
windows_pck_bytes: 808128
windows_pck_sha256: f8c8f805fe8475a87a3fd5c93a3c461aedc40068d2d43932cfddd44e44ef25b6
windows_runtime_json_proof_pck_sha256: f8c8f805fe8475a87a3fd5c93a3c461aedc40068d2d43932cfddd44e44ef25b6
android_validation_runtime_json_proof_pck_sha256: 120802da8b1eed60331f30bb6b3f4f1bddf8f43bc10cd0c2a774598984dcb612
windows_runtime_json_proof: PASS · parsed_json=26
android_validation_runtime_json_proof: PASS · parsed_json=26
engine_in_proof_log: Godot 4.7.1-stable
```

`SHA256SUMS.txt`의 EXE/PCK 해시와 독립 재계산 값이 일치한다.

## Product-equivalence boundary

Artifact는 PR #158 제품 구현 이후 생성됐다. 이후 PR #159/#160은 canonical docs/test/workflow/audit 계층만 변경했고 다음 제품 소유 경로는 변경하지 않았다.

```text
game/**
data/**
assets/**
art/product_assets/**
project.godot
export_presets.cfg
*.tscn / *.tres / *.res
VS_DEMO_01 bytes/semantic
GMB-002 gameplay rules
```

따라서 `SX59-ACCEPT-001`은 **현재 제품 의미의 Windows self-run/physical-smoke 후보**로 사용할 수 있다. 다만 current main 전체 tree를 exact하게 rebuild한 artifact라고 과장하지 않는다.

## Promotion gate

다음이 모두 충족되기 전에는 `ACCEPTANCE_BUILD`로 승격하지 않는다.

```text
1. artifact ZIP SHA-256 확인
2. EXE/PCK SHA-256 확인
3. developer self-run 8개 시나리오 완료
4. progression dead-end = 0
5. hidden-command bypass = 0
6. raw localization key = 0
7. player-facing placeholder = 0
8. crash/script error = 0
9. unsupported evidence claim = 0
10. unresolved P0/P1 implementation blocker = 0
```

통과 시 이 artifact identity를 exact Windows acceptance build로 지정할 수 있다. 하나라도 실패하면 `REWORK` 또는 새 candidate를 만든다.

## Developer self-run scenarios

1. T1→T6→Capstone happy path.
2. T3 wrong LIFO order → natural failure → Edit → recovery.
3. T4 first-pass overloading → selective non-load recovery without solution reveal.
4. T5 Auto ON safe segment → OFF before decision cargo.
5. T6 switch preselection + occupied-lock observation.
6. Capstone Retry Same Layout.
7. Capstone Edit Layout.
8. Reduced Motion same-information path.

## Local artifact check before launch

Windows PowerShell에서 artifact를 받은 폴더에서:

```powershell
Get-FileHash .\switchy-express-windows-demo.zip -Algorithm SHA256
```

ZIP 해시는 반드시 다음과 같아야 한다.

```text
30bd8ce9f2e057bede06145c4ff05d46a0cfdb04e239e55f45547862dc3b0264
```

압축 해제 후:

```powershell
Get-FileHash .\SwitchyExpressVerticalSlice.exe -Algorithm SHA256
Get-FileHash .\SwitchyExpressVerticalSlice.pck -Algorithm SHA256
```

기대값:

```text
EXE  1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244
PCK  f8c8f805fe8475a87a3fd5c93a3c461aedc40068d2d43932cfddd44e44ef25b6
```

그 뒤 `SwitchyExpressVerticalSlice.exe`를 실행하고 `SX_DEC_059_DEVELOPER_SELF_RUN_RECORD.md`에 관찰을 기록한다.

## Invalidating conditions

다음 중 하나면 이 candidate를 재사용하지 않는다.

- artifact 만료/재다운로드 불가
- ZIP/EXE/PCK hash mismatch
- `game/**`, `data/**`, `assets/**`, `art/product_assets/**`, `project.godot`, `export_presets.cfg`, Scene/Resource 변경
- first-session learning/UI/input 의미 변경
- self-run에서 P0/P1 blocker 발견

문서/감사 metadata만 바뀐 경우에도 actual artifact identity는 그대로 기록하되, 물리/사람 round에서는 사용한 exact artifact hash를 session evidence에 남긴다.

## Evidence ceiling

```yaml
artifact_integrity: PASS
package_runtime_json_proof: PASS
candidate_preparation: PASS
developer_self_run: NOT_RUN
acceptance_build: NOT_YET_DESIGNATED
windows_physical_runtime: NOT_RUN
android_device: NOT_RUN
five_person_comprehension: NOT_RUN
player_experience: NOT_RUN
production_cutover: BLOCKED_DEFERRED
```
