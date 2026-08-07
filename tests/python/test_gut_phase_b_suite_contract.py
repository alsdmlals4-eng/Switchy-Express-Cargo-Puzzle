from __future__ import annotations

import json
import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
CONFIG = ROOT / ".gutconfig.json"
GUT_ROOT = ROOT / "tests/gut"
EXPECTED_DIRS = [
    "res://tests/gut/unit",
    "res://tests/gut/integration",
    "res://tests/gut/regression",
]


class GutPhaseBSuiteContractTests(unittest.TestCase):
    def test_config_has_authoritative_discovery_and_junit_path(self) -> None:
        config = json.loads(CONFIG.read_text(encoding="utf-8"))
        self.assertEqual(config["dirs"], EXPECTED_DIRS)
        self.assertTrue(config["include_subdirs"])
        self.assertEqual(config["prefix"], "test_")
        self.assertEqual(config["suffix"], ".gd")
        self.assertTrue(config["should_exit"])
        self.assertEqual(config["junit_xml_file"], "res://test-results/gut/junit.xml")
        self.assertFalse(config["junit_xml_timestamp"])
        for directory in config["dirs"]:
            relative = directory.removeprefix("res://")
            self.assertTrue((ROOT / relative).is_dir(), f"missing configured GUT directory: {directory}")

    def test_suite_contains_real_gut_consumers(self) -> None:
        scripts = sorted(GUT_ROOT.rglob("test_*.gd"))
        self.assertGreaterEqual(len(scripts), 4)
        test_count = 0
        for script in scripts:
            text = script.read_text(encoding="utf-8")
            self.assertRegex(text, r"(?m)^extends GutTest\s*$")
            self.assertNotIn('extends "res://tests/test_case.gd"', text)
            test_count += len(re.findall(r"(?m)^func test_[A-Za-z0-9_]+\s*\(", text))
        self.assertGreaterEqual(test_count, 7)

    def test_suite_covers_approved_finite_core_responsibilities(self) -> None:
        joined = "\n".join(
            script.read_text(encoding="utf-8")
            for script in sorted(GUT_ROOT.rglob("test_*.gd"))
        )
        for token in (
            "RED_STAR",
            "BLUE_DIAMOND",
            "final_delivery_commit_time",
            "exit_for",
            "set_route_control_locked_cell",
            "route_control_states",
        ):
            self.assertIn(token, joined)


if __name__ == "__main__":
    unittest.main()
