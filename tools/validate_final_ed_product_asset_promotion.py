#!/usr/bin/env python3
import json
import struct
import zlib
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CANDIDATE_MANIFEST = ROOT / "art" / "production_candidates" / "ed_hybrid_v1" / "manifest.json"
PRODUCT_ROOT = ROOT / "art" / "product_assets" / "ed_hybrid_v1"
PRODUCT_MANIFEST = PRODUCT_ROOT / "manifest.json"
ALLOWED_DISPOSITIONS = {"PROMOTE_AS_IS", "PROMOTE_AFTER_REVISION", "REPLACE"}
PNG_SIGNATURE = b"\x89PNG\r\n\x1a\n"


def _png_info(path: Path):
    raw = path.read_bytes()
    if not raw.startswith(PNG_SIGNATURE) or len(raw) < 33:
        raise ValueError(f"invalid PNG signature/header: {path.relative_to(ROOT)}")

    pos = len(PNG_SIGNATURE)
    width = height = bit_depth = color_type = None
    has_trns = False
    idat = bytearray()
    saw_iend = False

    while pos + 12 <= len(raw):
        length = struct.unpack(">I", raw[pos:pos + 4])[0]
        chunk_type = raw[pos + 4:pos + 8]
        data_start = pos + 8
        data_end = data_start + length
        crc_end = data_end + 4
        if crc_end > len(raw):
            raise ValueError(f"truncated PNG chunk: {path.relative_to(ROOT)}")
        chunk_data = raw[data_start:data_end]
        expected_crc = struct.unpack(">I", raw[data_end:crc_end])[0]
        actual_crc = zlib.crc32(chunk_type)
        actual_crc = zlib.crc32(chunk_data, actual_crc) & 0xFFFFFFFF
        if expected_crc != actual_crc:
            raise ValueError(f"PNG CRC mismatch: {path.relative_to(ROOT)} · {chunk_type.decode('ascii', 'replace')}")

        if chunk_type == b"IHDR":
            if length != 13:
                raise ValueError(f"invalid PNG IHDR length: {path.relative_to(ROOT)}")
            width, height, bit_depth, color_type = struct.unpack(">IIBB", chunk_data[:10])
        elif chunk_type == b"tRNS":
            has_trns = True
        elif chunk_type == b"IDAT":
            idat.extend(chunk_data)
        elif chunk_type == b"IEND":
            saw_iend = True
            break
        pos = crc_end

    if width is None or height is None or color_type is None:
        raise ValueError(f"missing PNG IHDR: {path.relative_to(ROOT)}")
    if width <= 0 or height <= 0:
        raise ValueError(f"invalid PNG dimensions: {path.relative_to(ROOT)}")
    if not idat:
        raise ValueError(f"missing PNG IDAT: {path.relative_to(ROOT)}")
    if not saw_iend:
        raise ValueError(f"missing PNG IEND: {path.relative_to(ROOT)}")
    try:
        zlib.decompress(bytes(idat))
    except zlib.error as exc:
        raise ValueError(f"corrupt PNG IDAT stream: {path.relative_to(ROOT)} · {exc}") from exc

    alpha_capable = color_type in {4, 6} or has_trns
    return width, height, bit_depth, color_type, alpha_capable


def validate():
    errors = []

    try:
        candidate = json.loads(CANDIDATE_MANIFEST.read_text(encoding="utf-8"))
        product = json.loads(PRODUCT_MANIFEST.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        print(f"final E+D product asset promotion: FAIL · {exc}")
        return 1

    candidate_paths = [record["path"] for record in candidate.get("assets", [])]
    candidate_path_set = set(candidate_paths)
    ledger = product.get("source_candidate_dispositions", [])
    ledger_paths = [record.get("source_candidate") for record in ledger]

    if candidate.get("decision_id") != "SX-DEC-051":
        errors.append("candidate decision must remain SX-DEC-051")
    if candidate.get("candidate_count") != 31 or len(candidate_paths) != 31:
        errors.append("candidate source must remain complete at 31 records")
    if product.get("decision_id") != "SX-DEC-053":
        errors.append("product decision must be SX-DEC-053")
    if product.get("source_decision_id") != "SX-DEC-051":
        errors.append("product source decision must be SX-DEC-051")
    if product.get("art_direction") != "E+D HYBRID · NEO-ARCADE READABILITY":
        errors.append("unexpected product art direction")
    if product.get("runtime_integrated") is not False:
        errors.append("runtime_integrated must remain false")
    if product.get("source_candidate_count") != 31:
        errors.append("source_candidate_count must be 31")
    if len(ledger) != 31 or len(set(ledger_paths)) != 31:
        errors.append("disposition ledger must contain 31 unique source candidates")
    if set(ledger_paths) != candidate_path_set:
        errors.append("disposition ledger must exactly cover candidate manifest paths")

    for record in ledger:
        if record.get("source_decision_id") != "SX-DEC-051":
            errors.append(f"bad source_decision_id: {record.get('source_candidate')}")
        if record.get("disposition") not in ALLOWED_DISPOSITIONS:
            errors.append(f"unknown disposition: {record.get('source_candidate')}")
        if not str(record.get("reason", "")).strip():
            errors.append(f"missing disposition reason: {record.get('source_candidate')}")

    seen_product_paths = set()
    for asset in product.get("assets", []):
        rel = asset.get("path", "")
        source = asset.get("source_candidate", "")
        if not rel.startswith("art/product_assets/ed_hybrid_v1/"):
            errors.append(f"product asset outside approved root: {rel}")
            continue
        if rel in seen_product_paths:
            errors.append(f"duplicate product asset path: {rel}")
        seen_product_paths.add(rel)
        if source not in candidate_path_set:
            errors.append(f"product asset has unknown candidate source: {rel}")
        path = ROOT / rel
        if not path.is_file():
            errors.append(f"missing promoted asset: {rel}")
            continue
        try:
            width, height, _, _, alpha_capable = _png_info(path)
        except ValueError as exc:
            errors.append(str(exc))
            continue
        if asset.get("dimensions") != [width, height]:
            errors.append(f"dimension metadata mismatch: {rel}")
        if asset.get("transparent") is True and not alpha_capable:
            errors.append(f"transparent asset is not alpha-capable: {rel}")
        if "core_train_locomotive" in rel and asset.get("visual_scale") != 1.0:
            errors.append(f"locomotive visual_scale must be 1.0: {rel}")
        if "core_wagon_cargo_" in rel:
            scale = asset.get("visual_scale")
            if not isinstance(scale, (int, float)) or not (0.70 <= scale <= 0.75):
                errors.append(f"wagon visual_scale must be within 0.70..0.75: {rel}")
            transform = asset.get("transform", {})
            if transform.get("kind") != "centered_scale" or transform.get("scale") != scale:
                errors.append(f"wagon centered_scale provenance mismatch: {rel}")

    if errors:
        print("final E+D product asset promotion: FAIL")
        for error in errors:
            print(f"- {error}")
        return 1

    print(
        "final E+D product asset promotion: PASS · "
        f"dispositions={len(ledger)} · promoted={len(product.get('assets', []))} · runtime_integrated=false"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(validate())
