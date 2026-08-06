from __future__ import annotations

from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
PRESETS = ROOT / "export_presets.cfg"

EXPECTED_ANDROID_MARKERS = (
    '[preset.0]',
    'name="Android Validation"',
    'platform="Android"',
    'custom_features="validation_harness"',
    'export_path="builds/switchy-express-validation.apk"',
    'architectures/arm64-v8a=true',
    'architectures/armeabi-v7a=false',
    'architectures/x86=false',
    'architectures/x86_64=false',
    'version/code=1',
    'version/name="0.1-validation"',
    'package/unique_name="com.alsdmlals4.switchyexpress.validation"',
    'package/name="Switchy Express Validation"',
    'package/signed=true',
)


def _preset_block(text: str, index: int) -> str:
    start_marker = f"[preset.{index}]"
    end_marker = f"[preset.{index}.options]"
    start = text.index(start_marker)
    end = text.index(end_marker, start)
    return text[start:end]


def test_android_validation_preset_remains_exactly_identifiable() -> None:
    text = PRESETS.read_text(encoding="utf-8")
    for marker in EXPECTED_ANDROID_MARKERS:
        assert marker in text
    android_preset = _preset_block(text, 0)
    assert "runnable=true" not in android_preset
    assert android_preset.count("runnable=false") <= 1


def test_windows_demo_uses_a_separate_preset_index_and_package_surface() -> None:
    text = PRESETS.read_text(encoding="utf-8")
    assert text.count('name="Android Validation"') == 1
    assert text.count('custom_features="validation_harness"') == 1
    assert text.count('package/unique_name="com.alsdmlals4.switchyexpress.validation"') == 1
    assert '[preset.1]' in text
    assert 'name="Windows Demo"' in text
