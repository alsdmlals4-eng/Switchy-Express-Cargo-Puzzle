# Human Game Blueprint r03 Publication Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Publish `SX-HGB-001 r03` as an implementation-aware, human-review blueprint and verified derived PDF without changing any Godot product byte or creating speculative runtime art.

**Architecture:** Keep `docs/design/SWITCHY_EXPRESS_HUMAN_GAME_BLUEPRINT.md` as the sole registered human-review owner. Extend its existing ReportLab renderer only with text-native flow, wireframe, RUN-state, and asset-readiness pages; the generated PDF and manifest remain derived publication evidence. The source is responsible for wording and structured page data, while `tools/build_human_game_blueprint.py` is responsible only for deterministic visual layout.

**Tech Stack:** Markdown + embedded JSON, Python 3 with ReportLab 4.4.9 and pypdf 6.14.2 from the Codex bundled runtime, Poppler `pdftoppm`, PowerShell, Git/GitHub Actions.

**Spec:** `docs/superpowers/specs/2026-09-01-human-game-blueprint-r03-design.md`

## Global Constraints

- `GMB-002`, T1–T6, `VS_DEMO_01`, Route Book stage IDs, score/progression boundary, and the authored caution multiplier `0.55` are unchanged.
- Do not modify GDScript, `.tscn`, map JSON, product runtime PNGs, Candidate 010 pointers, or asset approval states.
- Reuse `SX-TITLE-WORDMARK-001` at `art/product_assets/ed_hybrid_v2/shells/shell_title_wordmark_switchy_express_candidate_v01.png`; do not regenerate or alter its pixels.
- Keep Route Book 02 v02 image entries `GENERATED_CANDIDATE · RUNTIME_CONNECTED · USER_PIXEL_REVIEW_PENDING`; never represent them as canonical or user-approved pixels.
- Keep r02 document visuals as `DOCUMENT_VISUAL_NOT_RUNTIME_CAPTURE`; do not promote them to Godot assets.
- Keep human/device/audio/release evidence separate from Candidate 010 machine evidence. Five-person comprehension and player-experience studies remain `NOT_REQUIRED_BY_USER_VALIDATION_POLICY`.
- Use the bundled Python executable `C:\Users\user\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe`; do not install packages.
- Before the first PDF creation command, run the PDF artifact receipt command exactly once with `operation-kind create`, `expected-output-count 1`, and `output-format pdf`.
- Work only on `codex/blueprint-r03-20260901`, update the current Draft PR #279, and never modify PR #254 or Draft PR #174.

---

## File structure and responsibility

| Path | Responsibility | Change type |
|---|---|---|
| `tests/python/test_human_game_blueprint_r03_publication.py` | Enforces r03 metadata, the three new page kinds, title-wordmark provenance, deterministic temporary build, PDF page count, and generated-manifest truth. | Create |
| `tools/build_human_game_blueprint.py` | Renders only the text-native r03 page kinds and approved existing asset inputs. | Modify |
| `docs/design/SWITCHY_EXPRESS_HUMAN_GAME_BLUEPRINT.md` | Sole registered editorial source: r03 identity, flow, screen wireframes, RUN state map, asset readiness, and evidence language. | Modify |
| `docs/design/SWITCHY_EXPRESS_HUMAN_GAME_BLUEPRINT_PUBLICATION_MANIFEST.json` | SHA-bound record emitted by the renderer for the actual r03 source and final PDF. | Generated/modify |
| `output/pdf/switchy-express-cargo-puzzle_HUMAN_GAME_BLUEPRINT_20260901_r03.pdf` | Final derived human-review artifact; not a runtime asset. | Create |
| `docs/superpowers/specs/2026-09-01-human-game-blueprint-r03-design.md` | Changes from plan-ready to published only after all evidence and user PDF review are complete. | Modify at final close only |

## Task 1: Add the r03 publication contract test

**Files:**

- Create: `tests/python/test_human_game_blueprint_r03_publication.py`
- Read: `docs/superpowers/specs/2026-09-01-human-game-blueprint-r03-design.md`
- Read: `docs/design/SWITCHY_EXPRESS_HUMAN_GAME_BLUEPRINT.md`
- Read: `tools/build_human_game_blueprint.py`

**Interfaces:**

- Consumes: the `<!-- BLUEPRINT_DATA:START -->` JSON block parsed from the registered editorial source.
- Produces: a deterministic contract that expects revision `r03`, 23 pages, three new renderer page kinds, and a derived PDF that pypdf can reopen.

- [ ] **Step 1: Write the failing test file.**

```python
from __future__ import annotations

import hashlib
import importlib.util
import json
import re
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

from pypdf import PdfReader


ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / "docs/design/SWITCHY_EXPRESS_HUMAN_GAME_BLUEPRINT.md"
BUILDER = ROOT / "tools/build_human_game_blueprint.py"
WORKSPACE_PYTHON = Path(r"C:\Users\user\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe")


def blueprint_data() -> dict:
    text = SOURCE.read_text(encoding="utf-8")
    match = re.search(
        r"<!-- BLUEPRINT_DATA:START -->\s*```json\s*(.*?)\s*```\s*<!-- BLUEPRINT_DATA:END -->",
        text,
        re.DOTALL,
    )
    if match is None:
        raise AssertionError("BLUEPRINT_DATA block is missing")
    return json.loads(match.group(1))


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


class HumanGameBlueprintR03PublicationTests(unittest.TestCase):
    def test_builder_advertises_r03_page_renderers(self) -> None:
        source = BUILDER.read_text(encoding="utf-8")
        for kind, renderer in {
            "wireframes": "draw_wireframes",
            "run_state": "draw_run_state",
            "asset_readiness": "draw_asset_readiness",
        }.items():
            self.assertIn(f'"{kind}": self.{renderer}', source)
            self.assertIn(f"def {renderer}(self, page: dict) -> None:", source)
        self.assertIn('"title_wordmark"', source)

    def test_editorial_source_declares_r03_current_surfaces(self) -> None:
        data = blueprint_data()
        kinds = [page["kind"] for page in data["pages"]]
        self.assertEqual(data["revision"], "r03")
        self.assertEqual(data["date"], "2026-09-01")
        self.assertEqual(data["source_main"], "0bf5e2150d643210abf127e34880111ee986b29d")
        self.assertEqual(data["user_final_review"], "AWAITING_R03_CONTENT_AND_RENDER_REVIEW")
        self.assertEqual(len(data["pages"]), 23)
        self.assertEqual(kinds.count("wireframes"), 1)
        self.assertEqual(kinds.count("run_state"), 1)
        self.assertEqual(kinds.count("asset_readiness"), 1)
        text = SOURCE.read_text(encoding="utf-8")
        for token in ("Route Book 01/02", "TitleLogo", "DECELERATE", "ACCELERATE", "USER_PIXEL_REVIEW_PENDING"):
            self.assertIn(token, text)

    def test_bundled_runtime_builds_a_reopenable_r03_pdf_and_manifest(self) -> None:
        self.assertTrue(WORKSPACE_PYTHON.exists(), "bundled document runtime is required")
        with tempfile.TemporaryDirectory() as raw_temp:
            temp = Path(raw_temp)
            output = temp / "r03.pdf"
            manifest_path = temp / "r03-manifest.json"
            subprocess.run(
                [
                    str(WORKSPACE_PYTHON), str(BUILDER),
                    "--source", str(SOURCE),
                    "--output", str(output),
                    "--manifest", str(manifest_path),
                ],
                cwd=ROOT,
                check=True,
                text=True,
                capture_output=True,
            )
            manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
            self.assertEqual(len(PdfReader(str(output)).pages), 23)
            self.assertEqual(manifest["revision"], "r03")
            self.assertEqual(manifest["page_count"], 23)
            self.assertEqual(manifest["output_sha256"], sha256(output))
            self.assertEqual(
                manifest["asset_inputs"]["title_wordmark"]["use"],
                "existing_runtime_asset_as_human_blueprint_visual_input",
            )


if __name__ == "__main__":
    unittest.main()
```

- [ ] **Step 2: Run the test before r03 implementation.**

Run:

```powershell
$workspacePython = 'C:\Users\user\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe'
& $workspacePython tests/python/test_human_game_blueprint_r03_publication.py
```

Expected: `FAIL`, because the source is still r02 and the builder does not yet expose `wireframes`, `run_state`, `asset_readiness`, or `title_wordmark`.

- [ ] **Step 3: Commit the red test only after preserving its failing evidence in the task log.**

```powershell
git add -- tests/python/test_human_game_blueprint_r03_publication.py
git commit -m "test: define human blueprint r03 publication contract"
```

## Task 2: Extend the deterministic PDF renderer for r03 text-native diagrams

**Files:**

- Modify: `tools/build_human_game_blueprint.py:25-69` — add the approved existing title-wordmark asset input.
- Modify: `tools/build_human_game_blueprint.py:267-315` — place the title wordmark on a light document plaque without altering its pixels.
- Modify: `tools/build_human_game_blueprint.py:900-984` — add the three new renderer methods and register them in `render_page`.
- Test: `tests/python/test_human_game_blueprint_r03_publication.py`

**Interfaces:**

- Consumes: page dictionaries of `kind: wireframes`, `kind: run_state`, and `kind: asset_readiness` from `BLUEPRINT_DATA`.
- Produces: three ReportLab page renderers with the exact signatures `draw_wireframes(self, page: dict) -> None`, `draw_run_state(self, page: dict) -> None`, and `draw_asset_readiness(self, page: dict) -> None`.
- Must not consume an image path that is not already listed in `ASSETS`.

- [ ] **Step 1: Add the sole new document input key to `ASSETS`.**

Add this entry directly after the existing `title` asset:

```python
"title_wordmark": ROOT / "art/product_assets/ed_hybrid_v2/shells/shell_title_wordmark_switchy_express_candidate_v01.png",
```

Do not add it to `DOCUMENT_CANDIDATE_KEYS` or `APPROVED_REFERENCE_KEYS`; the existing manifest record will therefore classify it as `existing_runtime_asset_as_human_blueprint_visual_input`.

- [ ] **Step 2: Make the cover use the approved wordmark without turning it into text baked into an image.**

Immediately after the dark left-side overlay in `draw_cover`, draw a `PAPER` plaque and contain the existing transparent title asset inside it:

```python
self.c.setFillColor(PAPER)
self.c.roundRect(MARGIN, PAGE_H - 173, 405, 72, 10, fill=1, stroke=0)
self.draw_asset_contain("title_wordmark", MARGIN + 18, PAGE_H - 163, 369, 52)
```

Move the existing textual title baseline below that plaque so the wordmark is not obscured. Keep the status and subtitle as live PDF text, and keep the r02 document visual only as the full-cover atmosphere reference.

- [ ] **Step 3: Add the three renderer methods using page-owned data only.**

Add these exact data contracts and rendering rules before `render_page`:

```python
def draw_wireframes(self, page: dict) -> None:
    # page["cards"]: [["ID", "title", "first_attention", "information", "action"], ...]
    # Render six equal cards in a 3-by-2 grid. Each card has a navy top bar,
    # a muted information row, and an accent action footer. Do not draw a raster image.

def draw_run_state(self, page: dict) -> None:
    # page["states"]: [["ID", "title", "trigger", "player_read", "next"], ...]
    # Render a left-to-right state rail with explicit arrows and a bounded
    # footer that says presentation remains renderer-local and reduced-motion safe.

def draw_asset_readiness(self, page: dict) -> None:
    # page["headers"], page["rows"], page["footer"]
    # Render a five-column table and paint only source-state labels; never
    # imply that a candidate input is a promoted product asset.
```

For every method, call `self.header(...)` first and `self.footer()` last. Reuse `self.card`, `self.draw_wrapped`, and existing colour constants. Reject missing expected page keys by allowing the natural `KeyError`; do not create fallback content or a silent generic page.

- [ ] **Step 4: Register exactly these page kinds in `render_page`.**

```python
"wireframes": self.draw_wireframes,
"run_state": self.draw_run_state,
"asset_readiness": self.draw_asset_readiness,
```

- [ ] **Step 5: Run only the renderer-surface assertion.**

Run:

```powershell
$workspacePython = 'C:\Users\user\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe'
& $workspacePython -m unittest tests.python.test_human_game_blueprint_r03_publication.HumanGameBlueprintR03PublicationTests.test_builder_advertises_r03_page_renderers
```

Expected: `PASS`. The editorial-source and temporary-PDF tests still fail until Task 3 updates r02 data.

- [ ] **Step 6: Commit the renderer-only change.**

```powershell
git add -- tools/build_human_game_blueprint.py
git commit -m "feat: render human blueprint r03 diagrams"
```

## Task 3: Author the registered r03 editorial source

**Files:**

- Modify: `docs/design/SWITCHY_EXPRESS_HUMAN_GAME_BLUEPRINT.md:1-40` — r03 identity and current authority/evidence language.
- Modify: `docs/design/SWITCHY_EXPRESS_HUMAN_GAME_BLUEPRINT.md:43-330` — `BLUEPRINT_DATA` revision, exact current surface flow, and three added page objects.
- Modify: `docs/design/SWITCHY_EXPRESS_HUMAN_GAME_BLUEPRINT.md:333-360` — r03 review record with no runtime-promotion claim.
- Test: `tests/python/test_human_game_blueprint_r03_publication.py`

**Interfaces:**

- Consumes: `render_page` page-kind mapping from Task 2 and actual scene/asset identifiers from the r03 design spec.
- Produces: a valid 23-page `BLUEPRINT_DATA` payload that the existing `load_data()` function can parse.

- [ ] **Step 1: Update editorial identity and publication metadata.**

Set the Markdown header and the embedded JSON root to these exact values:

```yaml
revision: r03
date: 2026-09-01
source_main: 0bf5e2150d643210abf127e34880111ee986b29d
output_pdf: output/pdf/switchy-express-cargo-puzzle_HUMAN_GAME_BLUEPRINT_20260901_r03.pdf
user_final_review: AWAITING_R03_CONTENT_AND_RENDER_REVIEW
implementation_authority: BLOCKED
```

Update the authority bullets to name `SX-DEC-067`, `SX-DEC-068`, `SX-DEC-069`, `art/product_assets/ed_hybrid_v2/manifest.json`, and `TARGET_BUILD_SCREEN_SURFACE_AND_VISUAL_COVERAGE.md`. Preserve the sentence that the PDF is not a runtime capture or a human/device/release PASS.

- [ ] **Step 2: Replace the old eight-node flow data with the current flow contract.**

Keep the existing `kind: "flow"` renderer, but set its eight `nodes` in this exact order:

```json
[
  ["1", "제목", "첫 세션·Stage Book", "BRIGHT"],
  ["2", "Route Book", "01/02 또는 고정 stage", "VIOLET"],
  ["3", "브리핑", "이번 판단 한 가지", "VIOLET"],
  ["4", "BUILD", "선로·조우 순서 설계", "GOLD"],
  ["5", "사전검사", "실패는 BUILD에 남김", "CRIMSON"],
  ["6", "RUN", "TOP·Auto·시간·현재 행로", "BLUE"],
  ["7", "경로/의미 이벤트", "선택·잠금·적재·속도 변화", "LIME"],
  ["8", "결과", "Retry·Edit·제목·다음 stage", "DARK"]
]
```

Set the three `branches` to distinguish `성공 → Result → 다음 스테이지 또는 제목`, `실패 → Result → Retry(같은 배치) 또는 Edit(BUILD)`, and `Pause / Exit 확인 → RUN 계속 또는 제목`. Do not imply that Retry opens BUILD or that Edit keeps the sealed run layout.

- [ ] **Step 3: Insert the three r03 page objects after the existing `scene_contract` page.**

Use these exact page kinds and minimum data:

```json
{
  "kind": "wireframes",
  "eyebrow": "CURRENT SCREEN WIREFRAMES",
  "title": "화면은 무엇을 먼저 보여 주고 어떤 행동을 받는가",
  "claim": "와이어프레임은 실제 Godot 화면의 정보·행동 계약이며 런타임 캡처가 아니다.",
  "cards": [
    ["SX-SCR-001", "제목", "wordmark와 Start", "Stage Book·Controls·Quit", "첫 세션 또는 선택형 Route Book"],
    ["SX-SCR-RB", "Route Book", "book/stage 카드", "이름과 하나의 판단", "고정 스테이지 선택"],
    ["SX-SCR-003", "브리핑", "목표와 한 규칙", "LessonArt·Objective·Rules", "BUILD 시작"],
    ["SX-SCR-004", "BUILD", "보드와 사전검사", "buildable·blocked·cargo·station", "유효한 RUN 경로 설계"],
    ["SX-SCR-006", "RUN", "열차·TOP·현재 행로", "Manual/Auto·시간·분기 상태", "적재·보류·분기 실행"],
    ["SX-SCR-010/011", "결과", "성공/실패 사실", "원인과 다음 선택", "Retry·Edit·Title·Next"]
  ]
}
```

Add a `run_state` page containing the ordered states `BUILD_FAIL`, `RUN_NORMAL`, `ROUTE_CHOICE`, `CAUTION_DECELERATE`, `NORMAL_ACCELERATE`, and `RESULT`. Its state descriptions must say that caution uses the existing `0.55` departure multiplier, `DECELERATE` is amber inward braking, `ACCELERATE` is cyan forward recovery, consecutive caution cells do not repeat the cue, and reduced-motion is static/bounded.

Add an `asset_readiness` page with headers `표면`, `실제 소비처`, `상태`, `r03 사용`, `새 이미지 조치`. Its required rows are title wordmark, title/briefing/result shell art, board renderer assets, Godot/procedural status layers, Route Book 02 v02 candidates, and r02 document visuals. The final column is `재사용만`, `새 비트맵 없음`, or `실제 빈 슬롯 검증 후 후보 1개` as appropriate.

- [ ] **Step 4: Update the review record and all stale r02 strings.**

Change the review record to `revision: r03`, state that r02 document candidates are preserved references, and add these excluded scopes verbatim:

```yaml
- runtime_asset_promotion
- runtime_scene_or_code_change
- candidate_010_evidence_reinterpretation
- v02_wayside_pixel_approval
```

Use `rg -n "r02|28619f4|20260830_r02|final user review" docs/design/SWITCHY_EXPRESS_HUMAN_GAME_BLUEPRINT.md` to classify each remaining occurrence. Retain historical r02 provenance only where it is explicitly labelled history; correct every current identity/reference occurrence.

- [ ] **Step 5: Run the static source and renderer contract tests.**

Run:

```powershell
$workspacePython = 'C:\Users\user\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe'
& $workspacePython -m unittest tests.python.test_human_game_blueprint_r03_publication.HumanGameBlueprintR03PublicationTests.test_builder_advertises_r03_page_renderers
& $workspacePython -m unittest tests.python.test_human_game_blueprint_r03_publication.HumanGameBlueprintR03PublicationTests.test_editorial_source_declares_r03_current_surfaces
```

Expected: both `PASS`. Do not run the PDF-producing test until Task 4 has recorded the required PDF artifact operation receipt.

- [ ] **Step 6: Commit source and data changes.**

```powershell
git add -- docs/design/SWITCHY_EXPRESS_HUMAN_GAME_BLUEPRINT.md
git commit -m "docs: author human game blueprint r03"
```

## Task 4: Generate, inspect, and bind the r03 PDF and manifest

**Files:**

- Modify/generated: `docs/design/SWITCHY_EXPRESS_HUMAN_GAME_BLUEPRINT_PUBLICATION_MANIFEST.json`
- Create: `output/pdf/switchy-express-cargo-puzzle_HUMAN_GAME_BLUEPRINT_20260901_r03.pdf`
- Test: `tests/python/test_human_game_blueprint_r03_publication.py`
- Temporary only: `tmp/pdfs/sx-hgb-001-r03-render/`

**Interfaces:**

- Consumes: r03 source/renderer from Tasks 2–3 and all existing `ASSETS` paths.
- Produces: one deterministic PDF, one manifest with exact hashes/page count, and rendered temporary PNGs for visual review.

- [ ] **Step 1: Record the required PDF create operation immediately before the first PDF-producing command.**

```powershell
$workspaceNode = 'C:\Users\user\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe'
$artifactReceipt = 'C:\Users\user\.codex\plugins\cache\openai-primary-runtime\pdf\26.826.12353\skills\pdf\container_tools\mark_artifact_operation_started.mjs'
& $workspaceNode $artifactReceipt --operation-kind create --expected-output-count 1 --output-format pdf
```

Expected: successful receipt. Run this command exactly once for the r03 publication operation.

- [ ] **Step 2: Run the complete r03 test file using the bundled runtime.**

Run:

```powershell
$workspacePython = 'C:\Users\user\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe'
& $workspacePython tests/python/test_human_game_blueprint_r03_publication.py
```

Expected: `PASS`, including its temporary build/reopen/hash checks.

- [ ] **Step 3: Generate the final PDF and its source-bound manifest.**

```powershell
$workspacePython = 'C:\Users\user\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe'
& $workspacePython tools/build_human_game_blueprint.py `
  --source docs/design/SWITCHY_EXPRESS_HUMAN_GAME_BLUEPRINT.md `
  --output output/pdf/switchy-express-cargo-puzzle_HUMAN_GAME_BLUEPRINT_20260901_r03.pdf `
  --manifest docs/design/SWITCHY_EXPRESS_HUMAN_GAME_BLUEPRINT_PUBLICATION_MANIFEST.json
```

Expected: JSON output with the r03 path, SHA-256, 23 pages, and `AWAITING_R03_CONTENT_AND_RENDER_REVIEW`.

- [ ] **Step 4: Validate the generated manifest and render all pages for visual inspection.**

```powershell
$workspacePython = 'C:\Users\user\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe'
$poppler = 'C:\Users\user\.cache\codex-runtimes\codex-primary-runtime\dependencies\native\poppler\Library\bin\pdftoppm.exe'
$pdf = 'output/pdf/switchy-express-cargo-puzzle_HUMAN_GAME_BLUEPRINT_20260901_r03.pdf'
$renderDir = 'tmp/pdfs/sx-hgb-001-r03-render'
New-Item -ItemType Directory -Force -Path $renderDir | Out-Null
& $workspacePython -c "import json; from pathlib import Path; from pypdf import PdfReader; m=json.loads(Path('docs/design/SWITCHY_EXPRESS_HUMAN_GAME_BLUEPRINT_PUBLICATION_MANIFEST.json').read_text(encoding='utf-8')); assert m['revision']=='r03'; assert m['page_count']==23; assert len(PdfReader('$pdf').pages)==23; print('r03 manifest and PDF structure: PASS')"
& $poppler -png -r 150 $pdf (Join-Path $renderDir 'page')
```

Inspect all rendered pages. At minimum, inspect the cover, flow, wireframes, RUN-state, asset-readiness, and user-review pages at full size. Reject and correct any clipped Korean glyph, black transparency box, wordmark contrast failure, table overflow, missing footer/page number, or unlabelled candidate state. If any page fails, return to Tasks 2 or 3, regenerate the PDF and manifest, and rerender the entire page set before continuing.

- [ ] **Step 5: Remove only the exact verified temporary render directory after visual review.**

```powershell
$renderDir = (Resolve-Path 'tmp/pdfs/sx-hgb-001-r03-render').Path
$tmpRoot = (Resolve-Path 'tmp/pdfs').Path
if (-not $renderDir.StartsWith($tmpRoot, [System.StringComparison]::OrdinalIgnoreCase)) { throw 'Refusing to remove a path outside tmp/pdfs.' }
Remove-Item -LiteralPath $renderDir -Recurse -Force
```

- [ ] **Step 6: Commit the manifest and final PDF.**

```powershell
git add -- docs/design/SWITCHY_EXPRESS_HUMAN_GAME_BLUEPRINT_PUBLICATION_MANIFEST.json output/pdf/switchy-express-cargo-puzzle_HUMAN_GAME_BLUEPRINT_20260901_r03.pdf
git commit -m "docs: publish human game blueprint r03"
```

## Task 5: Complete adversarial review, update Draft PR #279, and preserve the final user-review gate

**Files:**

- Modify: `docs/superpowers/specs/2026-09-01-human-game-blueprint-r03-design.md` only after every check below is green.
- Modify: current Draft PR #279 through normal push; do not touch unrelated PRs.

**Interfaces:**

- Consumes: exact branch head from Task 4, generated manifest/PDF evidence, local source/renderer tests, and project contract results.
- Produces: a review-ready Draft PR and a truthful remaining gate: `USER_PDF_REVIEW_REQUIRED`.

- [ ] **Step 1: Perform five full-scope adversarial review loops and correct every in-scope finding.**

| Loop | Attack | Required exit condition |
|---|---|---|
| 1 | Scope drift | Diff has no `.gd`, `.tscn`, map, product runtime PNG, candidate pointer, or decision-rule change. |
| 2 | Consumer/flow drift | Every current r03 screen label maps to `vertical_slice_demo.tscn` or `demo_flow_controller.gd`; Retry and Edit retain their distinct destinations. |
| 3 | Asset/provenance drift | Wordmark stays existing approved input; v02 remains candidate/pixel-pending; r02 visuals stay document-only. |
| 4 | Visual/readability drift | All 23 rendered pages have readable Korean text, visible wordmark contrast, uncut tables, and correct header/footer/page numbers. |
| 5 | Evidence inflation | Source, manifest, PR body, and report all say machine/document rendering only; human/device/audio/release remain unrun and r03 PDF acceptance remains user review. |

- [ ] **Step 2: Run the local document and project checks at the final exact HEAD.**

```powershell
$workspacePython = 'C:\Users\user\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe'
git diff --check origin/main...HEAD
python tools/validate_project_contract.py
& $workspacePython tests/python/test_human_game_blueprint_r03_publication.py
& $workspacePython tests/python/test_base_operating_adaptation.py
git status --short --branch
```

Expected: all checks pass and the worktree is clean after commits. Any missing dependency or nonzero check is a blocker, not a PASS.

- [ ] **Step 3: Update the r03 design source only with completed machine/document evidence.**

Change the design status to `PDF_RENDERED_AND_MACHINE_VERIFIED · USER_PDF_REVIEW_REQUIRED`, link the final PDF/manifest, and state that the only immediate remaining gate is user visual review of the exact r03 PDF. Do not mark `USER_APPROVED`, `RUNTIME_VERIFIED`, or `RELEASE_READY`.

- [ ] **Step 4: Commit the closeout evidence, then push the current branch.**

```powershell
git add -- docs/superpowers/specs/2026-09-01-human-game-blueprint-r03-design.md
git commit -m "docs: record blueprint r03 publication evidence"
git push origin codex/blueprint-r03-20260901
git fetch --prune origin
git rev-parse HEAD
git rev-parse origin/codex/blueprint-r03-20260901
```

Expected: both SHA values are identical.

- [ ] **Step 5: Read back Draft PR #279 at its exact head.**

```powershell
gh pr view 279 --json number,isDraft,headRefOid,baseRefOid,statusCheckRollup,reviewDecision,url
```

Wait for exact-head required checks. Keep the PR Draft and do not merge until the user reviews the generated r03 PDF. If `origin/main` advances before final merge, reconcile by fast-forward/rebase only through a newly approved, exact-head review cycle; never force-push or bypass rules.

## Coverage review

| Spec requirement | Plan task |
|---|---|
| Reuse one registered blueprint instead of making a duplicate document | Task 3 |
| Current flow map and editable wireframes | Tasks 2–3 |
| Actual title wordmark reuse and no speculative runtime art | Tasks 2–3 |
| RUN caution/recovery state distinction and reduced-motion boundary | Task 3 |
| Derived PDF plus provenance-bound manifest | Task 4 |
| Machine/document evidence separate from human/release acceptance | Tasks 3–5 |
| Five adversarial loops and exact-head Git readback | Task 5 |

## Self-review

- **Spec coverage:** Every surface, current asset state, r03 publication artifact, validation boundary, and user-review gate in `SX-HGB-001-R03-DESIGN` maps to a named task above.
- **Deferred-work scan:** No step leaves an unnamed future action or an unspecified implementation/test instruction. The exact path, status vocabulary, renderer methods, page kinds, test assertions, build runtime, and cleanup target are named.
- **Type consistency:** The three page kinds, renderer method names, test expectations, embedded JSON values, output path, and manifest keys use the same spelling throughout this plan.

## Execution handoff

Plan complete and saved to `docs/superpowers/plans/2026-09-01-human-game-blueprint-r03-publication.md`.

1. **Inline Execution (recommended)** — execute Tasks 1–5 in this session with exact checkpoints, preserving the user PDF-review gate before merge.
2. **Task-split execution** — use a fresh worker per task with independent review. This is available only if the user explicitly asks for delegation; the current collaboration policy does not start workers automatically.
