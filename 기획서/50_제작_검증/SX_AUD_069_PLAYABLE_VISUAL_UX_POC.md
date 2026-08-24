# SX-AUD-069 · Playable Visual / UX POC

Date: `2026-08-24 KST`
Status: `MERGED_MAIN_VERIFIED · AUTOMATED_AND_PACKAGE_PASS · MANUAL_GATES_OPEN`

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

```yaml
candidate: SX59-POC-ACCEPT-002
workflow_run: 32692759675
artifact_id: 5439198762
artifact_name: switchy-express-windows-159a3a741ef79b6207be290cc284bd63a5979e72
artifact_zip_sha256: c0a7856efaeb278ac1501ee5b36ec4af15c088aefd88b759eb15681c7ce4fd42
windows_exe_sha256: 90347bb3e5ef28760385777b63a87be5c1572a9e8c3f11e619fac6fabfb44103
windows_pck_sha256: 089c9b78bb3e82bbf1accce7fe26b2306700e2800c590cbac1763252b7a2ea7a
```

## Five-pass adversarial review

### PASS 1 · core / rule integrity

GMB-002, finite domain, T1→T6→Capstone, Retry/Edit 의미를 변경하지 않았다.

### PASS 2 · visual / feedback

generic Result 문제를 발견했고 RED-first로 outcome-specific approved art를 연결해 닫았다.

### PASS 3 · responsive / input / accessibility

PC standard / ultrawide / mobile landscape, touch target, Reduced Motion을 기존 regression으로 재검증했다.

### PASS 4 · runtime / package

Windows export와 Windows/Android packaged runtime JSON proof를 exact HEAD에서 통과했다. `all_resources` export boundary로 product assets가 package에 포함된다.

### PASS 5 · product scope / maintenance

새 feature breadth보다 existing approved asset을 실제 gameplay surface에 소비시키는 방식을 채택했다. 056~058은 계속 구현 권한 밖이다.

`CLEAN_REVIEW_EXIT`.

## IRG / evidence ceiling

현재 주장 가능:

- visually integrated playable POC code/resource tree가 main에 병합됨
- approved product images가 actual gameplay/UI shell에서 load/consume됨
- automated T1→T6→Capstone과 UI/UX contract가 GREEN
- Windows executable package가 생성되고 packaged runtime proof가 PASS

현재 주장 불가:

```yaml
PHYSICAL_WINDOWS: NOT_RUN
ANDROID_DEVICE: NOT_RUN
FIVE_PERSON_COMPREHENSION: NOT_RUN
PLAYER_EXPERIENCE: NOT_RUN
```

따라서 다음 제품 Gate는 `SX59-POC-ACCEPT-002` developer self-run이다.
