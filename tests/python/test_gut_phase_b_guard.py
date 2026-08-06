from __future__ import annotations

import tempfile
import unittest
from pathlib import Path

from tools.gut_phase_b_guard import compare_vendor, snapshot, verify_snapshot, validate_junit


class GutPhaseBGuardTests(unittest.TestCase):
    def test_vendor_compare_allows_only_redundant_load_steps(self) -> None:
        with tempfile.TemporaryDirectory() as raw:
            root = Path(raw)
            official = root / "official"
            local = root / "local"
            official.mkdir()
            local.mkdir()
            (official / "GutScene.tscn").write_text(
                '[gd_scene load_steps=4 format=3]\n[node name="A"]\n',
                encoding="utf-8",
            )
            (local / "GutScene.tscn").write_text(
                '[gd_scene format=3]\n[node name="A"]\n',
                encoding="utf-8",
            )

            report = compare_vendor(local, official)

            self.assertEqual(report["source_divergence"], [])
            self.assertEqual(report["normalized_scene_metadata"], ["GutScene.tscn"])
            self.assertEqual(report["missing_local"], [])
            self.assertEqual(report["extra_local"], [])

    def test_vendor_compare_rejects_load_steps_change_on_unapproved_scene(self) -> None:
        with tempfile.TemporaryDirectory() as raw:
            root = Path(raw)
            official = root / "official"
            local = root / "local"
            official.mkdir()
            local.mkdir()
            (official / "OtherScene.tscn").write_text(
                '[gd_scene load_steps=2 format=3]\n[node name="A"]\n',
                encoding="utf-8",
            )
            (local / "OtherScene.tscn").write_text(
                '[gd_scene format=3]\n[node name="A"]\n',
                encoding="utf-8",
            )

            report = compare_vendor(local, official)

            self.assertEqual(report["normalized_scene_metadata"], [])
            self.assertEqual(report["source_divergence"], ["OtherScene.tscn"])

    def test_vendor_compare_rejects_source_change(self) -> None:
        with tempfile.TemporaryDirectory() as raw:
            root = Path(raw)
            official = root / "official"
            local = root / "local"
            official.mkdir()
            local.mkdir()
            (official / "gut.gd").write_text("extends Node\n", encoding="utf-8")
            (local / "gut.gd").write_text("extends RefCounted\n", encoding="utf-8")

            report = compare_vendor(local, official)

            self.assertEqual(report["source_divergence"], ["gut.gd"])

    def test_vendor_compare_reports_missing_and_extra_files(self) -> None:
        with tempfile.TemporaryDirectory() as raw:
            root = Path(raw)
            official = root / "official"
            local = root / "local"
            official.mkdir()
            local.mkdir()
            (official / "required.gd").write_text("official\n", encoding="utf-8")
            (local / "extra.gd").write_text("extra\n", encoding="utf-8")

            report = compare_vendor(local, official)

            self.assertEqual(report["missing_local"], ["required.gd"])
            self.assertEqual(report["extra_local"], ["extra.gd"])

    def test_snapshot_hashes_protected_files_only(self) -> None:
        with tempfile.TemporaryDirectory() as raw:
            root = Path(raw)
            (root / "project.godot").write_text("config", encoding="utf-8")
            (root / "game").mkdir()
            (root / "game" / "core.gd").write_text("code", encoding="utf-8")
            (root / "tests").mkdir()
            (root / "tests" / "ignored.gd").write_text("test", encoding="utf-8")

            result = snapshot(root, ["project.godot", "game"])

            self.assertEqual(sorted(result), ["game/core.gd", "project.godot"])

    def test_verify_snapshot_reports_changed_added_and_removed(self) -> None:
        with tempfile.TemporaryDirectory() as raw:
            root = Path(raw)
            (root / "game").mkdir()
            (root / "game" / "same.gd").write_text("same", encoding="utf-8")
            (root / "game" / "removed.gd").write_text("old", encoding="utf-8")
            before = snapshot(root, ["game"])
            (root / "game" / "removed.gd").unlink()
            (root / "game" / "same.gd").write_text("changed", encoding="utf-8")
            (root / "game" / "added.gd").write_text("new", encoding="utf-8")

            report = verify_snapshot(root, before, ["game"])

            self.assertEqual(report["changed"], ["game/same.gd"])
            self.assertEqual(report["added"], ["game/added.gd"])
            self.assertEqual(report["removed"], ["game/removed.gd"])
            self.assertFalse(report["ok"])

    def test_validate_junit_requires_minimum_and_zero_failures(self) -> None:
        with tempfile.TemporaryDirectory() as raw:
            junit_path = Path(raw) / "junit.xml"
            junit_path.write_text(
                '<testsuites tests="7" failures="0" errors="0" skipped="0"></testsuites>',
                encoding="utf-8",
            )

            report = validate_junit(junit_path, minimum_tests=6)

            self.assertTrue(report["ok"])
            self.assertEqual(report["tests"], 7)

    def test_validate_junit_sums_nested_suites(self) -> None:
        with tempfile.TemporaryDirectory() as raw:
            junit_path = Path(raw) / "junit.xml"
            junit_path.write_text(
                '<testsuites><testsuite tests="4" failures="0" errors="0" />'
                '<testsuite tests="3" failures="1" errors="0" /></testsuites>',
                encoding="utf-8",
            )

            report = validate_junit(junit_path, minimum_tests=6)

            self.assertFalse(report["ok"])
            self.assertEqual(report["tests"], 7)
            self.assertEqual(report["failures"], 1)


if __name__ == "__main__":
    unittest.main()
