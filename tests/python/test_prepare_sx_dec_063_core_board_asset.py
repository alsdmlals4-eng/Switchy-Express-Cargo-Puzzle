import os
import struct
import subprocess
import tempfile
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
GODOT = Path(
    os.environ.get(
        "GODOT_BINARY",
        "C:/Users/user/Downloads/Godot_v4.7.1-stable_win64.exe/"
        "Godot_v4.7.1-stable_win64_console.exe",
    )
)
SCRIPT = ROOT / "tools/prepare_sx_dec_063_core_board_asset.gd"
ALPHA_SOURCE = ROOT / "art/product_assets/ed_hybrid_v1/core/core_cargo_star_red_normal_v01.png"


class PrepareSXDec063CoreBoardAssetTests(unittest.TestCase):
    def test_resizes_transparent_png_to_requested_dimensions(self) -> None:
        self.assertTrue(
            GODOT.is_file(),
            "the configured GODOT_BINARY or pinned local Godot console executable must be available",
        )
        self.assertTrue(ALPHA_SOURCE.is_file(), "an existing transparent core PNG is required for the real tool test")

        with tempfile.TemporaryDirectory() as temporary_directory:
            output_path = Path(temporary_directory) / "resized.png"
            completed = subprocess.run(
                [
                    str(GODOT),
                    "--headless",
                    "--path",
                    str(ROOT),
                    "--script",
                    "res://tools/prepare_sx_dec_063_core_board_asset.gd",
                    "--",
                    "--input",
                    str(ALPHA_SOURCE),
                    "--output",
                    str(output_path),
                    "--width",
                    "64",
                    "--height",
                    "64",
                ],
                capture_output=True,
                check=False,
                text=True,
            )

            self.assertEqual(
                0,
                completed.returncode,
                completed.stdout + completed.stderr,
            )
            raw = output_path.read_bytes()
            self.assertEqual(b"\x89PNG\r\n\x1a\n", raw[:8])
            self.assertEqual((64, 64), struct.unpack(">II", raw[16:24]))
            self.assertIn(raw[25], (4, 6), "output PNG must retain an alpha channel")


if __name__ == "__main__":
    unittest.main()
