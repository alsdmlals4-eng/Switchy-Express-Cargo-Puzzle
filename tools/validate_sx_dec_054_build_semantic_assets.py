#!/usr/bin/env python3
import hashlib
import json
import struct
import zlib
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
PRODUCT_ROOT = ROOT / "art" / "product_assets" / "ed_hybrid_v1"
BASE_MANIFEST = PRODUCT_ROOT / "manifest.json"
SEMANTIC_MANIFEST = PRODUCT_ROOT / "semantic_manifest_sx_dec_054.json"
PNG_SIGNATURE = b"\x89PNG\r\n\x1a\n"

REQUIRED_PLACEMENT = {"valid", "invalid", "rotate_preview", "replacement_preview"}
REQUIRED_TRACK_FORMS = {"straight", "curve", "switch", "crossing"}
REQUIRED_PALETTE_STATES = {"idle", "selected", "unavailable", "keyboard_focus", "touch_pressed"}
REQUIRED_PREFLIGHT = {"clear", "primary_issue", "multi_issue_summary", "focused_location"}

PLACEMENT_ATLAS = "art/production_candidates/ed_hybrid_v1/build/build_placement_preview_states_v01.png"
TRACK_PALETTE_ATLAS = "art/production_candidates/ed_hybrid_v1/build/build_track_palette_v01.png"

FORM_INPUTS = {
    "straight": "art/product_assets/ed_hybrid_v1/core/core_rail_straight_normal_v01.png",
    "curve": "art/product_assets/ed_hybrid_v1/core/core_rail_curve_normal_v01.png",
    "switch": "art/product_assets/ed_hybrid_v1/core/core_rail_switch_three_way_normal_v01.png",
    "crossing": "art/product_assets/ed_hybrid_v1/core/core_rail_crossing_normal_v01.png",
}

PALETTE_FRAME_INPUTS = {
    "idle": "art/product_assets/ed_hybrid_v1/ui/ui_button_frame_square_blue_normal_v01.png",
    "selected": "art/product_assets/ed_hybrid_v1/ui/ui_button_frame_square_blue_selected_v01.png",
    "unavailable": "art/product_assets/ed_hybrid_v1/ui/ui_button_frame_square_blue_disabled_v01.png",
    "keyboard_focus": "art/product_assets/ed_hybrid_v1/ui/ui_button_frame_square_blue_focus_v01.png",
    "touch_pressed": "art/product_assets/ed_hybrid_v1/ui/ui_button_frame_square_blue_pressed_v01.png",
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
    return width, height, color_type in {4, 6} or has_trns, hashlib.sha256(raw).hexdigest()


def validate():
    errors = []
    try:
        base = json.loads(BASE_MANIFEST.read_text(encoding="utf-8"))
        semantic = json.loads(SEMANTIC_MANIFEST.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        print(f"SX-DEC-054 BUILD semantic assets: FAIL · {exc}")
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
        errors.append("existing RUN batch identity must remain RUN_2A")
    if semantic.get("build_batch") != "BUILD_2B":
        errors.append("build_batch must be BUILD_2B")
    if semantic.get("completed_batches") != ["RUN_2A", "BUILD_2B"]:
        errors.append("completed_batches must be RUN_2A then BUILD_2B")
    if semantic.get("runtime_integrated") is not False:
        errors.append("runtime_integrated must remain false")
    if semantic.get("baseline_sx_dec_053_asset_count") != 39:
        errors.append("baseline_sx_dec_053_asset_count must remain 39")

    run_assets = semantic.get("semantic_assets", [])
    if len(run_assets) != 20:
        errors.append(f"RUN Batch 2A ownership must remain exactly 20, got {len(run_assets)}")
    run_paths = {record.get("path") for record in run_assets if record.get("path")}

    preserved = {
        record.get("path"): record.get("policy")
        for record in semantic.get("ambiguous_build_atlas_sources_preserved", [])
    }
    if preserved.get(PLACEMENT_ATLAS) != "PRESERVE_NAMED_SLICES_ONLY_NO_NEW_STATE_MAPPING":
        errors.append("placement atlas must preserve named slices only with no new state mapping")
    if preserved.get(TRACK_PALETTE_ATLAS) != "PRESERVE_REFERENCE_ONLY_NO_STATE_MAPPING":
        errors.append("track palette atlas must remain reference-only with no state mapping")

    assets = semantic.get("build_semantic_assets", [])
    if len(assets) != 8:
        errors.append(f"BUILD Batch 2B must own exactly 8 physical semantic PNGs, got {len(assets)}")
    paths = [record.get("path") for record in assets]
    if len(paths) != len(set(paths)):
        errors.append("duplicate BUILD semantic asset paths")

    base_paths = {record.get("path") for record in base.get("assets", []) if record.get("path")}
    build_paths = set(path for path in paths if path)
    if base_paths.intersection(build_paths):
        errors.append("BUILD semantic ownership overlaps SX-DEC-053")
    if run_paths.intersection(build_paths):
        errors.append("BUILD semantic ownership overlaps RUN Batch 2A")

    for asset in assets:
        rel = asset.get("path", "")
        if not rel.startswith("art/product_assets/ed_hybrid_v1/build/build_") or not rel.endswith("_v01.png"):
            errors.append(f"bad BUILD semantic asset path/name: {rel}")
            continue
        if asset.get("decision_id") != "SX-DEC-054":
            errors.append(f"asset decision drift: {rel}")
        if asset.get("family") != "build":
            errors.append(f"asset family must be build: {rel}")
        if asset.get("runtime_integrated") is not False:
            errors.append(f"asset runtime_integrated must be false: {rel}")
        derivation = asset.get("derivation", {})
        if derivation.get("kind") != "independent_semantic_asset":
            errors.append(f"asset must be independently authored: {rel}")
        source = derivation.get("source", "")
        if source in {PLACEMENT_ATLAS, TRACK_PALETTE_ATLAS}:
            errors.append(f"ambiguous/nonnamed atlas used as pixel authority: {rel}")
        if asset.get("authoritative_slice_name") is not None or asset.get("crop_bounds") is not None:
            errors.append(f"new BUILD semantic asset may not claim atlas crop authority: {rel}")
        path = ROOT / rel
        if not path.is_file():
            errors.append(f"missing BUILD semantic PNG: {rel}")
            continue
        try:
            width, height, alpha, sha256 = _png_info(path)
        except (OSError, ValueError, zlib.error) as exc:
            errors.append(str(exc))
            continue
        if asset.get("dimensions") != [width, height]:
            errors.append(f"dimension metadata mismatch: {rel}")
        if asset.get("transparent") is not True or not alpha:
            errors.append(f"BUILD semantic PNG must be alpha-capable: {rel}")
        if asset.get("sha256") != sha256:
            errors.append(f"SHA-256 metadata mismatch: {rel}")

    all_known_inputs = base_paths | run_paths | build_paths
    compositions = semantic.get("build_semantic_compositions", [])
    placement = [record for record in compositions if record.get("component") == "placement_preview"]
    palette = [record for record in compositions if record.get("component") == "track_palette"]
    preflight = [record for record in compositions if record.get("component") == "preflight_notice"]

    placement_states = {record.get("state") for record in placement}
    if placement_states != REQUIRED_PLACEMENT or len(placement) != 4:
        errors.append(f"placement state coverage mismatch: {sorted(placement_states)}")
    expected_form_inputs = set(FORM_INPUTS.values())
    for record in placement:
        state = record.get("state")
        if record.get("runtime_integrated") is not False:
            errors.append(f"placement runtime_integrated must be false: {state}")
        if set(record.get("allowed_form_inputs", [])) != expected_form_inputs:
            errors.append(f"placement form authority mismatch: {state}")
        if record.get("output_kind") != "preview_only":
            errors.append(f"placement output must remain preview_only: {state}")
        for input_path in record.get("inputs", []):
            if input_path not in build_paths:
                errors.append(f"placement state overlay must be BUILD-owned: {state} · {input_path}")

    matrix = {(record.get("form"), record.get("state")) for record in palette}
    expected_matrix = {(form, state) for form in REQUIRED_TRACK_FORMS for state in REQUIRED_PALETTE_STATES}
    if matrix != expected_matrix or len(palette) != 20:
        errors.append("track palette composition matrix must be exactly 4 forms × 5 interaction states")
    for record in palette:
        form = record.get("form")
        state = record.get("state")
        if record.get("runtime_integrated") is not False:
            errors.append(f"palette runtime_integrated must be false: {form}/{state}")
        inputs = record.get("inputs", [])
        if inputs != [FORM_INPUTS.get(form), PALETTE_FRAME_INPUTS.get(state)]:
            errors.append(f"palette composition input mismatch: {form}/{state}")
        for input_path in inputs:
            if input_path not in base_paths:
                errors.append(f"palette composition must reuse existing 053 product input: {form}/{state} · {input_path}")

    preflight_states = {record.get("state") for record in preflight}
    if preflight_states != REQUIRED_PREFLIGHT or len(preflight) != 4:
        errors.append(f"preflight state coverage mismatch: {sorted(preflight_states)}")
    for record in preflight:
        state = record.get("state")
        if record.get("runtime_integrated") is not False:
            errors.append(f"preflight runtime_integrated must be false: {state}")
        for input_path in record.get("inputs", []):
            if input_path not in build_paths:
                errors.append(f"preflight input must be BUILD-owned: {state} · {input_path}")
        forbidden = json.dumps(record, ensure_ascii=False).lower()
        if any(token in forbidden for token in ("optional_target", "leaderboard", "run_failure", "success_outcome")):
            errors.append(f"preflight record contains non-preflight outcome semantics: {state}")

    for record in compositions:
        component = record.get("component")
        state = record.get("state")
        for input_path in record.get("inputs", []):
            if input_path not in all_known_inputs:
                errors.append(f"unknown BUILD composition input: {component}/{state} · {input_path}")

    if errors:
        print("SX-DEC-054 BUILD semantic assets: FAIL")
        for error in errors:
            print(f"- {error}")
        return 1

    print(
        "SX-DEC-054 BUILD semantic assets: PASS · physical=8 · "
        "placement=4 · palette=20-compositions/0-new-form-state-pngs · "
        "preflight=4 · runtime_integrated=false"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(validate())
