from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
HERA_PLUGIN = ROOT / "addons/hera_agent_godot/hera_agent_plugin.gd"
HERA_CFG = ROOT / "addons/hera_agent_godot/plugin.cfg"
PROJECT = ROOT / "project.godot"
STATE = ROOT / "docs/tooling/local_godot_tooling_state.json"


class HeraRepoAdoptionReconciliationTests(unittest.TestCase):
    def test_hera_v1_is_tracked_enabled_and_clean_clone_safe(self) -> None:
        cfg = HERA_CFG.read_text(encoding="utf-8")
        project = PROJECT.read_text(encoding="utf-8")

        self.assertIn('version="1.0.0"', cfg)
        self.assertIn('res://addons/hera_agent_godot/plugin.cfg', project)
        self.assertIn(
            'HeraGameInspector="*res://addons/hera_agent_godot/runtime/game_inspector.gd"',
            project,
        )
        self.assertNotIn('HeraGameInspector="*uid://', project)

    def test_hera_server_is_inert_under_headless_display(self) -> None:
        source = HERA_PLUGIN.read_text(encoding="utf-8")
        enter = source.split("func _enter_tree() -> void:", 1)[1].split(
            "func _process(delta: float) -> void:", 1
        )[0]
        guard = 'DisplayServer.get_name() == "headless"'

        self.assertIn(guard, enter)
        self.assertLess(enter.index(guard), enter.index("_create_main_screen()"))
        self.assertLess(enter.index(guard), enter.index("_ensure_game_autoload()"))
        self.assertLess(enter.index(guard), enter.index("_server = HttpServer.new()"))
        guard_tail = enter[enter.index(guard) : enter.index("_create_main_screen()")]
        self.assertIn("return", guard_tail)

    def test_same_id_state_records_user_adopted_upstream_base_and_patch(self) -> None:
        state = json.loads(STATE.read_text(encoding="utf-8"))
        hera = state["hera"]

        self.assertEqual("SX-DEC-052", state["decision_id"])
        self.assertTrue(hera["repo_tracked"])
        self.assertTrue(hera["repo_enabled"])
        self.assertEqual("1.0.0", hera["repo_version"])
        self.assertEqual("v1.0.0", hera["upstream_tag"])
        self.assertEqual(
            "10f245ddae9e7a5d569150302acbde0d78f2aa03",
            hera["upstream_commit"],
        )
        self.assertEqual(
            "6cb87ac8ba768de1d924447f385fba6d80bcde68",
            hera["upstream_addon_tree_sha"],
        )
        self.assertEqual(
            "614fbdce2b1517b8ef34eadb156bf058ecf59b1d",
            hera["user_adoption_commit"],
        )
        self.assertEqual(
            ["addons/hera_agent_godot/hera_agent_plugin.gd:HEADLESS_EARLY_RETURN"],
            hera["project_compatibility_patches"],
        )


if __name__ == "__main__":
    unittest.main()
