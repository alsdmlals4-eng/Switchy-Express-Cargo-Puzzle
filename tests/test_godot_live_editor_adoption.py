from __future__ import annotations

import json
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
BASE_C0_SHA = "a764dcada13ec69c02bb290794a3979ba981e806"
GODOT_ARCHIVE_SHA256 = "c7ff14fd28472c8d4f193043de30278dcf7e5241a1dcf7566b02e27addaa33ba"
DESCRIPTOR = ROOT / ".godot-live-editor/project-pilot.json"
ADOPTION_DOC = ROOT / "docs/GODOT_LIVE_EDITOR_ADOPTION.md"
WORKFLOW = ROOT / ".github/workflows/validate-godot-live-editor-pilot.yml"
ALLOWED_PATHS = {
    ".godot-live-editor/project-pilot.json",
    "docs/GODOT_LIVE_EDITOR_ADOPTION.md",
    "tests/test_godot_live_editor_adoption.py",
    ".github/workflows/validate-godot-live-editor-pilot.yml",
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


def test_descriptor_is_exact_clean_baseline_contract() -> None:
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
        "legacy_editor_plugins": [],
        "legacy_autoloads": [],
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


def test_project_baseline_matches_reviewed_clean_pilot_assumptions() -> None:
    project = (ROOT / "project.godot").read_text(encoding="utf-8")
    assert 'run/main_scene="res://game/main/main.tscn"' in project
    assert "godot_ai" not in project
    assert "_mcp_game_helper" not in project
    assert (ROOT / "game/main/main.tscn").is_file()
    assert (ROOT / "tests/run_tests.gd").is_file()


def test_adoption_document_preserves_truthful_scope() -> None:
    text = _required_text(ADOPTION_DOC)
    for marker in (
        "TEMPORARY_COPY_ONLY",
        "MAIN_SCENE_READ_ONLY",
        "SCRATCH_SCENE_MUTATION_ONLY",
        "SOURCE_TREE_UNCHANGED",
        "DRAFT_CANDIDATE_EXACT_HEAD",
        "SELF_CONTAINED_EVIDENCE_BUNDLE",
        "matches open Scene paths and roots by index",
        "three consecutive editor frames",
        "bounded fixed diagnostic fields",
        "first failed operation code",
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
        "MERGED_IMMUTABLE_PIN",
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


def test_change_surface_is_bounded_to_four_adoption_files() -> None:
    changed = _changed_paths_from_main()
    assert changed <= ALLOWED_PATHS, f"forbidden changed paths: {sorted(changed - ALLOWED_PATHS)}"
