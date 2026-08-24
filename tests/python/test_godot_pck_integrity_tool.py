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


def _build_test_pck(path: Path, files: dict[str, bytes], flags: int = 2) -> None:
    header_size = 112
    file_base = header_size
    data = bytearray()
    records: list[tuple[str, int, int, bytes, int]] = []

    for name, payload in files.items():
        offset = len(data)
        data.extend(payload)
        records.append((name, offset, len(payload), hashlib.md5(payload).digest(), 0))

    directory_offset = file_base + len(data)
    header = bytearray()
    header.extend(b"GDPC")
    header.extend(struct.pack("<IIIII", 4, 4, 7, 1, flags))
    header.extend(struct.pack("<QQ", file_base, directory_offset))
    header.extend(b"\x00" * 64)
    if len(header) != header_size:
        raise AssertionError(f"unexpected synthetic header size: {len(header)}")

    directory = bytearray(struct.pack("<I", len(records)))
    for name, offset, size, md5_digest, entry_flags in records:
        encoded = name.encode("utf-8") + b"\x00"
        padded_length = (len(encoded) + 3) & ~3
        encoded += b"\x00" * (padded_length - len(encoded))
        directory.extend(struct.pack("<I", len(encoded)))
        directory.extend(encoded)
        directory.extend(struct.pack("<QQ", offset, size))
        directory.extend(md5_digest)
        directory.extend(struct.pack("<I", entry_flags))

    path.write_bytes(header + data + directory)


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
            _build_test_pck(pck, {"data/example.json": b"{}"}, flags=3)
            with self.assertRaises(tool.PckFormatError):
                tool.inspect_pck(pck)


if __name__ == "__main__":
    unittest.main()
