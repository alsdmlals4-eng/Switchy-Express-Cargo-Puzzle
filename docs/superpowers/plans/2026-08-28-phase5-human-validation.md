# Phase 5 Machine-Primary Validation and Final User Review Plan

> **For the user:** SX-DEC-065 makes machine verification the primary route. This plan records only exact-candidate evidence and a separately requested final user review; it is not runtime proof by itself.

**Goal:** Produce machine acceptance evidence for the exact current product candidate, then reserve one product-owner final review for the same exact candidate without changing gameplay, assets, Scenes, Resources, or production scope.

**Issue:** #233
**Current authority:** `GMB-002 · SX-DEC-027~065`, `SX-DEC-060`, `SX-DEC-061`, `SX-DEC-062`, `SX-DEC-064`, `SX-DEC-065`, `기획서/50_제작_검증/PLAYTEST_PLAN.md`
**Last verified package candidate:** `SX60-POC-ACCEPT-004` from source `58b99f261c3576150ab275bb041d744c69b83538` · `HISTORICAL_PRE_V04_PRODUCT_BYTES`
**Current exact candidate:** `SX60-POC-ACCEPT-005 · source a11dfd1a063e434ee22e8cfb7b073ebc380aa27a · MACHINE_PRIMARY_ACCEPTANCE_READY`
**Candidate pointer:** `evidence/acceptance/post_sx_dec_060_candidate.json`
**Status:** `MACHINE_PRIMARY_FINAL_USER_REVIEW · EXACT_CANDIDATE_005_MACHINE_EVIDENCE_COMPLETE · FINAL_USER_REVIEW_NOT_RUN`

> **SX-DEC-063 v04 boundary:** Candidates 002–004 are immutable prior-byte observation/package evidence. Candidate 005 is now bound to the exact current runtime bytes; never promote any older physical/audio/human field.

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
- One exact immutable candidate and its supported deterministic/runtime/export/package/CI machine verification.
- A final user review only when the product owner requests it, including the cardinal station service rule when that review is run.

Out of scope:

- Any Godot, map, asset, UI, audio, score, progression, store, or Base change.
- SX-DEC-056A/056B/057/058 implementation.
- Reuse of `SX59-POC-ACCEPT-003`, `SX60-POC-ACCEPT-001`, or the old Android validation APK as current post-060 proof.
- A PASS claim from automation, a package hash, a concept board, a screenshot, or an AI-generated planning image.

## Task 1 — Freeze the exact candidate before machine validation

**Read first:** `evidence/acceptance/post_sx_dec_060_candidate.json`, `evidence/acceptance/sx60_poc_accept_004_artifact.json`, `기획서/50_제작_검증/SX_DEC_060_POC_DEVELOPER_SELF_RUN_RECORD_04.md`.

- [ ] Use the current pointer; never select an artifact by newest timestamp.
- [ ] Run only repository-supported deterministic, Godot runner, export, runtime-payload, package-integrity, and CI routes for the chosen exact source head.
- [ ] Before recording a machine result, verify every artifact hash and workflow head against the candidate evidence owner.
- [ ] If the artifact is expired, unavailable, hash-mismatched, or its resolved candidate differs, stop with `BLOCKED_IDENTITY`; do not substitute another package.

**Record:** candidate ID, source SHA, executed command/workflow identity, artifact hashes, date/time, and a redacted evidence reference.
**Does not prove:** a final user review, release readiness, or any unrun Android physical-device result.

## Task 2 — Machine acceptance decision

**Prerequisite:** Task 1 identity is exact.
**Success condition:** all applicable exact-head machine owners pass without a claim beyond their evidence ceiling.

- [ ] Preserve the full Godot runner, focused Python contracts, export/package proof, package/PCK audit, and hosted required checks as separate named evidence.
- [ ] Verify the T1→T6→capstone/result contract at the actual runtime consumer boundary; do not substitute a mockup or documentation-only assertion.
- [ ] Mark unsupported or unavailable physical-device routes `NOT_RUN` or `BLOCKED_UNVERIFIED`, never `PASS`.

**Evidence ceiling after this task:** `MACHINE_PRIMARY_ACCEPTANCE_REVIEWED`; it is not a human or release pass.

## Task 3 — Assign a post-060 Android artifact before device testing

**Current state:** `BLOCKED_UNVERIFIED`. Candidate 004's record has Android runtime-JSON package proof but no exact Android APK artifact ID, APK SHA-256, or package identity. The existing `ANDROID_DEVICE_SMOKE_RUNBOOK.md` and Template are historical validation-APK records, not eligible current artifacts.

- [ ] Do not install or report on the historical APK as Phase 5 evidence.
- [ ] When an exact post-060 Android artifact is available, record its source commit, artifact ID, APK SHA-256, package ID, and relationship to the current product authority before a device session.
- [ ] Create or adapt an Android runbook only after those facts exist; it must include T2 cardinal service, the current first-session flow, landscape touch/readability, and privacy-safe evidence fields.
- [ ] Perform physical-device smoke only on that identity. Emulator, package JSON, or Windows observation cannot substitute for it.

## Task 4 — Final user review (not a five-person study)

**Prerequisite:** machine acceptance decision and a named exact candidate.

- [ ] Run only when the user asks for final inspection; do not schedule a five-person comprehension study.
- [ ] Record the exact candidate, what the user actually inspected, and any decision/finding without inflating it into research evidence.
- [ ] A user-reported blocking defect routes to the earliest affected machine/implementation owner and requires a new exact candidate after product bytes change.

`FIVE_PERSON_COMPREHENSION_NOT_REQUIRED` and `PLAYER_EXPERIENCE_STUDY_NOT_REQUIRED` remain explicit. A final user review is `FINAL_USER_REVIEW`, not a substitute label for unrun human research.

## Documentation correction and learning record

| Item | Record |
| --- | --- |
| Incident | `PHASE5_PLAYTEST_IDENTITY_DRIFT_2026-08-28`: active Playtest/Android surfaces still advertised SX-DEC-055/059 or a pre-060 validation APK as current. |
| Player risk | The wrong build could be tested and incorrectly attributed to the cardinal-service/LIFO first session, making the human evidence unusable. |
| Solution | Promote the then-current Candidate 002 Windows identity and Phase 5 order; reclassify old wrappers and Android APK materials as historical; add `FS-02A`/`HUM-02A`. Candidate 003 later became prior-byte evidence after SX-DEC-064; Candidate 004 now owns the current post-SX-DEC-064 runtime bytes. |
| Lesson | Acceptance evidence must own both exact artifact identity and current player rule; an Android runtime JSON proof is not an installable device candidate. |
| Base promotion | `NO_BASE_PROMOTION`: this is project-specific candidate lineage and retained historical artifact topology, not a repeated cross-project workflow finding. |

## Verification after documentation merge

- [ ] Run the project contract and current authority migration validators.
- [ ] Check that `START_HERE`, `ACTIVE_CONTEXT`, `ROADMAP`, `DEVELOPMENT_GATES`, Documentation Map, and Playtest Plan agree on the candidate and evidence ceiling.
- [ ] Read back the merged `main`, GitHub PR/Issue, and the GitHub project-hub/production owners. Historical Notion pages are not an active validation surface.
- [ ] Do not claim a human/runtime result until a separately dated session record exists.

## Rollback

This plan changes no runtime bytes. If an execution document or candidate pointer is wrong, revert only the documentation commit and return all physical/device/human fields to `NOT_RUN` or `BLOCKED_IDENTITY` as supported by evidence.
