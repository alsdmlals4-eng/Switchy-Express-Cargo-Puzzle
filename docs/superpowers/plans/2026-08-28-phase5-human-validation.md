# Phase 5 Human Validation Start and Execution Plan

> **For the user:** Phase 5 is authorized to start. This document is a validation plan, not runtime proof. Record only observations made on the exact artifact identified below.

**Goal:** Validate whether the approved first-session promise is understandable and playable on the current post-SX-DEC-060 product, without changing gameplay, assets, Scenes, Resources, or production scope.

**Issue:** #233
**Current authority:** `GMB-002 · SX-DEC-027~061`, `SX-DEC-060`, `SX-DEC-061`, `기획서/50_제작_검증/PLAYTEST_PLAN.md`
**Current candidate:** `SX60-POC-ACCEPT-002` from source `0e882764b837d13282a7642b115948d4e061d163`
**Candidate pointer:** `evidence/acceptance/post_sx_dec_060_candidate.json`
**Status at plan creation:** `USER_AUTHORIZED · WINDOWS_PHYSICAL_AUDIO_NOT_RUN · ANDROID_ARTIFACT_ID_UNASSIGNED · FIVE_PERSON_NOT_RUN`

## Player outcome under test

The player builds a route to control cargo encounter order, chooses when to load cargo into an unlimited LIFO stack, makes route/switch choices during automatic movement, passes a matching station from one cardinal-adjacent service cell, then learns from success or failure and chooses Retry or Edit.

```text
T1 Track Connection
→ T2 same-cell cargo pickup vs cardinal-adjacent station delivery
→ T3 LIFO/TOP reverse planning
→ T4 selective non-load and revisit
→ T5 Auto ON safe / OFF decision
→ T6 direct switch and occupied lock
→ VS_DEMO_01 capstone
→ Result / Retry / Edit
```

## Scope and exclusions

In scope:

- Current-status correction for Phase 5 documents and historical validation artifacts.
- One exact Windows physical/audio gate, then an exact Android identity gate, then first-contact human sessions.
- Behavior-first observation including the cardinal station service rule.

Out of scope:

- Any Godot, map, asset, UI, audio, score, progression, store, or Base change.
- SX-DEC-056A/056B/057/058 implementation.
- Reuse of `SX59-POC-ACCEPT-003`, `SX60-POC-ACCEPT-001`, or the old Android validation APK as current post-060 proof.
- A PASS claim from automation, a package hash, a concept board, a screenshot, or an AI-generated planning image.

## Task 1 — Freeze the exact Windows candidate before observation

**Read first:** `evidence/acceptance/post_sx_dec_060_candidate.json`, `evidence/acceptance/sx60_poc_accept_002_artifact.json`, `기획서/50_제작_검증/SX_DEC_060_POC_DEVELOPER_SELF_RUN_RECORD_02.md`.

- [ ] Use the current pointer; never select an artifact by newest timestamp.
- [ ] Run the existing current-main launcher only if its contract check resolves Candidate 002:

  ```powershell
  powershell -ExecutionPolicy Bypass -File .\RUN_SX60_POC_SELF_RUN.ps1 -ContractCheck
  powershell -ExecutionPolicy Bypass -File .\RUN_SX60_POC_SELF_RUN.ps1
  ```

- [ ] Before recording observation, verify the launched EXE and PCK against the Candidate 002 hashes in `PLAYTEST_PLAN.md`.
- [ ] If the artifact is expired, unavailable, hash-mismatched, or its resolved candidate differs, stop with `BLOCKED_IDENTITY`; do not substitute another package.

**Record:** candidate ID, source SHA, observer alias, date/time, display/audio conditions, and a redacted evidence reference.
**Does not prove:** Android, first-contact comprehension, player experience, or release readiness.

## Task 2 — Windows full physical smoke and audio perceptual QA

**Prerequisite:** Task 1 identity is exact.
**Success condition:** A human observer completes the representative T1→T6→capstone/result journey without a blocking launch, input, visual, or audio defect, while recording individual observations rather than a blanket PASS.

- [ ] Start at title, enter briefing and BUILD, and confirm primary pointer/keyboard controls respond.
- [ ] Complete T1 preflight correction without a hidden command.
- [ ] At T2, distinguish cargo same-cell pickup from station cardinal-adjacent service. Verify that station footprint and diagonal expectation do not silently deliver.
- [ ] Continue through LIFO/TOP, selective load, Auto ON/OFF, and switch occupied-lock lessons; reach a capstone result and use Retry or Edit where the outcome calls for it.
- [ ] Listen for essential feedback at title, briefing, BUILD, RUN, pickup/unload, route/switch, and success/failure. Record silence, masking, wrong causal cue, distortion, or unacceptable level as an observation; do not infer audio from a capture.
- [ ] Record any crash, input loss, raw key, unreadable primary cue, or contradiction between visual feedback and gameplay as `FAIL` or `BLOCKED`, not as a cosmetic note.

**Evidence ceiling after this task:** at most `WINDOWS_PHYSICAL_AND_AUDIO_REVIEWED`; Android and human/player gates remain separate.

## Task 3 — Assign a post-060 Android artifact before device testing

**Current state:** `BLOCKED_UNVERIFIED`. Candidate 002's record has Android runtime-JSON package proof but no exact Android APK artifact ID, APK SHA-256, or package identity. The existing `ANDROID_DEVICE_SMOKE_RUNBOOK.md` and Template are historical validation-APK records, not eligible current artifacts.

- [ ] Do not install or report on the historical APK as Phase 5 evidence.
- [ ] When an exact post-060 Android artifact is available, record its source commit, artifact ID, APK SHA-256, package ID, and relationship to the current product authority before a device session.
- [ ] Create or adapt an Android runbook only after those facts exist; it must include T2 cardinal service, the current first-session flow, landscape touch/readability, and privacy-safe evidence fields.
- [ ] Perform physical-device smoke only on that identity. Emulator, package JSON, or Windows observation cannot substitute for it.

## Task 4 — Five-person first-contact comprehension

**Prerequisites:** reviewed Windows physical/audio result, exact Android artifact/device gate if the study is Android-targeted, and no unresolved P0/P1 issue that invalidates the session.

- [ ] Recruit at least five people without exposure to the exact tested build. Use aliases only.
- [ ] Use the neutral opening and behavior/prediction/explanation fields in `PLAYTEST_PLAN.md`; never coach the route, stack, switch, or station rule.
- [ ] Require `FS-02A`: before outcome, the participant distinguishes cargo same-cell contact from station cardinal service and does not expect diagonal/footprint delivery.
- [ ] Apply the existing 4/5 threshold and all `HUM` gates, including new `HUM-02A`. `INTERVENTION_CONTAMINATED` is not independent PASS evidence.
- [ ] Preserve private recordings outside the public repository; commit only a minimized, redacted result record after evidence/privacy review.

## Documentation correction and learning record

| Item | Record |
| --- | --- |
| Incident | `PHASE5_PLAYTEST_IDENTITY_DRIFT_2026-08-28`: active Playtest/Android surfaces still advertised SX-DEC-055/059 or a pre-060 validation APK as current. |
| Player risk | The wrong build could be tested and incorrectly attributed to the cardinal-service/LIFO first session, making the human evidence unusable. |
| Solution | Promote Candidate 002 Windows identity and Phase 5 order; reclassify old wrappers and Android APK materials as historical; add `FS-02A`/`HUM-02A`. |
| Lesson | Acceptance evidence must own both exact artifact identity and current player rule; an Android runtime JSON proof is not an installable device candidate. |
| Base promotion | `NO_BASE_PROMOTION`: this is project-specific candidate lineage and retained historical artifact topology, not a repeated cross-project workflow finding. |

## Verification after documentation merge

- [ ] Run the project contract and current authority migration validators.
- [ ] Check that `START_HERE`, `ACTIVE_CONTEXT`, `ROADMAP`, `DEVELOPMENT_GATES`, Documentation Map, and Playtest Plan agree on the candidate and evidence ceiling.
- [ ] Read back the merged `main`, GitHub PR/Issue, and the Switchy Notion Home/Production surface.
- [ ] Do not claim a human/runtime result until a separately dated session record exists.

## Rollback

This plan changes no runtime bytes. If an execution document or candidate pointer is wrong, revert only the documentation commit and return all physical/device/human fields to `NOT_RUN` or `BLOCKED_IDENTITY` as supported by evidence.
