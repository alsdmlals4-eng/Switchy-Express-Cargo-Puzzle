"""Render every PDF page and make review sheets; never edits game artwork."""
import argparse
from pathlib import Path
import subprocess
from PIL import Image, ImageOps, ImageDraw


def render(pdf: Path, output: Path):
    output.mkdir(parents=True, exist_ok=True)
    if list(output.glob("page-*.png")):
        raise FileExistsError("Use a fresh review directory; stale pages must not mix.")
    subprocess.run(["pdftoppm", "-r", "72", "-png", str(pdf), str(output / "page")], check=True)
    pages = sorted(output.glob("page-*.png"), key=lambda p: int(p.stem.split("-")[-1]))
    if not pages:
        raise RuntimeError("No rendered pages")
    for start in range(0, len(pages), 12):
        sheet = Image.new("RGB", (1920, 900), "white")
        draw = ImageDraw.Draw(sheet)
        for offset, path in enumerate(pages[start:start+12]):
            with Image.open(path) as page:
                thumb = ImageOps.contain(page.convert("RGB"), (472, 272))
            x, y = (offset % 4) * 480, (offset // 4) * 300
            sheet.paste(thumb, (x, y+22))
            draw.text((x+8,y+4), path.stem, fill="black")
        sheet.save(output / f"contact-{start//12+1:02}.jpg", quality=92)
    print(f"RENDERED_PAGES={len(pages)} CONTACT_SHEETS={(len(pages)+11)//12}")


if __name__ == "__main__":
    parser=argparse.ArgumentParser()
    parser.add_argument("pdf",type=Path)
    parser.add_argument("output",type=Path)
    args=parser.parse_args()
    render(args.pdf,args.output)
