# Switchy Express v4.8 r4 Authority and Human Flow Reconciliation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reconcile current project authority from v4.8 r2 to the user-approved v4.8 r4 contract, align current Candidate 003 evidence routing, and refine the Notion Human Home into a full game-flow learning surface without changing gameplay/runtime bytes.

**Architecture:** Reuse the existing v4.8 thin adapter and v4.8 migration regression rather than creating a second authority system. Apply RED-first contract changes on one isolated GitHub branch, make minimal current-owner edits, record one `SX-AUD-070` audit, update only the bounded Human Home projection in Notion, then run exact-head checks, minimum five full adversarial loops, merge, and perform GitHub/Notion post-merge readback.

**Tech Stack:** Markdown, Python unittest, GitHub Actions, GitHub connector, Notion project workspace. Godot 4.7.1/GDScript runtime is protected and not modified by this docs-only package.

**Spec:** `docs/superpowers/specs/2026-08-25-v48-r4-authority-and-human-flow-reconciliation-design.md`

## Global Constraints

- Approved tracking identity: `SX-AUD-070`; this is an audit/reconciliation, not a new gameplay Decision.
- Project baseline main: `cf207f29cd4dcabc5796769f0eb0ca6764c2370e`.
- Base latest completed main observed at work start: `ceb83c680f76fead5811956bd6503fd5e4da8577`; always refetch before final merge/readback.
- User contract: `v4.8 · 2026-08-24-r4`; exact supplied file SHA-256: `1426c2e5e25e32dc72abccf49e4a0839578e54c14b38ba0de045be426fd63ea6`.
- Historical r2 source SHA-256 `6f0541048e084746f6777223521361d0339dbfb2e223c70947f694f1c050f508` remains provenance only.
- `GMB-002` and `SX-DEC-027~059` product meaning remain unchanged.
- Current acceptance target is `SX59-POC-ACCEPT-003`; its physical visual recheck, developer self-run, audio perceptual QA, Android device, five-person comprehension, and player-experience gates are not promoted without direct evidence.
- `SX-DEC-056A/056B/057/058` authorization states remain unchanged.
- No `game/**`, Scene, Resource, gameplay data, product PNG/audio, save/schema, score/combo formula, or solver change.
- No image generation/editing.
- Notion remains human-facing authority for project overview/flow; GitHub/runtime remains structured/runtime authority; Google Sheets remains migration-only and receives no new planning writes.
- Work occurs only on `docs/v48-r4-authority-reconcile-20260825` until the current-task PR is merged; no force push, direct main push, ruleset bypass, or unrelated PR mutation.

---

### Task 1: Freeze approved design and verify isolated baseline

**Files:**
- Create: `docs/superpowers/specs/2026-08-25-v48-r4-authority-and-human-flow-reconciliation-design.md`
- Create: `docs/superpowers/plans/2026-08-25-v48-r4-authority-and-human-flow-reconciliation.md`

**Interfaces:**
- Consumes: user approval, fresh Base/project/Notion/Sheet evidence, prior r2 reconciliation plan.
- Produces: one written design and one executable plan for the r4 delta.

- [x] **Step 1: Create isolated GitHub branch from exact project main `cf207f29...`.**
- [x] **Step 2: Write the approved design with exact source hash, protected boundaries, trade study, benchmark synthesis, IRG, acceptance, and rollback.**
- [x] **Step 3: Write this implementation plan and self-review for scope/placeholder consistency.**

### Task 2: RED — strengthen the v4.8 authority regression contract

**Files:**
- Modify: `tests/python/test_v48_current_authority_migration.py`

**Interfaces:**
- Consumes: existing r2 regression test and current Candidate 003 Active Context.
- Produces: a test that rejects stale r2 and Candidate 001 authority while preserving deferred package/evidence ceilings.

- [ ] **Step 1: Change current expected revision from `2026-08-24-r2` to `2026-08-24-r4`.**
- [ ] **Step 2: Replace the r2 source-hash constant used as current identity with exact supplied r4 file SHA-256 `1426c2e5...63ea6`; keep r2 only as historical provenance assertion if useful.**
- [ ] **Step 3: Require current entry surfaces to advertise r4.**
- [ ] **Step 4: Require the adapter to identify `SX59-POC-ACCEPT-003`, Candidate 003 Gate 0 physical visual recheck, developer self-run/screen QA, audio perceptual QA, Windows, Android, and five-person evidence separation.**
- [ ] **Step 5: Preserve tests that keep 056~058 unauthorized and `player_experience: NOT_RUN`.**
- [ ] **Step 6: Commit the test-only RED state.**
- [ ] **Step 7: Open the current-task PR and observe the expected Project Contract/Python failure caused specifically by stale r2/current-candidate content. Do not implement GREEN before the RED is observed.**

### Task 3: GREEN — update the existing r4 thin authority path

**Files:**
- Modify: `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md`
- Modify: `AGENTS.md`
- Modify: `README.md`
- Modify: `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`

**Interfaces:**
- Consumes: Task 2 failing expectations plus user r4 contract and current Candidate 003 evidence.
- Produces: one coherent r4 current authority route without duplicating Base procedure.

- [ ] **Step 1: Update adapter front matter to `revision: '2026-08-24-r4'` and record exact `source_v4_8_r4_sha256: 1426c2e5...63ea6`; retain the prior r2 source hash as historical provenance.**
- [ ] **Step 2: Add only r4 project-relevant invariants: reviewed safe auto-update/exact pin semantics, shared compatible Godot exact pin, default fixed Godot AI ports with exact session routing, and no Editor requirement for docs-only work. Do not copy the full Base/r4 playbook.**
- [ ] **Step 3: Replace stale adapter Candidate 001 evidence with Candidate 003 as current; preserve Candidate 002 physical startup as historical blocked evidence and keep physical/human PASS fail-closed.**
- [ ] **Step 4: Update AGENTS current work-instruction locator from r2 to r4 and align Candidate 003 current gate without altering GMB-002 or deferred package states.**
- [ ] **Step 5: Update README current authority/evidence/next-work sections to r4 + Candidate 003 and remove stale `SX59-ACCEPT-001` as current.**
- [ ] **Step 6: Update ACTIVE_CONTEXT work-instruction locator from r2 to r4 and exact source hash, leaving Candidate 003 exact artifact evidence and next physical gate unchanged.**
- [ ] **Step 7: Commit the minimal GREEN implementation.**

### Task 4: Create the repository audit record

**Files:**
- Create: `기획서/50_제작_검증/SX_AUD_070_V48_R4_AUTHORITY_AND_HUMAN_FLOW_RECONCILIATION.md`

**Interfaces:**
- Consumes: Tasks 2–3 diff, benchmark sources, current Notion/Sheet readback.
- Produces: durable repository evidence for rationale, RED/GREEN, IRG, review and post-merge closure.

- [ ] **Step 1: Record exact baseline/current branch identity, current Base SHA, r4 file SHA, scope and non-goals.**
- [ ] **Step 2: Record A/B/C trade study and benchmark `ADAPT / REFERENCE_ONLY / REJECT_NOW` conclusions without causal overclaim.**
- [ ] **Step 3: Record RED evidence and GREEN exact-head checks as they become available.**
- [ ] **Step 4: Record IRG ceiling: repository/Notion readback can PASS; runtime/device/human/player remains NOT_RUN/NOT_APPLICABLE for this docs-only package.**
- [ ] **Step 5: Reserve sections for five-pass review and merge/postmerge identity; populate them before completion instead of leaving placeholders.**

### Task 5: Refine the Notion Human Home without creating a second workspace

**Surfaces:**
- Modify: Notion `Switchy Express · Home` (`3c41b237-eb1c-8103-9537-ede6dfc5f07e`)
- Readback: five existing L2 Domain links and existing Visual/Benchmark owners.

**Interfaces:**
- Consumes: existing Home, current finite product promise, T1→T6→Capstone flow, Visual Domain, current Candidate 003 gate.
- Produces: human-readable full game flow and learning surface, not AI operational metadata.

- [ ] **Step 1: Fetch the enhanced Markdown spec and the current Home immediately before editing.**
- [ ] **Step 2: Replace only the bounded top Home content while preserving all five child Domain pages and System Record link.**
- [ ] **Step 3: Add a concise 10-second promise and full flow: `Title/Briefing → BUILD → Preflight → RUN → Pickup/LIFO/Switch → Delivery/Terminal → Result → Retry Same Layout or Edit`.**
- [ ] **Step 4: Add `Plan → Commit → Observe → Diagnose → Re-design` as the core emotional/decision loop.**
- [ ] **Step 5: Keep T1→T6→VS_DEMO_01 curriculum and add short learning intent per stage.**
- [ ] **Step 6: Add existing visual-language summary: approved E+D Hybrid assets already consumed; color+shape+text/state redundancy; Reduced Motion meaning parity. Do not generate a new image.**
- [ ] **Step 7: Keep Candidate 003 physical/human evidence fail-closed and move detailed SHA/CI/tool metadata to System/Production surfaces rather than Home.**
- [ ] **Step 8: Fetch Home after update and verify exact semantic placement and all child Domain links remain present.**

### Task 6: GREEN and exact-head repository verification

**Files/Surfaces:**
- Test only; no runtime mutation.

**Interfaces:**
- Consumes: Tasks 2–4 candidate branch state.
- Produces: exact-head executable evidence for the current-task PR.

- [ ] **Step 1: Re-read the PR exact HEAD and changed-file list; confirm no runtime/product asset files changed.**
- [ ] **Step 2: Observe the v4.8 authority regression GREEN.**
- [ ] **Step 3: Run/inspect repository workflows applicable to the actual change class. Do not infer required-check names from old docs; discover them from the PR/rules/workflow evidence.**
- [ ] **Step 4: If any validator fails, use Case Lookup + systematic debugging, fix the root cause without deleting/weakening tests, and rerun.**
- [ ] **Step 5: Verify no unexpected generated derivative or stale consumer still advertises r2/current Candidate 001; add only minimal freshness correction if a live consumer is found.**

### Task 7: Minimum five full adversarial loops

**Files/Surfaces:**
- Entire current-task PR diff
- Current Base/project canon
- Notion Home readback
- Google Sheet migration-only boundary
- Applicable CI/check evidence

**Interfaces:**
- Consumes: exact-head candidate and all evidence above.
- Produces: `CLEAN_REVIEW_EXIT` only after at least five full-scope loops and zero new blockers.

- [ ] **Step 1: Full loop 1 — full-scope attack: intent, authority, consumers, runtime protection, Notion projection, evidence ceiling, CI, cost, rollback, better alternative, long-term fit. Validate and fix only real findings.**
- [ ] **Step 2: Full loop 2 — repeat the whole scope on the resulting state; specifically challenge duplicate authority and stale provenance/current-status ambiguity.**
- [ ] **Step 3: Full loop 3 — repeat the whole scope; challenge Human Home information hierarchy, domain split, accessibility meaning, Sheet migration boundary, and player-evidence overclaim.**
- [ ] **Step 4: Full loop 4 — repeat the whole scope; challenge tests/CI/IRG/rollback/failure recovery, unrelated-file drift, and long-term maintenance cost.**
- [ ] **Step 5: Full loop 5 — repeat the whole scope from scratch; rerun better-alternative search and long-term fit.**
- [ ] **Step 6: Continue loop 6+ if any valid MUST_FIX/P0/P1/acceptance blocker remains.**
- [ ] **Step 7: Populate the five-pass evidence in `SX-AUD-070`; do not count different lenses as different full loops.**

### Task 8: PR merge gate and post-merge readback

**Files/Surfaces:**
- Current-task PR only
- Project `main`
- Base `main`
- Notion Home

**Interfaces:**
- Consumes: clean exact-head PR, check/review/thread evidence.
- Produces: merged new main plus durable GitHub/Notion readback.

- [ ] **Step 1: Refetch project main and Base main; if project main moved, reconcile safely without force and revalidate exact HEAD.**
- [ ] **Step 2: Verify current PR reviews, unresolved threads, discovered required checks/ruleset and exact HEAD.**
- [ ] **Step 3: Merge only this current-task PR using a repository-permitted method; no admin/ruleset bypass.**
- [ ] **Step 4: Fetch new project main and compare retained changes to the approved scope.**
- [ ] **Step 5: Fetch adapter, AGENTS, README, ACTIVE_CONTEXT and `SX-AUD-070` from new main; verify r4/Candidate 003 authority and preserved evidence ceilings.**
- [ ] **Step 6: Fetch Notion Home and confirm full game flow, learning path, visual-language summary and Domain links persist.**
- [ ] **Step 7: Complete post-change monitor/correction rescan; if a new valid omission/conflict appears, reopen remaining work and fix through the same owner before completion.**

## Self-Review

- Spec coverage: r4 authority, exact source identity, Candidate 003 routing, existing-solution reuse, Human Home projection, Sheet migration-only boundary, TDD, IRG, five-pass review, merge/postmerge readback are all mapped.
- Placeholder scan: no implementation step delegates decisions to `TBD`/`TODO`; the audit file may not retain empty placeholder sections at completion.
- Scope: one authority/planning reconciliation package; no independent gameplay subsystem is mixed in.
- Interface consistency: the test is RED before current-owner GREEN; the same `SX-AUD-070` identity ties repository and Notion change evidence; exact Candidate 003 physical/human gates remain independent.
