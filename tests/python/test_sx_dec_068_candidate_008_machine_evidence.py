from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
POINTER = ROOT / "evidence/acceptance/post_sx_dec_060_candidate.json"
ARTIFACT = ROOT / "evidence/acceptance/sx60_poc_accept_008_artifact.json"
AUDIT = ROOT / "evidence/acceptance/sx60_poc_accept_008_pck_deep_audit.json"
ACCEPTANCE = ROOT / "기획서/50_제작_검증/SX_DEC_060_POC_ACCEPTANCE_CANDIDATE_08.md"
SELF_RUN = ROOT / "기획서/50_제작_검증/SX_DEC_060_POC_DEVELOPER_SELF_RUN_RECORD_08.md"
ACTIVE_CONTEXT = ROOT / "기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md"
CURRENT_DECISIONS = ROOT / "기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md"
DEVELOPMENT_GATES = ROOT / "기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md"


class SXDec068Candidate008MachineEvidenceTests(unittest.TestCase):
    def _json(self, path: Path) -> dict:
        self.assertTrue(path.is_file(), f"missing evidence owner: {path}")
        return json.loads(path.read_text(encoding="utf-8"))

    def _text(self, path: Path) -> str:
        self.assertTrue(path.is_file(), f"missing current owner: {path}")
        return path.read_text(encoding="utf-8")

    def test_candidate_008_is_preserved_as_historical_pre_canonical_status_evidence(self) -> None:
        pointer = self._json(POINTER)
        artifact = self._json(ARTIFACT)

        self.assertEqual("PREPARED_PACKAGE_VERIFIED", pointer["candidate_status"])
        self.assertEqual("SX60-POC-ACCEPT-010", pointer["current_candidate_id"])
        self.assertIn("PASS", artifact["verification"]["launcher_contract_check"])
        self.assertEqual(
            "MACHINE_PRIMARY_ACCEPTANCE_READY · POST_SX_DEC_069_TRANSPARENT_WAYSIDE_SPEED_TRANSITION_PRODUCT_BYTES · "
            "FINAL_USER_REVIEW_NOT_RUN · TITLE_WORDMARK_USER_PIXEL_APPROVED_CANON_REGISTERED · "
            "V02_WAYSIDE_USER_PIXEL_REVIEW_PENDING",
            pointer["current_candidate_role"],
        )
        self.assertEqual("79323ff0175b674c594d18dfd6d28a8e9951f5bd", pointer["minimum_product_source_main"])
        self.assertEqual("evidence/acceptance/sx60_poc_accept_010_artifact.json", pointer["artifact_evidence_owner"])
        self.assertEqual("evidence/acceptance/sx60_poc_accept_010_pck_deep_audit.json", pointer["deep_pck_evidence_owner"])
        self.assertEqual("기획서/50_제작_검증/SX_DEC_060_POC_ACCEPTANCE_CANDIDATE_10.md", pointer["acceptance_candidate_document"])
        self.assertEqual("SX_DEC_060_POC_DEVELOPER_SELF_RUN_RECORD_10.md", pointer["self_run_record_name"])
        self.assertEqual(
            "FINAL_USER_REVIEW_ON_UNCHANGED_SX60_POC_ACCEPT_010",
            pointer["current_next_action"],
        )

        historical = pointer["historical_superseded_after_sx_dec_068"]
        self.assertEqual("SX60-POC-ACCEPT-007", historical["candidate_id"])
        self.assertEqual("c0bb86efa5bad6050217ca67dd6aa9eba155dc75", historical["source_main"])
        self.assertEqual("53e29f874bc70a0057c310d661dc45dbecc6cf13", historical["invalidated_by_product_source_main"])
        candidate_008_history = pointer["historical_superseded_after_sx_dec_068_canonical_wordmark_status"]
        self.assertEqual("SX60-POC-ACCEPT-008", candidate_008_history["candidate_id"])
        self.assertEqual("53e29f874bc70a0057c310d661dc45dbecc6cf13", candidate_008_history["source_main"])
        self.assertEqual("1ac3099d9ab1451323cca2935547f82d210b50b4", candidate_008_history["invalidated_by_product_source_main"])

    def test_artifact_and_pck_audit_bind_the_exact_machine_package(self) -> None:
        artifact = self._json(ARTIFACT)
        audit = self._json(AUDIT)

        self.assertEqual("SX60-POC-ACCEPT-008", artifact["candidate_id"])
        self.assertEqual("53e29f874bc70a0057c310d661dc45dbecc6cf13", artifact["source_build"]["main_sha"])
        self.assertEqual(33392296685, artifact["artifact"]["workflow_run_id"])
        self.assertEqual(572, artifact["artifact"]["workflow_run_number"])
        self.assertEqual(9757983433, artifact["artifact"]["id"])
        self.assertEqual("success", artifact["artifact"]["workflow_conclusion"])
        self.assertEqual("f11fc0dc64ac59ce86d581bdb68e5833d79e92ec6345112c470a5f3a26b9902a", artifact["package"]["zip_sha256"])
        self.assertEqual("587559f1360c7cc532b06a6a001c09dfd1ad1373de23603cc489f6cfccc24658", artifact["package"]["windows_pck_sha256"])
        self.assertEqual("2e4bb743ec53f6bd0e410c36786bd79a3c3172861107d5b92e2c933aacd4fb82", artifact["package"]["android_validation_pck_sha256"])
        self.assertTrue(artifact["verification"]["artifact_api_digest_equals_downloaded_zip_sha256"])
        self.assertEqual("PASS · 250 passed, 2 skipped", artifact["verification"]["python_contracts"])
        self.assertEqual("PASS · 120 cases, 14125 assertions, 0 failed", artifact["verification"]["godot_headless"])

        self.assertEqual("SX60-POC-ACCEPT-008", audit["candidate_id"])
        self.assertEqual(575, audit["pck_integrity"]["file_count"])
        self.assertEqual(575, audit["pck_integrity"]["verified_entry_count"])
        self.assertEqual(0, audit["pck_integrity"]["md5_mismatch_count"])
        self.assertEqual(0, audit["pck_integrity"]["bounds_error_count"])
        self.assertTrue(audit["pck_integrity"]["integrity_pass"])
        self.assertEqual(32, audit["product_texture_packaging"]["ed_hybrid_v2_prefix_entry_count"])
        self.assertEqual(1, audit["product_texture_packaging"]["sx_dec_068_title_wordmark_runtime_asset_import_count"])
        self.assertEqual(0, audit["export_hygiene"]["evidence_prefix_entry_count"])
        self.assertEqual(0, audit["export_hygiene"]["output_prefix_entry_count"])

    def test_candidate_keeps_machine_primary_and_wordmark_review_boundaries(self) -> None:
        artifact = self._json(ARTIFACT)
        audit = self._json(AUDIT)

        for evidence in (artifact["verification"], audit["evidence_ceiling"]):
            self.assertEqual("NOT_REQUIRED_BY_USER_VALIDATION_POLICY", evidence["five_person_comprehension"])
            self.assertEqual("NOT_REQUIRED_BY_USER_VALIDATION_POLICY", evidence["player_experience"])
            self.assertEqual("FINAL_USER_REVIEW · NOT_RUN", evidence["final_user_review"])
            self.assertEqual("NOT_REQUIRED_FOR_MACHINE_PRIMARY_ACCEPTANCE · NOT_RUN", evidence["android_device"])
            self.assertEqual("USER_PIXEL_REVIEW_PENDING · NOT_CANON", evidence["title_wordmark_pixel_review"])

        for document in (ACCEPTANCE, SELF_RUN):
            text = self._text(document)
            self.assertIn("SX60-POC-ACCEPT-008", text)
            self.assertIn("FINAL_USER_REVIEW_NOT_RUN", text)
            self.assertIn("USER_PIXEL_REVIEW_PENDING", text)

    def test_current_owners_point_to_candidate_010_and_retain_candidate_008_as_history(self) -> None:
        active = self._text(ACTIVE_CONTEXT)
        decisions = self._text(CURRENT_DECISIONS)
        gates = self._text(DEVELOPMENT_GATES)

        for text in (active, decisions, gates):
            self.assertIn("SX60-POC-ACCEPT-008", text)
            self.assertIn("SX60-POC-ACCEPT-010", text)
            self.assertIn("FINAL_USER_REVIEW_NOT_RUN", text)
            self.assertIn("USER_PIXEL_APPROVED", text)

        self.assertIn("remaining_machine_executable_required_work: NONE", active)
        self.assertIn("FINAL_USER_REVIEW_ON_UNCHANGED_SX60_POC_ACCEPT_010", active)


if __name__ == "__main__":
    unittest.main()
