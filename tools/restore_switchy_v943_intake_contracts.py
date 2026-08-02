from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PATH = ROOT / "skills/PROJECT_BASE_ADAPTER.json"
data = json.loads(PATH.read_text(encoding="utf-8"))
intake = data.setdefault("shared_overrides", {}).setdefault("managing-project-intake-and-work-contract", {})
intake["planning_first_governance"] = {
    "actual_project_batch_execution": "NOT_RUN",
    "base_contract_source": "docs/PLANNING_FIRST_GRILL_ME_BATCH_POLICY.md",
    "base_release_finalization_commit": "0b7c94f38d959efc0fc9442274c60b2e268a3c97",
    "base_release_lock": "base-v9.4.3.lock.json",
    "checkpoint_template": "templates/project-operations/GRILL_ME_BATCH_CHECKPOINT.md",
    "max_approved_decisions_per_batch": 10,
    "numeric_default_state": "RECOMMENDED_DEFAULT",
    "planning_conflict_state": "GRILL_ME_REQUIRED",
    "post_merge_sheet_state": "SYNCED_TO_MAIN",
    "pre_merge_sheet_state": "APPROVED_PENDING_MERGE",
}
commands = {item["command"] if isinstance(item, dict) else item for item in data["validators"]}
command = "python tests/test_base_v942_planning_first_adoption.py"
if command not in commands:
    data["validators"].append({"command": command, "status": "REQUIRED_ON_PULL_REQUEST", "evidence_commit": None})
PATH.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
