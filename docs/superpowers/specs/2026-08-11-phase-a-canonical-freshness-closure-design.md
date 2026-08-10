# Phase A Canonical Freshness Closure Design

Status: `USER_APPROVED · PLANNING_ONLY · NO_NEW_PRODUCT_DECISION`

Approval basis: user approved the recommended continuity/freshness repair direction on 2026-08-11 KST and requested continuous work.

## 1. Goal

Close the remaining Phase A documentation and Google Sheet freshness drift without changing Switchy Express gameplay, runtime behavior, product assets, semantic manifests, Base pin, or physical-validation status.

This is a bounded recurrence repair under existing `SX-AUD-035`. It does not create a new Decision ID and does not promote any `NOT_RUN` physical/device/human gate to PASS.

## 2. Current authority baseline

Repository authority at design freeze:

```yaml
repository: alsdmlals4-eng/Switchy-Express-Cargo-Puzzle
base_branch: main
baseline_main: a44891a903a384f8e1fb23e3eb9f53c241934119
open_project_prs: 0
current_decision_span: SX-DEC-027~055
runtime_semantic_authority: SX-DEC-055
runtime_semantic_state: USER_DEFERRED_AFTER_DOR · GODOT_IMPLEMENTATION_NOT_STARTED
semantic_product_assets: 73_TOTAL · PRODUCTION_COMPLETE
runtime_integrated: false
project_base_pin: v9.4.3
upstream_base_reference_main: 315c66eea9614c284b9c11c4d522141065dfa4b0
upstream_base_is_reference_only: true
windows_physical_runtime: NOT_RUN
android_device_smoke: NOT_RUN
connected_physical_editor: NOT_RUN
broader_human_comprehension: NOT_RUN
production_cutover: BLOCKED_DEFERRED
```

Canonical current-state owners:

- `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
- `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
- `기획서/00_프로젝트_허브/START_HERE.md`
- configured Google Sheet `1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo`
- `docs/decisions/SX_DEC_055_RUNTIME_SEMANTIC_POC.md`

## 3. Validated findings

### MUST_FIX-1 — `CORE_SYSTEMS.md` current-next-work drift

The product/system rules remain valid, but the bottom implementation/evidence section presents the historical canonical Android APK evidence as if Android device smoke is the immediate current task. That conflicts with `CURRENT_CONFIRMED_DECISIONS` and `ACTIVE_CONTEXT`, which place SX-DEC-055 at approved/spec/DoR-ready but user-deferred and implementation-not-started.

Repair:

- preserve all product-system rules;
- label the APK/automated block as historical/bounded evidence;
- add a current-state locator pointing to `CURRENT_CONFIRMED_DECISIONS` / `ACTIVE_CONTEXT`;
- keep Android/human gates `NOT_RUN` without calling them the immediate work item.

### MUST_FIX-2 — `DEVELOPMENT_GATES.md` implemented feature still marked pending

`PC4A` still says `PENDING`, while SX-DEC-041/042/046 are merged, automated PASS, and have feature-scoped user F5 evidence. This can cause a cold-start agent to repeat already-completed gameplay work.

Repair:

- promote only PC4A's feature implementation/automated state to the exact current evidence ceiling;
- preserve Windows/Android/human gates as open;
- update the current transition so it does not imply PC4A implementation is pending;
- do not reinterpret Base v9.4.3 pin or old Base PR #94 history.

### MUST_FIX-3 — `VERTICAL_SLICE_CONTRACT.md` contradictory PR/branch snapshot

The contract still says `PR #83은 현재 Draft` even though the same repository's `DEVELOPMENT_GATES.md` records PR #83 as merged. It also uses an obsolete feature branch as the active user handoff path.

Repair:

- preserve the first vertical-slice product and manual-gate contract;
- explicitly classify the old commit/APK/CI records as historical evidence;
- set active checkout/handoff branch to `main` and current-main source to `LIVE_GITHUB_DEFAULT_BRANCH`;
- replace the obsolete PR #83 draft merge gate with historical merged status plus current generic future-PR conditions;
- keep full PC physical runtime / Windows artifact runtime / Android / human boundaries unclosed.

### SHOULD_FIX-1 — Sheet current GDD metadata drift

`05_GDD_요약` current rows still use the 2026-08-04 main SHA and pre-runtime-replanning wording despite the later SX-DEC-049~055 authority.

Repair:

- preserve the six product summaries;
- refresh only current operational metadata and next-check fields;
- add one current module for the approved semantic asset/runtime POC boundary instead of rewriting historical GDD rows.

### SHOULD_FIX-2 — Sheet production/validation current-row gap

`50_제작_검증` has older Android/FP rows but no current SX-DEC-055 execution-boundary row.

Repair:

- preserve historical rows as history;
- add one current row describing SX-DEC-055 DoR-ready/user-deferred state and the open physical/device/human ceilings;
- reuse the same `SX-DEC-055` / `SX-AUD-035` authority rather than creating a new decision.

## 4. Protected invariants

The repair must not change:

- finite handcrafted delivery puzzle identity;
- free track construction and full BUILD refund rules;
- unlimited LIFO stack semantics or TOP contiguous unload semantics;
- route topology, route-end priority, U-turn, occupied lock, or switch-control rules;
- scoring, time limit, save/ruleset identity, retry identity, map content, campaign, or challenge rules;
- 73 approved product PNG bytes or any semantic/product manifest;
- historical `runtime_integrated=false` provenance;
- `project.godot`, `.gd`, `.tscn`, addon, workflow, or binary asset bytes;
- Base v9.4.3 project pin;
- any physical/device/human PASS status.

## 5. File-level design

### GitHub files to modify

1. `기획서/20_시스템_콘텐츠/CORE_SYSTEMS.md`
   - separate current product contract from historical automated/APK evidence;
   - replace immediate Android-next-work wording with current authority locator and open-gate statement.

2. `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md`
   - update PC4A from pending to merged/automated/user-feature evidence;
   - refresh the PC transition so it starts from current live main and remaining manual gates;
   - retain Android, human, Windows artifact, and Base adoption boundaries.

3. `기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md`
   - mark old automated package/branch/PR values as historical evidence;
   - route current state to `CURRENT_CONFIRMED_DECISIONS` and `ACTIVE_CONTEXT`;
   - remove the false current-Draft claim for PR #83;
   - use `main` / live-default-branch semantics for current handoff.

### New planning artifacts

- this design spec;
- `docs/superpowers/plans/2026-08-11-phase-a-canonical-freshness-closure.md`.

### Google Sheet updates

- `05_GDD_요약`: refresh current metadata and add current semantic/runtime boundary row;
- `50_제작_검증`: add current SX-DEC-055 validation/implementation boundary row;
- `00_프로젝트_허브` / `01_작업순서`: retain the already-corrected current values unless post-merge GitHub evidence requires a same-ID refresh.

## 6. Validation design

Before PR creation:

1. compare branch against frozen main and confirm changed scope is docs/planning only;
2. search changed docs for contradictory current phrases such as `PR #83은 현재 Draft`, `PC4A ... PENDING`, and immediate Android-next-work wording;
3. verify current owner statements still report SX-DEC-055 runtime implementation `NOT_STARTED` and physical/device/human gates `NOT_RUN`;
4. re-read the Google Sheet current ranges after writes;
5. create a PR and require applicable Project Contract, GUT, Godot, Thin Adapter, and any docs/static checks that GitHub actually triggers;
6. review changed filenames, diff, and unresolved review threads before merge;
7. do not claim skipped/non-triggered checks as PASS;
8. after merge, re-read new `main`, open PRs, current owner docs, and Sheet for post-merge adversarial closure.

## 7. Acceptance criteria

- no new product/gameplay/semantic decision is introduced;
- no runtime/product/asset/manifest byte changes exist;
- active current docs no longer contradict PR #83 merge state or SX-DEC-041/042 implementation state;
- `CORE_SYSTEMS` no longer presents Android device smoke as the sole immediate project task;
- GDD and production Sheet current surfaces can route a cold-start worker to SX-DEC-055 without erasing historical evidence;
- GitHub and Sheet preserve the same current Decision IDs and evidence ceilings;
- branch/PR verification is fresh and exact-head before any completion or merge claim.
