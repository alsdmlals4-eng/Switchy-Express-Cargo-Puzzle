from __future__ import annotations

import json
import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
HISTORICAL_POINTER = ROOT / "evidence/acceptance/current_poc_candidate.json"
POST_060_POINTER = ROOT / "evidence/acceptance/post_sx_dec_060_candidate.json"
HISTORICAL_LAUNCHER = ROOT / "RUN_SX59_POC_SELF_RUN.ps1"
POST_060_LAUNCHER = ROOT / "RUN_SX60_POC_SELF_RUN.ps1"


class CandidatePointerBoundaryTests(unittest.TestCase):
    def _json(self, path: Path) -> dict:
        self.assertTrue(path.is_file(), f"required evidence pointer is missing: {path}")
        return json.loads(path.read_text(encoding="utf-8"))

    def test_candidate_003_pointer_and_hash_evidence_remain_immutable_pre_060_history(self) -> None:
        pointer = self._json(HISTORICAL_POINTER)
        self.assertEqual(pointer["schema_version"], 1)
        self.assertEqual(pointer["current_candidate_id"], "SX59-POC-ACCEPT-003")
        self.assertEqual(
            pointer["artifact_evidence_owner"],
            "evidence/acceptance/sx59_poc_accept_003_artifact.json",
        )
        self.assertEqual(
            pointer["deep_pck_evidence_owner"],
            "evidence/acceptance/sx59_poc_accept_003_pck_deep_audit.json",
        )
        evidence = self._json(ROOT / pointer["artifact_evidence_owner"])
        deep = self._json(ROOT / pointer["deep_pck_evidence_owner"])
        self.assertEqual(evidence["candidate_id"], "SX59-POC-ACCEPT-003")
        self.assertEqual(deep["candidate_id"], "SX59-POC-ACCEPT-003")
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
        self.assertEqual(evidence["artifact"]["workflow_run_id"], 32715351609)
        self.assertEqual(evidence["corrected_runtime"]["pr"], 171)
        self.assertEqual(
            evidence["corrected_runtime"]["tree_sha"],
            "e3b6154a3042808fbc2fc62d5a3c6487e3d2a40f",
        )
        self.assertEqual(
            deep["package_identity"]["windows_pck_sha256"],
            "2e9634cedd6da49793973f4582e2bd58ea4daae2fec246657edcf58ae360af72",
        )
        self.assertTrue(deep["pck_integrity"]["integrity_pass"])
        self.assertEqual(deep["pck_integrity"]["file_count"], 472)
        self.assertEqual(deep["pck_integrity"]["verified_entry_count"], 472)
        self.assertEqual(deep["pck_integrity"]["md5_mismatch_count"], 0)
        self.assertEqual(deep["product_texture_packaging"]["product_png_import_count"], 73)
        self.assertEqual(deep["product_texture_packaging"]["unique_referenced_ctex_count"], 73)
        self.assertEqual(deep["product_texture_packaging"]["missing_ctex_reference_count"], 0)
        self.assertEqual(deep["product_texture_packaging"]["orphan_packed_ctex_count"], 0)
        self.assertEqual(deep["evidence_ceiling"]["physical_visual_recheck"], "NOT_RUN")

    def test_historical_pointer_retains_record_identity_and_evidence_classes(self) -> None:
        pointer = self._json(HISTORICAL_POINTER)
        self.assertEqual(
            pointer["acceptance_candidate_document"],
            "기획서/50_제작_검증/SX_DEC_059_POC_ACCEPTANCE_CANDIDATE_03.md",
        )
        self.assertEqual(pointer["self_run_record_name"], "SX_DEC_059_POC_DEVELOPER_SELF_RUN_RECORD_03.md")
        self.assertEqual(pointer["selection_policy"], "EXPLICIT_FAIL_CLOSED_POINTER_NO_NEWEST_INFERENCE")
        evidence = self._json(ROOT / pointer["artifact_evidence_owner"])
        self.assertTrue(evidence["verification"]["artifact_api_digest_equals_downloaded_zip_sha256"])
        self.assertEqual(evidence["package"]["identity_class"], "IMMUTABLE_CONTENT_DIGESTS")
        self.assertEqual(evidence["artifact"]["metadata_class"], "EPHEMERAL_DELIVERY_METADATA")

    def test_post_060_pointer_selects_candidate_008_and_preserves_every_prior_exact_candidate(self) -> None:
        pointer = self._json(POST_060_POINTER)
        self.assertEqual(pointer["schema_version"], 1)
        self.assertEqual(pointer["decision_id"], "SX-DEC-060")
        self.assertEqual(pointer["candidate_status"], "PREPARED_PACKAGE_VERIFIED")
        self.assertEqual(pointer["current_candidate_id"], "SX60-POC-ACCEPT-008")
        self.assertEqual(pointer["minimum_product_source_main"], "53e29f874bc70a0057c310d661dc45dbecc6cf13")
        self.assertEqual(
            pointer["current_candidate_role"],
            "MACHINE_PRIMARY_ACCEPTANCE_READY · POST_SX_DEC_068_EXACT_PRODUCT_BYTES · "
            "FINAL_USER_REVIEW_NOT_RUN · TITLE_WORDMARK_PIXEL_REVIEW_PENDING",
        )
        self.assertEqual(
            pointer["selection_policy"],
            "EXPLICIT_FAIL_CLOSED_POINTER_NO_NEWEST_INFERENCE",
        )
        self.assertEqual(
            pointer["historical_predecessor"]["candidate_id"],
            "SX59-POC-ACCEPT-003",
        )
        self.assertEqual(
            pointer["historical_predecessor"]["pointer"],
            "evidence/acceptance/current_poc_candidate.json",
        )
        self.assertEqual(
            pointer["historical_predecessor"]["role"],
            "HISTORICAL_EXACT_BYTES_ONLY",
        )
        self.assertEqual(pointer["artifact_evidence_owner"], "evidence/acceptance/sx60_poc_accept_008_artifact.json")
        self.assertEqual(pointer["deep_pck_evidence_owner"], "evidence/acceptance/sx60_poc_accept_008_pck_deep_audit.json")
        historical = pointer["historical_superseded_candidate"]
        self.assertEqual(historical["candidate_id"], "SX60-POC-ACCEPT-001")
        self.assertEqual(historical["source_main"], "7b7f350345619e870bb94e12954fbe81b1ef9403")
        self.assertEqual(historical["invalidation_reason"], "PLAYER_FACING_RUNTIME_ROUTE_READABILITY_CHANGE")
        self.assertEqual(historical["invalidated_by_product_source_main"], "a8eee4f875a95e8da69802c4e60452df3535fe0e")
        self.assertEqual(historical["role"], "HISTORICAL_SUPERSEDED_BY_PRODUCT_BYTE_CHANGE")
        sx_dec_062_history = pointer["historical_superseded_after_sx_dec_062"]
        self.assertEqual(sx_dec_062_history["candidate_id"], "SX60-POC-ACCEPT-002")
        self.assertEqual(
            sx_dec_062_history["invalidation_reason"],
            "PLAYER_FACING_SX_DEC_062_BOARD_FIRST_RUNTIME_COMPOSITION_CHANGE",
        )
        sx_dec_063_v04_history = pointer["historical_superseded_after_sx_dec_063_core_board_v04"]
        self.assertEqual(sx_dec_063_v04_history["candidate_id"], "SX60-POC-ACCEPT-004")
        self.assertEqual(sx_dec_063_v04_history["source_main"], "58b99f261c3576150ab275bb041d744c69b83538")
        self.assertEqual(
            sx_dec_063_v04_history["role"],
            "HISTORICAL_SUPERSEDED_BY_SX_DEC_063_CORE_BOARD_V04_PRODUCT_BYTE_CHANGE",
        )
        sx_dec_066_history = pointer["historical_superseded_after_sx_dec_066_route_book_01"]
        self.assertEqual(sx_dec_066_history["candidate_id"], "SX60-POC-ACCEPT-005")
        self.assertEqual(sx_dec_066_history["source_main"], "a11dfd1a063e434ee22e8cfb7b073ebc380aa27a")
        self.assertEqual(
            sx_dec_066_history["role"],
            "HISTORICAL_SUPERSEDED_BY_SX_DEC_066_ROUTE_BOOK_01_PRODUCT_BYTE_CHANGE",
        )
        sx_dec_067_history = pointer["historical_superseded_after_sx_dec_067"]
        self.assertEqual(sx_dec_067_history["candidate_id"], "SX60-POC-ACCEPT-006")
        self.assertEqual(sx_dec_067_history["source_main"], "9af5a8c46d29ea6781f9ee06008d7c7d2cde1877")
        self.assertEqual(
            sx_dec_067_history["role"],
            "HISTORICAL_SUPERSEDED_BY_SX_DEC_067_PLAYER_FACING_PRODUCT_BYTE_CHANGE",
        )
        sx_dec_068_history = pointer["historical_superseded_after_sx_dec_068"]
        self.assertEqual(sx_dec_068_history["candidate_id"], "SX60-POC-ACCEPT-007")
        self.assertEqual(sx_dec_068_history["source_main"], "c0bb86efa5bad6050217ca67dd6aa9eba155dc75")
        self.assertEqual(pointer["tooling_only_non_invalidating_prs"], ["PR #201", "PR #250"])

    def test_post_060_pointer_records_machine_validation_and_final_review_boundary(self) -> None:
        pointer = self._json(POST_060_POINTER)
        self.assertGreaterEqual(len(pointer["completed_machine_gates"]), 6)
        self.assertIn(
            "GitHub Actions Windows Demo Export PASS · run 33392296685 · exact main 53e29f874bc70a0057c310d661dc45dbecc6cf13",
            pointer["completed_machine_gates"],
        )
        self.assertEqual(
            pointer["last_verified_machine_gates"],
            [
                "Windows Demo Export PASS · 2026-08-31 KST · GitHub Actions run 33392296685 · "
                "exact main 53e29f874bc70a0057c310d661dc45dbecc6cf13"
            ],
        )
        self.assertEqual(
            pointer["mint_after"],
            [],
        )

    def test_post_060_launcher_cannot_select_or_launch_candidate_003(self) -> None:
        self.assertTrue(POST_060_LAUNCHER.is_file(), "post-060 fail-closed launcher is required")
        text = POST_060_LAUNCHER.read_text(encoding="ascii")
        self.assertIn("post_sx_dec_060_candidate.json", text)
        self.assertIn("candidate_status", text)
        self.assertIn("NOT_CREATED", text)
        self.assertIn("minimum_product_source_main", text)
        self.assertIn("$Evidence.source_build.main_sha", text)
        self.assertIn("merge-base --is-ancestor", text)
        self.assertIn("CANDIDATE_SOURCE_MAIN_NOT_DESCENDANT", text)
        self.assertIn("POST_SX_DEC_060_CANDIDATE_CONTRACT", text)
        self.assertIn("throw", text)
        self.assertNotIn("SX59-POC-ACCEPT-003", text)
        self.assertNotIn("current_poc_candidate.json", text)
        self.assertIn("Start-Process", text)
        self.assertIn("gh run download", text)

    def test_current_entry_docs_do_not_promote_historical_automation_to_current_physical_pass(self) -> None:
        for relative in ("README.md", "기획서/00_프로젝트_허브/START_HERE.md"):
            text = (ROOT / relative).read_text(encoding="utf-8")
            self.assertIn("SX60-POC-ACCEPT-006", text, relative)
            self.assertIn("NOT_RUN", text, relative)

    def test_current_machine_primary_surfaces_route_only_candidate_008_after_the_post_sx_dec_068_mint(self) -> None:
        current_surfaces = (
            "AGENTS.md",
            "PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md",
            "기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md",
            "기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md",
            "기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md",
            "기획서/00_프로젝트_허브/ROADMAP.md",
        )
        stale_current_claim = re.compile(
            r"(?:final user review[^.\n]*(?:Candidate[ _-]00[56]|SX60[_-]POC[_-]ACCEPT[_-]00[56])|"
            r"(?:Candidate[ _-]00[56]|SX60[_-]POC[_-]ACCEPT[_-]00[56])[^.\n]*"
            r"(?:current mapping|current .*candidate|MACHINE_PRIMARY_ACCEPTANCE_READY))",
            re.IGNORECASE,
        )
        findings = []
        for relative in current_surfaces:
            text = (ROOT / relative).read_text(encoding="utf-8")
            self.assertIn("SX-DEC-068", text, relative)
            self.assertIn("SX60-POC-ACCEPT-008", text, relative)
            for line_number, line in enumerate(text.splitlines(), 1):
                if stale_current_claim.search(line) and "historical" not in line.lower():
                    findings.append(f"{relative}:{line_number}: {line.strip()}")
        self.assertFalse(
            findings,
            "Candidates 005 and 006 are historical evidence and must not be routed as the current "
            "machine-primary or final-user-review candidate:\n" + "\n".join(findings),
        )

    def test_historical_launcher_requires_explicit_history_only_opt_in(self) -> None:
        self.assertTrue(HISTORICAL_LAUNCHER.is_file())
        text = HISTORICAL_LAUNCHER.read_text(encoding="ascii")
        self.assertIn("[switch]$HistoricalEvidenceOnly", text)
        self.assertIn("HISTORICAL_EVIDENCE_ONLY", text)
        self.assertIn("current_poc_candidate.json", text)


if __name__ == "__main__":
    unittest.main()
