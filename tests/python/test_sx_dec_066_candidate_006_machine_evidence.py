from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
POINTER = ROOT / "evidence/acceptance/post_sx_dec_060_candidate.json"
ARTIFACT = ROOT / "evidence/acceptance/sx60_poc_accept_006_artifact.json"
AUDIT = ROOT / "evidence/acceptance/sx60_poc_accept_006_pck_deep_audit.json"
ACCEPTANCE = ROOT / "기획서/50_제작_검증/SX_DEC_060_POC_ACCEPTANCE_CANDIDATE_06.md"


class SXDec066Candidate006MachineEvidenceTests(unittest.TestCase):
    def _json(self, path: Path) -> dict:
        self.assertTrue(path.is_file(), f"missing machine evidence owner: {path}")
        return json.loads(path.read_text(encoding="utf-8"))

    def test_pointer_preserves_route_book_candidate_006_as_historical_after_sx_dec_067(self) -> None:
        pointer = self._json(POINTER)

        self.assertEqual("PREPARED_PACKAGE_VERIFIED", pointer["candidate_status"])
        self.assertEqual("SX60-POC-ACCEPT-007", pointer["current_candidate_id"])
        self.assertEqual(
            "9af5a8c46d29ea6781f9ee06008d7c7d2cde1877",
            pointer["historical_superseded_after_sx_dec_067"]["source_main"],
        )
        self.assertEqual(
            "evidence/acceptance/sx60_poc_accept_006_artifact.json",
            pointer["historical_superseded_after_sx_dec_067"]["artifact_evidence_owner"],
        )
        self.assertEqual(
            "evidence/acceptance/sx60_poc_accept_006_pck_deep_audit.json",
            pointer["historical_superseded_after_sx_dec_067"]["deep_pck_evidence_owner"],
        )
        self.assertIn("MACHINE_PRIMARY_ACCEPTANCE_READY", pointer["current_candidate_role"])
        self.assertIn("POST_SX_DEC_067_EXACT_PRODUCT_BYTES", pointer["current_candidate_role"])

    def test_artifact_and_deep_audit_bind_the_route_book_package(self) -> None:
        pointer = self._json(POINTER)
        artifact = self._json(ARTIFACT)
        audit = self._json(AUDIT)

        historical = pointer["historical_superseded_after_sx_dec_067"]
        self.assertEqual(artifact["candidate_id"], historical["candidate_id"])
        self.assertEqual(artifact["source_build"]["main_sha"], historical["source_main"])
        self.assertEqual(33308989848, artifact["artifact"]["workflow_run_id"])
        self.assertEqual(551, artifact["artifact"]["workflow_run_number"])
        self.assertEqual(9731396797, artifact["artifact"]["id"])
        self.assertEqual("success", artifact["artifact"]["workflow_conclusion"])
        self.assertEqual(
            "fd55b69e86114e0b334983be7ae8c241a6f3709fbd9cc6fa9cdf00439fd4b888",
            artifact["package"]["zip_sha256"],
        )
        self.assertEqual(
            "1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244",
            artifact["package"]["windows_exe_sha256"],
        )
        self.assertEqual(
            "1081187807e7f7a6b31cacf423e44da677d876dd5ad8ed81d3bae54a6b001311",
            artifact["package"]["windows_pck_sha256"],
        )
        self.assertTrue(artifact["verification"]["artifact_api_digest_equals_downloaded_zip_sha256"])
        self.assertEqual("PASS · parsed_json=30", artifact["verification"]["windows_runtime_json"])
        self.assertEqual("PASS · parsed_json=30", artifact["verification"]["android_validation_runtime_json"])

        self.assertEqual(artifact["candidate_id"], audit["candidate_id"])
        self.assertEqual(571, audit["pck_integrity"]["file_count"])
        self.assertEqual(571, audit["pck_integrity"]["verified_entry_count"])
        self.assertEqual(0, audit["pck_integrity"]["md5_mismatch_count"])
        self.assertEqual(0, audit["pck_integrity"]["bounds_error_count"])
        self.assertTrue(audit["pck_integrity"]["integrity_pass"])
        self.assertEqual(6, audit["route_book_packaging"]["map_json_entry_count"])
        self.assertEqual(1, audit["route_book_packaging"]["definition_json_entry_count"])

    def test_machine_primary_policy_does_not_promote_human_evidence(self) -> None:
        artifact = self._json(ARTIFACT)
        audit = self._json(AUDIT)

        for evidence in (artifact["verification"], audit["evidence_ceiling"]):
            self.assertEqual("NOT_REQUIRED_BY_USER_VALIDATION_POLICY", evidence["five_person_comprehension"])
            self.assertEqual("NOT_REQUIRED_BY_USER_VALIDATION_POLICY", evidence["player_experience"])
            self.assertEqual("FINAL_USER_REVIEW · NOT_RUN", evidence["final_user_review"])
            self.assertEqual("NOT_RUN", evidence["windows_physical_runtime_full_scenarios"])
            self.assertEqual("NOT_RUN", evidence["audio_perceptual_qa"])

    def test_five_scope_adversarial_review_remains_explicit(self) -> None:
        text = ACCEPTANCE.read_text(encoding="utf-8")
        for required in (
            "FIVE_SCOPE_ADVERSARIAL_REVIEW_CLOSED",
            "1. Artifact identity and source drift",
            "2. Runtime consumer and scope expansion",
            "3. Evidence-ceiling inflation",
            "4. Asset provenance and package membership",
            "5. Reproducibility and fail-closed recovery",
        ):
            self.assertIn(required, text)


if __name__ == "__main__":
    unittest.main()
