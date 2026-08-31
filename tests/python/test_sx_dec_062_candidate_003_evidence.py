from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
POINTER = ROOT / "evidence/acceptance/post_sx_dec_060_candidate.json"
ARTIFACT = ROOT / "evidence/acceptance/sx60_poc_accept_003_artifact.json"
AUDIT = ROOT / "evidence/acceptance/sx60_poc_accept_003_pck_deep_audit.json"
CURRENT_DECISIONS = ROOT / "기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md"
ACTIVE_CONTEXT = ROOT / "기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md"


class SXDec062Candidate003EvidenceTests(unittest.TestCase):
    def _json(self, path: Path) -> dict:
        self.assertTrue(path.is_file(), f"missing required evidence owner: {path}")
        return json.loads(path.read_text(encoding="utf-8"))

    def test_historical_pointer_preserves_the_exact_main_export(self) -> None:
        pointer = self._json(POINTER)
        artifact = self._json(ARTIFACT)
        audit = self._json(AUDIT)

        self.assertEqual(pointer["candidate_status"], "NOT_MINTED")
        historical = pointer["historical_superseded_after_sx_dec_064"]
        self.assertIsNone(pointer["current_candidate_id"])
        self.assertEqual(historical["candidate_id"], "SX60-POC-ACCEPT-003")
        self.assertEqual(historical["source_main"], "8bce715b5045afebfb04d38108d2e3f7353e1b10")
        self.assertEqual(
            historical["artifact_evidence_owner"],
            "evidence/acceptance/sx60_poc_accept_003_artifact.json",
        )
        self.assertEqual(
            historical["deep_pck_evidence_owner"],
            "evidence/acceptance/sx60_poc_accept_003_pck_deep_audit.json",
        )
        self.assertEqual(artifact["candidate_id"], historical["candidate_id"])
        self.assertEqual(artifact["source_build"]["main_sha"], historical["source_main"])
        self.assertEqual(artifact["artifact"]["workflow_run_id"], 33159213393)
        self.assertEqual(artifact["artifact"]["id"], 9680934351)
        self.assertEqual(artifact["artifact"]["workflow_head_sha"], artifact["source_build"]["main_sha"])
        self.assertEqual(artifact["artifact"]["workflow_conclusion"], "success")
        self.assertEqual(
            artifact["package"]["zip_sha256"],
            "3ba9f8f79f8a8d011ba6094c184f9643a37251eaa779f1c9ebb8e50ba90086ba",
        )
        self.assertEqual(audit["candidate_id"], historical["candidate_id"])

    def test_deep_audit_preserves_the_current_asset_count_distinction_and_human_ceiling(self) -> None:
        artifact = self._json(ARTIFACT)
        audit = self._json(AUDIT)

        self.assertEqual(
            artifact["package"]["windows_pck_sha256"],
            "10481c5bafbcef32c805245134ba94745c1308cf91b1f633038fbfbef6c253f5",
        )
        self.assertTrue(audit["pck_integrity"]["integrity_pass"])
        self.assertEqual(audit["pck_integrity"]["file_count"], 495)
        self.assertEqual(audit["pck_integrity"]["verified_entry_count"], 495)
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
        self.assertEqual(
            artifact["verification"]["launcher_contract_check"],
            "PASS · 2026-08-28 · POST_SX_DEC_060_CANDIDATE_CONTRACT: SX60-POC-ACCEPT-003",
        )
        self.assertEqual(
            artifact["verification"]["launcher_no_launch_package_verification"],
            "PASS · 2026-08-28 · GitHub Actions Windows runner run 33161335690 · "
            "SX60-POC-ACCEPT-003 PACKAGE VERIFICATION: PASS (NoLaunch)",
        )
        for key in (
            "windows_physical_runtime_full_scenarios",
            "audio_perceptual_qa",
            "android_device",
            "five_person_comprehension",
            "player_experience",
        ):
            self.assertEqual(artifact["verification"][key], "NOT_RUN")

    def test_current_canon_marks_candidate_002_as_prior_byte_evidence(self) -> None:
        decisions = CURRENT_DECISIONS.read_text(encoding="utf-8")
        active_context = ACTIVE_CONTEXT.read_text(encoding="utf-8")

        self.assertIn("SX60-POC-ACCEPT-003 · HISTORICAL_SUPERSEDED_BY_SX_DEC_064_PRODUCT_BYTE_CHANGE", decisions)
        self.assertIn("SX60-POC-ACCEPT-002 · HISTORICAL_SUPERSEDED_BY_SX_DEC_062", decisions)
        self.assertIn(
            "post_sx_dec_060_candidate_status: NO_CURRENT_POST_SX_DEC_067_CANDIDATE · "
            "Candidate_006_historical · MINT_EXACT_SX_DEC_067_MACHINE_PACKAGE_CANDIDATE",
            active_context,
        )
        self.assertNotIn("SX-DEC-062 runtime/test/package/human result exists yet", decisions)


if __name__ == "__main__":
    unittest.main()
