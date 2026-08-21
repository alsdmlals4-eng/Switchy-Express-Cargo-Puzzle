from __future__ import annotations

import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
ACTIVE_FILES = [
    ROOT / "AGENTS.md",
    ROOT / "README.md",
    ROOT / "기획서/00_프로젝트_허브/START_HERE.md",
    ROOT / "기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md",
    ROOT / "기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md",
    ROOT / "기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md",
    ROOT / "기획서/00_프로젝트_허브/ROADMAP.md",
]
STAGE_SPEC = ROOT / "기획서/20_시스템_콘텐츠/FIRST_SESSION_STAGE_CONTENT_SPEC_V1.md"
COPY_MATRIX = ROOT / "기획서/30_UI_UX/FIRST_SESSION_LOCALIZATION_COPY_MATRIX_V1.md"
EVIDENCE = ROOT / "기획서/50_제작_검증/SX_AUD_066_SX_DEC_059_IMPLEMENTATION_AND_FIVE_PASS_REVIEW.md"


class SxDec059ImplementationCanonicalFreshnessTests(unittest.TestCase):
    def test_active_entrypoints_promote_implemented_automated_state(self) -> None:
        combined = "\n".join(path.read_text(encoding="utf-8") for path in ACTIVE_FILES)
        self.assertIn("SX_DEC_059_IMPLEMENTATION: IMPLEMENTED_AUTOMATED", combined)
        self.assertIn("USER_REQUESTED_AND_EXECUTED", combined)
        self.assertNotIn("sx_dec_059_codex_handoff: NOT_REQUESTED", combined)
        self.assertNotIn("sx_dec_059_build: NOT_STARTED", combined)

    def test_shipped_t4_t5_t6_contract_is_explicit(self) -> None:
        stage = STAGE_SPEC.read_text(encoding="utf-8")
        self.assertGreaterEqual(stage.count("FIXED_FIGURE_EIGHT_STARTER_LAYOUT"), 2)
        self.assertIn("ONE_SWITCH_PRESET_SELECTION", stage)

        matrix = COPY_MATRIX.read_text(encoding="utf-8")
        self.assertIn(
            "Set the switch before the train arrives to choose the delivery route.",
            matrix,
        )
        self.assertNotIn("Change the switch so the train uses both routes.", matrix)

    def test_five_pass_implementation_evidence_is_registered(self) -> None:
        self.assertTrue(EVIDENCE.is_file())
        text = EVIDENCE.read_text(encoding="utf-8")
        for pass_number in range(1, 6):
            self.assertIn(f"ADVERSARIAL_PASS_{pass_number}: CLOSED", text)
        self.assertIn("PHYSICAL_WINDOWS: NOT_RUN", text)
        self.assertIn("FIVE_PERSON_COMPREHENSION: NOT_RUN", text)


if __name__ == "__main__":
    unittest.main()
