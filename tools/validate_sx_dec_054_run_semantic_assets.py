#!/usr/bin/env python3
import json
import struct
import zlib
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PRODUCT_ROOT = ROOT / "art" / "product_assets" / "ed_hybrid_v1"
BASE_MANIFEST = PRODUCT_ROOT / "manifest.json"
SEMANTIC_MANIFEST = PRODUCT_ROOT / "semantic_manifest_sx_dec_054.json"
PNG_SIGNATURE = b"\x89PNG\r\n\x1a\n"

REQUIRED_STACK = {"compact", "8plus", "16plus", "unload_group", "paused"}
REQUIRED_STRIP = {"empty", "tokens_1_3", "compressed_plus_n", "unload_transition"}
REQUIRED_LOAD = {"manual_idle", "manual_held", "auto_off", "auto_on", "paused_disabled", "input_received"}
REQUIRED_SWITCH = {"three_visible", "selected", "unselected", "occupied_locked", "inactive"}
AMBIGUOUS_ATLASES = {
    "art/production_candidates/ed_hybrid_v1/run/run_train_cargo_strip_states_v01.png",
    "art/production_candidates/ed_hybrid_v1/run/run_load_mode_states_v01.png",
    "art/production_candidates/ed_hybrid_v1/run/run_switch_direction_states_v01.png",
}


def _png_info(path: Path):
    raw = path.read_bytes()
    if not raw.startswith(PNG_SIGNATURE):
        raise ValueError(f"invalid PNG signature: {path.relative_to(ROOT)}")
    pos = len(PNG_SIGNATURE)
    width = height = color_type = None
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
        data = raw[data_start:data_end]
        expected = struct.unpack(">I", raw[data_end:crc_end])[0]
        actual = zlib.crc32(data, zlib.crc32(chunk_type)) & 0xFFFFFFFF
        if expected != actual:
            raise ValueError(f"PNG CRC mismatch: {path.relative_to(ROOT)}")
        if chunk_type == b"IHDR":
            width, height, _, color_type = struct.unpack(">IIBB", data[:10])
        elif chunk_type == b"tRNS":
            has_trns = True
        elif chunk_type == b"IDAT":
            idat.extend(data)
        elif chunk_type == b"IEND":
            saw_iend = True
            break
        pos = crc_end
    if width is None or height is None or color_type is None or not idat or not saw_iend:
        raise ValueError(f"incomplete PNG: {path.relative_to(ROOT)}")
    zlib.decompress(bytes(idat))
    return width, height, color_type in {4, 6} or has_trns


def validate():
    errors = []
    if not SEMANTIC_MANIFEST.is_file():
        print("SX-DEC-054 RUN semantic assets: FAIL")
        print(f"- missing semantic manifest: {SEMANTIC_MANIFEST.relative_to(ROOT)}")
        return 1
    try:
        base = json.loads(BASE_MANIFEST.read_text(encoding="utf-8"))
        semantic = json.loads(SEMANTIC_MANIFEST.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        print(f"SX-DEC-054 RUN semantic assets: FAIL · {exc}")
        return 1

    if base.get("decision_id") != "SX-DEC-053" or base.get("promoted_asset_count") != 39:
        errors.append("SX-DEC-053 baseline ownership must remain exactly 39 assets")
    if semantic.get("decision_id") != "SX-DEC-054":
        errors.append("semantic decision_id must be SX-DEC-054")
    if semantic.get("source_visual_authority") != "SX-DEC-053":
        errors.append("source_visual_authority must be SX-DEC-053")
    if semantic.get("source_component_authority") != "SX-DEC-050":
        errors.append("source_component_authority must be SX-DEC-050")
    if semantic.get("batch") != "RUN_2A":
        errors.append("batch must be RUN_2A")
    if semantic.get("runtime_integrated") is not False:
        errors.append("runtime_integrated must remain false")
    if semantic.get("baseline_sx_dec_053_asset_count") != 39:
        errors.append("baseline_sx_dec_053_asset_count must be 39")

    preserved = semantic.get("ambiguous_atlas_sources_preserved", [])
    preserved_paths = {r.get("path") for r in preserved}
    if not AMBIGUOUS_ATLASES.issubset(preserved_paths):
        errors.append("all ambiguous RUN atlases must be preserved explicitly")
    for record in preserved:
        if record.get("policy") != "PRESERVE_REFERENCE_ONLY_NO_STATE_MAPPING":
            errors.append(f"ambiguous atlas policy drift: {record.get('path')}")

    assets = semantic.get("semantic_assets", [])
    if len(assets) != 20:
        errors.append(f"RUN Batch 2A must own exactly 20 physical semantic PNGs, got {len(assets)}")
    paths = [a.get("path") for a in assets]
    if len(paths) != len(set(paths)):
        errors.append("duplicate semantic asset paths")
    base_paths = {a.get("path") for a in base.get("assets", [])}
    if base_paths.intersection(paths):
        errors.append("SX-DEC-054 physical ownership overlaps SX-DEC-053")

    for asset in assets:
        rel = asset.get("path", "")
        if not rel.startswith("art/product_assets/ed_hybrid_v1/run/run_") or not rel.endswith("_v01.png"):
            errors.append(f"bad semantic asset path/name: {rel}")
            continue
        if asset.get("decision_id") != "SX-DEC-054":
            errors.append(f"asset decision drift: {rel}")
        if asset.get("runtime_integrated") is not False:
            errors.append(f"asset runtime_integrated must be false: {rel}")
        derivation = asset.get("derivation", {})
        if derivation.get("kind") != "independent_semantic_asset":
            errors.append(f"asset must be independently authored: {rel}")
        source = derivation.get("source")
        if source in AMBIGUOUS_ATLASES:
            errors.append(f"ambiguous atlas used as semantic pixel authority: {rel}")
        path = ROOT / rel
        if not path.is_file():
            errors.append(f"missing semantic PNG: {rel}")
            continue
        try:
            width, height, alpha = _png_info(path)
        except (OSError, ValueError, zlib.error) as exc:
            errors.append(str(exc))
            continue
        if asset.get("dimensions") != [width, height]:
            errors.append(f"dimension metadata mismatch: {rel}")
        if asset.get("transparent") is not True or not alpha:
            errors.append(f"semantic PNG must be alpha-capable: {rel}")

    actual = {
        p.relative_to(ROOT).as_posix()
        for p in (PRODUCT_ROOT / "run").glob("run_*.png")
        if p.relative_to(ROOT).as_posix() in set(paths)
    }
    if actual != set(paths):
        errors.append("semantic manifest↔physical RUN PNG ownership mismatch")

    compositions = semantic.get("semantic_compositions", [])
    coverage = {}
    all_known_inputs = base_paths | set(paths)
    for comp in compositions:
        component = comp.get("component")
        state = comp.get("state")
        coverage.setdefault(component, set()).add(state)
        if comp.get("runtime_integrated") is not False:
            errors.append(f"composition runtime_integrated must be false: {component}/{state}")
        for input_path in comp.get("inputs", []):
            if input_path not in all_known_inputs:
                errors.append(f"unknown composition input: {component}/{state} · {input_path}")
        if component == "switch_direction":
            authority = comp.get("procedural_direction_authority", "")
            if "SX-DEC-042" not in authority or "SX-DEC-046" not in authority or "VIS-014" not in authority:
                errors.append(f"switch procedural authority missing: {state}")

    expected = {
        "stack_hud": REQUIRED_STACK,
        "train_cargo_strip": REQUIRED_STRIP,
        "load_mode": REQUIRED_LOAD,
        "switch_direction": REQUIRED_SWITCH,
    }
    for component, required in expected.items():
        if coverage.get(component, set()) != required:
            errors.append(
                f"semantic state coverage mismatch for {component}: "
                f"expected={sorted(required)} got={sorted(coverage.get(component, set()))}"
            )

    if errors:
        print("SX-DEC-054 RUN semantic assets: FAIL")
        for error in errors:
            print(f"- {error}")
        return 1
    print(
        "SX-DEC-054 RUN semantic assets: PASS · physical=20 · "
        "stack=5 · strip=4 · load=6 · switch=5 · runtime_integrated=false"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(validate())
