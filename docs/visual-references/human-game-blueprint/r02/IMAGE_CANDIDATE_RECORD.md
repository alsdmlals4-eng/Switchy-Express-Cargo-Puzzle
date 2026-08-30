# SX-HGB r02 · generated visual candidate record

> **Status:** `USER_APPROVED_DOCUMENT_VISUAL · CANON_REGISTERED_FOR_HGB_R02 · NOT_RUNTIME_ASSET`
>
> **Consumer:** `tools/build_human_game_blueprint.py` → `output/pdf/switchy-express-cargo-puzzle_HUMAN_GAME_BLUEPRINT_20260830_r02.pdf`
>
> **Approval reference:** 2026-08-30 current user instruction — the existing bare grid and tiny rail/station sprites are not usable for the main screen, core scenes, or flow map; create new rail and station imagery.

> **User approval:** 2026-08-30 current user message — `승인할게`.

## Requirement and boundary

`SX-HGB-VIS-RQ-001` is a temporary document-visual requirement under the current user request. Its purpose is to make the human game blueprint readable as a polished visual review artifact without implying that the images are final Godot art.

- **Mode:** `planning-visualization` + `intermediate-visual-checkpoint`
- **Project canon held:** `SX-DEC-062`, `SX-DEC-063`, rectangular authoritative grid, warm miniature-diorama material language, navy control-deck framing, lime=current/valid path, violet=tutorial focus, crimson=invalid/lock.
- **Protected rules:** finite handcrafted puzzle; cargo pickup remains exact-cell; stations remain off-track and use cardinal-adjacent service; direct two-exit switch control; no solver implication; all localized game copy remains structured text outside image pixels.
- **Excluded from this delivery:** runtime consumer registration, Godot scene or script change, sprite atlas adoption, user approval of final product assets, runtime/physical/player-experience evidence.
- **Existing-solution disposition:** `REUSE + EXTEND`. Reuse the user-approved six-panel system exploration (`SX-VIS-061...002B`) for the flow map. Extend with four newly generated PDF-only candidates where no equivalent main/BUILD/RUN/rail-station visual existed.

## 2026-08-30 current-rule prevalidation receipt

- **Fresh owner and consumer readback:** current `ACTIVE_CONTEXT.md` identifies `SX-DEC-063` and `SX-DEC-064` as the active visual context. `ProductBoardRenderer` consumes only the existing terrain, station, marker, and procedural route paths. The candidate filenames occur only in this record, the HGB source/manifest, and the HGB PDF generator; no Godot runtime consumer was added.
- **Primary-source / current external research:** `NOT_MATERIAL`. This is not a market, platform, engine, or product-rule decision; the user requested original document visuals and no external visual source was adopted. Project-owned SX-DEC-062/063/064 and the checked runtime paths are the material authority.
- **Actual-consumer feasibility:** `PASS_FOR_DOCUMENT_USE`. `tools/build_human_game_blueprint.py` loads the candidates from this folder, and the resulting A4 PDF rendered all 20 pages. `NOT_APPLICABLE_FOR_RUNTIME`: no `.tscn`, `.gd`, product asset manifest, import path, or release package consumer exists for these candidates.

## Five-pass adversarial review and correction

| Loop | Attack | Evidence and result | Correction / disposition |
| --- | --- | --- | --- |
| 1 · Consumer / authorization | Could a document image be mistaken for a promoted game asset? | Candidate paths are outside `art/product_assets`; current `runtime_visual_manifest.json` and `ProductBoardRenderer` do not name them. | Kept a direct PDF-only consumer, added visible candidate/runtime disclaimers, and retained `NOT_RUNTIME_ASSET`. **PASS for boundary.** |
| 2 · Scope / game semantics | Could the images silently change finite/LIFO/cardinal-service/direct-route rules? | The PDF’s editable copy remains the authority. RUN candidate is illustrative only; the separate cardinal-service page still states the exact one-tile rule. | Removed any claim that image geometry is implementation instruction; retained the existing explicit no-solver and off-track-station text. **PASS for document scope.** |
| 3 · Visual readability | Do hero, flow, BUILD, and RUN pages still have blank or clipped information regions? | First r02 render exposed shallow cards whose body text overflowed or vanished on Flow, BUILD, and Switch pages. | Rebuilt those compact-card layouts, re-rendered all 20 pages, and spot-checked cover, flow, atlas, BUILD, switch, and visual-language pages. **PASS after correction.** |
| 4 · Rights / provenance | Did the work import or imitate an external game/UI/asset pack? | No input image or external reference was supplied; prompts prohibited logos, copied IP, third-party UI skins, and in-image type. SHA-256 and prompts are recorded. | Kept outputs in review status and marked release/right-to-use approval as separate. **PASS for recorded document provenance; release approval remains NOT_APPROVED.** |
| 5 · Import / runtime / evidence | Could embedded PDF images be presented as Godot integration, runtime proof, or player validation? | PDF metadata, source, captions, manifest, and record state `no_live_runtime_capture`; no Godot asset import or runtime test was run because no runtime path changed. | Kept all runtime/device/human fields explicitly `NOT_RUN / NOT_APPLICABLE`; no runtime evidence is inferred from the render. **PASS for evidence ceiling.** |

## Candidate package

| ID | File | Document role | SHA-256 | State |
| --- | --- | --- | --- | --- |
| `SX-HGB-VIS-001` | `sx-hgb-vis-001-title-hero-candidate.png` | Cover / main hero with safe left title area | `1e2c018bc43d34dee396748b40435aa089d76a2f892eb22688983c708382a887` | `USER_APPROVED_DOCUMENT_VISUAL` |
| `SX-HGB-VIS-002` | `sx-hgb-vis-002-build-board-candidate.png` | BUILD board, placement, track, blocked station footprint | `17a55375b696176f7b2761fefe542c65eaacca2b8f6881af09337bc8aeb25fbe` | `USER_APPROVED_DOCUMENT_VISUAL` |
| `SX-HGB-VIS-003` | `sx-hgb-vis-003-run-switch-top-candidate.png` | RUN, TOP, direct switch, current route, occupied lock, cardinal service | `76d8758b57c05e3ccb21870c83abbe02e4e260051ddce33aa15610979edc8a41` | `USER_APPROVED_DOCUMENT_VISUAL` |
| `SX-HGB-VIS-004` | `sx-hgb-vis-004-rail-station-language-candidate.png` | Cohesive rail, switch, and off-track station language sheet | `c37839a6a30bf7a2a36eed09f8f8da463ea9bf3c89bffcd2550e29a1e0a505ea` | `USER_APPROVED_DOCUMENT_VISUAL` |

## Generation provenance

- **Generator:** built-in `image_gen` image model
- **Generation date:** 2026-08-30
- **Input images:** none; prompts were authored from the project’s own visual direction and current game rules.
- **External reference use:** none. No commercial game screenshot, asset pack, logo, character, or creator style was supplied.
- **Reference brief:** warm tabletop miniature railway; tactile grass/stone/timber/brass/navy materials; high three-quarter top-down readability; intentionally original composition; native PDF text overlays instead of generated type.
- **Forbidden expression:** any existing game/IP’s logo, title, character, UI skin, asset sheet, signature layout, non-original commercial screenshot recreation, in-image Korean/English text, logo, number, or fake UI copy.
- **Reference similarity status:** `NOT_APPLICABLE_FOR_EXTERNAL_REFERENCE · ORIGINAL_PROMPTED_OUTPUT_REQUIRES_USER_REVIEW`

### Prompt cards

| Candidate | Core prompt contract | Regenerate if |
| --- | --- | --- |
| `001` | 16:9 original cover visual; navy left negative space for native title overlay; right-side rectangular board with readable rails, a compact locomotive, off-track red/blue/yellow stations, and restrained lime/violet/crimson state cues. | A title-safe zone disappears, the board becomes unreadable, stations sit on rail, text/logo appears, or the frame resembles a third-party UI. |
| `002` | 16:9 BUILD board; authoritative 15×11 rectangular grid; large readable rails, curves, crossing, two-exit switch, lime valid placement preview, crimson station build exclusion, color-coded cargo and off-track stations. | It suggests a non-grid/isometric interaction model, loses the station boundary, uses text, or makes rails/tokens too small to inspect. |
| `003` | 16:9 RUN board; compact short train, exactly one two-exit switch, lime selected path, dim alternative, distinct crimson occupied lock, exact-cell cargo, off-track station and cardinal service cues, TOP represented without text. | It implies a solver, longer freight simulation, diagonal/station-footprint delivery, unreadable switch state, or generated text. |
| `004` | 16:9 presentation sheet; straight/curve/crossing/two-exit-switch track modules plus red/blue/yellow off-track station buildings and separate lime/violet/crimson state samples. | It looks like an approved runtime atlas, lacks the off-track station distinction, includes copy/labels, or breaks the shared material language. |

## Screen interpretation and visual QA

| Check | Result | Notes |
| --- | --- | --- |
| Main screen hierarchy | `PASS_FOR_DOCUMENT_CANDIDATE` | 001 reserves a calm left title region; board, rail, train, and station read first on the right. |
| BUILD information hierarchy | `PASS_FOR_DOCUMENT_CANDIDATE` | 002 makes track placement, rail geometry, valid green preview, and blocked station footprint visible without relying on copy inside the image. |
| RUN information hierarchy | `PASS_FOR_DOCUMENT_CANDIDATE` | 003 shows a short train, two-exit choice, current path, alternative, and lock as different visual layers. |
| Station delivery rule | `PARTIAL_DOCUMENT_VISUAL` | 003 depicts an off-track station and service cues; authoritative cardinal-only rule remains editable PDF/Godot text, not a visual-only claim. |
| Rail/station language consistency | `PASS_FOR_DOCUMENT_CANDIDATE` | 004 unifies dark steel, timber sleepers, pale ballast, stone tile bases, navy, brass, and the three station colors. |
| Text/localization safety | `PASS` | No generated text is used as game copy; all reader-facing Korean copy remains ReportLab text. |
| Runtime implementation evidence | `NOT_RUN / NOT_APPLICABLE` | These files are intentionally outside runtime asset paths and have no Godot consumer. |
| Rights / release approval | `NOT_APPROVED` | Candidate provenance is recorded, but user review and formal runtime asset review remain separate gates. |

## Approval scope and runtime boundary

The user has approved the r02 document visual package. The four files are now canonical only as **HGB r02 document visuals**: they may be used in the human-review PDF and as the approved direction for future runtime-asset planning.

This approval does **not** promote the flattened presentation images into `art/product_assets`, a Godot texture import, a runtime sprite sheet, or release-approved art. Current `SX-DEC-063` is still terrain-only and `RUNTIME_NOT_CONNECTED`; the active Candidate 004 Windows route-readability and audio inspection remains `NOT_RUN`. A later runtime-art implementation must therefore first pass the current physical gate, then define exact existing consumers, normal/selected/locked state variants, import settings, RED→GREEN tests, and Godot runtime verification.
