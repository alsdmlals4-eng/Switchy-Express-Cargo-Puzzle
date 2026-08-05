from __future__ import annotations

import hashlib
import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class TestBaseV94Switchy(unittest.TestCase):
    def test_identity_registry_routes_and_core(self) -> None:
        adapter = json.loads(
            (ROOT / "skills/PROJECT_BASE_ADAPTER.json").read_text(encoding="utf-8")
        )
        registry = json.loads(
            (ROOT / "skills/SKILL_REGISTRY.json").read_text(encoding="utf-8")
        )
        base_routes = {
            route["skill_id"] for route in adapter["routing"]["base_routes"]
        }
        project_routes = {
            route["skill_id"] for route in adapter["routing"]["project_routes"]
        }
        project_registry_skills = {
            entry["skill_id"] for entry in registry["skills"]
        }

        self.assertEqual("9.4.3", adapter["base_release"]["version"])
        self.assertEqual(
            "7dd1a4f80388bc5faca767ff74a3eb32dc9d0ac8",
            adapter["base_release"]["release_commit"],
        )
        self.assertEqual(
            "da33a350d61b8adc52df97fccc7001708a933370",
            adapter["base_release"]["release_evidence_commit"],
        )
        self.assertEqual(
            "693a0dff3f054ecdd653079909e044211473838e73dd9aff07734d1ce5694c59",
            adapter["skill_registry"]["base"]["sha256"],
        )
        self.assertEqual(
            hashlib.sha256((ROOT / "skills/SKILL_REGISTRY.json").read_bytes()).hexdigest(),
            adapter["skill_registry"]["project"]["sha256"],
        )
        self.assertIn("optimizing-ai-model-and-prompt-costs", base_routes)
        self.assertIn("managing-project-intake-and-work-contract", base_routes)
        self.assertEqual({"switchy-express-design"}, project_routes)
        self.assertEqual({"switchy-express-design"}, project_registry_skills)
        self.assertEqual(
            ["project.godot", "game/**", "assets/**", "기획서/**"],
            adapter["protected_paths"],
        )

    def test_contracts(self) -> None:
        adapter = json.loads(
            (ROOT / "skills/PROJECT_BASE_ADAPTER.json").read_text(encoding="utf-8")
        )
        ai = (ROOT / "docs/AI_WORKFLOW.md").read_text(encoding="utf-8")
        ui = (ROOT / "기획서/40_표현/VISUAL_DIRECTION.md").read_text(encoding="utf-8")
        audit = (ROOT / "기획서/50_제작_검증/BASE_V9_4_ADOPTION_AUDIT.md").read_text(
            encoding="utf-8"
        )
        for token in (
            "[모델 추천]",
            "HARD_CONSTRAINT",
            "Interface-first",
            "Example-as-Fixture",
            "refresh_trigger",
            "LIFO",
            "NOT_RUN",
        ):
            self.assertIn(token, ai)
        for token in (
            "입력 접수",
            "처리 중",
            "중단",
            "즉시 완료",
            "빠른 반복",
            "재진입",
            "재시작",
            "Reduced Motion",
            "mute",
            "haptic-off",
            "권위 시점",
        ):
            self.assertIn(token, ui)
        planning = adapter["shared_overrides"][
            "managing-project-intake-and-work-contract"
        ]["planning_first_governance"]
        self.assertEqual(10, planning["max_approved_decisions_per_batch"])
        self.assertEqual("RECOMMENDED_DEFAULT", planning["numeric_default_state"])
        self.assertEqual("GRILL_ME_REQUIRED", planning["planning_conflict_state"])
        self.assertEqual("NOT_RUN", planning["actual_project_batch_execution"])
        self.assertIn("product_logic_changed: false", audit)
        self.assertIn("HUMAN_NOT_RUN", audit)


if __name__ == "__main__":
    unittest.main()
