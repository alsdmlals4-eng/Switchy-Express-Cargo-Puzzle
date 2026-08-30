# SX-DEC-060 · Codex Godot Product Implementation Handoff

```yaml
owner_decision: SX-DEC-060
status: EXECUTED_MERGED_MAIN_VERIFIED
prepared_on: 2026-08-26 KST
planning_branch: docs/sx-dec-060-cardinal-station-service-20260826
planning_base_main: d4b3ce5454c6a30ce4f004136f91f26c7e099d44
work_instruction: v4.8 · 2026-08-26-r5.4-superset-final
implementation_plan: docs/superpowers/plans/2026-08-26-cardinal-station-service-and-reachable-network.md
design_spec: docs/superpowers/specs/2026-08-26-cardinal-station-service-and-reachable-network-design.md
decision_owner: docs/decisions/SX_DEC_060_CARDINAL_STATION_SERVICE_AND_REACHABLE_NETWORK.md
implementation_merge_pr: 188
implementation_merge_main: 740b4b9312fa27289fd62baab8dda54c68ead3a7
godot_product_implementation: MERGED_MAIN_VERIFIED · PR_188
automated_regression: PASS · 111_CASES_13461_ASSERTIONS
ci: PASS · 7_GREEN
implementation_five_pass_review: CLOSED · SX-AUD-071
notion_post_merge_readback: PASS
physical_runtime: NOT_RUN
human_validation: NOT_RUN
new_bitmap_assets_required: 0
```

This package is the historical execution bridge from GPT-owned planning/canon work to Codex-owned Godot product implementation. PR #188 executed it and merged to `main` at `740b4b9312fa27289fd62baab8dda54c68ead3a7`. Its automated evidence is recorded above; package, physical-runtime, audio, and human evidence remain separate and not run.

## 1. Required fresh-read before any edit

Codex must not trust this handoff as a frozen repository snapshot. Start from the merged current project `main`, then fresh-read:

```text
fresh Base latest completed main
Base/AGENTS.md
Base/skills/SKILL_REGISTRY.json
Base/docs/generated/BASE_ACTIVE_SKILLS.md
Project AGENTS.md
PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md
기획서/00_프로젝트_허브/START_HERE.md
기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md
기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md
기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md
기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md
docs/decisions/SX_DEC_060_CARDINAL_STATION_SERVICE_AND_REACHABLE_NETWORK.md
docs/superpowers/specs/2026-08-26-cardinal-station-service-and-reachable-network-design.md
docs/superpowers/plans/2026-08-26-cardinal-station-service-and-reachable-network.md
exact Project Notion Home: 3c41b237-eb1c-8103-9537-ede6dfc5f07e
all open/draft PRs
actual relevant code/data/tests
```

If GitHub current owners and Notion human-facing meaning disagree, stop mutation and return `CONTEXT_DRIFT_RECHECK_REQUIRED`.

## 2. User-approved gameplay delta

```text
Station delivery service:
  exactly one tile UP / RIGHT / DOWN / LEFT
  Manhattan distance == 1
  diagonal excluded

Network validity:
  the player does not need every placed rail piece to belong to one global connected network
  only the start-reachable RUN component must satisfy required cargo and station-service coverage
```

Cargo remains exact-cell contact. Unlimited LIFO / TOP-group unload behavior remains intact.

## 3. Technical implementation default

Implement the approved rule with:

```yaml
finite_map_schema: 3
station_role: OFF_TRACK_SERVICE_OBJECT
station_cell_player_track: FORBIDDEN
station_service_cells: CARDINAL_IN_BOUNDS_ONLY
cargo_role: DIRECT_CONTACT
preflight_scope: START_REACHABLE_RUN_COMPONENT
irrelevant_disconnected_track_island: ALLOWED
station_service_overlap: FAIL_CLOSED_CONTENT_ERROR
new_image_assets_for_sx_dec_060: 0
new_image_assets_for_future_work: FORBIDDEN_WITHOUT_CONCRETE_RUNTIME_CONSUMER
```

Do not generalize this into arbitrary radii or service shapes.

## 4. Reuse-first implementation seams

Use and adapt the existing product owners instead of creating parallel systems:

```text
game/finite/map/finite_map_definition.gd
  → data/schema/service-cell derivation

game/finite/map/finite_map_loader.gd
  → buildable-surface exclusion

game/finite/rail/finite_track_graph_builder.gd
  → graph creation; no station footprint rail piece in v3

game/station/station.gd
  → station match + service predicate

game/finite/delivery/finite_delivery_loop.gd
  → contact transition and unload

game/finite/build/preflight_validator.gd
  → reachable component + required coverage

game/finite/run/finite_run_session_factory.gd
  → session construction / fail-closed validation

game/demo/presentation/product_board_renderer.gd
  → procedural human-facing service projection only

game/first_session/first_session_copy.gd
  → tutorial wording only
```

No new generic service-area framework should be introduced unless an actual test forces one.

## 5. Actual image-consumer rule

The user requires production image work to be justified by a real game consumer, not explanatory sheets.

Current renderer already consumes:

```text
art/product_assets/ed_hybrid_v1/core/core_station_red_normal_v01.png
art/product_assets/ed_hybrid_v1/core/core_station_blue_normal_v01.png
art/product_assets/ed_hybrid_v1/core/core_station_yellow_normal_v01.png
```

Therefore this implementation must:

- reuse those station PNGs;
- render four-cardinal service indication procedurally first;
- add no new PNG/bitmap/image key for SX-DEC-060;
- never ask an image generator to create an explanation board or concept sheet for this implementation.

PR #188 completed this SX-DEC-060 implementation with no new bitmap, so that historical fact remains unchanged. For a later verified consumer that proves a missing bitmap slot, the current user policy is:

```yaml
automatic_consumer_image_policy: USER_APPROVED_2026_08_26
approved_image_dual_storage: PROJECT_LOCAL_AND_NOTION
visual_continuity: existing E+D Hybrid / Neo-Arcade visual language
```

Generate only the required bitmap without a separate per-image approval request; preserve the tracked project-local asset and Notion Visual/Asset record with provenance/SHA-256/readback. A real node/key/path consumer remains required.

## 6. TDD execution contract

Follow the implementation plan task-by-task. Every production behavior follows:

```text
write failing test
→ run exact test path / repository runner
→ verify expected RED
→ minimal implementation
→ run focused GREEN
→ run full regression
→ commit logical slice
```

Do not write production code first and backfill tests.

Required negative coverage includes:

```text
station cell itself: no delivery
diagonal: no delivery
distance 2+: no delivery
mismatched TOP: no unload
overlapping station service ownership: fail closed
unreachable cargo: preflight fail
unreachable station service: preflight fail
irrelevant disconnected island: preflight pass
invalid reachable route structure: still fail
invalid unreachable island: does not block active RUN
```

## 7. Map/content migration boundary

Known current active finite maps to re-inventory from current main before editing:

```text
data/maps/fp_core_proof_01.json
data/maps/vs_demo_01.json
data/maps/tutorial/tut_01_02.json
data/maps/tutorial/tut_03_lifo.json
data/maps/tutorial/tut_04_selective_load.json
data/maps/tutorial/tut_05_auto_load.json
data/maps/tutorial/tut_06_switch.json
```

This list is a starting locator, not authority. Search all current map consumers before mutation.

For each active map, change coordinates only after preserving its actual lesson. Recompute deterministic witness/layout/solution identity from the new intended bytes. Never edit expected hashes just to make a test green.

## 8. First-session boundary

Keep `T1 → T6 → VS_DEMO_01` scope. Teach the changed mental model without adding another lesson:

```text
T2:
Cargo → travel through the cargo tile to load.
Station → travel through one of its four cardinal adjacent tiles to deliver.
Diagonal adjacency does not count.
```

Maintain `ko / en / ja / zh-Hans`; `zh-Hant` remains deferred. No raw localization key may reach UI.

## 9. Protected scope

Do not modify or absorb:

- Draft PR #174;
- SX-DEC-056A Route Probe / Actual Trace / PB / Fingerprint;
- SX-DEC-056B score/max-combo;
- SX-DEC-057 Yard Labs / Mastery;
- SX-DEC-058 challenge generation/pipeline;
- legacy endless/fuel/BOOST/capacity-8/cargo-slowdown/pickup-respawn/switch-auto-reset;
- Base current authority/pin;
- existing 73 production PNG bytes in this historic SX-DEC-060 implementation; a later verified missing consumer slot follows the automatic consumer-image policy above rather than a separate per-image approval;
- score formulas or player-facing solver behavior.

If implementation requires one of these, stop that local task and return a scoped change proposal instead of expanding authority.

## 10. Candidate/evidence boundary

`SX59-POC-ACCEPT-003` is an exact pre-SX-DEC-060 artifact.

Preserve:

```text
its pointer history
its hashes
its package integrity PASS
its recorded NOT_RUN physical/human fields
```

Do not call it the acceptance candidate for post-060 runtime. A changed gameplay build requires a new candidate identity and fresh evidence.

The current post-060 candidate locator is `evidence/acceptance/post_sx_dec_060_candidate.json`; it explicitly selects `SX60-POC-ACCEPT-005` as `PREPARED_PACKAGE_VERIFIED · MACHINE_PRIMARY_ACCEPTANCE_READY` from exact `main@a11dfd1a063e434ee22e8cfb7b073ebc380aa27a`. Candidates 001–004 remain immutable historical evidence. Candidate 005's CI export, artifact/API/download hashes, runtime JSON proofs, and PCK audit are machine evidence only; final user review remains `NOT_RUN`. `PR #201` and `PR #250` are tooling-only and non-invalidating.

Allowed implementation completion claims depend on actual results. Never infer:

```text
package PASS → physical PASS
Windows PASS → Android PASS
device PASS → five-person PASS
technical PASS → player-experience PASS
```

## 11. Required verification

Use current repository commands discovered from merged main. At minimum the current project discipline expects:

```bash
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tests/run_tests.gd
python tools/validate_project_contract.py
python tests/python/test_v48_current_authority_migration.py -v
```

Also run every current SX-DEC-060 freshness/map/witness/package test introduced by the implementation and all required GitHub Actions from exact PR head.

Do not claim a command passed unless its output was actually observed for exact head.

## 12. Five-pass adversarial close

Before implementation PR merge, run at least five complete review loops:

1. gameplay semantics — cardinal math, cargo contact, LIFO/TOP, outcome;
2. topology/preflight — reachable component, irrelevant islands, station coverage, switch/crossing safety;
3. schema/content — v2/v3 boundary, all active maps, revisions/ruleset/identity/witnesses;
4. UX/assets/localization — station readability, overlay priority, existing PNG consumer, four locales, no raw keys/new images;
5. governance/evidence — current canon, Candidate 003 history, 056–058, PR #174, Base, Notion, exact evidence ceiling.

Any finding restarts the relevant review loop after correction. `CLEAN_REVIEW_EXIT` requires no unresolved current-scope finding.

## 13. Codex task prompt

```text
Implement SX-DEC-060 for alsdmlals4-eng/Switchy-Express-Cargo-Puzzle from current merged main.

Fresh-read Base completed main, project AGENTS/current decision owners/active context/development gates, exact Project Notion Home, all open/draft PRs, the SX-DEC-060 decision/spec/plan/handoff, and actual relevant code/data/tests before editing. If current GitHub and Notion meaning disagree, stop with CONTEXT_DRIFT_RECHECK_REQUIRED.

Approved gameplay:
- a matching station services the train only when abs(dx)+abs(dy)==1;
- up/right/down/left count; diagonal, station cell, and distance 2+ do not;
- cargo remains exact-cell Manual/Auto contact;
- unlimited LIFO and contiguous matching TOP-group unload are unchanged;
- unused disconnected track islands do not invalidate RUN; the start-reachable RUN component must cover every required cargo and at least one cardinal service cell for every station.

Technical default:
- migrate current finite maps to FiniteMapDefinition schema v3;
- station is an off-track non-buildable service object with no rail anchor;
- fail closed on overlapping station service ownership;
- keep cargo direct-contact behavior;
- scope structural preflight checks to the start-reachable RUN component;
- use existing station PNG consumers and a procedural service overlay; create zero new bitmap assets.

Use the implementation plan task-by-task with RED→GREEN TDD. Do not modify PR #174, implement SX-DEC-056~058, invent score/combo, repin Base, revive legacy endless mechanics, or generate images without a concrete runtime consumer. Preserve Candidate 003 as historical pre-060 evidence and mint a new candidate only from actual post-060 packaged output.

Run focused and full regression from exact head, then five complete adversarial loops. Never elevate package/CI evidence to physical/device/human/player PASS.
```

## 14. Current handoff verdict

```text
USER_RULE: APPROVED
DESIGN: COMPLETE
IMPLEMENTATION_PLAN: COMPLETE
CODEX_HANDOFF: EXECUTED
CODEX_EXECUTION: MERGED_MAIN_VERIFIED · PR_188 · main_740b4b9312fa27289fd62baab8dda54c68ead3a7
GODOT_RUNTIME_CHANGE: IMPLEMENTED_AUTOMATED · 111_CASES_13461_ASSERTIONS · CI_7_GREEN
FIVE_PASS_REVIEW: CLOSED · SX-AUD-071
NOTION_POST_MERGE_READBACK: PASS
NEW_BITMAP_IMAGE: 0
POST_060_ACCEPTANCE_CANDIDATE: SX60-POC-ACCEPT-005 · PREPARED_PACKAGE_VERIFIED · MACHINE_PRIMARY_ACCEPTANCE_READY
SX60_POC_ACCEPT_001: HISTORICAL_SUPERSEDED_BY_PRODUCT_BYTE_CHANGE
PHYSICAL_NOT_RUN
HUMAN_NOT_RUN
```
