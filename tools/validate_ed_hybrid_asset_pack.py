#!/usr/bin/env python3
import json
import struct
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ASSET_ROOT = ROOT / "art" / "production_candidates" / "ed_hybrid_v1"
MANIFEST = ASSET_ROOT / "manifest.json"
REQUIRED_TOP_KEYS = {"decision_id", "status", "art_direction", "family_targets", "assets"}
REQUIRED_ASSET_KEYS = {
    "path", "family", "role", "state", "provenance", "transparent",
    "runtime_integrated", "final_asset_approved"
}
PNG_SIG = b"\x89PNG\r\n\x1a\n"


def fail(message: str) -> None:
    raise ValueError(message)


def png_info(path: Path):
    with path.open("rb") as f:
        if f.read(8) != PNG_SIG:
            fail(f"not a PNG file: {path}")
        width = height = color_type = None
        has_trns = False
        while True:
            raw_len = f.read(4)
            if not raw_len:
                break
            if len(raw_len) != 4:
                fail(f"truncated PNG: {path}")
            length = struct.unpack(">I", raw_len)[0]
            chunk_type = f.read(4)
            data = f.read(length)
            crc = f.read(4)
            if len(data) != length or len(crc) != 4:
                fail(f"truncated PNG chunk: {path}")
            if chunk_type == b"IHDR":
                if length != 13:
                    fail(f"invalid IHDR: {path}")
                width, height, _bit_depth, color_type, _comp, _filter, _interlace = struct.unpack(">IIBBBBB", data)
            elif chunk_type == b"tRNS":
                has_trns = True
            elif chunk_type == b"IEND":
                break
        if not width or not height:
            fail(f"missing/invalid dimensions: {path}")
        return width, height, color_type in (4, 6) or has_trns


def validate() -> int:
    if not ASSET_ROOT.is_dir():
        fail(f"missing asset root: {ASSET_ROOT}")
    if not (ASSET_ROOT.parent / ".gdignore").is_file():
        fail("missing art/production_candidates/.gdignore")
    data = json.loads(MANIFEST.read_text(encoding="utf-8"))
    if not REQUIRED_TOP_KEYS <= data.keys():
        fail("manifest missing required top-level fields")
    if data["decision_id"] != "SX-DEC-051":
        fail("unexpected decision_id")
    if data["status"] != "GENERATED_PRODUCTION_CANDIDATE":
        fail("unexpected status")
    if data["art_direction"] != "E+D HYBRID · NEO-ARCADE READABILITY":
        fail("unexpected art_direction")
    if not isinstance(data["family_targets"], list) or not data["family_targets"]:
        fail("family_targets must be non-empty")
    if not isinstance(data["assets"], list):
        fail("assets must be a list")

    seen = set()
    prefix = Path("art/production_candidates/ed_hybrid_v1")
    for record in data["assets"]:
        if not REQUIRED_ASSET_KEYS <= record.keys():
            fail(f"asset record missing fields: {record}")
        rel = Path(record["path"])
        if rel in seen:
            fail(f"duplicate asset path: {rel}")
        seen.add(rel)
        if rel.suffix.lower() != ".png":
            fail(f"non-PNG candidate path: {rel}")
        if ".." in rel.parts or tuple(rel.parts[:len(prefix.parts)]) != prefix.parts:
            fail(f"asset path outside candidate root: {rel}")
        if record["runtime_integrated"] is not False:
            fail(f"runtime_integrated must be false: {rel}")
        if record["final_asset_approved"] is not False:
            fail(f"final_asset_approved must be false: {rel}")
        full = ROOT / rel
        if not full.is_file():
            fail(f"missing referenced asset: {rel}")
        width, height, has_alpha = png_info(full)
        if record.get("dimensions") and record["dimensions"] != [width, height]:
            fail(f"dimension mismatch: {rel}")
        if record["transparent"] and not has_alpha:
            fail(f"expected alpha/transparency: {rel}")
    print(f"PASS: {len(data['assets'])} assets validated for SX-DEC-051")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(validate())
    except Exception as exc:
        print(f"FAIL: {exc}", file=sys.stderr)
        raise SystemExit(1)
