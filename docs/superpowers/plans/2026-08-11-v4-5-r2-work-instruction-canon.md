# v4.5 r2 Work-Instruction Canon Replacement Implementation Plan

> **For agentic workers:** Use Superpowers executing-plans/systematic-debugging/verification-before-completion as applicable. This plan is documentation/canon execution only.

**Goal:** Make the user-supplied v4.5 r2 payload the current discoverable GitHub work-instruction canon, synchronize current routers/Sheet, verify an exact-head PR, and merge within the already approved scope without changing product/runtime authority or granting BUILD.

**Architecture:** Content-addressed multipart verbatim bundle. Root manifest `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.5_r2.md` defines the exact ordered UTF-8 segments under `docs/work-instructions/v4.5_r2/`, their hashes, and full-source reconstruction identity.

## Global Constraints

```text
revision: 2026-08-11-r2
source bytes: 77734
source LF count: 2849
source SHA-256: 3f898b7e2749a2e1900e9df48183f02d4fbc735fd0e80297f28bb09317144de4
source Git blob SHA-1: de7c6f818a4c96d2a02edea5eaff33bb1c39e8da
non-product audit: SX-AUD-045
```

- No new product Decision ID.
- `SX-DEC-027~055` semantics unchanged; `SX-DEC-055` remains `IMPLEMENTATION_NOT_STARTED`, `runtime_integrated=false`.
- Phase A remains `READY_FOR_USER_PLANNING_COMPLETE_GATE`; user `기획 완료` remains `NOT_GRANTED`; Phase B `NOT_RUN`; BUILD `BLOCKED`.
- No `.gd`, `.tscn`, `project.godot`, test, workflow, addon, product asset, semantic manifest, or binary mutation.
- Base pin remains v9.4.3; Base current main remains reference-only.
- Merge only on unchanged exact head after all emitted/applicable checks pass and review blockers are zero.

### Task 1 — Preserve source bytes in GitHub

- [x] Calculate source byte/LF/SHA identities from the attachment.
- [x] Reject an unlinked single-call transport probe whose Git blob did not match the expected source identity.
- [x] Store content-addressed UTF-8 segments.
- [x] Detect part-4 EOF-LF omission by blob SHA before PR; preserve the missing LF as a separate one-byte content-addressed segment instead of rewriting the verified large segment.
- [x] Prove locally that ordered segment concatenation equals the original 77,734-byte source exactly.
- [x] Create root manifest with ordered segment identities and reconstruction contract.

### Task 2 — Route current authority to r2

Target only current discovery/operational surfaces necessary to make r2 discoverable and remove stale execution shortcuts:

- `AGENTS.md`
- `기획서/00_프로젝트_허브/START_HERE.md`
- `기획서/00_프로젝트_허브/DESIGN_DOCUMENT_REGISTRY.json`
- `기획서/50_제작_검증/SX_AUD_045_V4_5_R2_WORK_INSTRUCTION_CANON.md`

If adversarial review proves additional current-owner routing is required, update only the smallest affected owner while preserving the user-gate/build boundaries.

- [ ] Add r2 manifest path/revision/hash to AGENTS current canon routing.
- [ ] Reconcile stale START_HERE direct `resume → RED` handoff to current Phase A READY → explicit `기획 완료` → Phase B sequence.
- [ ] Register r2 canon and SX-AUD-045 owner.
- [ ] Record replacement/audit provenance and transport/recovery evidence.

### Task 3 — Sheet pre-PR synchronization

- [ ] Hub: r2 canon replacement in progress, Phase A READY/no-build preserved.
- [ ] Add `CURRENT-13 · SX-AUD-045 v4.5 r2 Work Instruction Canon Replacement` before history rows.
- [ ] Add SX-AUD-045 audit row with source identity, branch/baseline, PR/CI `NOT_RUN` until evidence exists.
- [ ] Reread touched ranges.

### Task 4 — Pre-PR adversarial review

- [ ] Compare branch with baseline `e2e075ffb41ff1f60e22ac369ddc5e8275d98dd6`; prove docs/canon-only scope.
- [ ] Verify all registered segment Git blob SHAs and root manifest metadata.
- [ ] Confirm no tracked predecessor instruction file existed at audit start.
- [ ] Confirm no stale current direct `resume → RED` route remains.
- [ ] Confirm no product Decision/gameplay/Base pin/runtime/asset/physical-human PASS expansion.
- [ ] Record accidental `__noop__` main create/delete as `NET_TREE_DELTA_ZERO`; no force/reset/history rewrite.

### Task 5 — Exact-head PR validation and merge

- [ ] Re-read project/Base current main and all open/draft PRs.
- [ ] Create ready PR with source identity, multipart rationale, no-build boundary, noop recovery disclosure, and Sheet state.
- [ ] List changed filenames, review threads, and reviews.
- [ ] Inspect every workflow actually emitted for the exact head; skipped/non-triggered checks are not PASS.
- [ ] Systematically debug any failure and make only the minimum compatible correction.
- [ ] Re-read exact head, base/main freshness, mergeability, review blockers.
- [ ] Squash merge with `expected_head_sha` only after gates pass.

### Task 6 — Post-merge closure

- [ ] Read new main and all open/draft PRs.
- [ ] Fetch root manifest and all segment blob identities from new main.
- [ ] Reread AGENTS/START_HERE/Registry/SX-AUD-045.
- [ ] Update Sheet Hub/CURRENT-13/SX-AUD-045 with exact-head CI and merge SHA.
- [ ] Final readback: r2 = current GitHub canon; Phase A READY; user gate NOT_GRANTED; Phase B NOT_RUN; BUILD BLOCKED; runtime/device/human NOT_RUN.

## Transport/Recovery Notes

- Unlinked nonmatching blob probes are rejected evidence and never become branch/tree authority.
- Accidental main `__noop__` create `1e439d049cd069ce23c104dda89921dd1c1f878c` and delete/recovery `e2e075ffb41ff1f60e22ac369ddc5e8275d98dd6` have comparison `files: []`; the actual work branch starts from the recovered main.
