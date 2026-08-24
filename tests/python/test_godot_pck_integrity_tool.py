from __future__ import annotations

import hashlib
import importlib.util
import struct
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
