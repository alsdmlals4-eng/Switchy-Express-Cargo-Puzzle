# Switchy Express r4 Authority & Planning Reconciliation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reconcile Switchy Express project authority to the user-approved v4.8 `2026-08-24-r4` contract, align all current validation locators to Candidate 003, and improve the human-facing Notion planning/flow projection without changing product runtime behavior.

**Architecture:** Keep the project adapter thin and progressive-load Base owners rather than copying the r4 contract. GitHub remains the structured/runtime authority, Notion remains the human-facing planning/flow surface, and Google Sheets remains migration-only evidence. Treat Candidate 003 physical/human gates as explicit evidence ceilings, not completion signals.

**Tech Stack:** Markdown, GitHub repository/PR/checks, Notion pages, existing project contract tests/workflows.

**Spec:** `docs/superpowers/specs/2026-08-25-r4-authority-planning-reconciliation-design.md`

## Global Constraints

- Product baseline: `GMB-002` finite delivery cargo puzzle.
- Current first session: `T1 → T2 → T3 → T4 → T5 → T6 → VS_DEMO_01 → Result / Retry / Edit`.
- Product runtime/code/Scene/Resource/asset changes are outside this package.
- `SX-DEC-056A/056B/057/058` implementation remains unauthorized/deferred.
- No endless/fuel/BOOST/capacity-8/cargo-slowdown/pickup-respawn/switch-auto-reset reintroduction.
- Current work-instruction revision must resolve to `2026-08-24-r4`.
- The historical r2 hash must never be relabeled as an r4 file hash.
- Candidate 003 physical visual, device, human-comprehension, and player-experience evidence remain fail-closed unless actually run.
- No direct main push, force push, or ruleset bypass.

---

### Task 1: Capture RED authority drift and prepare current branch

**Files:**
- Read: `AGENTS.md`
- Read: `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md`
- Read: `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
- Read: project contract tests/workflows that validate these owners

**Interfaces:**
- Consumes: baseline `main` `cf207f29cd4dcabc5796769f0eb0ca6764c2370e`
- Produces: explicit stale-fact inventory used by Tasks 2–4

- [ ] **Step 1: Read all three current authority files from the baseline/branch.**
- [ ] **Step 2: Record RED facts:** current project root/adapter still identify r2 and adapter evidence predates Candidate 003.
- [ ] **Step 3: Locate current project contract tests/workflows; do not invent check names.**
- [ ] **Step 4: Confirm branch contains only approved documentation/planning changes.**

### Task 2: Reconcile the thin adapter to r4 and Candidate 003

**Files:**
- Modify: `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md`

**Interfaces:**
- Consumes: user-provided v4.8 r4 contract, current Base owners, `ACTIVE_CONTEXT.md`
- Produces: one project-local thin adapter whose current revision is r4 and whose evidence ceiling resolves to Candidate 003

- [ ] **Step 1: Change the current revision locator to `2026-08-24-r4`.**
- [ ] **Step 2: Preserve r2 hash only as historical provenance; explicitly avoid claiming it hashes r4.**
- [ ] **Step 3: Route fresh-shell/update/shared Godot behavior to current Base/r4 owners without duplicating the full contract.**
- [ ] **Step 4: Replace stale acceptance-candidate state with Candidate 003 exact known state and validation route.**
- [ ] **Step 5: Re-read the file and verify deferred 056–058 boundaries and GMB-002 are unchanged.**

### Task 3: Reconcile root AGENTS and Active Context locators

**Files:**
- Modify: `AGENTS.md`
- Modify: `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`

**Interfaces:**
- Consumes: Task 2 adapter and current Candidate 003 evidence
- Produces: repository-wide current locator consistency

- [ ] **Step 1: Apply the smallest AGENTS change necessary to identify r4 as current and Active Context/Candidate 003 as live validation authority.**
- [ ] **Step 2: Do not expand AGENTS with copied r4 playbook text.**
- [ ] **Step 3: Update Active Context work-instruction locator from r2 to r4 while preserving current Candidate 003 state verbatim.**
- [ ] **Step 4: Re-read all three locator files and compare revision/candidate/deferred-package statements.**

### Task 4: Add fresh benchmark/planning evidence

**Files:**
- Create: `기획서/50_제작_검증/SX_AUD_070_R4_AUTHORITY_AND_PLANNING_RECONCILIATION.md`

**Interfaces:**
- Consumes: current product baseline, benchmark observations dated 2026-08-25
- Produces: durable project evidence separating observed facts, inference, applicability, and ADAPT/REJECT decisions

- [ ] **Step 1: Record Railbound, Mini Metro, Train Valley 2, and Rail Route source observations with URLs and observation date.**
- [ ] **Step 2: Explicitly state that popularity/review ratios do not establish causality.**
- [ ] **Step 3: Record selected approach A and rejected approaches B/C with implementation/maintenance/player-evidence tradeoffs.**
- [ ] **Step 4: State the product decision: no deferred breadth expansion before current physical/human evidence closes.**

### Task 5: GREEN repository verification

**Files:**
- Test: existing project contract checks/workflows discovered in Task 1

**Interfaces:**
- Consumes: Tasks 2–4 changes
- Produces: exact branch/commit verification evidence

- [ ] **Step 1: Compare branch against baseline and confirm no runtime/code/Scene/Resource/asset files changed.**
- [ ] **Step 2: Run/observe the repository's actual relevant contract checks on the exact branch/PR HEAD.**
- [ ] **Step 3: Verify r4/current-candidate strings through repository readback/search.**
- [ ] **Step 4: If a relevant check fails, classify root cause and minimally correct the documentation package; never weaken the check.**

### Task 6: Update Notion Human Home and planning/benchmark projection

**Files / destinations:**
- Notion: `Switchy Express · Home`
- Notion: `01 · Direction · Planning`
- Notion: `05 · Reference · Benchmark` or its existing library surface

**Interfaces:**
- Consumes: approved design and repository benchmark evidence
- Produces: human-facing whole-game flow, first-session learning flow, player-value explanation, and evidence-ladder explanation without AI/CI clutter

- [ ] **Step 1: Fetch each destination immediately before mutation.**
- [ ] **Step 2: Preserve Home's human-facing role and existing child pages.**
- [ ] **Step 3: Clarify whole game flow `Title → Build → Preflight → Run → Result → Retry/Edit`.**
- [ ] **Step 4: Preserve/clarify `T1→T6→VS_DEMO_01` first-session learning flow.**
- [ ] **Step 5: Add concise rationale: route planning + LIFO pickup order + run-time switch execution + redesign from feedback.**
- [ ] **Step 6: Keep automated/package vs physical vs human vs player-experience evidence explicitly separate.**
- [ ] **Step 7: Add benchmark conclusion to Direction/Reference, not raw CI/task logs to Home.**
- [ ] **Step 8: Fetch/read back all edited pages and confirm semantic placement.**

### Task 7: Minimum five-pass adversarial review

**Files:**
- Review: all changed GitHub files + Notion destinations + current consumers

**Interfaces:**
- Consumes: complete package state
- Produces: blocking-finding count 0 candidate

- [ ] **Step 1: Pass 1 — attack authority/provenance drift; fix only valid findings.**
- [ ] **Step 2: Pass 2 — attack stale evidence/candidate inflation; fix only valid findings.**
- [ ] **Step 3: Pass 3 — attack Notion human/system boundary violations; fix only valid findings.**
- [ ] **Step 4: Pass 4 — attack benchmark causality and feature-creep pressure; fix only valid findings.**
- [ ] **Step 5: Pass 5 — attack runtime-scope leakage, untouched consumers, maintenance/rework risk; fix only valid findings.**
- [ ] **Step 6: Re-run relevant regression/readback after any correction.**

### Task 8: PR, exact-head verification, merge, postmerge readback

**Files:**
- GitHub PR for `docs/r4-authority-planning-reconciliation-20260825`

**Interfaces:**
- Consumes: clean reviewed branch
- Produces: merged main + postmerge GitHub/Notion evidence

- [ ] **Step 1: Create one current-task PR with scope, RED/GREEN evidence, IRG ceiling, and benchmark disposition.**
- [ ] **Step 2: Read exact PR HEAD, changed-file list, required checks, unresolved review state/ruleset evidence available through the repository.**
- [ ] **Step 3: Merge only if current-task PR gates are satisfied; no force/admin bypass.**
- [ ] **Step 4: Read new `main` and confirm r4/current Candidate 003 alignment.**
- [ ] **Step 5: Re-fetch Notion destinations and confirm postmerge human-facing projection remains correct.**
- [ ] **Step 6: Report remaining physical/device/human/player gates as NOT_RUN rather than inflating completion.**
