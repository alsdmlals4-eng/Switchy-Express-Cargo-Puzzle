import importlib.util
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ASSET_ROOT = ROOT / "art" / "production_candidates" / "ed_hybrid_v1"
MANIFEST = ASSET_ROOT / "manifest.json"
VALIDATOR_PATH = ROOT / "tools" / "validate_ed_hybrid_asset_pack.py"

spec = importlib.util.spec_from_file_location("asset_validator", VALIDATOR_PATH)
validator = importlib.util.module_from_spec(spec)
spec.loader.exec_module(validator)


def load_manifest():
    return json.loads(MANIFEST.read_text(encoding="utf-8"))


def test_candidate_root_and_gdignore_exist():
    assert ASSET_ROOT.is_dir()
    assert (ROOT / "art" / "production_candidates" / ".gdignore").is_file()


def test_manifest_contract_and_static_validation():
    data = load_manifest()
    assert data["decision_id"] == "SX-DEC-051"
    assert data["status"] == "GENERATED_PRODUCTION_CANDIDATE"
    assert data["art_direction"] == "E+D HYBRID · NEO-ARCADE READABILITY"
    assert data["runtime_integrated"] is False
    assert data["final_asset_approved"] is False
    assert validator.validate() == 0


def test_required_candidate_families_and_states_are_present():
    data = load_manifest()
    families = {r["family"] for r in data["assets"]}
    assert {"core_world", "run_lifo", "build_states", "controls", "vfx", "shells_result_meta"} <= families
    roles = {r["role"] for r in data["assets"]}
    assert {"locomotive_blue", "cargo_wagon_red", "cargo_wagon_blue", "cargo_wagon_yellow"} <= roles
    assert {"stack_hud", "switch_direction", "train_cargo_strip", "load_mode", "combo_feedback"} <= roles
    assert {"build_states", "track_palette"} <= roles
    assert {"controls", "feedback", "result_shell", "progress_meta"} <= roles

    slices = {s["name"] for r in data["assets"] for s in r.get("slices", [])}
    assert {
        "run_stack_empty_v01", "run_stack_32plus_v01", "run_stack_unloading_v01",
        "run_switch_arrow_left_selected_v01", "run_switch_arrow_up_locked_v01",
        "build_track_straight_valid_ghost_v01", "build_track_straight_invalid_ghost_v01",
        "build_track_curve_valid_ghost_v01", "build_port_marker_left_v01",
        "ui_button_frame_square_blue_normal_v01", "ui_button_frame_square_blue_pressed_v01",
        "ui_button_frame_square_blue_disabled_v01", "ui_button_frame_square_blue_focus_v01"
    } <= slices
