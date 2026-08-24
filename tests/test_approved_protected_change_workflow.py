from __future__ import annotations

import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
WORKFLOW = ROOT / ".github/workflows/validate-project-base-adapter.yml"
BASE_GATE_COMMIT = "2828a74f60c1ed09546171040f4178c8848ea686"


class ApprovedProtectedChangeWorkflowTests(unittest.TestCase):
    def test_workflow_uses_exact_external_approval_gate_and_fails_closed(self) -> None:
        workflow = WORKFLOW.read_text(encoding="utf-8")
        required = (
            f"ref: {BASE_GATE_COMMIT}",
            "check_approved_project_operating_contract.py",
            "PROJECT_PROTECTED_CHANGE_APPROVAL.json",
            "approved-protected-change",
            '--external-approval "$EXTERNAL_APPROVAL"',
            "Select trusted protected baseline",
            "github.event.pull_request.base.sha",
            "labeled",
            "unlabeled",
        )
        for token in required:
            self.assertIn(token, workflow)

        forbidden = (
            "--admin",
            "check_project_operating_contract.py \\\n            --project-root . \\\n            --base-repository .base-contract \\\n            --protected-base \"$PR_BASE_SHA\"",
        )
        for token in forbidden:
            self.assertNotIn(token, workflow)


if __name__ == "__main__":
    unittest.main()
