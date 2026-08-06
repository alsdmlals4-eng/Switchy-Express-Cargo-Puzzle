# Base Skill and Workflow Map — GMB-004

```yaml
base_repository: alsdmlals4-eng/Base
base_main_sha: 4f98f968a377f7b6a11aafa4fc94d11bddbebedc
project_pinned_release: v9.4.3
purpose: v4.3 entry-gate and GUT/HiGodot authority reconciliation
inventory_method:
  - GitHub recursive tracked-tree readback
  - root and relevant directory inventory
  - relevant registry/router/skill texts full or bounded read
coverage_claim: INVENTORY_OBSERVED_RELEVANT_TEXT_READ
not_claimed:
  - every Base text file read in full
  - every binary executed
  - latest Base main automatically adopted as project release
```

## Classification map

| Class | Observed Base surfaces | GMB-004 use | Read status |
|---|---|---|---|
| Registry | `skills/SKILL_REGISTRY.json`, `skills/BASE_SHARED_SKILL_ROUTES.json`, snapshots and coverage/evidence JSON | minimum automatic-trigger routing and evidence ceiling | RELEVANT_READ |
| Skill | `skills/<skill-id>/SKILL.md`, references/scripts/agents | intake, project OS, design docs, handoff, concept, vertical-slice, UI/art audit | SELECTED_ONLY |
| Router | Skill registry, shared routes, project adapter/router contracts | prevent load-all and stale aliases | RELEVANT_READ |
| Workflow | `.github/workflows/**` | contract, adoption, exact-head and Godot gates | INVENTORIED · SELECTED_READ |
| Template | `templates/**` | traceability, review, visual and project packets | INVENTORIED · NOT_ALL_READ |
| Policy | `docs/**`, Godot/visual/AI operation policies | HiGodot single authority, optional addon boundary, evidence ceiling | SELECTED_READ |
| Test | `tests/**` | registry/route/adoption/static regression | INVENTORIED · NOT_ALL_EXECUTED |
| Script | `tools/**`, skill scripts | generation, validation and adoption checks | INVENTORIED · SELECTED_READ |
| Archive | archive/legacy/backup/removal-candidate surfaces and alias map | compare only; not active authority | INVENTORIED · NOT_READ_BY_DEFAULT |
| Generated | `docs/generated/**`, snapshots/dashboard/health outputs | read-only consumer views, not second authority | INVENTORIED |
| Binary | images, PDFs and other non-text assets | metadata/consumer review only for current task | BLOCKED_UNVERIFIED_OR_NOT_APPLICABLE |

## Active routing authority

Base states that the active Skill list and selection authority is `skills/SKILL_REGISTRY.json`, not a manually duplicated README list. Routing is fail-closed with `load_all_skills: false`, `automatic-trigger-match`, trigger matching and required execution reporting.

Relevant registry routes observed:

| Skill ID | Trigger relevance | GMB-004 use |
|---|---|---|
| `managing-project-intake-and-work-contract` | new request, work order, Google Sheet sync, PR preflight, approval bundle, duplicate/omission/conflict audit | bind v4.3 and recalculate entry state |
| `managing-game-project-operating-system` | existing project, operating health, decision recovery, Sheet sync, adapter integrity | recover main/Sheet/tool state and correct stale READY |
| `managing-design-documents` | decision tracking, canonical integration, immediate Sheet sync | record SX-DEC-043~046 and SX-AUD-027 |
| `maintaining-project-context-and-handoff` | phase boundary, implementation handoff, verified PR merge | block implementation and define next merged-main handoff |
| `analyzing-and-refining-game-concepts` | core concept/system alignment, benchmark and evidence | confirm route-end/arrows strengthen existing core fun rather than expand scope |
| `designing-vertical-slices` | vertical slice, quality bar, playtest/runtime evidence | preserve manual evidence ceiling and cross-platform validation |
| `auditing-and-refining-ui-art` | UI state, accessibility, Godot UI and visual audit | define procedural arrow component and visual Registry entry |

## Invocation and failure route

```text
v4.3 upload
→ managing-project-intake-and-work-contract
→ managing-game-project-operating-system
→ decision ledger/unresolved/image Sheet readback
→ ENTRY_GATE BLOCK
→ managing-design-documents
→ GMB-004 canon and Sheet sync
→ GUT spec Draft PR
→ attack review and exact-head checks
→ merge/main readback
→ recalculate entry gate
```

Failure routes:

```text
missing decision/image readback -> ENTRY_GATE_BLOCKED_UNVERIFIED
missing GUT spec merge -> BLOCKED_BY_GUT_ADOPTION_SPEC
missing HiGodot authoring evidence -> BLOCKED_BY_HIGODOT_AUTHORITY
addon source/tree/license mismatch -> GUT_SPEC_REVISE
0 GUT discovery or production mutation -> PR_CHECKS_FAILED
```

## Base/project boundary

- Project release pin remains Base `v9.4.3` until a separate adoption Decision.
- Base latest `main` `4f98f968…` is comparison evidence only.
- Base and project changes are not mixed in one PR.
- No project-specific GUT/HiGodot rule is written back to Base in GMB-004.

## Coverage limitations

- Recursive tracked-file inventory was requested through the GitHub connector, but the connector response is too large to support a trustworthy per-file full-text read claim in this session.
- Relevant Registry, router entry, project policies and tool-adoption surfaces were read; unrelated long knowledge logs, archives, templates and binaries remain `NOT_READ` or metadata-only.
- Therefore this map satisfies bounded entry-gate routing evidence but does not claim `BASE_WHOLE_REPOSITORY_FULL_TEXT_READ_COMPLETE`.
