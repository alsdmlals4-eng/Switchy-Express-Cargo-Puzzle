# SX-AUD-069 · Playable Visual / UX POC

Date: `2026-08-24 KST`  
Status: `MERGED_MAIN_VERIFIED · AUTOMATED_AND_PACKAGE_PASS · ARTIFACT_EVIDENCE_RECONCILED · MANUAL_GATES_OPEN`

## Scope

PR #166은 기존 SX-DEC-059 first-session gameplay를 바꾸지 않고 **board / HUD / title / lesson briefing / result**를 하나의 playable visual/UX POC로 완성했다.

핵심 원칙:

- approved E+D Hybrid product assets 재사용
- 새 gameplay system / score / generator / 056~058 구현 없음
- player-visible board에서 train / rail / station / cargo asset 실제 load/consume
- build toolbar에 straight / curve / switch / crossing visual icon 연결
- title / lesson / result shell에서 동일 제품 visual language 사용
- result SUCCESS / FAILURE는 승인된 서로 다른 result art 사용
- procedural shape/text는 fallback 및 non-color readability 보조로 유지

## Merge identity

```yaml
poc_pr: 166
poc_pr_head: 159a3a741ef79b6207be290cc284bd63a5979e72
poc_merge_main: 1bf798cedf28dffba9185edb62fb1c50c108fe90
poc_head_tree: b3fa0ad93721d7f99614fb6f0bf594c7ce068127
poc_merge_tree: b3fa0ad93721d7f99614fb6f0bf594c7ce068127
tree_identity: PASS
```

## TDD / debugging evidence

### RED 1 · product visual integration

기존 110개 gameplay/finite/first-session 회귀는 통과하고 새 POC visual contract만 실패했다. 결손은 core logic가 아니라 product-art consumption에 격리됐다.

### GREEN 1 · visual integration

- board renderer가 13개 approved core texture mapping을 실제 load
- HUD 4개 build tool icon 연결
- title / lesson / result shell art 연결
- lesson progress `1 / 7` 표시

### Responsive failure / root cause

visual integration 뒤 기존 responsive test에서 Briefing BeginButton clipping이 발생했다.

처음에는 image 높이 문제로 보였지만 systematic-debugging 계측 결과 실제 원인은 autowrap Label의 width가 1px로 평가되어:

```text
Objective minimum height ≈ 1099px
Rules minimum height ≈ 1418px
Briefing VBox minimum height ≈ 2732px
```

로 폭증한 것이었다.

근본 수정:

```text
Objective / Rules
→ stable readable minimum width 560px
→ horizontal EXPAND
→ wrap 유지
```

### RED 2 · result emotional feedback

성공/실패 Result가 같은 generic art를 사용하는 문제를 적대 검토에서 발견했다. 기존 전체 회귀는 통과하고 outcome-specific visual contract만 RED였다.

### GREEN 2 · outcome-specific result

- SUCCESS → approved `shell_result_success_candidate_v01.png`
- FAILURE → approved `shell_result_failure_candidate_v01.png`
- authority는 existing finite outcome에 유지, art는 presentation consumer만 담당

## Exact-head verification

PR #166 final HEAD에서:

```yaml
Project Contract: PASS
Validate Thin Adapter Migration: PASS
GUT 9.7.1: PASS
Godot Tests: PASS · cases=111
Windows Demo Export: PASS
Windows packaged runtime JSON proof: PASS
Android packaged runtime JSON proof: PASS
review_threads: 0
reviews_request_changes: 0
```

Responsive/accessibility coverage includes:

```text
1280×720
1600×900
1920×1080
2560×1080
960×540 mobile landscape
visible touch control minimum >= 48px
Reduced Motion same-information identity
Retry / Edit action availability
```

## Artifact evidence

Machine-readable owner:

`evidence/acceptance/sx59_poc_accept_002_artifact.json`

```yaml
candidate: SX59-POC-ACCEPT-002
workflow_run: 32692759675
artifact_id: 9507816480
artifact_name: switchy-express-windows-demo-9b70b9ecf62494b049d4e39d173a049a89a907b7
artifact_expires_at: 2026-09-07T05:15:01Z
artifact_api_digest_sha256: 16c81f9b42a3391a2a3dabf501cb2d6eb7e011682abdaa3f79eb8b1124836e55
artifact_zip_sha256: 16c81f9b42a3391a2a3dabf501cb2d6eb7e011682abdaa3f79eb8b1124836e55
windows_exe_sha256: 1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244
windows_pck_sha256: d48fe09796954f3b4f836d092b4184cb0ac33bc6f1f3b96f52166e2d6760aa0f
```

Fresh GitHub API readback와 artifact 재다운로드를 독립 수행했고 API digest와 ZIP SHA-256은 exact match다. ZIP 내부 `SHA256SUMS.txt`와 독립 EXE/PCK 계산도 일치했다.

## Artifact evidence reconciliation incident · 2026-08-24

기존 audit/candidate/self-run/test에는 같은 run `32692759675`에 대해 다른 artifact ID/name/expiry와 다른 ZIP/EXE/PCK 해시가 하드코딩돼 있었다. 기존 테스트는 live artifact를 읽지 않고 이 복제값끼리만 비교하여 drift를 잡지 못했다.

교정 원칙:

```text
artifact_id / artifact_name / artifact_expires_at = EPHEMERAL_DELIVERY_METADATA
artifact/API digest + downloaded ZIP/EXE/PCK SHA-256 = DURABLE_CONTENT_IDENTITY
```

Workflow 자체가 `switchy-express-windows-demo-${{ github.sha }}` + `retention-days: 14`를 사용하므로 artifact 이름 suffix를 PR HEAD로 해석하거나 장기 만료일을 고정해서는 안 된다. `pull_request` run의 workflow-context `${{ github.sha }}`와 API `head_sha`는 역할이 다를 수 있다.

이 incident는 **evidence bookkeeping defect**다. PR #166 gameplay/image/audio/UI runtime bytes 자체의 변경이나 회귀 증거는 발견되지 않았다.

## Five-pass adversarial review

### PASS 1 · core / rule integrity

GMB-002, finite domain, T1→T6→Capstone, Retry/Edit 의미를 변경하지 않았다.

### PASS 2 · visual / feedback

generic Result 문제를 발견했고 RED-first로 outcome-specific approved art를 연결해 닫았다.

### PASS 3 · responsive / input / accessibility

PC standard / ultrawide / mobile landscape, touch target, Reduced Motion을 기존 regression으로 재검증했다.

### PASS 4 · runtime / package

Windows export와 Windows/Android packaged runtime JSON proof를 exact HEAD에서 통과했다. `all_resources` export boundary로 product assets가 package에 포함된다. Artifact evidence는 live API + independent download digest로 다시 닫았다.

### PASS 5 · product scope / maintenance

새 feature breadth보다 existing approved asset을 실제 gameplay surface에 소비시키는 방식을 채택했다. 056~058은 계속 구현 권한 밖이다.

`CLEAN_REVIEW_EXIT`는 playable POC 구현 자체에 대한 당시 판정이며, 이번 artifact evidence correction은 별도 current-task review에서 다시 검증한다.

## IRG / evidence ceiling

현재 주장 가능:

- visually integrated playable POC code/resource tree가 main에 병합됨
- approved product images가 actual gameplay/UI shell에서 load/consume됨
- automated T1→T6→Capstone과 UI/UX contract가 GREEN
- Windows executable package가 생성되고 packaged runtime proof가 PASS
- Candidate 002 package content digest가 live API + fresh download로 재검증됨

현재 주장 불가:

```yaml
PHYSICAL_WINDOWS: NOT_RUN
AUDIO_PERCEPTUAL_QA: NOT_RUN
ANDROID_DEVICE: NOT_RUN
FIVE_PERSON_COMPREHENSION: NOT_RUN
PLAYER_EXPERIENCE: NOT_RUN
```

따라서 다음 제품 Gate는 package identity 확인 후 `SX59-POC-ACCEPT-002` developer self-run이다.
