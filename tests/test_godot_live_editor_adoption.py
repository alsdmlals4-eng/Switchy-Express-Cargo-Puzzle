from __future__ import annotations

import json
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
BASE_C0_SHA = "2b595570bd237174b2b962a1eb54588b5ecc508d"
GODOT_ARCHIVE_SHA256 = "c7ff14fd28472c8d4f193043de30278dcf7e5241a1dcf7566b02e27addaa33ba"
DESCRIPTOR = ROOT / ".godot-live-editor/project-pilot.json"
ADOPTION_DOC = ROOT / "docs/GODOT_LIVE_EDITOR_ADOPTION.md"
WORKFLOW = ROOT / ".github/workflows/validate-godot-live-editor-pilot.yml"
LEGACY_EDITOR_PLUGINS = [
    "res://addons/godot_ai/plugin.cfg",
    "res://addons/gut/plugin.cfg",
    "res://addons/hera_agent_godot/plugin.cfg",
]
LEGACY_AUTOLOADS = ["_mcp_game_helper", "HeraGameInspector"]
ALLOWED_PATHS = {
    ".godot-live-editor/project-pilot.json",
    "docs/GODOT_LIVE_EDITOR_ADOPTION.md",
    "tests/test_godot_live_editor_adoption.py",
    ".github/workflows/validate-godot-live-editor-pilot.yml",
}
PILOT_CONFIGURATION_PATHS = ALLOWED_PATHS - {
    "tests/test_godot_live_editor_adoption.py",
}


def _required_text(path: Path) -> str:
    assert path.is_file(), f"missing required adoption surface: {path.relative_to(ROOT)}"
    return path.read_text(encoding="utf-8")


def _changed_paths_from_main() -> set[str]:
    merge_base = subprocess.run(
        ["git", "merge-base", "HEAD", "origin/main"],
        cwd=ROOT,
        check=True,
        capture_output=True,
        text=True,
    ).stdout.strip()
    output = subprocess.run(
        ["git", "diff", "--name-only", f"{merge_base}..HEAD"],
        cwd=ROOT,
        check=True,
        capture_output=True,
        text=True,
    ).stdout
    return {line.strip() for line in output.splitlines() if line.strip()}


def _assert_pilot_change_surface(changed: set[str]) -> None:
    if changed & PILOT_CONFIGURATION_PATHS:
        assert changed <= ALLOWED_PATHS, (
            f"forbidden Pilot adoption changes: {sorted(changed - ALLOWED_PATHS)}"
        )


def test_descriptor_is_exact_current_project_contract() -> None:
    payload = json.loads(_required_text(DESCRIPTOR))

    assert payload == {
        "schema_version": "1",
        "project_identity": {
            "repository": "alsdmlals4-eng/Switchy-Express-Cargo-Puzzle",
            "project_id": "switchy-express-cargo-puzzle",
        },
        "base_pilot_commit": BASE_C0_SHA,
        "project_state": "EXISTING_GODOT_PROJECT",
        "godot": {
            "version": "4.7.1-stable",
            "archive_sha256": GODOT_ARCHIVE_SHA256,
        },
        "project_file": "project.godot",
        "main_scene_source": "application/run/main_scene",
        "legacy_editor_plugins": LEGACY_EDITOR_PLUGINS,
        "legacy_autoloads": LEGACY_AUTOLOADS,
        "legacy_disable_mode": "TEMPORARY_COPY_ONLY",
        "source_mutation_policy": "FORBIDDEN",
        "scratch_scene_path": "res://.godot-live-editor-pilot/scratch.tscn",
        "behavior_checks": [
            {
                "kind": "GODOT_SCRIPT",
                "target": "res://tests/run_tests.gd",
                "timeout_seconds": 120,
            }
        ],
        "expected_platform": "ANDROID",
    }


def test_project_baseline_matches_declared_pilot_assumptions() -> None:
    project = (ROOT / "project.godot").read_text(encoding="utf-8")
    assert 'run/main_scene="res://game/main/main.tscn"' in project
    assert (
        '_mcp_game_helper="*res://addons/godot_ai/runtime/game_helper.gd"'
        in project
    )
    assert (
        'HeraGameInspector="*res://addons/hera_agent_godot/runtime/game_inspector.gd"'
        in project
    )
    assert (
        'enabled=PackedStringArray("res://addons/godot_ai/plugin.cfg", '
        '"res://addons/gut/plugin.cfg", '
        '"res://addons/hera_agent_godot/plugin.cfg")'
        in project
    )
    for resource_path in LEGACY_EDITOR_PLUGINS:
        assert (ROOT / resource_path.removeprefix("res://")).is_file()
    assert (ROOT / "addons/godot_ai/runtime/game_helper.gd").is_file()
    assert (ROOT / "addons/hera_agent_godot/runtime/game_inspector.gd").is_file()
    assert (ROOT / "game/main/main.tscn").is_file()
    assert (ROOT / "tests/run_tests.gd").is_file()


def test_adoption_document_preserves_truthful_scope() -> None:
    text = _required_text(ADOPTION_DOC)
    for marker in (
        "TEMPORARY_COPY_ONLY",
        "MAIN_SCENE_READ_ONLY",
        "SCRATCH_SCENE_MUTATION_ONLY",
        "SOURCE_TREE_UNCHANGED",
        "SELF_CONTAINED_EVIDENCE_BUNDLE",
        "project-pilot-evidence.json",
        "runtime-result.json",
        "scratch.tscn",
        "ARTIFACT_BYTE_HASH_MISMATCH",
        "PRODUCTION_ADAPTER_READY: NOT_READY",
        "Program B",
        "Program C",
        "physical SHA-256",
        "four adoption files",
    ):
        assert marker in text

    for forbidden_claim in (
        "PRODUCTION_ADAPTER_READY: READY",
        "Android Device Smoke: PASS",
        "HUMAN_USABILITY: PASS",
    ):
        assert forbidden_claim not in text


def test_workflow_uses_one_immutable_base_c0_pin() -> None:
    text = _required_text(WORKFLOW)
    reusable = (
        "alsdmlals4-eng/Base/.github/workflows/"
        f"reusable-godot-project-pilot.yml@{BASE_C0_SHA}"
    )

    assert reusable in text
    assert f"base_pilot_commit: {BASE_C0_SHA}" in text
    assert "descriptor_path: .godot-live-editor/project-pilot.json" in text
    assert "pull_request:" in text
    assert "push:" in text
    assert "workflow_dispatch:" in text
    assert "permissions:\n  contents: read" in text
    assert "fetch-depth: 0" in text
    assert "persist-credentials: false" in text
    assert "python -m pytest tests/test_godot_live_editor_adoption.py -q" in text
    assert "@main" not in text
    assert text.count(BASE_C0_SHA) == 2


def test_pull_request_trigger_is_scoped_to_adoption_surface() -> None:
    text = _required_text(WORKFLOW)
    assert "    paths:\n" in text
    for path in sorted(ALLOWED_PATHS):
        assert f"      - {path}\n" in text


def test_non_pilot_documentation_changes_do_not_trip_pilot_scope_guard() -> None:
    _assert_pilot_change_surface(
        {
            "docs/ASSET_RIGHTS_AND_PROVENANCE_RECORD.md",
            "docs/visual-references/2026-08-25/README.md",
        }
    )


def test_pilot_configuration_change_rejects_unrelated_paths() -> None:
    try:
        _assert_pilot_change_surface(
            {
                ".godot-live-editor/project-pilot.json",
                "docs/ASSET_RIGHTS_AND_PROVENANCE_RECORD.md",
            }
        )
    except AssertionError:
        return
    raise AssertionError("expected unrelated paths to be rejected with Pilot configuration")


def test_change_surface_is_bounded_to_four_adoption_files() -> None:
    _assert_pilot_change_surface(_changed_paths_from_main())
