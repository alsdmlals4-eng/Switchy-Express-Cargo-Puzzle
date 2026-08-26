from __future__ import annotations

import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
IMPLEMENTATION_MERGE_MAIN = "162e8a0a5e8ddc8472e74a6152e87dc12008e34c"
ACCEPTANCE_CANDIDATE_ID = "SX59-ACCEPT-001"
ACCEPTANCE_ZIP_SHA256 = "30bd8ce9f2e057bede06145c4ff05d46a0cfdb04e239e55f45547862dc3b0264"
ACCEPTANCE_EXE_SHA256 = "1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244"
ACCEPTANCE_PCK_SHA256 = "f8c8f805fe8475a87a3fd5c93a3c461aedc40068d2d43932cfddd44e44ef25b6"

ADAPTER = ROOT / "PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md"
ACTIVE_CONTEXT = ROOT / "기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md"
CURRENT_DECISIONS = ROOT / "기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md"
README = ROOT / "README.md"
DEVELOPMENT_GATES = ROOT / "기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md"
PROJECT_SKILL = ROOT / "skills/switchy-express-design/SKILL.md"
STAGE_SPEC = ROOT / "기획서/20_시스템_콘텐츠/FIRST_SESSION_STAGE_CONTENT_SPEC_V1.md"
COPY_MATRIX = ROOT / "기획서/30_UI_UX/FIRST_SESSION_LOCALIZATION_COPY_MATRIX_V1.md"
PLAYTEST_DELTA = ROOT / "기획서/50_제작_검증/SX_DEC_059_FIRST_SESSION_PLAYTEST_DELTA.md"
EVIDENCE = ROOT / "기획서/50_제작_검증/SX_AUD_066_SX_DEC_059_IMPLEMENTATION_AND_FIVE_PASS_REVIEW.md"
ACCEPTANCE_CANDIDATE = ROOT / "기획서/50_제작_검증/SX_DEC_059_ACCEPTANCE_CANDIDATE_01.md"
SELF_RUN_RECORD = ROOT / "기획서/50_제작_검증/SX_DEC_059_DEVELOPER_SELF_RUN_RECORD.md"
ACCEPTANCE_AUDIT = ROOT / "기획서/50_제작_검증/SX_AUD_068_ACCEPTANCE_CANDIDATE_PREPARATION.md"


class SxDec059ImplementationCanonicalFreshnessTests(unittest.TestCase):
    def test_current_owners_reject_premerge_reopen_state(self) -> None:
        stale_tokens = (
            "implementation_execution_state: NOT_STARTED",
            "sx_dec_059_build_started: false",
            "sx_dec_059_technical_implementation: NOT_RUN",
            "implementation_authority: NOT_GRANTED",
            "implementation PR exact-head CI + merge",
        )
        for path in (ADAPTER, ACTIVE_CONTEXT, CURRENT_DECISIONS, README, DEVELOPMENT_GATES):
            text = path.read_text(encoding="utf-8")
            for stale in stale_tokens:
                self.assertNotIn(stale, text, f"{path} still contains stale token: {stale}")

    def test_pr158_merge_is_retained_as_pre_060_runtime_history(self) -> None:
        adapter = ADAPTER.read_text(encoding="utf-8")
        for required in (
            "pre_sx_dec_060_implementation_execution_state: MERGED_MAIN_VERIFIED",
            "pre_sx_dec_060_implementation_merge_pr: 158",
            f"pre_sx_dec_060_implementation_merge_main: {IMPLEMENTATION_MERGE_MAIN}",
            "pre_sx_dec_060_candidate: SX59-POC-ACCEPT-003",
            "HISTORICAL_PRE_CHANGE_EVIDENCE_ONLY",
            "sx_dec_060_runtime: MERGED_MAIN_VERIFIED · PR_188 · main_740b4b9312fa27289fd62baab8dda54c68ead3a7",
            "post_sx_dec_060_candidate: NOT_CREATED",
        ):
            self.assertIn(required, adapter)
        for path in (ACTIVE_CONTEXT, CURRENT_DECISIONS):
            text = path.read_text(encoding="utf-8")
            self.assertIn(IMPLEMENTATION_MERGE_MAIN, text, f"{path} lost PR #158 merge identity")
            self.assertIn("PRE_SX_DEC_060", text, f"{path} lost historical scope label")

    def test_current_next_action_is_new_post_060_candidate_not_old_candidate_validation(self) -> None:
        adapter = ADAPTER.read_text(encoding="utf-8")
        combined = "\n".join(
            path.read_text(encoding="utf-8")
            for path in (ADAPTER, ACTIVE_CONTEXT, DEVELOPMENT_GATES, PROJECT_SKILL)
        )
        for required in (
            "SX-DEC-060",
            "new exact post-060 package candidate",
            "NOT_CREATED",
            "NOT_RUN",
        ):
            self.assertIn(required, combined)
        self.assertNotIn(
            "Candidate 003 physical visual recheck\n→ same exact Candidate 003 developer self-run",
            adapter,
        )

    def test_superseded_pr154_is_retained_only_as_history(self) -> None:
        text = ADAPTER.read_text(encoding="utf-8")
        self.assertIn("PR #154", text)
        self.assertIn("CLOSED_UNMERGED", text)
        self.assertIn("HISTORICAL", text)

    def test_historical_playtest_delta_preserves_executed_059_boundary(self) -> None:
        text = PLAYTEST_DELTA.read_text(encoding="utf-8")
        for required in (
            "implementation_authority: EXECUTED · PR_158_MERGED_MAIN_VERIFIED",
            "acceptance_candidate: SX59-ACCEPT-001",
            "developer self-run / screen QA: NOT_RUN",
            "Five-person Comprehension: NOT_RUN",
        ):
            self.assertIn(required, text)
        self.assertNotIn("SX-DEC-060 RUNTIME: PASS", text)

    def test_historical_acceptance_candidate_is_hash_bound_and_not_promoted(self) -> None:
        self.assertTrue(ACCEPTANCE_CANDIDATE.is_file())
        text = ACCEPTANCE_CANDIDATE.read_text(encoding="utf-8")
        for required in (
            f"candidate_id: {ACCEPTANCE_CANDIDATE_ID}",
            f"artifact_zip_sha256: {ACCEPTANCE_ZIP_SHA256}",
            f"windows_exe_sha256: {ACCEPTANCE_EXE_SHA256}",
            f"windows_pck_sha256: {ACCEPTANCE_PCK_SHA256}",
            "artifact_integrity: PASS",
            "developer_self_run: NOT_RUN",
            "acceptance_build: NOT_YET_DESIGNATED",
            "windows_physical_runtime: NOT_RUN",
            "five_person_comprehension: NOT_RUN",
        ):
            self.assertIn(required, text)

    def test_developer_self_run_record_starts_fail_closed(self) -> None:
        self.assertTrue(SELF_RUN_RECORD.is_file())
        text = SELF_RUN_RECORD.read_text(encoding="utf-8")
        self.assertIn("NOT_RUN · READY_TO_EXECUTE", text)
        self.assertIn(f"candidate_id: {ACCEPTANCE_CANDIDATE_ID}", text)
        self.assertIn("verdict: NOT_RUN", text)
        self.assertIn("candidate_promotion: BLOCKED_BY_DEVELOPER_SELF_RUN", text)
        for scenario in range(1, 9):
            self.assertIn(f"## Scenario {scenario}", text)

    def test_historical_acceptance_preparation_audit_keeps_evidence_ceiling(self) -> None:
        self.assertTrue(ACCEPTANCE_AUDIT.is_file())
        text = ACCEPTANCE_AUDIT.read_text(encoding="utf-8")
        for pass_number in range(1, 6):
            self.assertIn(f"### PASS {pass_number}", text)
        self.assertIn("candidate_id: SX59-ACCEPT-001", text)
        self.assertIn("developer_self_run: NOT_RUN", text)
        self.assertIn("acceptance_build: NOT_YET_DESIGNATED", text)
        self.assertIn("production_cutover: BLOCKED_DEFERRED", text)

    def test_historical_stage_and_copy_contract_remain_explicit(self) -> None:
        stage = STAGE_SPEC.read_text(encoding="utf-8")
        self.assertGreaterEqual(stage.count("FIXED_FIGURE_EIGHT_STARTER_LAYOUT"), 2)
        self.assertIn("ONE_SWITCH_PRESET_SELECTION", stage)

        matrix = COPY_MATRIX.read_text(encoding="utf-8")
        self.assertIn(
            "Set the switch before the train arrives to choose the delivery route.",
            matrix,
        )
        self.assertNotIn("Change the switch so the train uses both routes.", matrix)

    def test_five_pass_implementation_evidence_is_registered_as_history(self) -> None:
        self.assertTrue(EVIDENCE.is_file())
        text = EVIDENCE.read_text(encoding="utf-8")
        for pass_number in range(1, 6):
            self.assertIn(f"ADVERSARIAL_PASS_{pass_number}: CLOSED", text)
        self.assertIn("PHYSICAL_WINDOWS: NOT_RUN", text)
        self.assertIn("FIVE_PERSON_COMPREHENSION: NOT_RUN", text)


if __name__ == "__main__":
    unittest.main()
