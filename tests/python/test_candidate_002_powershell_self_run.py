from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
LAUNCHER = ROOT / "RUN_SX59_POC_SELF_RUN.ps1"
POINTER = ROOT / "evidence/acceptance/current_poc_candidate.json"
OLD_EVIDENCE = ROOT / "evidence/acceptance/sx59_poc_accept_002_artifact.json"
WINDOWS_CONTRACT = ROOT / ".github/workflows/candidate-self-run-powershell.yml"


class CurrentCandidatePowerShellSelfRunTests(unittest.TestCase):
    def _pointer(self) -> dict:
        self.assertTrue(POINTER.is_file())
        return json.loads(POINTER.read_text(encoding="utf-8"))

    def _current_evidence(self) -> dict:
        pointer = self._pointer()
        path = ROOT / pointer["artifact_evidence_owner"]
        self.assertTrue(path.is_file())
        return json.loads(path.read_text(encoding="utf-8"))

    def test_repo_root_launcher_uses_explicit_current_pointer(self) -> None:
        self.assertTrue(LAUNCHER.is_file(), "repo-root PowerShell launcher is required")
        text = LAUNCHER.read_text(encoding="ascii")
        self.assertIn("current_poc_candidate.json", text)
        self.assertIn("artifact_evidence_owner", text)
        self.assertIn("self_run_record_name", text)
        self.assertIn("ConvertFrom-Json", text)
        self.assertIn("current_candidate_id", text)
        self.assertNotIn("sx59_poc_accept_002_artifact.json", text)
        self.assertNotIn("SX59-POC-ACCEPT-002", text)
        self.assertNotIn("SX59-POC-ACCEPT-003", text)

    def test_launcher_does_not_duplicate_current_ephemeral_or_content_identity(self) -> None:
        evidence = self._current_evidence()
        text = LAUNCHER.read_text(encoding="ascii")
        forbidden_literals = (
            str(evidence["artifact"]["id"]),
            evidence["artifact"]["name"],
            evidence["package"]["zip_sha256"],
            evidence["package"]["windows_exe_sha256"],
            evidence["package"]["windows_pck_sha256"],
        )
        for value in forbidden_literals:
            self.assertNotIn(value, text, f"launcher duplicated canonical evidence literal: {value}")

    def test_launcher_downloads_with_gh_and_fails_closed_before_launch(self) -> None:
        text = LAUNCHER.read_text(encoding="ascii")
        for required in (
            "gh auth status",
            "gh api",
            "gh run download",
            "Get-FileHash",
            "Assert-Equal",
            "Assert-FileHash",
            "artifact_api_digest_equals_downloaded_zip_sha256",
            "EXPLICIT_FAIL_CLOSED_POINTER_NO_NEWEST_INFERENCE",
            "Start-Process",
            "SwitchyExpressVerticalSlice.exe",
            "-NoLaunch",
        ):
            self.assertIn(required, text)
        self.assertIn("throw", text)
        self.assertIn("No fallback to another build is allowed", text)

    def test_launcher_is_ascii_safe_for_windows_powershell_51(self) -> None:
        raw = LAUNCHER.read_bytes()
        text = raw.decode("ascii")
        self.assertIn("#Requires -Version 5.1", text)
        self.assertNotIn("기획서", text)

    def test_launcher_opens_pointer_selected_self_run_record(self) -> None:
        pointer = self._pointer()
        record_name = pointer["self_run_record_name"]
        matches = list(ROOT.rglob(record_name))
        self.assertEqual(len(matches), 1)
        text = LAUNCHER.read_text(encoding="ascii")
        self.assertIn("self_run_record_name", text)
        self.assertIn("Resolve-UniqueFile", text)
        self.assertNotIn("switchy_candidate002_self_run_toolkit", text)

    def test_candidate_002_evidence_is_preserved_as_history(self) -> None:
        self.assertTrue(OLD_EVIDENCE.is_file())
        old = json.loads(OLD_EVIDENCE.read_text(encoding="utf-8"))
        self.assertEqual(old["candidate_id"], "SX59-POC-ACCEPT-002")
        self.assertEqual(
            old["package"]["zip_sha256"],
            "16c81f9b42a3391a2a3dabf501cb2d6eb7e011682abdaa3f79eb8b1124836e55",
        )

    def test_windows_contract_tracks_pointer_and_live_verifies_current_candidate(self) -> None:
        self.assertTrue(WINDOWS_CONTRACT.is_file(), "Windows PowerShell contract workflow is required")
        text = WINDOWS_CONTRACT.read_text(encoding="utf-8")
        self.assertIn("runs-on: windows-latest", text)
        self.assertIn("RUN_SX59_POC_SELF_RUN.ps1", text)
        self.assertIn("current_poc_candidate.json", text)
        self.assertIn("System.Management.Automation.Language.Parser", text)
        self.assertIn("-ContractCheck", text)
        self.assertIn("shell: powershell", text)
        self.assertIn("Prove current candidate download and package verification on Windows", text)
        self.assertIn("GH_TOKEN: ${{ github.token }}", text)
        self.assertNotIn("Candidate 002 download", text)


if __name__ == "__main__":
    unittest.main()
