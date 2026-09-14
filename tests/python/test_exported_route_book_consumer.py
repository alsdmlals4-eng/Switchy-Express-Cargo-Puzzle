"""Execute the real package verifier; assertions also work against a mounted PCK."""
import os
from pathlib import Path
import subprocess

import pytest

ROOT = Path(__file__).resolve().parents[2]


@pytest.fixture(scope="module")
def imported_godot():
    binary = os.environ.get("GODOT_BINARY")
    if not binary:
        pytest.skip("GODOT_BINARY required for real consumer execution")
    # Fresh CI checkouts have neither imported textures nor the script-class cache.
    imported = subprocess.run(
        [binary, "--headless", "--editor", "--import", "--path", str(ROOT), "--quit"],
        capture_output=True, text=True, encoding="utf-8", errors="replace", timeout=180,
    )
    assert imported.returncode == 0, imported.stdout + imported.stderr
    return binary


def test_package_verifier_enters_all_current_route_book_stages(imported_godot):
    result = subprocess.run(
        [imported_godot, "--headless", "--path", str(ROOT), "--script",
         "res://tools/validation/verify_exported_runtime_json.gd"],
        capture_output=True, text=True, encoding="utf-8", errors="replace", timeout=60,
    )
    output = result.stdout + result.stderr
    assert result.returncode == 0, output
    assert "ROUTE_BOOK_PACK_PROOF: PASS books=3 stages=18 build_entries=18" in output
    assert "SCRIPT ERROR:" not in output and "ERROR:" not in output, output


def test_package_verifier_rejects_actual_corrupt_book_overlay(imported_godot):
    result = subprocess.run(
        [imported_godot, "--headless", "--path", str(ROOT), "--script",
         "res://tests/runtime/route_book_pack_negative_runner.gd"],
        capture_output=True, text=True, encoding="utf-8", errors="replace", timeout=60,
    )
    output = result.stdout + result.stderr
    assert result.returncode == 1, output
    assert "unreadable exported Route Book definition/copy: ROUTE_BOOK_01" in output
    assert "ROUTE_BOOK_PACK_PROOF: PASS" not in output
    assert "SCRIPT ERROR:" not in output, output
