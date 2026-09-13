"""Preserve crash observations without turning a successful retry into a fix."""
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]


def test_native_diagnostic_source_and_log_bindings():
    folder = ROOT / "evidence/runtime/native-exit-20260913"
    receipt = json.loads((folder / "source-bindings.json").read_text(encoding="utf-8"))
    assert receipt["status"] == "NOT_FIXED"
    for name, digest in receipt["logs_sha256"].items():
        assert hashlib.sha256((folder / name).read_bytes()).hexdigest() == digest
    for name, digest in receipt["instrumented_sources_sha256_lf"].items():
        raw = (ROOT / name).read_bytes().replace(b"\r\n", b"\n")
        assert hashlib.sha256(raw).hexdigest() == digest
    for name in ("native-pair-isolated.log", "native-e2e-isolated.log"):
        assert "ISOLATION SUMMARY" not in (folder / name).read_text(encoding="utf-8")
    assert "TEST SUMMARY" not in (folder / "hud-complete-postmerge.log").read_text(encoding="utf-8")
