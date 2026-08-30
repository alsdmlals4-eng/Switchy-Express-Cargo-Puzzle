from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
POINTER = ROOT / "evidence/acceptance/post_sx_dec_060_candidate.json"
ARTIFACT = ROOT / "evidence/acceptance/sx60_poc_accept_001_artifact.json"
PCK_AUDIT = ROOT / "evidence/acceptance/sx60_poc_accept_001_pck_deep_audit.json"


class SXDec060CandidateMintTests(unittest.TestCase):
    def _json(self, path: Path) -> dict:
        self.assertTrue(path.is_file(), f"missing evidence owner: {path}")
        return json.loads(path.read_text(encoding="utf-8"))

    def test_old_exact_main_artifact_is_preserved_as_historical_evidence_after_candidate_005_mint(self) -> None:
        pointer = self._json(POINTER)
        artifact = self._json(ARTIFACT)
        audit = self._json(PCK_AUDIT)

        self.assertEqual(pointer["candidate_status"], "PREPARED_PACKAGE_VERIFIED")
        self.assertEqual(pointer["current_candidate_id"], "SX60-POC-ACCEPT-005")
        historical = pointer["historical_superseded_candidate"]
        self.assertEqual(historical["artifact_evidence_owner"], "evidence/acceptance/sx60_poc_accept_001_artifact.json")
        self.assertEqual(historical["deep_pck_evidence_owner"], "evidence/acceptance/sx60_poc_accept_001_pck_deep_audit.json")
        self.assertEqual(historical["invalidation_reason"], "PLAYER_FACING_RUNTIME_ROUTE_READABILITY_CHANGE")
        self.assertEqual(artifact["source_build"]["main_sha"], "7b7f350345619e870bb94e12954fbe81b1ef9403")
        self.assertEqual(artifact["artifact"]["id"], 9609930575)
        self.assertEqual(artifact["package"]["windows_pck_sha256"], "da0ec17fd55f5406bc68c2717666ec70a610087324c195a9a208cf67cc3a4920")
        self.assertTrue(audit["pck_integrity"]["integrity_pass"])
        self.assertEqual(audit["pck_integrity"]["file_count"], 477)
        self.assertEqual(audit["product_texture_packaging"]["product_png_import_count"], 73)
        self.assertEqual(
            pointer["historical_superseded_after_sx_dec_063_core_board_v04"]["artifact_evidence_owner"],
            "evidence/acceptance/sx60_poc_accept_004_artifact.json",
        )

    def test_candidate_does_not_promote_physical_or_human_evidence(self) -> None:
        artifact = self._json(ARTIFACT)
        self.assertEqual(
            artifact["verification"]["windows_physical_startup_and_build_entry_automation_observed"],
            "PASS · 2026-08-26 · title screen rendered and Demo Start reached the build board",
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


if __name__ == "__main__":
    unittest.main()
