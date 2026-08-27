#!/usr/bin/env python3
import json
import hashlib
import struct
import zlib
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CANDIDATE_MANIFEST = ROOT / "art" / "production_candidates" / "ed_hybrid_v1" / "manifest.json"
PRODUCT_ROOT = ROOT / "art" / "product_assets" / "ed_hybrid_v1"
PRODUCT_MANIFEST = PRODUCT_ROOT / "manifest.json"
SEMANTIC_MANIFEST = PRODUCT_ROOT / "semantic_manifest_sx_dec_054.json"
BUILD_SEMANTIC_MANIFEST = PRODUCT_ROOT / "semantic_manifest_sx_dec_054_build_2b.json"
VFX_SEMANTIC_MANIFEST = PRODUCT_ROOT / "semantic_manifest_sx_dec_054_vfx_2c.json"
TITLE_HERO_MANIFEST = PRODUCT_ROOT / "shells" / "shell_title_hero_manifest.json"
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
            raise ValueError(
                f"PNG CRC mismatch: {path.relative_to(ROOT)} · {chunk_type.decode('ascii', 'replace')}"
            )

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


def scan_candidate_health(product):
    disposition_by_source = {
        record["source_candidate"]: record["disposition"]
        for record in product.get("source_candidate_dispositions", [])
    }
    corrupt = []
    for source, disposition in sorted(disposition_by_source.items()):
        path = ROOT / source
        try:
            _png_info(path)
        except (OSError, ValueError) as exc:
            corrupt.append((source, disposition, str(exc)))
    return corrupt


def validate():
    errors = []

    try:
        candidate = json.loads(CANDIDATE_MANIFEST.read_text(encoding="utf-8"))
        product = json.loads(PRODUCT_MANIFEST.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        print(f"final E+D product asset promotion: FAIL · {exc}")
        return 1

    runtime_product_paths = set()
    if not TITLE_HERO_MANIFEST.is_file():
        errors.append(f"missing runtime consumer asset manifest: {TITLE_HERO_MANIFEST.relative_to(ROOT)}")
    else:
        try:
            title_hero = json.loads(TITLE_HERO_MANIFEST.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError) as exc:
            errors.append(f"invalid runtime consumer asset manifest: {exc}")
            title_hero = {}
        title_path = title_hero.get("path", "")
        runtime_product_paths.add(title_path)
        if title_hero.get("asset_id") != "SX-TITLE-HERO-001":
            errors.append("runtime title hero asset_id mismatch")
        if title_hero.get("status") != "RUNTIME_INTEGRATED_VERIFIED":
            errors.append("runtime title hero must be integration-verified")
        if title_hero.get("consumer_status") != "VERIFIED":
            errors.append("runtime title hero consumer must be verified")
        if title_hero.get("dual_preservation_status") != "APPROVED_DUAL_PRESERVED":
            errors.append("runtime title hero dual preservation must be complete")
        if not str(title_hero.get("runtime_consumer", "")).startswith(
            "game/demo/vertical_slice_demo.tscn"
        ):
            errors.append("runtime title hero must name the actual title scene consumer")
        if not title_path.startswith("art/product_assets/ed_hybrid_v1/shells/"):
            errors.append(f"runtime title hero path outside shell product root: {title_path}")
        title_file = ROOT / title_path
        if not title_file.is_file():
            errors.append(f"missing runtime title hero PNG: {title_path}")
        else:
            try:
                width, height, _, _, _ = _png_info(title_file)
                if title_hero.get("dimensions") != [width, height]:
                    errors.append("runtime title hero dimension metadata mismatch")
                actual_sha256 = hashlib.sha256(title_file.read_bytes()).hexdigest()
                if title_hero.get("sha256") != actual_sha256:
                    errors.append("runtime title hero SHA-256 metadata mismatch")
            except ValueError as exc:
                errors.append(str(exc))

    semantic_product_paths = set()
    for semantic_manifest, expected_batch in (
        (SEMANTIC_MANIFEST, "RUN_2A"),
        (BUILD_SEMANTIC_MANIFEST, "BUILD_2B"),
        (VFX_SEMANTIC_MANIFEST, "VFX_2C"),
    ):
        if not semantic_manifest.is_file():
            errors.append(f"missing SX-DEC-054 sidecar manifest: {semantic_manifest.relative_to(ROOT)}")
            continue
        try:
            semantic = json.loads(semantic_manifest.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError) as exc:
            errors.append(f"invalid SX-DEC-054 sidecar manifest {semantic_manifest.name}: {exc}")
            continue
        if semantic.get("decision_id") != "SX-DEC-054":
            errors.append(f"semantic sidecar decision must be SX-DEC-054: {semantic_manifest.name}")
        if semantic.get("batch") != expected_batch:
            errors.append(
                f"semantic sidecar batch must be {expected_batch}: {semantic_manifest.name}"
            )
        semantic_paths = {
            record.get("path")
            for record in semantic.get("semantic_assets", [])
            if record.get("path")
        }
        if semantic_product_paths.intersection(semantic_paths):
            errors.append(f"SX-DEC-054 sidecar ownership overlaps: {semantic_manifest.name}")
        semantic_product_paths.update(semantic_paths)

    candidate_paths = [record["path"] for record in candidate.get("assets", [])]
    candidate_path_set = set(candidate_paths)
    candidate_by_path = {
        record["path"]: record for record in candidate.get("assets", [])
    }
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
    if product.get("promoted_asset_count") != len(product.get("assets", [])):
        errors.append("promoted_asset_count must equal manifest assets length")
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

    corrupt_sources = scan_candidate_health(product)
    for source, disposition, detail in corrupt_sources:
        if disposition == "PROMOTE_AS_IS":
            errors.append(f"PROMOTE_AS_IS source PNG is corrupt: {source} · {detail}")

    seen_product_paths = set()
    authoritative_slice_count = 0
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

        slice_name = asset.get("authoritative_slice_name")
        if slice_name:
            authoritative_slice_count += 1
            source_record = candidate_by_path.get(source, {})
            source_slices = {
                item.get("name"): item
                for item in source_record.get("slices", [])
                if item.get("name")
            }
            source_slice = source_slices.get(slice_name)
            if source_slice is None:
                errors.append(f"unknown authoritative source slice: {rel} · {slice_name}")
            else:
                transform = asset.get("transform", {})
                bounds = source_slice.get("bounds")
                if Path(rel).stem != slice_name:
                    errors.append(f"authoritative slice filename mismatch: {rel} · {slice_name}")
                if transform.get("kind") != "crop":
                    errors.append(f"authoritative slice must use crop transform: {rel}")
                if transform.get("bounds") != bounds:
                    errors.append(f"authoritative slice bounds drift: {rel}")
                if isinstance(bounds, list) and len(bounds) == 4:
                    if asset.get("dimensions") != bounds[2:4]:
                        errors.append(f"authoritative slice dimensions drift: {rel}")

    if authoritative_slice_count not in {0, 8}:
        errors.append(
            "SX-DEC-053 authoritative slice batch must be absent or complete at 8 records"
        )

    if seen_product_paths.intersection(semantic_product_paths):
        errors.append("SX-DEC-053 and SX-DEC-054 product ownership must be disjoint")
    if seen_product_paths.intersection(runtime_product_paths):
        errors.append("SX-DEC-053 and runtime consumer asset ownership must be disjoint")
    if semantic_product_paths.intersection(runtime_product_paths):
        errors.append("SX-DEC-054 and runtime consumer asset ownership must be disjoint")

    actual_product_paths = {
        path.relative_to(ROOT).as_posix()
        for path in PRODUCT_ROOT.rglob("*.png")
    }
    actual_sx_dec_053_paths = actual_product_paths - semantic_product_paths - runtime_product_paths
    if actual_sx_dec_053_paths != seen_product_paths:
        missing_from_manifest = sorted(actual_sx_dec_053_paths - seen_product_paths)
        missing_from_tree = sorted(seen_product_paths - actual_sx_dec_053_paths)
        if missing_from_manifest:
            errors.append(f"unmanifested SX-DEC-053 product PNGs: {missing_from_manifest}")
        if missing_from_tree:
            errors.append(f"manifested SX-DEC-053 product PNGs missing from tree: {missing_from_tree}")

    pending_corrupt = [
        (source, detail)
        for source, disposition, detail in corrupt_sources
        if disposition != "PROMOTE_AS_IS"
    ]
    for source, detail in pending_corrupt:
        print(f"candidate source deferred for revision: {source} · {detail}")

    if errors:
        print("final E+D product asset promotion: FAIL")
        for error in errors:
            print(f"- {error}")
        return 1

    print(
        "final E+D product asset promotion: PASS · "
        f"dispositions={len(ledger)} · promoted={len(product.get('assets', []))} · "
        f"authoritative_slices={authoritative_slice_count} · "
        f"sx_dec_054_owned={len(semantic_product_paths)} · "
        f"runtime_consumer_owned={len(runtime_product_paths)} · "
        f"pending_corrupt_sources={len(pending_corrupt)} · runtime_integrated=false"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(validate())
