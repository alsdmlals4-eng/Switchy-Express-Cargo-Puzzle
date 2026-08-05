# Android Device Smoke Canonical Freshness Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Restore all active project entrypoints, registries, and the project Skill to the finite-delivery authority, add a fail-closed Android real-device smoke runbook tied to the canonical APK hash, and prove the repair with RED→GREEN contract tests plus full regression checks.

**Architecture:** Add one focused Python contract test that treats active project consumers as a single canonical-freshness surface. Make the smallest edits to the seven stale active consumers, preserve all VS03-era files as historical evidence, and add one Android device-smoke runbook with an evidence template. Product code, APK bytes, export workflow, default entrypoint, game rules, and Google Sheet remain unchanged.

**Tech Stack:** Markdown, JSON, Python 3 contract tests, Godot 4.7.1 headless tests, GitHub Actions.

## Global Constraints

- Repository: `alsdmlals4-eng/Switchy-Express-Cargo-Puzzle`.
- Baseline main: `6cdbda34da61de7b5175ad08d7aaffaf186a0dcf`.
- Product authority: `GMB-002`, `SX-DEC-027` through `SX-DEC-036`.
- Current audit/evidence: `SX-AUD-019`, `EV-FP-APK-001`.
- Canonical APK source commit: `536911449018a3caf3511bc64e7bf1a66edf2016`.
- Canonical APK SHA-256: `eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea`.
- Canonical APK size: `28771631` bytes.
- Current gate: `ANDROID_DEVICE_SMOKE`.
- `FIVE_PERSON_COMPREHENSION` remains `NOT_RUN` until Android passes with the same APK hash.
- Default entrypoint remains legacy; production cutover remains blocked.
- Correct Google Sheet ID: `1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo`.
- Never modify the legacy/wrong `19Ff...` Sheet.
- Preserve historical VS03/fuel/BOOST/capacity-eight documents; only remove their active authority.
- Do not modify PR #74-owned files unless a fresh conflict review proves it unavoidable.
- Do not claim Android PASS without physical-device evidence.

---

## File Structure

**Create**

- `tests/python/test_android_smoke_canonical_freshness_contract.py` — focused active-consumer and runbook contract.
- `기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_RUNBOOK.md` — same-APK physical-device procedure and evidence template.

**Modify**

- `기획서/00_프로젝트_허브/START_HERE.md` — first-entry current state and reading order.
- `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md` — current execution package and next gate.
- `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md` — authoritative gate chain.
- `기획서/00_프로젝트_허브/DOCUMENTATION_MAP.md` — current-owner routing and historical classification.
- `기획서/00_프로젝트_허브/DESIGN_DOCUMENT_REGISTRY.json` — status/authority metadata.
- `skills/switchy-express-design/SKILL.md` — finite product authority and validation triggers.
- `skills/SKILL_REGISTRY.json` — project Skill triggers/output contract.

**Must remain byte-identical in this package**

- `project.godot` and production `run/main_scene` value.
- `game/main/main.tscn`.
- Android export workflow and export presets.
- Product scripts, scenes, assets, APK artifacts, and Google Sheet.

---

### Task 1: Add the focused canonical-freshness contract in RED

**Files:**
- Create: `tests/python/test_android_smoke_canonical_freshness_contract.py`

**Interfaces:**
- Consumes: repository-relative UTF-8 text and JSON files.
- Produces: pytest tests that fail on stale active authority and pass after Tasks 2–5.

- [ ] **Step 1: Create shared readers and constants**

```python
from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
HUB = ROOT / "기획서" / "00_프로젝트_허브"
RUNBOOK = ROOT / "기획서" / "50_제작_검증" / "ANDROID_DEVICE_SMOKE_RUNBOOK.md"
SKILL = ROOT / "skills" / "switchy-express-design" / "SKILL.md"
SKILL_REGISTRY = ROOT / "skills" / "SKILL_REGISTRY.json"
APK_SHA256 = "eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea"


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def read_json(path: Path) -> object:
    return json.loads(read_text(path))
```

- [ ] **Step 2: Add active-entrypoint assertions**

```python
def test_active_project_hub_points_to_android_smoke() -> None:
    combined = "\n".join(
        read_text(HUB / name)
        for name in ("START_HERE.md", "ACTIVE_CONTEXT.md", "DEVELOPMENT_GATES.md")
    )
    for required in ("SX-AUD-019", "EV-FP-APK-001", "ANDROID_DEVICE_SMOKE"):
        assert required in combined
    assert "FIVE-PERSON COMPREHENSION: NOT_RUN" in combined
    assert "PRODUCTION CUTOVER: BLOCKED" in combined
```

- [ ] **Step 3: Add stale-current-authority rejection**

```python
def test_active_consumers_do_not_restore_legacy_product_authority() -> None:
    active = "\n".join(
        [
            read_text(HUB / "START_HERE.md"),
            read_text(HUB / "ACTIVE_CONTEXT.md"),
            read_text(HUB / "DEVELOPMENT_GATES.md"),
            read_text(HUB / "DOCUMENTATION_MAP.md"),
            read_text(SKILL),
        ]
    ).lower()
    forbidden_current_phrases = (
        "vs03-03 is current",
        "current package: vs03-03",
        "fuel is the current core",
        "boost is the current core",
        "capacity eight is current",
    )
    for phrase in forbidden_current_phrases:
        assert phrase not in active
```

- [ ] **Step 4: Add Registry and Skill assertions**

```python
def test_registries_route_to_finite_android_validation_authority() -> None:
    design_registry = read_json(HUB / "DESIGN_DOCUMENT_REGISTRY.json")
    skill_registry = read_json(SKILL_REGISTRY)
    serialized = json.dumps(
        {"design": design_registry, "skills": skill_registry},
        ensure_ascii=False,
        sort_keys=True,
    )
    for required in (
        "FINITE_DELIVERY_PUZZLE_BASELINE",
        "ANDROID_DEVICE_SMOKE",
        "SX-AUD-019",
    ):
        assert required in serialized


def test_project_skill_describes_finite_delivery_core() -> None:
    text = read_text(SKILL).lower()
    for required in (
        "manual",
        "automatic loading",
        "unlimited lifo stack",
        "finite-time completion",
        "android device smoke",
    ):
        assert required in text
```

- [ ] **Step 5: Add runbook fail-closed assertions**

```python
def test_android_smoke_runbook_is_same_hash_and_fail_closed() -> None:
    text = read_text(RUNBOOK)
    for required in (
        APK_SHA256,
        "PASS | FAIL | BLOCKED | NOT_RUN",
        "BLOCKED_HASH_MISMATCH",
        "PROOF",
        "STACK 8",
        "STACK 16",
        "STACK 32",
        "crash",
        "ANR",
        "48dp",
        "safe area",
        "tester_alias",
        "device_alias",
    ):
        assert required in text
```

- [ ] **Step 6: Run the focused test and verify RED**

Run:

```bash
python -m pytest tests/python/test_android_smoke_canonical_freshness_contract.py -q
```

Expected: FAIL because the runbook does not exist and active consumers still expose stale authority.

- [ ] **Step 7: Commit the RED contract**

```bash
git add tests/python/test_android_smoke_canonical_freshness_contract.py
git commit -m "test: define Android smoke canonical freshness contract"
```

---

### Task 2: Repair the active project hub

**Files:**
- Modify: `기획서/00_프로젝트_허브/START_HERE.md`
- Modify: `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
- Modify: `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md`

**Interfaces:**
- Consumes: `CURRENT_CONFIRMED_DECISIONS.md`, `FINITE_DELIVERY_PUZZLE_BASELINE.md`, and `SX_AUD_019_ANDROID_APK_PIPELINE_PROBE.md`.
- Produces: one consistent current-state block and one current gate chain.

- [ ] **Step 1: Replace START_HERE current status with the exact block**

```text
FINITE AUTOMATED CORE: PASS
VALIDATION PREPARATION: PASS
ON-DEVICE SELECTOR: PASS
CANONICAL MAIN APK EXPORT: PASS
ANDROID DEVICE SMOKE: NOT_RUN · CURRENT
FIVE-PERSON COMPREHENSION: NOT_RUN
DEFAULT ENTRYPOINT: LEGACY
PRODUCTION CUTOVER: BLOCKED
```

- [ ] **Step 2: Set START_HERE reading order**

Use this order:

```text
FINITE_DELIVERY_PUZZLE_BASELINE.md
CURRENT_CONFIRMED_DECISIONS.md
SX_AUD_019_ANDROID_APK_PIPELINE_PROBE.md
ANDROID_DEVICE_SMOKE_RUNBOOK.md
VERTICAL_SLICE_CONTRACT.md
ROADMAP.md
```

- [ ] **Step 3: Rewrite ACTIVE_CONTEXT current execution package**

Use this gate statement verbatim:

```text
Current execution: verify the canonical validation APK on a physical Android landscape device using ANDROID_DEVICE_SMOKE_RUNBOOK.md. Do not create a replacement APK, change the default entrypoint, or begin five-person comprehension before this gate passes on the same SHA-256.
```

Keep VS03 references only in a clearly labeled `Historical context` section.

- [ ] **Step 4: Rewrite DEVELOPMENT_GATES current chain**

```text
AUTOMATED CORE PASS
→ VALIDATION PREPARATION PASS
→ CANONICAL APK EXPORT PASS
→ ANDROID DEVICE SMOKE CURRENT
→ FIVE-PERSON COMPREHENSION BLOCKED_BY_ANDROID
→ PRODUCTION CUTOVER BLOCKED
```

- [ ] **Step 5: Run focused tests**

```bash
python -m pytest tests/python/test_android_smoke_canonical_freshness_contract.py -q
```

Expected: remaining failures are limited to Registry, Skill, or missing runbook assertions.

- [ ] **Step 6: Commit the project-hub repair**

```bash
git add \
  기획서/00_프로젝트_허브/START_HERE.md \
  기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md \
  기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md
git commit -m "docs: restore current Android validation gate"
```

---

### Task 3: Repair Documentation Map and design Registry routing

**Files:**
- Modify: `기획서/00_프로젝트_허브/DOCUMENTATION_MAP.md`
- Modify: `기획서/00_프로젝트_허브/DESIGN_DOCUMENT_REGISTRY.json`

**Interfaces:**
- Consumes: exact current-owner paths from Task 2 and the new runbook path from Task 5.
- Produces: one current owner per active question; historical status for superseded VS03 material.

- [ ] **Step 1: Define current owners in DOCUMENTATION_MAP**

Route these questions exactly:

```text
current product and gate → START_HERE.md
current execution and next action → ACTIVE_CONTEXT.md
approved decisions → CURRENT_CONFIRMED_DECISIONS.md
finite product baseline → FINITE_DELIVERY_PUZZLE_BASELINE.md
canonical APK evidence → SX_AUD_019_ANDROID_APK_PIPELINE_PROBE.md
Android physical-device execution → ANDROID_DEVICE_SMOKE_RUNBOOK.md
quality and cutover boundary → VERTICAL_SLICE_CONTRACT.md
```

- [ ] **Step 2: Mark superseded materials as historical**

Use explicit labels such as `HISTORICAL`, `SUPERSEDED`, or `LEGACY_IMPLEMENTATION`. Do not delete the files or their links.

- [ ] **Step 3: Update DESIGN_DOCUMENT_REGISTRY.json**

For current entries, set status/role metadata so serialized JSON includes:

```json
{
  "current_gate": "ANDROID_DEVICE_SMOKE",
  "current_audit": "SX-AUD-019",
  "product_baseline": "FINITE_DELIVERY_PUZZLE_BASELINE"
}
```

Preserve valid existing schema and ordering conventions; do not invent a parallel Registry format.

- [ ] **Step 4: Validate JSON syntax**

```bash
python -m json.tool 기획서/00_프로젝트_허브/DESIGN_DOCUMENT_REGISTRY.json > /dev/null
```

Expected: exit code 0.

- [ ] **Step 5: Run focused tests**

```bash
python -m pytest tests/python/test_android_smoke_canonical_freshness_contract.py -q
```

Expected: failures remain only for project Skill/Skill Registry or missing runbook.

- [ ] **Step 6: Commit routing repair**

```bash
git add \
  기획서/00_프로젝트_허브/DOCUMENTATION_MAP.md \
  기획서/00_프로젝트_허브/DESIGN_DOCUMENT_REGISTRY.json
git commit -m "docs: reroute current finite design authority"
```

---

### Task 4: Repair the project Skill and Skill Registry

**Files:**
- Modify: `skills/switchy-express-design/SKILL.md`
- Modify: `skills/SKILL_REGISTRY.json`

**Interfaces:**
- Consumes: current product baseline and gate names.
- Produces: finite-product routing that cannot reactivate fuel/BOOST/capacity-eight as current authority.

- [ ] **Step 1: Replace the project Skill core model**

Use this sequence as the active core:

```text
track construction
→ cargo encounter order
→ manual/automatic loading
→ unlimited LIFO stack
→ route and persistent branch execution
→ TOP contiguous-group unloading
→ finite-time completion
→ time/cost/score redesign
```

- [ ] **Step 2: Add positive routing triggers**

Include:

```text
finite delivery puzzle
Android device smoke
five-person comprehension
canonical APK hash
manual loading
automatic loading
unlimited LIFO stack
TOP unloading
production cutover boundary
```

- [ ] **Step 3: Demote legacy mechanics**

Describe fuel, player BOOST, capacity eight, cargo-count slowdown, endless survival, pickup respawn, and VS03-03 only under a `LEGACY_IMPLEMENTATION` or historical section. Do not present them as current constraints.

- [ ] **Step 4: Update SKILL_REGISTRY.json**

Keep the existing Registry schema. Update only the `switchy-express-design` entry triggers, description, outputs, and authority references.

- [ ] **Step 5: Validate JSON syntax**

```bash
python -m json.tool skills/SKILL_REGISTRY.json > /dev/null
```

Expected: exit code 0.

- [ ] **Step 6: Run focused tests**

```bash
python -m pytest tests/python/test_android_smoke_canonical_freshness_contract.py -q
```

Expected: only missing-runbook assertions may still fail.

- [ ] **Step 7: Commit Skill repair**

```bash
git add skills/switchy-express-design/SKILL.md skills/SKILL_REGISTRY.json
git commit -m "docs: align Switchy Express skill with finite authority"
```

---

### Task 5: Add the Android physical-device smoke runbook

**Files:**
- Create: `기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_RUNBOOK.md`

**Interfaces:**
- Consumes: exact APK source/hash/size and validation modes.
- Produces: a physical-device checklist and evidence record that can later support the Android audit closure.

- [ ] **Step 1: Add frozen artifact identity**

```yaml
source_commit: 536911449018a3caf3511bc64e7bf1a66edf2016
apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
apk_size_bytes: 28771631
package: com.alsdmlals4.switchyexpress.validation
orientation: landscape
```

State that a hash mismatch is `BLOCKED_HASH_MISMATCH` and no prior evidence transfers to a replacement APK.

- [ ] **Step 2: Add preflight fields**

```yaml
device_alias:
device_model:
android_version:
resolution_density:
input_method:
tester_alias:
executed_at:
```

Prohibit account names, notifications, contacts, phone numbers, advertising IDs, serial numbers, IMEI, and other unique device identifiers.

- [ ] **Step 3: Add selector and lifecycle matrix**

Require all of:

```text
install
first boot
full exit and reboot
PROOF
STACK 8
STACK 16
STACK 32
Back navigation
```

- [ ] **Step 4: Add gameplay matrix**

Require BUILD place/rotate/replace/remove/clear, preflight error identification, BUILD→RUN, pause/resume, success/failure, retry/edit, LOAD hold, auto-load, branch direct tap, occupied switch lock, pause integrity, failed-run layout preservation, and fresh-runtime retry.

- [ ] **Step 5: Add presentation/stability matrix**

Require rear/TOP readability for 8/16/32, 48dp-equivalent touch targets, safe area, clipping/overlap/touch omission checks, crash, ANR, script-error, and severe frame-degradation review.

- [ ] **Step 6: Add exact result enum and overall rule**

```text
PASS | FAIL | BLOCKED | NOT_RUN
```

State that any required `FAIL`, `BLOCKED`, or `NOT_RUN` prevents overall PASS.

- [ ] **Step 7: Add evidence record**

```yaml
apk_sha256:
source_commit:
device_alias:
device_model:
android_version:
resolution_density:
orientation:
input_method:
executed_at:
tester_alias:
item_results:
recording_references:
screenshot_references:
crash_anr_log_reference:
observations:
overall_gate: PASS | FAIL | BLOCKED | NOT_RUN
```

- [ ] **Step 8: Run focused tests and verify GREEN**

```bash
python -m pytest tests/python/test_android_smoke_canonical_freshness_contract.py -q
```

Expected: PASS.

- [ ] **Step 9: Commit the runbook**

```bash
git add 기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_RUNBOOK.md
git commit -m "docs: add fail-closed Android device smoke runbook"
```

---

### Task 6: Run full regression and adversarial freshness review

**Files:**
- Review all files changed in Tasks 1–5.
- Do not modify product files unless a failing pre-existing contract proves the plan itself is incomplete; stop and report before expanding scope.

**Interfaces:**
- Consumes: completed repair package.
- Produces: fresh CI evidence and an adversarial review record in the PR conversation.

- [ ] **Step 1: Run focused Python contract**

```bash
python -m pytest tests/python/test_android_smoke_canonical_freshness_contract.py -q
```

Expected: PASS.

- [ ] **Step 2: Run all Python project-contract tests**

```bash
python -m pytest tests/python -q
```

Expected: PASS with zero failures.

- [ ] **Step 3: Validate both JSON registries**

```bash
python -m json.tool 기획서/00_프로젝트_허브/DESIGN_DOCUMENT_REGISTRY.json > /dev/null
python -m json.tool skills/SKILL_REGISTRY.json > /dev/null
```

Expected: both exit 0.

- [ ] **Step 4: Run the full Godot suite**

Use the repository workflow-equivalent command:

```bash
timeout 30s ./Godot_v4.7.1-stable_linux.x86_64 \
  --headless \
  --path . \
  --script res://tests/run_tests.gd
```

Expected: `failed=0`; record exact case and assertion counts rather than assuming the prior `65/10792` count remains unchanged.

- [ ] **Step 5: Check immutable product paths**

```bash
git diff --name-only 6cdbda34da61de7b5175ad08d7aaffaf186a0dcf...HEAD
```

Expected changed paths are limited to the two new files, seven active consumers, the approved design, and this plan. No Godot scene/script, workflow, export preset, asset, or Sheet integration file appears.

- [ ] **Step 6: Run active-authority search**

```bash
grep -RniE "VS03-03|fuel|BOOST|capacity eight|capacity-eight" \
  기획서/00_프로젝트_허브 \
  skills/switchy-express-design/SKILL.md \
  skills/SKILL_REGISTRY.json
```

Expected: remaining matches are explicitly historical/legacy, not current authority.

- [ ] **Step 7: Perform adversarial review**

Attack these failure modes:

```text
stale current owner remains
history was accidentally deleted or rewritten
APK hash is partial or inconsistent
runbook allows partial PASS
emulator can be mistaken for physical-device evidence
Android PASS can be mistaken for production cutover
wrong Google Sheet can be selected
PR #74-owned file was modified
current status was advanced without device evidence
```

Classify each finding as `VALID`, `INVALID`, or `NEEDS_EVIDENCE`; fix only approved valid findings, then rerun Steps 1–6.

- [ ] **Step 8: Commit adversarial corrections if any**

```bash
git add <only-approved-correction-paths>
git commit -m "docs: close canonical freshness review findings"
```

Skip this commit when no corrections are required.

- [ ] **Step 9: Push and update Draft PR #77**

Include:

```text
RED evidence
GREEN focused-test evidence
full Python contract result
full Godot case/assertion result
JSON validation result
immutable-product-path diff result
adversarial findings and dispositions
Android Device Smoke remains NOT_RUN
Google Sheet remains unchanged
```

---

### Task 7: Merge the documentation package without advancing the Android gate

**Files:**
- PR #77 metadata and review conversation only.

**Interfaces:**
- Consumes: passing checks and closed adversarial findings.
- Produces: merged canonical repair on `main`; no Android audit closure.

- [ ] **Step 1: Verify PR review state**

Required:

```text
unresolved review threads: 0
REQUEST_CHANGES reviews: 0
required checks: success
mergeable against latest main
```

- [ ] **Step 2: Recheck PR #74 concurrency**

Confirm none of these changed in PR #77:

```text
AGENTS.md
.github/workflows/platform-release-asset-rights.yml
docs/PLATFORM_RELEASE_AND_ASSET_RIGHTS_PROFILE.md
docs/ASSET_RIGHTS_AND_PROVENANCE_RECORD.md
docs/GAME_RELEASE_COMPLIANCE_EVIDENCE_PACK.md
tests/python/test_platform_release_asset_rights_contract.py
```

- [ ] **Step 3: Merge PR #77**

Use the repository's established merge policy. Record the merge commit SHA.

- [ ] **Step 4: Read back merged main**

Verify on `main`:

```text
START_HERE current block
ACTIVE_CONTEXT current execution
DEVELOPMENT_GATES chain
runbook full APK hash
project Skill finite authority
both Registry current routing
```

- [ ] **Step 5: Report the exact remaining gate**

```text
ANDROID DEVICE SMOKE: NOT_RUN · CURRENT
FIVE-PERSON COMPREHENSION: NOT_RUN
DEFAULT ENTRYPOINT: LEGACY
PRODUCTION CUTOVER: BLOCKED
```

Do not update Google Sheet in this package because no new device PASS or audit/evidence ID exists.

---

## Post-Merge Physical-Device Handoff

The next package begins only when the user supplies a completed runbook record and evidence from a physical Android landscape device using the exact APK SHA-256. That later package will verify evidence completeness/privacy, run adversarial review, assign the final Android audit/evidence IDs, update GitHub canon and the correct Google Sheet with the same IDs, and read both back. It must not reuse or modify the `19Ff...` Sheet.
