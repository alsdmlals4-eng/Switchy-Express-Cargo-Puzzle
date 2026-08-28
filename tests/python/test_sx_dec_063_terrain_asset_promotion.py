import hashlib
import json
import struct
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
ASSET_PATH = ROOT / "art/product_assets/ed_hybrid_v2/board/board_terrain_playfield_v02.png"
IMPORT_PATH = ROOT / "art/product_assets/ed_hybrid_v2/board/board_terrain_playfield_v02.png.import"
MANIFEST_PATH = ROOT / "art/product_assets/ed_hybrid_v2/manifest.json"
RENDERER_PATH = ROOT / "game/demo/presentation/product_board_renderer.gd"
ASSET_SHA256 = "1b8cdeda06a940e70bf462e0e59b71e4130eeb1b266f606d7cd484ab5d145d0d"


class SXDec063TerrainAssetPromotionTests(unittest.TestCase):
    def test_approved_terrain_is_preserved_but_not_runtime_connected(self) -> None:
        self.assertTrue(ASSET_PATH.is_file(), "approved terrain v02 must be locally tracked")
        self.assertTrue(IMPORT_PATH.is_file(), "approved terrain v02 must retain the Godot import descriptor")
        self.assertTrue(MANIFEST_PATH.is_file(), "approved terrain v02 must have a local manifest")

        raw = ASSET_PATH.read_bytes()
        self.assertEqual(ASSET_SHA256, hashlib.sha256(raw).hexdigest())
        self.assertEqual(b"\x89PNG\r\n\x1a\n", raw[:8])
        width, height = struct.unpack(">II", raw[16:24])
        self.assertEqual((1672, 941), (width, height))

        import_descriptor = IMPORT_PATH.read_text(encoding="utf-8")
        self.assertIn('importer="texture"', import_descriptor)
        self.assertIn('type="CompressedTexture2D"', import_descriptor)
        self.assertIn('source_file="res://art/product_assets/ed_hybrid_v2/board/board_terrain_playfield_v02.png"', import_descriptor)

        manifest = json.loads(MANIFEST_PATH.read_text(encoding="utf-8"))
        self.assertEqual("APPROVED_GITHUB_PRESERVED_RUNTIME_NOT_CONNECTED", manifest["status"])
        self.assertEqual("SX-VIS-063-CANDIDATE-001", manifest["source_candidate_id"])
        self.assertEqual(243, manifest["tracking_issue"])
        self.assertEqual(
            {
                "asset_id": "SX-BOARD-TERRAIN-002",
                "path": "art/product_assets/ed_hybrid_v2/board/board_terrain_playfield_v02.png",
                "dimensions": [1672, 941],
                "sha256": ASSET_SHA256,
                "visual_role": "APPROVED_PRODUCT_ASSET_PENDING_RUNTIME_INTEGRATION",
                "planned_runtime_consumer": "game/demo/presentation/product_board_renderer.gd::PRODUCT_VISUAL_ASSET_PATHS[board_terrain]",
                "runtime_connection_status": "NOT_CONNECTED",
            },
            manifest["assets"][0],
        )

        renderer = RENDERER_PATH.read_text(encoding="utf-8")
        self.assertIn(
            '"board_terrain": "art/product_assets/ed_hybrid_v1/board/board_terrain_playfield_v01.png"',
            renderer,
            "asset promotion must not silently switch the runtime consumer",
        )


if __name__ == "__main__":
    unittest.main()
