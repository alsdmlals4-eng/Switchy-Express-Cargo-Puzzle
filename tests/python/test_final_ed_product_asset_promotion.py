import importlib.util
import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
PRODUCT_ROOT = ROOT / "art" / "product_assets" / "ed_hybrid_v1"
PRODUCT_MANIFEST = PRODUCT_ROOT / "manifest.json"
CANDIDATE_MANIFEST = ROOT / "art" / "production_candidates" / "ed_hybrid_v1" / "manifest.json"
VALIDATOR_PATH = ROOT / "tools" / "validate_final_ed_product_asset_promotion.py"


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

    def test_static_validator_accepts_promoted_batch(self):
        self.assertTrue(
            VALIDATOR_PATH.is_file(),
            f"missing static promotion validator: {VALIDATOR_PATH.relative_to(ROOT)}",
        )
        spec = importlib.util.spec_from_file_location("final_ed_promotion_validator", VALIDATOR_PATH)
        validator = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(validator)
        self.assertEqual(0, validator.validate())


if __name__ == "__main__":
    unittest.main()
