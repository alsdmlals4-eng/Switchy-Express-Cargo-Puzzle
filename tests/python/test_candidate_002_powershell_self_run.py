from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
HISTORICAL_LAUNCHER = ROOT / "RUN_SX59_POC_SELF_RUN.ps1"
POST_060_LAUNCHER = ROOT / "RUN_SX60_POC_SELF_RUN.ps1"
POST_060_POINTER = ROOT / "evidence/acceptance/post_sx_dec_060_candidate.json"
OLD_EVIDENCE = ROOT / "evidence/acceptance/sx59_poc_accept_002_artifact.json"
WINDOWS_CONTRACT = ROOT / ".github/workflows/candidate-self-run-powershell.yml"


class CandidatePowerShellSelfRunTests(unittest.TestCase):
    def _post_060_pointer(self) -> dict:
        self.assertTrue(POST_060_POINTER.is_file())
        return json.loads(POST_060_POINTER.read_text(encoding="utf-8"))

    def test_historical_launcher_is_not_a_default_current_route(self) -> None:
        self.assertTrue(HISTORICAL_LAUNCHER.is_file())
        text = HISTORICAL_LAUNCHER.read_text(encoding="ascii")
        self.assertIn("current_poc_candidate.json", text)
        self.assertIn("[switch]$HistoricalEvidenceOnly", text)
        self.assertIn("HISTORICAL_EVIDENCE_ONLY", text)
        self.assertIn("gh run download", text)

    def test_post_060_launcher_reads_only_the_post_060_fail_closed_pointer(self) -> None:
        self.assertTrue(POST_060_LAUNCHER.is_file(), "post-060 launcher is required")
        text = POST_060_LAUNCHER.read_text(encoding="ascii")
        self.assertIn("post_sx_dec_060_candidate.json", text)
        self.assertIn("EXPLICIT_FAIL_CLOSED_POINTER_NO_NEWEST_INFERENCE", text)
        self.assertIn("POST_SX_DEC_060_CANDIDATE_NOT_CREATED", text)
        self.assertNotIn("current_poc_candidate.json", text)
        self.assertNotIn("SX59-POC-ACCEPT-003", text)
        self.assertNotIn("gh api", text)
        self.assertNotIn("gh run download", text)
        self.assertNotIn("Start-Process", text)

    def test_post_060_pointer_has_no_candidate_or_live_artifact_identity(self) -> None:
        pointer = self._post_060_pointer()
        self.assertEqual(pointer["candidate_status"], "NOT_CREATED")
        self.assertIsNone(pointer["current_candidate_id"])
        self.assertNotIn("artifact_evidence_owner", pointer)
        self.assertNotIn("deep_pck_evidence_owner", pointer)
        self.assertNotIn("self_run_record_name", pointer)

    def test_candidate_002_evidence_is_preserved_as_history(self) -> None:
        self.assertTrue(OLD_EVIDENCE.is_file())
        old = json.loads(OLD_EVIDENCE.read_text(encoding="utf-8"))
        self.assertEqual(old["candidate_id"], "SX59-POC-ACCEPT-002")
        self.assertEqual(
            old["package"]["zip_sha256"],
            "16c81f9b42a3391a2a3dabf501cb2d6eb7e011682abdaa3f79eb8b1124836e55",
        )

    def test_windows_contract_checks_post_060_fail_closed_state(self) -> None:
        self.assertTrue(WINDOWS_CONTRACT.is_file(), "Windows PowerShell contract workflow is required")
        text = WINDOWS_CONTRACT.read_text(encoding="utf-8")
        self.assertIn("runs-on: windows-latest", text)
        self.assertIn("RUN_SX60_POC_SELF_RUN.ps1", text)
        self.assertIn("post_sx_dec_060_candidate.json", text)
        self.assertIn("System.Management.Automation.Language.Parser", text)
        self.assertIn("-ContractCheck", text)
        self.assertIn("HistoricalEvidenceOnly -ContractCheck", text)
        self.assertIn("POST_SX_DEC_060_CANDIDATE_NOT_CREATED", text)
        self.assertIn("shell: powershell", text)
        self.assertNotIn("Prove current candidate download", text)
        self.assertNotIn("gh run download", text)


if __name__ == "__main__":
    unittest.main()
