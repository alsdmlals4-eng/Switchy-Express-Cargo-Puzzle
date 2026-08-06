# Development Gates

## Active Gate Chains

### Product·Android chain

```text
G0 PROJECT_IDENTIFIED: PASS
→ G1 FINITE_PRODUCT_AUTHORITY: PASS
→ G2 AUTOMATED_CORE: PASS
→ G3 VALIDATION_PREPARATION: PASS
→ G4 CANONICAL MAIN APK EXPORT: PASS
→ G5 ANDROID DEVICE SMOKE: NOT_RUN · CURRENT_ANDROID_TRACK
→ G6 FIVE-PERSON COMPREHENSION: NOT_RUN · BLOCKED_BY_G5
→ G7 PRODUCTION CUTOVER REVIEW: BLOCKED_BY_G5_G6
```

### PC Vertical Slice chain

```text
PC0 SX-DEC-037 APPROVAL: PASS
→ PC1 AUTOMATED VERTICAL SLICE: PASS
→ PC2 WINDOWS DEBUG EXPORT·INTEGRITY: PASS
→ PC3 WINDOWS RUNTIME·VISUAL·AUDIO SMOKE: NOT_RUN · CURRENT_PC_TRACK
→ PC4 PR MERGE REVIEW: BLOCKED_BY_PC3_OR_EXPLICIT_ACCEPTANCE
```

PC chain은 G5~G7을 대체하거나 자동으로 닫지 않는다.

## G0 — PROJECT_IDENTIFIED

Status: `PASS`

- [x] Repository: `alsdmlals4-eng/Switchy-Express-Cargo-Puzzle`
- [x] Engine: Godot `4.7.1-stable` · GDScript
- [x] Platforms: PC · Android landscape
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
- [x] integrated `A → B → A → A` / `2 → 1 → 1` proof
- [x] automated regression evidence preserved in `SX-AUD-017~020`

## G3 — VALIDATION_PREPARATION

Status: `PASS · SX-AUD-018`

- [x] isolated validation launcher
- [x] `PROOF`, `STACK 8`, `STACK 16`, `STACK 32`
- [x] on-device Selector and Back
- [x] Android validation export preset and isolated package
- [x] production `run/main_scene` and `game/main/main.tscn` invariance

## G4 — CANONICAL MAIN APK EXPORT

Status: `PASS · SX-AUD-019 · EV-FP-APK-001`

```yaml
workflow_run_id: 31011620357
source_commit: 536911449018a3caf3511bc64e7bf1a66edf2016
tests: 65 cases · 10,792 assertions · 0 failures
apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
artifact_zip_sha256: 1802ca52dd90eb674f89b0a6e4678152d314c5644d135a84033388b4d3ee7193
package_id: com.alsdmlals4.switchyexpress.validation
```

APK export PASS는 device/HUMAN/cutover PASS가 아니다.

## G5 — ANDROID DEVICE SMOKE

Status: `NOT_RUN · CURRENT_ANDROID_TRACK`

Authority:

- `기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_RUNBOOK.md`
- `기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_EVIDENCE_TEMPLATE.md`

Required:

- [ ] full canonical APK SHA-256 match
- [ ] physical Android landscape device
- [ ] AND-01~20 all executed
- [ ] BUILD→RUN→pause/resume→result→retry/edit
- [ ] LOAD hold·auto-load·branch direct tap·occupied lock
- [ ] safe area·touch target·clipping·overlap·input omission
- [ ] crash·ANR·script error·severe frame degradation absent
- [ ] linked evidence with privacy review

## G6 — FIVE-PERSON COMPREHENSION

Status: `NOT_RUN · BLOCKED_BY_G5`

- [ ] P01~P05 first-contact sessions
- [ ] 4/5+ explain last-loaded cargo as TOP
- [ ] 4/5+ explain why `A/B/A/A` requires A revisit
- [ ] failure recovery and same-layout retry comprehension
- [ ] shape/text identification without relying on color alone

## G7 — PRODUCTION CUTOVER REVIEW

Status: `BLOCKED_BY_G5_G6`

- [ ] Android Device Smoke reviewed PASS
- [ ] Five-person Comprehension reviewed PASS
- [ ] default entrypoint cutover design and rollback
- [ ] production package/signing/release evidence
- [ ] final art/icon and store consistency

## PC0 — SX-DEC-037 APPROVAL

Status: `PASS · EV-USER-023`

- [x] mouse-first PC controls + keyboard shortcuts
- [x] existing touch command path preserved
- [x] one polished representative stage
- [x] separate F6 scene and Windows debug export
- [x] default entrypoint and Android evidence protected

## PC1 — AUTOMATED VERTICAL SLICE

Status: `PASS · SX-AUD-020`

```yaml
feature_head: 0f36ef9af5d37397e23272c40bb62c3599d2db37
project_contract_run: 31065293042
Godot_tests_run: 31065293026
Godot_cases: 85
Godot_assertions: 11258
Python_contracts: 56_passed · 1_skipped
critical_open: 0
important_open_in_automated_scope: 0
```

- [x] shared finite controller and validation parity
- [x] Title→Briefing→BUILD→RUN→Result
- [x] Retry/Edit/Title flow
- [x] mouse·keyboard·touch command parity
- [x] Korean HUD, Theme, ghost, TOP and problem feedback
- [x] responsive layout
- [x] effects/audio non-authority
- [x] Android preset, proof map and default main invariance

## PC2 — WINDOWS DEBUG EXPORT·INTEGRITY

Status: `PASS · SX-AUD-020`

```yaml
workflow_run_id: 31065293030
artifact_id: 8953621440
artifact_zip_sha256: 7c44092b3837d84d3f027fc1625aaccaa1543d5307a174eda37824b27889af9e
exe_sha256: 1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244
pck_sha256: 66ffec232a851d1858da6a5bc0b90ca3c3e4b3769dc472fe1e97a15c0a82c741
```

- [x] Windows preset isolated
- [x] EXE/PCK generated and non-empty
- [x] declared and actual hashes match
- [x] artifact ZIP digest independently verified

## PC3 — WINDOWS RUNTIME·VISUAL·AUDIO SMOKE

Status: `NOT_RUN · CURRENT_PC_TRACK`

- [ ] EXE and PCK retained in one directory
- [ ] process launch and clean exit
- [ ] Title/Briefing/BUILD/RUN/Result
- [ ] Retry same layout and Edit layout
- [ ] mouse and keyboard physical input
- [ ] 1280×720 or larger clipping/overlap/readability
- [ ] audio cues, train loop, pause, success/failure
- [ ] no crash, script error or severe frame degradation

## PC4 — PR MERGE REVIEW

Status: `BLOCKED_BY_PC3_OR_EXPLICIT_ACCEPTANCE`

PR #83 can be merged only after Windows manual smoke or an explicit decision to merge automated/package PASS while retaining PC3 `NOT_RUN`.

## Separate Later Gates

- final art and production icon
- target100 official catalog
- daily/weekly online challenge backend
- UGC editor/publication/moderation/privacy/community
- Google Play submission, rating and target audience
- release asset-rights audit

## Current Transition

```text
PC: Windows artifact runtime smoke → PR #83 merge review
Android: canonical APK device smoke → evidence review → Five-person Comprehension
Both: separate production cutover review
```

금지:

- Windows export PASS를 Windows runtime PASS로 확대
- PC Demo 증거를 Android/HUMAN 증거로 대체
- 실제 evidence 전 Android·HUMAN·cutover PASS 기록
