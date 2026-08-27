# SX-DEC-060 Exact Candidate 002 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Mint `SX60-POC-ACCEPT-002` from the independently verified Windows Demo Export at exact main `0e882764b837d13282a7642b115948d4e061d163`.

**Architecture:** Keep the machine-readable post-060 candidate pointer as the sole selection authority. Bind one new artifact evidence owner and one deep PCK audit to the artifact’s immutable content hashes; route the launcher and human-facing candidate document through that pointer without promoting any physical, device, or human gate.

**Tech Stack:** GitHub Actions artifact API, PowerShell launcher, Python `unittest`, Python PCK integrity verifier, Godot 4.7.1 CI evidence.

**Spec:** `docs/decisions/SX_DEC_060_CARDINAL_STATION_SERVICE_AND_REACHABLE_NETWORK.md`, `evidence/acceptance/post_sx_dec_060_candidate.json`, GitHub Issue #206.

## Global Constraints

- Candidate source must be exact main `0e882764b837d13282a7642b115948d4e061d163`; its artifact run is `33030116761` and artifact is `9629917429`.
- Candidate 001 and Candidate 003 remain immutable history; PR #174 remains read-only.
- No `game/**`, map, scene, product asset, audio, or deferred SX-DEC-056~058 change.
- No new bitmap assets and no physical/device/human/player PASS claim.
- The candidate launcher must retain explicit-pointer and source-ancestry fail-closed behavior.

---

### Task 1: Lock the candidate contract in RED tests

**Files:**
- Modify: `tests/python/test_sx_dec_060_candidate_mint.py`
- Modify: `tests/python/test_current_poc_candidate_pointer.py`
- Create: `tests/python/test_sx_dec_060_candidate_002_evidence.py`

**Interfaces:**
- Consumes: `evidence/acceptance/post_sx_dec_060_candidate.json`.
- Produces: the exact expected candidate ID, artifact/evidence owner paths, source SHA, content hashes, and evidence ceiling for Task 2.

- [x] **Step 1: Write failing candidate-002 expectations**

Require `PREPARED_PACKAGE_VERIFIED`, `SX60-POC-ACCEPT-002`, exact artifact `9629917429`, run `33030116761`, source `0e882...`, and all physical/device/human keys as `NOT_RUN`.

- [x] **Step 2: Run the focused test files to verify RED**

Run: `python -m unittest tests.python.test_sx_dec_060_candidate_mint tests.python.test_current_poc_candidate_pointer tests.python.test_sx_dec_060_candidate_002_evidence -v`

Expected: FAIL because the current pointer is `NOT_CREATED` and Candidate 002 evidence owners do not exist.

- [x] **Step 3: Commit after GREEN in Task 2**

```powershell
git add tests/python/test_sx_dec_060_candidate_mint.py tests/python/test_current_poc_candidate_pointer.py tests/python/test_sx_dec_060_candidate_002_evidence.py
git commit -m "test: specify exact SX60 candidate 002 evidence"
```

### Task 2: Mint the machine-readable candidate and auditable human record

**Files:**
- Modify: `evidence/acceptance/post_sx_dec_060_candidate.json`
- Create: `evidence/acceptance/sx60_poc_accept_002_artifact.json`
- Create: `evidence/acceptance/sx60_poc_accept_002_pck_deep_audit.json`
- Create: `기획서/50_제작_검증/SX_DEC_060_POC_ACCEPTANCE_CANDIDATE_02.md`
- Create: `기획서/50_제작_검증/SX_DEC_060_POC_DEVELOPER_SELF_RUN_RECORD_02.md`

**Interfaces:**
- Consumes: Task 1 test contract and independently downloaded artifact evidence.
- Produces: the single explicit current candidate pointer read by `RUN_SX60_POC_SELF_RUN.ps1`.

- [x] **Step 1: Add minimal artifact and deep-audit evidence**

Record the API/download ZIP digest `b2602554ec28ba8597cc509c6dc2e1b61a946ca193a31673ed96bf9671c8c8e3`, EXE hash `1cb23...c3244`, Windows PCK hash `d360...cd49`, Android validation PCK hash `6ce0...96b6`, PCK 479/479 integrity, and 73/73 import/CTEX crosscheck.

- [x] **Step 2: Point the post-060 pointer only at Candidate 002**

Set the explicit candidate ID and evidence-owner paths; preserve the historical predecessor and superseded Candidate 001 sections unchanged.

- [x] **Step 3: Write a candidate document and self-run record with the evidence ceiling**

State package verification and automated runtime JSON proof only. Keep developer self-run, full Windows physical runtime, audio, Android device, five-person comprehension, player experience, and production cutover closed.

- [x] **Step 4: Run focused tests to verify GREEN**

Run: `python -m unittest tests.python.test_sx_dec_060_candidate_mint tests.python.test_current_poc_candidate_pointer tests.python.test_sx_dec_060_candidate_002_evidence -v`

Expected: PASS with Candidate 002 as the only current post-060 route.

### Task 3: Propagate the new pointer only to active consumers

**Files:**
- Modify: active current-state docs returned by `rg -l "NOT_CREATED|MINT_NEW_EXACT_POST_ROUTE_READABILITY"` excluding historical records.
- Modify: candidate-related Python freshness tests that encode the current `NOT_CREATED` state.

**Interfaces:**
- Consumes: Task 2 pointer and candidate records.
- Produces: one coherent GitHub current-state surface; historical candidate records remain historical.

- [x] **Step 1: Update only current owner wording**

Replace the current no-candidate next action with Candidate 002 package-verification and the next physical self-run gate; do not rewrite dated historical entries.

- [x] **Step 2: Verify stale-reference scan**

Run: `rg -n -i "SX60-POC-ACCEPT-001.*(current|next|physical)|MINT_NEW_EXACT_POST_ROUTE_READABILITY_PACKAGE_CANDIDATE" skills README.md PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md docs 기획서 evidence tests`

Expected: Candidate 001 appears only as historical/superseded; the old mint action has no active consumer.

- [x] **Step 3: Run candidate launcher contract without download/launch**

Run: `powershell -ExecutionPolicy Bypass -File .\RUN_SX60_POC_SELF_RUN.ps1 -ContractCheck`

Expected: `POST_SX_DEC_060_CANDIDATE_CONTRACT: PASS - SX60-POC-ACCEPT-002`.

### Task 4: Verify, review, publish, and synchronize

**Files:**
- Modify: `docs/superpowers/plans/2026-08-27-sx60-exact-candidate-mint.md` checkboxes only if needed to record actual completion.

**Interfaces:**
- Consumes: exact branch head and Task 1–3 evidence.
- Produces: PR #206 follow-up with exact-head CI, merged main, and Notion Home/Direction/Production/Visual readback.

- [x] **Step 1: Run full local regression**

Run: `python tools/validate_project_contract.py; python -m unittest discover -s tests/python -p 'test_*.py' -v; godot --headless --path . --script res://tests/run_tests.gd`

Expected: zero task-related failures; document unavailable Godot binary rather than inferring a pass.

- [x] **Step 2: Run five adversarial review loops**

Check source ancestry, artifact/hash mismatch, evidence-ceiling inflation, stale candidate consumers, and protected-scope leakage. Fix verified findings and rerun affected regressions.

- [ ] **Step 3: Create a PR and verify exact-head CI**

Use fresh main/PR preflight; leave PR #174 untouched. Merge only if exact head, required checks, and review state are clean.

- [ ] **Step 4: Post-merge readback and Notion synchronization**

Fetch new `main`, verify the pointer/artifact on GitHub, then update and fetch Notion Home, Direction, Production, and Visual. Do not call any physical/device/human gate `PASS`.
