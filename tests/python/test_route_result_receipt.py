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
        assert hashlib.sha256((folder / (sample["locale"] + "-build.png")).read_bytes()).hexdigest() == sample["build_capture_sha256"]
        assert hashlib.sha256((folder / (sample["locale"] + "-manifest-stress.png")).read_bytes()).hexdigest() == sample["manifest_stress_sha256"]
        assert "107.5" in sample["body"]  # Actual revision2 no-pickup route at product speed.
        assert hashlib.sha256((folder / (sample["locale"] + "-running.png")).read_bytes()).hexdigest() == sample["running_capture_sha256"]
        assert hashlib.sha256((folder / (sample["locale"] + ".png")).read_bytes()).hexdigest() == sample["capture_sha256"]
    assert "res://data/maps/route_book/rb08_caution_cut.json" in receipt["source_sha256_lf"]
    assert "res://tests/fixtures/route_book/route_book_witnesses.gd" in receipt["source_sha256_lf"]
    for path, expected in receipt["source_sha256_lf"].items():
        data = (ROOT / path.removeprefix("res://")).read_bytes().replace(b"\r\n", b"\n")
        assert hashlib.sha256(data).hexdigest() == expected, path
