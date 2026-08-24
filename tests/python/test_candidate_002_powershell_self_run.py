from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
LAUNCHER = ROOT / "RUN_SX59_POC_SELF_RUN.ps1"
EVIDENCE = ROOT / "evidence/acceptance/sx59_poc_accept_002_artifact.json"
SELF_RUN = ROOT / "기획서/50_제작_검증/SX_DEC_059_POC_DEVELOPER_SELF_RUN_RECORD_02.md"
WINDOWS_CONTRACT = ROOT / ".github/workflows/candidate-self-run-powershell.yml"


class Candidate002PowerShellSelfRunTests(unittest.TestCase):
    def _evidence(self) -> dict:
        self.assertTrue(EVIDENCE.is_file())
        return json.loads(EVIDENCE.read_text(encoding="utf-8"))

    def test_repo_root_launcher_exists_and_uses_canonical_evidence(self) -> None:
        self.assertTrue(LAUNCHER.is_file(), "repo-root PowerShell launcher is required")
        text = LAUNCHER.read_text(encoding="utf-8-sig")
        self.assertIn("sx59_poc_accept_002_artifact.json", text)
        self.assertIn("ConvertFrom-Json", text)
        self.assertIn("candidate_id", text)

    def test_launcher_does_not_duplicate_ephemeral_or_content_identity(self) -> None:
        evidence = self._evidence()
        text = LAUNCHER.read_text(encoding="utf-8-sig") if LAUNCHER.is_file() else ""
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
        text = LAUNCHER.read_text(encoding="utf-8-sig") if LAUNCHER.is_file() else ""
        for required in (
            "gh auth status",
            "gh api",
            "gh run download",
            "Get-FileHash",
            "Assert-Equal",
            "Assert-FileHash",
            "artifact_api_digest_equals_downloaded_zip_sha256",
            "Start-Process",
            "SwitchyExpressVerticalSlice.exe",
            "-NoLaunch",
        ):
            self.assertIn(required, text)
        self.assertIn("throw", text)

    def test_launcher_opens_the_existing_self_run_record_not_a_downloaded_toolkit_copy(self) -> None:
        self.assertTrue(SELF_RUN.is_file())
        text = LAUNCHER.read_text(encoding="utf-8-sig") if LAUNCHER.is_file() else ""
        self.assertIn("SX_DEC_059_POC_DEVELOPER_SELF_RUN_RECORD_02.md", text)
        self.assertNotIn("switchy_candidate002_self_run_toolkit", text)

    def test_windows_contract_parses_and_contract_checks_launcher(self) -> None:
        self.assertTrue(WINDOWS_CONTRACT.is_file(), "Windows PowerShell contract workflow is required")
        text = WINDOWS_CONTRACT.read_text(encoding="utf-8")
        self.assertIn("runs-on: windows-latest", text)
        self.assertIn("RUN_SX59_POC_SELF_RUN.ps1", text)
        self.assertIn("System.Management.Automation.Language.Parser", text)
        self.assertIn("-ContractCheck", text)


if __name__ == "__main__":
    unittest.main()
