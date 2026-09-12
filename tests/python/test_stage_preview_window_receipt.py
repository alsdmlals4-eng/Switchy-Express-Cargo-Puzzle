"""Current actual-window preview QA remains bound to its inspected inputs."""
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
RECEIPT = ROOT / "evidence/runtime/stage-preview-window-20260913/receipt.json"


def test_matrix_reports_actual_sizes_and_pointer_checks():
    receipt = json.loads(RECEIPT.read_text(encoding="utf-8"))
    assert receipt["status"] == "PASS"
    assert receipt["checked"] == 144
    assert receipt["pointer_begin_checks"] == 3
    assert receipt["failures"] == []
    assert [entry["actual"] for entry in receipt["window_sizes"]] == [
        "(960, 540)", "(1280, 720)", "(1600, 900)"
    ]
    assert all(entry["requested"] == entry["actual"] for entry in receipt["window_sizes"])
    assert receipt["restored_size"] == "(1280, 720)"
    assert receipt["restored_locale"] == "ko"
    assert receipt["human_review"] == receipt["release_review"] == "NOT_RUN"


def test_current_preview_input_and_capture_hashes():
    receipt = json.loads(RECEIPT.read_text(encoding="utf-8"))
    assert receipt["source_hash_policy"] == "SHA256_UTF8_TEXT_CRLF_TO_LF"
    assert len(receipt["source_hashes"]) >= 27
    assert len(receipt["capture_sha256"]) == 4
    for resource, expected in receipt["source_hashes"].items():
        data = (ROOT / resource.removeprefix("res://")).read_bytes().replace(b"\r\n", b"\n")
        assert hashlib.sha256(data).hexdigest() == expected, resource
    for resource, expected in receipt["capture_sha256"].items():
        assert hashlib.sha256((ROOT / resource.removeprefix("res://")).read_bytes()).hexdigest() == expected


def test_rejected_embedded_sizes_are_not_promoted_to_pass():
    failed = json.loads((RECEIPT.parent / "embedded-size-rejected.json").read_text(encoding="utf-8"))
    assert failed["status"] == "FAIL"
    assert len(failed["failures"]) == 2
    assert any(entry["requested"] != entry["actual"] for entry in failed["window_sizes"])
