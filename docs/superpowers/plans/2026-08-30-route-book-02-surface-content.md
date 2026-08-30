# Route Book 02 Surface Content Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Deliver Route Book 02 as six directly selectable authored maps that consume the approved wayside core and modular board decorations.

**Architecture:** Generalize the existing single-book definition into validated book data and introduce a two-book catalog while retaining `RouteBookDirector` for within-book sequencing. Use existing Stage Book, Briefing, Build, Run, Result, Retry, and Edit consumers; Book 02 maps are fixed JSON and all content choices are machine-witnessed.

**Tech Stack:** Godot 4.7.1, GDScript, JSON map data, four-locale Route Book copy, existing responsive Control scene.

**Spec:** `docs/superpowers/specs/2026-08-30-route-book-02-surface-content-design.md`

## Global Constraints

- Execute only after the core plan provides validated surface fields, waste cargo, disposal yard, and renderer consumers.
- Keep Route Book 01 stage IDs, direct selection, and six-stage order unchanged.
- Keep each book fixed at six authored stages; no score, lock, save, progression, generator, or solution reveal.
- Keep T1–T6 and VS_DEMO_01 byte/behaviorally independent.
- Each Book 02 map must have one success witness and a named counterexample witness.

---

### Task 1: Generalize single-book data into an explicit two-book catalog

**Files:**
- Modify: `game/route_book/route_book_definition.gd`
- Create: `game/route_book/route_book_catalog.gd`
- Create: `data/route_book/route_book_02.json`
- Modify: `tests/route_book/test_route_book_definition.gd`
- Create: `tests/route_book/test_route_book_catalog.gd`

**Interfaces:**
- `RouteBookDefinition.book_id() -> StringName` reads the validated data value.
- `RouteBookCatalog.load_default() -> Variant` returns both `ROUTE_BOOK_01` and `ROUTE_BOOK_02` definitions.
- `RouteBookCatalog.book(book_id: StringName) -> Variant` returns no book for unregistered IDs.

- [ ] **Step 1: Write failing catalog tests**

```gdscript
func test_default_catalog_has_two_six_stage_books() -> void:
	var catalog = RouteBookCatalog.load_default()
	assert_eq(catalog.book_ids(), [&"ROUTE_BOOK_01", &"ROUTE_BOOK_02"])
	assert_eq(catalog.book(&"ROUTE_BOOK_01").stage_count(), 6)
	assert_eq(catalog.book(&"ROUTE_BOOK_02").stage_count(), 6)
```

- [ ] **Step 2: Run the route-book tests and verify RED**

- [ ] **Step 3: Refactor only the hard-coded book identity/IDs from `RouteBookDefinition`**

Maintain schema v1, order preservation, valid path prefix, duplicate-ID rejection, command-array validation, and `RECOMMENDED_LAYOUT` rejection. Add the catalog with exactly the two tracked JSON paths.

- [ ] **Step 4: Add malformed-book rejection tests, verify GREEN, and commit**

```text
git add game/route_book/route_book_definition.gd game/route_book/route_book_catalog.gd data/route_book/route_book_02.json tests/route_book/test_route_book_definition.gd tests/route_book/test_route_book_catalog.gd
git commit -m "feat: add validated route book catalog"
```

### Task 2: Add explicit Book 01 / Book 02 selection without altering stage recovery

**Files:**
- Modify: `game/demo/vertical_slice_demo.tscn`
- Modify: `game/demo/demo_flow_controller.gd`
- Modify: `tests/demo/test_route_book_flow.gd`
- Modify: `tests/demo/test_route_book_responsive_layout.gd`

**Interfaces:**
- `DemoFlowController.select_route_book(book_id: StringName) -> bool`.
- `DemoFlowController.select_route_book_stage(stage_id: StringName) -> bool` applies to the selected book.

- [ ] **Step 1: Write failing flow tests**

```gdscript
func test_book_two_selection_only_populates_book_two_cards() -> void:
	controller.open_route_book()
	assert_true(controller.select_route_book(&"ROUTE_BOOK_02"))
	assert_eq(controller.route_book_stage_ids_for_test()[0], &"RB07_FOREST_RELAY")
```

- [ ] **Step 2: Run focused flow/responsive tests and verify RED**

- [ ] **Step 3: Add two Book buttons and minimal catalog state in the controller**

Reuse the existing scrollable `StageList`. Preserve Title→Stage Book, Stage Book→Briefing, Result→Retry/Edit/Stage Book, and book-local Next Stage; never auto-switch into another book.

- [ ] **Step 4: Verify Book 01 recovery tests stay green, then commit**

```text
git add game/demo/vertical_slice_demo.tscn game/demo/demo_flow_controller.gd tests/demo/test_route_book_flow.gd tests/demo/test_route_book_responsive_layout.gd
git commit -m "feat: select route book content packs"
```

### Task 3: Author Route Book 02 maps, localization, and machine witnesses

**Files:**
- Create: `data/maps/route_book/rb07_forest_relay.json`
- Create: `data/maps/route_book/rb08_caution_cut.json`
- Create: `data/maps/route_book/rb09_salvage_siding.json`
- Create: `data/maps/route_book/rb10_clean_break.json`
- Create: `data/maps/route_book/rb11_turnout_under_load.json`
- Create: `data/maps/route_book/rb12_lantern_loop.json`
- Modify: `game/first_session/first_session_copy.gd` (the existing reusable JSON localization loader)
- Modify: `tests/route_book/test_route_book_maps.gd`
- Modify: `tests/route_book/test_route_book_machine_witnesses.gd`
- Create: `기획서/20_시스템_콘텐츠/ROUTE_BOOK_02_WAYSIDE_CONTENT_SPEC.md`

- [ ] **Step 1: Write one failing map-contract test per RB07–RB12**

Assert the exact stage ID, path, valid v3 definition, declared named condition, four-to-seven blocked-cell decorations, and absence of `RECOMMENDED_LAYOUT`.

- [ ] **Step 2: Write one failing witness and one counterexample per stage**

The witnesses must respectively prove the named judgement: revisit (RB07), caution route trade-off (RB08), waste TOP order (RB09), disposal then delivery (RB10), pre-occupancy switch with caution exit (RB11), and all conditions combined (RB12).

- [ ] **Step 3: Author the fixed JSON maps and four-locale copy**

Use one first-appearance sentence for `CAUTION_TRACK` and `DISPOSAL_YARD`; keep every other copy factual and compact. Use only `FINITE_MAP_DEFINITION v3` values and no hidden solution data.

- [ ] **Step 4: Run map/witness tests to GREEN**

Expected: each stage has a passing structural preflight/success witness and its named bad choice fails by an existing factual terminal outcome or leaves required cargo unresolved.

- [ ] **Step 5: Commit the authored-content unit**

```text
git add data/route_book/route_book_02.json data/maps/route_book game/route_book tests/route_book 기획서/20_시스템_콘텐츠/ROUTE_BOOK_02_WAYSIDE_CONTENT_SPEC.md
git commit -m "feat: add Route Book 02 authored stages"
```

### Task 4: Validate UI, imports, and unchanged current content

**Files:**
- Modify: `docs/operations/2026-08-30-sx-dec-067-local-machine-verification.md`
- Modify: `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`

- [ ] **Step 1: Run Godot import and full test suite**

Verify that every Book 02 bitmap imports and all 118-plus pre-existing tests retain their behavior.

- [ ] **Step 2: Run Route Book 01 regression tests as a named subset**

Verify that Book 01 stays six cards, preserves its IDs/order, and never presents a waste/disposal/caution condition.

- [ ] **Step 3: Complete five adversarial review passes and record evidence**

Cover catalog/consumer misuse, Rule Book scope leakage, board readability, generated-asset provenance, import/runtime integrity, and evidence ceiling. Record only machine results; name Candidate 006 as historical for post-change bytes.
