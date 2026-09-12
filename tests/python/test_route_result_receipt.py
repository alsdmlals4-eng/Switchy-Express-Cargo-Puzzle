"""Runtime result capture bindings, not human review."""
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]


def test_result_runtime_receipt():
    folder = ROOT / "evidence/runtime/route-result-20260913"
    receipt = json.loads((folder / "receipt.json").read_text(encoding="utf-8"))
    assert receipt["status"] == "PASS" and not receipt["failures"]
    assert receipt["human_review"] == "NOT_RUN"
    assert receipt["window"] == "(960, 540)"
    assert [sample["locale"] for sample in receipt["samples"]] == ["ko", "en", "ja", "zh-Hans"]
    for sample in receipt["samples"]:
        assert "108.7" in sample["body"]
        assert hashlib.sha256((folder / (sample["locale"] + ".png")).read_bytes()).hexdigest() == sample["capture_sha256"]
    for path, expected in receipt["source_sha256_lf"].items():
        data = (ROOT / path.removeprefix("res://")).read_bytes().replace(b"\r\n", b"\n")
        assert hashlib.sha256(data).hexdigest() == expected, path
