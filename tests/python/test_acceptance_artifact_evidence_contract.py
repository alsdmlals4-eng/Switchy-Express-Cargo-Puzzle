from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
EVIDENCE = ROOT / "evidence/acceptance/sx59_poc_accept_002_artifact.json"
CANDIDATE = ROOT / "기획서/50_제작_검증/SX_DEC_059_POC_ACCEPTANCE_CANDIDATE_02.md"
SELF_RUN = ROOT / "기획서/50_제작_검증/SX_DEC_059_POC_DEVELOPER_SELF_RUN_RECORD_02.md"
AUDIT = ROOT / "기획서/50_제작_검증/SX_AUD_069_PLAYABLE_VISUAL_UX_POC.md"
WORKFLOW = ROOT / ".github/workflows/windows-demo-export.yml"


class AcceptanceArtifactEvidenceContractTests(unittest.TestCase):
    def _load_evidence(self) -> dict:
        self.assertTrue(
            EVIDENCE.is_file(),
            "current acceptance candidate must have one machine-readable artifact evidence owner",
        )
        return json.loads(EVIDENCE.read_text(encoding="utf-8"))

    def test_artifact_api_digest_matches_independently_downloaded_zip(self) -> None:
        evidence = self._load_evidence()
        artifact = evidence["artifact"]
        package = evidence["package"]
        self.assertEqual(evidence["candidate_id"], "SX59-POC-ACCEPT-002")
        self.assertEqual(artifact["workflow_run_id"], 32692759675)
        self.assertEqual(artifact["workflow_head_sha"], "159a3a741ef79b6207be290cc284bd63a5979e72")
        self.assertEqual(artifact["api_digest_sha256"], package["zip_sha256"])
        self.assertTrue(package["windows_exe_sha256"])
        self.assertTrue(package["windows_pck_sha256"])

    def test_candidate_and_audit_read_hashes_from_the_single_evidence_owner(self) -> None:
        evidence = self._load_evidence()
        artifact = evidence["artifact"]
        package = evidence["package"]
        expected = (
            f"artifact_id: {artifact['id']}",
            f"artifact_name: {artifact['name']}",
            f"artifact_expires_at: {artifact['expires_at']}",
            f"artifact_zip_sha256: {package['zip_sha256']}",
            f"windows_exe_sha256: {package['windows_exe_sha256']}",
            f"windows_pck_sha256: {package['windows_pck_sha256']}",
        )
        for path in (CANDIDATE, AUDIT):
            text = path.read_text(encoding="utf-8")
            for value in expected:
                self.assertIn(value, text, f"{path} drifted from machine-readable evidence")
        self.assertIn(
            f"candidate_zip_sha256: {package['zip_sha256']}",
            SELF_RUN.read_text(encoding="utf-8"),
        )

    def test_ephemeral_artifact_metadata_is_not_used_as_durable_identity(self) -> None:
        evidence = self._load_evidence()
        artifact = evidence["artifact"]
        self.assertEqual(artifact["metadata_class"], "EPHEMERAL_DELIVERY_METADATA")
        self.assertEqual(evidence["package"]["identity_class"], "IMMUTABLE_CONTENT_DIGESTS")
        candidate = CANDIDATE.read_text(encoding="utf-8")
        self.assertIn("artifact_id / artifact_name / artifact_expires_at = EPHEMERAL_DELIVERY_METADATA", candidate)
        self.assertIn("artifact/API digest + downloaded ZIP/EXE/PCK SHA-256 = DURABLE_CONTENT_IDENTITY", candidate)

    def test_workflow_contract_explains_live_artifact_name_and_retention(self) -> None:
        workflow = WORKFLOW.read_text(encoding="utf-8")
        self.assertIn("name: switchy-express-windows-demo-${{ github.sha }}", workflow)
        self.assertIn("retention-days: 14", workflow)


if __name__ == "__main__":
    unittest.main()
