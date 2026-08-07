from __future__ import annotations

import hashlib
import tempfile
import unittest
from pathlib import Path

from tools.gut_phase_b_guard import compare_vendor, snapshot, verify_snapshot, validate_junit


class GutPhaseBGuardTests(unittest.TestCase):
    def test_vendor_compare_allows_explicit_scene_load_steps_metadata(self) -> None:
        with tempfile.TemporaryDirectory() as raw:
            root = Path(raw)
            official = root / "official"
            local = root / "local"
            official.mkdir()
            local.mkdir()
            path = "gui/GutControl.tscn"
            (official / "gui").mkdir()
            (local / "gui").mkdir()
            (official / path).write_text(
                '[gd_scene load_steps=4 format=3]\n[node name="A"]\n', encoding="utf-8"
            )
            (local / path).write_text(
                '[gd_scene format=3]\n[node name="A"]\n', encoding="utf-8"
            )

            report = compare_vendor(local, official)

            self.assertTrue(report["ok"])
            self.assertEqual(report["source_divergence"], [])
            self.assertEqual(report["normalized_resource_metadata"], [path])

    def test_vendor_compare_allows_explicit_theme_load_steps_metadata(self) -> None:
        with tempfile.TemporaryDirectory() as raw:
            root = Path(raw)
            official = root / "official"
            local = root / "local"
            official.mkdir()
            local.mkdir()
            path = "gui/GutSceneTheme.tres"
            (official / "gui").mkdir()
            (local / "gui").mkdir()
            (official / path).write_text(
                '[gd_resource type="Theme" load_steps=2 format=3]\n[resource]\n',
                encoding="utf-8",
            )
            (local / path).write_text(
                '[gd_resource type="Theme" format=3]\n[resource]\n', encoding="utf-8"
            )

            report = compare_vendor(local, official)

            self.assertTrue(report["ok"])
            self.assertEqual(report["source_divergence"], [])
            self.assertEqual(report["normalized_resource_metadata"], [path])

    def test_vendor_compare_rejects_load_steps_change_on_unapproved_resource(self) -> None:
        with tempfile.TemporaryDirectory() as raw:
            root = Path(raw)
            official = root / "official"
            local = root / "local"
            official.mkdir()
            local.mkdir()
            (official / "OtherTheme.tres").write_text(
                '[gd_resource type="Theme" load_steps=2 format=3]\n[resource]\n',
                encoding="utf-8",
            )
            (local / "OtherTheme.tres").write_text(
                '[gd_resource type="Theme" format=3]\n[resource]\n', encoding="utf-8"
            )

            report = compare_vendor(local, official)

            self.assertFalse(report["ok"])
            self.assertEqual(report["normalized_resource_metadata"], [])
            self.assertEqual(report["source_divergence"], ["OtherTheme.tres"])

    def test_vendor_compare_accepts_only_exact_pinned_binary_pair(self) -> None:
        with tempfile.TemporaryDirectory() as raw:
            root = Path(raw)
            official = root / "official"
            local = root / "local"
            official.mkdir()
            local.mkdir()
            local_bytes = b"local-font"
            official_bytes = b"official-font"
            (local / "font.fnt").write_bytes(local_bytes)
            (official / "font.fnt").write_bytes(official_bytes)
            expected = {
                "font.fnt": {
                    "local_sha256": hashlib.sha256(local_bytes).hexdigest(),
                    "official_sha256": hashlib.sha256(official_bytes).hexdigest(),
                    "local_size": len(local_bytes),
                    "official_size": len(official_bytes),
                }
            }

            report = compare_vendor(local, official, expected_binary_divergences=expected)

            self.assertTrue(report["ok"])
            self.assertEqual(report["pinned_binary_divergence"], ["font.fnt"])
            self.assertEqual(report["source_divergence"], [])

    def test_vendor_compare_rejects_changed_pinned_binary(self) -> None:
        with tempfile.TemporaryDirectory() as raw:
            root = Path(raw)
            official = root / "official"
            local = root / "local"
            official.mkdir()
            local.mkdir()
            expected_local = b"local-font"
            official_bytes = b"official-font"
            (local / "font.fnt").write_bytes(b"changed-font")
            (official / "font.fnt").write_bytes(official_bytes)
            expected = {
                "font.fnt": {
                    "local_sha256": hashlib.sha256(expected_local).hexdigest(),
                    "official_sha256": hashlib.sha256(official_bytes).hexdigest(),
                    "local_size": len(expected_local),
                    "official_size": len(official_bytes),
                }
            }

            report = compare_vendor(local, official, expected_binary_divergences=expected)

            self.assertFalse(report["ok"])
            self.assertEqual(report["pinned_binary_divergence"], [])
            self.assertEqual(report["source_divergence"], ["font.fnt"])

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
            self.assertEqual(
                report["divergence_evidence"]["gut.gd"],
                {
                    "local_sha256": "c73d1366ec40d23336ad7ae26fe2a73a3126c6110a121774ff3c2dd068216a14",
                    "official_sha256": "006c373933f8e49903c974a70b81864df932f34b72076a11916696e4577e804a",
                    "local_size": 19,
                    "official_size": 13,
                },
            )

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
