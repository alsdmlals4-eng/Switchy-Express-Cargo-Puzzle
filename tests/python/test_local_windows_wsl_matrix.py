from pathlib import Path
import importlib.util
import unittest


ROOT = Path(__file__).resolve().parents[2]
MATRIX = ROOT / "tools/local_python_matrix.py"
ENTRY = ROOT / "tools/local_exact_head_verification_entry.py"
WRAPPER = ROOT / "tools/run_local_exact_head_verification.ps1"


def load_matrix():
    spec = importlib.util.spec_from_file_location("local_python_matrix", MATRIX)
    if spec is None or spec.loader is None:
        raise RuntimeError("unable to load matrix validator")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def passing_matrix(head: str = "a" * 40):
    versions = {
        "windows-python-3.11": "3.11.9",
        "windows-python-3.12": "3.12.9",
        "windows-python-3.13": "3.13.5",
        "wsl-ubuntu-python-3.12": "3.12.8",
    }
    return {
        "status": "PASS",
        "exact_head": head,
        "targets": [
            {
                "target": target,
                "python_version": version,
                "exit_code": 0,
                "duration_seconds": 1.0,
                "log_file": f"{target}.log",
                "stdout": "C:/secret/path",
            }
            for target, version in versions.items()
        ],
    }


class LocalWindowsWslMatrixTest(unittest.TestCase):
    def test_matrix_requires_all_targets(self) -> None:
        module = load_matrix()
        value = passing_matrix()
        value["targets"] = value["targets"][1:]
        with self.assertRaisesRegex(module.MatrixError, "PYTHON_MATRIX_TARGETS_MISMATCH"):
            module.validate_matrix(value, "a" * 40)

    def test_matrix_rejects_failed_target_and_wrong_head(self) -> None:
        module = load_matrix()
        failed = passing_matrix()
        failed["targets"][0]["exit_code"] = 1
        with self.assertRaisesRegex(module.MatrixError, "PYTHON_MATRIX_TARGET_FAILED"):
            module.validate_matrix(failed, "a" * 40)
        with self.assertRaisesRegex(module.MatrixError, "PYTHON_MATRIX_HEAD_MISMATCH"):
            module.validate_matrix(passing_matrix("b" * 40), "a" * 40)

    def test_matrix_summary_is_sanitized(self) -> None:
        summary = load_matrix().validate_matrix(passing_matrix(), "a" * 40)
        self.assertEqual(summary["status"], "PASS")
        self.assertEqual(len(summary["targets"]), 4)
        self.assertNotIn("stdout", summary["targets"]["windows-python-3.11"])

    def test_entry_hardens_git_and_bytecode(self) -> None:
        text = ENTRY.read_text(encoding="utf-8")
        self.assertIn('os.environ["PYTHONDONTWRITEBYTECODE"] = "1"', text)
        self.assertIn('base.VerificationError("GIT_COMMAND_FAILED"', text)
        self.assertIn("base._git = stable_git", text)

    def test_wrapper_contract(self) -> None:
        text = WRAPPER.read_text(encoding="utf-8")
        for token in (
            '"3.11"', '"3.12"', '"3.13"',
            'WslDistribution = "Ubuntu"',
            'WslPythonExecutable = "python3.12"',
            "wsl.exe", "wslpath", '"--cd"',
            "WSL_HEAD_MISMATCH", "WSL_DIRTY_WORKTREE",
            "PYTHONDONTWRITEBYTECODE", "python-matrix.json",
            "local_python_matrix.py", "local_exact_head_verification_entry.py",
        ):
            self.assertIn(token, text)

    def test_docs_bind_same_decision(self) -> None:
        required = {
            ROOT / "docs/testing/LOCAL_EXACT_HEAD_VERIFICATION.md": "WSL2 Ubuntu Python 3.12",
            ROOT / "docs/decisions/SX_DEC_047_LOCAL_EXACT_HEAD_FALLBACK.md": "Windows + WSL2",
            ROOT / "기획서/50_제작_검증/SX_AUD_028_LOCAL_EXACT_HEAD_FALLBACK.md": "WINDOWS_WSL2_MATRIX",
        }
        for path, token in required.items():
            self.assertIn("SX-DEC-047", path.read_text(encoding="utf-8"))
            self.assertIn(token, path.read_text(encoding="utf-8"))


if __name__ == "__main__":
    unittest.main()
