from __future__ import annotations

import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
HUD_SCENE = ROOT / "game/demo/presentation/product_hud.tscn"
HUD_SCRIPT = ROOT / "game/demo/presentation/product_hud.gd"
BOARD_RENDERER = ROOT / "game/demo/presentation/product_board_renderer.gd"


class PhysicalPreflightVisualContractTests(unittest.TestCase):
    def test_problem_banner_keeps_semantic_badge_at_native_badge_width(self) -> None:
        scene = HUD_SCENE.read_text(encoding="utf-8")
        self.assertIn('[node name="ProblemLayout" type="HBoxContainer" parent="ProblemBanner"]', scene)
        self.assertIn(
            '[node name="ProblemSemanticBadge" type="Control" parent="ProblemBanner/ProblemLayout"]',
            scene,
        )
        self.assertIn(
            '[node name="ProblemText" type="Label" parent="ProblemBanner/ProblemLayout"]',
            scene,
        )
        self.assertNotIn('[node name="ProblemSemanticBadge" type="Control" parent="ProblemBanner"]', scene)
        self.assertNotIn('[node name="ProblemText" type="Label" parent="ProblemBanner"]', scene)

    def test_hud_script_uses_non_overlapping_problem_layout_paths(self) -> None:
        script = HUD_SCRIPT.read_text(encoding="utf-8")
        self.assertIn('ProblemBanner/ProblemLayout/ProblemText', script)
        self.assertIn('ProblemBanner/ProblemLayout/ProblemSemanticBadge', script)
        self.assertNotIn('get_node("ProblemBanner/ProblemText")', script)
        self.assertNotIn('_set_semantic_badge("ProblemBanner/ProblemSemanticBadge"', script)

    def test_board_problem_cells_do_not_render_full_preflight_hud_composition_over_markers(self) -> None:
        script = BOARD_RENDERER.read_text(encoding="utf-8")
        self.assertNotIn('_draw_semantic_record(focus_record, problem_rect.grow(-3.0))', script)
        self.assertIn('draw_rect(problem_rect, Palette.PROBLEM, false, 5.0)', script)


if __name__ == "__main__":
    unittest.main()
