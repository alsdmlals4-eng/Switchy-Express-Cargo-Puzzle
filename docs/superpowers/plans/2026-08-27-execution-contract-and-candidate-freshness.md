# Execution Contract and Candidate Freshness Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the project operating contract fail closed when player-facing bytes invalidate an acceptance candidate, while requiring a bounded GPT preparation → single Codex implementation → machine QA flow.

**Architecture:** The thin adapter owns durable workflow invariants and points to the existing active-context/candidate-pointer owners for current state. A focused Python contract test locks the new clauses. Current candidate records then distinguish the historical package from the new exact-main candidate that must be minted after runtime changes.

**Tech Stack:** Markdown, JSON, Python `unittest`, GitHub Actions, Godot 4.7.1, GUT 9.7.1, Hera live observation.

**Spec:** `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md`

## Global Constraints

- Preserve GMB-002 and SX-DEC-060 gameplay semantics; do not alter GDScript, Scenes, maps, assets, or PR #174.
- Treat all routine scoped choices as delegated; defer only irreversible loss, new cost, legal/rights uncertainty, security expansion, release publication, or core-identity change.
- Use actual code, candidate bytes, GitHub, and Notion readback; do not promote automated evidence to human/player PASS.
- User-approved production images require a concrete runtime consumer and dual project-local/Notion storage; this plan creates no image.

---

### Task 1: Lock the operating contract clauses with a RED test

**Files:**
- Create: `tests/python/test_execution_contract_freshness.py`
- Test: `tests/python/test_execution_contract_freshness.py`

**Interfaces:**
- Consumes: `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md`
- Produces: exact required marker assertions for startup reconciliation, delegated routine approval, fallback ladder, candidate freshness, GPT→Codex handoff, and machine-only QA boundary.

- [x] **Step 1: Write the failing test**

```python
for marker in REQUIRED_MARKERS:
    self.assertIn(marker, contract)
```

- [x] **Step 2: Run test to verify it fails**

Run: `python -m unittest tests.python.test_execution_contract_freshness -v`

Expected: FAIL because the adapter lacks the required exact execution clauses.

- [x] **Step 3: Commit later with Task 2**

### Task 2: Add only the missing execution invariants to the thin adapter

**Files:**
- Modify: `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md`
- Test: `tests/python/test_execution_contract_freshness.py`

**Interfaces:**
- Consumes: existing authority split, candidate pointer, current-owner read order, verification gate.
- Produces: a mandatory startup checklist, bounded fallback ladder, delegated approval boundary, GPT/Codex/human sequence, candidate freshness invalidation rule, and completion queue rule.

- [x] **Step 1: Add a startup reconciliation section**

Require core fun/system, SWOT, current candidate/head, protected scope, open PR, ready/deferred work, and evidence-ceiling readback before mutation.

- [x] **Step 2: Add execution and fallback sections**

Require GPT-owned noncoding preparation before one bounded Codex implementation window; require safe retry then evidence-equivalent fallback without lowering validation strength; require runtime/Hera/GUT evidence before deferred human validation.

- [x] **Step 3: Add candidate freshness and completion sections**

Mark any player-facing code/scene/resource/map/localization/consumer asset/export change as invalidating the current candidate; preserve tooling/test/docs-only changes; require GitHub/Notion reconciliation before a new candidate or gate promotion; require all machine-executable work to be zero before closing.

- [x] **Step 4: Run the RED test to verify it passes**

Run: `python -m unittest tests.python.test_execution_contract_freshness -v`

Expected: PASS.

- [x] **Step 5: Run contract regression**

Run: `python tools/validate_project_contract.py`

Expected: `project operating contract: PASS`.

### Task 3: Reconcile the post-060 candidate identity

**Files:**
- Modify: `evidence/acceptance/post_sx_dec_060_candidate.json`
- Modify: `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
- Modify: `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
- Modify: `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md`

**Interfaces:**
- Consumes: PR #198 exact player-facing merge and the existing `SX60-POC-ACCEPT-001` source identity.
- Produces: an explicit historical/superseded status for the old candidate and a current next action to mint a new exact-main candidate.

- [x] **Step 1: Write/extend a failing Python contract test**

Assert that a candidate whose pinned source commit predates the route-readability product merge is not described as the current candidate.

- [x] **Step 2: Make the smallest owner updates**

Retain all hashes/provenance for `SX60-POC-ACCEPT-001`, set its role to historical/superseded-by-player-facing-byte-change, and set the current candidate state to `NOT_CREATED` with main `a8eee4f...` as the new minimum baseline.

- [x] **Step 3: Run focused and full contract validation**

Run: `python -m unittest tests.python.test_execution_contract_freshness -v`

Run: `python -m unittest discover -s tests/python -p 'test_*.py' -v`

Expected: all tests pass; any Godot executable-dependent skip remains explicit.

### Task 4: Commit, review, merge, and sync current human-facing status

**Files:**
- Modify: only Task 1–3 files

**Interfaces:**
- Consumes: exact reviewed PR head and green required checks.
- Produces: merged main with GitHub and Notion Home/Direction/Production/Visual readback aligned to the candidate boundary.

- [x] **Step 1: Perform five-pass adversarial review**

Check authority/candidate identity, protected scope, test evidence, Notion/GitHub agreement, and completion/evidence ceiling. Correct every valid finding before PR.

- [ ] **Step 2: Create GitHub Issue and PR**

Use a `codex/` branch, reference the issue, and state that no gameplay or asset bytes change.

- [ ] **Step 3: Verify exact-head CI and merge safely**

Re-fetch main, confirm PR head/base freshness, CLEAN state, all required checks success, and no unresolved review blocker. Do not use direct main push, force push, or bypass.

- [ ] **Step 4: Update and read back Notion**

Update Home, Direction, Production, and Visual only with the candidate freshness boundary and exact merge SHA; read each page back.

## Self-Review

- Spec coverage: startup reconciliation, fallback, delegated scope, GPT/Codex transition, Godot/Hera machine QA, candidate freshness, completion queue, GitHub/Notion sync, and human-evidence boundary are mapped to Tasks 1–4.
- Placeholder scan: no unresolved implementation placeholders are present.
- Type consistency: the plan adds only Markdown/JSON status fields and Python string assertions; it introduces no runtime interfaces.

## Execution Handoff

Execute inline in this Codex session: tests first, minimal contract and owner updates, then exact-head review, merge, and Notion readback.
