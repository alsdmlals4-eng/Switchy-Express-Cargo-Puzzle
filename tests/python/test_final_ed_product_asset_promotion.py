import importlib.util
import json
import struct
import tempfile
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
PRODUCT_ROOT = ROOT / "art" / "product_assets" / "ed_hybrid_v1"
PRODUCT_MANIFEST = PRODUCT_ROOT / "manifest.json"
SEMANTIC_MANIFEST = PRODUCT_ROOT / "semantic_manifest_sx_dec_054.json"
BUILD_SEMANTIC_MANIFEST = PRODUCT_ROOT / "semantic_manifest_sx_dec_054_build_2b.json"
CANDIDATE_MANIFEST = ROOT / "art" / "production_candidates" / "ed_hybrid_v1" / "manifest.json"
VALIDATOR_PATH = ROOT / "tools" / "validate_final_ed_product_asset_promotion.py"
LOCOMOTIVE_SOURCE = "art/production_candidates/ed_hybrid_v1/core/core_train_locomotive_blue_normal_v01.png"
LOCOMOTIVE_PRODUCT = "art/product_assets/ed_hybrid_v1/core/core_train_locomotive_blue_normal_v01.png"
CONTROLS_SOURCE = "art/production_candidates/ed_hybrid_v1/ui/ui_button_controls_states_v01.png"
APPROVED_LOCOMOTIVE_REFERENCE_SHA256 = "edd9b76558755e1fa603d5d3c373be57e9325055a2a1f5c92ff0b0bda88f5b8d"
APPROVED_CONTROLS_REFERENCE_SHA256 = "34f4fefeabdd0030b0689868899cd71e4cf694e475f12280bb75ea61aa25d6d7"

CONTROL_PRODUCT_PATHS = {
    f"art/product_assets/ed_hybrid_v1/ui/ui_button_frame_square_blue_{state}_v01.png"
    for state in ("normal", "hover", "pressed", "selected", "disabled", "locked", "focus")
}

CORE_PRODUCT_PATHS = {
    LOCOMOTIVE_PRODUCT,
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

AUTHORITATIVE_SLICE_PRODUCTS = {
    "art/product_assets/ed_hybrid_v1/run/run_stack_empty_v01.png": (
        "art/production_candidates/ed_hybrid_v1/run/run_stack_hud_states_v01.png",
        "run_stack_empty_v01",
        [70, 74, 44, 18],
    ),
    "art/product_assets/ed_hybrid_v1/run/run_stack_32plus_v01.png": (
        "art/production_candidates/ed_hybrid_v1/run/run_stack_hud_states_v01.png",
        "run_stack_32plus_v01",
        [70, 16, 42, 18],
    ),
    "art/product_assets/ed_hybrid_v1/run/run_stack_unloading_v01.png": (
        "art/production_candidates/ed_hybrid_v1/run/run_stack_hud_states_v01.png",
        "run_stack_unloading_v01",
        [69, 44, 45, 18],
    ),
    "art/product_assets/ed_hybrid_v1/run/run_stack_top_highlight_v01.png": (
        "art/production_candidates/ed_hybrid_v1/run/run_stack_hud_states_v01.png",
        "run_stack_top_highlight_v01",
        [10, 8, 42, 25],
    ),
    "art/product_assets/ed_hybrid_v1/build/build_track_straight_valid_ghost_v01.png": (
        "art/production_candidates/ed_hybrid_v1/build/build_placement_preview_states_v01.png",
        "build_track_straight_valid_ghost_v01",
        [4, 4, 36, 30],
    ),
    "art/product_assets/ed_hybrid_v1/build/build_track_straight_invalid_ghost_v01.png": (
        "art/production_candidates/ed_hybrid_v1/build/build_placement_preview_states_v01.png",
        "build_track_straight_invalid_ghost_v01",
        [46, 4, 36, 30],
    ),
    "art/product_assets/ed_hybrid_v1/build/build_track_curve_valid_ghost_v01.png": (
        "art/production_candidates/ed_hybrid_v1/build/build_placement_preview_states_v01.png",
        "build_track_curve_valid_ghost_v01",
        [88, 4, 36, 30],
    ),
    "art/product_assets/ed_hybrid_v1/build/build_port_marker_left_v01.png": (
        "art/production_candidates/ed_hybrid_v1/build/build_placement_preview_states_v01.png",
        "build_port_marker_left_v01",
        [6, 53, 30, 26],
    ),
}


def _load_validator():
    spec = importlib.util.spec_from_file_location("final_ed_promotion_validator", VALIDATOR_PATH)
    validator = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(validator)
    return validator


class FinalEdProductAssetPromotionContractTest(unittest.TestCase):
    def test_product_manifest_exists_for_approved_promotion(self):
        self.assertTrue(PRODUCT_MANIFEST.is_file())

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
        self.assertEqual(39, data["promoted_asset_count"])
        dispositions = {r["disposition"] for r in data["source_candidate_dispositions"]}
        self.assertLessEqual(dispositions, {"PROMOTE_AS_IS", "PROMOTE_AFTER_REVISION", "REPLACE"})

    def test_authoritative_slice_batch_matches_candidate_manifest_exactly(self):
        candidate = json.loads(CANDIDATE_MANIFEST.read_text(encoding="utf-8"))
        product = json.loads(PRODUCT_MANIFEST.read_text(encoding="utf-8"))
        candidate_by_path = {record["path"]: record for record in candidate["assets"]}
        product_by_path = {record["path"]: record for record in product["assets"]}

        self.assertLessEqual(set(AUTHORITATIVE_SLICE_PRODUCTS), set(product_by_path))
        self.assertEqual(
            8,
            sum(1 for record in product["assets"] if record.get("authoritative_slice_name")),
        )

        for product_path, (source_path, slice_name, bounds) in AUTHORITATIVE_SLICE_PRODUCTS.items():
            source_slices = {
                item["name"]: item["bounds"]
                for item in candidate_by_path[source_path].get("slices", [])
            }
            self.assertEqual(bounds, source_slices[slice_name])
            record = product_by_path[product_path]
            self.assertEqual(source_path, record["source_candidate"])
            self.assertEqual("PROMOTE_AFTER_REVISION", record["disposition"])
            self.assertEqual(slice_name, record["authoritative_slice_name"])
            self.assertEqual("crop", record["transform"]["kind"])
            self.assertEqual(bounds, record["transform"]["bounds"])
            self.assertEqual(bounds[2:4], record["dimensions"])
            self.assertTrue((ROOT / product_path).is_file())

    def test_import_safe_hero_and_controls_recover_from_exact_approved_references(self):
        data = json.loads(PRODUCT_MANIFEST.read_text(encoding="utf-8"))
        assets = {record["path"]: record for record in data["assets"]}
        dispositions = {record["source_candidate"]: record for record in data["source_candidate_dispositions"]}

        self.assertLessEqual(CORE_PRODUCT_PATHS | CONTROL_PRODUCT_PATHS, set(assets))
        self.assertEqual("REPLACE", dispositions[LOCOMOTIVE_SOURCE]["disposition"])
        self.assertEqual("REPLACE", dispositions[CONTROLS_SOURCE]["disposition"])

        locomotive = assets[LOCOMOTIVE_PRODUCT]
        self.assertEqual(1.0, locomotive["visual_scale"])
        self.assertEqual("approved_reference_recovery", locomotive["transform"]["kind"])
        self.assertEqual(APPROVED_LOCOMOTIVE_REFERENCE_SHA256, locomotive["recovery_reference"]["sha256"])

        for path in CONTROL_PRODUCT_PATHS:
            control = assets[path]
            self.assertEqual("approved_reference_recovery", control["transform"]["kind"])
            self.assertEqual(APPROVED_CONTROLS_REFERENCE_SHA256, control["recovery_reference"]["sha256"])

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
        self.assertTrue(info[-1])

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
        self.assertEqual([], failures)

    def test_every_product_png_has_exactly_one_manifest_owner(self):
        base = json.loads(PRODUCT_MANIFEST.read_text(encoding="utf-8"))
        run_semantic = json.loads(SEMANTIC_MANIFEST.read_text(encoding="utf-8"))
        build_semantic = json.loads(BUILD_SEMANTIC_MANIFEST.read_text(encoding="utf-8"))
        actual = {path.relative_to(ROOT).as_posix() for path in PRODUCT_ROOT.rglob("*.png")}
        base_recorded = [record["path"] for record in base["assets"]]
        run_recorded = [record["path"] for record in run_semantic["semantic_assets"]]
        build_recorded = [record["path"] for record in build_semantic["semantic_assets"]]

        self.assertEqual(39, len(base_recorded))
        self.assertEqual(20, len(run_recorded))
        self.assertEqual(8, len(build_recorded))
        self.assertEqual(len(base_recorded), len(set(base_recorded)))
        self.assertEqual(len(run_recorded), len(set(run_recorded)))
        self.assertEqual(len(build_recorded), len(set(build_recorded)))

        base_paths = set(base_recorded)
        run_paths = set(run_recorded)
        build_paths = set(build_recorded)
        self.assertTrue(base_paths.isdisjoint(run_paths))
        self.assertTrue(base_paths.isdisjoint(build_paths))
        self.assertTrue(run_paths.isdisjoint(build_paths))
        self.assertEqual(67, len(base_paths | run_paths | build_paths))
        self.assertEqual(actual, base_paths | run_paths | build_paths)

    def test_static_validator_accepts_promoted_batch(self):
        validator = _load_validator()
        self.assertEqual(0, validator.validate())


if __name__ == "__main__":
    unittest.main()