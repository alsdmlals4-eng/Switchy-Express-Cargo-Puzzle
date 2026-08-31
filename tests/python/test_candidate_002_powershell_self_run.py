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

    def test_historical_launcher_retains_exact_byte_verification_without_literal_duplication(self) -> None:
        text = HISTORICAL_LAUNCHER.read_text(encoding="ascii")
        for required in (
            "gh auth status",
            "gh api",
            "gh run download",
            "Get-FileHash",
            "Assert-FileHash",
            "artifact_api_digest_equals_downloaded_zip_sha256",
            "EXPLICIT_FAIL_CLOSED_POINTER_NO_NEWEST_INFERENCE",
            "SwitchyExpressVerticalSlice.exe",
            "-NoLaunch",
            "No fallback to another build is allowed",
        ):
            self.assertIn(required, text)
        historical_pointer = json.loads(
            (ROOT / "evidence/acceptance/current_poc_candidate.json").read_text(encoding="utf-8")
        )
        evidence = json.loads(
            (ROOT / historical_pointer["artifact_evidence_owner"]).read_text(encoding="utf-8")
        )
        for value in (
            str(evidence["artifact"]["id"]),
            evidence["artifact"]["name"],
            evidence["package"]["zip_sha256"],
            evidence["package"]["windows_exe_sha256"],
            evidence["package"]["windows_pck_sha256"],
        ):
            self.assertNotIn(value, text, f"historical launcher duplicated immutable evidence literal: {value}")

    def test_post_060_launcher_verifies_only_the_explicit_post_change_candidate(self) -> None:
        self.assertTrue(POST_060_LAUNCHER.is_file(), "post-060 launcher is required")
        text = POST_060_LAUNCHER.read_text(encoding="ascii")
        self.assertIn("post_sx_dec_060_candidate.json", text)
        self.assertIn("EXPLICIT_FAIL_CLOSED_POINTER_NO_NEWEST_INFERENCE", text)
        self.assertIn("POST_SX_DEC_060_CANDIDATE_CONTRACT", text)
        self.assertNotIn("current_poc_candidate.json", text)
        self.assertNotIn("SX59-POC-ACCEPT-003", text)
        self.assertIn("gh api", text)
        self.assertIn("actions/runs", text)
        self.assertIn("live workflow head SHA", text)
        self.assertIn("live workflow conclusion", text)
        self.assertIn("gh run download", text)
        self.assertIn("Start-Process", text)
        self.assertIn("WorkDir must be a direct child of TEMP", text)
        self.assertIn("RUNNER_TEMP", text)

    def test_post_060_pointer_fails_closed_while_preserving_historical_evidence(self) -> None:
        pointer = self._post_060_pointer()
        self.assertEqual(pointer["candidate_status"], "NOT_MINTED")
        self.assertIsNone(pointer["current_candidate_id"])
        self.assertIn("FAIL_CLOSED", pointer["current_candidate_role"])
        self.assertEqual(
            pointer["historical_superseded_candidate"]["invalidation_reason"],
            "PLAYER_FACING_RUNTIME_ROUTE_READABILITY_CHANGE",
        )
        self.assertEqual(pointer["historical_superseded_after_sx_dec_067"]["artifact_evidence_owner"], "evidence/acceptance/sx60_poc_accept_006_artifact.json")
        self.assertEqual(pointer["historical_superseded_after_sx_dec_067"]["deep_pck_evidence_owner"], "evidence/acceptance/sx60_poc_accept_006_pck_deep_audit.json")
        self.assertEqual(pointer["historical_superseded_after_sx_dec_067"]["self_run_record_name"], "SX_DEC_060_POC_DEVELOPER_SELF_RUN_RECORD_06.md")
        self.assertEqual(
            pointer["historical_superseded_after_sx_dec_062"]["candidate_id"],
            "SX60-POC-ACCEPT-002",
        )
        self.assertEqual(
            pointer["historical_superseded_after_sx_dec_064"]["candidate_id"],
            "SX60-POC-ACCEPT-003",
        )
        self.assertEqual(
            pointer["historical_superseded_after_sx_dec_063_core_board_v04"]["candidate_id"],
            "SX60-POC-ACCEPT-004",
        )

    def test_candidate_002_evidence_is_preserved_as_history(self) -> None:
        self.assertTrue(OLD_EVIDENCE.is_file())
        old = json.loads(OLD_EVIDENCE.read_text(encoding="utf-8"))
        self.assertEqual(old["candidate_id"], "SX59-POC-ACCEPT-002")
        self.assertEqual(
            old["package"]["zip_sha256"],
            "16c81f9b42a3391a2a3dabf501cb2d6eb7e011682abdaa3f79eb8b1124836e55",
        )

    def test_windows_contract_verifies_the_explicit_post_060_candidate(self) -> None:
        self.assertTrue(WINDOWS_CONTRACT.is_file(), "Windows PowerShell contract workflow is required")
        text = WINDOWS_CONTRACT.read_text(encoding="utf-8")
        self.assertIn("runs-on: windows-latest", text)
        self.assertIn("fetch-depth: 0", text)
        self.assertIn("RUN_SX60_POC_SELF_RUN.ps1", text)
        self.assertIn("post_sx_dec_060_candidate.json", text)
        self.assertIn("System.Management.Automation.Language.Parser", text)
        self.assertIn("-ContractCheck", text)
        self.assertIn("HistoricalEvidenceOnly -ContractCheck", text)
        self.assertIn("Verify post-060 explicit candidate contract", text)
        self.assertIn("Verify post-060 candidate package without launch", text)
        self.assertIn("-ContractCheck", text)
        self.assertIn("id: post060_candidate", text)
        self.assertIn("candidate_status=", text)
        self.assertIn(
            "steps.post060_candidate.outputs.candidate_status != 'NOT_CREATED' && "
            "steps.post060_candidate.outputs.candidate_status != 'NOT_MINTED'",
            text,
        )
        self.assertIn("switchy-post-060-candidate-002", text)
        self.assertIn("evidence/acceptance/sx60_poc_accept_*_artifact.json", text)
        self.assertIn("SX_DEC_060_POC_ACCEPTANCE_CANDIDATE_*.md", text)
        self.assertIn("SX_DEC_060_POC_DEVELOPER_SELF_RUN_RECORD_*.md", text)
        self.assertIn("tests/python/test_sx_dec_060_candidate_mint.py", text)
        self.assertIn("shell: powershell", text)
        self.assertIn("Verify historical pre-SX-DEC-060 Candidate 003 exact bytes", text)
        self.assertIn("GH_TOKEN: ${{ github.token }}", text)
        self.assertIn("switchy-historical-candidate-003", text)


if __name__ == "__main__":
    unittest.main()
