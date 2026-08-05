# SX-AUD-019 · GitHub / Google Sheet Sync Closure

```yaml
audit_id: SX-AUD-019
status: SYNCED_TO_PR_HEAD · CANONICAL_EXPORT_NOT_RUN
source_main: 536911449018a3caf3511bc64e7bf1a66edf2016
audit_pr: PR #73
pr_head: b2b88cd505085403323cc68b65796bcbb4c9d93e
correct_sheet: 1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo
wrong_sheet: 19Ff... · UNTOUCHED
```

## Synchronized locations

- `00_프로젝트_허브` current Stage·Work Mode·main·next Gate
- `01_작업순서` current execution row
- `03_근거_라이브러리` `EV-FP-APK-PROBE-001`
- `04_누락_충돌_감사` `SX-AUD-019`
- `50_제작_검증` current production/validation Gate

## Synchronized meaning

```text
APK PIPELINE RUNTIME PROBE: PASS
CANONICAL MAIN APK EXPORT: NOT_RUN
ANDROID DEVICE SMOKE: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
DEFAULT ENTRYPOINT: LEGACY
PRODUCTION CUTOVER: BLOCKED
```

The Sheet records Probe run `31010824827`, artifact `8932389596`, artifact ZIP digest `76601acb...9787a`, APK SHA-256 `c0a1359c...c9b7`, and the requirement to manually dispatch `Android Validation APK` on `main` before canonical `APK_EXPORT` may become PASS.

All written ranges were read back after the update. The wrong `19Ff...` spreadsheet was not accessed or modified.
