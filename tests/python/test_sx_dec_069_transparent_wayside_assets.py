import hashlib
import json
import struct
import unittest
import zlib
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
MANIFEST_PATH = ROOT / "art/product_assets/ed_hybrid_v2/manifest.json"
RENDERER_PATH = ROOT / "game/demo/presentation/product_board_renderer.gd"
PNG_SIGNATURE = b"\x89PNG\r\n\x1a\n"

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


def _paeth(left: int, up: int, upper_left: int) -> int:
    prediction = left + up - upper_left
    left_distance = abs(prediction - left)
    up_distance = abs(prediction - up)
    upper_left_distance = abs(prediction - upper_left)
    if left_distance <= up_distance and left_distance <= upper_left_distance:
        return left
    if up_distance <= upper_left_distance:
        return up
    return upper_left


def _rgba_alpha_statistics(path: Path) -> tuple[int, int, tuple[int, int, int, int], int]:
    payload = path.read_bytes()
    if not payload.startswith(PNG_SIGNATURE):
        raise AssertionError("candidate must be a PNG file")

    offset = len(PNG_SIGNATURE)
    header: tuple[int, int, int, int, int, int, int] | None = None
    compressed_rows: list[bytes] = []
    while offset < len(payload):
        if offset + 12 > len(payload):
            raise AssertionError("PNG chunk is truncated")
        size = struct.unpack(">I", payload[offset : offset + 4])[0]
        chunk_kind = payload[offset + 4 : offset + 8]
        chunk_end = offset + 12 + size
        if chunk_end > len(payload):
            raise AssertionError("PNG chunk payload is truncated")
        chunk_payload = payload[offset + 8 : offset + 8 + size]
        if chunk_kind == b"IHDR":
            header = struct.unpack(">IIBBBBB", chunk_payload)
        elif chunk_kind == b"IDAT":
            compressed_rows.append(chunk_payload)
        elif chunk_kind == b"IEND":
            break
        offset = chunk_end

    if header is None:
        raise AssertionError("PNG has no IHDR")
    width, height, bit_depth, color_type, compression, filter_method, interlace = header
    if width <= 1 or height <= 1:
        raise AssertionError("candidate must have a meaningful raster size")
    if (bit_depth, color_type, compression, filter_method, interlace) != (8, 6, 0, 0, 0):
        raise AssertionError("candidate must be a non-interlaced 8-bit RGBA PNG")

    row_stride = width * 4
    rows = memoryview(zlib.decompress(b"".join(compressed_rows)))
    expected_size = height * (row_stride + 1)
    if len(rows) != expected_size:
        raise AssertionError("PNG scanline data does not match the RGBA header")

    offset = 0
    previous_alpha = bytearray(width)
    first_row_alpha: bytearray | None = None
    last_row_alpha = bytearray(width)
    nontransparent = 0
    for _row_index in range(height):
        filter_kind = rows[offset]
        offset += 1
        row_start = offset
        offset += row_stride
        current_alpha = bytearray(width)
        for column in range(width):
            raw_alpha = rows[row_start + column * 4 + 3]
            left = current_alpha[column - 1] if column else 0
            up = previous_alpha[column]
            upper_left = previous_alpha[column - 1] if column else 0
            if filter_kind == 0:
                alpha = raw_alpha
            elif filter_kind == 1:
                alpha = (raw_alpha + left) & 0xFF
            elif filter_kind == 2:
                alpha = (raw_alpha + up) & 0xFF
            elif filter_kind == 3:
                alpha = (raw_alpha + ((left + up) >> 1)) & 0xFF
            elif filter_kind == 4:
                alpha = (raw_alpha + _paeth(left, up, upper_left)) & 0xFF
            else:
                raise AssertionError(f"unsupported PNG filter {filter_kind}")
            current_alpha[column] = alpha
            nontransparent += alpha != 0
        if first_row_alpha is None:
            first_row_alpha = current_alpha
        last_row_alpha = current_alpha
        previous_alpha = current_alpha

    if first_row_alpha is None:
        raise AssertionError("PNG contains no image rows")
    return (
        width,
        height,
        (first_row_alpha[0], first_row_alpha[-1], last_row_alpha[0], last_row_alpha[-1]),
        nontransparent,
    )


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
                width, height, corners, nontransparent = _rgba_alpha_statistics(asset_path)
                self.assertEqual((0, 0, 0, 0), corners, "all candidate corners must be transparent")
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
