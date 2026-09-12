# Stage thinking briefs implementation plan

> Execute task-by-task using superpowers:executing-plans. User explicitly delegates benchmark -> specification -> implementation -> verification -> reassessment loops, preserving core and approved assets. Results tracked in evidence/runtime/stage-thinking-20260913/README.md; this is the preimplementation checklist.

**Goal:** Turn the existing twelve stage concepts into concrete player-facing planning questions without revealing a route or changing success conditions.
**Architecture:** Reuse each stage's existing context_key and the localized FirstSessionCopy loader. Connect those fields to the existing BriefingScreen Rules label, as tutorial cards already do. The stage definition owns the key, existing locale JSON owns copy, and DemoFlowController only displays it.
**Tech Stack:** Godot 4.7.1, GDScript, schema-v1 route books, ko/en/ja/zh-Hans.
**Spec:** Latest approved core-preserved replan and user's continuous benchmark-led completion direction.

## Authority / boundaries

Source main 913309def20aad70e6af416a2c158e24766d6989 (PR291 complete), Base observed d830c0f6967678eed3c208ac6b24f9cd1b262ec3. No repin. Existing isolated worktree, preserve dirty imports/project settings and read-only PR174/254/281. No solver, achievements, capacity, RUN rewind, new stage IDs, altered maps/time budgets or new art. Native crash remains separately unresolved; a passing content test is not an engine fix.

## Benchmark comparison (official sources read 2026-09-13)

| Source | Observed pattern | Disposition / project difference |
|---|---|---|
| https://www.trainyard.ca/solutions/faq | Many possible player solutions; discovery of one's own solution is central | ADAPT: use planning questions, not route coordinates or a compulsory witness |
| https://store.steampowered.com/app/1967510/Railbound/ | Gentle main progression and more challenging branches; track puzzles combine mechanisms | ADAPT: basic order -> combined existing mechanisms; no tunnels or new collision rules |
| https://cosmicexpressgame.com/ | Train-route planning is the central premise | ADOPT focus on route planning; source does not establish specific hint/undo behavior |

Three viable presentation alternatives: (A) concise questions in existing briefing Rules (selected: no new interaction or persistent HUD obstruction), (B) always-visible planning sidebar (defer: board space/overlap cost), (C) optional expandable hints (defer: more input/localization/state maintenance). No claimed user-comprehension or sales causality.

## Concrete content design

| Stage | Core decision made explicit | Guardrail |
|---|---|---|
| RB01 | Cargo exact cell vs station cardinal service | Never station footprint |
| RB02 | First delivery determines useful TOP | No prescribed route |
| RB03 | Revisit and temporarily skip a load | Keep manual choice |
| RB04 | Safe auto-loading window vs unwanted TOP | No mandatory toggle count |
| RB05 | Choose switch before occupancy | No auto-reset |
| RB06 | Stack order, service and branch composition | No score target |
| RB07 | Buildable ground among blocked decor | Do not invent decorative collision |
| RB08 | Short distance vs slow traversal | No new time limit |
| RB09 | Waste TOP blocks normal delivery until removed | Unlimited stack preserved |
| RB10 | Return trip and optional loading | Witness is not unique solution |
| RB11 | Disposal destination and early branch choice | Occupied lock preserved |
| RB12 | Combine waste, delay and three cargo identities | No additional winning constraint |

## Task 1: RED -> content/consumer integration

Files: data/route_book/route_book_01.json, route_book_02.json; data/localization/route_book_01_v1.json, route_book_02_v1.json; game/demo/demo_flow_controller.gd; tests/demo/test_route_book_context.gd; tests/run_tests.gd.

- [ ] Instantiate actual demo, select all twelve stages in four locales; assert Rules visible/nonempty/no raw key and changes with stage. Example: open_route_book(); select_route_book(&"ROUTE_BOOK_02"); select_route_book_stage(&"RB09_SALVAGE_SIDING"); assert_true(rules.visible); assert_false(rules.text.is_empty()).
- [ ] Run full custom runner, confirm failure is missing context, not parse/setup error.
- [ ] Populate twelve context_key values and localized questions; reuse FirstSessionCopy.text. In _apply_route_book_card: rules.text = _route_book_copy.text(StringName(stage.get("context_key", &"")), first_session_locale); rules.visible = not rules.text.is_empty(). Empty context must clear previous content.
- [ ] Run full regression; ensure next-stage selection refreshes context and fixed stage/map identities unchanged.

## Task 2: Review and correction loop

- [ ] Five passes: factual stage fit, no solution/mandatory-goal leak, localization completeness, input/lifecycle freshness, responsive visual evidence and limits.
- [ ] Actual main run: select waste stage, capture briefing, begin stage and verify exact map; return/select another stage and confirm no stale copy. Correct findings and rerun affected/full tests.
- [ ] Update existing Active Context/Decisions/Roadmap with continuous loop definition and next gap, not a new dashboard. Publish implementation learning to existing replan owner.
- [ ] Exact branch checks -> normal merge -> main readback. Physical/human/release remain separate. No Base promotion without cross-project validation.

Rollback: scoped normal revert of context fields/copy/consumer/test; no save or map migration.
