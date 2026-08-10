#!/usr/bin/env python3
import hashlib
import json
import struct
import zlib
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
PRODUCT_ROOT = ROOT / "art" / "product_assets" / "ed_hybrid_v1"
BASE_MANIFEST = PRODUCT_ROOT / "manifest.json"
RUN_MANIFEST = PRODUCT_ROOT / "semantic_manifest_sx_dec_054.json"
BUILD_MANIFEST = PRODUCT_ROOT / "semantic_manifest_sx_dec_054_build_2b.json"
VFX_MANIFEST = PRODUCT_ROOT / "semantic_manifest_sx_dec_054_vfx_2c.json"
PNG_SIGNATURE = b"\x89PNG\r\n\x1a\n"

REQUIRED_EVENTS = {
    "cargo_pickup",
    "cargo_unload",
    "combo",
    "route_selection",
    "success",
    "failure",
    "route_end",
    "time_expired",
}
REQUIRED_MODES = {"standard", "reduced_motion"}
VFX_ATLAS = "art/production_candidates/ed_hybrid_v1/vfx/vfx_feedback_static_states_v01.png"
OCCLUSION_POLICY = "DO_NOT_COVER_NEXT_CRITICAL_BRANCH_OR_CARGO_TARGET"

EXPECTED_INPUTS = {
    "cargo_pickup": "art/product_assets/ed_hybrid_v1/vfx/vfx_cargo_pickup_feedback_v01.png",
    "cargo_unload": "art/product_assets/ed_hybrid_v1/vfx/vfx_cargo_unload_feedback_v01.png",
    "combo": "art/product_assets/ed_hybrid_v1/run/run_combo_feedback_static_v01.png",
    "route_selection": "art/product_assets/ed_hybrid_v1/run/run_switch_state_selected_overlay_v01.png",
    "success": "art/product_assets/ed_hybrid_v1/vfx/vfx_success_feedback_v01.png",
    "failure": "art/product_assets/ed_hybrid_v1/vfx/vfx_failure_feedback_v01.png",
    "route_end": "art/product_assets/ed_hybrid_v1/vfx/vfx_route_end_feedback_v01.png",
    "time_expired": "art/product_assets/ed_hybrid_v1/vfx/vfx_time_expired_feedback_v01.png",
}

EXPECTED_AUTHORITIES = {
    "cargo_pickup": "SX-DEC-054 · SX-DEC-049",
    "cargo_unload": "SX-DEC-054 · VR-FINITE-RUN-04",
    "combo": "SX-DEC-054 · CMP-RUN-COMBO-FEEDBACK",
    "route_selection": "SX-DEC-054 · SX-DEC-042 · SX-DEC-046",
    "success": "SX-DEC-054 · CMP-RESULT-SUMMARY",
    "failure": "SX-DEC-054 · CMP-RESULT-SUMMARY",
    "route_end": "SX-DEC-054 · SX-DEC-041 · CMP-RESULT-FAILURE-INSIGHT",
    "time_expired": "SX-DEC-054 · SX-DEC-029 · CMP-RESULT-FAILURE-INSIGHT",
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
        expected_crc = struct.unpack(">I", raw[data_end:crc_end])[0]
        actual_crc = zlib.crc32(data, zlib.crc32(chunk_type)) & 0xFFFFFFFF
        if expected_crc != actual_crc:
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
    return width, height, color_type in {4, 6} or has_trns, hashlib.sha256(raw).hexdigest()


def _load(path: Path):
    return json.loads(path.read_text(encoding="utf-8"))


def validate():
    errors = []
    try:
        base = _load(BASE_MANIFEST)
        run_semantic = _load(RUN_MANIFEST)
        build_semantic = _load(BUILD_MANIFEST)
        vfx = _load(VFX_MANIFEST)
    except (OSError, json.JSONDecodeError) as exc:
        print(f"SX-DEC-054 VFX semantic assets: FAIL · {exc}")
        return 1

    if base.get("decision_id") != "SX-DEC-053" or base.get("promoted_asset_count") != 39:
        errors.append("SX-DEC-053 baseline ownership must remain exactly 39")
    if run_semantic.get("decision_id") != "SX-DEC-054" or run_semantic.get("batch") != "RUN_2A":
        errors.append("RUN semantic sidecar identity drift")
    if len(run_semantic.get("semantic_assets", [])) != 20:
        errors.append("RUN Batch 2A ownership must remain exactly 20")
    if build_semantic.get("decision_id") != "SX-DEC-054" or build_semantic.get("batch") != "BUILD_2B":
        errors.append("BUILD semantic sidecar identity drift")
    if len(build_semantic.get("semantic_assets", [])) != 8:
        errors.append("BUILD Batch 2B ownership must remain exactly 8")

    if vfx.get("decision_id") != "SX-DEC-054":
        errors.append("VFX decision_id must be SX-DEC-054")
    if vfx.get("batch") != "VFX_2C":
        errors.append("VFX batch must be VFX_2C")
    if vfx.get("source_visual_authority") != "SX-DEC-053":
        errors.append("VFX source_visual_authority must be SX-DEC-053")
    if vfx.get("source_component_authority") != "SX-DEC-050":
        errors.append("VFX source_component_authority must be SX-DEC-050")
    if vfx.get("baseline_sx_dec_053_asset_count") != 39:
        errors.append("VFX baseline 053 count must be 39")
    if vfx.get("baseline_sx_dec_054_run_2a_asset_count") != 20:
        errors.append("VFX baseline RUN count must be 20")
    if vfx.get("baseline_sx_dec_054_build_2b_asset_count") != 8:
        errors.append("VFX baseline BUILD count must be 8")
    if vfx.get("runtime_integrated") is not False:
        errors.append("VFX runtime_integrated must remain false")
    if vfx.get("standard_runtime_animation_authored") is not False:
        errors.append("VFX batch must not author runtime Animation resources")

    preserved = {
        item.get("path"): item.get("policy")
        for item in vfx.get("ambiguous_atlas_sources_preserved", [])
    }
    if preserved.get(VFX_ATLAS) != "PRESERVE_REFERENCE_ONLY_NO_STATE_MAPPING":
        errors.append("unnamed VFX atlas must remain reference-only/no-state-mapping")

    base_paths = {item.get("path") for item in base.get("assets", []) if item.get("path")}
    run_paths = {item.get("path") for item in run_semantic.get("semantic_assets", []) if item.get("path")}
    build_paths = {item.get("path") for item in build_semantic.get("semantic_assets", []) if item.get("path")}

    assets = vfx.get("semantic_assets", [])
    if len(assets) != 6:
        errors.append(f"VFX Batch 2C must own exactly 6 physical PNGs, got {len(assets)}")
    vfx_paths = [item.get("path") for item in assets]
    if len(vfx_paths) != len(set(vfx_paths)):
        errors.append("duplicate VFX semantic asset paths")
    vfx_path_set = {path for path in vfx_paths if path}
    if base_paths & vfx_path_set or run_paths & vfx_path_set or build_paths & vfx_path_set:
        errors.append("VFX ownership must be disjoint from 053/RUN/BUILD")

    for asset in assets:
        rel = asset.get("path", "")
        if not rel.startswith("art/product_assets/ed_hybrid_v1/vfx/vfx_") or not rel.endswith("_v01.png"):
            errors.append(f"bad VFX product path: {rel}")
            continue
        if asset.get("decision_id") != "SX-DEC-054" or asset.get("family") != "vfx":
            errors.append(f"VFX asset authority drift: {rel}")
        if asset.get("runtime_integrated") is not False:
            errors.append(f"VFX asset runtime_integrated must be false: {rel}")
        derivation = asset.get("derivation", {})
        if derivation.get("kind") != "independent_semantic_asset":
            errors.append(f"VFX asset must be independently authored: {rel}")
        if derivation.get("source") == VFX_ATLAS:
            errors.append(f"unnamed VFX atlas used as pixel authority: {rel}")
        if asset.get("authoritative_slice_name") is not None or asset.get("crop_bounds") is not None:
            errors.append(f"VFX asset may not claim atlas crop authority: {rel}")
        path = ROOT / rel
        if not path.is_file():
            errors.append(f"missing VFX semantic PNG: {rel}")
            continue
        try:
            width, height, alpha, sha256 = _png_info(path)
        except (OSError, ValueError, zlib.error) as exc:
            errors.append(str(exc))
            continue
        if asset.get("dimensions") != [width, height]:
            errors.append(f"VFX dimensions mismatch: {rel}")
        if asset.get("transparent") is not True or not alpha:
            errors.append(f"VFX PNG must be alpha-capable: {rel}")
        if asset.get("sha256") != sha256:
            errors.append(f"VFX SHA-256 mismatch: {rel}")

    compositions = vfx.get("semantic_compositions", [])
    expected_pairs = {(event, mode) for event in REQUIRED_EVENTS for mode in REQUIRED_MODES}
    actual_pairs = {
        (item.get("event"), item.get("presentation_mode"))
        for item in compositions
    }
    if len(compositions) != 16 or actual_pairs != expected_pairs:
        errors.append("VFX compositions must be exactly 8 events × standard/reduced_motion")

    all_known_paths = base_paths | run_paths | build_paths | vfx_path_set
    by_event = {event: {} for event in REQUIRED_EVENTS}
    for item in compositions:
        event = item.get("event")
        mode = item.get("presentation_mode")
        if event not in REQUIRED_EVENTS or mode not in REQUIRED_MODES:
            continue
        by_event[event][mode] = item
        expected_input = EXPECTED_INPUTS[event]
        if item.get("inputs") != [expected_input]:
            errors.append(f"VFX event input mismatch: {event}/{mode}")
        if expected_input not in all_known_paths:
            errors.append(f"VFX event input is not an owned product asset: {event}/{mode}")
        if item.get("information_key") != event:
            errors.append(f"VFX information_key mismatch: {event}/{mode}")
        if item.get("authority") != EXPECTED_AUTHORITIES[event]:
            errors.append(f"VFX event authority mismatch: {event}/{mode}")
        if item.get("occlusion_policy") != OCCLUSION_POLICY:
            errors.append(f"VFX occlusion policy mismatch: {event}/{mode}")
        if item.get("mute_independent") is not True:
            errors.append(f"VFX visual information must survive mute: {event}/{mode}")
        if item.get("runtime_integrated") is not False:
            errors.append(f"VFX runtime_integrated must be false: {event}/{mode}")
        expected_motion = (
            "RUNTIME_ANIMATION_OPTIONAL_LATER"
            if mode == "standard"
            else "STATIC_INFORMATION_EQUIVALENT"
        )
        if item.get("motion_policy") != expected_motion:
            errors.append(f"VFX motion policy mismatch: {event}/{mode}")

    for event, modes in by_event.items():
        if set(modes) != REQUIRED_MODES:
            errors.append(f"VFX event missing standard/reduced pair: {event}")
            continue
        standard = modes["standard"]
        reduced = modes["reduced_motion"]
        if standard.get("inputs") != reduced.get("inputs"):
            errors.append(f"Reduced Motion must preserve the same information asset: {event}")
        if standard.get("information_key") != reduced.get("information_key"):
            errors.append(f"Reduced Motion information identity drift: {event}")

    if EXPECTED_INPUTS["combo"] not in base_paths:
        errors.append("combo must reuse existing SX-DEC-053 reduced-motion combo product")
    if EXPECTED_INPUTS["route_selection"] not in run_paths:
        errors.append("route_selection must reuse RUN Batch 2A selected overlay")
    for event in REQUIRED_EVENTS - {"combo", "route_selection"}:
        if EXPECTED_INPUTS[event] not in vfx_path_set:
            errors.append(f"event must use a VFX-owned independent glyph: {event}")

    if errors:
        print("SX-DEC-054 VFX semantic assets: FAIL")
        for error in errors:
            print(f"- {error}")
        return 1

    print(
        "SX-DEC-054 VFX semantic assets: PASS · physical=6 · events=8 · "
        "compositions=16 · reduced_motion_pairs=8 · runtime_integrated=false"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(validate())
