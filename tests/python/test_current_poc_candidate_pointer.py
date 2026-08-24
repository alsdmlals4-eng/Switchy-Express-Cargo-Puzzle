from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
POINTER = ROOT / "evidence/acceptance/current_poc_candidate.json"
LAUNCHER = ROOT / "RUN_SX59_POC_SELF_RUN.ps1"


class CurrentPocCandidatePointerTests(unittest.TestCase):
    def _pointer(self) -> dict:
        self.assertTrue(POINTER.is_file(), "current candidate pointer is required")
        return json.loads(POINTER.read_text(encoding="utf-8"))

    def test_pointer_selects_candidate_003_without_inference(self) -> None:
        pointer = self._pointer()
        self.assertEqual(pointer["schema_version"], 1)
        self.assertEqual(pointer["current_candidate_id"], "SX59-POC-ACCEPT-003")
        self.assertEqual(
            pointer["artifact_evidence_owner"],
            "evidence/acceptance/sx59_poc_accept_003_artifact.json",
        )
        self.assertEqual(
            pointer["self_run_record_name"],
            "SX_DEC_059_POC_DEVELOPER_SELF_RUN_RECORD_03.md",
        )
        self.assertEqual(pointer["selection_policy"], "EXPLICIT_FAIL_CLOSED_POINTER_NO_NEWEST_INFERENCE")

    def test_pointer_and_candidate_evidence_agree(self) -> None:
        pointer = self._pointer()
        evidence_path = ROOT / pointer["artifact_evidence_owner"]
        self.assertTrue(evidence_path.is_file())
        evidence = json.loads(evidence_path.read_text(encoding="utf-8"))
        self.assertEqual(evidence["candidate_id"], pointer["current_candidate_id"])
        self.assertEqual(evidence["artifact"]["workflow_run_id"], 32715351609)
        self.assertEqual(
            evidence["package"]["zip_sha256"],
            "8b4e630c667b5fd88886878e5a07401c1fe6cfd8f1f9d84b2ab39cb8824923d4",
        )
        self.assertEqual(
            evidence["package"]["windows_exe_sha256"],
            "1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244",
        )
        self.assertEqual(
            evidence["package"]["windows_pck_sha256"],
            "2e9634cedd6da49793973f4582e2bd58ea4daae2fec246657edcf58ae360af72",
        )

    def test_launcher_reads_pointer_instead_of_hardcoding_candidate_002_or_003(self) -> None:
        text = LAUNCHER.read_text(encoding="ascii")
        self.assertIn("current_poc_candidate.json", text)
        self.assertIn("artifact_evidence_owner", text)
        self.assertIn("self_run_record_name", text)
        self.assertNotIn("sx59_poc_accept_002_artifact.json", text)
        self.assertNotIn("sx59_poc_accept_003_artifact.json", text)
        self.assertNotIn("SX59-POC-ACCEPT-002", text)
        self.assertNotIn("SX59-POC-ACCEPT-003", text)

    def test_candidate_002_evidence_remains_immutable_history(self) -> None:
        old_evidence = ROOT / "evidence/acceptance/sx59_poc_accept_002_artifact.json"
        self.assertTrue(old_evidence.is_file())
        old = json.loads(old_evidence.read_text(encoding="utf-8"))
        self.assertEqual(old["candidate_id"], "SX59-POC-ACCEPT-002")
        self.assertEqual(
            old["package"]["zip_sha256"],
            "16c81f9b42a3391a2a3dabf501cb2d6eb7e011682abdaa3f79eb8b1124836e55",
        )


if __name__ == "__main__":
    unittest.main()
