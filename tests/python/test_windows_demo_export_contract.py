from __future__ import annotations

from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
PRESETS = ROOT / "export_presets.cfg"
WORKFLOW = ROOT / ".github/workflows/windows-demo-export.yml"
PROJECT = ROOT / "project.godot"


def _text(path: Path) -> str:
    assert path.is_file(), f"missing required file: {path.relative_to(ROOT)}"
    return path.read_text(encoding="utf-8")


def _preset_block(text: str, index: int) -> str:
    start_marker = f"[preset.{index}]"
    end_marker = f"[preset.{index}.options]"
    start = text.index(start_marker)
    end = text.index(end_marker, start)
    return text[start:end]


def test_windows_demo_preset_is_isolated_and_exact() -> None:
    text = _text(PRESETS)
    for marker in (
        '[preset.1]',
        'name="Windows Demo"',
        'platform="Windows Desktop"',
        'custom_features="vertical_slice_demo"',
        'export_filter="all_resources"',
        'export_path="builds/windows/SwitchyExpressVerticalSlice.exe"',
        '[preset.1.options]',
        'binary_format/architecture="x86_64"',
    ):
        assert marker in text
    windows_preset = _preset_block(text, 1)
    assert "runnable=true" not in windows_preset
    assert windows_preset.count("runnable=false") <= 1


def test_windows_demo_workflow_is_pinned_and_exports_artifact() -> None:
    text = _text(WORKFLOW)
    for marker in (
        'name: Windows Demo Export',
        'Godot_v4.7.1-stable_linux.x86_64',
        'Godot_v4.7.1-stable_export_templates.tpz',
        '--script res://tests/run_tests.gd',
        '--export-debug "Windows Demo"',
        'builds/windows/SwitchyExpressVerticalSlice.exe',
        'builds/windows/SwitchyExpressVerticalSlice.pck',
        'sha256sum',
        'switchy-express-windows-demo-${{ github.sha }}',
    ):
        assert marker in text
    assert '@main' not in text


def test_windows_demo_does_not_become_default_entrypoint() -> None:
    project = _text(PROJECT)
    assert 'run/main_scene="res://game/main/main.tscn"' in project
    assert 'run/main_scene="res://game/demo/vertical_slice_demo.tscn"' not in project
