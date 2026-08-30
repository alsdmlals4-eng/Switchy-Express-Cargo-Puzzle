import hashlib
import json
import re
import struct
import unittest
import zlib
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
    "SX-CORE-RAIL-STRAIGHT-004": (
        "art/product_assets/ed_hybrid_v2/core/core_rail_straight_normal_v04.png",
        (64, 64),
        True,
        "rail_straight",
    ),
    "SX-CORE-RAIL-CURVE-004": (
        "art/product_assets/ed_hybrid_v2/core/core_rail_curve_normal_v04.png",
        (64, 64),
        True,
        "rail_curve",
    ),
    "SX-CORE-RAIL-CROSSING-004": (
        "art/product_assets/ed_hybrid_v2/core/core_rail_crossing_normal_v04.png",
        (64, 64),
        True,
        "rail_crossing",
    ),
    "SX-CORE-RAIL-SWITCH-004": (
        "art/product_assets/ed_hybrid_v2/core/core_rail_switch_three_way_normal_v04.png",
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
        "SX-CORE-RAIL-STRAIGHT-004": [650, 803, 256, 256],
        "SX-CORE-RAIL-CURVE-004": [394, 803, 256, 256],
        "SX-CORE-RAIL-CROSSING-004": [388, 300, 256, 256],
        "SX-CORE-RAIL-SWITCH-004": [855, 300, 256, 256],
    },
}

RAIL_PORTS = {
    "rail_straight": ("left", "right"),
    "rail_curve": ("top", "right"),
    "rail_crossing": ("top", "right", "bottom", "left"),
    "rail_switch": ("top", "right", "left"),
}


def _paeth(left: int, above: int, upper_left: int) -> int:
    prediction = left + above - upper_left
    left_distance = abs(prediction - left)
    above_distance = abs(prediction - above)
    upper_left_distance = abs(prediction - upper_left)
    if left_distance <= above_distance and left_distance <= upper_left_distance:
        return left
    if above_distance <= upper_left_distance:
        return above
    return upper_left


def _rgba_rows(path: Path) -> tuple[int, int, list[bytes]]:
    """Read real RGBA pixels so a tile-port seam cannot hide behind metadata."""
    raw = path.read_bytes()
    if raw[:8] != b"\x89PNG\r\n\x1a\n":
        raise AssertionError(f"not a PNG: {path}")

    width = height = bit_depth = color_type = interlace = None
    compressed = bytearray()
    cursor = 8
    while cursor < len(raw):
        chunk_length = struct.unpack(">I", raw[cursor : cursor + 4])[0]
        chunk_type = raw[cursor + 4 : cursor + 8]
        chunk_data = raw[cursor + 8 : cursor + 8 + chunk_length]
        cursor += 12 + chunk_length
        if chunk_type == b"IHDR":
            width, height, bit_depth, color_type, _compression, _filter, interlace = struct.unpack(
                ">IIBBBBB", chunk_data
            )
        elif chunk_type == b"IDAT":
            compressed.extend(chunk_data)
        elif chunk_type == b"IEND":
            break

    if (bit_depth, color_type, interlace) != (8, 6, 0):
        raise AssertionError(
            f"{path} must be an 8-bit, non-interlaced RGBA PNG; got "
            f"bit_depth={bit_depth}, color_type={color_type}, interlace={interlace}"
        )
    if width is None or height is None:
        raise AssertionError(f"missing PNG header: {path}")

    stride = width * 4
    decoded = zlib.decompress(compressed)
    rows: list[bytes] = []
    offset = 0
    previous = bytearray(stride)
    for _ in range(height):
        filter_type = decoded[offset]
        offset += 1
        source = decoded[offset : offset + stride]
        offset += stride
        row = bytearray(stride)
        for index, value in enumerate(source):
            left = row[index - 4] if index >= 4 else 0
            above = previous[index]
            upper_left = previous[index - 4] if index >= 4 else 0
            if filter_type == 0:
                row[index] = value
            elif filter_type == 1:
                row[index] = (value + left) & 0xFF
            elif filter_type == 2:
                row[index] = (value + above) & 0xFF
            elif filter_type == 3:
                row[index] = (value + ((left + above) // 2)) & 0xFF
            elif filter_type == 4:
                row[index] = (value + _paeth(left, above, upper_left)) & 0xFF
            else:
                raise AssertionError(f"unsupported PNG filter {filter_type}: {path}")
        rows.append(bytes(row))
        previous = row
    return width, height, rows


def _opaque_edge_port_span(path: Path, edge: str) -> tuple[float, int]:
    width, height, rows = _rgba_rows(path)
    if edge == "top":
        alphas = [rows[0][index * 4 + 3] for index in range(width)]
    elif edge == "right":
        alphas = [rows[index][(width - 1) * 4 + 3] for index in range(height)]
    elif edge == "bottom":
        alphas = [rows[height - 1][index * 4 + 3] for index in range(width)]
    elif edge == "left":
        alphas = [rows[index][3] for index in range(height)]
    else:
        raise AssertionError(f"unknown edge: {edge}")
    positions = [index for index, alpha in enumerate(alphas) if alpha >= 128]
    if not positions:
        raise AssertionError(f"{path} has no opaque rail/ballast pixels at {edge} port")
    spans: list[list[int]] = []
    for position in positions:
        if not spans or position > spans[-1][-1] + 1:
            spans.append([position])
        else:
            spans[-1].append(position)
    expected_center = (len(alphas) - 1) / 2.0
    port_span = min(
        spans,
        key=lambda span: (abs(((span[0] + span[-1]) / 2.0) - expected_center), -len(span)),
    )
    return (port_span[0] + port_span[-1]) / 2.0, len(port_span)


class SXDec063CoreBoardAssetPromotionTests(unittest.TestCase):
    def test_v04_rail_family_is_preserved_and_runtime_verified(self) -> None:
        manifest = json.loads(MANIFEST_PATH.read_text(encoding="utf-8"))
        self.assertEqual(
            "USER_DIRECTED_APPROVED_MASTER_DERIVATIVE_LOCAL_RUNTIME_AND_PACKAGE_AND_REMOTE_RUNTIME_BYTE_CI_7_GREEN_PR_255_4D5C5EF",
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

    def test_runtime_rail_ports_are_centered_for_seamless_tile_connections(self) -> None:
        """Catch a crop whose rail art reaches a cell edge away from the game port."""
        renderer = RENDERER_PATH.read_text(encoding="utf-8")
        for slot, edges in RAIL_PORTS.items():
            match = re.search(rf'"{slot}": "([^"]+)"', renderer)
            self.assertIsNotNone(match, f"renderer must expose the actual {slot} texture path")
            if match is None:
                continue
            asset_path = ROOT / match.group(1)
            width, height, _rows = _rgba_rows(asset_path)
            self.assertEqual(width, height, f"{slot} must remain square for quarter-turn rotation")
            expected_center = (width - 1) / 2.0
            for edge in edges:
                with self.subTest(slot=slot, edge=edge):
                    edge_center, opaque_width = _opaque_edge_port_span(asset_path, edge)
                    self.assertGreaterEqual(
                        opaque_width,
                        12,
                        f"{slot} {edge} port must keep a visible contiguous rail/ballast span",
                    )
                    self.assertAlmostEqual(
                        expected_center,
                        edge_center,
                        delta=2.0,
                        msg=(
                            f"{slot} {edge} port must meet the cell boundary at its center; "
                            "otherwise a legal neighboring rail produces a visible seam"
                        ),
                    )


if __name__ == "__main__":
    unittest.main()
