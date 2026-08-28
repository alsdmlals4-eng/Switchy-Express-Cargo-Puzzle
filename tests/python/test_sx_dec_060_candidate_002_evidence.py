from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
POINTER = ROOT / "evidence/acceptance/post_sx_dec_060_candidate.json"
ARTIFACT = ROOT / "evidence/acceptance/sx60_poc_accept_002_artifact.json"
AUDIT = ROOT / "evidence/acceptance/sx60_poc_accept_002_pck_deep_audit.json"
CURRENT_DECISIONS = ROOT / "기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md"
ACTIVE_CONTEXT = ROOT / "기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md"
PROTECTED_APPROVAL = ROOT / "docs/operations/PROJECT_PROTECTED_CHANGE_APPROVAL.json"
FIVE_PHASE_RECEIPT = ROOT / "docs/operations/2026-08-27-sx60-work-five-phase-start-receipt.md"
LIVE_MACHINE_QA = ROOT / "docs/operations/2026-08-27-sx60-current-main-live-machine-qa.md"


class SXDec060Candidate002EvidenceTests(unittest.TestCase):
    def _json(self, path: Path) -> dict:
        self.assertTrue(path.is_file(), f"missing required evidence owner: {path}")
        return json.loads(path.read_text(encoding="utf-8"))

    def test_current_pointer_binds_candidate_002_to_the_exact_successful_export(self) -> None:
        pointer = self._json(POINTER)
        artifact = self._json(ARTIFACT)
        audit = self._json(AUDIT)

        self.assertEqual(pointer["candidate_status"], "PREPARED_PACKAGE_VERIFIED")
        self.assertEqual(pointer["current_candidate_id"], "SX60-POC-ACCEPT-002")
        self.assertEqual(pointer["minimum_product_source_main"], "a8eee4f875a95e8da69802c4e60452df3535fe0e")
        self.assertEqual(
            pointer["artifact_evidence_owner"],
            "evidence/acceptance/sx60_poc_accept_002_artifact.json",
        )
        self.assertEqual(
            pointer["deep_pck_evidence_owner"],
            "evidence/acceptance/sx60_poc_accept_002_pck_deep_audit.json",
        )
        self.assertEqual(artifact["candidate_id"], pointer["current_candidate_id"])
        self.assertEqual(artifact["source_build"]["main_sha"], "0e882764b837d13282a7642b115948d4e061d163")
        self.assertEqual(artifact["artifact"]["workflow_run_id"], 33030116761)
        self.assertEqual(artifact["artifact"]["workflow_head_sha"], artifact["source_build"]["main_sha"])
        self.assertEqual(artifact["artifact"]["workflow_conclusion"], "success")
        self.assertEqual(artifact["artifact"]["id"], 9629917429)
        self.assertEqual(
            artifact["package"]["zip_sha256"],
            "b2602554ec28ba8597cc509c6dc2e1b61a946ca193a31673ed96bf9671c8c8e3",
        )
        self.assertEqual(audit["candidate_id"], pointer["current_candidate_id"])

    def test_deep_audit_is_package_complete_without_promoting_human_gates(self) -> None:
        artifact = self._json(ARTIFACT)
        audit = self._json(AUDIT)

        self.assertEqual(
            artifact["package"]["windows_pck_sha256"],
            "d360eb70b0182e3409b8c60a18e214e5324dd4af619e97b484d3c9dd9a27cd49",
        )
        self.assertTrue(audit["pck_integrity"]["integrity_pass"])
        self.assertEqual(audit["pck_integrity"]["file_count"], 479)
        self.assertEqual(audit["pck_integrity"]["verified_entry_count"], 479)
        textures = audit["product_texture_packaging"]
        self.assertEqual(textures["product_png_import_count"], 73)
        self.assertEqual(textures["unique_referenced_ctex_count"], 73)
        self.assertEqual(textures["missing_ctex_reference_count"], 0)
        self.assertEqual(textures["orphan_packed_ctex_count"], 0)
        self.assertEqual(
            artifact["verification"]["launcher_no_launch_package_verification"],
            "PASS · 2026-08-27 · explicit Candidate 002 NoLaunch PowerShell verification",
        )
        self.assertEqual(
            artifact["verification"]["windows_physical_startup_and_build_entry_automation_observed"],
            "ISOLATED_TITLE_BRIEFING_BUILD_VISUAL_AND_BUTTON_INPUT_OBSERVED",
        )
        self.assertEqual(
            artifact["verification"]["developer_self_run"],
            "ISOLATED_VISUAL_INPUT_OBSERVED_AUDIO_NOT_OBSERVED",
        )
        isolated = artifact["verification"]["isolated_window_observation"]
        self.assertEqual(
            isolated["window_identity"],
            "Switchy Express: Cargo Puzzle (DEBUG)",
        )
        self.assertEqual(isolated["observed_flow"], "title -> briefing -> build board")
        self.assertEqual(isolated["audio_verdict"], "NOT_OBSERVED")
        self.assertEqual(isolated["human_or_device_verdict"], "NOT_RUN")
        for key in (
            "windows_physical_runtime_full_scenarios",
            "audio_perceptual_qa",
            "android_device",
            "five_person_comprehension",
            "player_experience",
        ):
            self.assertEqual(artifact["verification"][key], "NOT_RUN")

    def test_current_decisions_preserve_startup_only_evidence_without_physical_promotion(self) -> None:
        text = CURRENT_DECISIONS.read_text(encoding="utf-8")

        self.assertNotIn("candidate_002_windows_physical_startup_smoke: PASS", text)
        self.assertNotIn("candidate_002_result: BLOCKED_BY_CONFIRMED_P1_PREFLIGHT_VISUAL_DEFECTS", text)
        self.assertIn(
            "candidate_002_windows_physical_startup_smoke: ISOLATED_TITLE_BRIEFING_BUILD_VISUAL_AND_BUTTON_INPUT_OBSERVED",
            text,
        )
        self.assertIn("acceptance_build: SX60-POC-ACCEPT-002 · PACKAGE_VERIFIED · ISOLATED_VISUAL_INPUT_OBSERVED · AUDIO_PERCEPTUAL_QA_NEXT", text)

    def test_active_context_routes_after_startup_observation_to_isolated_self_run(self) -> None:
        text = ACTIVE_CONTEXT.read_text(encoding="utf-8")

        self.assertIn(
            "post_sx_dec_060_candidate_status: SX60-POC-ACCEPT-002 · PREPARED_PACKAGE_VERIFIED · ISOLATED_VISUAL_INPUT_OBSERVED · AUDIO_NOT_OBSERVED · PHYSICAL_AUDIO_QA_NEXT",
            text,
        )
        self.assertNotIn("HUMAN_PHYSICAL_SELF_RUN_NEXT", text)

    def test_user_approval_manifest_retains_candidate_002_records_and_current_decision(self) -> None:
        approval = self._json(PROTECTED_APPROVAL)
        self.assertIn("SX-DEC-060", approval["decision_ids"])
        self.assertIn("SX-DEC-062", approval["decision_ids"])
        self.assertIn(
            "기획서/50_제작_검증/SX_DEC_060_POC_ACCEPTANCE_CANDIDATE_02.md",
            approval["approved_paths"],
        )
        self.assertIn(
            "기획서/50_제작_검증/SX_DEC_060_POC_DEVELOPER_SELF_RUN_RECORD_02.md",
            approval["approved_paths"],
        )
        self.assertIn(
            "기획서/50_제작_검증/SX_DEC_062_CODEX_GODOT_PRODUCT_IMPLEMENTATION_HANDOFF.md",
            approval["approved_paths"],
        )

    def test_five_phase_receipt_preserves_historical_block_while_active_context_tracks_user_authorization(self) -> None:
        receipt = FIVE_PHASE_RECEIPT.read_text(encoding="utf-8")
        active_context = ACTIVE_CONTEXT.read_text(encoding="utf-8")

        for required in (
            "PHASE_5_USER_VERTICAL_SLICE_VALIDATION",
            "MACHINE_EXECUTABLE_REQUIRED_WORK_0",
            "BLOCKED_USER_VALIDATION",
            "remaining_machine_executable_required_work: 0",
            "Do not start a new Slice automatically.",
            "PR #174 remains untouched.",
        ):
            self.assertIn(required, receipt)

        self.assertIn(
            "base_work_current_phase: PHASE_5_USER_VERTICAL_SLICE_VALIDATION · USER_AUTHORIZED · WINDOWS_PHYSICAL_AUDIO_EXECUTION_PENDING",
            active_context,
        )
        self.assertNotIn(
            "base_work_current_phase: PHASE_5_USER_VERTICAL_SLICE_VALIDATION · BLOCKED_USER_VALIDATION",
            active_context,
        )
        self.assertIn("remaining_machine_executable_required_work: 0", active_context)

    def test_current_main_live_machine_qa_preserves_the_human_evidence_boundary(self) -> None:
        text = LIVE_MACHINE_QA.read_text(encoding="utf-8")
        active_context = ACTIVE_CONTEXT.read_text(encoding="utf-8")

        for required in (
            "cf93926e302d2b7d8ea1492dec3d19c43f7484cd",
            "112` cases, `13,480` assertions, and `0` failures",
            "title screen",
            "build board / HUD",
            "HUMAN_DEVICE_AUDIO_NOT_RUN",
            "Windows physical human smoke: NOT_RUN",
            "audio perceptual QA: NOT_RUN",
            "Android device: NOT_RUN",
            "PR #174 remains `READ_ONLY`.",
        ):
            self.assertIn(required, text)

        self.assertIn("current_main_live_machine_qa:", active_context)


if __name__ == "__main__":
    unittest.main()
