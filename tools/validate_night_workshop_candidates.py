"""Read-only exact candidate checks; not gameplay, visual approval or rail-join proof."""
import hashlib
import json
from pathlib import Path

from PIL import Image


def main():
    root = Path(__file__).resolve().parents[1]
    folder = root / "evidence/design/night-workshop-assets-20260910"
    source = Image.open(folder / "cargo-source.png").convert("RGBA")
    sheet = Image.open(folder / "cargo-lift-ready.png")
    data = json.loads((folder / "cargo-lift-ready.json").read_text(encoding="utf-8"))
    assert source.size == (1254, 1254), "Source dimensions changed"
    assert sheet.mode == "RGBA" and sheet.size == (1798, 448)
    assert len(data["frames"]) == 4
    offsets = [(-92, -105), (-715, -129), (-92, -722), (-715, -753)]
    expected_bounds = [(56, 132, 392, 440), (56, 72, 392, 380),
                       (56, 12, 392, 320), (56, 36, 392, 345)]
    frames = []
    for index, entry in enumerate(data["frames"]):
        frame = entry["frame"]
        assert frame == {"x": index * 450, "y": 0, "w": 448, "h": 448}
        assert entry["duration"] == 60 and not entry["trimmed"] and not entry["rotated"]
        actual = sheet.crop((frame["x"], 0, frame["x"] + 448, 448))
        dx, dy = offsets[index]
        expected = source.crop((-dx, -dy, 448-dx, 448-dy))
        # Fully transparent RGB is not visually meaningful and may be normalized by Aseprite.
        assert actual.getchannel("A").tobytes() == expected.getchannel("A").tobytes()
        actual_bytes, expected_bytes = actual.tobytes(), expected.tobytes()
        for offset in range(0, len(actual_bytes), 4):
            if actual_bytes[offset + 3] > 0:
                assert actual_bytes[offset:offset+4] == expected_bytes[offset:offset+4], "Visible source pixels changed during extraction"
        alpha = actual.getchannel("A")
        bounds = alpha.point(lambda value: 255 if value > 127 else 0).getbbox()
        assert bounds == expected_bounds[index]
        assert alpha.getpixel((0, 0)) == 0 and alpha.getpixel((447, 447)) == 0
        frames.append({"duration_ms": 60, "alpha128_bounds": bounds,
                       "sha256_rgba": hashlib.sha256(actual.tobytes()).hexdigest()})
    assert len({frame["sha256_rgba"] for frame in frames}) == 4
    rail_source = Image.open(folder / "rail-source.png").convert("RGBA")
    rail_clean = Image.open(folder / "rail-master.png").convert("RGBA")
    assert rail_source.size == rail_clean.size == (1254, 1254)
    for border in [(0, 0, 1254, 32), (0, 1222, 1254, 1254),
                   (0, 32, 32, 1222), (1222, 32, 1254, 1222)]:
        assert rail_source.getchannel("A").crop(border).getextrema()[1] <= 1
        assert rail_clean.getchannel("A").crop(border).getextrema() == (0, 0)
    # Preserve the connected artwork while replacing only verified empty exterior padding.
    original = rail_source.crop((32, 32, 1222, 1222)).tobytes()
    cleaned = rail_clean.crop((32, 32, 1222, 1222)).tobytes()
    for offset in range(0, len(original), 4):
        if original[offset + 3] > 0:
            assert original[offset:offset+4] == cleaned[offset:offset+4]
    images = {}
    for name in ("rail-master.png", "cargo-source.png", "cargo-lift-ready.png",
                 "train.png", "station-blue.png"):
        with Image.open(folder / name) as image:
            assert image.mode == "RGBA", f"{name}: missing alpha"
            alpha = image.getchannel("A")
            assert alpha.getextrema() == (0, 255), f"{name}: empty or opaque backdrop"
            assert all(alpha.getpixel(point) == 0 for point in
                       [(0, 0), (image.width-1, 0), (0, image.height-1),
                        (image.width-1, image.height-1)]), f"{name}: opaque corner"
            images[name] = {"size": image.size,
                            "transparent_pixels": alpha.histogram()[0]}
    hashes = {p.name: hashlib.sha256(p.read_bytes()).hexdigest()
              for p in sorted(folder.iterdir()) if p.suffix in (".png", ".aseprite", ".json")}
    print(json.dumps({"status": "PASS", "scope": "candidate extraction/alpha/metadata only",
                      "frames": frames, "images": images, "hashes": hashes,
                      "rail_tiling": "NOT_VERIFIED", "godot_runtime": "NOT_RUN",
                      "pixel_approval": "PENDING"}, indent=2))


if __name__ == "__main__":
    main()
