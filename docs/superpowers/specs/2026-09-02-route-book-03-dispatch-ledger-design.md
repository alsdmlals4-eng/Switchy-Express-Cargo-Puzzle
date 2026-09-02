# Route Book 03 · Dispatch Ledger Design

**Proposed decision:** `SX-DEC-070 · Route Book 03`
**Status:** `USER_DIRECTION_APPROVED · WRITTEN_SPEC_REVIEW_REQUIRED · IMPLEMENTATION_NOT_STARTED`
**Date:** 2026-09-02 KST
**Approval input:** the user approved the recommended direction: a third optional pack of fixed, authored stages that reuses the current finite rules.
**Implementation gate:** this file is the written-review artifact. No production code, maps, asset bytes, current candidate pointer, or canonical decision register is changed until its written scope is accepted and an implementation plan is created.

## 1. Outcome and protected baseline

Route Book 03, subtitled **Dispatch Ledger** (`운행 장부`), adds six directly selectable, hand-authored optional stages after Route Books 01 and 02. It is a content-depth pack, not a new progression layer, tutorial, mode, or mechanics family.

```text
Title
→ Stage Books
→ Route Book 01 | Route Book 02 | Route Book 03 · Dispatch Ledger
→ one of six directly selected stages
→ existing briefing
→ existing BUILD → RUN → factual Result
→ Retry Same Route | Edit Route | Stage Book | Next Stage
```

The following remain unchanged:

- `T1 → T6 → VS_DEMO_01`, Title Start, and the first-session contract;
- `FiniteMapDefinition v3`, exact-cell cargo pickup, exact-cardinal station/disposal service, unlimited LIFO and contiguous matching TOP-group unload;
- free BUILD / full refund, automatic train movement, manual load, Auto toggle, direct switch selection and occupied-switch lock;
- `CAUTION_TRACK` at its existing authored `0.55` speed multiplier, `WASTE_CRATE`, and `DISPOSAL_YARD` semantics;
- existing asset files, title-shell scene, board renderer slots, audio, score/progression/save surfaces, and Candidate 010's immutable historical/current evidence boundary;
- the user-selected machine-primary acceptance policy. Five-person comprehension and player-experience studies are not introduced as gates.

Route Book 03 changes player-facing bytes only when the later implementation is approved and merged. It will then require its own exact machine regression, package evidence, CI, and candidate; existing Candidate 010 evidence must not be transferred.

## 2. Current-state and reuse findings

### Actual project consumer seam

Current Godot runtime was launched directly on 2026-09-02 using Godot `4.7.1-stable`. The actual title screen exposed the `StageBookButton`; selecting it opened the live `RouteBookScreen` with exactly two runtime cards: `ROUTE_BOOK_01Card` and `ROUTE_BOOK_02Card`. Diagnostics were clean.

The implementation seam is already narrow:

| Existing owner | Current fact | Route Book 03 disposition |
| --- | --- | --- |
| `game/route_book/route_book_catalog.gd` | Owns the two ordered book IDs, definition paths, copy paths, and display keys. | **ADAPT** with one ordered third entry. |
| `game/route_book/route_book_definition.gd` | Fails closed against unknown book IDs and requires the exact six IDs for each known book. | **ADAPT** with one third explicit six-ID list; do not loosen validation. |
| `game/route_book/route_book_director.gd` | Owns direct stage selection and same-book next-stage traversal. | **REUSE unchanged**. |
| `game/demo/demo_flow_controller.gd` | Builds book cards from catalog data and stage cards from the selected definition. The selector currently loads the Route Book 02 locale file for generic labels and all book-card labels. | **ADAPT** to a dedicated selector locale so a new book does not edit an unrelated book's stage-copy owner. |
| `data/route_book/route_book_01.json`, `route_book_02.json` | One schema-v1 definition per book, exactly six direct stages. | **REUSE pattern** for one new definition. |
| `data/maps/route_book/` | Existing v3 authored map path boundary. | **REUSE pattern** for six new maps only. |
| Route Book test suites and `tests/fixtures/route_book/route_book_witnesses.gd` | Fixed IDs, catalog paths, copy parity, map validity, and success/failure witnesses are already deterministic. | **ADAPT** with RB13–RB18 coverage. |
| Existing board renderer / 73 semantic assets / v02 wayside candidates | The current board has all required cargo, station, disposal, caution, decoration and feedback consumers. | **REUSE unchanged**; no bitmap generation or candidate promotion. |

The clean, imported baseline ran on this exact source before design output: `120` test cases, `14,133` assertions, `0` failures. The first headless attempt revealed only an empty worktree `.godot/imported` cache; Godot's own `--import` step produced the ignored cache, and the unchanged rerun passed. That setup finding is environmental, not a product defect or a Route Book 03 change.

### Reuse decision

The Base SWITCHY profile already enables `RM-SYS-001` grid placement and the semantic UI/symbol patterns, but Route Book 03 needs neither a new reusable module nor a new Godot plugin. The project owns the mature route-book catalog, direct-selection flow, fixture pattern, and finite map schema. Therefore:

```yaml
reuse_mode: PROJECT_EXISTING_ROUTE_BOOK_PATTERN
base_module_change: NOT_APPLICABLE
new_plugin_or_asset_search: NOT_APPLICABLE
new_bitmap_assets: 0
base_promotion_candidate: NONE
```

## 3. Current benchmark and reverse-engineering

The project already owns a 12-product Route Book benchmark. Each source was reread against its current official site, official wiki, developer press page, or official Steam page on 2026-09-02. The goal is to identify boundaries, not to copy level layouts, text, imagery, or progression systems.

| Product family | Current official observation | Switchy disposition |
| --- | --- | --- |
| Train Valley 2 | Hand-authored Company-mode levels coexist with upgrades, industries, Workshop and modding. | **ADOPT** a compact authored pack; **REJECT** tycoon, upgrade, UGC. |
| Rail Route | Construction sits inside timetables, automation, upgrades, endless play, and map editing. | **ADAPT** explicit route state; **REJECT** timetable, economy, automation, editor. |
| Station to Station | Calm connection puzzles add world growth, optional score challenges, biome content and generated modes. | **ADAPT** calm board readability; **REJECT** world growth, score, generation. |
| Mini Metro | Clear route information supports a dynamically growing, failure-driven network with multiple modes. | **ADAPT** redundant information; **REJECT** dynamic growth, endless, upgrade loop. |
| Railgrade | Railway construction serves production chains, investment and upgrades. | **ADOPT** legible source-to-destination causality; **REJECT** production/economy. |
| Unrailed! | Cooperative procedural survival includes resources, unlocks and roguelite progression. | **REJECT** the entire survival/procedural/progression family. |
| Teeny Tiny Trains | Small handcrafted miniature train puzzles foreground one readable routing thought per challenge. | **ADOPT** a named central decision per authored map; **REJECT** editor, collection, customization. |
| Railway Islands | A safe route and all-delivered objective are simple and observable. | **ADOPT** factual delivery witness and explicit failure counterexample. |
| Trainyard | Fixed brain-teasers allow many solutions and support colour-blind use. | **ADOPT** multiple valid layouts plus colour/shape/text redundancy; **REJECT** solution sharing. |
| Railbound | Large authored puzzle selection concentrates one interaction problem at a time. | **ADOPT** directly selectable authored stages; **REJECT** unlock path and foreign mechanics. |
| Tracks | A toy-rail sandbox prioritizes decoration, free construction, first-person riding, and multiple trains. | **ADAPT** existing miniature-diorama tone only; **REJECT** sandbox/decoration system/multi-train. |
| Rail Island | Terrain generation, broad transport construction, saved/published islands and optional subscription define the product. | **ADAPT** build-then-observe clarity only; **REJECT** terrain tools, save/publish, monetization. |

**Result:** the better content investment is a fixed, all-open six-stage pack with one named judgment each. It is not a score wrapper, a generation pipeline, or another visual-asset program.

Primary-source links used for this receipt: [Train Valley 2](https://store.train-valley.com/), [Rail Route Wiki](https://wiki.railroute.eu/), [Station to Station](https://store.steampowered.com/app/2272400/Station_to_Station/), [Mini Metro](https://minimetro.radialgames.com/), [Railgrade](https://railgrade.com/), [Unrailed!](https://www.unrailed-game.com/unrailed.html), [Teeny Tiny Trains](https://store.steampowered.com/app/2825600/Teeny_Tiny_Trains/), [Railway Islands](https://www.qubyteinteractive.com/games/Railway-Islands/), [Trainyard](https://trainyard.ca/), [Railbound](https://afterburn.games/press/sheet.php?p=railbound), [Tracks](https://store.steampowered.com/app/657240/Tracks/), and [Rail Island](https://www.railisland.com/).

## 4. Alternatives considered

| Alternative | Player value | Cost / risk | Decision |
| --- | --- | --- | --- |
| A. A third six-stage fixed authored book using only established conditions | More puzzles and combinatorial depth while retaining the finite product identity; uses current code and art consumers. | Requires six maps, locale parity, witnesses, and one bounded selector-copy ownership correction. | **RECOMMENDED · ADOPT** |
| B. Append six extra stages to Route Book 02 | Fewer catalog changes. | Erases the semantic boundary of the approved wayside pack, makes old evidence/story harder to inspect, and ties ordinary content to the unresolved v02 wayside-pixel review. | **REJECT** |
| C. Add an endless/daily/score/unlock wrapper around the existing books | Could increase nominal replay quantity. | Directly conflicts with approved finite authored identity and prohibited SX-DEC-056–058/progression families; adds persistence, balancing and acceptance surface. | **REJECT** |

## 5. Selected structure

### 5.1 Catalog and copy ownership

The catalog order becomes:

```text
ROUTE_BOOK_01 → Route Book 01 definition + stage copy
ROUTE_BOOK_02 → Route Book 02 definition + stage copy
ROUTE_BOOK_03 → Route Book 03 definition + stage copy
```

The existing selector uses `route_book_02_v1.json` as an accidental owner for generic button labels and the card labels of every book. This works for two books but forces future packs to modify 02's stage-copy file. The implementation will add a small shared selector locale (for title, book selector, back, begin, stage-book action, and all three book-card labels) and update only `DemoFlowController`'s selector-copy load path. Stage-specific titles/objectives/progress remain in each book's own locale file.

This is a source-ownership correction, not a localization-system rewrite: there is no language picker, key format, locale expansion, fallback change, or new UI scene. Existing duplicated common keys stay compatible until a separately authorized cleanup; this scope does not delete or migrate them.

### 5.2 Data contract

`RouteBookDefinition` keeps its fail-closed strategy:

- adds `ROUTE_BOOK_03_IDS` with exactly `RB13` through `RB18` in declared order;
- retains exact six-stage count, unique IDs, `res://data/maps/route_book/` path boundary, required strings and command arrays;
- keeps `RECOMMENDED_LAYOUT` forbidden from player-facing feature data;
- rejects an unknown book or malformed third-book JSON exactly as it does today.

New tracked data paths after implementation:

```text
data/route_book/route_book_03.json
data/localization/route_book_selector_v1.json
data/localization/route_book_03_v1.json
data/maps/route_book/rb13_four_sides.json
data/maps/route_book/rb14_manifest_mirror.json
data/maps/route_book/rb15_manual_gap.json
data/maps/route_book/rb16_caution_ledger.json
data/maps/route_book/rb17_clearance_yard.json
data/maps/route_book/rb18_switchboard_night.json
```

No new scene, resource class, autoload, save key, image, sound, animation, plugin, network endpoint, or paid service is needed.

### 5.3 Route Book 03 content contract

All six cards are selectable immediately. Stage order gives the book a readable escalation, but never unlocks or blocks selection. The cards use existing Stage Book, Briefing, Build, Run, and factual Result UI. Existing board decorations may appear only on valid blocked cells; they never become gameplay markers and do not require new art.

| Stage | Named central judgment | Required known conditions | Success witness | Counterexample the test must preserve |
| --- | --- | --- | --- | --- |
| RB13 `FOUR_SIDES` · 사방 배차 | Read two off-track stations through their legal cardinal service cells rather than their footprints or diagonals. | ordinary cargo, normal stations, free build | Both cargoes unload only from cardinal-adjacent cells. | A diagonal/footprint-oriented route leaves delivery incomplete or fails preflight. |
| RB14 `MANIFEST_MIRROR` · 적재 장부 | Build a three-cargo reverse manifest so the current TOP clears each destination in order. | three ordinary cargoes, two station types, LIFO | Witness loads the intended reverse order and observes the matching contiguous TOP sequence. | Forward encounter loading strands the needed item below an incompatible TOP. |
| RB15 `MANUAL_GAP` · 빈 적재칸 | Leave Auto off through one early contact, then deliberately load that cargo only on a later visit. | manual load, Auto toggle, revisit | Witness records the first skip, later pickup, and complete delivery. | Auto left on through every contact produces an incompatible stack/failure. |
| RB16 `CAUTION_LEDGER` · 감속 장부 | Commit the switch before occupancy and budget the existing caution departure rather than treating it as a new hazard rule. | `CAUTION_TRACK`, direct switch, timer | Correct branch crosses the authored slow cell and reaches factual success. | Default/wrong branch reaches a factual route/time failure; no auto-correction occurs. |
| RB17 `CLEARANCE_YARD` · 정리 야드 | Preserve a two-crate waste TOP group until the disposal-yard service pass, while clearing the normal cargo first. | two `WASTE_CRATE`, one normal cargo, disposal yard | Witness sees the normal unload then one contiguous waste-group disposal at a legal cardinal cell. | Taking waste after normal cargo blocks the ordinary delivery or makes the disposal sequence fail. |
| RB18 `SWITCHBOARD_NIGHT` · 야간 분기대 | Combine selective Auto, a persistent switch choice, one caution exit, ordinary LIFO delivery, and grouped disposal without changing any rule. | Auto toggle, switch lock, caution, two waste crates, normal cargo, disposal yard, existing lantern/forest decoration only | Witness records Auto transition, occupied-lock rejection, normal delivery, then grouped legal disposal. | Wrong pre-occupation switch state or an indiscriminate Auto sequence ends in factual failure. |

The map author may choose any valid coordinates and multiple valid layouts, but must satisfy every tabled witness/counterexample using the existing schema-v3 preflight and direct runtime loop. The plan must not encode, expose, or show a recommended player layout.

### 5.4 Localization

The selector locale and Route Book 03 stage locale each contain exact `ko`, `en`, `ja`, and `zh-Hans` entries. The new stage locale must own `SX_RB_PROGRESS`, `SX_RB_NEXT_STAGE`, and every `SX_RB13`–`SX_RB18` title/objective key; the selector locale owns the shared title/action/book-card keys. No text is rendered into an image. `zh-Hant` remains deferred under the current project baseline.

### 5.5 Pre-implementation five-pass review record

This review is deliberately separate from the five post-implementation reviews in section 7. It attacks the design before any Route Book 03 byte is introduced.

| Loop | Attack | Verified finding and correction | Result |
| --- | --- | --- | --- |
| 1. Product scope | Could a third book quietly become T7, a progression wrapper, or a score/daily system? | The flow starts only from the existing Stage Book. Direct selection, no persistence, no score/unlock/generator, and unchanged first-session entry are explicit invariants. | `CLEAN` |
| 2. Consumer/data ownership | Would a third book require a scene redesign or put its label into Route Book 02's content file? | The live selector already builds from `RouteBookCatalog`; the only confirmed ownership gap is the selector copy path. Section 5.1 adds a dedicated selector locale instead of mutating 02's stage-copy owner. | `CLEAN_AFTER_CORRECTION` |
| 3. Visual/provenance | Could the content request create a decorative raster asset with no consumer or promote the eight pending wayside candidates? | The current renderer already owns all markers/decorations. The scope sets `new_bitmap_assets: 0` and preserves every candidate/asset status unchanged. | `CLEAN` |
| 4. Engine/rule feasibility | Do the selected stage conditions require a new schema or a hidden exception to cardinal service, LIFO, caution, disposal, or switches? | Existing RB08–RB12 maps and machine witnesses already exercise caution, disposal, Auto, and lock through schema v3. RB13–RB18 only recombine those existing contracts and every proposed map remains subject to the same preflight. | `CLEAN` |
| 5. Evidence boundary | Could a baseline test, current live screenshot, or Candidate 010 be misrepresented as proof of the new pack? | The test baseline is labeled pre-change only; the first-run import-cache failure is classified as environment setup; Candidate 010 is expressly non-transferable. New runtime/package/CI/candidate proof is required after changed bytes exist. | `CLEAN` |

## 6. Verification contract

Implementation begins RED-first. Before adding production data, tests must fail for the absent third book, unknown/invalid 03 definition, missing 03 selector label, and absent RB13–RB18 witnesses. Green evidence must include:

1. catalog order/path/display-key tests for all three books;
2. fail-closed definition tests for exact RB13–RB18 order, six-count, path boundary, duplicate/malformed rejection, and hidden `RECOMMENDED_LAYOUT`;
3. four-locale copy parity and selector-label tests;
4. six map-schema/preflight tests plus six success witnesses and six named factual counterexamples;
5. Stage Book flow tests proving three book cards, direct selection, next-stage containment inside 03, Title Start still opens T1, and first-session/Route Books 01–02 remain unchanged;
6. responsive 1280×720 UI test proving the third card remains reachable through the current scroll container and does not require a new scene/layout invention;
7. full project contract, complete Godot regression, runtime scene launch, clean diagnostics, and a direct Godot/Hera inspection of Title → Stage Book → Route Book 03 → RB18 BUILD;
8. exact-PR-head CI/package checks and a new post-change candidate only after implementation bytes are complete.

Machine/runtime proof is not physical Windows/device/audio/user/release proof. The user has explicitly made machine validation primary; five-person comprehension and player-experience studies remain `NOT_REQUIRED_BY_USER_VALIDATION_POLICY`. A final visual/user review, if requested later, must target the new unchanged post-Route-Book-03 candidate—not Candidate 010.

## 7. Five adversarial reviews required after implementation

1. **Scope and ownership:** try to find a tutorial replacement, a new mechanic, a score/unlock/save state, an accidental Route Book 02 ownership leak, or a modified protected first-session/candidate file.
2. **Consumer and implementation:** verify the third card is supplied by catalog data, all strings resolve, all maps use actual schema-v3 consumers, and no new raster slot/decorative asset slipped in.
3. **Rules and witnesses:** attack exact-cardinal service, cargo direct contact, LIFO group ordering, caution restoration, disposal pairing, switch lock, retry freshness, and preflight reachability.
4. **Readability and UI:** inspect the direct Godot 1280×720 selector/briefing/build flow for reachability, label clipping, hidden text, and ambiguity between book/stage navigation; correct validated findings only.
5. **Evidence and regression:** verify exact changed head, full regression, package/candidate boundary, PR #174 untouched, unrelated open PRs untouched, and no human/release evidence is overstated.

## 8. Scope ledger, rollback, and handoff

| Category | Decision |
| --- | --- |
| Add | One selector-copy JSON, one Route Book 03 JSON, one stage-copy JSON, six authored map JSON files, targeted catalog/definition/controller/test/fixture updates, and decision/content/evidence documents after implementation approval. |
| Modify | Route Book catalog, fail-closed known-book ID table, selector copy load path, current route-book tests/fixtures, and current canonical decision/context/roadmap owners only when implementation is accepted. |
| Keep | All existing maps, book IDs, locales, art bytes, scenes, core finite rules, Candidate 010 record, first session, user-validation policy, PR #174, and unrelated PR #254. |
| Explicitly exclude | New bitmap/audio/VFX, score/rank/stars, save/unlock/progression, procedural generation, Daily/Weekly, Yard Lab/Mastery, solver/route reveal, map editor/UGC, online, economy, and Base repin. |
| Rollback | Revert the dedicated Route Book 03 implementation commit/PR; no migration, save conversion, or asset restoration is needed because the pack is nonpersistent and additive. |

## 9. Spec self-review

- **Placeholder scan:** no `TBD`/`TODO`/unowned required behavior remains.
- **Consistency:** every content condition maps to an existing finite rule; no table row assumes a new mechanic or changes an invariant.
- **Scope:** one bounded content pack plus the minimal selector-copy ownership correction; it does not bundle visual replacement, UX redesign, core systems, or release work.
- **Ambiguity resolved:** cards are all directly selectable; stage order is display/Next-only; maps allow multiple player layouts; tests own the named witness/counterexample; selector strings have a dedicated owner; no existing candidate is reused for changed bytes.

## 10. Required written-review decision

Confirm this exact specification before an implementation plan is written. The review question is deliberately narrow:

> Approve Route Book 03 `Dispatch Ledger` as six directly selectable RB13–RB18 maps, with the shared selector-copy ownership correction, zero new assets/mechanics/progression, and the stated machine-first verification boundary.

On approval, the next step is a detailed RED→GREEN implementation plan; no further design direction or content expansion is assumed.
