import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
POINTER = ROOT / "evidence/acceptance/post_sx_dec_060_candidate.json"
ARTIFACT = ROOT / "evidence/acceptance/sx60_poc_accept_010_artifact.json"
AUDIT = ROOT / "evidence/acceptance/sx60_poc_accept_010_pck_deep_audit.json"
ACCEPTANCE = ROOT / "기획서/50_제작_검증/SX_DEC_060_POC_ACCEPTANCE_CANDIDATE_10.md"
SELF_RUN = ROOT / "기획서/50_제작_검증/SX_DEC_060_POC_DEVELOPER_SELF_RUN_RECORD_10.md"


class SXDec069Candidate010MachineEvidenceTests(unittest.TestCase):
    def _json(self, path: Path) -> dict:
        return json.loads(path.read_text(encoding="utf-8"))

    def test_candidate_010_is_the_single_current_transparent_wayside_package(self) -> None:
        pointer = self._json(POINTER)
        artifact = self._json(ARTIFACT)
        audit = self._json(AUDIT)

        self.assertEqual("PREPARED_PACKAGE_VERIFIED", pointer["candidate_status"])
        self.assertEqual("SX60-POC-ACCEPT-010", pointer["current_candidate_id"])
        self.assertEqual("79323ff0175b674c594d18dfd6d28a8e9951f5bd", pointer["minimum_product_source_main"])
        self.assertEqual(
            "MACHINE_PRIMARY_ACCEPTANCE_READY · POST_SX_DEC_069_TRANSPARENT_WAYSIDE_SPEED_TRANSITION_PRODUCT_BYTES · "
            "FINAL_USER_REVIEW_NOT_RUN · TITLE_WORDMARK_USER_PIXEL_APPROVED_CANON_REGISTERED · "
            "V02_WAYSIDE_USER_PIXEL_REVIEW_PENDING",
            pointer["current_candidate_role"],
        )
        self.assertEqual("SX60-POC-ACCEPT-010", artifact["candidate_id"])
        self.assertEqual(33415291733, artifact["artifact"]["workflow_run_id"])
        self.assertEqual(9766817524, artifact["artifact"]["id"])
        self.assertTrue(artifact["verification"]["artifact_api_digest_equals_downloaded_zip_sha256"])
        self.assertEqual("SX60-POC-ACCEPT-010", audit["candidate_id"])
        self.assertTrue(audit["pck_integrity"]["integrity_pass"])
        self.assertEqual(591, audit["pck_integrity"]["file_count"])
        self.assertEqual(39, audit["product_texture_packaging"]["ed_hybrid_v2_runtime_png_import_count"])
        self.assertEqual(8, audit["product_texture_packaging"]["sx_dec_069_transparent_runtime_asset_import_count"])
        self.assertEqual(
            "GENERATED_CANDIDATE_RUNTIME_CONNECTED_NOT_CANON · USER_PIXEL_REVIEW_PENDING",
            audit["scope"]["wayside_v02_asset_status_within_package"],
        )

    def test_candidate_010_preserves_machine_primary_and_historical_boundaries(self) -> None:
        pointer = self._json(POINTER)
        artifact = self._json(ARTIFACT)
        audit = self._json(AUDIT)

        historical = pointer["historical_superseded_after_sx_dec_069"]
        self.assertEqual("SX60-POC-ACCEPT-009", historical["candidate_id"])
        self.assertEqual("1ac3099d9ab1451323cca2935547f82d210b50b4", historical["source_main"])
        self.assertEqual(
            "HISTORICAL_SUPERSEDED_BY_SX_DEC_069_TRANSPARENT_WAYSIDE_SPEED_TRANSITION_PRODUCT_BYTE_CHANGE",
            historical["role"],
        )

        for evidence in (artifact["verification"], audit["evidence_ceiling"]):
            self.assertEqual("NOT_REQUIRED_BY_USER_VALIDATION_POLICY", evidence["five_person_comprehension"])
            self.assertEqual("NOT_REQUIRED_BY_USER_VALIDATION_POLICY", evidence["player_experience"])
            self.assertEqual("FINAL_USER_REVIEW · NOT_RUN", evidence["final_user_review"])
            self.assertEqual("NOT_REQUIRED_FOR_MACHINE_PRIMARY_ACCEPTANCE · NOT_RUN", evidence["android_device"])
            self.assertEqual("USER_PIXEL_APPROVED · CANON_REGISTERED", evidence["title_wordmark_pixel_review"])
            self.assertEqual("USER_PIXEL_REVIEW_PENDING", evidence["wayside_v02_pixel_review"])

        for document in (ACCEPTANCE, SELF_RUN):
            text = document.read_text(encoding="utf-8")
            self.assertIn("SX60-POC-ACCEPT-010", text)
            self.assertIn("FINAL_USER_REVIEW_NOT_RUN", text)
            self.assertIn("USER_PIXEL_REVIEW_PENDING", text)


if __name__ == "__main__":
    unittest.main()
