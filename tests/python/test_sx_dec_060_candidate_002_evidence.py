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

    def test_candidate_002_is_preserved_as_exact_prior_byte_evidence(self) -> None:
        pointer = self._json(POINTER)
        artifact = self._json(ARTIFACT)
        audit = self._json(AUDIT)

        self.assertEqual(pointer["candidate_status"], "PREPARED_PACKAGE_VERIFIED")
        self.assertEqual(pointer["current_candidate_id"], "SX60-POC-ACCEPT-007")
        historical = pointer["historical_superseded_after_sx_dec_062"]
        self.assertEqual(historical["candidate_id"], "SX60-POC-ACCEPT-002")
        self.assertEqual(
            historical["artifact_evidence_owner"],
            "evidence/acceptance/sx60_poc_accept_002_artifact.json",
        )
        self.assertEqual(
            historical["deep_pck_evidence_owner"],
            "evidence/acceptance/sx60_poc_accept_002_pck_deep_audit.json",
        )
        self.assertEqual(artifact["candidate_id"], historical["candidate_id"])
        self.assertEqual(artifact["source_build"]["main_sha"], "0e882764b837d13282a7642b115948d4e061d163")
        self.assertEqual(artifact["artifact"]["workflow_run_id"], 33030116761)
        self.assertEqual(artifact["artifact"]["workflow_head_sha"], artifact["source_build"]["main_sha"])
        self.assertEqual(artifact["artifact"]["workflow_conclusion"], "success")
        self.assertEqual(artifact["artifact"]["id"], 9629917429)
        self.assertEqual(
            artifact["package"]["zip_sha256"],
            "b2602554ec28ba8597cc509c6dc2e1b61a946ca193a31673ed96bf9671c8c8e3",
        )
        self.assertEqual(audit["candidate_id"], historical["candidate_id"])

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

        self.assertNotIn("SX60-POC-ACCEPT-004 · PHYSICAL_PASS", text)
        self.assertIn("sx60_poc_accept_002: SX60-POC-ACCEPT-002 · HISTORICAL_SUPERSEDED_BY_SX_DEC_062", text)
        self.assertIn(
            "acceptance_build: SX60-POC-ACCEPT-007 · PREPARED_PACKAGE_VERIFIED · exact post-SX-DEC-067 machine package · NO_HUMAN_OR_PHYSICAL_EVIDENCE",
            text,
        )

    def test_active_context_preserves_candidate_history_and_routes_to_new_machine_candidate(self) -> None:
        text = ACTIVE_CONTEXT.read_text(encoding="utf-8")

        self.assertIn(
            "post_sx_dec_060_candidate_status: SX60-POC-ACCEPT-007 · PREPARED_PACKAGE_VERIFIED · Candidate_006_historical",
            text,
        )
        self.assertNotIn("HUMAN_PHYSICAL_SELF_RUN_NEXT", text)

    def test_user_approval_manifest_scopes_current_paths_without_erasing_candidate_history(self) -> None:
        approval = self._json(PROTECTED_APPROVAL)
        self.assertIn("SX-DEC-060", approval["decision_ids"])
        self.assertIn("SX-DEC-062", approval["decision_ids"])
        candidate_history = (
            "기획서/50_제작_검증/SX_DEC_060_POC_ACCEPTANCE_CANDIDATE_02.md",
            "기획서/50_제작_검증/SX_DEC_060_POC_DEVELOPER_SELF_RUN_RECORD_02.md",
            "기획서/50_제작_검증/SX_DEC_060_POC_ACCEPTANCE_CANDIDATE_03.md",
            "기획서/50_제작_검증/SX_DEC_060_POC_DEVELOPER_SELF_RUN_RECORD_03.md",
            "기획서/50_제작_검증/SX_DEC_062_CODEX_GODOT_PRODUCT_IMPLEMENTATION_HANDOFF.md",
        )
        for relative_path in candidate_history:
            self.assertTrue((ROOT / relative_path).is_file(), relative_path)
            self.assertNotIn(relative_path, approval["approved_paths"])

    def test_five_phase_receipt_remains_historical_while_active_context_tracks_machine_primary_policy(self) -> None:
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
            "base_work_current_phase: PHASE_5_MACHINE_PRIMARY_CANDIDATE_007_PREPARED",
            active_context,
        )
        self.assertNotIn(
            "base_work_current_phase: PHASE_5_USER_VERTICAL_SLICE_VALIDATION · BLOCKED_USER_VALIDATION",
            active_context,
        )
        self.assertIn(
            "remaining_machine_executable_required_work: NONE · exact SX-DEC-067 machine package candidate prepared",
            active_context,
        )

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
