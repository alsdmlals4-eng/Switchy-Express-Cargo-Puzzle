"""Build the Switchy Express human-review blueprint PDF from its editorial source.

The script intentionally renders only the human-facing editorial source.  Game
rules, maps, assets, and proof status remain owned by their existing canonical
documents.  Board illustrations are labelled explanatory diagrams, not runtime
captures.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import math
import re
from pathlib import Path
from typing import Iterable

from reportlab.lib.colors import Color, HexColor, white
from reportlab.lib.pagesizes import A4, landscape
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.pdfgen.canvas import Canvas
from reportlab.lib.utils import ImageReader


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_SOURCE = ROOT / "docs/design/SWITCHY_EXPRESS_HUMAN_GAME_BLUEPRINT.md"
DEFAULT_OUTPUT = ROOT / "output/pdf/switchy-express-cargo-puzzle_HUMAN_GAME_BLUEPRINT_20260901_r03.pdf"
DEFAULT_MANIFEST = ROOT / "docs/design/SWITCHY_EXPRESS_HUMAN_GAME_BLUEPRINT_PUBLICATION_MANIFEST.json"

PAGE_W, PAGE_H = landscape(A4)
MARGIN = 34

NAVY = HexColor("#102833")
INK = HexColor("#1D2830")
MUTED = HexColor("#5E6A70")
PAPER = HexColor("#F8F3E9")
PAPER_2 = HexColor("#F1E9DA")
GOLD = HexColor("#C79848")
SKY = HexColor("#72B6DA")
LIME = HexColor("#5FAF81")
CRIMSON = HexColor("#B84F4C")
VIOLET = HexColor("#8B72B8")
DARK = HexColor("#25343D")

ASSETS = {
    "terrain": ROOT / "art/product_assets/ed_hybrid_v1/board/board_terrain_playfield_v01.png",
    "terrain_v02": ROOT / "art/product_assets/ed_hybrid_v2/board/board_terrain_playfield_v02.png",
    "title": ROOT / "art/product_assets/ed_hybrid_v1/shells/shell_title_hero_v01.png",
    "title_wordmark": ROOT / "art/product_assets/ed_hybrid_v2/shells/shell_title_wordmark_switchy_express_candidate_v01.png",
    "lesson": ROOT / "art/product_assets/ed_hybrid_v1/shells/shell_lesson_hero_v02.png",
    "success": ROOT / "art/product_assets/ed_hybrid_v1/shells/shell_result_success_v02.png",
    "failure": ROOT / "art/product_assets/ed_hybrid_v1/shells/shell_result_failure_v02.png",
    "train": ROOT / "art/product_assets/ed_hybrid_v1/core/core_train_locomotive_blue_normal_v01.png",
    "cargo_red": ROOT / "art/product_assets/ed_hybrid_v1/core/core_cargo_star_red_normal_v01.png",
    "cargo_blue": ROOT / "art/product_assets/ed_hybrid_v1/core/core_cargo_star_blue_normal_v01.png",
    "station_red": ROOT / "art/product_assets/ed_hybrid_v1/core/core_station_red_normal_v01.png",
    "station_blue": ROOT / "art/product_assets/ed_hybrid_v1/core/core_station_blue_normal_v01.png",
    # Human-review visual candidates.  These are deliberately separate from
    # product asset paths: embedding them in the PDF does not promote them to
    # runtime art or change any Godot consumer.
    "flow_reference": ROOT / "docs/visual-references/sx-vis-061-core-systems-board-exploration-002b.png",
    "hgb_title": ROOT / "docs/visual-references/human-game-blueprint/r02/sx-hgb-vis-001-title-hero-candidate.png",
    "hgb_build": ROOT / "docs/visual-references/human-game-blueprint/r02/sx-hgb-vis-002-build-board-candidate.png",
    "hgb_run": ROOT / "docs/visual-references/human-game-blueprint/r02/sx-hgb-vis-003-run-switch-top-candidate.png",
    "hgb_rail_station": ROOT / "docs/visual-references/human-game-blueprint/r02/sx-hgb-vis-004-rail-station-language-candidate.png",
}

DOCUMENT_CANDIDATE_KEYS = {"hgb_title", "hgb_build", "hgb_run", "hgb_rail_station"}
APPROVED_REFERENCE_KEYS = {"flow_reference", "terrain_v02"}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def load_data(path: Path) -> dict:
    text = path.read_text(encoding="utf-8")
    match = re.search(
        r"<!-- BLUEPRINT_DATA:START -->\s*```json\s*(.*?)\s*```\s*<!-- BLUEPRINT_DATA:END -->",
        text,
        re.DOTALL,
    )
    if match is None:
        raise ValueError(f"No BLUEPRINT_DATA block found in {path}")
    return json.loads(match.group(1))


def register_fonts() -> None:
    normal = Path(r"C:\Windows\Fonts\malgun.ttf")
    bold = Path(r"C:\Windows\Fonts\malgunbd.ttf")
    if not normal.exists() or not bold.exists():
        raise FileNotFoundError("Required embedded Korean fonts are unavailable: Malgun Gothic")
    pdfmetrics.registerFont(TTFont("Malgun", str(normal)))
    pdfmetrics.registerFont(TTFont("MalgunBold", str(bold)))


def ensure_assets() -> None:
    missing = [str(path) for path in ASSETS.values() if not path.exists()]
    if missing:
        raise FileNotFoundError("Missing required current runtime asset(s): " + ", ".join(missing))


def run_state_connector_pairs(state_count: int) -> tuple[tuple[int, int], ...]:
    """Return only the adjacent, card-to-card transitions shown in the RUN state map.

    BUILD_FAIL deliberately has no outgoing visual connector: the card itself
    says that the player returns to BUILD, while the first RUN card represents
    a separate successful-preflight entry.
    """
    if state_count != 6:
        return ()
    return ((1, 2), (3, 4), (4, 5))


def journey_table_layout(row_count: int) -> tuple[float, float]:
    """Fit the full journey table and its continuity callout above the footer."""
    return table_with_callout_layout(row_count, header_height=30, callout_height=39, maximum_row_height=50)


def content_table_layout(row_count: int) -> tuple[float, float]:
    """Fit the first-session content table and its product-boundary callout."""
    return table_with_callout_layout(row_count, header_height=29, callout_height=48, maximum_row_height=53)


def table_with_callout_layout(
    row_count: int,
    *,
    header_height: float,
    callout_height: float,
    maximum_row_height: float,
) -> tuple[float, float]:
    """Reserve footer clearance for any compact table plus its callout."""
    if row_count < 1:
        raise ValueError("table layout requires at least one row")
    table_start_y = PAGE_H - 133 - header_height
    callout_gap = 12
    footer_clearance = 34
    fitted_maximum_row_height = math.floor(
        (table_start_y - callout_gap - callout_height - footer_clearance) / row_count
    )
    row_height = float(max(30, min(maximum_row_height, fitted_maximum_row_height)))
    table_bottom_y = table_start_y - row_height * row_count
    callout_y = table_bottom_y - callout_gap - callout_height
    return row_height, callout_y


def lifo_question_card_layout(header_y: float, question_count: int) -> tuple[tuple[float, float, float, float], ...]:
    """Place LIFO questions in dedicated cards with enough copy space."""
    if question_count < 1:
        return ()
    width, height = 150.0, 80.0
    x = 654.0
    first_y = header_y - 105
    return tuple((x, first_y - index * 87, width, height) for index in range(question_count))


def capstone_card_layout(header_y: float, step_count: int) -> tuple[tuple[float, float, float, float], ...]:
    """Place the six VS_DEMO_01 decisions above the finish bar without clipped copy."""
    if step_count < 1:
        return ()
    width, height = 190.0, 100.0
    first_y = header_y - 125
    return tuple(
        (394.0 + (index % 2) * 202, first_y - (index // 2) * 112, width, height)
        for index in range(step_count)
    )


def fit_cover(image: Path, x: float, y: float, width: float, height: float) -> tuple[float, float, float, float]:
    reader = ImageReader(str(image))
    image_w, image_h = reader.getSize()
    scale = max(width / image_w, height / image_h)
    draw_w, draw_h = image_w * scale, image_h * scale
    return x - (draw_w - width) / 2, y - (draw_h - height) / 2, draw_w, draw_h


class BlueprintRenderer:
    def __init__(self, canvas: Canvas, data: dict) -> None:
        self.c = canvas
        self.data = data
        self.page_index = 0
        self.page_count = len(data["pages"])

    def page_background(self, dark: bool = False) -> None:
        self.c.setFillColor(NAVY if dark else PAPER)
        self.c.rect(0, 0, PAGE_W, PAGE_H, fill=1, stroke=0)

    def footer(self, dark: bool = False) -> None:
        self.c.setFont("Malgun", 7.2)
        self.c.setFillColor(HexColor("#CFD8DD") if dark else MUTED)
        self.c.drawString(MARGIN, 15, f"SWITCHY EXPRESS · HUMAN GAME BLUEPRINT · {self.data['revision']} · {self.data['date']}")
        self.c.drawRightString(PAGE_W - MARGIN, 15, f"{self.page_index:02d}/{self.page_count:02d}")

    def header(self, eyebrow: str, title: str, claim: str) -> float:
        self.page_background()
        self.c.setFillColor(NAVY)
        self.c.setFont("MalgunBold", 8.2)
        self.c.drawString(MARGIN, PAGE_H - 33, eyebrow)
        self.c.setFillColor(INK)
        self.c.setFont("MalgunBold", 24)
        self.c.drawString(MARGIN, PAGE_H - 66, title)
        self.c.setFillColor(MUTED)
        self.c.setFont("Malgun", 10.3)
        self.draw_wrapped(claim, MARGIN, PAGE_H - 85, PAGE_W - MARGIN * 2, 14, MUTED)
        self.c.setStrokeColor(PAPER_2)
        self.c.setLineWidth(1)
        self.c.line(MARGIN, PAGE_H - 112, PAGE_W - MARGIN, PAGE_H - 112)
        return PAGE_H - 133

    def draw_wrapped(
        self,
        text: str,
        x: float,
        y: float,
        width: float,
        leading: float,
        color: Color = INK,
        font: str = "Malgun",
        size: float = 10,
        max_lines: int | None = None,
    ) -> float:
        self.c.setFont(font, size)
        self.c.setFillColor(color)
        lines: list[str] = []
        for paragraph in str(text).split("\n"):
            if not paragraph:
                lines.append("")
                continue
            current = ""
            for token in re.split(r"(\s+)", paragraph):
                candidate = current + token
                if current and pdfmetrics.stringWidth(candidate, font, size) > width:
                    lines.append(current.rstrip())
                    current = token.lstrip()
                else:
                    current = candidate
            if current:
                lines.append(current.rstrip())
        if max_lines is not None:
            lines = lines[:max_lines]
        for index, line in enumerate(lines):
            self.c.drawString(x, y - index * leading, line)
        return y - len(lines) * leading

    def card(
        self,
        x: float,
        y: float,
        width: float,
        height: float,
        title: str,
        body: str,
        accent: Color = SKY,
        dark: bool = False,
        title_size: float = 12,
        body_size: float = 9.2,
    ) -> None:
        fill = DARK if dark else white
        self.c.setFillColor(fill)
        self.c.setStrokeColor(accent)
        self.c.setLineWidth(1.15)
        self.c.roundRect(x, y, width, height, 8, fill=1, stroke=1)
        self.c.setFillColor(accent)
        self.c.roundRect(x + 12, y + height - 25, 46, 12, 6, fill=1, stroke=0)
        self.c.setFillColor(white)
        self.c.setFont("MalgunBold", 6.4)
        self.c.drawCentredString(x + 35, y + height - 21, "핵심")
        self.c.setFillColor(white if dark else INK)
        self.c.setFont("MalgunBold", title_size)
        self.draw_wrapped(title, x + 13, y + height - 45, width - 26, title_size + 3, white if dark else INK, "MalgunBold", title_size, 2)
        self.draw_wrapped(body, x + 13, y + height - 80, width - 26, body_size + 3, HexColor("#DDE7EA") if dark else MUTED, "Malgun", body_size, 6)

    def color_for(self, name: str) -> Color:
        return {
            "BRIGHT": SKY,
            "VIOLET": VIOLET,
            "GOLD": GOLD,
            "BLUE": SKY,
            "DARK": DARK,
            "GREEN": LIME,
        }.get(name, SKY)

    def draw_asset_cover(self, key: str, x: float, y: float, width: float, height: float) -> None:
        image = ASSETS[key]
        dx, dy, dw, dh = fit_cover(image, x, y, width, height)
        path = self.c.beginPath()
        path.rect(x, y, width, height)
        self.c.saveState()
        self.c.clipPath(path, stroke=0, fill=0)
        self.c.drawImage(str(image), dx, dy, dw, dh, mask="auto")
        self.c.restoreState()

    def draw_asset_contain(self, key: str, x: float, y: float, width: float, height: float) -> None:
        reader = ImageReader(str(ASSETS[key]))
        image_w, image_h = reader.getSize()
        scale = min(width / image_w, height / image_h)
        draw_w, draw_h = image_w * scale, image_h * scale
        self.c.drawImage(str(ASSETS[key]), x + (width - draw_w) / 2, y + (height - draw_h) / 2, draw_w, draw_h, mask="auto")

    def board(self, x: float, y: float, width: float, height: float, markers: bool = True) -> None:
        self.c.setStrokeColor(HexColor("#D5C093"))
        self.c.setLineWidth(1.4)
        self.c.roundRect(x, y, width, height, 12, fill=0, stroke=1)
        self.draw_asset_cover("terrain", x + 3, y + 3, width - 6, height - 6)
        cols, rows = 15, 11
        cell_w, cell_h = (width - 26) / cols, (height - 26) / rows
        grid_x, grid_y = x + 13, y + 13
        self.c.setStrokeColor(Color(1, 1, 1, alpha=0.42))
        self.c.setLineWidth(0.45)
        for col in range(cols + 1):
            self.c.line(grid_x + col * cell_w, grid_y, grid_x + col * cell_w, grid_y + rows * cell_h)
        for row in range(rows + 1):
            self.c.line(grid_x, grid_y + row * cell_h, grid_x + cols * cell_w, grid_y + row * cell_h)
        if not markers:
            return
        def cell(point: tuple[int, int]) -> tuple[float, float]:
            col, row = point
            return grid_x + col * cell_w, grid_y + (rows - row - 1) * cell_h
        for point, asset in [((6, 5), "cargo_red"), ((10, 5), "cargo_blue"), ((14, 7), "cargo_red"), ((12, 9), "cargo_red"), ((8, 8), "station_red"), ((4, 8), "station_blue")]:
            cx, cy = cell(point)
            self.draw_asset_contain(asset, cx + 1, cy + 1, cell_w - 2, cell_h - 2)
        start_x, start_y = cell((1, 5))
        self.c.setFillColor(NAVY)
        self.c.circle(start_x + cell_w / 2, start_y + cell_h / 2, min(cell_w, cell_h) * 0.18, fill=1, stroke=0)
        self.c.setFillColor(white)
        self.c.setFont("MalgunBold", 6)
        self.c.drawCentredString(start_x + cell_w / 2, start_y + cell_h / 2 - 2, "시작")

    def draw_cover(self, page: dict) -> None:
        self.c.setFillColor(NAVY)
        self.c.rect(0, 0, PAGE_W, PAGE_H, fill=1, stroke=0)
        self.draw_asset_cover("hgb_title", 0, 0, PAGE_W, PAGE_H)
        self.c.setFillColor(Color(0.02, 0.07, 0.1, alpha=0.80))
        self.c.rect(0, 0, PAGE_W * 0.58, PAGE_H, fill=1, stroke=0)
        self.c.setFillColor(PAPER)
        self.c.roundRect(MARGIN, PAGE_H - 173, 405, 72, 10, fill=1, stroke=0)
        self.draw_asset_contain("title_wordmark", MARGIN + 18, PAGE_H - 163, 369, 52)
        self.c.setFillColor(GOLD)
        self.c.roundRect(MARGIN, PAGE_H - 73, 154, 21, 10, fill=1, stroke=0)
        self.c.setFillColor(NAVY)
        self.c.setFont("MalgunBold", 8.2)
        self.c.drawCentredString(MARGIN + 77, PAGE_H - 66, "HUMAN GAME BLUEPRINT")
        self.c.setFillColor(white)
        self.c.setFont("MalgunBold", 33)
        y = PAGE_H - 223
        for line in page["title"].split("\n"):
            self.c.drawString(MARGIN, y, line)
            y -= 42
        self.draw_wrapped(page["subtitle"], MARGIN, y - 12, 370, 19, HexColor("#E1E8E9"), "Malgun", 12.2)
        chip_x = MARGIN
        for verb in page["verbs"]:
            self.c.setFillColor(Color(0.07, 0.16, 0.2, alpha=0.96))
            self.c.roundRect(chip_x, 125, 59, 24, 8, fill=1, stroke=0)
            self.c.setFillColor(GOLD)
            self.c.setFont("MalgunBold", 8.5)
            self.c.drawCentredString(chip_x + 29.5, 133, verb)
            chip_x += 66
        self.c.setFillColor(Color(0.06, 0.13, 0.17, alpha=0.9))
        self.c.roundRect(MARGIN, 51, 405, 42, 8, fill=1, stroke=0)
        self.c.setFillColor(HexColor("#D8E3E5"))
        self.c.setFont("Malgun", 9)
        self.c.drawString(MARGIN + 14, 76, page["status"])
        self.c.setFont("Malgun", 7.4)
        self.c.drawString(MARGIN + 14, 61, "현재 제품·승인 설계·시각 참고를 구분한 검수용 파생본")
        self.footer(dark=True)

    def draw_vision(self, page: dict) -> None:
        y = self.header(page["eyebrow"], page["title"], page["claim"])
        self.c.setFillColor(NAVY)
        self.c.roundRect(MARGIN, y - 52, PAGE_W - 2 * MARGIN, 41, 8, fill=1, stroke=0)
        self.c.setFillColor(white)
        self.c.setFont("MalgunBold", 15)
        self.c.drawCentredString(PAGE_W / 2, y - 37, "선로의 선택이 화물 TOP의 선택이 되는 퍼즐")
        cards = [("대상 플레이어", page["audience"], SKY), ("플레이어 판타지", page["fantasy"], GOLD), ("기억할 순간", page["memory"], CRIMSON)]
        width = (PAGE_W - 2 * MARGIN - 24) / 3
        for index, (title, body, accent) in enumerate(cards):
            self.card(MARGIN + index * (width + 12), y - 214, width, 137, title, body, accent)
        self.c.setFont("MalgunBold", 12)
        self.c.setFillColor(INK)
        self.c.drawString(MARGIN, y - 243, "세 가지 설계 기둥")
        pillar_w = (PAGE_W - 2 * MARGIN - 24) / 3
        for index, (title, body) in enumerate(page["pillars"]):
            self.card(MARGIN + index * (pillar_w + 12), y - 365, pillar_w, 97, title, body, [SKY, GOLD, LIME][index], title_size=10.5)
        self.c.setFillColor(HexColor("#F8E4E0"))
        self.c.setStrokeColor(CRIMSON)
        self.c.roundRect(MARGIN, y - 433, PAGE_W - 2 * MARGIN, 45, 8, fill=1, stroke=1)
        self.c.setFillColor(CRIMSON)
        self.c.setFont("MalgunBold", 9.5)
        self.c.drawString(MARGIN + 14, y - 408, "이 게임이 아닌 것")
        self.draw_wrapped(page["not_this"], MARGIN + 110, y - 408, PAGE_W - 2 * MARGIN - 125, 12, CRIMSON, "Malgun", 8.8, 2)
        self.footer()

    def draw_positioning(self, page: dict) -> None:
        y = self.header(page["eyebrow"], page["title"], page["claim"])
        headers = ["비교작", "공식 설명에서 읽은 문법", "ADOPT / ADAPT", "Switchy의 경계"]
        widths = [112, 145, 148, PAGE_W - 2 * MARGIN - 405]
        x = MARGIN
        height = 33
        self.c.setFillColor(NAVY)
        self.c.rect(x, y - height, sum(widths), height, fill=1, stroke=0)
        cursor = x
        self.c.setFillColor(white)
        self.c.setFont("MalgunBold", 8)
        for header, width in zip(headers, widths):
            self.c.drawString(cursor + 7, y - 21, header)
            cursor += width
        row_y = y - height
        accents = [SKY, GOLD, LIME, SKY, NAVY]
        for index, row in enumerate(page["rows"]):
            row_h = 64 if index < 4 else 74
            self.c.setFillColor(white if index % 2 == 0 else PAPER_2)
            self.c.rect(x, row_y - row_h, sum(widths), row_h, fill=1, stroke=0)
            self.c.setStrokeColor(HexColor("#DFD5C5"))
            self.c.rect(x, row_y - row_h, sum(widths), row_h, fill=0, stroke=1)
            cursor = x
            for cell, width in zip(row, widths):
                self.c.setStrokeColor(HexColor("#DFD5C5"))
                self.c.line(cursor, row_y, cursor, row_y - row_h)
                self.draw_wrapped(cell, cursor + 7, row_y - 15, width - 14, 10.5, INK if index == 4 else MUTED, "MalgunBold" if index == 4 else "Malgun", 8.2, 5)
                cursor += width
            self.c.setFillColor(accents[index])
            self.c.rect(x, row_y - row_h, 4, row_h, fill=1, stroke=0)
            row_y -= row_h
        self.c.setFillColor(MUTED)
        self.c.setFont("Malgun", 8)
        self.draw_wrapped(page["note"], MARGIN, row_y - 22, PAGE_W - 2 * MARGIN, 11, MUTED, "Malgun", 8, 2)
        self.footer()

    def draw_experience(self, page: dict) -> None:
        y = self.header(page["eyebrow"], page["title"], page["claim"])
        widths = (PAGE_W - 2 * MARGIN - 32) / 5
        positions = []
        for index, item in enumerate(page["steps"]):
            row, col = divmod(index, 5)
            x = MARGIN + col * (widths + 8)
            card_y = y - 126 - row * 144
            positions.append((x, card_y))
            accent = [SKY, GOLD, CRIMSON, VIOLET, GOLD, LIME, SKY, CRIMSON, LIME][index]
            self.c.setFillColor(white)
            self.c.setStrokeColor(accent)
            self.c.roundRect(x, card_y, widths, 112, 8, fill=1, stroke=1)
            self.c.setFillColor(accent)
            self.c.circle(x + 18, card_y + 92, 11, fill=1, stroke=0)
            self.c.setFillColor(white)
            self.c.setFont("MalgunBold", 7)
            self.c.drawCentredString(x + 18, card_y + 89, item[0])
            self.c.setFillColor(INK)
            self.c.setFont("MalgunBold", 10)
            self.c.drawString(x + 35, card_y + 87, item[1])
            self.draw_wrapped(item[2], x + 12, card_y + 62, widths - 24, 12, MUTED, "Malgun", 8.2, 2)
            self.c.setFillColor(accent)
            self.c.setFont("MalgunBold", 8.3)
            self.c.drawString(x + 12, card_y + 14, item[3])
        self.c.setStrokeColor(GOLD)
        self.c.setLineWidth(2)
        for index in range(4):
            x1, y1 = positions[index]
            x2, y2 = positions[index + 1]
            self.c.line(x1 + widths, y1 + 56, x2 - 4, y2 + 56)
        for index in range(5, 8):
            x1, y1 = positions[index]
            x2, y2 = positions[index + 1]
            self.c.line(x1 + widths, y1 + 56, x2 - 4, y2 + 56)
        self.c.setFillColor(NAVY)
        self.c.roundRect(MARGIN, 72, PAGE_W - 2 * MARGIN, 33, 8, fill=1, stroke=0)
        self.c.setFillColor(white)
        self.c.setFont("MalgunBold", 9.5)
        self.c.drawCentredString(PAGE_W / 2, 84, page["bottom"])
        self.footer()

    def draw_flow(self, page: dict) -> None:
        y = self.header(page["eyebrow"], page["title"], page["claim"])
        image_x, image_y, image_w, image_h = MARGIN, 163, 458, 267
        self.draw_asset_cover("flow_reference", image_x, image_y, image_w, image_h)
        self.c.setStrokeColor(GOLD)
        self.c.setLineWidth(1.25)
        self.c.roundRect(image_x, image_y, image_w, image_h, 10, fill=0, stroke=1)
        self.c.setFillColor(MUTED)
        self.c.setFont("Malgun", 7.3)
        self.c.drawString(image_x + 8, image_y - 12, "승인된 planning reference 재사용 · 실제 런타임 캡처 아님")

        flow_x, flow_w, node_h = 520, 285, 36
        self.c.setFillColor(INK)
        self.c.setFont("MalgunBold", 11)
        self.c.drawString(flow_x, y - 16, "화면 흐름 · 실제 편집 텍스트")
        for index, node in enumerate(page["nodes"]):
            number, title, body, state = node
            node_y = y - 60 - index * 40
            accent = self.color_for(state)
            self.c.setFillColor(white)
            self.c.setStrokeColor(accent)
            self.c.setLineWidth(1)
            self.c.roundRect(flow_x, node_y, flow_w, node_h, 7, fill=1, stroke=1)
            self.c.setFillColor(accent)
            self.c.circle(flow_x + 16, node_y + 18, 9, fill=1, stroke=0)
            self.c.setFillColor(white)
            self.c.setFont("MalgunBold", 6.4)
            self.c.drawCentredString(flow_x + 16, node_y + 15.5, number)
            self.c.setFillColor(INK)
            self.c.setFont("MalgunBold", 8.5)
            self.c.drawString(flow_x + 30, node_y + 20, title)
            self.c.setFillColor(MUTED)
            self.c.setFont("Malgun", 6.5)
            self.c.drawRightString(flow_x + flow_w - 8, node_y + 20, body)
            if index < len(page["nodes"]) - 1:
                self.c.setStrokeColor(NAVY)
                self.c.setLineWidth(1.1)
                self.c.line(flow_x + flow_w / 2, node_y, flow_x + flow_w / 2, node_y - 4)
        branch_y = 54
        for index, text in enumerate(page["branches"]):
            x, width, height = MARGIN + index * 250, 235, 62
            accent = [LIME, CRIMSON, DARK][index]
            self.c.setFillColor(white)
            self.c.setStrokeColor(accent)
            self.c.setLineWidth(1.1)
            self.c.roundRect(x, branch_y, width, height, 8, fill=1, stroke=1)
            self.c.setFillColor(accent)
            self.c.roundRect(x + 12, branch_y + height - 22, 48, 11, 5, fill=1, stroke=0)
            self.c.setFillColor(white)
            self.c.setFont("MalgunBold", 6.1)
            self.c.drawCentredString(x + 36, branch_y + height - 18, "흐름")
            self.c.setFillColor(INK)
            self.c.setFont("MalgunBold", 9.2)
            self.c.drawString(x + 12, branch_y + height - 38, ["진행", "회복", "종료"][index])
            self.draw_wrapped(text, x + 55, branch_y + height - 38, width - 67, 8.5, MUTED, "Malgun", 7.2, 2)
        self.footer()

    def arrow(self, x1: float, y1: float, x2: float, y2: float) -> None:
        import math
        dx, dy = x2 - x1, y2 - y1
        length = max(1.0, (dx * dx + dy * dy) ** 0.5)
        ux, uy = dx / length, dy / length
        start_x, start_y = x1 + ux * 68, y1 + uy * 43
        end_x, end_y = x2 - ux * 68, y2 - uy * 43
        self.c.line(start_x, start_y, end_x, end_y)
        angle = math.atan2(uy, ux)
        size = 7
        for delta in (2.6, -2.6):
            self.c.line(end_x, end_y, end_x - size * math.cos(angle + delta), end_y - size * math.sin(angle + delta))

    def draw_journey_table(self, page: dict) -> None:
        y = self.header(page["eyebrow"], page["title"], page["claim"])
        widths = [92, 128, 150, 166, PAGE_W - 2 * MARGIN - 536]
        x = MARGIN
        header_h = 30
        self.c.setFillColor(NAVY)
        self.c.rect(x, y - header_h, sum(widths), header_h, fill=1, stroke=0)
        cursor = x
        self.c.setFont("MalgunBold", 7.4)
        self.c.setFillColor(white)
        for heading, width in zip(page["headers"], widths):
            self.c.drawString(cursor + 6, y - 19, heading)
            cursor += width
        row_h, callout_y = journey_table_layout(len(page["rows"]))
        row_y = y - header_h
        for row_index, row in enumerate(page["rows"]):
            self.c.setFillColor(white if row_index % 2 == 0 else PAPER_2)
            self.c.rect(x, row_y - row_h, sum(widths), row_h, fill=1, stroke=0)
            cursor = x
            for col_index, (text, width) in enumerate(zip(row, widths)):
                self.c.setStrokeColor(HexColor("#DDCFBC"))
                self.c.rect(cursor, row_y - row_h, width, row_h, fill=0, stroke=1)
                self.draw_wrapped(text, cursor + 6, row_y - 13, width - 12, 9.3, INK if col_index == 0 else MUTED, "MalgunBold" if col_index == 0 else "Malgun", 7.4, 4)
                cursor += width
            row_y -= row_h
        self.c.setFillColor(HexColor("#E7F0E9"))
        self.c.setStrokeColor(LIME)
        self.c.roundRect(MARGIN, callout_y, PAGE_W - 2 * MARGIN, 39, 8, fill=1, stroke=1)
        self.c.setFillColor(LIME)
        self.c.setFont("MalgunBold", 9.4)
        self.c.drawCentredString(PAGE_W / 2, callout_y + 14, "앞 단계에서 얻은 정보가 다음 판단을 바꾸지 않으면, 화면은 흐름이 아니라 목록이 된다.")
        self.footer()

    def draw_atlas(self, page: dict) -> None:
        y = self.header(page["eyebrow"], page["title"], page["claim"])
        cols, card_w, card_h = 3, 232, 163
        for index, card in enumerate(page["cards"]):
            row, col = divmod(index, cols)
            x = MARGIN + col * (card_w + 17)
            card_y = y - 185 - row * 184
            number, title, body, asset = card
            visual_asset = ["hgb_title", "lesson", "hgb_build", "hgb_run", "success", "failure"][index]
            self.c.setFillColor(white)
            self.c.setStrokeColor([SKY, VIOLET, GOLD, LIME, GOLD, CRIMSON][index])
            self.c.roundRect(x, card_y, card_w, card_h, 8, fill=1, stroke=1)
            self.draw_asset_cover(visual_asset, x + 8, card_y + 51, card_w - 16, 94)
            self.c.setFillColor(NAVY)
            self.c.roundRect(x + 10, card_y + 24, 26, 15, 7, fill=1, stroke=0)
            self.c.setFillColor(white)
            self.c.setFont("MalgunBold", 6.7)
            self.c.drawCentredString(x + 23, card_y + 29, number)
            self.c.setFillColor(INK)
            self.c.setFont("MalgunBold", 10.4)
            self.c.drawString(x + 44, card_y + 29, title)
            self.draw_wrapped(body, x + 10, card_y + 12, card_w - 20, 9, MUTED, "Malgun", 7.5, 2)
        self.c.setFillColor(CRIMSON)
        self.c.setFont("Malgun", 7.6)
        self.draw_wrapped(page["note"], MARGIN, 47, PAGE_W - 2 * MARGIN, 10, CRIMSON, "Malgun", 7.6, 2)
        self.footer()

    def draw_scene_contract(self, page: dict) -> None:
        y = self.header(page["eyebrow"], page["title"], page["claim"])
        headers = ["장면", "들어온 조건", "가장 먼저 보는 것", "핵심 판단", "다음 장면"]
        widths = [92, 136, 170, 190, PAGE_W - 2 * MARGIN - 588]
        x = MARGIN
        self.c.setFillColor(NAVY)
        self.c.rect(x, y - 29, sum(widths), 29, fill=1, stroke=0)
        cursor = x
        self.c.setFillColor(white)
        self.c.setFont("MalgunBold", 7.3)
        for heading, width in zip(headers, widths):
            self.c.drawString(cursor + 6, y - 18, heading)
            cursor += width
        row_y = y - 29
        for index, row in enumerate(page["items"]):
            row_h = 54
            self.c.setFillColor(white if index % 2 == 0 else PAPER_2)
            self.c.rect(x, row_y - row_h, sum(widths), row_h, fill=1, stroke=0)
            cursor = x
            for col, (text, width) in enumerate(zip(row, widths)):
                self.c.setStrokeColor(HexColor("#DDCFBC"))
                self.c.rect(cursor, row_y - row_h, width, row_h, fill=0, stroke=1)
                self.draw_wrapped(text, cursor + 6, row_y - 13, width - 12, 9.3, INK if col == 0 else MUTED, "MalgunBold" if col == 0 else "Malgun", 7.4, 4)
                cursor += width
            row_y -= row_h
        self.c.setFillColor(NAVY)
        self.c.roundRect(MARGIN, row_y - 62, PAGE_W - 2 * MARGIN, 48, 8, fill=1, stroke=0)
        self.c.setFillColor(white)
        self.c.setFont("MalgunBold", 9.1)
        self.draw_wrapped(page["footer"], MARGIN + 14, row_y - 34, PAGE_W - 2 * MARGIN - 28, 12, white, "MalgunBold", 9.1, 3)
        self.footer()

    def draw_lesson_curve(self, page: dict) -> None:
        y = self.header(page["eyebrow"], page["title"], page["claim"])
        cards = page["cards"]
        card_w = (PAGE_W - 2 * MARGIN - 36) / 4
        for index, card in enumerate(cards):
            row, col = divmod(index, 4)
            x = MARGIN + col * (card_w + 12)
            card_y = y - 154 - row * 183
            lesson, title, body, takeaway = card
            accent = [SKY, GOLD, CRIMSON, LIME, SKY, VIOLET, NAVY][index]
            self.card(x, card_y, card_w, 151, f"{lesson} · {title}", body, accent, title_size=10.3, body_size=8.5)
            self.c.setFillColor(accent)
            self.c.setFont("MalgunBold", 8)
            self.draw_wrapped(takeaway, x + 13, card_y + 18, card_w - 26, 10, accent, "MalgunBold", 8, 2)
        self.footer()

    def draw_board_layers(self, page: dict) -> None:
        y = self.header(page["eyebrow"], page["title"], page["claim"])
        self.draw_asset_cover("hgb_build", MARGIN, y - 360, 420, 275)
        self.c.setStrokeColor(GOLD)
        self.c.setLineWidth(1.2)
        self.c.roundRect(MARGIN, y - 360, 420, 275, 10, fill=0, stroke=1)
        layer_x = MARGIN + 446
        row_h = 42
        for index, layer in enumerate(page["layers"]):
            number, title, info, reason = layer
            row_y = y - 48 - index * row_h
            accent = [GOLD, SKY, CRIMSON, LIME, VIOLET, DARK][index]
            self.c.setFillColor(white)
            self.c.setStrokeColor(accent)
            self.c.roundRect(layer_x, row_y - row_h + 4, PAGE_W - MARGIN - layer_x, row_h - 5, 6, fill=1, stroke=1)
            self.c.setFillColor(accent)
            self.c.circle(layer_x + 15, row_y - 17, 10, fill=1, stroke=0)
            self.c.setFillColor(white)
            self.c.setFont("MalgunBold", 7)
            self.c.drawCentredString(layer_x + 15, row_y - 20, number)
            self.c.setFillColor(INK)
            self.c.setFont("MalgunBold", 9)
            self.c.drawString(layer_x + 31, row_y - 15, title)
            self.c.setFont("Malgun", 7.6)
            self.c.setFillColor(MUTED)
            self.c.drawString(layer_x + 94, row_y - 15, info)
            self.c.setFillColor(accent)
            self.c.drawRightString(PAGE_W - MARGIN - 10, row_y - 15, reason)
        self.c.setFillColor(CRIMSON)
        self.c.setFont("Malgun", 8)
        self.c.drawString(MARGIN, 65, page["note"])
        self.footer()

    def draw_build_board(self, page: dict) -> None:
        y = self.header(page["eyebrow"], page["title"], page["claim"])
        self.draw_asset_cover("hgb_build", MARGIN, 116, 425, 300)
        self.c.setStrokeColor(GOLD)
        self.c.setLineWidth(1.2)
        self.c.roundRect(MARGIN, 116, 425, 300, 10, fill=0, stroke=1)
        self.c.setFillColor(NAVY)
        self.c.setFont("MalgunBold", 8.8)
        self.c.drawCentredString(MARGIN + 212, 97, page["diagram_label"])
        x = 493
        self.c.setFillColor(INK)
        self.c.setFont("MalgunBold", 12)
        self.c.drawString(x, y - 12, "RUN 전에 확인하는 조건")
        for index, item in enumerate(page["left"]):
            card_y, accent = y - 72 - index * 61, [SKY, LIME, GOLD, VIOLET][index]
            self.c.setFillColor(white)
            self.c.setStrokeColor(accent)
            self.c.setLineWidth(1.15)
            self.c.roundRect(x, card_y, 315, 49, 8, fill=1, stroke=1)
            self.c.setFillColor(accent)
            self.c.circle(x + 19, card_y + 24.5, 12, fill=1, stroke=0)
            self.c.setFillColor(white)
            self.c.setFont("MalgunBold", 7.3)
            self.c.drawCentredString(x + 19, card_y + 21.6, str(index + 1))
            self.draw_wrapped(item, x + 40, card_y + 31, 262, 9.3, INK, "Malgun", 8.0, 2)
        self.c.setFillColor(INK)
        self.c.setFont("MalgunBold", 12)
        self.c.drawString(x, 183, "플레이어가 설계하는 것")
        for index, item in enumerate(page["right"]):
            self.c.setFillColor([SKY, CRIMSON, GOLD, LIME][index])
            self.c.roundRect(x + (index % 2) * 157, 134 - (index // 2) * 41, 146, 31, 7, fill=1, stroke=0)
            self.c.setFillColor(white)
            self.c.setFont("MalgunBold", 8.4)
            self.c.drawCentredString(x + (index % 2) * 157 + 73, 145 - (index // 2) * 41, item)
        self.footer()

    def draw_lifo(self, page: dict) -> None:
        y = self.header(page["eyebrow"], page["title"], page["claim"])
        stack_x, stack_y, size = 126, 158, 106
        colors = [SKY, CRIMSON, SKY]
        for index, (label, color) in enumerate(zip(page["stack"], colors)):
            block_y = stack_y + index * 74
            self.c.setFillColor(color)
            self.c.roundRect(stack_x, block_y, size, 55, 9, fill=1, stroke=0)
            self.c.setFillColor(white)
            self.c.setFont("MalgunBold", 9.3)
            self.c.drawCentredString(stack_x + size / 2, block_y + 31, label)
            if index == 2:
                self.c.setStrokeColor(GOLD)
                self.c.setLineWidth(3)
                self.c.roundRect(stack_x - 5, block_y - 5, size + 10, 65, 11, fill=0, stroke=1)
        self.c.setFillColor(NAVY)
        self.c.setFont("MalgunBold", 10)
        self.c.drawCentredString(stack_x + size / 2, 124, "먼저 적재 → TOP")
        self.c.setStrokeColor(GOLD)
        self.c.setLineWidth(3)
        self.arrow(stack_x + 142, stack_y + 112, 425, stack_y + 112)
        self.c.setFillColor(white)
        self.c.setStrokeColor(GOLD)
        self.c.roundRect(432, 195, 190, 128, 14, fill=1, stroke=1)
        self.draw_asset_contain("station_blue", 482, 228, 58, 58)
        self.c.setFillColor(INK)
        self.c.setFont("MalgunBold", 12)
        self.c.drawCentredString(527, 211, "맞는 역의 옆 칸")
        self.c.setFillColor(LIME)
        self.c.setFont("MalgunBold", 11)
        self.c.drawCentredString(527, 183, "TOP부터 연속 묶음 하역")
        qx = 654
        self.c.setFillColor(INK)
        self.c.setFont("MalgunBold", 13)
        self.c.drawString(qx, y - 10, "계속 묻는 세 가지")
        for index, (question, (card_x, card_y, card_w, card_h)) in enumerate(
            zip(page["questions"], lifo_question_card_layout(y, len(page["questions"])))
        ):
            accent = [SKY, GOLD, CRIMSON][index % 3]
            self.c.setFillColor(white)
            self.c.setStrokeColor(accent)
            self.c.setLineWidth(1.15)
            self.c.roundRect(card_x, card_y, card_w, card_h, 8, fill=1, stroke=1)
            self.c.setFillColor(accent)
            self.c.roundRect(card_x + 11, card_y + card_h - 24, 28, 13, 6, fill=1, stroke=0)
            self.c.setFillColor(white)
            self.c.setFont("MalgunBold", 6.6)
            self.c.drawCentredString(card_x + 25, card_y + card_h - 20, str(index + 1))
            self.draw_wrapped(question, card_x + 12, card_y + 43, card_w - 24, 10, MUTED, "Malgun", 7.5, 3)
        self.c.setFillColor(NAVY)
        self.c.roundRect(MARGIN, 55, PAGE_W - 2 * MARGIN, 41, 8, fill=1, stroke=0)
        self.c.setFillColor(white)
        self.c.setFont("Malgun", 8.7)
        self.draw_wrapped(page["rule"], MARGIN + 14, 78, PAGE_W - 2 * MARGIN - 28, 11, white, "Malgun", 8.7, 2)
        self.footer()

    def draw_station(self, page: dict) -> None:
        y = self.header(page["eyebrow"], page["title"], page["claim"])
        grid_x, grid_y, cell = 108, 150, 94
        allowed = {(1, 2): "위", (2, 1): "오른쪽", (1, 0): "아래", (0, 1): "왼쪽"}
        for row in range(3):
            for col in range(3):
                x, gy = grid_x + col * cell, grid_y + row * cell
                if (col, row) == (1, 1):
                    self.c.setFillColor(PAPER_2)
                    accent = NAVY
                elif (col, row) in allowed:
                    self.c.setFillColor(HexColor("#E3F1E7"))
                    accent = LIME
                else:
                    self.c.setFillColor(HexColor("#F8E5E2"))
                    accent = CRIMSON
                self.c.setStrokeColor(accent)
                self.c.roundRect(x, gy, cell - 7, cell - 7, 8, fill=1, stroke=1)
                if (col, row) == (1, 1):
                    self.draw_asset_contain("station_red", x + 16, gy + 16, cell - 39, cell - 39)
                    self.c.setFillColor(NAVY)
                    self.c.setFont("MalgunBold", 7.5)
                    self.c.drawCentredString(x + (cell - 7) / 2, gy + 11, "역 건물")
                else:
                    self.c.setFillColor(accent)
                    self.c.setFont("MalgunBold", 8)
                    label = allowed.get((col, row), "대각선")
                    self.c.drawCentredString(x + (cell - 7) / 2, gy + 40, label)
                    self.c.setFont("Malgun", 7)
                    self.c.drawCentredString(x + (cell - 7) / 2, gy + 25, "배송 가능" if (col, row) in allowed else "배송 불가")
        self.c.setFillColor(INK)
        self.c.setFont("MalgunBold", 13)
        self.c.drawString(440, y - 10, "배송 가능한 네 칸")
        for index, direction in enumerate(page["allowed"]):
            card_x = 440 + (index % 2) * 165
            card_y = y - 70 - (index // 2) * 72
            self.c.setFillColor(white)
            self.c.setStrokeColor(LIME)
            self.c.setLineWidth(1.15)
            self.c.roundRect(card_x, card_y, 150, 57, 8, fill=1, stroke=1)
            self.c.setFillColor(LIME)
            self.c.roundRect(card_x + 12, card_y + 34, 46, 12, 6, fill=1, stroke=0)
            self.c.setFillColor(white)
            self.c.setFont("MalgunBold", 6.4)
            self.c.drawCentredString(card_x + 35, card_y + 38, "핵심")
            self.c.setFillColor(INK)
            self.c.setFont("MalgunBold", 10)
            self.c.drawString(card_x + 13, card_y + 16, direction)
            self.c.setFillColor(MUTED)
            self.c.setFont("Malgun", 6.8)
            self.c.drawRightString(card_x + 137, card_y + 17, "배송 가능한 한 칸")
        self.c.setFont("MalgunBold", 13)
        self.c.setFillColor(INK)
        self.c.drawString(440, 218, "배송으로 세지 않는 위치")
        self.draw_wrapped(" · ".join(page["not_allowed"]), 440, 193, 325, 16, CRIMSON, "MalgunBold", 10, 3)
        self.c.setFillColor(NAVY)
        self.c.roundRect(440, 84, 325, 78, 9, fill=1, stroke=0)
        self.c.setFillColor(white)
        self.c.setFont("MalgunBold", 10)
        self.c.drawString(456, 142, "세 단계")
        for index, step in enumerate(page["steps"]):
            self.c.setFont("Malgun", 8.5)
            self.c.drawString(456, 122 - index * 17, step)
        self.c.setFillColor(MUTED)
        self.c.setFont("Malgun", 8)
        self.draw_wrapped(page["note"], MARGIN, 58, PAGE_W - 2 * MARGIN, 10, MUTED, "Malgun", 8, 2)
        self.footer()

    def draw_auto(self, page: dict) -> None:
        y = self.header(page["eyebrow"], page["title"], page["claim"])
        card_w = (PAGE_W - 2 * MARGIN - 24) / 3
        for index, (title, body, when) in enumerate(page["cards"]):
            accent = [SKY, LIME, CRIMSON][index]
            x = MARGIN + index * (card_w + 12)
            self.card(x, y - 245, card_w, 182, title, body, accent, title_size=14, body_size=10)
            self.c.setFillColor(PAPER_2)
            self.c.roundRect(x + 13, y - 222, card_w - 26, 38, 8, fill=1, stroke=0)
            self.c.setFillColor(accent)
            self.c.setFont("MalgunBold", 9.4)
            self.c.drawCentredString(x + card_w / 2, y - 208, when)
        self.c.setFillColor(NAVY)
        self.c.roundRect(MARGIN, y - 331, PAGE_W - 2 * MARGIN, 54, 8, fill=1, stroke=0)
        self.c.setFillColor(white)
        self.c.setFont("MalgunBold", 11)
        self.c.drawCentredString(PAGE_W / 2, y - 309, page["bottom"])
        self.c.setFillColor(HexColor("#D8E5E7"))
        self.c.setFont("Malgun", 8.5)
        self.c.drawCentredString(PAGE_W / 2, y - 327, "자동화는 편의의 범위를 넓히지만, 순서의 의미를 대신 결정하지 않는다.")
        self.footer()

    def draw_switch(self, page: dict) -> None:
        y = self.header(page["eyebrow"], page["title"], page["claim"])
        self.draw_asset_cover("hgb_run", MARGIN, 132, 394, 269)
        self.c.setStrokeColor(GOLD)
        self.c.setLineWidth(1.2)
        self.c.roundRect(MARGIN, 132, 394, 269, 10, fill=0, stroke=1)
        self.c.setFillColor(MUTED)
        self.c.setFont("Malgun", 7.4)
        self.c.drawCentredString(MARGIN + 197, 117, "문서용 RUN 후보 · 선택 행로·대안·잠금 상태의 시각 문법")
        for index, (title, body, tail) in enumerate(page["states"]):
            card_x, card_y, accent = 460, y - 66 - index * 86, [SKY, LIME, CRIMSON, DARK][index]
            self.c.setFillColor(white)
            self.c.setStrokeColor(accent)
            self.c.setLineWidth(1.2)
            self.c.roundRect(card_x, card_y, 305, 71, 9, fill=1, stroke=1)
            self.c.setFillColor(accent)
            self.c.roundRect(card_x + 14, card_y + 47, 48, 12, 6, fill=1, stroke=0)
            self.c.setFillColor(white)
            self.c.setFont("MalgunBold", 6.2)
            self.c.drawCentredString(card_x + 38, card_y + 51, "핵심")
            self.c.setFillColor(INK)
            self.c.setFont("MalgunBold", 10.2)
            self.c.drawString(card_x + 14, card_y + 31, title)
            self.draw_wrapped(body, card_x + 14, card_y + 14, 278, 8.7, MUTED, "Malgun", 7.9, 1)
            self.c.setFillColor(accent)
            self.c.setFont("MalgunBold", 7.8)
            self.c.drawRightString(752, y - 126 - index * 86, tail)
        self.c.setFillColor(HexColor("#F8E4E0"))
        self.c.setStrokeColor(CRIMSON)
        self.c.roundRect(MARGIN, 55, PAGE_W - 2 * MARGIN, 45, 8, fill=1, stroke=1)
        self.c.setFillColor(CRIMSON)
        self.c.setFont("MalgunBold", 8.7)
        self.draw_wrapped(page["warning"], MARGIN + 14, 79, PAGE_W - 2 * MARGIN - 28, 11, CRIMSON, "MalgunBold", 8.7, 3)
        self.footer()

    def draw_capstone(self, page: dict) -> None:
        y = self.header(page["eyebrow"], page["title"], page["claim"])
        self.draw_asset_cover("hgb_run", MARGIN, 126, 340, 255)
        self.c.setStrokeColor(GOLD)
        self.c.setLineWidth(1.2)
        self.c.roundRect(MARGIN, 126, 340, 255, 10, fill=0, stroke=1)
        for index, ((number, title, body), (card_x, card_y, card_w, card_h)) in enumerate(
            zip(page["steps"], capstone_card_layout(y, len(page["steps"])))
        ):
            accent = [SKY, GOLD, CRIMSON, LIME, VIOLET, NAVY][index % 6]
            self.c.setFillColor(white)
            self.c.setStrokeColor(accent)
            self.c.setLineWidth(1.15)
            self.c.roundRect(card_x, card_y, card_w, card_h, 8, fill=1, stroke=1)
            self.c.setFillColor(accent)
            self.c.roundRect(card_x + 12, card_y + card_h - 25, 46, 12, 6, fill=1, stroke=0)
            self.c.setFillColor(white)
            self.c.setFont("MalgunBold", 6.4)
            self.c.drawCentredString(card_x + 35, card_y + card_h - 21, "핵심")
            self.draw_wrapped(f"{number} · {title}", card_x + 13, card_y + 58, card_w - 26, 12, INK, "MalgunBold", 10, 1)
            self.draw_wrapped(body, card_x + 13, card_y + 38, card_w - 26, 9, MUTED, "Malgun", 7.4, 3)
        self.c.setFillColor(NAVY)
        self.c.roundRect(MARGIN, 56, PAGE_W - 2 * MARGIN, 48, 8, fill=1, stroke=0)
        self.c.setFillColor(white)
        self.c.setFont("MalgunBold", 9.2)
        self.draw_wrapped(page["finish"], MARGIN + 14, 83, PAGE_W - 2 * MARGIN - 28, 12, white, "MalgunBold", 9.2, 3)
        self.footer()

    def draw_result(self, page: dict) -> None:
        y = self.header(page["eyebrow"], page["title"], page["claim"])
        for key, x, title, rows, accent in [
            ("success", MARGIN, "성공 흐름", page["success"], LIME),
            ("failure", 428, "실패 흐름", page["failure"], CRIMSON),
        ]:
            self.c.setFillColor(white)
            self.c.setStrokeColor(accent)
            self.c.roundRect(x, 177, 380, 237, 12, fill=1, stroke=1)
            self.draw_asset_cover(key, x + 12, 281, 356, 119)
            self.c.setFillColor(accent)
            self.c.setFont("MalgunBold", 13)
            self.c.drawString(x + 14, 255, title)
            for index, row in enumerate(rows):
                self.c.setFillColor(INK)
                self.c.setFont("Malgun", 8.8)
                self.c.drawString(x + 17, 232 - index * 18, f"• {row}")
        self.c.setFillColor(NAVY)
        self.c.roundRect(MARGIN, 104, PAGE_W - 2 * MARGIN, 49, 8, fill=1, stroke=0)
        self.c.setFillColor(white)
        self.c.setFont("MalgunBold", 9.6)
        self.c.drawString(MARGIN + 14, 134, page["retry"])
        self.c.setFillColor(GOLD)
        self.c.drawString(MARGIN + 14, 116, page["edit"])
        self.c.setFillColor(MUTED)
        self.c.setFont("Malgun", 8)
        self.c.drawCentredString(PAGE_W / 2, 70, page["note"])
        self.footer()

    def draw_content(self, page: dict) -> None:
        y = self.header(page["eyebrow"], page["title"], page["claim"])
        headers = ["콘텐츠", "새로 묻는 질문", "플레이어가 배우는 것", "다음에 남는 판단"]
        widths = [70, 166, 220, PAGE_W - 2 * MARGIN - 456]
        self.c.setFillColor(NAVY)
        self.c.rect(MARGIN, y - 29, sum(widths), 29, fill=1, stroke=0)
        cursor = MARGIN
        self.c.setFillColor(white)
        self.c.setFont("MalgunBold", 7.5)
        for heading, width in zip(headers, widths):
            self.c.drawString(cursor + 6, y - 18, heading)
            cursor += width
        row_h, callout_y = content_table_layout(len(page["rows"]))
        row_y = y - 29
        for index, row in enumerate(page["rows"]):
            self.c.setFillColor(white if index % 2 == 0 else PAPER_2)
            self.c.rect(MARGIN, row_y - row_h, sum(widths), row_h, fill=1, stroke=0)
            cursor = MARGIN
            for col, (text, width) in enumerate(zip(row, widths)):
                self.c.setStrokeColor(HexColor("#DDCFBC"))
                self.c.rect(cursor, row_y - row_h, width, row_h, fill=0, stroke=1)
                self.draw_wrapped(text, cursor + 6, row_y - 13, width - 12, 9.3, INK if col == 0 else MUTED, "MalgunBold" if col == 0 else "Malgun", 7.4, 4)
                cursor += width
            row_y -= row_h
        self.c.setFillColor(HexColor("#F8E4E0"))
        self.c.setStrokeColor(CRIMSON)
        self.c.roundRect(MARGIN, callout_y, PAGE_W - 2 * MARGIN, 48, 8, fill=1, stroke=1)
        self.c.setFillColor(CRIMSON)
        self.c.setFont("MalgunBold", 8.8)
        self.draw_wrapped(page["footer"], MARGIN + 14, callout_y + 28, PAGE_W - 2 * MARGIN - 28, 11, CRIMSON, "MalgunBold", 8.8, 3)
        self.footer()

    def draw_visual(self, page: dict) -> None:
        y = self.header(page["eyebrow"], page["title"], page["claim"])
        self.draw_asset_cover("hgb_rail_station", MARGIN, 125, 368, 267)
        self.c.setStrokeColor(GOLD)
        self.c.setLineWidth(1.4)
        self.c.roundRect(MARGIN, 125, 368, 267, 10, fill=0, stroke=1)
        x = 430
        self.c.setFillColor(INK)
        self.c.setFont("MalgunBold", 12.5)
        self.c.drawString(x, y - 12, "Visual North Star")
        for index, line in enumerate(page["north_star"]):
            self.c.setFillColor([GOLD, SKY, LIME, VIOLET, DARK][index])
            self.c.circle(x + 8, y - 42 - index * 43, 7, fill=1, stroke=0)
            self.draw_wrapped(line, x + 23, y - 38 - index * 43, 320, 10, INK, "Malgun", 8.6, 2)
        asset_y = 84
        for index, asset in enumerate(["terrain_v02", "hgb_title", "hgb_build", "hgb_run"]):
            self.draw_asset_cover(asset, MARGIN + index * 187, asset_y, 176, 29)
        self.c.setFillColor(MUTED)
        self.c.setFont("Malgun", 7.6)
        self.draw_wrapped(page["boundary"], MARGIN, 56, PAGE_W - 2 * MARGIN, 10, MUTED, "Malgun", 7.6, 2)
        self.footer()

    def draw_wireframes(self, page: dict) -> None:
        y = self.header(page["eyebrow"], page["title"], page["claim"])
        card_w = (PAGE_W - 2 * MARGIN - 24) / 3
        card_h = 140
        accents = [SKY, VIOLET, GOLD, LIME, SKY, CRIMSON]
        for index, card in enumerate(page["cards"]):
            screen_id, title, attention, information, action = card
            row, col = divmod(index, 3)
            x = MARGIN + col * (card_w + 12)
            card_y = y - 160 - row * 162
            accent = accents[index % len(accents)]
            self.c.setFillColor(white)
            self.c.setStrokeColor(accent)
            self.c.setLineWidth(1.1)
            self.c.roundRect(x, card_y, card_w, card_h, 8, fill=1, stroke=1)
            self.c.setFillColor(NAVY)
            self.c.roundRect(x + 1, card_y + card_h - 30, card_w - 2, 29, 7, fill=1, stroke=0)
            self.c.setFillColor(white)
            self.c.setFont("MalgunBold", 7.2)
            self.c.drawString(x + 10, card_y + card_h - 19, screen_id)
            self.c.setFont("MalgunBold", 10.4)
            self.c.drawRightString(x + card_w - 10, card_y + card_h - 19, title)
            self.c.setFillColor(accent)
            self.c.setFont("MalgunBold", 7.1)
            self.c.drawString(x + 11, card_y + card_h - 49, "첫 시선")
            self.draw_wrapped(attention, x + 11, card_y + card_h - 63, card_w - 22, 10, INK, "MalgunBold", 8.1, 2)
            self.c.setFillColor(MUTED)
            self.c.setFont("MalgunBold", 7.1)
            self.c.drawString(x + 11, card_y + 47, "읽을 정보")
            self.draw_wrapped(information, x + 11, card_y + 33, card_w - 22, 9.2, MUTED, "Malgun", 7.5, 2)
            self.c.setFillColor(accent)
            self.c.roundRect(x + 9, card_y + 8, card_w - 18, 18, 5, fill=1, stroke=0)
            self.c.setFillColor(white)
            self.c.setFont("MalgunBold", 7.1)
            self.c.drawCentredString(x + card_w / 2, card_y + 14, action)
        self.footer()

    def draw_run_state(self, page: dict) -> None:
        y = self.header(page["eyebrow"], page["title"], page["claim"])
        state_w = (PAGE_W - 2 * MARGIN - 24) / 3
        state_h = 114
        accents = [CRIMSON, SKY, VIOLET, GOLD, SKY, DARK]
        positions: list[tuple[float, float]] = []
        for index, state in enumerate(page["states"]):
            state_id, title, trigger, player_read, next_state = state
            row, col = divmod(index, 3)
            x = MARGIN + col * (state_w + 12)
            state_y = y - 149 - row * 152
            positions.append((x, state_y))
            accent = accents[index % len(accents)]
            self.c.setFillColor(white)
            self.c.setStrokeColor(accent)
            self.c.setLineWidth(1.1)
            self.c.roundRect(x, state_y, state_w, state_h, 8, fill=1, stroke=1)
            self.c.setFillColor(accent)
            self.c.roundRect(x + 10, state_y + state_h - 25, 74, 14, 6, fill=1, stroke=0)
            self.c.setFillColor(white)
            self.c.setFont("MalgunBold", 6.5)
            self.c.drawCentredString(x + 47, state_y + state_h - 20, state_id)
            self.c.setFillColor(INK)
            self.c.setFont("MalgunBold", 10)
            self.c.drawString(x + 10, state_y + state_h - 44, title)
            self.c.setFillColor(MUTED)
            self.c.setFont("Malgun", 7.2)
            self.draw_wrapped(f"진입: {trigger}", x + 10, state_y + state_h - 61, state_w - 20, 8.8, MUTED, "Malgun", 7.2, 2)
            self.draw_wrapped(f"판독: {player_read}", x + 10, state_y + 30, state_w - 20, 8.8, MUTED, "Malgun", 7.2, 2)
            self.c.setFillColor(accent)
            self.c.setFont("MalgunBold", 7.2)
            self.c.drawRightString(x + state_w - 10, state_y + 12, f"다음: {next_state}")
        self.c.setStrokeColor(NAVY)
        self.c.setLineWidth(1.2)
        for origin_index, _destination_index in run_state_connector_pairs(len(positions)):
            x, state_y = positions[origin_index]
            self.c.line(x + state_w, state_y + state_h / 2, x + state_w + 9, state_y + state_h / 2)
        self.c.setFillColor(NAVY)
        self.c.roundRect(MARGIN, 58, PAGE_W - 2 * MARGIN, 37, 8, fill=1, stroke=0)
        self.c.setFillColor(white)
        self.c.setFont("MalgunBold", 8.6)
        self.draw_wrapped(page["footer"], MARGIN + 14, 80, PAGE_W - 2 * MARGIN - 28, 10.5, white, "MalgunBold", 8.6, 2)
        self.footer()

    def draw_asset_readiness(self, page: dict) -> None:
        y = self.header(page["eyebrow"], page["title"], page["claim"])
        headers = page["headers"]
        widths = [95, 175, 150, 145, PAGE_W - 2 * MARGIN - 565]
        x = MARGIN
        header_h = 29
        self.c.setFillColor(NAVY)
        self.c.rect(x, y - header_h, sum(widths), header_h, fill=1, stroke=0)
        cursor = x
        self.c.setFillColor(white)
        self.c.setFont("MalgunBold", 7.1)
        for heading, width in zip(headers, widths):
            self.c.drawString(cursor + 6, y - 18, heading)
            cursor += width
        row_y = y - header_h
        for row_index, row in enumerate(page["rows"]):
            row_h = 48
            self.c.setFillColor(white if row_index % 2 == 0 else PAPER_2)
            self.c.rect(x, row_y - row_h, sum(widths), row_h, fill=1, stroke=0)
            cursor = x
            for col_index, (text, width) in enumerate(zip(row, widths)):
                self.c.setStrokeColor(HexColor("#DDCFBC"))
                self.c.rect(cursor, row_y - row_h, width, row_h, fill=0, stroke=1)
                status = str(text)
                color = INK if col_index == 0 else MUTED
                if col_index == 2 and "PENDING" in status:
                    color = GOLD
                elif col_index == 2 and "APPROVED" in status:
                    color = LIME
                self.draw_wrapped(status, cursor + 6, row_y - 13, width - 12, 9.2, color, "MalgunBold" if col_index == 0 else "Malgun", 7.2, 4)
                cursor += width
            row_y -= row_h
        self.c.setFillColor(HexColor("#F8E4E0"))
        self.c.setStrokeColor(CRIMSON)
        self.c.roundRect(MARGIN, 55, PAGE_W - 2 * MARGIN, 48, 8, fill=1, stroke=1)
        self.c.setFillColor(CRIMSON)
        self.c.setFont("MalgunBold", 8.3)
        self.draw_wrapped(page["footer"], MARGIN + 14, 80, PAGE_W - 2 * MARGIN - 28, 10.5, CRIMSON, "MalgunBold", 8.3, 3)
        self.footer()

    def draw_review(self, page: dict) -> None:
        y = self.header(page["eyebrow"], page["title"], page["claim"])
        self.c.setFillColor(INK)
        self.c.setFont("MalgunBold", 13)
        self.c.drawString(MARGIN, y - 8, "사용자 검수 질문")
        for index, question in enumerate(page["questions"]):
            row_y = y - 43 - index * 42
            accent = [SKY, GOLD, LIME, VIOLET, CRIMSON, NAVY][index]
            self.c.setFillColor(white)
            self.c.setStrokeColor(accent)
            self.c.roundRect(MARGIN, row_y - 26, PAGE_W - 2 * MARGIN, 33, 7, fill=1, stroke=1)
            self.c.setFillColor(accent)
            self.c.circle(MARGIN + 17, row_y - 10, 10, fill=1, stroke=0)
            self.c.setFillColor(white)
            self.c.setFont("MalgunBold", 7)
            self.c.drawCentredString(MARGIN + 17, row_y - 13, str(index + 1))
            self.c.setFillColor(INK)
            self.c.setFont("Malgun", 8.7)
            self.c.drawString(MARGIN + 36, row_y - 13, question)
        x, table_y = MARGIN, 159
        self.c.setFillColor(NAVY)
        self.c.rect(x, table_y, PAGE_W - 2 * MARGIN, 25, fill=1, stroke=0)
        self.c.setFillColor(white)
        self.c.setFont("MalgunBold", 8)
        self.c.drawString(x + 10, table_y + 8, "상태")
        self.c.drawString(x + 245, table_y + 8, "현재 의미")
        for index, (status, meaning) in enumerate(page["status_rows"]):
            row_y = table_y - 27 - index * 27
            self.c.setFillColor(white if index % 2 == 0 else PAPER_2)
            self.c.rect(x, row_y, PAGE_W - 2 * MARGIN, 27, fill=1, stroke=0)
            self.c.setStrokeColor(HexColor("#DDCFBC"))
            self.c.rect(x, row_y, PAGE_W - 2 * MARGIN, 27, fill=0, stroke=1)
            self.c.line(x + 225, row_y, x + 225, row_y + 27)
            self.c.setFillColor(INK)
            self.c.setFont("MalgunBold", 6.8)
            self.c.drawString(x + 10, row_y + 9, status)
            self.c.setFillColor(MUTED)
            self.c.setFont("Malgun", 6.8)
            self.c.drawString(x + 240, row_y + 9, meaning)
        self.footer()

    def render_page(self, page: dict) -> None:
        self.page_index += 1
        renderers = {
            "cover": self.draw_cover,
            "vision": self.draw_vision,
            "positioning": self.draw_positioning,
            "experience": self.draw_experience,
            "flow": self.draw_flow,
            "journey_table": self.draw_journey_table,
            "atlas": self.draw_atlas,
            "scene_contract": self.draw_scene_contract,
            "lesson_curve": self.draw_lesson_curve,
            "board_layers": self.draw_board_layers,
            "build_board": self.draw_build_board,
            "lifo": self.draw_lifo,
            "station": self.draw_station,
            "auto": self.draw_auto,
            "switch": self.draw_switch,
            "capstone": self.draw_capstone,
            "result": self.draw_result,
            "content": self.draw_content,
            "visual": self.draw_visual,
            "wireframes": self.draw_wireframes,
            "run_state": self.draw_run_state,
            "asset_readiness": self.draw_asset_readiness,
            "review": self.draw_review,
        }
        try:
            renderer = renderers[page["kind"]]
        except KeyError as exc:
            raise ValueError(f"Unsupported page kind: {page['kind']}") from exc
        renderer(page)
        self.c.showPage()


def build(source: Path, output: Path, manifest: Path) -> dict:
    register_fonts()
    ensure_assets()
    data = load_data(source)
    output.parent.mkdir(parents=True, exist_ok=True)
    canvas = Canvas(str(output), pagesize=(PAGE_W, PAGE_H), pageCompression=1, invariant=1)
    canvas.setTitle("Switchy Express: Cargo Puzzle — Human Game Blueprint")
    canvas.setAuthor("Switchy Express project")
    canvas.setSubject("Human review blueprint; not runtime or user-play evidence")
    renderer = BlueprintRenderer(canvas, data)
    for page in data["pages"]:
        renderer.render_page(page)
    canvas.save()
    record = {
        "manifest_id": "SX-HGB-001-PUBLICATION",
        "blueprint_pair_id": data["pair_id"],
        "revision": data["revision"],
        "source_main": data["source_main"],
        "source": str(source.relative_to(ROOT)).replace("\\", "/"),
        "source_sha256": sha256(source),
        "generator": str(Path(__file__).relative_to(ROOT)).replace("\\", "/"),
        "output_pdf": str(output.relative_to(ROOT)).replace("\\", "/"),
        "output_sha256": sha256(output),
        "page_count": len(data["pages"]),
        "asset_inputs": {
            key: {
                "path": str(path.relative_to(ROOT)).replace("\\", "/"),
                "sha256": sha256(path),
                "use": (
                    "generated_document_visual_candidate_not_runtime_asset"
                    if key in DOCUMENT_CANDIDATE_KEYS
                    else "user_approved_planning_reference_not_runtime_capture"
                    if key in APPROVED_REFERENCE_KEYS
                    else "existing_runtime_asset_as_human_blueprint_visual_input"
                ),
            }
            for key, path in ASSETS.items()
        },
        "visual_status": "existing_runtime_assets_plus_user_approved_planning_reference_plus_generated_document_candidates; no_live_runtime_capture",
        "user_final_review": data.get("user_final_review", "AWAITING"),
        "implementation_authority": "BLOCKED",
    }
    manifest.parent.mkdir(parents=True, exist_ok=True)
    manifest.write_text(json.dumps(record, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return record


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", type=Path, default=DEFAULT_SOURCE)
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    parser.add_argument("--manifest", type=Path, default=DEFAULT_MANIFEST)
    args = parser.parse_args()
    record = build(args.source.resolve(), args.output.resolve(), args.manifest.resolve())
    print(json.dumps({key: record[key] for key in ("output_pdf", "output_sha256", "page_count", "user_final_review")}, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
