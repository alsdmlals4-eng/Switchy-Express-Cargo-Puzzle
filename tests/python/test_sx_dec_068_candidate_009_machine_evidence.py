import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
POINTER = ROOT / "evidence/acceptance/post_sx_dec_060_candidate.json"
ARTIFACT = ROOT / "evidence/acceptance/sx60_poc_accept_009_artifact.json"
AUDIT = ROOT / "evidence/acceptance/sx60_poc_accept_009_pck_deep_audit.json"
ACCEPTANCE = ROOT / "기획서/50_제작_검증/SX_DEC_060_POC_ACCEPTANCE_CANDIDATE_09.md"
SELF_RUN = ROOT / "기획서/50_제작_검증/SX_DEC_060_POC_DEVELOPER_SELF_RUN_RECORD_09.md"


class SXDec068Candidate009MachineEvidenceTests(unittest.TestCase):
    def _json(self, path: Path) -> dict:
        return json.loads(path.read_text(encoding="utf-8"))

    def test_candidate_009_is_the_single_current_canonical_wordmark_package(self) -> None:
        pointer = self._json(POINTER)
        artifact = self._json(ARTIFACT)
        audit = self._json(AUDIT)

        self.assertEqual("PREPARED_PACKAGE_VERIFIED", pointer["candidate_status"])
        self.assertEqual("SX60-POC-ACCEPT-009", pointer["current_candidate_id"])
        self.assertEqual("1ac3099d9ab1451323cca2935547f82d210b50b4", pointer["minimum_product_source_main"])
        self.assertEqual(
            "MACHINE_PRIMARY_ACCEPTANCE_READY · POST_SX_DEC_068_CANONICAL_WORDMARK_PRODUCT_BYTES · "
            "FINAL_USER_REVIEW_NOT_RUN · TITLE_WORDMARK_USER_PIXEL_APPROVED_CANON_REGISTERED",
            pointer["current_candidate_role"],
        )
        self.assertEqual("SX60-POC-ACCEPT-009", artifact["candidate_id"])
        self.assertEqual(33396533310, artifact["artifact"]["workflow_run_id"])
        self.assertEqual(9759591197, artifact["artifact"]["id"])
        self.assertTrue(artifact["verification"]["artifact_api_digest_equals_downloaded_zip_sha256"])
        self.assertEqual("SX60-POC-ACCEPT-009", audit["candidate_id"])
        self.assertTrue(audit["pck_integrity"]["integrity_pass"])
        self.assertEqual(
            "USER_APPROVED_CANONICAL_PRODUCT_ASSET_RUNTIME_CONNECTED · USER_APPROVED · CANON_REGISTERED",
            audit["scope"]["title_wordmark_status_within_package"],
        )

    def test_candidate_009_preserves_the_machine_primary_evidence_ceiling(self) -> None:
        artifact = self._json(ARTIFACT)
        audit = self._json(AUDIT)

        for evidence in (artifact["verification"], audit["evidence_ceiling"]):
            self.assertEqual("NOT_REQUIRED_BY_USER_VALIDATION_POLICY", evidence["five_person_comprehension"])
            self.assertEqual("NOT_REQUIRED_BY_USER_VALIDATION_POLICY", evidence["player_experience"])
            self.assertEqual("FINAL_USER_REVIEW · NOT_RUN", evidence["final_user_review"])
            self.assertEqual("NOT_REQUIRED_FOR_MACHINE_PRIMARY_ACCEPTANCE · NOT_RUN", evidence["android_device"])
            self.assertEqual("USER_PIXEL_APPROVED · CANON_REGISTERED", evidence["title_wordmark_pixel_review"])

        for document in (ACCEPTANCE, SELF_RUN):
            text = document.read_text(encoding="utf-8")
            self.assertIn("SX60-POC-ACCEPT-009", text)
            self.assertIn("FINAL_USER_REVIEW_NOT_RUN", text)
            self.assertIn("USER_PIXEL_APPROVED", text)


if __name__ == "__main__":
    unittest.main()
