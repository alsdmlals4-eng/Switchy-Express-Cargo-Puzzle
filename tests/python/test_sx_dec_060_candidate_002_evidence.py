from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
POINTER = ROOT / "evidence/acceptance/post_sx_dec_060_candidate.json"
ARTIFACT = ROOT / "evidence/acceptance/sx60_poc_accept_002_artifact.json"
AUDIT = ROOT / "evidence/acceptance/sx60_poc_accept_002_pck_deep_audit.json"
CURRENT_DECISIONS = ROOT / "기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md"


class SXDec060Candidate002EvidenceTests(unittest.TestCase):
    def _json(self, path: Path) -> dict:
        self.assertTrue(path.is_file(), f"missing required evidence owner: {path}")
        return json.loads(path.read_text(encoding="utf-8"))

    def test_current_pointer_binds_candidate_002_to_the_exact_successful_export(self) -> None:
        pointer = self._json(POINTER)
        artifact = self._json(ARTIFACT)
        audit = self._json(AUDIT)

        self.assertEqual(pointer["candidate_status"], "PREPARED_PACKAGE_VERIFIED")
        self.assertEqual(pointer["current_candidate_id"], "SX60-POC-ACCEPT-002")
        self.assertEqual(pointer["minimum_product_source_main"], "a8eee4f875a95e8da69802c4e60452df3535fe0e")
        self.assertEqual(
            pointer["artifact_evidence_owner"],
            "evidence/acceptance/sx60_poc_accept_002_artifact.json",
        )
        self.assertEqual(
            pointer["deep_pck_evidence_owner"],
            "evidence/acceptance/sx60_poc_accept_002_pck_deep_audit.json",
        )
        self.assertEqual(artifact["candidate_id"], pointer["current_candidate_id"])
        self.assertEqual(artifact["source_build"]["main_sha"], "0e882764b837d13282a7642b115948d4e061d163")
        self.assertEqual(artifact["artifact"]["workflow_run_id"], 33030116761)
        self.assertEqual(artifact["artifact"]["workflow_head_sha"], artifact["source_build"]["main_sha"])
        self.assertEqual(artifact["artifact"]["workflow_conclusion"], "success")
        self.assertEqual(artifact["artifact"]["id"], 9629917429)
        self.assertEqual(
            artifact["package"]["zip_sha256"],
            "b2602554ec28ba8597cc509c6dc2e1b61a946ca193a31673ed96bf9671c8c8e3",
        )
        self.assertEqual(audit["candidate_id"], pointer["current_candidate_id"])

    def test_deep_audit_is_package_complete_without_promoting_human_gates(self) -> None:
        artifact = self._json(ARTIFACT)
        audit = self._json(AUDIT)

        self.assertEqual(
            artifact["package"]["windows_pck_sha256"],
            "d360eb70b0182e3409b8c60a18e214e5324dd4af619e97b484d3c9dd9a27cd49",
        )
        self.assertTrue(audit["pck_integrity"]["integrity_pass"])
        self.assertEqual(audit["pck_integrity"]["file_count"], 479)
        self.assertEqual(audit["pck_integrity"]["verified_entry_count"], 479)
        textures = audit["product_texture_packaging"]
        self.assertEqual(textures["product_png_import_count"], 73)
        self.assertEqual(textures["unique_referenced_ctex_count"], 73)
        self.assertEqual(textures["missing_ctex_reference_count"], 0)
        self.assertEqual(textures["orphan_packed_ctex_count"], 0)
        self.assertEqual(
            artifact["verification"]["launcher_no_launch_package_verification"],
            "PASS · 2026-08-27 · explicit Candidate 002 NoLaunch PowerShell verification",
        )
        for key in (
            "developer_self_run",
            "windows_physical_runtime_full_scenarios",
            "audio_perceptual_qa",
            "android_device",
            "five_person_comprehension",
            "player_experience",
        ):
            self.assertEqual(artifact["verification"][key], "NOT_RUN")

    def test_current_decisions_do_not_promote_unexecuted_candidate_002_physical_evidence(self) -> None:
        text = CURRENT_DECISIONS.read_text(encoding="utf-8")

        self.assertNotIn("candidate_002_windows_physical_startup_smoke: PASS", text)
        self.assertNotIn("candidate_002_result: BLOCKED_BY_CONFIRMED_P1_PREFLIGHT_VISUAL_DEFECTS", text)
        self.assertIn("candidate_002_windows_physical_startup_smoke: NOT_RUN", text)


if __name__ == "__main__":
    unittest.main()
