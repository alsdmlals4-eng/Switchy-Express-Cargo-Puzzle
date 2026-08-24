#!/usr/bin/env python3
from __future__ import annotations

import argparse
import hashlib
import json
import os
import struct
from collections import Counter
from pathlib import Path
from typing import BinaryIO, Iterable


MAGIC = b"GDPC"
SUPPORTED_PACK_VERSIONS = {3, 4}
PACK_DIR_ENCRYPTED = 1 << 0
PACK_REL_FILEBASE = 1 << 1
PACK_SPARSE_BUNDLE = 1 << 2
HEADER_RESERVED_BYTES = 64
MAX_PATH_BYTES = 1 << 20
HASH_CHUNK_SIZE = 1 << 20


class PckFormatError(ValueError):
    pass


def _read_exact(handle: BinaryIO, size: int, label: str) -> bytes:
    data = handle.read(size)
    if len(data) != size:
        raise PckFormatError(f"truncated PCK while reading {label}: expected={size} got={len(data)}")
    return data


def _u32(handle: BinaryIO, label: str) -> int:
    return struct.unpack("<I", _read_exact(handle, 4, label))[0]


def _u64(handle: BinaryIO, label: str) -> int:
    return struct.unpack("<Q", _read_exact(handle, 8, label))[0]


def _hash_region(handle: BinaryIO, offset: int, size: int) -> str:
    digest = hashlib.md5()
    handle.seek(offset)
    remaining = size
    while remaining:
        chunk = handle.read(min(HASH_CHUNK_SIZE, remaining))
        if not chunk:
            raise PckFormatError(
                f"truncated PCK while hashing payload: offset={offset} expected_size={size}"
            )
        digest.update(chunk)
        remaining -= len(chunk)
    return digest.hexdigest()


def inspect_pck(path: str | os.PathLike[str], prefixes: Iterable[str] = ()) -> dict:
    pck_path = Path(path)
    file_size = pck_path.stat().st_size
    if file_size < 40:
        raise PckFormatError(f"PCK is too small: {file_size} bytes")

    prefix_list = list(prefixes)
    extension_counts: Counter[str] = Counter()
    prefix_counts = {prefix: 0 for prefix in prefix_list}
    prefix_extension_counts = {prefix: Counter() for prefix in prefix_list}
    mismatch_count = 0
    bounds_error_count = 0
    verified_count = 0
    nonzero_entry_flags = 0

    with pck_path.open("rb") as handle:
        if _read_exact(handle, 4, "magic") != MAGIC:
            raise PckFormatError("PCK magic mismatch; expected GDPC")

        pack_version = _u32(handle, "pack format version")
        engine_major = _u32(handle, "engine major")
        engine_minor = _u32(handle, "engine minor")
        engine_patch = _u32(handle, "engine patch")
        pack_flags = _u32(handle, "pack flags")

        if pack_version not in SUPPORTED_PACK_VERSIONS:
            raise PckFormatError(
                f"unsupported PCK format version {pack_version}; supported={sorted(SUPPORTED_PACK_VERSIONS)}"
            )
        if pack_flags & PACK_DIR_ENCRYPTED:
            raise PckFormatError("encrypted PCK directory is unsupported without a key")
        if pack_flags & PACK_SPARSE_BUNDLE:
            raise PckFormatError("sparse PCK bundles are outside this verifier contract")

        raw_file_base = _u64(handle, "file base")
        raw_directory_offset = _u64(handle, "directory offset")
        _read_exact(handle, HEADER_RESERVED_BYTES, "reserved header")

        # This verifier intentionally accepts standalone .pck files only.
        # For V3/V4 standalone packs, header offsets are relative to PCK start (zero).
        file_base = raw_file_base
        directory_offset = raw_directory_offset

        if directory_offset + 4 > file_size:
            raise PckFormatError(
                f"directory offset outside PCK: offset={directory_offset} size={file_size}"
            )
        if file_base > file_size:
            raise PckFormatError(f"file base outside PCK: file_base={file_base} size={file_size}")

        handle.seek(directory_offset)
        file_count = _u32(handle, "file count")

        entries = []
        for index in range(file_count):
            path_length = _u32(handle, f"entry[{index}] path length")
            if path_length <= 0 or path_length > MAX_PATH_BYTES:
                raise PckFormatError(
                    f"invalid entry[{index}] path length: {path_length}"
                )
            path_raw = _read_exact(handle, path_length, f"entry[{index}] path")
            try:
                entry_path = path_raw.rstrip(b"\x00").decode("utf-8")
            except UnicodeDecodeError as exc:
                raise PckFormatError(f"entry[{index}] path is not UTF-8") from exc

            relative_offset = _u64(handle, f"entry[{index}] offset")
            payload_size = _u64(handle, f"entry[{index}] size")
            expected_md5 = _read_exact(handle, 16, f"entry[{index}] md5").hex()
            entry_flags = _u32(handle, f"entry[{index}] flags")
            if entry_flags:
                nonzero_entry_flags += 1

            actual_offset = (
                file_base + relative_offset
                if pack_flags & PACK_REL_FILEBASE
                else relative_offset
            )
            payload_end = actual_offset + payload_size
            bounds_ok = actual_offset <= file_size and payload_end <= file_size

            extension = Path(entry_path).suffix.lower() or "<none>"
            extension_counts[extension] += 1
            for prefix in prefix_list:
                if entry_path.startswith(prefix):
                    prefix_counts[prefix] += 1
                    prefix_extension_counts[prefix][extension] += 1

            entries.append(
                (
                    entry_path,
                    actual_offset,
                    payload_size,
                    expected_md5,
                    bounds_ok,
                )
            )

        directory_end = handle.tell()

        for _entry_path, actual_offset, payload_size, expected_md5, bounds_ok in entries:
            if not bounds_ok:
                bounds_error_count += 1
                continue
            actual_md5 = _hash_region(handle, actual_offset, payload_size)
            if actual_md5 != expected_md5:
                mismatch_count += 1
            else:
                verified_count += 1

    integrity_pass = (
        mismatch_count == 0
        and bounds_error_count == 0
        and verified_count == file_count
    )

    return {
        "path": str(pck_path),
        "file_size_bytes": file_size,
        "pack_format_version": pack_version,
        "engine_version": f"{engine_major}.{engine_minor}.{engine_patch}",
        "pack_flags": pack_flags,
        "relative_filebase": bool(pack_flags & PACK_REL_FILEBASE),
        "file_base": file_base,
        "directory_offset": directory_offset,
        "directory_end": directory_end,
        "file_count": file_count,
        "verified_entry_count": verified_count,
        "md5_mismatch_count": mismatch_count,
        "bounds_error_count": bounds_error_count,
        "nonzero_entry_flags_count": nonzero_entry_flags,
        "extension_counts": dict(sorted(extension_counts.items())),
        "prefix_counts": prefix_counts,
        "prefix_extension_counts": {
            prefix: dict(sorted(counts.items()))
            for prefix, counts in prefix_extension_counts.items()
        },
        "integrity_pass": integrity_pass,
    }


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Fail-closed integrity verifier for standalone Godot 4.x PCK files."
    )
    parser.add_argument("pck", type=Path)
    parser.add_argument(
        "--prefix",
        action="append",
        default=[],
        help="Count directory entries beginning with this path prefix. May be repeated.",
    )
    parser.add_argument(
        "--json-out",
        type=Path,
        help="Optionally write the JSON summary to this path.",
    )
    args = parser.parse_args()

    try:
        summary = inspect_pck(args.pck, prefixes=args.prefix)
    except (OSError, PckFormatError) as exc:
        print(json.dumps({"integrity_pass": False, "error": str(exc)}, ensure_ascii=False))
        return 2

    output = json.dumps(summary, indent=2, sort_keys=True, ensure_ascii=False)
    print(output)
    if args.json_out is not None:
        args.json_out.write_text(output + "\n", encoding="utf-8")
    return 0 if summary["integrity_pass"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
