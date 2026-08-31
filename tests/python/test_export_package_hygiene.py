from __future__ import annotations

import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
EXPORT_PRESETS = ROOT / "export_presets.cfg"


class ExportPackageHygieneTests(unittest.TestCase):
    def test_human_pdf_render_cache_and_internal_evidence_are_excluded_from_all_runtime_presets(self) -> None:
        text = EXPORT_PRESETS.read_text(encoding="utf-8")
        exclude_filters = re.findall(r'^exclude_filter="([^"]*)"$', text, flags=re.MULTILINE)

        self.assertEqual(2, len(exclude_filters), "both runtime export presets must declare exclusions")
        for export_filter in exclude_filters:
            excluded = set(export_filter.split(","))
            self.assertIn("output/**", excluded, "human-PDF render cache must not enter game PCKs")
            self.assertIn("evidence/**", excluded, "internal machine-evidence records must not enter game PCKs")


if __name__ == "__main__":
    unittest.main()
