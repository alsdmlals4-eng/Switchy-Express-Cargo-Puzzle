from __future__ import annotations

import hashlib
import json
import struct
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
ASSET_ID = "SX-TITLE-WORDMARK-001"
ASSET_PATH = "art/product_assets/ed_hybrid_v2/shells/shell_title_wordmark_switchy_express_candidate_v01.png"
ASSET_SHA256 = "4faaefca00416119bc0c30e0e45b8e8bf33fe27c72a7466d541ab6c6576244e8"
SCENE = ROOT / "game/demo/vertical_slice_demo.tscn"
MANIFEST = ROOT / "art/product_assets/ed_hybrid_v2/manifest.json"
DECISION = ROOT / "docs/decisions/SX_DEC_068_TITLE_SCREEN_MAIN_SHELL.md"


class SXDec068TitleWordmarkCandidateTests(unittest.TestCase):
    def test_wordmark_is_a_tracked_rgba_canonical_asset_with_one_title_consumer(self) -> None:
        asset_path = ROOT / ASSET_PATH
        self.assertTrue(asset_path.is_file(), "generated title wordmark must be tracked in the project asset family")

        raw = asset_path.read_bytes()
        self.assertEqual(b"\x89PNG\r\n\x1a\n", raw[:8])
        self.assertEqual((1774, 887), struct.unpack(">II", raw[16:24]))
        self.assertEqual(6, raw[25], "title wordmark must preserve its transparent RGBA channel")
        self.assertEqual(ASSET_SHA256, hashlib.sha256(raw).hexdigest())

        manifest = json.loads(MANIFEST.read_text(encoding="utf-8"))
        canonical_assets = {entry["asset_id"]: entry for entry in manifest["assets"]}
        generated_candidates = {entry["asset_id"]: entry for entry in manifest["generated_candidates"]}
        self.assertIn(ASSET_ID, canonical_assets)
        self.assertNotIn(ASSET_ID, generated_candidates)
        asset = canonical_assets[ASSET_ID]
        self.assertEqual(ASSET_PATH, asset["path"])
        self.assertEqual([1774, 887], asset["dimensions"])
        self.assertEqual(ASSET_SHA256, asset["sha256"])
        self.assertEqual("USER_APPROVED_CANONICAL_PRODUCT_ASSET_RUNTIME_CONNECTED", asset["visual_role"])
        self.assertEqual("VERIFIED_AUTOMATED_RUNTIME", asset["consumer_status"])
        self.assertEqual("VERIFIED", asset["runtime_connection_status"])
        self.assertEqual("USER_APPROVED · CANON_REGISTERED", asset["pixel_review_status"])
        self.assertEqual(
            "game/demo/vertical_slice_demo.tscn::TitleScreen/TitleMargin/TitleColumns/TitleDeck/Content/TitleLogo",
            asset["runtime_consumer"],
        )

        scene = SCENE.read_text(encoding="utf-8")
        self.assertIn(f'path="res://{ASSET_PATH}"', scene)
        self.assertIn('[node name="TitleLogo" type="TextureRect"', scene)
        self.assertIn('texture = ExtResource("3_title_wordmark")', scene)

        decision = DECISION.read_text(encoding="utf-8")
        self.assertIn(ASSET_ID, decision)
        self.assertIn("USER_PIXEL_APPROVED", decision)
        self.assertIn("canonical product asset", decision)


if __name__ == "__main__":
    unittest.main()
