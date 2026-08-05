from __future__ import annotations

import hashlib
import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
CANONICAL_APK_SHA256 = (
    "eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea"
)


def read(path: str) -> str:
    return (ROOT / path).read_text(encoding="utf-8")


def section(text: str, heading: str, next_heading: str) -> str:
    return text.split(heading, 1)[1].split(next_heading, 1)[0]


class TestAndroidSmokeCanonicalFreshness(unittest.TestCase):
    def test_active_hub_points_to_android_smoke(self) -> None:
        start = read("기획서/00_프로젝트_허브/START_HERE.md")
        active = read("기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md")
        gates = read("기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md")
        for text in (start, active, gates):
            self.assertIn("CANONICAL MAIN APK EXPORT", text)
            self.assertIn("ANDROID DEVICE SMOKE", text)
            self.assertIn("FIVE-PERSON COMPREHENSION", text)
            self.assertIn("PRODUCTION CUTOVER", text)
        self.assertNotIn("FINITE_PUZZLE_DEFINITION_OF_READY", start)
        self.assertNotIn("current_authorized_package: VS03-03", active)
        self.assertNotIn("current authority is VS03-03 only", gates)
        self.assertNotIn("VS03-03 READY_FOR_BUILD", gates)

    def test_active_supporting_consumers_are_current(self) -> None:
        readme = read("README.md")
        baseline = read("기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md")
        roadmap = read("기획서/00_프로젝트_허브/ROADMAP.md")
        systems = read("기획서/20_시스템_콘텐츠/CORE_SYSTEMS.md")
        playtest = read("기획서/50_제작_검증/PLAYTEST_PLAN.md")

        self.assertIn("CANONICAL MAIN APK EXPORT: PASS", readme)
        self.assertIn("ANDROID DEVICE SMOKE: NOT_RUN", readme)
        self.assertNotIn("FINITE_PUZZLE_DEFINITION_OF_READY", readme)
        self.assertNotIn("finite delivery runtime not aligned", readme)

        self.assertIn(
            "CURRENT_CANON · USER_APPROVED · AUTOMATED_CORE_PASS · MANUAL_ACCEPTANCE_NOT_RUN",
            baseline,
        )
        self.assertNotIn("IMPLEMENTATION_REPLAN_REQUIRED", baseline)

        self.assertIn("CANONICAL MAIN APK EXPORT · PASS", roadmap)
        self.assertIn("ANDROID DEVICE SMOKE · CURRENT", roadmap)
        self.assertNotIn("implementation replan required", roadmap)
        self.assertNotIn("## FP-M0 — 새 Definition of Ready", roadmap)

        self.assertIn("CURRENT_CANON · GMB-002 · AUTOMATED_CORE_PASS", systems)
        self.assertIn("## 다음 검증 Gate", systems)
        self.assertIn("ANDROID DEVICE SMOKE", systems)
        self.assertNotIn("IMPLEMENTATION_REPLAN_REQUIRED", systems)
        self.assertNotIn("1. finite puzzle DoR", systems)

        self.assertIn("FIVE-PERSON COMPREHENSION", playtest)
        self.assertIn(CANONICAL_APK_SHA256, playtest)
        self.assertIn("P01", playtest)
        self.assertIn("P05", playtest)
        self.assertIn("4/5", playtest)
        for stale in ("부스터", "연료", "BOOST", "capacity 8", "assisted_first_run"):
            self.assertNotIn(stale, playtest)

    def test_documentation_routes_have_one_current_device_authority(self) -> None:
        registry = json.loads(
            read("기획서/00_프로젝트_허브/DESIGN_DOCUMENT_REGISTRY.json")
        )
        by_id = {item["id"]: item for item in registry["documents"]}
        self.assertEqual(
            "기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_RUNBOOK.md",
            by_id["SX-ANDROID-SMOKE-RUNBOOK"]["source"],
        )
        self.assertEqual("CURRENT", by_id["SX-ANDROID-SMOKE-RUNBOOK"]["status"])
        self.assertEqual(
            "기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_EVIDENCE_TEMPLATE.md",
            by_id["SX-ANDROID-SMOKE-EVIDENCE-TEMPLATE"]["source"],
        )
        for legacy_id in (
            "SX-CURRENT-VS-PLAN",
            "SX-FIRST-SESSION-ONBOARDING",
            "SX-FIRST-SESSION-ONBOARDING-PLAN",
        ):
            self.assertIn(by_id[legacy_id]["status"], {"HISTORICAL", "SUPERSEDED"})
        doc_map = read("기획서/00_프로젝트_허브/DOCUMENTATION_MAP.md")
        self.assertIn("ANDROID_DEVICE_SMOKE_RUNBOOK.md", doc_map)
        self.assertIn("ANDROID_DEVICE_SMOKE_EVIDENCE_TEMPLATE.md", doc_map)

    def test_project_skill_current_authority_is_finite(self) -> None:
        skill = read("skills/switchy-express-design/SKILL.md")
        current = section(
            skill,
            "## Current Product Authority",
            "## Legacy Implementation Boundary",
        )
        for token in (
            "unlimited LIFO",
            "persistent branch",
            "finite-time completion",
            "ANDROID DEVICE SMOKE",
        ):
            self.assertIn(token, current)
        for stale in (
            "fuel zero",
            "player BOOST",
            "capacity-eight",
            "cargo slowdown",
            "VS03-03",
        ):
            self.assertNotIn(stale, current)
        self.assertIn("LEGACY_IMPLEMENTATION", skill)

    def test_runbook_and_template_are_same_hash_and_fail_closed(self) -> None:
        runbook = read("기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_RUNBOOK.md")
        template = read(
            "기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_EVIDENCE_TEMPLATE.md"
        )
        for text in (runbook, template):
            self.assertIn(CANONICAL_APK_SHA256, text)
            self.assertIn("com.alsdmlals4.switchyexpress.validation", text)
        for index in range(1, 21):
            self.assertIn(f"AND-{index:02d}", runbook)
        for status in ("PASS", "FAIL", "BLOCKED", "NOT_RUN"):
            self.assertIn(status, runbook)
        for field in (
            "device_alias:",
            "device_model:",
            "android_version:",
            "resolution_density:",
            "recording_references:",
            "screenshot_references:",
            "crash_anr_log_reference:",
            "overall_gate: NOT_RUN",
        ):
            self.assertIn(field, template)
        self.assertNotIn("overall_gate: PASS", template)

    def test_project_registry_hash_is_propagated(self) -> None:
        adapter = json.loads(read("skills/PROJECT_BASE_ADAPTER.json"))
        actual = hashlib.sha256((ROOT / "skills/SKILL_REGISTRY.json").read_bytes()).hexdigest()
        self.assertEqual(actual, adapter["skill_registry"]["project"]["sha256"])


if __name__ == "__main__":
    unittest.main()
