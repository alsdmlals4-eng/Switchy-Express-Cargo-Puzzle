# Route Book 03 Implementation Plan

Execution checkpoint September14: Tasks1–3 implementation/local verification executed.
Six separate missing-map REDs and637 focused assertions; full131/17040; actual18SUCCESS,
six negative paths and six same-layout Retry/Edit checks;216preview/9Begin. Package and
integration closure still pending; exact receipts are in evidence/runtime/route-book-03-20260914.
Checklist below retains the original ordered instructions, not a second status owner.

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement task-by-task. Execute inline; independent review remains read-only.

**Goal:** Add six distinct optional authored puzzles, with actual18-stage completion and changed-byte package evidence.

**Architecture:** Reuse the existing finite map/route-book/shell consumers. Keep new authored fixtures and witness checks separate from the old twelve. Add the third catalog entry and a narrow shared-selector copy owner; do not introduce a solver, persistent progression, or new art.

**Tech Stack:** Godot4.7.1-stable / GDScript, JSON schema3 maps/schema1 book+copy, existing custom tests/GUT9.7.1 and Python pytest.

**Spec:** `docs/superpowers/specs/2026-09-14-route-book-03-authored-content.md` plus approved `2026-09-14-remaining-work-design.md` section6.

## Global Constraints

- Finite handcrafted puzzles, cardinal station service, exact-cell pickup, unlimited LIFO, manual default/Auto toggle, occupied switch lock, same-layout Retry/Edit.
- Six optional stages, no new tutorial; Title Start stays T1. No save/unlock/score/PB/Daily/Weekly/fuel/BOOST additions.
- Existing topdown approved assets; new bitmap0; ko/en/ja/zh-Hans. No engine/provider/Base repin.
- PR174/254/281 read-only. New scope tracked by September14 approval, no reused SX-DEC-070.
- Source/docs/automation/runtime/package/user/release evidence remain separate. No deletion; only verified task-derived holding material for user cleanup.
- Read latest merged main and these owners before execution. Do not expose book03 until all six positive/negative witnesses exist and pass.

## Task 1: Six independently executable map/witness pairs

Files: create `data/maps/route_book/rb13_four_sides.json`, `rb14_manifest_mirror.json`,
`rb15_manual_gap.json`, `rb16_caution_ledger.json`, `rb17_clearance_yard.json`,
`rb18_switchboard_night.json`; create `tests/fixtures/route_book/route_book_03_witnesses.gd`,
`tests/route_book/test_route_book_03_witnesses.gd`, `tests/runtime/route_book_03_witness_runner.gd`;
register the test in `tests/run_tests.gd`. Read existing finite loader/build/factory consumers.

Interfaces: fixture `static func pieces(stage_id: StringName, negative: bool = false) -> Array[Variant]`;
fixture `static func drive(stage_id: StringName, history: Array, runtime: Variant, negative: bool = false) -> Dictionary`
returns `manual:bool, auto:bool, desired_exit:Vector2i, switch_cell:Vector2i` from exact authored
contact history. Domain test applies returned input to existing InputState/graph; actual Main runner
applies it through Product commands. It is test-only input, not a runtime policy or solution service.
New witness test exports `results:Array[Dictionary]`, including observed phase, pickup/unload sequence,
group sizes, contact skips/revisits and occupied-lock result; expected six exact IDs independent of catalog.

- [ ] Write RED for missing first map and empty witness before generating any map. Use actual loader:

```gdscript
var definition: Variant = Loader.load_from_path("res://data/maps/route_book/rb13_four_sides.json")
assert_not_null(definition, "RB13 authored map exists and validates")
if definition == null: return
assert_equal(definition.map_id, &"RB13_FOUR_SIDES", "exact authored identity")
```

- [ ] Run existing `tests/run_tests.gd`; record nonzero missing-map failure, not an engine parse error.
- [ ] Encode RB13 exact map and positive/negative paths from spec. Use `TrackPiece.create` for straight/curve/crossing; start marker is never a player piece. A path encoder may convert explicit cardinal coordinates to ports but must never search for a route:

```gdscript
const PORTS := [Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT]
# For each explicit interior coordinate: incoming=previous-current,
# outgoing=next-current (last outgoing=current-previous).
# U/R=CURVE0; R/D=CURVE1; D/L=CURVE2; L/U=CURVE3.
# L/R=STRAIGHT0; U/D=STRAIGHT1; repeated orthogonal crossing=CROSSING0.
# Overrides at RB16[7,5], RB18[6,5] are SWITCH0; RB18[7,5]=CROSSING0.
```

- [ ] Build with `BuildSession.new(definition)`, assert every `place_piece` succeeds, call `begin_run` and assert positive preflight. For RB13 diagonal negative assert failed preflight; station footprint placement rejected.
- [ ] Create actual session with `FiniteRunSessionFactory.configure(definition,build.sealed_snapshot(),2.0)`, `create_attempt(1)` and `run_controller.start()`. At0.05 increments, apply explicit driver until SUCCESS/FAILURE or5000-step bound. Require SUCCESS and exact B,R / R,B for RB13.
- [ ] Repeat that RED->JSON+fixture->GREEN cycle separately for RB14,15,16,17,18, using each complete positive/negative trace in the spec. Expected outcomes are fixed:

```text
RB14 positive B,R,R -> R,R (one group),B; negative R,B,R leaves R.
RB15 positive skip R once then B,R -> R,B; negative Auto always on leaves R.
RB16 positive select UP before occupancy + lock rejected -> SUCCESS;
     negative EAST + occupied change rejection -> FAILURE.
RB17 positive W,W,R -> R,W,W (one waste group); negative R,W,W leaves R.
RB18 positive Auto W,W / skip R / manual B,R -> R,B,W,W, two-waste group;
     negative Auto always ON, same correct switch -> FAILURE.
```

- [ ] Preserve observed failures when a coordinate is corrected; update spec/JSON/fixture together. Commit only these new map/test files after six exact pairs are verified. No catalog exposure yet.

## Task 2: Third-book identity and four-locale consumers

Files: modify `game/route_book/route_book_catalog.gd`, `route_book_definition.gd`,
`game/demo/demo_flow_controller.gd`; create `data/route_book/route_book_03.json`,
`data/localization/route_book_03_v1.json`, `route_book_selector_v1.json`;
retain legacy non-owner selector duplicates in book01/02. Tests: `test_route_book_catalog.gd`,
`test_route_book_definition.gd`, `test_route_book_02_copy.gd`, new `test_route_book_03_copy.gd`.

Interfaces: existing catalog API unchanged; exact book03 paths and `SX_RB03_STAGE_BOOK` label.
Definition preserves six exact ordered IDs per book. New data uses existing action arrays,
with `context_key` and correct feature flags for caution/waste on each relevant stage.

- [ ] Change expected catalog to exact three IDs, assert unknown book still returns empty. RED before implementation:

```gdscript
assert_equal(Catalog.book_ids(), [&"ROUTE_BOOK_01", &"ROUTE_BOOK_02", &"ROUTE_BOOK_03"], "three approved books")
assert_equal(Catalog.copy_path(&"ROUTE_BOOK_03"), "res://data/localization/route_book_03_v1.json", "book03 copy")
```

- [ ] Add six-ID constant and map in Definition, catalog entry, and exact six-stage JSON. For book03 require exact lowercased stage map basename and nonempty context; preserve older optional-context semantics. Tests mutate duplicate/order/missing stage/map/context to require null:

```gdscript
var invalid: Dictionary = data.duplicate(true)
invalid.stages[0].map_path = "res://data/maps/route_book/rb14_manifest_mirror.json"
assert_equal(Definition.create(invalid), null, "RB13 cannot alias RB14")
invalid = data.duplicate(true)
invalid.stages[0].context_key = ""
assert_equal(Definition.create(invalid), null, "book03 requires planning context")
```

- [ ] Prepare all four translations. Titles: 사방의 역/Four Sides, 적재 거울/Manifest Mirror,
  수동 적재 틈/Manual Gap, 주의 운행 장부/Caution Ledger, 정리 작업장/Clearance Yard,
  야간 배차판/Switchboard Night. Objective/context describe the spec's decision, not coordinates or input solution.
  Every stage owns TITLE/OBJECTIVE/CONTEXT; book copy owns PROGRESS (03), BEGIN, NEXT_STAGE.
  Selector owns STAGE_BOOK, SELECT_BOOK, SELECT_STAGE, BACK and three catalog labels.
  Legacy selector duplicates in books01/02 remain non-owner compatibility data to avoid
  unnecessary older-copy churn; book03 does not duplicate selector keys. Actual selector
  consumer reads only the new selector file; no general localization refactor.
- [ ] Point only `_route_book_selector_copy.load_from_path` to selector_v1. Add translation tests
  iterating every required key and four locales. Temporary copy with a missing translation must
  make existing `FirstSessionCopy.load_from_path` return false; empty/missing selector labels fail checks.
- [ ] Run full custom suite and Python contract; commit catalog/data/copy/test companions atomically.

## Task 3: Actual UI flow and18-stage execution

Files: `tests/demo/test_route_book_context.gd`, `test_route_book_flow.gd`,
`test_route_book_responsive_layout.gd`, `test_route_book_result_truth.gd`,
`tests/runtime/route_book_completion_window_runner.gd`, `stage_preview_live_qa.gd`,
`tests/python/test_stage_preview_window_receipt.py`, `test_exported_route_book_consumer.py`.
Keep `route_book_director.gd` unchanged unless a failing consumer proves a narrow defect.

Interfaces: test-only explicit map of eighteen stage IDs to their owning book, independent of
production catalog; new six use Task1 fixture/driver, old twelve retain old fixture/driver.

- [ ] Extend RED expected counts/IDs before runtime changes. Require book03 can select every stage,
  Begin exact map with empty layout, Result->Retry new session/same layout, Edit preserves layout,
  back/list switches reset context, RB18 has no next-stage action. Title Start remains T1.
- [ ] Replace completion runner's `index < 6 ? book01 : book02` with explicit stage->book map.
  Verify exact catalog ID set equals the independently declared18 IDs, not just count18.
  Load new fixture beside external runner only for new six; product resources remain mounted PCK.
- [ ] Apply Task1 driver using Product `LOAD_ACTIVE`, `AUTO_TOGGLE`, `BOARD_CELL` commands;
  retain prior old12 driver and final real SUCCESS/cargo/next-button checks. Add new-six negative
  mode that expects RB13 preflight rejection and five actual FAILURE outcomes, not forged results.
- [ ] Preview matrix expects216 states and nine pointer Begin checks (last stage of each book at
  three widths in ko). Retain four-locale smallest-window captures and current RB08 blueprint binding;
  add four RB18 captures with separate keys. Include selector copy hash.
- [ ] Run exact Godot window QA at960x540,1280x720,1600x900; inspect captured maps/labels/buttons.
  Runtime receipts remain NOT_HUMAN/NOT_RELEASE. Commit tests and current receipts together.

## Task 4: Blueprint, package and normal integration

Files: `tools/build_blueprint_review_20260911.py`, `docs/design/SWITCHY_BLUEPRINT_REVIEW_20260911.md`,
existing publication/current-state owners and new route-book03 evidence directory.

- [ ] Extend builder copy source list to book03 and update current18-stage counts; existing map glob
  emits six new data/decision page pairs. Do not silently promote older stage images to new-byte proof.
- [ ] Re-run actual preview, publish current source/capture hashes, regenerate PDF, render every page
  and inspect layout. If C1 witness source inputs changed, rerun its bounded timing test and receipt
  before PDF; never bypass its stale-source guard.
- [ ] Run `python tools/validate_project_contract.py`, full custom Godot suite and `python -m pytest tests -q`
  with exact `GODOT_BINARY`. Inspect exit/error/summary; keep failed attempts separate.
- [ ] Export Windows Demo to a new exact-source folder; runtime presets exclude tmp/tests/evidence/output.
  Verify packaged18 JSON BUILD entries, actual18 SUCCESS, new-six negative paths, then native EXE startup.
  Record EXE/PCK hashes before/after and preserve externally driven PCK versus native EXE evidence distinction.
- [ ] Five-pass independent review -> corrections -> regression -> exact-head CI -> normal PR merge;
  fetch/readback main and expected product paths. Update Active Context/Roadmap and package pointer.
- [ ] Keep R1 release/U1 final user separate; V1 capability limitation explicit. Move only verified
  task-derived rejects/render intermediates to user-delete holding, with original paths and restoration note.
