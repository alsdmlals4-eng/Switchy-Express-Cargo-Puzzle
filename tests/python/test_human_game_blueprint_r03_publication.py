from __future__ import annotations

import io
import importlib.util
import unittest
from pathlib import Path

from pypdf import PdfReader


ROOT = Path(__file__).resolve().parents[2]
BUILDER = ROOT / "tools/build_human_game_blueprint.py"
WINDOWS_MALGUN = Path(r"C:\Windows\Fonts\malgun.ttf")
WINDOWS_MALGUN_BOLD = Path(r"C:\Windows\Fonts\malgunbd.ttf")
LINUX_TEST_FONT = Path("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf")
LINUX_TEST_FONT_BOLD = Path("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf")


def load_builder():
    spec = importlib.util.spec_from_file_location("human_game_blueprint_builder", BUILDER)
    if spec is None or spec.loader is None:
        raise AssertionError("human blueprint builder module cannot be loaded")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def register_test_fonts(builder) -> None:
    """Use production fonts on Windows and a CI-only renderer substitute elsewhere.

    The generated Korean publication remains intentionally Windows-font-bound.
    This helper only lets the English fixture exercise the real ReportLab page
    renderers on Ubuntu CI, where the production Malgun files do not exist.
    """
    if WINDOWS_MALGUN.exists() and WINDOWS_MALGUN_BOLD.exists():
        builder.register_fonts()
        return
    if not LINUX_TEST_FONT.exists() or not LINUX_TEST_FONT_BOLD.exists():
        raise AssertionError("CI font substitute is unavailable")
    builder.pdfmetrics.registerFont(builder.TTFont("Malgun", str(LINUX_TEST_FONT)))
    builder.pdfmetrics.registerFont(builder.TTFont("MalgunBold", str(LINUX_TEST_FONT_BOLD)))


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
        register_test_fonts(builder)
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

    def test_run_state_connectors_do_not_turn_build_failure_into_a_run_transition(self) -> None:
        builder = load_builder()
        self.assertTrue(
            hasattr(builder, "run_state_connector_pairs"),
            "run-state connector mapping must be explicit and independently testable",
        )
        connector_pairs = builder.run_state_connector_pairs(6)
        self.assertNotIn((0, 1), connector_pairs)
        self.assertEqual(connector_pairs, ((1, 2), (3, 4), (4, 5)))

    def test_eight_row_journey_table_reserves_a_visible_callout_above_the_footer(self) -> None:
        builder = load_builder()
        self.assertTrue(
            hasattr(builder, "journey_table_layout"),
            "journey table layout must explicitly reserve callout and footer space",
        )
        row_height, callout_y = builder.journey_table_layout(8)
        self.assertLess(row_height, 50)
        self.assertGreaterEqual(callout_y, 34)

    def test_lifo_questions_fit_inside_dedicated_cards_without_entering_the_rule_bar(self) -> None:
        builder = load_builder()
        self.assertTrue(
            hasattr(builder, "lifo_question_card_layout"),
            "LIFO question-card geometry must be explicit so copy cannot render below its border",
        )
        cards = builder.lifo_question_card_layout(builder.PAGE_H - 133, 3)
        self.assertEqual(len(cards), 3)
        self.assertGreaterEqual(min(y for _x, y, _width, _height in cards), 96)
        self.assertLessEqual(
            max(y + height for _x, y, _width, height in cards), builder.PAGE_H - 133 - 25
        )

    def test_capstone_cards_stay_between_header_and_finish_bar(self) -> None:
        builder = load_builder()
        self.assertTrue(
            hasattr(builder, "capstone_card_layout"),
            "capstone card geometry must reserve readable copy space and avoid the finish bar",
        )
        cards = builder.capstone_card_layout(builder.PAGE_H - 133, 6)
        self.assertEqual(len(cards), 6)
        self.assertGreaterEqual(min(y for _x, y, _width, _height in cards), 106)
        self.assertLessEqual(
            max(y + height for _x, y, _width, height in cards), builder.PAGE_H - 133 - 25
        )

    def test_content_table_reserves_its_footer_callout_above_the_page_footer(self) -> None:
        builder = load_builder()
        self.assertTrue(
            hasattr(builder, "content_table_layout"),
            "content-table layout must reserve a visible callout and footer clearance",
        )
        row_height, callout_y = builder.content_table_layout(7)
        self.assertLess(row_height, 53)
        self.assertGreaterEqual(callout_y, 34)


if __name__ == "__main__":
    unittest.main()
