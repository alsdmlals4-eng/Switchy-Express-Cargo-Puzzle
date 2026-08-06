from pathlib import Path
import importlib.util
import json
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[2]
VERIFIER = ROOT / "tools/local_exact_head_verification.py"


def load_verifier():
    spec = importlib.util.spec_from_file_location("local_exact_head_verification", VERIFIER)
    if spec is None or spec.loader is None:
        raise RuntimeError("unable to load verifier module")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


class LocalExactHeadVerificationTest(unittest.TestCase):
    def test_verifier_script_exists(self) -> None:
        self.assertTrue(VERIFIER.is_file(), "local exact-head verifier must exist")

    def test_hash_production_files_is_deterministic_and_excludes_tests_and_artifacts(self) -> None:
        verifier = load_verifier()
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            (root / "game").mkdir()
            (root / "tests").mkdir()
            (root / ".godot").mkdir()
            artifact_dir = root / "artifacts/local-exact-head"
            artifact_dir.mkdir(parents=True)
            (root / "project.godot").write_text("[application]\n", encoding="utf-8")
            (root / "game/core.gd").write_text("extends RefCounted\n", encoding="utf-8")
            (root / "tests/test_only.gd").write_text("test", encoding="utf-8")
            (root / ".godot/cache.bin").write_bytes(b"cache")
            (artifact_dir / "result.json").write_text("{}", encoding="utf-8")

            first = verifier.hash_production_files(root, artifact_dir)
            second = verifier.hash_production_files(root, artifact_dir)

            self.assertEqual(first, second)
            self.assertEqual(set(first), {"game/core.gd", "project.godot"})
            self.assertEqual(len(first["game/core.gd"]), 64)

    def test_parse_junit_sums_nested_suites(self) -> None:
        verifier = load_verifier()
        with tempfile.TemporaryDirectory() as temporary:
            junit = Path(temporary) / "junit.xml"
            junit.write_text(
                '<testsuites><testsuite tests="4" failures="0" errors="0" skipped="1" />'
                '<testsuite tests="3" failures="1" errors="0" skipped="0" /></testsuites>',
                encoding="utf-8",
            )
            self.assertEqual(verifier.parse_junit(junit), (7, 1, 0, 1))

    def test_verify_evidence_requires_full_hex_sha(self) -> None:
        verifier = load_verifier()
        with self.assertRaisesRegex(verifier.VerificationError, "INVALID_EXACT_HEAD"):
            verifier.verify_evidence(
                expected_head="abc123",
                actual_head="abc123",
                dirty_entries=[],
                post_dirty_entries=[],
                godot_version="4.7.1.stable.official",
                command_results=[],
                before_hashes={},
                after_hashes={},
                junit_counts=(6, 0, 0, 0),
                minimum_discovered_tests=6,
                artifact_dir="EXTERNAL_TO_REPOSITORY",
                started_at="2026-08-07T00:00:00+09:00",
                completed_at="2026-08-07T00:01:00+09:00",
                limitations=[],
            )

    def test_verify_evidence_rejects_exact_head_mismatch(self) -> None:
        verifier = load_verifier()
        with self.assertRaisesRegex(verifier.VerificationError, "HEAD_MISMATCH"):
            verifier.verify_evidence(
                expected_head="a" * 40,
                actual_head="b" * 40,
                dirty_entries=[],
                post_dirty_entries=[],
                godot_version="4.7.1.stable.official",
                command_results=[],
                before_hashes={},
                after_hashes={},
                junit_counts=(6, 0, 0, 0),
                minimum_discovered_tests=6,
                artifact_dir="artifact",
                started_at="2026-08-07T00:00:00+09:00",
                completed_at="2026-08-07T00:01:00+09:00",
                limitations=[],
            )

    def test_verify_evidence_rejects_dirty_tree(self) -> None:
        verifier = load_verifier()
        with self.assertRaisesRegex(verifier.VerificationError, "DIRTY_WORKTREE"):
            verifier.verify_evidence(
                expected_head="a" * 40,
                actual_head="a" * 40,
                dirty_entries=[" M game/core.gd"],
                post_dirty_entries=[],
                godot_version="4.7.1.stable.official",
                command_results=[],
                before_hashes={},
                after_hashes={},
                junit_counts=(6, 0, 0, 0),
                minimum_discovered_tests=6,
                artifact_dir="artifact",
                started_at="2026-08-07T00:00:00+09:00",
                completed_at="2026-08-07T00:01:00+09:00",
                limitations=[],
            )

    def test_verify_evidence_rejects_low_gut_discovery(self) -> None:
        verifier = load_verifier()
        with self.assertRaisesRegex(verifier.VerificationError, "GUT_DISCOVERY_BELOW_MINIMUM"):
            verifier.verify_evidence(
                expected_head="a" * 40,
                actual_head="a" * 40,
                dirty_entries=[],
                post_dirty_entries=[],
                godot_version="4.7.1.stable.official",
                command_results=[{"name": "gut", "exit_code": 0}],
                before_hashes={"game/core.gd": "1"},
                after_hashes={"game/core.gd": "1"},
                junit_counts=(5, 0, 0, 0),
                minimum_discovered_tests=6,
                artifact_dir="artifact",
                started_at="2026-08-07T00:00:00+09:00",
                completed_at="2026-08-07T00:01:00+09:00",
                limitations=[],
            )

    def test_verify_evidence_rejects_production_mutation(self) -> None:
        verifier = load_verifier()
        with self.assertRaisesRegex(verifier.VerificationError, "PRODUCTION_MUTATION"):
            verifier.verify_evidence(
                expected_head="a" * 40,
                actual_head="a" * 40,
                dirty_entries=[],
                post_dirty_entries=[],
                godot_version="4.7.1.stable.official",
                command_results=[{"name": "gut", "exit_code": 0}],
                before_hashes={"game/core.gd": "before"},
                after_hashes={"game/core.gd": "after"},
                junit_counts=(6, 0, 0, 0),
                minimum_discovered_tests=6,
                artifact_dir="artifact",
                started_at="2026-08-07T00:00:00+09:00",
                completed_at="2026-08-07T00:01:00+09:00",
                limitations=[],
            )

    def test_verify_evidence_returns_pass_manifest(self) -> None:
        verifier = load_verifier()
        manifest = verifier.verify_evidence(
            expected_head="a" * 40,
            actual_head="a" * 40,
            dirty_entries=[],
            post_dirty_entries=[],
            godot_version="4.7.1.stable.official",
            command_results=[
                {"name": "python-tests", "exit_code": 0, "duration_seconds": 1.2, "stdout": "C:/secret/path", "stderr": ""},
                {"name": "gut", "exit_code": 0, "duration_seconds": 2.3},
            ],
            before_hashes={"game/core.gd": "same"},
            after_hashes={"game/core.gd": "same"},
            junit_counts=(6, 0, 0, 0),
            minimum_discovered_tests=6,
            artifact_dir="artifact",
            started_at="2026-08-07T00:00:00+09:00",
            completed_at="2026-08-07T00:01:00+09:00",
            limitations=["ANDROID_NOT_RUN"],
        )
        self.assertEqual(manifest["status"], "PASS")
        self.assertEqual(manifest["exact_head"], "a" * 40)
        self.assertEqual(manifest["gut"]["discovered"], 6)
        self.assertFalse(manifest["production_mutation"])
        self.assertEqual(manifest["limitations"], ["ANDROID_NOT_RUN"])
        self.assertNotIn("stdout", manifest["commands"][0])
        self.assertNotIn("stderr", manifest["commands"][0])
        self.assertNotIn("argv", manifest["commands"][0])

    def test_verify_evidence_rejects_post_run_repository_changes(self) -> None:
        verifier = load_verifier()
        with self.assertRaisesRegex(verifier.VerificationError, "POST_RUN_DIRTY_WORKTREE"):
            verifier.verify_evidence(
                expected_head="a" * 40,
                actual_head="a" * 40,
                dirty_entries=[],
                post_dirty_entries=["?? unexpected.tmp"],
                godot_version="4.7.1.stable.official",
                command_results=[{"name": "gut", "exit_code": 0}],
                before_hashes={"game/core.gd": "same"},
                after_hashes={"game/core.gd": "same"},
                junit_counts=(6, 0, 0, 0),
                minimum_discovered_tests=6,
                artifact_dir="EXTERNAL_TO_REPOSITORY",
                started_at="2026-08-07T00:00:00+09:00",
                completed_at="2026-08-07T00:01:00+09:00",
                limitations=[],
            )

    def test_write_manifest_uses_stable_json(self) -> None:
        verifier = load_verifier()
        with tempfile.TemporaryDirectory() as temporary:
            output = Path(temporary) / "evidence.json"
            verifier.write_manifest(output, {"status": "PASS", "exact_head": "a" * 40})
            self.assertEqual(
                json.loads(output.read_text(encoding="utf-8")),
                {"exact_head": "a" * 40, "status": "PASS"},
            )
            self.assertTrue(output.read_text(encoding="utf-8").endswith("\n"))

    def test_powershell_wrapper_has_fail_closed_contract(self) -> None:
        wrapper = ROOT / "tools/run_local_exact_head_verification.ps1"
        self.assertTrue(wrapper.is_file(), "PowerShell entry point must exist")
        text = wrapper.read_text(encoding="utf-8")
        for token in (
            "Set-StrictMode -Version Latest",
            "[Parameter(Mandatory = $true)][string]$ExpectedHead",
            "[Parameter(Mandatory = $true)][string]$GodotExecutable",
            "local_exact_head_verification.py",
            "--expected-head",
            "--godot-executable",
            "--minimum-gut-tests",
            "gut-junit.xml",
            "local-verification.json",
        ):
            self.assertIn(token, text)
        for forbidden in ("reset --hard", "clean -fd", "git stash", "force push"):
            self.assertNotIn(forbidden, text.lower())


    def test_documentation_and_canon_bind_decision_and_audit(self) -> None:
        required = {
            ROOT / "docs/testing/LOCAL_EXACT_HEAD_VERIFICATION.md": (
                "SX-DEC-047",
                "SX-AUD-028",
                "[skip actions]",
                "local-verification.json",
                "GUT_DISCOVERY_BELOW_MINIMUM",
            ),
            ROOT / "docs/decisions/SX_DEC_047_LOCAL_EXACT_HEAD_FALLBACK.md": (
                "decision_id: SX-DEC-047",
                "GitHub-hosted Actions",
                "exact HEAD",
                "production mutation",
            ),
            ROOT / "기획서/50_제작_검증/SX_AUD_028_LOCAL_EXACT_HEAD_FALLBACK.md": (
                "audit_id: SX-AUD-028",
                "SX-DEC-047",
                "GAMEPLAY_UNCHANGED",
                "WINDOWS_FULL_PROJECT_NOT_RUN",
            ),
        }
        for document, tokens in required.items():
            self.assertTrue(document.is_file(), f"missing document: {document}")
            content = document.read_text(encoding="utf-8")
            for token in tokens:
                self.assertIn(token, content)



if __name__ == "__main__":
    unittest.main()
