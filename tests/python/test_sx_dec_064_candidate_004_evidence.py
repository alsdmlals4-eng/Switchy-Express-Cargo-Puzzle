from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
POINTER = ROOT / "evidence/acceptance/post_sx_dec_060_candidate.json"
ARTIFACT = ROOT / "evidence/acceptance/sx60_poc_accept_004_artifact.json"
AUDIT = ROOT / "evidence/acceptance/sx60_poc_accept_004_pck_deep_audit.json"


class SXDec064Candidate004EvidenceTests(unittest.TestCase):
    def _json(self, path: Path) -> dict:
        self.assertTrue(path.is_file(), f"missing required evidence owner: {path}")
        return json.loads(path.read_text(encoding="utf-8"))

    def test_historical_pointer_preserves_the_exact_post_route_lighting_export(self) -> None:
        pointer = self._json(POINTER)
        artifact = self._json(ARTIFACT)
        audit = self._json(AUDIT)

        self.assertEqual(pointer["candidate_status"], "PREPARED_PACKAGE_VERIFIED")
        self.assertEqual(pointer["current_candidate_id"], "SX60-POC-ACCEPT-005")
        historical = pointer["historical_superseded_after_sx_dec_063_core_board_v04"]
        self.assertEqual(historical["candidate_id"], "SX60-POC-ACCEPT-004")
        self.assertEqual(historical["source_main"], "58b99f261c3576150ab275bb041d744c69b83538")
        self.assertEqual(
            historical["artifact_evidence_owner"],
            "evidence/acceptance/sx60_poc_accept_004_artifact.json",
        )
        self.assertEqual(
            historical["deep_pck_evidence_owner"],
            "evidence/acceptance/sx60_poc_accept_004_pck_deep_audit.json",
        )
        self.assertEqual(artifact["candidate_id"], historical["candidate_id"])
        self.assertEqual(artifact["source_build"]["main_sha"], historical["source_main"])
        self.assertEqual(artifact["artifact"]["workflow_run_id"], 33190345143)
        self.assertEqual(artifact["artifact"]["id"], 9693500347)
        self.assertEqual(artifact["artifact"]["workflow_head_sha"], artifact["source_build"]["main_sha"])
        self.assertEqual(artifact["artifact"]["workflow_conclusion"], "success")
        self.assertEqual(
            artifact["package"]["zip_sha256"],
            "04e230e3d62c518b3d76ae4938964d2a1234a82949b7e2f4af4a3a447822f303",
        )
        self.assertEqual(
            artifact["package"]["windows_pck_sha256"],
            "3325f11115fdf3fc57e39bb35c545d115217614eb1e58607934edacf0c6b0839",
        )
        self.assertEqual(audit["candidate_id"], historical["candidate_id"])

    def test_deep_audit_and_evidence_ceiling_are_exact(self) -> None:
        artifact = self._json(ARTIFACT)
        audit = self._json(AUDIT)

        integrity = audit["pck_integrity"]
        self.assertTrue(integrity["integrity_pass"])
        self.assertEqual(integrity["file_count"], 500)
        self.assertEqual(integrity["verified_entry_count"], 500)
        textures = audit["product_texture_packaging"]
        self.assertEqual(textures["semantic_product_png_count"], 73)
        self.assertEqual(textures["runtime_presentation_png_count"], 6)
        self.assertEqual(textures["total_tracked_product_png_count"], 79)
        self.assertEqual(textures["product_png_import_count"], 79)
        self.assertEqual(textures["unique_referenced_ctex_count"], 79)
        self.assertEqual(textures["missing_ctex_reference_count"], 0)
        self.assertEqual(textures["orphan_packed_ctex_count"], 0)
        self.assertEqual(artifact["verification"]["windows_runtime_json"], "PASS · parsed_json=27")
        self.assertEqual(artifact["verification"]["android_validation_runtime_json"], "PASS · parsed_json=27")
        for key in (
            "windows_physical_startup_and_build_entry_automation_observed",
            "developer_self_run",
            "windows_physical_runtime_full_scenarios",
            "audio_perceptual_qa",
            "android_device",
            "five_person_comprehension",
            "player_experience",
        ):
            self.assertEqual(artifact["verification"][key], "NOT_RUN")


if __name__ == "__main__":
    unittest.main()
