# Hera Repo Adoption + CI Recovery Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Preserve the user's tracked/enabled Hera v1.0.0 adoption while restoring clean-clone headless CI and reconciling SX-DEC-052/Pilot authority.

**Architecture:** Treat current main `0a2bfc0f...` as the user-work-preserving baseline. Phase 1 adds one isolated Hera headless compatibility patch, normalizes the Hera autoload path, updates local-tooling authority, and refreshes the Pilot source baseline. Phase 2 separately updates only the existing four-file Pilot adoption surface so its strict PR-scope guard remains intact.

**Tech Stack:** Godot 4.7.1 GDScript EditorPlugin, Python 3.12/pytest, GitHub Actions, JSON/Markdown authority files, Google Sheets.

## Global Constraints

- Baseline project main: `0a2bfc0f11e77ddaa09c5c45a83599c745375789`.
- Base main: `2a6ced23f6d6de1fb6e0a281c7138beb03f1a13b`.
- User Hera adoption commit: `614fbdce2b1517b8ef34eadb156bf058ecf59b1d`.
- Official Hera v1.0.0 tag commit: `10f245ddae9e7a5d569150302acbde0d78f2aa03`.
- Official/project pre-patch Hera addon tree: `6cb87ac8ba768de1d924447f385fba6d80bcde68` (exact parity).
- Hera stays repo-tracked and enabled; do not revert the user's adoption.
- Only `addons/hera_agent_godot/hera_agent_plugin.gd` may diverge from the upstream Hera addon in Phase 1, and only for the documented headless early-return compatibility patch.
- `HeraGameInspector` committed autoload uses a direct `res://addons/hera_agent_godot/runtime/game_inspector.gd` path after recovery.
- Do not mutate gameplay, Scene, Resource, Theme, Animation, signals, production-candidate assets, or `.asset-vault` bytes.
- Existing 14 tracked `.asset-vault` files remain preserved; untrack stays `DEFERRED_EXTERNAL_EXECUTOR` until local hash-preservation attestation.
- Runtime/POC, physical Windows/Android/editor, human validation, and final product-asset approval remain unclaimed.
- PR #118 is superseded/closed; its SX-AUD-038 closure facts must be carried into the final recovery branch.

---

### Task 1: Add deterministic Hera adoption recovery contract (RED)

**Files:**
- Create: `tests/python/test_hera_repo_adoption_reconciliation.py`
- Modify: `tests/python/test_local_tooling_reconciliation.py`

**Interfaces:**
- Consumes: current Hera v1.0.0 vendor, `project.godot`, `docs/tooling/local_godot_tooling_state.json`.
- Produces: deterministic contract for repo tracking, clean-clone autoload, headless guard, and same-ID authority.

- [ ] **Step 1: Create focused test with these exact assertions**

```python
from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
HERA_PLUGIN = ROOT / "addons/hera_agent_godot/hera_agent_plugin.gd"
HERA_CFG = ROOT / "addons/hera_agent_godot/plugin.cfg"
PROJECT = ROOT / "project.godot"
STATE = ROOT / "docs/tooling/local_godot_tooling_state.json"


def test_hera_v1_is_tracked_enabled_and_clean_clone_safe() -> None:
    cfg = HERA_CFG.read_text(encoding="utf-8")
    project = PROJECT.read_text(encoding="utf-8")
    assert 'version="1.0.0"' in cfg
    assert 'res://addons/hera_agent_godot/plugin.cfg' in project
    assert (
        'HeraGameInspector="*res://addons/hera_agent_godot/runtime/game_inspector.gd"'
        in project
    )
    assert 'HeraGameInspector="*uid://' not in project


def test_hera_server_is_inert_under_headless_display() -> None:
    source = HERA_PLUGIN.read_text(encoding="utf-8")
    enter = source.split("func _enter_tree() -> void:", 1)[1].split(
        "func _process(delta: float) -> void:", 1
    )[0]
    guard = 'DisplayServer.get_name() == "headless"'
    assert guard in enter
    assert enter.index(guard) < enter.index("_create_main_screen()")
    assert enter.index(guard) < enter.index("_ensure_game_autoload()")
    assert enter.index(guard) < enter.index("_server = HttpServer.new()")
    guard_tail = enter[enter.index(guard): enter.index("_create_main_screen()")]
    assert "return" in guard_tail


def test_same_id_state_records_user_adopted_upstream_base_and_patch() -> None:
    state = json.loads(STATE.read_text(encoding="utf-8"))
    hera = state["hera"]
    assert state["decision_id"] == "SX-DEC-052"
    assert hera["repo_tracked"] is True
    assert hera["repo_enabled"] is True
    assert hera["repo_version"] == "1.0.0"
    assert hera["upstream_tag"] == "v1.0.0"
    assert hera["upstream_commit"] == "10f245ddae9e7a5d569150302acbde0d78f2aa03"
    assert hera["upstream_addon_tree_sha"] == "6cb87ac8ba768de1d924447f385fba6d80bcde68"
    assert hera["user_adoption_commit"] == "614fbdce2b1517b8ef34eadb156bf058ecf59b1d"
    assert hera["project_compatibility_patches"] == [
        "addons/hera_agent_godot/hera_agent_plugin.gd:HEADLESS_EARLY_RETURN"
    ]
```

- [ ] **Step 2: Update existing local-tooling state assertions** from `repo_tracked == False` to the new tracked/enabled v1.0.0 authority fields, while keeping `local_version is None` / remote physical version unverified.
- [ ] **Step 3: Commit tests only** and open/refresh a Draft PR.
- [ ] **Step 4: Verify RED**. Expected focused failures: missing direct `res://` Hera autoload, missing headless early return, stale `repo_tracked=false` authority. Existing current-main CI failures remain historical integration RED evidence.

### Task 2: Implement minimal Hera headless compatibility and config normalization (GREEN)

**Files:**
- Modify: `addons/hera_agent_godot/hera_agent_plugin.gd`
- Modify: `project.godot`
- Modify: `docs/tooling/local_godot_tooling_state.json`

**Interfaces:**
- Consumes: Task 1 test contract and exact upstream v1.0.0 vendor baseline.
- Produces: GUI-enabled Hera + inert strict-headless Hera and clean-clone autoload path.

- [ ] **Step 1: Add this guard as the first executable branch in `_enter_tree()`**

```gdscript
func _enter_tree() -> void:
	if DisplayServer.get_name() == "headless":
		print("[hera] plugin disabled in headless mode")
		return
	set_process(true)
	_create_main_screen()
```

Do not change any other Hera behavior.

- [ ] **Step 2: Normalize the committed autoload**

Replace:

```ini
HeraGameInspector="*uid://c4ug7a211oav8"
```

with:

```ini
HeraGameInspector="*res://addons/hera_agent_godot/runtime/game_inspector.gd"
```

Keep all three editor plugins enabled.

- [ ] **Step 3: Update `local_godot_tooling_state.json` Hera object**

```json
{
  "identity": "NotNull92/hera-agent-godot",
  "stable_upstream_version": "1.0.0",
  "user_enabled_approved": true,
  "local_version": null,
  "repo_tracked": true,
  "repo_enabled": true,
  "repo_version": "1.0.0",
  "upstream_tag": "v1.0.0",
  "upstream_commit": "10f245ddae9e7a5d569150302acbde0d78f2aa03",
  "upstream_addon_tree_sha": "6cb87ac8ba768de1d924447f385fba6d80bcde68",
  "user_adoption_commit": "614fbdce2b1517b8ef34eadb156bf058ecf59b1d",
  "project_compatibility_patches": [
    "addons/hera_agent_godot/hera_agent_plugin.gd:HEADLESS_EARLY_RETURN"
  ],
  "status": "REPO_TRACKED_V1_0_0_USER_ADOPTED_HEADLESS_COMPAT_PATCHED"
}
```

- [ ] **Step 4: Run focused contract in CI**. Expected: new Hera test and existing local-tooling test PASS.
- [ ] **Step 5: Commit implementation.** Record this commit SHA as the `project.godot` baseline commit for Task 3.

### Task 3: Refresh Pilot source baseline without weakening adoption PR scope

**Files:**
- Modify: `tools/godot-live-editor-pilot/SOURCE_BASELINE.json`

**Interfaces:**
- Consumes: final Task 2 `project.godot` blob bytes and Task 2 commit SHA.
- Produces: Pilot materializer integrity baseline for the approved Hera-enabled project config.

- [ ] **Step 1: Fetch final `project.godot` blob SHA** from the Task 2 branch head.
- [ ] **Step 2: Compute SHA-256 of the exact UTF-8 file bytes.**
- [ ] **Step 3: Update only these fields**:

```json
{
  "baseline_commit": "<TASK_2_COMMIT_SHA>",
  "project_godot": {
    "path": "project.godot",
    "git_blob_sha": "<FINAL_PROJECT_GODOT_BLOB_SHA>",
    "raw_sha256": "<FINAL_PROJECT_GODOT_SHA256>"
  }
}
```

Target-scene baseline fields remain unchanged.

- [ ] **Step 4: Commit source baseline refresh.**
- [ ] **Step 5: Verify Project Contract no longer reports `SOURCE_BASELINE_MISMATCH:project_godot`.**

### Task 4: Reconcile SX-DEC-052 / audits with concurrent Hera adoption

**Files:**
- Modify: `docs/decisions/SX_DEC_052_LOCAL_TOOLING_ASSET_VAULT_RECONCILIATION.md`
- Create: `기획서/50_제작_검증/SX_AUD_039_CONCURRENT_HERA_REPO_ADOPTION_RECONCILIATION.md`
- Modify: `기획서/50_제작_검증/SX_AUD_038_VERTICAL_SLICE_BACKLOG_RECONCILIATION.md`

**Interfaces:**
- Consumes: Tasks 1-3 and PR #117 / Issue #3/#6/#7 final states.
- Produces: canonical same-ID authority before Phase 1 merge.

- [ ] **Step 1: Amend SX-DEC-052 history** to distinguish:
  - PR #115/#116 state: Hera user-approved but repo-untracked at that time;
  - later user adoption `614fbdce...` + merge main `0a2bfc0f...`;
  - exact upstream v1.0.0 tree parity;
  - bounded one-file headless compatibility patch;
  - `.asset-vault` gate unchanged.
- [ ] **Step 2: Write SX-AUD-039** with initial RED run IDs:
  - Contract `31284627677` FAILURE;
  - GUT `31284627676` FAILURE;
  - Godot `31284627671` FAILURE;
  - Pilot `31284627904` FAILURE;
  and exact root causes (stale baseline/plugin assumptions, clean-clone UID autoload, Hera strict-headless side effects).
- [ ] **Step 3: Carry SX-AUD-038 closure facts** from superseded PR #118: #6 `closed/not_planned`, #3/#7 open, PR #117 exact test-merge + merged-main evidence.
- [ ] **Step 4: Commit authority docs with status `PHASE1_FINAL_HEAD_RECHECK_REQUIRED`.**

### Task 5: Phase 1 exact-head verification and merge

**Files:**
- Verify the complete Phase 1 diff only.

**Interfaces:**
- Consumes: Phase 1 final head.
- Produces: merged Hera-compatible main suitable for adoption-surface Phase 2.

- [ ] **Step 1: Adversarial diff review** verifies:
  - user Hera vendor retained;
  - only `hera_agent_plugin.gd` diverges from upstream addon tree;
  - no gameplay/Scene/Resource/Theme/Animation/signal/candidate/vault byte mutation;
  - `project.godot` delta is only Hera autoload normalization relative to current user main.
- [ ] **Step 2: Exact PR test-merge checks** must pass:
  - Project Contract;
  - GUT 9.7.1 Tests;
  - Godot Tests;
  - Thin Adapter;
  - Windows Export/other automatically triggered required checks if present.
- [ ] **Step 3: Confirm GUT import output** contains `[hera] plugin disabled in headless mode` and no Hera-induced resource-leak `ERROR` lines.
- [ ] **Step 4: Confirm Godot tests** finish 92 cases / 11,494 assertions with zero failures and no invalid Hera autoload `ERROR`.
- [ ] **Step 5: Confirm zero review threads/comments/request-changes and no main drift.**
- [ ] **Step 6: Ready → squash merge with expected-head protection; read back merged main.**

### Task 6: Phase 2 Pilot adoption-surface RED/GREEN

**Files:**
- Modify: `.godot-live-editor/project-pilot.json`
- Modify: `tests/test_godot_live_editor_adoption.py`
- Modify if text is stale: `docs/GODOT_LIVE_EDITOR_ADOPTION.md`
- Workflow `.github/workflows/validate-godot-live-editor-pilot.yml` remains unchanged unless its documented assertions require text-only reconciliation.

**Interfaces:**
- Consumes: Phase 1 merged main with Hera tracked/enabled.
- Produces: Pilot temporary-copy configuration that disables all three editor plugins and both tooling autoloads.

- [ ] **Step 1: Create a new Phase 2 branch from exact Phase 1 merged main.**
- [ ] **Step 2: Update descriptor arrays**

```json
"legacy_editor_plugins": [
  "res://addons/godot_ai/plugin.cfg",
  "res://addons/gut/plugin.cfg",
  "res://addons/hera_agent_godot/plugin.cfg"
],
"legacy_autoloads": [
  "_mcp_game_helper",
  "HeraGameInspector"
]
```

- [ ] **Step 3: Update adoption test constants**

```python
LEGACY_EDITOR_PLUGINS = [
    "res://addons/godot_ai/plugin.cfg",
    "res://addons/gut/plugin.cfg",
    "res://addons/hera_agent_godot/plugin.cfg",
]
LEGACY_AUTOLOADS = ["_mcp_game_helper", "HeraGameInspector"]
```

Update the exact project plugin assertion to require all three tracked plugin paths without weakening the source-mutation/scope assertions.

- [ ] **Step 4: Keep `ALLOWED_PATHS` unchanged.** This Phase 2 PR must remain inside the existing four-file adoption surface.
- [ ] **Step 5: Update adoption documentation only if it explicitly says there are exactly two legacy plugins/one autoload.**
- [ ] **Step 6: Open Draft PR and verify dedicated Pilot workflow plus normal repository gates PASS on exact test-merge.**
- [ ] **Step 7: Ready → squash merge with expected-head protection; read back merged main.**

### Task 7: Final closure, post-merge regression, and Sheet sync

**Files:**
- Modify via docs-only closure only if final evidence changes authority text: `SX-DEC-052`, `SX-AUD-039`.
- Google Sheet: `00_프로젝트_허브`, `02_현재_확정결정`, `04_누락_충돌_감사`, `50_제작_검증`.

**Interfaces:**
- Consumes: final Phase 2 merged main and post-merge workflow results.
- Produces: GitHub/Sheet parity and zero stale tooling/backlog authority.

- [ ] **Step 1: Verify final main push** Project Contract, GUT, Godot Tests, and Live-Editor Pilot PASS.
- [ ] **Step 2: Verify open PR set is empty and open issue set remains exactly #3 and #7.**
- [ ] **Step 3: If Decision/Audit still says recheck pending, make a docs-only closure PR, exact-head verify, merge, and repeat final-main regression.**
- [ ] **Step 4: Update Sheet same-ID `SX-DEC-052`** from `HERA_USER_APPROVED_REPO_UNTRACKED` to repo-tracked v1.0.0 + compatibility-patched state.
- [ ] **Step 5: Append `SX-AUD-038` and `SX-AUD-039` audit rows** preserving historical chronology.
- [ ] **Step 6: Append `CURRENT-18` for backlog reconciliation and `CURRENT-19` for Hera adoption/CI recovery.**
- [ ] **Step 7: Update Hub final main/next action/deferred gates.** Do not remove `ASSET_VAULT_UNTRACK_DEFERRED_EXTERNAL_EXECUTOR`, runtime/POC/device/human/product-asset deferrals.
- [ ] **Step 8: Read back all written ranges and compare exact final main SHA, issue/PR sets, Hera authority, and deferred gates.
