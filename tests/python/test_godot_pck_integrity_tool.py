from __future__ import annotations

import hashlib
import importlib.util
import json
import struct
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
TOOL = ROOT / "tools/verify_godot_pck_integrity.py"


def _load_tool():
    if not TOOL.is_file():
        raise AssertionError("tools/verify_godot_pck_integrity.py must exist")
    spec = importlib.util.spec_from_file_location("verify_godot_pck_integrity", TOOL)
    if spec is None or spec.loader is None:
        raise AssertionError("unable to load PCK integrity verifier")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def _build_test_pck(
    path: Path,
    files: dict[str, bytes],
    pack_flags: int = 2,
    entry_flags: int = 0,
    trailing_bytes: bytes = b"",
) -> None:
    file_base = 112
    data = bytearray()
    records: list[tuple[str, int, int, bytes, int]] = []

    for name, payload in files.items():
        offset = len(data)
        data.extend(payload)
        records.append((name, offset, len(payload), hashlib.md5(payload).digest(), entry_flags))

    directory_offset = file_base + len(data)
    header = bytearray()
    header.extend(b"GDPC")
    header.extend(struct.pack("<IIIII", 4, 4, 7, 1, pack_flags))
    header.extend(struct.pack("<QQ", file_base, directory_offset))
    header.extend(b"\x00" * 64)
    header.extend(b"\x00" * (file_base - len(header)))
    if len(header) != file_base:
        raise AssertionError(f"unexpected synthetic header size: {len(header)}")

    directory = bytearray(struct.pack("<I", len(records)))
    for name, offset, size, md5_digest, current_entry_flags in records:
        encoded = name.encode("utf-8") + b"\x00"
        padded_length = (len(encoded) + 3) & ~3
        encoded += b"\x00" * (padded_length - len(encoded))
        directory.extend(struct.pack("<I", len(encoded)))
        directory.extend(encoded)
        directory.extend(struct.pack("<QQ", offset, size))
        directory.extend(md5_digest)
        directory.extend(struct.pack("<I", current_entry_flags))

    path.write_bytes(header + data + directory + trailing_bytes)


class GodotPckIntegrityToolTests(unittest.TestCase):
    def test_optional_inventory_preserves_pack_order_sizes_and_verified_status(self) -> None:
        tool = _load_tool()
        with tempfile.TemporaryDirectory() as tmp:
            pck = Path(tmp) / "inventory.pck"
            files = {"art/example.png.import": b"hello", "data/map.json": b"{}"}
            _build_test_pck(pck, files)
            self.assertNotIn("entries", tool.inspect_pck(pck))
            summary = tool.inspect_pck(pck, include_entries=True)
        self.assertEqual([entry["path"] for entry in summary["entries"]], list(files))
        for entry, payload in zip(summary["entries"], files.values()):
            self.assertEqual(entry["size_bytes"], len(payload))
            self.assertEqual(entry["expected_md5"], hashlib.md5(payload).hexdigest())
            self.assertEqual(entry["integrity_status"], "VERIFIED")

    def test_inventory_does_not_mark_tampered_payload_verified(self) -> None:
        tool = _load_tool()
        with tempfile.TemporaryDirectory() as tmp:
            pck = Path(tmp) / "tampered.pck"
            _build_test_pck(pck, {"data/example.json": b"abcdef"})
            raw = bytearray(pck.read_bytes())
            raw[112] ^= 1
            pck.write_bytes(raw)
            summary = tool.inspect_pck(pck, include_entries=True)
        self.assertFalse(summary["integrity_pass"])
        self.assertEqual(summary["entries"][0]["integrity_status"], "MD5_MISMATCH")

    def test_inventory_reports_out_of_bounds_entry_without_hashing_it(self) -> None:
        tool = _load_tool()
        with tempfile.TemporaryDirectory() as tmp:
            pck = Path(tmp) / "bounds.pck"
            _build_test_pck(pck, {"x": b"abc"})
            raw = bytearray(pck.read_bytes())
            # Directory: count, path length, padded 'x', then relative offset.
            struct.pack_into("<Q", raw, 115 + 4 + 4 + 4, 999999)
            pck.write_bytes(raw)
            summary = tool.inspect_pck(pck, include_entries=True)
        self.assertFalse(summary["integrity_pass"])
        self.assertEqual(summary["bounds_error_count"], 1)
        self.assertEqual(summary["entries"][0]["integrity_status"], "BOUNDS_ERROR")

    def test_cli_inventory_option_preserves_summary_and_writes_same_json(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            pck = Path(tmp) / "cli.pck"
            output = Path(tmp) / "inventory.json"
            _build_test_pck(pck, {"data/a.json": b"{}"})
            result = subprocess.run(
                [sys.executable, str(TOOL), str(pck), "--include-entries", "--json-out", str(output)],
                capture_output=True, text=True, check=False,
            )
            self.assertEqual(result.returncode, 0, result.stderr)
            summary = json.loads(result.stdout)
            self.assertEqual(summary, json.loads(output.read_text(encoding="utf-8")))
            self.assertEqual(summary["entries"][0]["path"], "data/a.json")

    def test_valid_v4_relative_filebase_pack_verifies_all_entries(self) -> None:
        tool = _load_tool()
        with tempfile.TemporaryDirectory() as tmp:
            pck = Path(tmp) / "valid.pck"
            _build_test_pck(
                pck,
                {
                    "data/maps/tutorial/tut_01.json": b'{"ok": true}',
                    "art/product_assets/ed_hybrid_v1/core/example.png.import": b'[remap]\npath="res://.godot/imported/example.ctex"\n',
                },
            )
            summary = tool.inspect_pck(pck)

        self.assertEqual(summary["pack_format_version"], 4)
        self.assertEqual(summary["engine_version"], "4.7.1")
        self.assertEqual(summary["file_count"], 2)
        self.assertEqual(summary["verified_entry_count"], 2)
        self.assertEqual(summary["md5_mismatch_count"], 0)
        self.assertEqual(summary["bounds_error_count"], 0)
        self.assertEqual(summary["trailing_unverified_bytes"], 0)

    def test_v4_reader_uses_file_base_even_when_relative_flag_is_absent(self) -> None:
        tool = _load_tool()
        with tempfile.TemporaryDirectory() as tmp:
            pck = Path(tmp) / "v4-no-rel-flag.pck"
            _build_test_pck(pck, {"data/example.json": b"abcdef"}, pack_flags=0)
            summary = tool.inspect_pck(pck)

        self.assertTrue(summary["integrity_pass"])
        self.assertEqual(summary["verified_entry_count"], 1)

    def test_payload_tamper_is_fail_closed(self) -> None:
        tool = _load_tool()
        with tempfile.TemporaryDirectory() as tmp:
            pck = Path(tmp) / "tampered.pck"
            _build_test_pck(pck, {"data/example.json": b"abcdef"})
            raw = bytearray(pck.read_bytes())
            raw[112] ^= 0x01
            pck.write_bytes(raw)
            summary = tool.inspect_pck(pck)

        self.assertEqual(summary["md5_mismatch_count"], 1)
        self.assertFalse(summary["integrity_pass"])

    def test_encrypted_directory_is_rejected_without_key(self) -> None:
        tool = _load_tool()
        with tempfile.TemporaryDirectory() as tmp:
            pck = Path(tmp) / "encrypted-flag.pck"
            _build_test_pck(pck, {"data/example.json": b"{}"}, pack_flags=3)
            with self.assertRaises(tool.PckFormatError):
                tool.inspect_pck(pck)

    def test_nonzero_file_flags_are_rejected_without_specialized_support(self) -> None:
        tool = _load_tool()
        with tempfile.TemporaryDirectory() as tmp:
            pck = Path(tmp) / "file-flags.pck"
            _build_test_pck(pck, {"data/example.json": b"{}"}, entry_flags=1)
            with self.assertRaises(tool.PckFormatError):
                tool.inspect_pck(pck)

    def test_standalone_pack_rejects_unverified_trailing_bytes(self) -> None:
        tool = _load_tool()
        with tempfile.TemporaryDirectory() as tmp:
            pck = Path(tmp) / "trailing.pck"
            _build_test_pck(pck, {"data/example.json": b"{}"}, trailing_bytes=b"UNVERIFIED")
            summary = tool.inspect_pck(pck)

        self.assertEqual(summary["trailing_unverified_bytes"], len(b"UNVERIFIED"))
        self.assertFalse(summary["integrity_pass"])


if __name__ == "__main__":
    unittest.main()
