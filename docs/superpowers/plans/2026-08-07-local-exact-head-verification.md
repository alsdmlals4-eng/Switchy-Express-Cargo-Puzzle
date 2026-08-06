# Local Exact-HEAD Verification Fallback Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a repository-owned Windows/local verifier that replaces GitHub-hosted Actions execution while preserving exact-HEAD, GUT, regression, and production-mutation evidence.

**Architecture:** A tested Python core performs deterministic hashing, command execution, JUnit parsing, and evidence generation. A thin PowerShell wrapper supplies Windows paths and invokes the Python core. Documentation and Decision `SX-DEC-047` define the temporary fallback without changing game production files or existing workflows.

**Tech Stack:** Python 3.12 standard library, PowerShell 7/Windows PowerShell 5.1-compatible syntax, Git CLI, Godot 4.7.1-stable, GUT 9.7.1, `unittest`, JUnit XML.

## Global Constraints

- Base commit: `a18b9fd52734f1884286bc3d0830e337d0c800c9`.
- Do not modify `project.godot`, `.tscn`, `.tres`, `.res`, gameplay scripts, assets, or existing workflow files.
- Every branch commit and merge commit uses `[skip actions]` during the budget constraint.
- Evidence is valid only for the exact verified HEAD.
- GUT discovery below 6 is failure.
- Production hashes must remain unchanged before and after test execution.
- Windows/Android runtime and HiGodot connection are not claimed by this task.

---

### Task 1: Python Verification Core

**Files:**
- Create: `tests/python/test_local_exact_head_verification.py`
- Create: `tools/local_exact_head_verification.py`

**Interfaces:**
- Produces: `hash_production_files(root: Path, artifact_dir: Path) -> dict[str, str]`
- Produces: `parse_junit(path: Path) -> tuple[int, int, int, int]`
- Produces: `verify_evidence(inputs: VerificationInputs) -> dict[str, object]`
- Produces CLI: `python tools/local_exact_head_verification.py verify ...`

- [ ] **Step 1: Write failing tests for missing verifier, exact-head mismatch, dirty tree, JUnit floor, mutation, and success manifest.**
- [ ] **Step 2: Run `python -m unittest tests.python.test_local_exact_head_verification -v` and confirm RED because the verifier does not exist.**
- [ ] **Step 3: Implement deterministic hashing, JUnit parsing, command capture, fail-closed validation, and JSON manifest output with standard library only.**
- [ ] **Step 4: Run the targeted unittest module and confirm all tests PASS.**
- [ ] **Step 5: Run `python -m compileall tools tests/python` and confirm PASS.**

### Task 2: Windows PowerShell Entry Point

**Files:**
- Modify: `tests/python/test_local_exact_head_verification.py`
- Create: `tools/run_local_exact_head_verification.ps1`

**Interfaces:**
- Consumes: Python verifier CLI.
- Produces: `./tools/run_local_exact_head_verification.ps1 -ExpectedHead <sha> -GodotExecutable <path>`.

- [ ] **Step 1: Add contract tests requiring strict mode, exact parameters, repository-root resolution, artifact path, and Python verifier invocation.**
- [ ] **Step 2: Run the targeted unittest module and confirm RED because the wrapper is absent.**
- [ ] **Step 3: Implement the minimal wrapper without modifying repository state.**
- [ ] **Step 4: Run the targeted unittest module and confirm PASS.**

### Task 3: Operator Documentation and Canon

**Files:**
- Create: `docs/testing/LOCAL_EXACT_HEAD_VERIFICATION.md`
- Create: `docs/decisions/SX_DEC_047_LOCAL_EXACT_HEAD_FALLBACK.md`
- Create: `기획서/50_제작_검증/SX_AUD_028_LOCAL_EXACT_HEAD_FALLBACK.md`

**Interfaces:**
- Consumes: verifier and wrapper commands.
- Produces: same-ID GitHub canon for Sheet synchronization and a copy/paste PR evidence format.

- [ ] **Step 1: Add static contract assertions to the Python test for required documentation tokens and Decision/Audit IDs.**
- [ ] **Step 2: Run the targeted unittest module and confirm RED for missing documentation.**
- [ ] **Step 3: Write operator documentation and canonical Decision/Audit records; bind the operational decision in a dedicated canonical Decision document without changing gameplay decisions.**
- [ ] **Step 4: Run targeted tests and compileall; confirm PASS.**

### Task 4: Branch, PR, and Sheet Synchronization

**Files:**
- No additional repository files beyond Tasks 1-3.
- Update Google Sheet tabs: `00_프로젝트_허브`, `01_작업순서`, `02_현재_확정결정`, `04_누락_충돌_감사`, `50_제작_검증`.

**Interfaces:**
- Produces branch `chore/local-exact-head-verification-fallback` and PR with `[skip actions]` commit history.

- [ ] **Step 1: Create branch from `a18b9fd52734f1884286bc3d0830e337d0c800c9`.**
- [ ] **Step 2: Commit exact tested file bytes with `[skip actions]`.**
- [ ] **Step 3: Open PR and confirm hosted workflow runs are skipped/not created.**
- [ ] **Step 4: Inspect full changed-file inventory, patches, review threads, and mergeability.**
- [ ] **Step 5: Record `SX-DEC-047` and `SX-AUD-028` in Sheet with exact branch/PR HEAD and read back values.**
- [ ] **Step 6: Merge only if no production files changed and no P0/P1 finding remains; use expected HEAD and `[skip actions]` merge message.**
- [ ] **Step 7: Read merged `main`, update Sheet to merged SHA, and leave Windows full-project verifier execution as the exact next action.**
