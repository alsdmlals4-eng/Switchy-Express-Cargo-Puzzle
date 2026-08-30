import hashlib
import json
import struct
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
MANIFEST_PATH = ROOT / "art/product_assets/ed_hybrid_v2/manifest.json"
RENDERER_PATH = ROOT / "game/demo/presentation/product_board_renderer.gd"

EXPECTED_ASSETS = {
    "SX-BOARD-TERRAIN-002": (
        "art/product_assets/ed_hybrid_v2/board/board_terrain_playfield_v02.png",
        (1672, 941),
        False,
        "board_terrain",
    ),
    "SX-CORE-TRAIN-002": (
        "art/product_assets/ed_hybrid_v2/core/core_train_locomotive_blue_normal_v02.png",
        (128, 96),
        True,
        "train",
    ),
    "SX-CORE-RAIL-STRAIGHT-003": (
        "art/product_assets/ed_hybrid_v2/core/core_rail_straight_normal_v03.png",
        (64, 64),
        True,
        "rail_straight",
    ),
    "SX-CORE-RAIL-CURVE-003": (
        "art/product_assets/ed_hybrid_v2/core/core_rail_curve_normal_v03.png",
        (64, 64),
        True,
        "rail_curve",
    ),
    "SX-CORE-RAIL-CROSSING-003": (
        "art/product_assets/ed_hybrid_v2/core/core_rail_crossing_normal_v03.png",
        (64, 64),
        True,
        "rail_crossing",
    ),
    "SX-CORE-RAIL-SWITCH-003": (
        "art/product_assets/ed_hybrid_v2/core/core_rail_switch_three_way_normal_v03.png",
        (64, 64),
        True,
        "rail_switch",
    ),
    "SX-CORE-MARKER-START-002": (
        "art/product_assets/ed_hybrid_v2/core/core_marker_start_normal_v02.png",
        (64, 64),
        True,
        "start_marker",
    ),
    "SX-CORE-MARKER-END-002": (
        "art/product_assets/ed_hybrid_v2/core/core_marker_route_end_normal_v02.png",
        (64, 64),
        True,
        "route_end_marker",
    ),
    "SX-CORE-STATION-RED-002": (
        "art/product_assets/ed_hybrid_v2/core/core_station_red_normal_v02.png",
        (64, 64),
        True,
        "station_red",
    ),
    "SX-CORE-STATION-BLUE-002": (
        "art/product_assets/ed_hybrid_v2/core/core_station_blue_normal_v02.png",
        (64, 64),
        True,
        "station_blue",
    ),
    "SX-CORE-STATION-YELLOW-002": (
        "art/product_assets/ed_hybrid_v2/core/core_station_yellow_normal_v02.png",
        (64, 64),
        True,
        "station_yellow",
    ),
    "SX-CORE-CARGO-RED-002": (
        "art/product_assets/ed_hybrid_v2/core/core_cargo_star_red_normal_v02.png",
        (64, 64),
        True,
        "cargo_red",
    ),
    "SX-CORE-CARGO-BLUE-002": (
        "art/product_assets/ed_hybrid_v2/core/core_cargo_star_blue_normal_v02.png",
        (64, 64),
        True,
        "cargo_blue",
    ),
    "SX-CORE-CARGO-YELLOW-002": (
        "art/product_assets/ed_hybrid_v2/core/core_cargo_star_yellow_normal_v02.png",
        (64, 64),
        True,
        "cargo_yellow",
    ),
}

V01_ROLLBACK_PATHS = [
    "art/product_assets/ed_hybrid_v1/board/board_terrain_playfield_v01.png",
    "art/product_assets/ed_hybrid_v1/core/core_train_locomotive_blue_normal_v01.png",
    "art/product_assets/ed_hybrid_v1/core/core_rail_straight_normal_v01.png",
    "art/product_assets/ed_hybrid_v1/core/core_rail_curve_normal_v01.png",
    "art/product_assets/ed_hybrid_v1/core/core_rail_crossing_normal_v01.png",
    "art/product_assets/ed_hybrid_v1/core/core_rail_switch_three_way_normal_v01.png",
    "art/product_assets/ed_hybrid_v1/core/core_marker_start_normal_v01.png",
    "art/product_assets/ed_hybrid_v1/core/core_marker_route_end_normal_v01.png",
    "art/product_assets/ed_hybrid_v1/core/core_station_red_normal_v01.png",
    "art/product_assets/ed_hybrid_v1/core/core_station_blue_normal_v01.png",
    "art/product_assets/ed_hybrid_v1/core/core_station_yellow_normal_v01.png",
    "art/product_assets/ed_hybrid_v1/core/core_cargo_star_red_normal_v01.png",
    "art/product_assets/ed_hybrid_v1/core/core_cargo_star_blue_normal_v01.png",
    "art/product_assets/ed_hybrid_v1/core/core_cargo_star_yellow_normal_v01.png",
]

RAIL_MASTER_SOURCE = {
    "source_candidate_id": "SX-VIS-063-RAIL-NETWORK-MASTER-003",
    "source_generation_receipt": "exec-c20ff7f8-a3b4-4b7d-a2d9-4a37d460ca3b.png",
    "tracked_source_path": "art/product_assets/ed_hybrid_v2/source/core_rail_network_master_v03.png",
    "dimensions": [1254, 1254],
    "sha256": "f3a6f070b728e319a15b3fc1b72ac7c4732f3b632e73e5dda202a52e95bb5d5b",
    "derivation_route": "AI_GENERATED_THEN_DETERMINISTIC_RASTER_CROP_AND_RESAMPLE",
    "crop_rectangles": {
        "SX-CORE-RAIL-STRAIGHT-003": [0, 316, 256, 256],
        "SX-CORE-RAIL-CURVE-003": [374, 749, 256, 256],
        "SX-CORE-RAIL-CROSSING-003": [374, 318, 256, 256],
        "SX-CORE-RAIL-SWITCH-003": [821, 318, 256, 256],
    },
}


class SXDec063CoreBoardAssetPromotionTests(unittest.TestCase):
    def test_v03_rail_family_is_preserved_and_runtime_verified(self) -> None:
        manifest = json.loads(MANIFEST_PATH.read_text(encoding="utf-8"))
        self.assertEqual(
            "APPROVED_GITHUB_PRESERVED_RUNTIME_VERIFIED_AUTOMATED",
            manifest["status"],
        )
        manifest_assets = {entry["asset_id"]: entry for entry in manifest["assets"]}
        self.assertEqual(set(EXPECTED_ASSETS), set(manifest_assets))
        renderer = RENDERER_PATH.read_text(encoding="utf-8")

        self.assertEqual(RAIL_MASTER_SOURCE, manifest["rail_master_source"])
        master_path = ROOT / RAIL_MASTER_SOURCE["tracked_source_path"]
        self.assertTrue(master_path.is_file(), "the connected rail master source must be preserved")
        if master_path.is_file():
            master_raw = master_path.read_bytes()
            self.assertEqual(b"\x89PNG\r\n\x1a\n", master_raw[:8])
            self.assertEqual((1254, 1254), struct.unpack(">II", master_raw[16:24]))
            self.assertEqual(RAIL_MASTER_SOURCE["sha256"], hashlib.sha256(master_raw).hexdigest())

        for asset_id, (relative_path, dimensions, alpha_required, slot) in EXPECTED_ASSETS.items():
            asset_path = ROOT / relative_path
            import_path = ROOT / f"{relative_path}.import"
            self.assertTrue(asset_path.is_file(), f"{asset_id} must be locally tracked")
            self.assertTrue(import_path.is_file(), f"{asset_id} must import as a Godot Texture2D")
            if not asset_path.is_file() or not import_path.is_file():
                continue
            self.assertIn(asset_id, manifest_assets, f"{asset_id} must have a manifest entry")
            if asset_id not in manifest_assets:
                continue

            raw = asset_path.read_bytes()
            self.assertEqual(b"\x89PNG\r\n\x1a\n", raw[:8], asset_id)
            self.assertEqual(dimensions, struct.unpack(">II", raw[16:24]), asset_id)
            if alpha_required:
                self.assertIn(raw[25], (4, 6), f"{asset_id} must preserve PNG alpha")

            manifest_entry = manifest_assets[asset_id]
            self.assertEqual(relative_path, manifest_entry["path"])
            self.assertEqual(list(dimensions), manifest_entry["dimensions"])
            self.assertEqual(hashlib.sha256(raw).hexdigest(), manifest_entry["sha256"])
            self.assertEqual(
                f"game/demo/presentation/product_board_renderer.gd::PRODUCT_VISUAL_ASSET_PATHS[{slot}]",
                manifest_entry["runtime_consumer"],
            )
            self.assertEqual("VERIFIED_AUTOMATED_RUNTIME", manifest_entry["consumer_status"])
            self.assertEqual("VERIFIED", manifest_entry["runtime_connection_status"])
            self.assertIn(f'"{slot}": "{relative_path}"', renderer)

            import_descriptor = import_path.read_text(encoding="utf-8")
            self.assertIn('importer="texture"', import_descriptor)
            self.assertIn('type="CompressedTexture2D"', import_descriptor)
            self.assertIn(f'source_file="res://{relative_path}"', import_descriptor)

        for relative_path in V01_ROLLBACK_PATHS:
            self.assertTrue((ROOT / relative_path).is_file(), f"v01 rollback source must remain: {relative_path}")


if __name__ == "__main__":
    unittest.main()
