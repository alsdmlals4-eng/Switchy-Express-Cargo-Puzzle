# Windows ANGLE Renderer Compatibility Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ensure the Windows Compatibility build defaults to the proven visible ANGLE rendering path while preserving a native fallback and all game behavior.

**Architecture:** Godot resolves the Compatibility driver per platform at startup. A Windows-only project setting selects `opengl3_angle`; the Windows export preset explicitly carries ANGLE libraries; a small Python contract prevents either half of the delivery contract from drifting. Existing scenes and game systems are unchanged.

**Tech Stack:** Godot 4.7.1-stable, Windows export preset, Python 3.12 / pytest, GDScript GUT regression suite, GitHub Actions Windows Demo Export.

**Spec:** `docs/superpowers/specs/2026-08-29-windows-angle-renderer-compatibility-design.md`

## Global Constraints

- Restrict the rendering preference to `Windows`; Android remains on its existing native Compatibility driver.
- Do not modify finite rules, maps, scenes, UI composition, assets, audio content, Base, or PR #174.
- Begin with a failing test and keep the exact Candidate 004 as historical evidence until a new candidate is recorded.
- Do not promote Windows physical/audio, Android device, five-person, player-experience, or release status without its own observation.

---

## File structure

| File | Responsibility |
| --- | --- |
| `tests/python/test_windows_angle_rendering_contract.py` | Locks the Windows-only driver, native fallback, and exporter library contract. |
| `project.godot` | Selects the Windows Compatibility driver at project startup. |
| `export_presets.cfg` | Includes ANGLE libraries in the Windows Demo delivery. |
| `docs/decisions/SX_DEC_065_WINDOWS_ANGLE_RENDERER_COMPATIBILITY.md` | Records decision, observed defect, scope, and evidence ceiling. |
| Project hub/current-candidate evidence files | Bind the eventual replacement candidate and keep Candidate 004 historical. |

### Task 1: Add the failing Windows rendering-delivery contract

**Files:**
- Create: `tests/python/test_windows_angle_rendering_contract.py`
- Read: `project.godot`, `export_presets.cfg`, `tests/python/test_windows_demo_export_contract.py`

**Interfaces:**
- Consumes UTF-8 project and preset text.
- Produces two pytest assertions that name the supported Godot configuration values.

- [ ] **Step 1: Write the failing test**

```python
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
PROJECT = ROOT / "project.godot"
PRESETS = ROOT / "export_presets.cfg"


def test_windows_compatibility_prefers_angle_with_native_fallback() -> None:
    text = PROJECT.read_text(encoding="utf-8")
    assert 'gl_compatibility/driver.windows="opengl3_angle"' in text
    assert "gl_compatibility/fallback_to_native=true" in text


def test_windows_demo_exports_angle_runtime() -> None:
    text = PRESETS.read_text(encoding="utf-8")
    assert "application/export_angle=1" in text
```

- [ ] **Step 2: Run test to verify it fails**

Run: `python -m pytest tests/python/test_windows_angle_rendering_contract.py -q`  
Expected: FAIL because the current project has no Windows-specific driver/fallback setting and uses `application/export_angle=0`.

- [ ] **Step 3: Commit test-only red state**

```text
git add tests/python/test_windows_angle_rendering_contract.py
git commit -m "test: define Windows ANGLE export contract"
```

### Task 2: Apply the minimum platform-scoped settings

**Files:**
- Modify: `project.godot` under `[rendering]`
- Modify: `export_presets.cfg` in `[preset.1.options]` (`Windows Demo`)
- Test: `tests/python/test_windows_angle_rendering_contract.py`

**Interfaces:**
- Reads `gl_compatibility/driver.windows` at Windows startup.
- Reads `application/export_angle` when creating the Windows Demo artifact.

- [ ] **Step 1: Add Windows driver preference and fallback**

```ini
[rendering]
renderer/rendering_method="gl_compatibility"
renderer/rendering_method.mobile="gl_compatibility"
gl_compatibility/driver.windows="opengl3_angle"
gl_compatibility/fallback_to_native=true
```

- [ ] **Step 2: Require ANGLE runtime libraries in the Windows Demo preset**

```ini
[preset.1.options]
application/export_angle=1
```

- [ ] **Step 3: Run the focused test to verify it passes**

Run: `python -m pytest tests/python/test_windows_angle_rendering_contract.py -q`  
Expected: `2 passed`.

- [ ] **Step 4: Run compatible automated regression**

Run: `python tools/validate_project_contract.py` and `python -m pytest tests/python -q`  
Expected: both exit zero; do not describe a physical run as covered by these commands.

- [ ] **Step 5: Commit the implementation**

```text
git add project.godot export_presets.cfg tests/python/test_windows_angle_rendering_contract.py
git commit -m "fix: prefer ANGLE for Windows compatibility rendering"
```

### Task 3: Record the technical decision and validate pre-merge readiness

**Files:**
- Create: `docs/decisions/SX_DEC_065_WINDOWS_ANGLE_RENDERER_COMPATIBILITY.md`
- Modify: `docs/superpowers/specs/2026-08-29-windows-angle-renderer-compatibility-design.md`, `docs/superpowers/plans/2026-08-29-windows-angle-renderer-compatibility.md`

**Interfaces:**
- The decision record consumes Candidate 004's exact reproduction and produces a bounded change contract for CI and the post-merge candidate task.

- [ ] **Step 1: Write the `SX-DEC-065` decision record before merging**

Include the exact Candidate 004 reproduction, native-versus-ANGLE observation, Windows-only scope, official Godot setting behavior, exclusions, and open evidence fields. State that the result is a compatibility correction, not a gameplay or visual-direction decision.

- [ ] **Step 2: Run the local checks that are independent of the future artifact**

Run: the current project contract, full Python suite, and local Godot regression runner.
Expected: all local checks pass; no command is represented as a Windows physical/audio result.

- [ ] **Step 3: Commit the decision record with its reviewed implementation contract**

```text
git add docs/decisions/SX_DEC_065_WINDOWS_ANGLE_RENDERER_COMPATIBILITY.md docs/superpowers/specs/2026-08-29-windows-angle-renderer-compatibility-design.md docs/superpowers/plans/2026-08-29-windows-angle-renderer-compatibility.md
git commit -m "docs: record Windows ANGLE compatibility decision"
```

### Task 4: Obtain and verify the replacement package candidate

**Files:**
- Modify after CI artifact exists: `evidence/acceptance/post_sx_dec_060_candidate.json`, `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`, `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`, `기획서/00_프로젝트_허브/ROADMAP.md`, `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md`, `기획서/00_프로젝트_허브/DOCUMENTATION_MAP.md`
- Create after CI artifact exists: `evidence/acceptance/sx60_poc_accept_005_artifact.json`, `evidence/acceptance/sx60_poc_accept_005_pck_deep_audit.json`, `기획서/50_제작_검증/SX_DEC_060_POC_ACCEPTANCE_CANDIDATE_05.md`

**Interfaces:**
- Candidate pointer can advance only when source SHA, artifact identity, EXE/PCK hashes, and package audit agree.
- Candidate 004 remains immutable historical prior-byte evidence once source bytes change.

- [ ] **Step 1: Run CI through a pull request before candidate minting**

Run: open a PR for Issue #253 and require the current Python, Godot, and Windows Demo Export checks.  
Expected: every required check is green on the implementation head; CI package evidence is not a physical PASS.

- [ ] **Step 2: Mint Candidate 005 only from the merged source**

Use the repository's candidate-mint procedure to record the source main SHA, Actions artifact ID/name/expiry, independent ZIP/EXE/PCK SHA-256 values, and deep PCK audit. Do not reuse Candidate 004 hashes or the `--rendering-driver` diagnostic command as replacement-candidate evidence.

- [ ] **Step 3: Recheck the replacement candidate with default launch**

Run: `RUN_SX60_POC_SELF_RUN.ps1 -ContractCheck`, then launch with no renderer argument.  
Expected: Title → Briefing → BUILD renders visibly on the same Windows host. Record audio only from actual perception; preserve Android/five-person/player-experience gates.

- [ ] **Step 4: Commit the candidate evidence separately**

```text
git add docs/decisions/SX_DEC_065_WINDOWS_ANGLE_RENDERER_COMPATIBILITY.md docs/superpowers/specs/2026-08-29-windows-angle-renderer-compatibility-design.md docs/superpowers/plans/2026-08-29-windows-angle-renderer-compatibility.md
git commit -m "docs: record Windows ANGLE compatibility decision"

git add evidence/acceptance 기획서/00_프로젝트_허브 기획서/50_제작_검증
git commit -m "docs: mint Windows renderer compatibility candidate"
```

## Self-review

- **Spec coverage:** Task 1 locks the settings contract; Task 2 makes the minimal Windows-only delivery change; Task 3 records the decision and validates the branch; Task 4 creates the exact package and restores the physical-validation chain only after the merged source exists. No game/content scope is unowned.
- **Placeholder scan:** No undecided implementation value remains: the driver is `opengl3_angle`, native fallback is `true`, and ANGLE export is `1`.
- **Type consistency:** The test reads literal Godot project/preset string values only; no new runtime API or GDScript type is introduced.

## Execution handoff

Plan complete and saved to `docs/superpowers/plans/2026-08-29-windows-angle-renderer-compatibility.md`.

1. **Subagent-Driven (recommended):** fresh agent per task with review between tasks.
2. **Inline Execution:** execute tasks in this session using `superpowers:executing-plans`, with checkpoints.

The user already instructed continued work and approved required actions, so proceed with inline execution unless they redirect the task.
