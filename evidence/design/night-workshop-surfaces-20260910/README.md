# Night Workshop surfaces — candidates, not production assets

Current status: board-slate = USER_APPROVED_PIXELS / REGISTERED / IMPLEMENTED / MACHINE_FRAMEBUFFER_REVIEWED.
title-workshop = USER_NOT_SELECTED / PRESERVED_REFERENCE_ONLY.
Latest user instruction (2026-09-11): finish remaining preparation and implement the game.
Board source copied unchanged to art/product_assets/night_workshop_v1/board_slate.png.
Neutral white tint and transparent veil replace the old warm overlay. Current runtime proof:
evidence/runtime/blueprint-implementation-20260911/receipt.json. Title remains unselected.
Built-in image model; no paid API, borrowed external pixels or vector-generated art.

| File | Source generation | SHA-256 | Existing consumer |
|---|---|---|---|
| board-slate.png | exec-5f762a6a-e55f-47f4-aaa3-63a7fbc00980.png | 694f69c32f457a9dea425716774d9bca4de2896c680c8defed47667d86e15365 | ProductBoardRenderer board_terrain |
| title-workshop.png | exec-93224fcc-c842-4478-8b82-24104b50443c.png | 01fee8f90ce435d2e115943f67ad8b342489eafbd9b6fc9069108aa848eee863 | ProductShellArt TITLE_HERO_PATH |

Prompts: board = opaque quiet blue-gray slate, low contrast, orthographic, no grid/rail/props/text.
Title = navy/brass compact locomotive and cream/navy depot on workshop tabletop at night,
restrained amber lights, quiet left 30% and right 20% for localized controls, no painted UI/text.
Full prompts are in the current generation tool calls; filenames identify exact source output.

Board is 1536x1024 RGB; title dimensions must be read from actual output, not the prompt request.
Large static images do not need Aseprite frame packing. The source remains unchanged.
board-preview.png is an actual Godot framebuffer with a temporary in-memory terrain substitution;
production texture was restored immediately. It is a candidate comparison, not canonical runtime proof.
Finding: existing warm veil desaturates this slate. Plan modulation and grid/service contrast
requirements first (historical review finding, corrected in September 11 implementation). Title right edge is busier
than requested and the user did not select it. No hidden runtime replacement or deletion.
