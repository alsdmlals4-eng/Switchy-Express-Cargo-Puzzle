import importlib.util
import json
import struct
import tempfile
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
PRODUCT_ROOT = ROOT / "art" / "product_assets" / "ed_hybrid_v1"
PRODUCT_MANIFEST = PRODUCT_ROOT / "manifest.json"
CANDIDATE_MANIFEST = ROOT / "art" / "production_candidates" / "ed_hybrid_v1" / "manifest.json"
VALIDATOR_PATH = ROOT / "tools" / "validate_final_ed_product_asset_promotion.py"
LOCOMOTIVE_SOURCE = "art/production_candidates/ed_hybrid_v1/core/core_train_locomotive_blue_normal_v01.png"
LOCOMOTIVE_PRODUCT = "art/product_assets/ed_hybrid_v1/core/core_train_locomotive_blue_normal_v01.png"

CORE_PRODUCT_PATHS = {
    "art/product_assets/ed_hybrid_v1/core/core_wagon_cargo_red_normal_v02.png",
    "art/product_assets/ed_hybrid_v1/core/core_wagon_cargo_blue_normal_v02.png",
    "art/product_assets/ed_hybrid_v1/core/core_wagon_cargo_yellow_normal_v02.png",
    "art/product_assets/ed_hybrid_v1/core/core_cargo_star_red_normal_v01.png",
    "art/product_assets/ed_hybrid_v1/core/core_cargo_star_blue_normal_v01.png",
    "art/product_assets/ed_hybrid_v1/core/core_cargo_star_yellow_normal_v01.png",
    "art/product_assets/ed_hybrid_v1/core/core_station_red_normal_v01.png",
    "art/product_assets/ed_hybrid_v1/core/core_station_blue_normal_v01.png",
    "art/product_assets/ed_hybrid_v1/core/core_station_yellow_normal_v01.png",
    "art/product_assets/ed_hybrid_v1/core/core_rail_straight_normal_v01.png",
    "art/product_assets/ed_hybrid_v1/core/core_rail_curve_normal_v01.png",
    "art/product_assets/ed_hybrid_v1/core/core_rail_crossing_normal_v01.png",
    "art/product_assets/ed_hybrid_v1/core/core_rail_switch_three_way_normal_v01.png",
    "art/product_assets/ed_hybrid_v1/core/core_marker_start_normal_v01.png",
    "art/product_assets/ed_hybrid_v1/core/core_marker_route_end_normal_v01.png",
}


def _load_validator():
    spec = importlib.util.spec_from_file_location("final_ed_promotion_validator", VALIDATOR_PATH)
    validator = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(validator)
    return validator


class FinalEdProductAssetPromotionContractTest(unittest.TestCase):
    def test_product_manifest_exists_for_approved_promotion(self):
        self.assertTrue(
            PRODUCT_MANIFEST.is_file(),
            f"missing approved product asset manifest: {PRODUCT_MANIFEST.relative_to(ROOT)}",
        )

    def test_candidate_source_remains_complete_and_unmodified_in_authority(self):
        data = json.loads(CANDIDATE_MANIFEST.read_text(encoding="utf-8"))
        self.assertEqual("SX-DEC-051", data["decision_id"])
        self.assertEqual(31, data["candidate_count"])
        self.assertFalse(data["runtime_integrated"])
        self.assertFalse(data["final_asset_approved"])

    def test_product_manifest_declares_sx_dec_053_contract(self):
        data = json.loads(PRODUCT_MANIFEST.read_text(encoding="utf-8"))
        self.assertEqual("SX-DEC-053", data["decision_id"])
        self.assertEqual("E+D HYBRID · NEO-ARCADE READABILITY", data["art_direction"])
        self.assertFalse(data["runtime_integrated"])
        self.assertEqual(31, data["source_candidate_count"])
        self.assertEqual(31, len(data["source_candidate_dispositions"]))
        dispositions = {r["disposition"] for r in data["source_candidate_dispositions"]}
        self.assertLessEqual(
            dispositions,
            {"PROMOTE_AS_IS", "PROMOTE_AFTER_REVISION", "REPLACE"},
        )

    def test_first_import_safe_core_batch_keeps_corrupt_locomotive_pending(self):
        data = json.loads(PRODUCT_MANIFEST.read_text(encoding="utf-8"))
        assets = {record["path"]: record for record in data["assets"]}
        dispositions = {
            record["source_candidate"]: record for record in data["source_candidate_dispositions"]
        }
        self.assertLessEqual(CORE_PRODUCT_PATHS, set(assets))
        self.assertNotIn(LOCOMOTIVE_PRODUCT, assets)
        locomotive = dispositions[LOCOMOTIVE_SOURCE]
        self.assertEqual("PROMOTE_AFTER_REVISION", locomotive["disposition"])
        self.assertIn("Godot", locomotive["reason"])
        for color in ("red", "blue", "yellow"):
            wagon = assets[f"art/product_assets/ed_hybrid_v1/core/core_wagon_cargo_{color}_normal_v02.png"]
            self.assertEqual("centered_scale", wagon["transform"]["kind"])
            self.assertAlmostEqual(0.74, wagon["visual_scale"], places=6)
            self.assertGreaterEqual(wagon["visual_scale"], 0.70)
            self.assertLessEqual(wagon["visual_scale"], 0.75)

    def test_palette_png_with_trns_is_alpha_capable(self):
        validator = _load_validator()
        station = PRODUCT_ROOT / "core" / "core_station_red_normal_v01.png"
        info = validator._png_info(station)
        self.assertTrue(info[-1], "palette PNG with tRNS must count as alpha-capable")

    def test_png_parser_rejects_corrupted_idat_stream(self):
        validator = _load_validator()
        source = PRODUCT_ROOT / "core" / "core_wagon_cargo_blue_normal_v02.png"
        raw = bytearray(source.read_bytes())
        pos = 8
        corrupted = False
        while pos + 12 <= len(raw):
            length = struct.unpack(">I", raw[pos:pos + 4])[0]
            chunk_type = bytes(raw[pos + 4:pos + 8])
            if chunk_type == b"IDAT" and length > 8:
                raw[pos + 8 + length // 2] ^= 0x01
                corrupted = True
                break
            pos += 12 + length
        self.assertTrue(corrupted)
        with tempfile.TemporaryDirectory() as temp_dir:
            bad = Path(temp_dir) / "corrupt.png"
            bad.write_bytes(raw)
            with self.assertRaises(ValueError):
                validator._png_info(bad)

    def test_every_promote_as_is_source_is_png_decodable(self):
        validator = _load_validator()
        data = json.loads(PRODUCT_MANIFEST.read_text(encoding="utf-8"))
        failures = []
        for record in data["source_candidate_dispositions"]:
            if record["disposition"] != "PROMOTE_AS_IS":
                continue
            source = ROOT / record["source_candidate"]
            try:
                validator._png_info(source)
            except ValueError as exc:
                failures.append(f"{record['source_candidate']}: {exc}")
        self.assertEqual([], failures, "PROMOTE_AS_IS candidates must be valid decodable PNG sources")

    def test_every_product_png_is_manifested_exactly_once(self):
        data = json.loads(PRODUCT_MANIFEST.read_text(encoding="utf-8"))
        actual = {
            path.relative_to(ROOT).as_posix()
            for path in PRODUCT_ROOT.rglob("*.png")
        }
        recorded = [record["path"] for record in data["assets"]]
        self.assertEqual(len(recorded), len(set(recorded)), "product manifest paths must be unique")
        self.assertEqual(actual, set(recorded), "every product PNG must be represented in the product manifest")

    def test_static_validator_accepts_promoted_batch(self):
        self.assertTrue(
            VALIDATOR_PATH.is_file(),
            f"missing static promotion validator: {VALIDATOR_PATH.relative_to(ROOT)}",
        )
        validator = _load_validator()
        self.assertEqual(0, validator.validate())


if __name__ == "__main__":
    unittest.main()
