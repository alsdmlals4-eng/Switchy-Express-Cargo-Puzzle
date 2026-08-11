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


def require_contains(test: unittest.TestCase, label: str, text: str, token: str) -> None:
    if token not in text:
        print(f"::error title=canonical-freshness::{label} missing required token: {token}")
    test.assertIn(token, text, f"{label} missing required token: {token}")


def require_absent(test: unittest.TestCase, label: str, text: str, token: str) -> None:
    if token in text:
        print(f"::error title=canonical-freshness::{label} contains forbidden token: {token}")
    test.assertNotIn(token, text, f"{label} contains forbidden token: {token}")


class TestAndroidSmokeCanonicalFreshness(unittest.TestCase):
    def test_active_hub_preserves_device_gates_after_phase_b(self) -> None:
        start = read("기획서/00_프로젝트_허브/START_HERE.md")
        active = read("기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md")
        gates = read("기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md")

        for label, text in (("START_HERE", start), ("ACTIVE_CONTEXT", active)):
            for token in ("SX-DEC-055", "GRANTED", "PASS", "NOT_RUN"):
                require_contains(self, label, text, token)
        require_contains(self, "START_HERE", start, "ANDROID DEVICE SMOKE")
        require_contains(self, "ACTIVE_CONTEXT", active, "ANDROID DEVICE SMOKE")

        for token in (
            "HISTORICAL CANONICAL APK EXPORT",
            "ANDROID DEVICE SMOKE",
            "FIVE-PERSON COMPREHENSION",
            "PRODUCTION CUTOVER",
        ):
            require_contains(self, "DEVELOPMENT_GATES", gates, token)

        require_absent(self, "START_HERE", start, "ANDROID DEVICE SMOKE · CURRENT")
        require_absent(self, "ACTIVE_CONTEXT", active, "ANDROID DEVICE SMOKE · CURRENT")
        require_absent(self, "START_HERE", start, "FINITE_PUZZLE_DEFINITION_OF_READY")
        require_absent(self, "ACTIVE_CONTEXT", active, "current_authorized_package: VS03-03")
        require_absent(self, "DEVELOPMENT_GATES", gates, "current authority is VS03-03 only")
        require_absent(self, "DEVELOPMENT_GATES", gates, "VS03-03 READY_FOR_BUILD")

    def test_active_supporting_consumers_are_current(self) -> None:
        readme = read("README.md")
        baseline = read("기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md")
        roadmap = read("기획서/00_프로젝트_허브/ROADMAP.md")
        systems = read("기획서/20_시스템_콘텐츠/CORE_SYSTEMS.md")
        playtest = read("기획서/50_제작_검증/PLAYTEST_PLAN.md")

        for token in (
            "SX-DEC-055 RUNTIME POC: MERGED_MAIN_VERIFIED",
            "ANDROID DEVICE SMOKE: NOT_RUN",
            "GMB-002",
            "SX-AUD-047",
        ):
            require_contains(self, "README", readme, token)
        require_absent(self, "README", readme, "FINITE_PUZZLE_DEFINITION_OF_READY")
        require_absent(self, "README", readme, "finite delivery runtime not aligned")
        require_absent(self, "README", readme, "SX-DEC-055 RUNTIME POC: NOT_STARTED")

        require_contains(
            self,
            "FINITE_DELIVERY_PUZZLE_BASELINE",
            baseline,
            "CURRENT_CANON · USER_APPROVED · AUTOMATED_CORE_PASS · MANUAL_ACCEPTANCE_NOT_RUN",
        )
        require_absent(
            self,
            "FINITE_DELIVERY_PUZZLE_BASELINE",
            baseline,
            "IMPLEMENTATION_REPLAN_REQUIRED",
        )

        for token in (
            "SX-DEC-055 Runtime Semantic POC",
            "IMPLEMENTED · MERGED_MAIN_VERIFIED",
            "M5A · Post-POC acceptance",
            "Android device smoke",
            "M6 · Physical/device/human validation",
        ):
            require_contains(self, "ROADMAP", roadmap, token)
        for stale in (
            "ANDROID DEVICE SMOKE · CURRENT",
            "implementation replan required",
            "## FP-M0 — 새 Definition of Ready",
            "BUILD AUTHORIZED · IMPLEMENTATION NOT_STARTED",
        ):
            require_absent(self, "ROADMAP", roadmap, stale)

        for token in (
            "CURRENT_CANON · GMB-002 · AUTOMATED_CORE_PASS",
            "## 다음 검증 Gate",
            "ANDROID DEVICE SMOKE",
        ):
            require_contains(self, "CORE_SYSTEMS", systems, token)
        for stale in ("IMPLEMENTATION_REPLAN_REQUIRED", "1. finite puzzle DoR"):
            require_absent(self, "CORE_SYSTEMS", systems, stale)

        for token in ("FIVE-PERSON COMPREHENSION", CANONICAL_APK_SHA256, "P01", "P05", "4/5"):
            require_contains(self, "PLAYTEST_PLAN", playtest, token)
        for stale in ("부스터", "연료", "BOOST", "capacity 8", "assisted_first_run"):
            require_absent(self, "PLAYTEST_PLAN", playtest, stale)

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
