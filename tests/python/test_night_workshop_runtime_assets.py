import hashlib
import json
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[2]


class NightWorkshopRuntimeAssets(unittest.TestCase):
    def test_approved_family_bytes_and_consumers(self):
        folder = ROOT / "art/product_assets/night_workshop_v1"
        manifest = json.loads((folder / "manifest.json").read_text(encoding="utf-8"))
        self.assertEqual(manifest["decision_id"], "SX-DEC-070")
        self.assertEqual({a["key"] for a in manifest["assets"]},
                         {"train", "station_blue", "cargo_blue", "cargo_lift", "board_terrain"})
        renderer = (ROOT / manifest["consumer"]).read_text(encoding="utf-8")
        for asset in manifest["assets"]:
            path = folder / asset["path"]
            self.assertEqual(hashlib.sha256(path.read_bytes()).hexdigest(), asset["sha256"])
            self.assertIn("art/product_assets/night_workshop_v1/" + asset["path"], renderer)
        lift = next(a for a in manifest["assets"] if a["key"] == "cargo_lift")
        self.assertEqual((lift["frames"], lift["frame_size"], lift["frame_stride"],
                          lift["duration_ms"], lift["loop"]), (4, [448, 448], 450, 60, False))

    def test_board_preserves_selected_pixels_without_old_warm_filter(self):
        folder = ROOT / "art/product_assets/night_workshop_v1"
        manifest = json.loads((folder / "manifest.json").read_text(encoding="utf-8"))
        board = next(a for a in manifest["assets"] if a["key"] == "board_terrain")
        self.assertEqual((folder / board["path"]).read_bytes(), (ROOT / board["source"]).read_bytes())
        self.assertEqual(board["sha256"], "694f69c32f457a9dea425716774d9bca4de2896c680c8defed47667d86e15365")
        palette = (ROOT / "game/demo/presentation/demo_palette.gd").read_text(encoding="utf-8")
        self.assertIn("BOARD_TERRAIN_TINT := Color.WHITE", palette)
        self.assertIn("BOARD_TERRAIN_VEIL := Color.TRANSPARENT", palette)
