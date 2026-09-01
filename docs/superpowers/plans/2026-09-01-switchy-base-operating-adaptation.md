# Switchy Base Operating Adaptation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the current Base execution model enforceable in Switchy's thin adapter and canonical locators without changing the Base compatibility pin or product bytes.

**Architecture:** The v4.8 adapter remains the only active work-contract owner and receives a concise Switchy-specific current-Base control plane.  Current status stays in `ACTIVE_CONTEXT`, approvals stay in `CURRENT_CONFIRMED_DECISIONS`, and a dated audit receipt records this one Base read without becoming next-task authority.  One focused Python test protects the separation between current and historical status.

**Tech Stack:** Markdown, JSON, Python `unittest`, project contract validator, GitHub Actions project-contract workflow.

**Spec:** `docs/superpowers/specs/2026-09-01-switchy-base-operating-adaptation-design.md`

## Global Constraints

- Keep Base `v9.4.3` as `HISTORICAL_COMPATIBILITY`; current Base is read fresh per task and never becomes a silent pin.
- Keep Switchy GitHub-only; Notion and Google Sheets remain retired from normal active use.
- Keep product source, maps, Scene/Resource/GDScript, art binary state, Candidate 010, and SX-DEC-065 validation policy unchanged.
- Keep every pre-existing Open/Draft/Ready PR read-only, including PR #174 and PR #254.
- Use `FRESH_READ → CLASSIFY → PLAN → BUILD/HANDOFF → VERIFY → FIVE_LOOPS → PR → MERGE → MAIN_READBACK → REMAINING_WORK_RECALCULATION` for L1+ work.
- Do not call unrun human/device/audio/accessibility/release evidence `PASS`.

---

### Task 1: Lock the contract with a failing regression

**Files:**

- Create: `tests/python/test_base_operating_adaptation.py`
- Read: `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md`
- Read: `기획서/00_프로젝트_허브/START_HERE.md`
- Read: `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
- Read: `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
- Read: `docs/PROJECT_OPERATING_HEALTH.json`

**Interfaces:**

- Consumes: the active adapter and current owner documents.
- Produces: `BaseOperatingAdaptationTests`, a deterministic guard against Base repinning and current/history locator drift.

- [ ] **Step 1: Write the failing test**

```python
def test_adapter_adopts_current_base_execution_without_repining() -> None:
    adapter = read("PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md")
    assert "base_current_execution_model: FRESH_READ_ONLY_NO_REPIN" in adapter
    assert "FRESH_READ → CLASSIFY → PLAN → BUILD_OR_HANDOFF → VERIFY → FIVE_ADVERSARIAL_LOOPS" in adapter
    assert "project_base_compatibility_pin: v9.4.3" in adapter
```

- [ ] **Step 2: Run the focused test and verify RED**

Run: `python -m unittest tests.python.test_base_operating_adaptation -v`

Expected: `FAIL` because `test_base_operating_adaptation` and the current-Base marker do not yet exist.

- [ ] **Step 3: Add the smallest complete test suite**

```python
def test_current_locators_select_sx_dec_069_and_candidate_010() -> None:
    for relative in ("기획서/00_프로젝트_허브/START_HERE.md", "기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md"):
        text = read(relative)
        assert "SX-DEC-069" in text
        assert "SX60-POC-ACCEPT-010" in text

def test_operating_health_declares_its_historical_snapshot_role() -> None:
    health = json.loads(read("docs/PROJECT_OPERATING_HEALTH.json"))
    assert health["snapshot_role"] == "HISTORICAL_COMPATIBILITY_SNAPSHOT"
    assert health["current_runtime_authority"] == "ACTIVE_CONTEXT_AND_DECISION_OWNERS"
```

- [ ] **Step 4: Leave the suite red until the contract and locators are changed**

Run: `python -m unittest tests.python.test_base_operating_adaptation -v`

Expected: `FAIL` with missing Base-current markers and missing historical health snapshot fields.

- [ ] **Step 5: Commit after the implementation tasks are green**

```bash
git add tests/python/test_base_operating_adaptation.py
git commit -m "test: guard base operating adaptation"
```

### Task 2: Add the thin Base-current control plane

**Files:**

- Modify: `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md`
- Modify: `AGENTS.md`
- Create: `docs/operations/2026-09-01-switchy-base-operating-adaptation-audit.md`
- Modify: `docs/PROJECT_OPERATING_HEALTH.json`

**Interfaces:**

- Consumes: Base current `main@19355b7`, the design spec, and Switchy's v9.4.3 compatibility record.
- Produces: explicit `ADOPT / ADAPT / DEFERRED` rules and a dated non-authoritative audit receipt.

- [ ] **Step 1: Add the adapter control-plane markers**

```yaml
base_current_execution_model: FRESH_READ_ONLY_NO_REPIN
base_current_observation_role: TASK_SCOPED_AUDIT_INPUT_NOT_RELEASE_LOCK
project_base_compatibility_pin: v9.4.3 · HISTORICAL_COMPATIBILITY
current_base_provider_change: DEFERRED_UNVERIFIED
```

- [ ] **Step 2: Add the exact L1+ workflow**

```text
FRESH_READ → CLASSIFY → PLAN → BUILD_OR_HANDOFF → VERIFY → FIVE_ADVERSARIAL_LOOPS
→ PR_EXACT_HEAD → NORMAL_MERGE → MAIN_READBACK → REMAINING_WORK_RECALCULATION
```

- [ ] **Step 3: Record the Base observation without turning it into a pin**

```yaml
base_completed_main_observed: 19355b7ef065a21d0f2b685c7d9be64a4a3970f8
observation_status: HISTORICAL_TASK_RECEIPT
next_task_requirement: REFRESH_BASE_COMPLETED_MAIN_AGAIN
base_repository_mutation: NOT_PERFORMED
```

- [ ] **Step 4: Classify the health JSON as a historical snapshot**

```json
{
  "snapshot_role": "HISTORICAL_COMPATIBILITY_SNAPSHOT",
  "current_runtime_authority": "ACTIVE_CONTEXT_AND_DECISION_OWNERS"
}
```

- [ ] **Step 5: Run the focused regression and verify GREEN**

Run: `python -m unittest tests.python.test_base_operating_adaptation -v`

Expected: `PASS`.

### Task 3: Reconcile the current locators and registry

**Files:**

- Modify: `기획서/00_프로젝트_허브/START_HERE.md`
- Modify: `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
- Modify: `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
- Modify: `기획서/00_프로젝트_허브/DOCUMENTATION_MAP.md`
- Modify: `기획서/00_프로젝트_허브/DESIGN_DOCUMENT_REGISTRY.json`
- Modify: `README.md`
- Modify: `기획서/00_프로젝트_허브/ROADMAP.md`
- Modify: `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md`

**Interfaces:**

- Consumes: Candidate 010 pointer and Decision SX-DEC-069.
- Produces: exactly one mutable status locator, a complete active Decision Registry, and navigation that does not promote historical evidence.

- [ ] **Step 1: Correct every compact current-entry span and add the control-plane route**

```markdown
| 결정 범위 | `SX-DEC-027~069` |
| 현재 Base 적응 작업 계약 | `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md` |
```

`README.md` and `ROADMAP.md` must identify `SX-DEC-027~069` and Candidate 010 as current.  The old SX-DEC-063 planning gate must be preserved as `HISTORICAL_PRE_RUNTIME`, with current runtime ownership linked rather than silently overwritten.

- [ ] **Step 2: Replace Candidate 009 wording in mutable Active Context sections**

```text
SX-DEC-069 merged main@79323ff...
→ SX60-POC-ACCEPT-010 is the exact current machine package candidate
→ Candidate 009 remains historical pre-SX-DEC-069 evidence
```

- [ ] **Step 3: Add the missing SX-DEC-069 Decision Registry row**

```markdown
| **SX-DEC-069** | **Transparent wayside cutouts and speed-transition presentation · MERGED_MAIN_VERIFIED · PR #276 · Candidate 010 exact machine package · v02 pixels pending user review** |
```

- [ ] **Step 4: Register the thin adapter and dated audit receipt by role**

```json
{
  "id": "SX-BASE-CURRENT-OPERATING-ADAPTATION-20260901",
  "source": "docs/operations/2026-09-01-switchy-base-operating-adaptation-audit.md",
  "status": "HISTORICAL_AUDIT_RECEIPT"
}
```

- [ ] **Step 5: Run focused freshness tests**

Run: `python -m unittest tests.python.test_base_operating_adaptation tests.python.test_execution_contract_freshness tests.python.test_current_poc_candidate_pointer -v`

Expected: `PASS`.

### Task 4: Validate, adversarially review, and publish

**Files:**

- Modify if required by validated finding: only files listed in Tasks 1–3.
- Modify if the protected validator identifies an exact approved-delta reconciliation: `docs/operations/PROJECT_PROTECTED_CHANGE_APPROVAL.json` only, preserving its exact detected-path set and recording the current user approval source.
- Read: `.github/workflows/project-contract.yml`
- Read: `skills/PROJECT_BASE_ADAPTER.json`

**Interfaces:**

- Consumes: the planned diff and all focused regression results.
- Produces: a review receipt, a normal PR, required CI evidence, merged-main readback, and remaining-work result.

- [ ] **Step 1: Run the project contract and relevant Python suite**

Run: `python tools/validate_project_contract.py` and `python -m unittest discover -s tests/python -p 'test_*.py' -v`

Expected: project contract `PASS`; every executed Python test `OK` with any documented skip preserved as `skipped`.

- [ ] **Step 2: Run five full adversarial loops**

```text
1. Scope and protected-product attack
2. Current-versus-historical owner attack
3. Reference, registry, and test propagation attack
4. Evidence-ceiling and claim-inflation attack
5. Git/pre-existing-PR/rollback attack
```

Expected: each valid in-scope finding is corrected and retested; unresolved findings are recorded as `BLOCKED_UNVERIFIED` rather than passed.

- [ ] **Step 3: Commit the cohesive implementation**

```bash
git add AGENTS.md PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md docs tests 기획서
git commit -m "docs: adapt current Base operating model for Switchy"
```

- [ ] **Step 4: Publish a normal PR and wait for exact-head checks**

Run: `git push -u origin codex/base-operating-adaptation-20260901`

Expected: PR targets `main`, contains only approved contract/status/test paths, has exact-head required checks, and uses `approved-protected-change` only when the current user approval is recorded in the exact-path manifest.

- [ ] **Step 5: Merge normally, read back main, and recalculate remaining work**

Run: `git fetch --prune`, `git pull --ff-only`, `git rev-parse HEAD`, `git rev-parse origin/main`, and `git status --short --branch`.

Expected: local `HEAD == origin/main`, clean worktree, no touched pre-existing PR, and either `REQUIRED_WORK_REMAINING: 0` for this operating-adaptation scope or an explicit next safe action.

## Plan self-review

- Spec coverage: Tasks 1–4 cover every required current-state correction, Base adaptation rule, no-repin boundary, verification, normal Git flow, and rollback stated in the design spec.
- Placeholder scan: no task contains deferred implementation language; every code/test task has an exact command and expected outcome.
- Interface consistency: the test names, adapter markers, Candidate 010 identifier, and audit receipt path use the same strings in every task.

## Execution choice

The approved task will use **inline execution** in this session.  It is a single cohesive contract update, and the project has multiple unrelated retained worktrees that should not be repurposed.  No subagent or pre-existing PR will be used.
