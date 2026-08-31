from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
POINTER = ROOT / "evidence/acceptance/post_sx_dec_060_candidate.json"
ARTIFACT = ROOT / "evidence/acceptance/sx60_poc_accept_007_artifact.json"
AUDIT = ROOT / "evidence/acceptance/sx60_poc_accept_007_pck_deep_audit.json"
ACCEPTANCE = ROOT / "기획서/50_제작_검증/SX_DEC_060_POC_ACCEPTANCE_CANDIDATE_07.md"
SELF_RUN = ROOT / "기획서/50_제작_검증/SX_DEC_060_POC_DEVELOPER_SELF_RUN_RECORD_07.md"


class SXDec067Candidate007MachineEvidenceTests(unittest.TestCase):
    def _json(self, path: Path) -> dict:
        self.assertTrue(path.is_file(), f"missing evidence owner: {path}")
        return json.loads(path.read_text(encoding="utf-8"))

    def test_exact_sx_dec_067_candidate_is_the_only_current_pointer(self) -> None:
        pointer = self._json(POINTER)

        self.assertEqual("PREPARED_PACKAGE_VERIFIED", pointer["candidate_status"])
        self.assertEqual("SX60-POC-ACCEPT-007", pointer["current_candidate_id"])
        self.assertEqual(
            "MACHINE_PRIMARY_ACCEPTANCE_READY · POST_SX_DEC_067_EXACT_PRODUCT_BYTES · "
            "FINAL_USER_REVIEW_NOT_RUN",
            pointer["current_candidate_role"],
        )
        self.assertEqual(
            "evidence/acceptance/sx60_poc_accept_007_artifact.json",
            pointer["artifact_evidence_owner"],
        )
        self.assertEqual(
            "evidence/acceptance/sx60_poc_accept_007_pck_deep_audit.json",
            pointer["deep_pck_evidence_owner"],
        )
        self.assertEqual(
            "기획서/50_제작_검증/SX_DEC_060_POC_ACCEPTANCE_CANDIDATE_07.md",
            pointer["acceptance_candidate_document"],
        )
        self.assertEqual("SX_DEC_060_POC_DEVELOPER_SELF_RUN_RECORD_07.md", pointer["self_run_record_name"])
        self.assertEqual(
            "c0bb86efa5bad6050217ca67dd6aa9eba155dc75",
            pointer["minimum_product_source_main"],
        )
        self.assertEqual("FINAL_USER_REVIEW_ON_UNCHANGED_SX60_POC_ACCEPT_007", pointer["current_next_action"])

    def test_artifact_and_pck_audit_bind_the_exact_machine_package(self) -> None:
        artifact = self._json(ARTIFACT)
        audit = self._json(AUDIT)

        self.assertEqual("SX60-POC-ACCEPT-007", artifact["candidate_id"])
        self.assertEqual("c0bb86efa5bad6050217ca67dd6aa9eba155dc75", artifact["source_build"]["main_sha"])
        self.assertEqual(33382094895, artifact["artifact"]["workflow_run_id"])
        self.assertEqual(563, artifact["artifact"]["workflow_run_number"])
        self.assertEqual(9754181081, artifact["artifact"]["id"])
        self.assertEqual("success", artifact["artifact"]["workflow_conclusion"])
        self.assertEqual(
            "a48b689bcbe40fc229663ed8a1b254e876f210851cec43963cb8db72af6ff3ef",
            artifact["package"]["zip_sha256"],
        )
        self.assertEqual(
            "1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244",
            artifact["package"]["windows_exe_sha256"],
        )
        self.assertEqual(
            "e848f9932c90210aa8e05b187dd69180c161258ad236ad0c5a278ecaa52669c4",
            artifact["package"]["windows_pck_sha256"],
        )
        self.assertEqual(
            "5e127d1ec3ad584a5cc89a2d65f5b5a2f122911b92eef5c03a8852b85b18005d",
            artifact["package"]["android_validation_pck_sha256"],
        )
        self.assertTrue(artifact["verification"]["artifact_api_digest_equals_downloaded_zip_sha256"])
        self.assertEqual("PASS · 240 passed, 2 skipped", artifact["verification"]["python_contracts"])
        self.assertEqual("PASS · 120 cases, 14053 assertions, 0 failed", artifact["verification"]["godot_headless"])
        self.assertEqual("PASS · parsed_json=31", artifact["verification"]["windows_runtime_json"])
        self.assertEqual("PASS · parsed_json=31", artifact["verification"]["android_validation_runtime_json"])

        self.assertEqual("SX60-POC-ACCEPT-007", audit["candidate_id"])
        self.assertEqual(599, audit["pck_integrity"]["file_count"])
        self.assertEqual(599, audit["pck_integrity"]["verified_entry_count"])
        self.assertEqual(0, audit["pck_integrity"]["md5_mismatch_count"])
        self.assertEqual(0, audit["pck_integrity"]["bounds_error_count"])
        self.assertTrue(audit["pck_integrity"]["integrity_pass"])
        self.assertEqual(12, audit["route_book_packaging"]["map_json_entry_count"])
        self.assertEqual(2, audit["route_book_packaging"]["definition_json_entry_count"])
        self.assertEqual(31, audit["product_texture_packaging"]["ed_hybrid_v2_prefix_entry_count"])

    def test_candidate_keeps_machine_primary_evidence_boundary_and_documents_review(self) -> None:
        artifact = self._json(ARTIFACT)
        audit = self._json(AUDIT)

        for evidence in (artifact["verification"], audit["evidence_ceiling"]):
            self.assertEqual("NOT_REQUIRED_BY_USER_VALIDATION_POLICY", evidence["five_person_comprehension"])
            self.assertEqual("NOT_REQUIRED_BY_USER_VALIDATION_POLICY", evidence["player_experience"])
            self.assertEqual("FINAL_USER_REVIEW · NOT_RUN", evidence["final_user_review"])
            self.assertEqual("NOT_RUN", evidence["windows_physical_runtime_full_scenarios"])
            self.assertEqual("NOT_RUN", evidence["audio_perceptual_qa"])
            self.assertEqual("NOT_REQUIRED_FOR_MACHINE_PRIMARY_ACCEPTANCE · NOT_RUN", evidence["android_device"])

        for document in (ACCEPTANCE, SELF_RUN):
            self.assertTrue(document.is_file(), f"missing candidate document: {document}")
            text = document.read_text(encoding="utf-8")
            self.assertIn("SX60-POC-ACCEPT-007", text)
            self.assertIn("FINAL_USER_REVIEW_NOT_RUN", text)


if __name__ == "__main__":
    unittest.main()
