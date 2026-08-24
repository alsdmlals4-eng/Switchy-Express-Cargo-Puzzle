from __future__ import annotations

import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
POC_PR = "166"
POC_HEAD = "159a3a741ef79b6207be290cc284bd63a5979e72"
POC_MAIN = "1bf798cedf28dffba9185edb62fb1c50c108fe90"
POC_TREE = "b3fa0ad93721d7f99614fb6f0bf594c7ce068127"
CANDIDATE_ID = "SX59-POC-ACCEPT-002"
ZIP_SHA256 = "c0a7856efaeb278ac1501ee5b36ec4af15c088aefd88b759eb15681c7ce4fd42"
EXE_SHA256 = "90347bb3e5ef28760385777b63a87be5c1572a9e8c3f11e619fac6fabfb44103"
PCK_SHA256 = "089c9b78bb3e82bbf1accce7fe26b2306700e2800c590cbac1763252b7a2ea7a"

CURRENT_OWNERS = [
    ROOT / "기획서/00_프로젝트_허브/START_HERE.md",
    ROOT / "기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md",
    ROOT / "기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md",
    ROOT / "기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md",
    ROOT / "기획서/00_프로젝트_허브/ROADMAP.md",
]
CANDIDATE = ROOT / "기획서/50_제작_검증/SX_DEC_059_POC_ACCEPTANCE_CANDIDATE_02.md"
SELF_RUN = ROOT / "기획서/50_제작_검증/SX_DEC_059_POC_DEVELOPER_SELF_RUN_RECORD_02.md"
AUDIT = ROOT / "기획서/50_제작_검증/SX_AUD_069_PLAYABLE_VISUAL_UX_POC.md"


class PlayablePocPostMergeCanonTests(unittest.TestCase):
    def test_current_owners_record_merged_playable_poc_without_inflating_manual_evidence(self) -> None:
        for path in CURRENT_OWNERS:
            text = path.read_text(encoding="utf-8")
            self.assertIn(f"PR #{POC_PR}", text, f"{path} lost POC merge identity")
            self.assertIn(POC_MAIN, text, f"{path} lost POC merged main")
            self.assertIn(CANDIDATE_ID, text, f"{path} does not route to current POC candidate")
            self.assertIn("developer self-run", text.lower())
            self.assertIn("NOT_RUN", text)

    def test_candidate_binds_exact_artifact_and_merged_tree(self) -> None:
        self.assertTrue(CANDIDATE.is_file())
        text = CANDIDATE.read_text(encoding="utf-8")
        for required in (
            f"candidate_id: {CANDIDATE_ID}",
            f"poc_pr_head: {POC_HEAD}",
            f"poc_merge_main: {POC_MAIN}",
            f"poc_tree_sha: {POC_TREE}",
            f"artifact_zip_sha256: {ZIP_SHA256}",
            f"windows_exe_sha256: {EXE_SHA256}",
            f"windows_pck_sha256: {PCK_SHA256}",
            "merged_tree_matches_artifact_head_tree: PASS",
            "developer_self_run: NOT_RUN",
            "acceptance_build: NOT_YET_DESIGNATED",
            "windows_physical_runtime: NOT_RUN",
            "android_device: NOT_RUN",
            "five_person_comprehension: NOT_RUN",
            "player_experience: NOT_RUN",
        ):
            self.assertIn(required, text)

    def test_old_candidate_is_explicitly_superseded_for_current_poc(self) -> None:
        old = (ROOT / "기획서/50_제작_검증/SX_DEC_059_ACCEPTANCE_CANDIDATE_01.md").read_text(encoding="utf-8")
        self.assertIn("SUPERSEDED_FOR_CURRENT_POC", old)
        self.assertIn(CANDIDATE_ID, old)

    def test_self_run_record_is_fail_closed_and_covers_eight_scenarios(self) -> None:
        self.assertTrue(SELF_RUN.is_file())
        text = SELF_RUN.read_text(encoding="utf-8")
        self.assertIn(f"candidate_id: {CANDIDATE_ID}", text)
        self.assertIn("verdict: NOT_RUN", text)
        self.assertIn("candidate_promotion: BLOCKED_BY_DEVELOPER_SELF_RUN", text)
        for index in range(1, 9):
            self.assertIn(f"## Scenario {index}", text)

    def test_audit_records_visual_scope_and_evidence_ceiling(self) -> None:
        self.assertTrue(AUDIT.is_file())
        text = AUDIT.read_text(encoding="utf-8")
        for required in (
            "board / HUD / title / lesson briefing / result",
            "approved E+D Hybrid product assets",
            "111",
            "Windows Demo Export: PASS",
            "Windows packaged runtime JSON proof: PASS",
            "Android packaged runtime JSON proof: PASS",
            "PHYSICAL_WINDOWS: NOT_RUN",
            "ANDROID_DEVICE: NOT_RUN",
            "FIVE_PERSON_COMPREHENSION: NOT_RUN",
            "PLAYER_EXPERIENCE: NOT_RUN",
        ):
            self.assertIn(required, text)


if __name__ == "__main__":
    unittest.main()
