import hashlib
import json
import unittest
from pathlib import Path

from PIL import Image


ROOT = Path(__file__).resolve().parents[2]
MANIFEST_PATH = ROOT / "art/product_assets/ed_hybrid_v2/manifest.json"
RENDERER_PATH = ROOT / "game/demo/presentation/product_board_renderer.gd"

EXPECTED_ASSETS = {
    "SX-BOARD-DECOR-FOREST-002": ("art/product_assets/ed_hybrid_v2/board/board_decor_forest_cluster_v02.png", "decoration_forest_cluster"),
    "SX-BOARD-DECOR-BOULDER-002": ("art/product_assets/ed_hybrid_v2/board/board_decor_moss_boulder_v02.png", "decoration_moss_boulder"),
    "SX-BOARD-DECOR-TIMBER-002": ("art/product_assets/ed_hybrid_v2/board/board_decor_timber_stack_v02.png", "decoration_timber_stack"),
    "SX-BOARD-DECOR-WATERWAY-002": ("art/product_assets/ed_hybrid_v2/board/board_decor_waterway_v02.png", "decoration_waterway"),
    "SX-BOARD-DECOR-LANTERN-002": ("art/product_assets/ed_hybrid_v2/board/board_decor_lantern_fence_v02.png", "decoration_lantern_fence"),
    "SX-BOARD-CAUTION-002": ("art/product_assets/ed_hybrid_v2/board/board_caution_track_overlay_v02.png", "caution_track"),
    "SX-CORE-CARGO-WASTE-002": ("art/product_assets/ed_hybrid_v2/core/core_cargo_waste_crate_normal_v02.png", "cargo_waste"),
    "SX-CORE-DISPOSAL-YARD-002": ("art/product_assets/ed_hybrid_v2/core/core_disposal_yard_normal_v02.png", "station_disposal"),
}


class TransparentWaysideAssetTests(unittest.TestCase):
    def test_v02_assets_are_transparent_candidates_with_exact_consumers(self) -> None:
        manifest = json.loads(MANIFEST_PATH.read_text(encoding="utf-8"))
        candidates = {entry["asset_id"]: entry for entry in manifest["generated_candidates"]}
        renderer = RENDERER_PATH.read_text(encoding="utf-8")

        for asset_id, (relative_path, slot) in EXPECTED_ASSETS.items():
            with self.subTest(asset_id=asset_id):
                asset_path = ROOT / relative_path
                self.assertTrue(asset_path.is_file(), f"missing transparent v02 candidate: {asset_id}")
                if not asset_path.is_file():
                    continue
                with Image.open(asset_path) as image:
                    self.assertEqual("RGBA", image.mode, "candidate must retain an 8-bit alpha channel")
                    width, height = image.size
                    self.assertGreater(width, 1)
                    self.assertGreater(height, 1)
                    alpha = image.getchannel("A")
                    self.assertEqual(0, alpha.getpixel((0, 0)), "top-left corner must be transparent")
                    self.assertEqual(0, alpha.getpixel((width - 1, 0)), "top-right corner must be transparent")
                    self.assertEqual(0, alpha.getpixel((0, height - 1)), "bottom-left corner must be transparent")
                    self.assertEqual(0, alpha.getpixel((width - 1, height - 1)), "bottom-right corner must be transparent")
                    nontransparent = sum(alpha.histogram()[1:])
                    self.assertLess(
                        nontransparent,
                        width * height * 0.75,
                        "a transparent object candidate must not contain a full-frame terrain backdrop",
                    )
                self.assertIn(asset_id, candidates, "v02 candidate must be recorded")
                candidate = candidates[asset_id]
                self.assertEqual(relative_path, candidate["path"])
                self.assertEqual(hashlib.sha256(asset_path.read_bytes()).hexdigest(), candidate["sha256"])
                self.assertEqual("GENERATED_CANDIDATE_RUNTIME_CONNECTED_NOT_CANON", candidate["visual_role"])
                self.assertEqual("USER_REVIEW_PENDING", candidate["pixel_review_status"])
                self.assertEqual(
                    f"game/demo/presentation/product_board_renderer.gd::PRODUCT_VISUAL_ASSET_PATHS[{slot}]",
                    candidate["runtime_consumer"],
                )
                self.assertIn(f'"{slot}": "{relative_path}"', renderer)


if __name__ == "__main__":
    unittest.main()
