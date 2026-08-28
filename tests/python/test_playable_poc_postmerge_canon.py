from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
POC_HEAD = "159a3a741ef79b6207be290cc284bd63a5979e72"
POC_MAIN = "1bf798cedf28dffba9185edb62fb1c50c108fe90"
POC_TREE = "b3fa0ad93721d7f99614fb6f0bf594c7ce068127"
PRE_060_CANDIDATE = "SX59-POC-ACCEPT-003"
EVIDENCE = ROOT / "evidence/acceptance/sx59_poc_accept_002_artifact.json"

ACTIVE_CONTEXT = ROOT / "기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md"
CURRENT_DECISIONS = ROOT / "기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md"
DEVELOPMENT_GATES = ROOT / "기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md"
ROADMAP = ROOT / "기획서/00_프로젝트_허브/ROADMAP.md"
CANDIDATE = ROOT / "기획서/50_제작_검증/SX_DEC_059_POC_ACCEPTANCE_CANDIDATE_02.md"
SELF_RUN = ROOT / "기획서/50_제작_검증/SX_DEC_059_POC_DEVELOPER_SELF_RUN_RECORD_02.md"
AUDIT = ROOT / "기획서/50_제작_검증/SX_AUD_069_PLAYABLE_VISUAL_UX_POC.md"


def _evidence() -> dict:
    return json.loads(EVIDENCE.read_text(encoding="utf-8"))


class PlayablePocPostMergeCanonTests(unittest.TestCase):
    def test_resume_owners_preserve_playable_poc_as_pre_060_history(self) -> None:
        for path in (ACTIVE_CONTEXT, CURRENT_DECISIONS):
            text = path.read_text(encoding="utf-8")
            self.assertIn(POC_MAIN, text, f"{path} lost POC merged-main identity")
            self.assertIn(PRE_060_CANDIDATE, text, f"{path} lost historical Candidate 003 identity")
            self.assertIn("SX-DEC-060", text)
            self.assertIn("HISTORICAL", text)
            self.assertIn("SX60-POC-ACCEPT-001", text)
            self.assertNotIn("current_candidate: SX59-POC-ACCEPT-003", text)

    def test_current_decision_and_gates_route_post_060_work(self) -> None:
        decisions = CURRENT_DECISIONS.read_text(encoding="utf-8")
        self.assertIn("current_decision_span: SX-DEC-027~063", decisions)
        self.assertIn("SX-DEC-060", decisions)
        self.assertIn("SX-DEC-061", decisions)
        self.assertIn("SX-DEC-063", decisions)
        self.assertNotIn("current_decision_span: SX-DEC-027~059", decisions)
        for path in (DEVELOPMENT_GATES, ROADMAP):
            text = path.read_text(encoding="utf-8")
            self.assertIn("SX-DEC-060", text)
            self.assertIn("NOT_RUN", text)
            self.assertIn("post-060", text.lower())

    def test_candidate_binds_exact_artifact_and_merged_tree(self) -> None:
        self.assertTrue(EVIDENCE.is_file(), "machine-readable candidate evidence must exist")
        evidence = _evidence()
        artifact = evidence["artifact"]
        package = evidence["package"]
        candidate_id = evidence["candidate_id"]

        self.assertEqual(artifact["workflow_head_sha"], POC_HEAD)
        self.assertEqual(
            artifact["api_digest_sha256"],
            package["zip_sha256"],
            "GitHub artifact digest must equal the independently downloaded ZIP digest",
        )
        self.assertEqual(artifact["metadata_class"], "EPHEMERAL_DELIVERY_METADATA")
        self.assertEqual(package["identity_class"], "IMMUTABLE_CONTENT_DIGESTS")

        text = CANDIDATE.read_text(encoding="utf-8")
        for required in (
            f"candidate_id: {candidate_id}",
            "supersedes_candidate: SX59-ACCEPT-001",
            f"poc_pr_head: {POC_HEAD}",
            f"poc_merge_main: {POC_MAIN}",
            f"poc_tree_sha: {POC_TREE}",
            f"artifact_id: {artifact['id']}",
            f"artifact_name: {artifact['name']}",
            f"artifact_expires_at: {artifact['expires_at']}",
            f"artifact_api_digest_sha256: {artifact['api_digest_sha256']}",
            f"artifact_zip_sha256: {package['zip_sha256']}",
            f"windows_exe_sha256: {package['windows_exe_sha256']}",
            f"windows_pck_sha256: {package['windows_pck_sha256']}",
            "merged_tree_matches_artifact_head_tree: PASS",
            "developer_self_run: NOT_RUN",
            "acceptance_build: NOT_YET_DESIGNATED",
            "windows_physical_runtime: NOT_RUN",
            "android_device: NOT_RUN",
            "five_person_comprehension: NOT_RUN",
            "player_experience: NOT_RUN",
        ):
            self.assertIn(required, text)

    def test_old_candidate_remains_immutable_history_and_new_candidate_owns_supersession(self) -> None:
        old = ROOT / "기획서/50_제작_검증/SX_DEC_059_ACCEPTANCE_CANDIDATE_01.md"
        self.assertTrue(old.is_file(), "historical candidate 001 must remain available")
        self.assertIn("candidate_id: SX59-ACCEPT-001", old.read_text(encoding="utf-8"))
        text = CANDIDATE.read_text(encoding="utf-8") if CANDIDATE.is_file() else ""
        self.assertIn("supersedes_reason: PLAYABLE_POC_RUNTIME_AND_VISUAL_BYTES_CHANGED", text)

    def test_self_run_record_is_fail_closed_and_covers_eight_scenarios(self) -> None:
        evidence = _evidence()
        package = evidence["package"]
        self.assertTrue(SELF_RUN.is_file())
        text = SELF_RUN.read_text(encoding="utf-8")
        self.assertIn(f"candidate_id: {evidence['candidate_id']}", text)
        self.assertIn(f"candidate_zip_sha256: {package['zip_sha256']}", text)
        self.assertIn("verdict: NOT_RUN", text)
        self.assertIn("candidate_promotion: BLOCKED_BY_DEVELOPER_SELF_RUN", text)
        self.assertIn("audio_perceptual_qa: NOT_RUN", text)
        for index in range(1, 9):
            self.assertIn(f"## Scenario {index}", text)

    def test_audit_records_visual_scope_and_evidence_ceiling(self) -> None:
        evidence = _evidence()
        artifact = evidence["artifact"]
        package = evidence["package"]
        self.assertTrue(AUDIT.is_file())
        text = AUDIT.read_text(encoding="utf-8")
        for required in (
            "board / HUD / title / lesson briefing / result",
            "approved E+D Hybrid product assets",
            "Godot Tests: PASS · cases=111",
            "Windows Demo Export: PASS",
            "Windows packaged runtime JSON proof: PASS",
            "Android packaged runtime JSON proof: PASS",
            f"artifact_id: {artifact['id']}",
            f"artifact_zip_sha256: {package['zip_sha256']}",
            "PHYSICAL_WINDOWS: NOT_RUN",
            "AUDIO_PERCEPTUAL_QA: NOT_RUN",
            "ANDROID_DEVICE: NOT_RUN",
            "FIVE_PERSON_COMPREHENSION: NOT_RUN",
            "PLAYER_EXPERIENCE: NOT_RUN",
        ):
            self.assertIn(required, text)


if __name__ == "__main__":
    unittest.main()
