# SX-DEC-059 · Playable POC Acceptance Candidate 02

Date: `2026-08-24 KST`
Status: `PREPARED · PENDING_DEVELOPER_SELF_RUN · NOT_YET_ACCEPTANCE_BUILD`

## Purpose

PR #166으로 병합된 **playable visual/UX POC**를 실제 Windows self-run과 후속 physical/human 검증에 넘기기 위한 current exact artifact 후보를 고정한다.

기존 `SX59-ACCEPT-001`은 PR #166 이전 runtime/visual bytes를 대표하는 역사 candidate다. 현재 POC의 board/HUD/title/lesson/result visual integration을 포함하지 않으므로 current POC physical validation에는 재사용하지 않는다.

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
artifact_id: 5439198762
artifact_name: switchy-express-windows-159a3a741ef79b6207be290cc284bd63a5979e72
artifact_expires_at: 2026-11-22
artifact_zip_sha256: c0a7856efaeb278ac1501ee5b36ec4af15c088aefd88b759eb15681c7ce4fd42
windows_exe_sha256: 90347bb3e5ef28760385777b63a87be5c1572a9e8c3f11e619fac6fabfb44103
windows_pck_sha256: 089c9b78bb3e82bbf1accce7fe26b2306700e2800c590cbac1763252b7a2ea7a
engine: Godot 4.7.1-stable
```

PR #166 base가 merge 직전까지 이동하지 않았고 PR HEAD tree와 merge-main tree가 동일하다. 따라서 위 artifact는 **병합된 POC code/resource tree와 exact tree-equivalent**다. merge commit SHA 자체에서 rebuild됐다고 과장하지 않는다.

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
artifact_hashing: PASS
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

Windows에서 받은 ZIP에 대해:

```powershell
Get-FileHash .\switchy-express-windows-159a3a741ef79b6207be290cc284bd63a5979e72.zip -Algorithm SHA256
```

기대값:

```text
c0a7856efaeb278ac1501ee5b36ec4af15c088aefd88b759eb15681c7ce4fd42
```

압축 해제 후 EXE/PCK 기대값:

```text
EXE  90347bb3e5ef28760385777b63a87be5c1572a9e8c3f11e619fac6fabfb44103
PCK  089c9b78bb3e82bbf1accce7fe26b2306700e2800c590cbac1763252b7a2ea7a
```

## Invalidating conditions

다음 변경이 생기면 candidate 002를 재사용하지 않는다.

- `game/**`, `data/**`, `art/product_assets/**`, `project.godot`, `export_presets.cfg`, Scene/Resource의 player-visible/runtime 의미 변경
- first-session learning/input/result meaning 변경
- artifact hash mismatch 또는 artifact 만료/회수 불가
- developer self-run에서 P0/P1 blocker 발견

문서-only 정본 sync는 candidate bytes를 바꾸지 않는다.

## Evidence ceiling

```yaml
artifact_integrity: PASS
package_runtime_json_proof: PASS
playable_poc_automated: PASS
developer_self_run: NOT_RUN
acceptance_build: NOT_YET_DESIGNATED
windows_physical_runtime: NOT_RUN
android_device: NOT_RUN
five_person_comprehension: NOT_RUN
player_experience: NOT_RUN
production_cutover: BLOCKED_DEFERRED
```