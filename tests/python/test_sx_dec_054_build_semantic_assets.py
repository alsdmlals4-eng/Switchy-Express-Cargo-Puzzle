import importlib.util
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
SEMANTIC_MANIFEST = ROOT / "art" / "product_assets" / "ed_hybrid_v1" / "semantic_manifest_sx_dec_054.json"
VALIDATOR_PATH = ROOT / "tools" / "validate_sx_dec_054_build_semantic_assets.py"


def test_sx_dec_054_build_batch_is_declared():
    semantic = json.loads(SEMANTIC_MANIFEST.read_text(encoding="utf-8"))
    assert semantic.get("build_batch") == "BUILD_2B"
    assert semantic.get("build_semantic_assets")
    assert semantic.get("build_semantic_compositions")


def test_sx_dec_054_build_semantic_assets_contract():
    assert VALIDATOR_PATH.is_file(), "BUILD Batch 2B validator must exist"
    spec = importlib.util.spec_from_file_location(
        "validate_sx_dec_054_build_semantic_assets", VALIDATOR_PATH
    )
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    assert module.validate() == 0
