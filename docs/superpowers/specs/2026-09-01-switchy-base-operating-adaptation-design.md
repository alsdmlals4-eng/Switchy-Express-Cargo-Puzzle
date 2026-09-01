# Switchy Express · Base Current Operating Adaptation Design

**Status:** `USER_APPROVED · IMPLEMENTATION_AUTHORIZED · NONCODING_ARCHITECTURAL_CHANGE`

**Approved request:** Fresh-read the current Base in detail and update Switchy's work order, structure, and contracts by following Base where it fits and adapting it where the project requires different boundaries.

**Fresh-read baseline:**

```yaml
base_completed_main_observed: 19355b7ef065a21d0f2b685c7d9be64a4a3970f8
project_main_before_branch: 8dc0b9c05fa3a200612329c466062ce29cda8c3b
project_base_compatibility_pin: v9.4.3 · HISTORICAL_COMPATIBILITY
project_workspace: GITHUB_ONLY
current_product_candidate: SX60-POC-ACCEPT-010
candidate_product_source: 79323ff0175b674c594d18dfd6d28a8e9951f5bd
```

## Goal

Adopt the current Base execution model without silently repinning Base, replacing Switchy's Godot provider, changing player-facing bytes, or promoting any unreviewed visual candidate.  One task must reconstruct authority, classify its scope, use the smallest effective route, verify the actual change, and close only after post-merge readback plus remaining-work recalculation.

## Non-goals and protected boundaries

- Do not alter `v9.4.3` historical compatibility evidence, the Base registry lock, or project engine pin.
- Do not change GDScript, Scene, Resource, map, product assets, Candidate 010 package pointers, or asset approval status.
- Do not treat an automated/package pass as physical, device, audio, accessibility, human, player-experience, release, or production-cutover evidence.
- Keep `SX-DEC-065` machine-primary acceptance, `FIVE_PERSON_COMPREHENSION_NOT_REQUIRED`, and `PLAYER_EXPERIENCE_STUDY_NOT_REQUIRED` intact.
- Keep PR #174 and every other pre-existing Open/Draft/Ready PR read-only; this task starts from completed `main` only.
- Preserve historical evidence and rollback sources.  This change classifies legacy surfaces; it does not bulk-delete them.

## Current findings to correct

| ID | Finding | Classification | Required correction |
|---|---|---|---|
| F1 | `START_HERE.md` says `SX-DEC-027~067` in its current-state table while the same active surface points to SX-DEC-069/Candidate 010. | `CONFLICTING_SOURCE` | Set the compact current decision span to `SX-DEC-027~069`. |
| F2 | `CURRENT_CONFIRMED_DECISIONS.md` summarizes SX-DEC-069 but its Decision Registry stops at SX-DEC-068. | `MISSING_PROPAGATION` | Add SX-DEC-069 to the active registry with its source, machine ceiling, and pending pixel review boundary. |
| F3 | `ACTIVE_CONTEXT.md` retains Candidate 009 wording in a current-next-action/evidence section after Candidate 010 became the exact current package. | `PREDECESSOR_CEILING_FREEZE` | Point mutable next-action/evidence text to Candidate 010 while retaining Candidate 009 only as historical evidence. |
| F4 | `PROJECT_OPERATING_HEALTH.json` exposes an early runtime/maturity snapshot without declaring it historical, although current runtime and package evidence is owned elsewhere. Its strict Base schema does not allow project-defined scope fields. | `CONFLICTING_SOURCE` | Preserve the schema-compatible health snapshot and record its non-current interpretation in the dated audit receipt; do not raise any evidence state. |
| F5 | The old thin adapter contains durable project boundaries but does not express Base's current task control plane, exact Git preflight, adoption matrix, or post-merge completion rescan in one Switchy-specific section. | `MISSING_PROJECT_ADAPTATION` | Add a concise, project-specific control-plane section rather than copying Base bodies. |
| F6 | `README.md`, the compact `ROADMAP.md` authority, and the SX-DEC-063 planning-gate wording leave pre-SX-DEC-069 state or pre-runtime framing on an entry surface. | `STALE_ENTRYPOINT` | Promote Candidate 010/SX-DEC-069 at the current entrypoints and label the prior SX-DEC-063 gate as historical rather than rewriting its evidence. |
| F7 | Exact-head Base validation rejected project-defined keys in the strict operating-health schema and requires external metadata for the already-approved protected current-canon delta. | `VALIDATOR_CONTRACT_DRIFT` | Keep the health file schema-compatible, preserve scope interpretation in the dated audit, extend the approved-source record with this user-approved task, and use the normal PR label gate. |

## Alternatives and decision

| Alternative | Decision | Reason |
|---|---|---|
| Repin the project to current Base and replace project routes/providers. | `REJECT` | Current Base main is a runtime authority to read, not a release lock to adopt without compatibility, canary, rollback, and approval evidence. |
| Copy current Base policies into several Switchy documents. | `REJECT` | Copied shared bodies create a second drift surface and weaken progressive fresh-read. |
| Keep the v9.4.3 compatibility lock, retain a thin adapter, and add a Switchy-specific current-Base control plane plus focused freshness tests. | `ADOPT` | Preserves product boundaries while making the latest Base execution method enforceable in the project. |

## Base adaptation matrix

| Base capability | Switchy disposition | Project-specific implementation |
|---|---|---|
| Current authority → actual consumer → verification sequence | `ADOPT` | Fresh-read Base completed main, project main, Open/Draft PRs, project owners, and actual affected consumers before each material write. |
| `PLAN → NONCODING_BUILD → GODOT_PRODUCT_BUILD → REVIEW` | `ADAPT` | Canon/contract work stays noncoding; GDScript/Scene/Resource/map/runtime changes require the exact Codex Godot handoff. |
| Minimum three alternatives and `ADOPT / ADAPT / REJECT` | `ADOPT` for L1+ | Internal Base/project sources are sufficient when no external product fact is material; record `NOT_MATERIAL` instead of inventing research. |
| Five adversarial loops and post-completion rescan | `ADOPT` for L1+ | Each loop must attack scope, current/history separation, consumer/reference propagation, evidence ceiling, and Git integration. |
| Git concurrent-change preflight and read-only Open PRs | `ADOPT` | Record execution surface, source main, branch parent, intended paths, semantic locks, and PR overlap before writing/publishing/merging. |
| `REMAINING_WORK = 0` completion gate | `ADAPT` | Zero closes only the approved task. Optional final-user review and release gates remain separate product gates. |
| GitHub primary workspace / Notion and Sheets retirement | `ADOPT` | Switchy is GitHub-only; history is audit-only and not an active sync requirement. |
| Current Base release/Registry/provider replacement | `DEFERRED_UNVERIFIED` | Keep v9.4.3 and current project Godot tooling until exact compatibility, canary, rollback, and user approval exist. |
| Base promotion from this task | `DEFERRED` | One project observation is not cross-project evidence; create no Base mutation or promotion proposal. |

## Responsibility structure after the change

| Question | Single owner | Consumer role |
|---|---|---|
| Which instructions and project-only deviations govern a task? | `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md` | Thin operating adapter. |
| What is currently true, the next safe action, and the evidence ceiling? | `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md` | Mutable resume locator. |
| Which decisions are currently approved? | `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md` | Decision ledger and owner links. |
| Where does a new worker start? | `기획서/00_프로젝트_허브/START_HERE.md` | Compact entry locator only. |
| Which document owns which question? | `기획서/00_프로젝트_허브/DOCUMENTATION_MAP.md` and `DESIGN_DOCUMENT_REGISTRY.json` | Navigation and registry, not duplicate decision truth. |
| What does the old Base release pin prove? | `docs/BASE_RULES_VERSION.md` and `skills/PROJECT_BASE_ADAPTER.json` | Historical compatibility only. |
| What did this Base-current fresh read observe? | `docs/operations/2026-09-01-switchy-base-operating-adaptation-audit.md` | Timestamped audit receipt, never a substitute for next-task fresh read. |

## Required work order

```text
FRESH_READ
→ CLASSIFY_L0_OR_L1_PLUS
→ RESTORE_INTENT_SCOPE_AND_EVIDENCE_CEILING
→ CURRENT_REPOSITORY_AND_CONSUMER_FEASIBILITY
→ THREE_ALTERNATIVE_TRADE_STUDY
→ USER_DECISION_IF_PRODUCT_OR_HIGH_RISK_BOUNDARY_CHANGES
→ PLAN
→ NONCODING_BUILD_OR_CODEX_GODOT_HANDOFF
→ RED_GREEN_RELEVANT_REGRESSION
→ FIVE_ADVERSARIAL_LOOPS_AND_CORRECTION
→ PUBLISH_PR_EXACT_HEAD_CHECKS
→ NORMAL_MERGE
→ POSTMERGE_MAIN_READBACK
→ REMAINING_WORK_RECALCULATION
→ CLEAN_REVIEW_EXIT
```

## Verification and rollback

- Add a focused Python regression that proves the Base-current control-plane markers, current SX-DEC-069/Candidate 010 locator state, no-repin policy, and historical health-snapshot classification.
- Run the focused test RED before adding the markers, then GREEN after the smallest corrections.
- Run the project contract validator and the relevant Python contract/freshness regression suite.
- Run five documented full-scope adversarial passes.  Correct every in-scope finding before publication.
- Use a normal feature branch, exact-head PR checks, normal merge, and `origin/main == local HEAD` readback.
- Rollback is a normal revert of this documentation/test-only change.  Historical evidence, Base v9.4.3 compatibility, product bytes, and Candidate 010 stay intact.
