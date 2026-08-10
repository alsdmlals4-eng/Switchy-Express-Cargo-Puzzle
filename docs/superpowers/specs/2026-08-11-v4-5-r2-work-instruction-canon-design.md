# v4.5 r2 Work-Instruction Canon Replacement Design

Date: `2026-08-11 KST`
Audit: `SX-AUD-045`
Approval: `USER_APPROVED_RECOMMENDED_CONTINUATION_AND_GITHUB_CANON_REPLACEMENT_2026-08-11`

## Goal

Promote the user-supplied `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.5_r2.md` into GitHub as the current project work-instruction canon without changing product/runtime authority or treating this request as the explicit `기획 완료` gate.

## Source Identity

```text
revision: 2026-08-11-r2
bytes: 77734
LF count: 2849
SHA-256: 3f898b7e2749a2e1900e9df48183f02d4fbc735fd0e80297f28bb09317144de4
Git blob SHA-1: de7c6f818a4c96d2a02edea5eaff33bb1c39e8da
```

## Selected Architecture

The GitHub connector available in this conversation has no local-file streaming parameter for contents writes. A single manually assembled 77,734-byte payload is therefore an unnecessary corruption risk. The selected representation is a **content-addressed multipart verbatim canonical bundle**:

- root locator/manifest: `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.5_r2.md`;
- exact UTF-8 payload segments under `docs/work-instructions/v4.5_r2/`;
- the manifest defines exact order, byte counts, SHA-256 and Git blob SHA values;
- binary concatenation of the registered segments, with no inserted separator, reconstructs the attached source byte-for-byte;
- no second full-body copy is created.

A transport probe that produced a non-matching unlinked Git blob was rejected before any tree/branch reference. Part 4 additionally exposed a one-byte EOF-LF omission; rather than rewriting the large verified segment, a content-addressed 1-byte LF segment is registered in the canonical concatenation. This preserves source bytes exactly and makes the exceptional boundary auditable.

## Routing

Current project discovery must point to the root manifest, not duplicate the instruction body. At minimum:

```text
AGENTS.md
→ START_HERE.md
→ root r2 manifest
→ current execution owners / registered canon
```

`START_HERE.md` must also be repaired because its pre-PR-139 `resume → Task 1 RED` handoff is stale relative to the already-verified Phase A READY state.

## Authority Boundary

Preserve all of the following:

- product Decision span `SX-DEC-027~055` unchanged;
- `SX-DEC-055` implementation `NOT_STARTED`;
- `runtime_integrated=false`;
- Phase A evidence `READY_FOR_USER_PLANNING_COMPLETE_GATE`;
- explicit user `기획 완료` gate `NOT_GRANTED`;
- Phase B `NOT_RUN`;
- BUILD `BLOCKED`;
- Windows/Android/editor/human physical evidence ceilings;
- Base project pin `v9.4.3`;
- Base current main reference-only.

This turn explicitly authorizes the GitHub canon replacement and its docs/PR/merge lifecycle. It does not contain the planning-complete declaration required by r2.

## Replacement Semantics

No tracked predecessor work-instruction file existed in the repository at audit start. Therefore the operation establishes r2 as GitHub canon and supersedes prior chat/upload instruction revisions as external historical evidence; it does not delete an older tracked canon.

## Sheet Synchronization

Use non-product audit `SX-AUD-045` and update only current operational routing surfaces. No product Decision ID is created and `SX-DEC-055` semantics are not changed.

## Validation

Before merge:

- every payload segment must be addressable at its expected Git blob SHA;
- registered concatenation must match the source byte count/LF count/SHA-256/Git blob identity;
- changed paths remain docs/canon/routing only;
- no direct BUILD authorization or physical/human PASS inflation;
- no stale current `resume → RED` shortcut;
- actual exact-head PR workflows pass;
- unresolved review blockers = 0;
- main freshness is re-read immediately before merge.

After merge, re-read the new main, the r2 manifest/segments, current routers, open PRs, and configured Sheet. Final state must remain `READY_FOR_USER_PLANNING_COMPLETE_GATE`, with user gate not granted and BUILD blocked.

## Accidental Main Noop Recovery

Tool discovery accidentally created `__noop__` on main at `1e439d049cd069ce23c104dda89921dd1c1f878c`; it was immediately deleted at `e2e075ffb41ff1f60e22ac369ddc5e8275d98dd6` after root-cause confirmation. Comparison from pre-incident `78b8f09a930fdef040b2017fceb427864a15f51b` to recovery main `e2e075ffb41ff1f60e22ac369ddc5e8275d98dd6` reports `files: []`: net tree delta zero, with no reset/force/history rewrite.

## Verdict

`APPROVED · CONTENT_ADDRESSED_MULTIPART_VERBATIM_CANON · DOCS/CANON_ONLY · NO_PRODUCT_DECISION_CHANGE · NO_BUILD`.
