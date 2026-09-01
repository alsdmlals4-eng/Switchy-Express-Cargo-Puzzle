from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
PROJECT = ROOT / "project.godot"
PRESETS = ROOT / "export_presets.cfg"


def test_windows_compatibility_prefers_angle_with_native_fallback() -> None:
    text = PROJECT.read_text(encoding="utf-8")
    assert 'gl_compatibility/driver.windows="opengl3_angle"' in text
    assert "gl_compatibility/fallback_to_native=true" in text


def test_windows_demo_exports_angle_runtime() -> None:
    text = PRESETS.read_text(encoding="utf-8")
    assert "application/export_angle=1" in text
