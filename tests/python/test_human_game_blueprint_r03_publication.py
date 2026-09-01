from __future__ import annotations

import io
import importlib.util
import unittest
from pathlib import Path

from pypdf import PdfReader


ROOT = Path(__file__).resolve().parents[2]
BUILDER = ROOT / "tools/build_human_game_blueprint.py"


def load_builder():
    spec = importlib.util.spec_from_file_location("human_game_blueprint_builder", BUILDER)
    if spec is None or spec.loader is None:
        raise AssertionError("human blueprint builder module cannot be loaded")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


class HumanGameBlueprintR03PublicationTests(unittest.TestCase):
    def test_new_page_kinds_render_real_pdf_pages(self) -> None:
        builder = load_builder()
        pages = [
            {
                "kind": "wireframes",
                "eyebrow": "TEST",
                "title": "Wireframes",
                "claim": "renderer behavior",
                "cards": [
                    [f"SX-{index}", "surface", "attention", "information", "action"]
                    for index in range(6)
                ],
            },
            {
                "kind": "run_state",
                "eyebrow": "TEST",
                "title": "Run state",
                "claim": "renderer behavior",
                "states": [
                    [str(index), "state", "trigger", "player read", "next"]
                    for index in range(6)
                ],
                "footer": "bounded presentation",
            },
            {
                "kind": "asset_readiness",
                "eyebrow": "TEST",
                "title": "Asset readiness",
                "claim": "renderer behavior",
                "headers": ["surface", "consumer", "state", "use", "action"],
                "rows": [
                    ["title", "node", "approved", "reuse", "none"]
                    for _ in range(6)
                ],
                "footer": "candidate state remains separate",
            },
        ]
        builder.register_fonts()
        stream = io.BytesIO()
        canvas = builder.Canvas(
            stream,
            pagesize=(builder.PAGE_W, builder.PAGE_H),
            pageCompression=1,
            invariant=1,
        )
        renderer = builder.BlueprintRenderer(
            canvas,
            {"revision": "r03", "date": "2026-09-01", "pages": pages},
        )
        try:
            for page in pages:
                renderer.render_page(page)
        except ValueError as exc:
            self.fail(str(exc))
        canvas.save()
        self.assertEqual(len(PdfReader(io.BytesIO(stream.getvalue())).pages), 3)


if __name__ == "__main__":
    unittest.main()
