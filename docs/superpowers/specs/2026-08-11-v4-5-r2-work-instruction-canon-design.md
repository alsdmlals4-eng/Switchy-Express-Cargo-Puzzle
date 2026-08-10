# v4.5 r2 Work-Instruction Canon Replacement Design

Date: `2026-08-11 KST`
Audit: `SX-AUD-045`
Approval: `USER_APPROVED_RECOMMENDED_CONTINUATION_AND_GITHUB_CANON_REPLACEMENT_2026-08-11`

## Goal

Promote the user-supplied `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.5_r2.md` into the project GitHub repository as the single current project work-instruction canon, then route current authority surfaces to it without changing product gameplay/runtime authority or treating the request as the explicit `기획 완료` gate.

## Source of Truth

The source payload is the attached file:

```text
PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.5_r2.md
revision: 2026-08-11-r2
sha256: 3f898b7e2749a2e1900e9df48183f02d4fbc735fd0e80297f28bb09317144de4
bytes: 77734
lines: 2850
```

The GitHub canonical file must preserve this payload verbatim. Project-specific routing metadata may be stored in owner documents, but the 77,734-byte instruction body is not duplicated elsewhere.

## Selected Architecture

Use one root-level versioned canonical file:

`PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.5_r2.md`

Current routing owners reference that exact path:

```text
AGENTS.md
→ START_HERE.md
→ ACTIVE_CONTEXT.md
→ CURRENT_CONFIRMED_DECISIONS.md / PHASE_A_PLANNING_COMPLETION_GATE.md where execution sequencing is summarized
→ DESIGN_DOCUMENT_REGISTRY.json
```

`SX-AUD-045` records provenance, replacement boundaries, accidental-noop recovery evidence, exact-head validation, and Sheet synchronization.

## Authority Boundary

The replacement changes **execution-contract provenance**, not product rules.

Preserve:

- product Decision span `SX-DEC-027~055`;
- `SX-DEC-055` implementation `NOT_STARTED`;
- `runtime_integrated=false`;
- Phase A evidence `READY_FOR_USER_PLANNING_COMPLETE_GATE`;
- explicit user `기획 완료` gate `NOT_GRANTED`;
- Phase B `NOT_RUN`;
- BUILD `BLOCKED`;
- Windows/Android/editor/human physical evidence ceilings;
- Base project pin `v9.4.3`;
- upstream Base current main as reference-only.

The current user message approves this documentation/canon replacement and continuous docs work, but does not contain the literal/explicit planning-complete declaration required by r2.

## Replacement Semantics

Earlier uploaded/chat instruction revisions are historical external evidence once r2 is merged. No older instruction file currently exists in the repository, so this operation is a **GitHub canon establishment/replacement of the external instruction authority**, not a deletion of a tracked predecessor.

The project must not create a second unversioned copy. The versioned r2 file is the current single body; routers provide discovery.

## START_HERE Freshness Repair

`START_HERE.md` is a current registry owner but still contains pre-PR-139 handoff state and a `resume → Task 1 RED` shortcut. Because r2 now becomes GitHub canon, START_HERE must be reconciled in the same PR to:

- point to the r2 work-instruction canon;
- reflect current main/open-PR truth at branch start;
- preserve `READY_FOR_USER_PLANNING_COMPLETE_GATE`;
- route next action to explicit `기획 완료` → Phase B, not direct BUILD;
- keep runtime/physical/device/human `NOT_RUN` ceilings.

This is canonical-freshness repair necessary for discoverability, not product scope expansion.

## Sheet Synchronization

Use new non-product audit `SX-AUD-045`.

Update current Sheet surfaces only:

- `00_프로젝트_허브`: r2 GitHub canon replacement in progress/then merged;
- `01_작업순서`: add `CURRENT-13` for r2 work-instruction canon replacement;
- `04_누락_충돌_감사`: add `SX-AUD-045` with source hash/provenance and validation evidence;
- `50_제작_검증`: add/update a current operational row only if needed for routing.

Do not create a new product Decision ID and do not alter `SX-DEC-055` product semantics.

## Validation

Pre-PR:

- attached source SHA-256 and size recorded;
- fetched GitHub canonical file after write must have identical UTF-8 bytes/hash-equivalent content;
- changed paths limited to docs/current routing/canonical instruction only;
- no `.gd`, `.tscn`, `project.godot`, workflow, test, product asset, manifest, addon, or binary changes;
- no direct BUILD authorization introduced;
- no stale `resume → RED` current route remains in START_HERE/current owners.

PR exact-head:

- use actual workflows emitted for the exact PR head;
- required/applicable checks must pass;
- unresolved review threads = 0;
- main freshness re-read before merge;
- merge only on unchanged expected head.

Post-merge:

- fetch current main/open PR state;
- fetch GitHub r2 canonical and verify revision/path/body identity;
- reread routing owners;
- synchronize Sheet with merge SHA and final audit status;
- remain `READY_FOR_USER_PLANNING_COMPLETE_GATE`, not Phase B/BUILD.

## Accidental Main Noop Recovery

During tool discovery on this turn, `__noop__` was accidentally created on main at `1e439d049cd069ce23c104dda89921dd1c1f878c` and immediately deleted at `e2e075ffb41ff1f60e22ac369ddc5e8275d98dd6` after root-cause confirmation.

Comparison `78b8f09a930fdef040b2017fceb427864a15f51b...e2e075ffb41ff1f60e22ac369ddc5e8275d98dd6` has `files: []`, so the net repository tree delta is zero. `SX-AUD-045` records this transparently; no force/reset/history rewrite is used.

## Final Design Verdict

`APPROVED · DOCS/CANON_ONLY · NO_PRODUCT_DECISION_CHANGE · NO_BUILD`.
