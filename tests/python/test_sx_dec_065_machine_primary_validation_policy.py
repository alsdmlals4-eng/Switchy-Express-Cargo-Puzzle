from __future__ import annotations

import json
import os
import subprocess
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]


def read(relative_path: str) -> str:
    path = ROOT / relative_path
    if not path.is_file():
        raise AssertionError(f"missing canonical owner: {relative_path}")
    return path.read_text(encoding="utf-8")


class SXDec065MachinePrimaryValidationPolicyTests(unittest.TestCase):
    def test_decision_owner_defines_machine_primary_and_final_user_review(self) -> None:
        decision = read("docs/decisions/SX_DEC_065_MACHINE_PRIMARY_FINAL_USER_REVIEW_VALIDATION_POLICY.md")

        for required in (
            "SX-DEC-065",
            "USER_APPROVED",
            "MACHINE_PRIMARY_FINAL_USER_REVIEW",
            "FIVE_PERSON_COMPREHENSION_NOT_REQUIRED",
            "PLAYER_EXPERIENCE_STUDY_NOT_REQUIRED",
            "FINAL_USER_REVIEW",
            "Machine evidence never becomes human evidence",
        ):
            self.assertIn(required, decision)

    def test_current_hubs_route_to_the_new_policy_without_erasing_history(self) -> None:
        owners = (
            "기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md",
            "기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md",
            "기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md",
            "기획서/00_프로젝트_허브/ROADMAP.md",
            "기획서/00_프로젝트_허브/START_HERE.md",
            "기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md",
        )
        combined = "\n".join(read(path) for path in owners)

        for required in (
            "SX-DEC-065",
            "MACHINE_PRIMARY_FINAL_USER_REVIEW",
            "FIVE_PERSON_COMPREHENSION_NOT_REQUIRED",
            "PLAYER_EXPERIENCE_STUDY_NOT_REQUIRED",
            "FINAL_USER_REVIEW",
            "Candidate 003",
            "HISTORICAL",
        ):
            self.assertIn(required, combined)

        active = read("기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md")
        self.assertIn("current_decisions: SX-DEC-027~065", active)
        self.assertIn(
            "five_person_post_060: NOT_REQUIRED_BY_USER_VALIDATION_POLICY",
            active,
        )
        self.assertIn(
            "player_experience_post_060: NOT_REQUIRED_BY_USER_VALIDATION_POLICY",
            active,
        )

    def test_current_playtest_and_vertical_slice_contracts_no_longer_require_five_people(self) -> None:
        playtest = read("기획서/50_제작_검증/PLAYTEST_PLAN.md")
        vertical_slice = read("기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md")
        phase5 = read("docs/superpowers/plans/2026-08-28-phase5-human-validation.md")

        for text in (playtest, vertical_slice, phase5):
            self.assertIn("SX-DEC-065", text)
            self.assertIn("MACHINE_PRIMARY_FINAL_USER_REVIEW", text)
            self.assertIn("FINAL_USER_REVIEW", text)

        current_phase = playtest.split("## 1. Historical Phase B Gate Record", 1)[0]
        self.assertIn(
            "five_person_comprehension: NOT_REQUIRED_BY_USER_VALIDATION_POLICY",
            current_phase,
        )
        self.assertIn(
            "player_experience: NOT_REQUIRED_BY_USER_VALIDATION_POLICY",
            current_phase,
        )
        self.assertNotIn("→ five-person first-contact comprehension", current_phase)
        self.assertIn("HISTORICAL_METHOD_REFERENCE_ONLY", playtest)
        self.assertIn(
            "CURRENT EXACT CANDIDATE: SX60-POC-ACCEPT-005 · SOURCE_MAIN_a11dfd1a063e434ee22e8cfb7b073ebc380aa27a",
            playtest,
        )

    def test_candidate_pointer_selects_the_machine_verified_v04_candidate(self) -> None:
        pointer = json.loads(
            read("evidence/acceptance/post_sx_dec_060_candidate.json")
        )

        self.assertEqual("PREPARED_PACKAGE_VERIFIED", pointer["candidate_status"])
        self.assertEqual("SX60-POC-ACCEPT-005", pointer["current_candidate_id"])
        self.assertEqual(
            "SX60-POC-ACCEPT-004",
            pointer["historical_superseded_after_sx_dec_063_core_board_v04"]["candidate_id"],
        )

    @unittest.skipUnless(os.name == "nt", "PowerShell contract execution requires Windows")
    def test_contract_check_resolves_current_candidate_without_launch(self) -> None:
        contract_result = subprocess.run(
            [
                "powershell",
                "-ExecutionPolicy",
                "Bypass",
                "-File",
                str(ROOT / "RUN_SX60_POC_SELF_RUN.ps1"),
                "-ContractCheck",
            ],
            cwd=ROOT,
            capture_output=True,
            text=True,
            check=False,
        )

        self.assertEqual(
            0,
            contract_result.returncode,
            contract_result.stdout + contract_result.stderr,
        )
        self.assertIn("POST_SX_DEC_060_CANDIDATE_CONTRACT: PASS - SX60-POC-ACCEPT-005", contract_result.stdout)

    def test_registry_map_and_protected_approval_track_the_new_owner(self) -> None:
        registry = json.loads(read("기획서/00_프로젝트_허브/DESIGN_DOCUMENT_REGISTRY.json"))
        entry = next(item for item in registry["documents"] if item["id"] == "SX-DEC-065-MACHINE-PRIMARY-VALIDATION")
        self.assertEqual(
            "docs/decisions/SX_DEC_065_MACHINE_PRIMARY_FINAL_USER_REVIEW_VALIDATION_POLICY.md",
            entry["source"],
        )
        self.assertEqual("CURRENT", entry["status"])
        self.assertIn("SX-DEC-065", read("기획서/00_프로젝트_허브/DOCUMENTATION_MAP.md"))

        approval = json.loads(read("docs/operations/PROJECT_PROTECTED_CHANGE_APPROVAL.json"))
        self.assertIn("SX-DEC-065", approval["decision_ids"])
        self.assertNotIn(
            "docs/decisions/SX_DEC_065_MACHINE_PRIMARY_FINAL_USER_REVIEW_VALIDATION_POLICY.md",
            approval["approved_paths"],
        )
        self.assertIn("SX_DEC_065_MACHINE_PRIMARY_FINAL_USER_REVIEW", approval["approval_source"])
        self.assertIn("SX-DEC-065", approval["scope_summary"])

        self.assertIn(
            "USER-APPROVAL-2026-08-30-SX60-POC-ACCEPT-005-MACHINE-VALIDATION",
            approval["decision_ids"],
        )
        for protected_current_candidate_owner in (
            "기획서/50_제작_검증/SX_DEC_060_POC_ACCEPTANCE_CANDIDATE_05.md",
            "기획서/50_제작_검증/SX_DEC_060_POC_DEVELOPER_SELF_RUN_RECORD_05.md",
        ):
            self.assertIn(protected_current_candidate_owner, approval["approved_paths"])
        for non_protected_evidence_owner in (
            "evidence/acceptance/post_sx_dec_060_candidate.json",
            "evidence/acceptance/sx60_poc_accept_005_artifact.json",
            "evidence/acceptance/sx60_poc_accept_005_pck_deep_audit.json",
        ):
            self.assertNotIn(non_protected_evidence_owner, approval["approved_paths"])


if __name__ == "__main__":
    unittest.main()
