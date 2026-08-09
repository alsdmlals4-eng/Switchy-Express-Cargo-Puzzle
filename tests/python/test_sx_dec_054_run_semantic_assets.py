from pathlib import Path
import importlib.util


ROOT = Path(__file__).resolve().parents[2]
VALIDATOR_PATH = ROOT / "tools" / "validate_sx_dec_054_run_semantic_assets.py"


def _load_validator():
    spec = importlib.util.spec_from_file_location("validate_sx_dec_054_run_semantic_assets", VALIDATOR_PATH)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_sx_dec_054_run_semantic_assets_contract():
    validator = _load_validator()
    assert validator.validate() == 0
