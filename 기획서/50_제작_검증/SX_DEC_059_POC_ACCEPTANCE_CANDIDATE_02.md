# SX-DEC-059 · Playable POC Acceptance Candidate 02

Date: `2026-08-24 KST`  
Status: `PACKAGE_EVIDENCE_RECONCILED · PENDING_DEVELOPER_SELF_RUN · NOT_YET_ACCEPTANCE_BUILD`

## Purpose

PR #166으로 병합된 **playable visual/UX POC**를 실제 Windows self-run과 후속 physical/human 검증에 넘기기 위한 current exact package 후보를 고정한다.

기존 `SX59-ACCEPT-001`은 PR #166 이전 runtime/visual bytes를 대표하는 역사 candidate다. 현재 POC의 board/HUD/title/lesson/result visual integration을 포함하지 않으므로 current POC physical validation에는 재사용하지 않는다.

## Evidence ownership

Machine-readable authority:

`evidence/acceptance/sx59_poc_accept_002_artifact.json`

증거를 두 종류로 분리한다.

```text
artifact_id / artifact_name / artifact_expires_at = EPHEMERAL_DELIVERY_METADATA
artifact/API digest + downloaded ZIP/EXE/PCK SHA-256 = DURABLE_CONTENT_IDENTITY
```

GitHub Actions artifact의 ID·이름·만료일은 다운로드/조회 편의를 위한 현재 메타데이터다. Candidate의 장기 package identity는 content digest와 내부 실행 패키지 SHA-256으로 고정한다.

`pull_request` workflow에서 artifact 이름의 `${{ github.sha }}` suffix는 workflow-context merge ref SHA가 될 수 있으므로 PR HEAD와 동일하다고 가정하지 않는다. 이 run의 GitHub API `head_sha`는 PR #166 HEAD `159a3a...`이고, artifact name suffix는 `9b70b9...`다.

## Candidate identity

```yaml
candidate_id: SX59-POC-ACCEPT-002
supersedes_candidate: SX59-ACCEPT-001
supersedes_reason: PLAYABLE_POC_RUNTIME_AND_VISUAL_BYTES_CHANGED
poc_runtime_pr: 166
poc_pr_head: 159a3a741ef79b6207be290cc284bd63a5979e72
poc_merge_main: 1bf798cedf28dffba9185edb62fb1c50c108fe90
poc_tree_sha: b3fa0ad93721d7f99614fb6f0bf594c7ce068127
artifact_head_tree_sha: b3fa0ad93721d7f99614fb6f0bf594c7ce068127
merged_tree_matches_artifact_head_tree: PASS
artifact_workflow: Windows Demo Export
artifact_workflow_run_id: 32692759675
artifact_workflow_run_number: 311
artifact_head: 159a3a741ef79b6207be290cc284bd63a5979e72
artifact_id: 9507816480
artifact_name: switchy-express-windows-demo-9b70b9ecf62494b049d4e39d173a049a89a907b7
artifact_expires_at: 2026-09-07T05:15:01Z
artifact_api_digest_sha256: 16c81f9b42a3391a2a3dabf501cb2d6eb7e011682abdaa3f79eb8b1124836e55
artifact_zip_sha256: 16c81f9b42a3391a2a3dabf501cb2d6eb7e011682abdaa3f79eb8b1124836e55
windows_exe_sha256: 1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244
windows_pck_sha256: d48fe09796954f3b4f836d092b4184cb0ac33bc6f1f3b96f52166e2d6760aa0f
engine: Godot 4.7.1-stable
```

Fresh GitHub API readback와 artifact ID `9507816480`의 재다운로드를 독립 검증했다. API digest와 downloaded ZIP SHA-256은 정확히 동일하며, ZIP 내부 `SHA256SUMS.txt`와 독립 계산한 EXE/PCK SHA-256도 일치한다.

PR #166 base가 merge 직전까지 이동하지 않았고 PR HEAD tree와 merge-main tree가 동일하다. 따라서 위 artifact는 **병합된 POC code/resource tree와 exact tree-equivalent**다. merge commit SHA 자체에서 rebuild됐다고 과장하지 않는다.

## 2026-08-24 evidence reconciliation incident

기존 candidate 문서는 같은 workflow run에 대해 artifact ID `5439198762`, 다른 artifact name/expiry, 그리고 `c0a785... / 90347b... / 089c9b...` package hash를 기록하고 있었다. Fresh Actions API + artifact 재다운로드에서 이 값들이 실제 run `32692759675`의 artifact와 일치하지 않음을 확인했다.

원인 범위:

- 기존 Python postmerge test가 live artifact가 아니라 문서에 복제된 hardcoded 값을 상호 비교했다.
- 따라서 문서끼리 같은 잘못된 값을 가지면 CI가 통과할 수 있었다.
- workflow는 실제로 `switchy-express-windows-demo-${{ github.sha }}`와 `retention-days: 14`를 사용한다.

교정:

- machine-readable single evidence owner 추가.
- durable content digest와 ephemeral delivery metadata 분리.
- candidate/audit/self-run/test가 같은 evidence owner와 일치하도록 fail-closed 계약 추가.
- gameplay/runtime/image/audio bytes는 변경하지 않는다.

## Packaged proof

```yaml
project_contract: PASS
thin_adapter: PASS
gut_9_7_1: PASS
godot_headless_cases: 111 · PASS
playable_poc_visual_contract: PASS
windows_demo_export: PASS
windows_packaged_runtime_json_proof: PASS · parsed_json=26
android_packaged_runtime_json_proof: PASS · parsed_json=26
artifact_hashing: PASS · API_DIGEST_EQUALS_DOWNLOADED_ZIP
```

Automated proof는 다음을 확인한다.

- T1→T6→Capstone first-session flow가 기존 finite domain authority를 유지한다.
- board / HUD / title / lesson briefing / result가 approved E+D Hybrid product assets를 실제 load/consume한다.
- straight/curve/switch/crossing build tool이 동일 rail visual language를 사용한다.
- result success/failure가 승인된 서로 다른 result art를 사용한다.
- 1280×720 / 1600×900 / 1920×1080 / 2560×1080 / 960×540 의미가 보존된다.
- visible touch control minimum 48px와 Reduced Motion information identity가 유지된다.
- Windows export와 Android packaged PCK에서 runtime JSON proof가 성공한다.

## Developer self-run gate

이 candidate는 아직 acceptance build가 아니다. 다음 8개 시나리오를 실제 화면·입력으로 수행해야 한다.

1. T1→T6→Capstone happy path.
2. T3 wrong LIFO order → failure → Edit → recovery.
3. T4 overloading → selective non-load recovery.
4. T5 Auto ON safe segment → OFF before decision cargo.
5. T6 switch preselection + occupied-lock observation.
6. Capstone Retry Same Layout.
7. Capstone Edit Layout.
8. Reduced Motion same-information path.

필수 blocker 기준:

```text
progression dead-end = 0
hidden-command bypass = 0
raw localization key = 0
player-facing placeholder = 0
crash/script error = 0
critical image missing = 0
critical UI clipping = 0
unsupported evidence claim = 0
unresolved P0/P1 implementation blocker = 0
```

## Local hash check

현재 artifact를 Windows에 보존한 경우 ZIP 자체를 검사한다.

```powershell
Get-FileHash .\sx59-poc-accept-002.zip -Algorithm SHA256
```

기대값:

```text
16c81f9b42a3391a2a3dabf501cb2d6eb7e011682abdaa3f79eb8b1124836e55
```

압축 해제 후 EXE/PCK 기대값:

```text
EXE  1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244
PCK  d48fe09796954f3b4f836d092b4184cb0ac33bc6f1f3b96f52166e2d6760aa0f
```

Artifact가 retention 만료되더라도 이미 검증·보존된 content digest의 정체성은 변하지 않는다. 다만 새 물리 검증자가 원본 artifact를 다시 받을 수 없다면 동일 digest package를 보존본에서 확보하거나, current tree에서 새 candidate를 재빌드해 별도 identity로 승격해야 한다.

## Invalidating conditions

다음 변경이 생기면 candidate 002를 재사용하지 않는다.

- `game/**`, `data/**`, `art/product_assets/**`, `project.godot`, `export_presets.cfg`, Scene/Resource의 player-visible/runtime 의미 변경
- first-session learning/input/result meaning 변경
- 보존/다운로드한 package의 content digest mismatch
- developer self-run에서 P0/P1 blocker 발견

Artifact ID/name/expiry 변경 또는 retention 만료 자체는 content identity를 변경하지 않는다. 문서-only 정본 sync도 candidate bytes를 바꾸지 않는다.

## Evidence ceiling

```yaml
artifact_integrity: PASS · LIVE_API_AND_INDEPENDENT_DOWNLOAD_RECONCILED
package_runtime_json_proof: PASS
playable_poc_automated: PASS
developer_self_run: NOT_RUN
acceptance_build: NOT_YET_DESIGNATED
windows_physical_runtime: NOT_RUN
audio_perceptual_qa: NOT_RUN
android_device: NOT_RUN
five_person_comprehension: NOT_RUN
player_experience: NOT_RUN
production_cutover: BLOCKED_DEFERRED
```
