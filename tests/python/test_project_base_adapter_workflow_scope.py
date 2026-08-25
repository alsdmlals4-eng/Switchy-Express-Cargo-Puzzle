from pathlib import Path
import unittest


ROOT = Path(__file__).resolve().parents[2]
WORKFLOW = ROOT / ".github/workflows/validate-project-base-adapter.yml"


class ProjectBaseAdapterWorkflowScopeTest(unittest.TestCase):
    def test_adapter_validator_remains_scoped_and_refreshes_on_label_changes(self) -> None:
        text = WORKFLOW.read_text(encoding="utf-8")
        for required in (
            "pull_request:",
            "types: [opened, synchronize, reopened, ready_for_review, labeled, unlabeled]",
            "branches: [main]",
            "paths:",
        ):
            self.assertIn(required, text)
        self.assertNotIn("pull_request:\n\n", text)

    def test_authoritative_adapter_paths_trigger_validation(self) -> None:
        text = WORKFLOW.read_text(encoding="utf-8")
        for path in (
            ".agents/skills/switchy-express-cargo-puzzle-workflow-router/**",
            "skills/PROJECT_BASE_ADAPTER.json",
            "skills/PROJECT_SKILL_SNAPSHOT.json",
            "skills/SKILL_REGISTRY.json",
            "docs/PROJECT_OPERATING_DASHBOARD.html",
            "docs/PROJECT_OPERATING_HEALTH.json",
            "tests/python/test_project_base_adapter_thin_migration.py",
        ):
            self.assertIn(f"- {path}", text)

    def test_product_runtime_paths_do_not_trigger_adapter_migration_validation(self) -> None:
        text = WORKFLOW.read_text(encoding="utf-8")
        for unrelated in (
            "game/**",
            "game/demo/**",
            "game/finite/**",
            "data/maps/**",
            "project.godot",
            "export_presets.cfg",
        ):
            self.assertNotIn(f"- {unrelated}", text)


if __name__ == "__main__":
    unittest.main()
