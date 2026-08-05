# Development Gates

## Active Gate Chain

```text
G0 PROJECT_IDENTIFIED: PASS
→ G1 FINITE_PRODUCT_AUTHORITY: PASS
→ G2 AUTOMATED_CORE: PASS
→ G3 VALIDATION_PREPARATION: PASS
→ G4 CANONICAL MAIN APK EXPORT: PASS
→ G5 ANDROID DEVICE SMOKE: NOT_RUN · CURRENT
→ G6 FIVE-PERSON COMPREHENSION: NOT_RUN · BLOCKED_BY_G5
→ G7 PRODUCTION CUTOVER REVIEW: BLOCKED_BY_G5_G6
```

## G0 — PROJECT_IDENTIFIED

Status: `PASS`

- [x] Repository: `alsdmlals4-eng/Switchy-Express-Cargo-Puzzle`
- [x] Engine: Godot `4.7.1-stable` · GDScript
- [x] Primary platform: Android · landscape
- [x] Correct Sheet: `1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo`
- [x] Wrong `19Ff...` Sheet excluded

## G1 — FINITE_PRODUCT_AUTHORITY

Status: `PASS · GMB-002 · SX-DEC-027~036`

- [x] finite authored delivery puzzle
- [x] free track construction with construction cost and full BUILD refund
- [x] structural preflight before run
- [x] automatic movement, manual/auto loading, persistent branch direct tap
- [x] unlimited LIFO and TOP contiguous-group unloading
- [x] finite timer, immediate success on final unload, failure with undelivered cargo
- [x] cosmetic-only fairness

Historical endless/fuel/BOOST/capacity-eight rules do not own current behavior.

## G2 — AUTOMATED_CORE

Status: `PASS`

- [x] map definition·track layout·editor·preflight
- [x] build session·sealed snapshot
- [x] fixed cargo field·manual/auto loading·unlimited LIFO
- [x] delivery event·finite lifecycle·pause·result
- [x] immutable solution/attempt identity and same-layout retry
- [x] landscape finite product view
- [x] integrated `A → B → A → A` / `2 → 1 → 1` proof
- [x] automated regression evidence preserved in `SX-AUD-017~019`

자동 테스트는 Android touch, safe area, 실기기 성능 또는 사람 이해도를 증명하지 않는다.

## G3 — VALIDATION_PREPARATION

Status: `PASS · SX-AUD-018`

- [x] isolated validation launcher
- [x] `PROOF` real finite Slice
- [x] view-owned `STACK 8 / STACK 16 / STACK 32`
- [x] on-device Selector and Back
- [x] fail-closed invalid mode handling
- [x] Android validation export preset and isolated package
- [x] production `run/main_scene` and `game/main/main.tscn` invariance

## G4 — CANONICAL MAIN APK EXPORT

Status: `PASS · SX-AUD-019 · EV-FP-APK-001`

```yaml
workflow: Android Validation APK
workflow_run_id: 31011620357
source_commit: 536911449018a3caf3511bc64e7bf1a66edf2016
result: SUCCESS
tests: 65 cases · 10,792 assertions · 0 failures
apk_size_bytes: 28771631
apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
artifact_zip_sha256: 1802ca52dd90eb674f89b0a6e4678152d314c5644d135a84033388b4d3ee7193
attestation_id: 39044925
artifact_expiry: 2026-08-19T13:45:27Z
```

- [x] workflow source and manifest source match
- [x] APK actual hash, `.sha256`, manifest and attestation subject match
- [x] validation package: `com.alsdmlals4.switchyexpress.validation`
- [x] product entrypoint remains legacy

APK export PASS는 device/HUMAN/cutover PASS가 아니다.

## G5 — ANDROID DEVICE SMOKE

Status: `NOT_RUN · CURRENT`

Authority:

- `기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_RUNBOOK.md`
- `기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_EVIDENCE_TEMPLATE.md`

Required:

- [ ] full canonical APK SHA-256 match
- [ ] physical Android landscape device
- [ ] AND-01~20 all executed
- [ ] `PROOF / STACK 8 / STACK 16 / STACK 32 / Back`
- [ ] BUILD→RUN→pause/resume→result→retry/edit
- [ ] LOAD hold·auto-load·branch direct tap·occupied lock
- [ ] 8/16/32 rear/TOP readability
- [ ] safe area·touch target·clipping·overlap·input omission
- [ ] crash·ANR·script error·severe frame degradation absent
- [ ] linked recordings/screenshots/logs with privacy review

Gate:

```text
PASS: AND-01~20 all PASS on one physical device with the canonical hash.
FAIL: one or more executable required items FAIL.
BLOCKED: hash/package/device/evidence prerequisite prevents a valid run.
NOT_RUN: one or more required items were not performed.
```

## G6 — FIVE-PERSON COMPREHENSION

Status: `NOT_RUN · BLOCKED_BY_G5`

Android reviewed PASS 뒤 같은 APK SHA-256으로 수행한다.

- [ ] P01~P05 first-contact sessions
- [ ] 4/5+ explain last-loaded cargo as TOP
- [ ] 4/5+ explain why `A/B/A/A` requires A revisit
- [ ] failure recovery and same-layout retry comprehension
- [ ] shape/text identification without relying on color alone
- [ ] no solution coaching beyond control failure recovery

## G7 — PRODUCTION CUTOVER REVIEW

Status: `BLOCKED_BY_G5_G6`

별도 승인과 PR이 필요하다.

- [ ] Android Device Smoke reviewed PASS
- [ ] Five-person Comprehension reviewed PASS
- [ ] default entrypoint cutover design and rollback
- [ ] production package/signing/release evidence
- [ ] final art/icon and store consistency where required

## Separate Later Gates

다음은 G5의 완료 조건이 아니며 별도 package다.

- final art and production icon
- target100 official catalog
- daily/weekly online challenge backend
- UGC editor/publication/moderation/privacy/community
- Google Play submission, rating and target audience
- asset rights runtime audit and release compliance evidence
- GitHub Action runtime modernization

## Historical Package Boundary

과거 VS03 package order, fuel pressure, BOOST, capacity-eight compact wagon and endless progression 자료는 `HISTORICAL_REPLACED` 또는 `LEGACY_IMPLEMENTATION`이다. 당시 코드·테스트·감사의 역사 증거로 보존하지만 current Gate나 다음 작업 권위를 갖지 않는다.

## Current Transition

```text
canonical APK hash verification
→ physical Android AND-01~20
→ evidence completeness and privacy review
→ adversarial review
→ reviewed Gate decision
```

실제 증거 전에는 `SX-AUD-020`, Android PASS, Five-person PASS, Google Sheet Android closure 또는 production cutover를 기록하지 않는다.
