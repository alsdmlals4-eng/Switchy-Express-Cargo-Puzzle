from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
POINTER = ROOT / "evidence/acceptance/post_sx_dec_060_candidate.json"
ARTIFACT = ROOT / "evidence/acceptance/sx60_poc_accept_005_artifact.json"
AUDIT = ROOT / "evidence/acceptance/sx60_poc_accept_005_pck_deep_audit.json"
ACCEPTANCE = ROOT / "기획서/50_제작_검증/SX_DEC_060_POC_ACCEPTANCE_CANDIDATE_05.md"


class SXDec065Candidate005MachineEvidenceTests(unittest.TestCase):
    def _json(self, path: Path) -> dict:
        self.assertTrue(path.is_file(), f"missing machine evidence owner: {path}")
        return json.loads(path.read_text(encoding="utf-8"))

    def test_candidate_005_remains_immutable_historical_evidence_after_route_book_bytes_changed(self) -> None:
        pointer = self._json(POINTER)
        historical = pointer["historical_superseded_after_sx_dec_066_route_book_01"]

        self.assertEqual("PREPARED_PACKAGE_VERIFIED", historical["candidate_status_at_invalidation"])
        self.assertEqual("SX60-POC-ACCEPT-005", historical["candidate_id"])
        self.assertEqual(
            "a11dfd1a063e434ee22e8cfb7b073ebc380aa27a",
            historical["source_main"],
        )
        self.assertEqual(
            "evidence/acceptance/sx60_poc_accept_005_artifact.json",
            historical["artifact_evidence_owner"],
        )
        self.assertEqual(
            "evidence/acceptance/sx60_poc_accept_005_pck_deep_audit.json",
            historical["deep_pck_evidence_owner"],
        )
        self.assertEqual(
            "SX_DEC_066_ROUTE_BOOK_01_PLAYER_FACING_RUNTIME_BYTE_CHANGE",
            historical["invalidation_reason"],
        )
        self.assertEqual(
            "HISTORICAL_SUPERSEDED_BY_SX_DEC_066_ROUTE_BOOK_01_PRODUCT_BYTE_CHANGE",
            historical["role"],
        )

    def test_artifact_and_deep_pck_audit_bind_every_machine_identity_value(self) -> None:
        pointer = self._json(POINTER)
        artifact = self._json(ARTIFACT)
        audit = self._json(AUDIT)

        historical = pointer["historical_superseded_after_sx_dec_066_route_book_01"]
        self.assertEqual(artifact["candidate_id"], historical["candidate_id"])
        self.assertEqual(
            artifact["source_build"]["main_sha"],
            historical["source_main"],
        )
        self.assertEqual(33301925424, artifact["artifact"]["workflow_run_id"])
        self.assertEqual(546, artifact["artifact"]["workflow_run_number"])
        self.assertEqual(9729236728, artifact["artifact"]["id"])
        self.assertEqual(
            "switchy-express-windows-demo-a11dfd1a063e434ee22e8cfb7b073ebc380aa27a",
            artifact["artifact"]["name"],
        )
        self.assertEqual(artifact["artifact"]["workflow_head_sha"], artifact["source_build"]["main_sha"])
        self.assertEqual("success", artifact["artifact"]["workflow_conclusion"])
        self.assertEqual(
            "90cb0e60bc0ddaf0124b1307647a155c5a663052673e34560e06dd4f4c1bf0ed",
            artifact["package"]["zip_sha256"],
        )
        self.assertEqual(
            "1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244",
            artifact["package"]["windows_exe_sha256"],
        )
        self.assertEqual(
            "f826523a976a6a844e3bc8df8e10c24cbd4cfc015c01db282a58a6dfa5a022b6",
            artifact["package"]["windows_pck_sha256"],
        )
        self.assertTrue(artifact["verification"]["artifact_api_digest_equals_downloaded_zip_sha256"])
        self.assertEqual("PASS · parsed_json=29", artifact["verification"]["windows_runtime_json"])
        self.assertEqual("PASS · parsed_json=29", artifact["verification"]["android_validation_runtime_json"])
        self.assertEqual("PASS", artifact["verification"]["package_integrity"])
        self.assertIn("POST_SX_DEC_060_CANDIDATE_CONTRACT: SX60-POC-ACCEPT-005", artifact["verification"]["launcher_contract_check"])
        self.assertIn("SX60-POC-ACCEPT-005 PACKAGE VERIFICATION: PASS (NoLaunch)", artifact["verification"]["launcher_no_launch_package_verification"])

        self.assertEqual(artifact["candidate_id"], audit["candidate_id"])
        self.assertEqual(557, audit["pck_integrity"]["file_count"])
        self.assertEqual(557, audit["pck_integrity"]["verified_entry_count"])
        self.assertEqual(0, audit["pck_integrity"]["md5_mismatch_count"])
        self.assertEqual(0, audit["pck_integrity"]["bounds_error_count"])
        self.assertTrue(audit["pck_integrity"]["integrity_pass"])
        packaging = audit["product_texture_packaging"]
        self.assertEqual(85, packaging["ed_hybrid_v1_prefix_entry_count"])
        self.assertEqual(23, packaging["ed_hybrid_v2_prefix_entry_count"])
        self.assertEqual(22, packaging["ed_hybrid_v2_runtime_png_import_count"])
        self.assertTrue(packaging["ed_hybrid_v2_master_source_excluded_from_package"])

    def test_machine_primary_policy_does_not_promote_human_evidence(self) -> None:
        artifact = self._json(ARTIFACT)
        audit = self._json(AUDIT)

        for evidence in (artifact["verification"], audit["evidence_ceiling"]):
            self.assertEqual(
                "NOT_REQUIRED_BY_USER_VALIDATION_POLICY",
                evidence["five_person_comprehension"],
            )
            self.assertEqual(
                "NOT_REQUIRED_BY_USER_VALIDATION_POLICY",
                evidence["player_experience"],
            )
            self.assertEqual("FINAL_USER_REVIEW · NOT_RUN", evidence["final_user_review"])
            self.assertEqual("NOT_RUN", evidence["windows_physical_runtime_full_scenarios"])
            self.assertEqual("NOT_RUN", evidence["audio_perceptual_qa"])

    def test_five_scope_adversarial_review_is_closed_without_evidence_promotion(self) -> None:
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
