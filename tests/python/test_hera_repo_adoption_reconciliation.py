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
    guard_tail = enter[enter.index(guard) : enter.index("_create_main_screen()")]
    assert "return" in guard_tail


def test_same_id_state_records_user_adopted_upstream_base_and_patch() -> None:
    state = json.loads(STATE.read_text(encoding="utf-8"))
    hera = state["hera"]

    assert state["decision_id"] == "SX-DEC-052"
    assert hera["repo_tracked"] is True
    assert hera["repo_enabled"] is True
    assert hera["repo_version"] == "1.0.0"
    assert hera["upstream_tag"] == "v1.0.0"
    assert (
        hera["upstream_commit"]
        == "10f245ddae9e7a5d569150302acbde0d78f2aa03"
    )
    assert (
        hera["upstream_addon_tree_sha"]
        == "6cb87ac8ba768de1d924447f385fba6d80bcde68"
    )
    assert (
        hera["user_adoption_commit"]
        == "614fbdce2b1517b8ef34eadb156bf058ecf59b1d"
    )
    assert hera["project_compatibility_patches"] == [
        "addons/hera_agent_godot/hera_agent_plugin.gd:HEADLESS_EARLY_RETURN"
    ]
