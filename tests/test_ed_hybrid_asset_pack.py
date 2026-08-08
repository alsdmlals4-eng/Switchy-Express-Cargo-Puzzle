import json
from pathlib import Path
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
ASSET_ROOT = ROOT / "art" / "production_candidates" / "ed_hybrid_v1"
MANIFEST = ASSET_ROOT / "manifest.json"

REQUIRED_TOP_KEYS = {"decision_id", "status", "art_direction", "family_targets", "assets"}
REQUIRED_ASSET_KEYS = {
    "path", "family", "role", "state", "provenance",
    "transparent", "runtime_integrated", "final_asset_approved"
}


def load_manifest():
    return json.loads(MANIFEST.read_text(encoding="utf-8"))


def test_candidate_root_and_gdignore_exist():
    assert ASSET_ROOT.is_dir()
    assert (ROOT / "art" / "production_candidates" / ".gdignore").is_file()


def test_manifest_contract():
    data = load_manifest()
    assert REQUIRED_TOP_KEYS <= data.keys()
    assert data["decision_id"] == "SX-DEC-051"
    assert data["status"] == "GENERATED_PRODUCTION_CANDIDATE"
    assert data["art_direction"] == "E+D HYBRID · NEO-ARCADE READABILITY"
    assert isinstance(data["family_targets"], list) and data["family_targets"]
    assert isinstance(data["assets"], list)


def test_asset_records_are_safe_and_unique():
    data = load_manifest()
    seen = set()
    for record in data["assets"]:
        assert REQUIRED_ASSET_KEYS <= record.keys()
        path = record["path"]
        assert path not in seen
        seen.add(path)
        assert path.endswith(".png")
        assert ".." not in Path(path).parts
        assert record["runtime_integrated"] is False
        assert record["final_asset_approved"] is False
        full = ROOT / path
        assert full.is_file()
        with Image.open(full) as im:
            im.verify()
        if record["transparent"]:
            with Image.open(full) as im:
                assert im.mode in {"RGBA", "LA"} or "transparency" in im.info
