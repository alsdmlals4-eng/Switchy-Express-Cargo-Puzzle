import importlib.util
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
VFX_MANIFEST = (
    ROOT
    / "art"
    / "product_assets"
    / "ed_hybrid_v1"
    / "semantic_manifest_sx_dec_054_vfx_2c.json"
)
VALIDATOR_PATH = ROOT / "tools" / "validate_sx_dec_054_vfx_semantic_assets.py"

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


def test_sx_dec_054_vfx_batch_is_declared():
    assert VFX_MANIFEST.is_file(), "VFX Batch 2C semantic sidecar must exist"
    semantic = json.loads(VFX_MANIFEST.read_text(encoding="utf-8"))
    assert semantic.get("decision_id") == "SX-DEC-054"
    assert semantic.get("batch") == "VFX_2C"
    assert len(semantic.get("semantic_assets", [])) == 6
    compositions = semantic.get("semantic_compositions", [])
    assert len(compositions) == 16
    assert {(item["event"], item["presentation_mode"]) for item in compositions} == {
        (event, mode) for event in REQUIRED_EVENTS for mode in REQUIRED_MODES
    }


def test_sx_dec_054_vfx_semantic_assets_contract():
    assert VALIDATOR_PATH.is_file(), "VFX Batch 2C validator must exist"
    spec = importlib.util.spec_from_file_location(
        "validate_sx_dec_054_vfx_semantic_assets", VALIDATOR_PATH
    )
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    assert module.validate() == 0
