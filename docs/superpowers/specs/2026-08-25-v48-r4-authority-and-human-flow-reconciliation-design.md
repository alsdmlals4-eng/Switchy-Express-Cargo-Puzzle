# Switchy Express v4.8 r4 Authority and Human Flow Reconciliation Design

Date: `2026-08-25 KST`  
Approval: `USER_APPROVED · 2026-08-25`  
Tracking: `SX-AUD-070`  
Work Mode: `PLAN → BUILD → REVIEW`

## 1. Goal

Synchronize Switchy Express with the user-provided `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION v4.8 · 2026-08-24-r4` without changing product gameplay, then improve the Notion Human Home so a player/developer can understand the full game loop, first-session learning path, visual language, and current evidence boundary without reading AI/CI metadata.

This package is an authority/planning reconciliation. It is not a new gameplay Decision.

## 2. Exact authority baseline

```yaml
project_repository: alsdmlals4-eng/Switchy-Express-Cargo-Puzzle
project_baseline_main: cf207f29cd4dcabc5796769f0eb0ca6764c2370e
base_latest_completed_main_observed: ceb83c680f76fead5811956bd6503fd5e4da8577
user_contract_version: 4.8
user_contract_revision: 2026-08-24-r4
user_contract_file_sha256: 1426c2e5e25e32dc72abccf49e4a0839578e54c14b38ba0de045be426fd63ea6
prior_r2_source_sha256: 6f0541048e084746f6777223521361d0339dbfb2e223c70947f694f1c050f508
product_baseline: GMB-002
current_decisions: SX-DEC-027~059
current_candidate: SX59-POC-ACCEPT-003
physical_visual_recheck: NOT_RUN
player_experience: NOT_RUN
```

Current project sources remain subordinate to fresh runtime/repository evidence and the latest Base owners. Historical Base v9.4.3 and v4.8 r2 identities remain provenance/rollback evidence only.

## 3. Problem statement

The project already adopted v4.8 r2 and Candidate 003 post-merge canon, but current entry surfaces still contain two stale authority signals:

1. `AGENTS.md`, `README.md`, and the v4.8 Switchy adapter identify `2026-08-24-r2` as current work-instruction revision.
2. The v4.8 Switchy adapter still identifies `SX59-ACCEPT-001` and the older post-059 validation sequence, while `ACTIVE_CONTEXT.md` already identifies `SX59-POC-ACCEPT-003` as the current candidate and keeps its physical visual recheck fail-closed.

The Notion Human Home is structurally correct but can communicate the full game loop more directly. It currently shows the T1→T6 first-session chain, yet the relationship between BUILD, preflight, RUN, LIFO/switch decisions, delivery result, and Retry/Edit can be more explicit for a human reader.

## 4. Protected product meaning

This package MUST NOT change:

- `GMB-002` finite cargo puzzle core;
- free rail construction / full refund;
- structural preflight before RUN;
- manual load default / auto-load toggle;
- unlimited LIFO stack and TOP-group unload;
- direct reciprocal switch control with occupied lock;
- time failure, `ROUTE_END`, all-delivered success;
- same-layout fresh-runtime Retry and Edit;
- `SX-DEC-056A/056B/057/058` authorization states;
- score/combo formulas, maps, gameplay data, Scene, Resource, product assets, audio bytes, save/schema, or player-facing solver;
- physical, device, audio-perceptual, human, or player-experience evidence ceilings.

No new image generation is authorized. Existing approved visuals may be referenced/reused; generation/editing remains behind the explicit image approval gate.

## 5. Domain split

### GitHub / runtime

Owns:

- work-instruction identity and project thin adapter;
- structured current candidate/evidence locator;
- tests that reject stale r2/current-candidate claims;
- audit record `SX-AUD-070`;
- actual code/data/Scene/Resource/test/runtime truth.

### Notion Human Home

Owns the human-readable projection:

- what the game is;
- full game flow;
- why the loop is interesting;
- first-session T1→T6→Capstone learning path;
- visual/UX meaning and approved-asset reuse;
- concise evidence boundary and next validation gate;
- drill-down links to Direction / Puzzle / Visual / Production / Benchmark.

Detailed SHA, CI runs, hash, prompt, connector routing, and AI work logs remain outside the Human Home.

### Google Sheets

Remains `MIGRATION_ONLY_UNTIL_REMOVAL`. It is read for unique legacy material and conflict detection only; this package writes no new planning/approval data to the Sheet.

## 6. Existing Solution First

A prior plan already implemented the r2 v4.8 migration:

`docs/superpowers/plans/2026-08-24-v48-current-authority-reconciliation.md`

Reuse the existing adapter, regression test, Human Home hierarchy, and Candidate evidence model. Do not create a parallel adapter, dashboard, Sheet workflow, or new project-management surface.

Disposition:

```yaml
prior_v48_r2_migration: ADAPT
existing_v48_adapter: REUSE_AND_UPDATE
existing_v48_regression_test: REUSE_AND_STRENGTHEN
existing_notion_home: REUSE_AND_REFINE
new_gameplay_system: REJECT
new_dashboard_or_sheet_workspace: REJECT
```

## 7. Trade study

### Option A — authority-first → Human-flow-first → validation-first

Selected.

- Correct r4/current-candidate authority first.
- Strengthen executable regression coverage.
- Improve the Human Home by projection, not duplication.
- Keep physical/human validation as the next product gate.

Benefits: lowest drift/rework risk, preserves product focus, makes future AI/Codex routing safer.  
Cost: no new player-visible gameplay feature in this package.

### Option B — physical Candidate 003 validation first, docs later

Rejected for this package. It would leave the known r2/current-candidate routing drift active during the validation workflow and conflicts with the user-approved planning-first order.

### Option C — reopen broad product planning / 056~058 now

Rejected. It expands scope before current first-session physical/human evidence exists and increases maintenance/content cost without resolving the immediate evidence bottleneck.

## 8. Benchmark synthesis · observed 2026-08-25

Evidence is directional, not causal proof.

- **Mini Metro** — Steam describes a small rule set around drawing lines, moving trains, and allocating limited resources; current English reviews remain 95% positive. `ADAPT`: preserve a small set of legible decisions rather than add breadth.
- **Railbound** — Steam remains 94% positive overall. Afterburn described Railbound as a more dynamic puzzle where the player prepares the field and watches action unfold, and reported regular playtests plus significant effort on in-engine visual clarity. `ADAPT`: strengthen prepare → execute → observe feedback and human readability.
- **Train Valley 2** — Steam positions increasingly complex railway challenges and currently shows 90% positive English reviews. `ADAPT`: progression and mastery can deepen later, but first-session comprehension comes first.
- **Rail Route** — Steam combines construction, dispatch, upgrades, automation, and management; current recent reviews are Mixed around 67–68% positive while English all-time reviews are 84% positive. `REFERENCE_ONLY/REJECT_NOW`: review score does not prove complexity is the cause, but the breadth is not evidence to expand Switchy before first-session validation.

Sources:

- https://store.steampowered.com/app/287980/
- https://store.steampowered.com/app/1967510/
- https://store.steampowered.com/app/602320/
- https://store.steampowered.com/app/1124180/
- https://gameworldobserver.com/2022/06/03/afterburn-railbound-making-of-interview

## 9. Repository design

### 9.1 Regression contract

Strengthen `tests/python/test_v48_current_authority_migration.py` so it fails if:

- the current project adapter is not `2026-08-24-r4`;
- the exact r4 source file hash is not recorded;
- `AGENTS.md` or `README.md` still advertise r2 as current;
- the current adapter still advertises Candidate 001 instead of Candidate 003;
- the current validation sequence omits Candidate 003 Gate 0 / developer self-run / audio perceptual QA / Windows / Android / five-person evidence separation;
- any deferred 056~058 package becomes authorized by this migration.

Observed RED must precede the adapter/entry-owner GREEN implementation.

### 9.2 Current entry owners

Update only the existing owners:

- `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md`
- `AGENTS.md`
- `README.md`
- `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md` only for r4 locator/freshness metadata; preserve Candidate 003 evidence bytes and next physical gate.

Historical v4.7 and r2 provenance remains discoverable; do not copy the full r4 contract into the adapter.

### 9.3 Audit owner

Create:

`기획서/50_제작_검증/SX_AUD_070_V48_R4_AUTHORITY_AND_HUMAN_FLOW_RECONCILIATION.md`

It records baseline, r4 delta, benchmark disposition, RED/GREEN evidence, IRG ceiling, five-pass adversarial review, PR/merge identity, Notion readback, and remaining physical/human gates.

## 10. Notion Human Home design

Preserve the existing `Switchy Express · Home` and its five L2 domains. Refine the top of Home into a learning surface with this information order:

1. **10-second promise** — design the encounter order with track, construct LIFO through pickup choices, execute through switches, learn from the result.
2. **Full game flow** — Title/Briefing → BUILD → Preflight → RUN → Pickup/LIFO/Switch decisions → Delivery/Terminal → Result → Retry Same Layout or Edit.
3. **Decision loop** — Plan → Commit → Observe → Diagnose → Re-design.
4. **First-session curriculum** — T1 Track → T2 Cargo/Station → T3 LIFO/TOP → T4 Selective non-load/revisit → T5 Auto safe/off decision → T6 switch execution → VS_DEMO_01 Capstone.
5. **Visual language** — approved E+D Hybrid assets are already consumed in Board/HUD/Title/Lesson/Result; color is reinforced with shape/text/state; Reduced Motion preserves meaning.
6. **Evidence boundary** — automated/package PASS does not equal Candidate 003 physical visual PASS or player-experience PASS.
7. **Drill-down** — keep existing five L2 Domain links.

Use Notion-native text, callouts, table, and Mermaid diagram. Do not create new images.

## 11. Implementation Reality Gate

Claims are bounded as follows:

```text
DISCOVERY: r4 contract / project main / Base main / Notion / Sheet read
→ IMPLEMENTED: branch files + Notion content actually changed
→ EXECUTED: repository tests / PR workflows actually run
→ DURABLE READBACK: exact branch/PR/new-main and Notion destination re-fetched
→ RUNTIME/HUMAN: NOT_APPLICABLE for this docs-only package; existing Candidate 003 physical/human gates remain NOT_RUN
```

No repository/Notion write is considered complete until destination readback succeeds.

## 12. Acceptance criteria

- Current project work-instruction locator says `v4.8 · 2026-08-24-r4`.
- Exact user r4 file SHA-256 `1426c2e5...63ea6` is recorded in the thin adapter/regression contract.
- Candidate 003 is the current acceptance target everywhere this package touches.
- Candidate 002 remains historical physical evidence and Candidate 001 remains superseded history where referenced.
- GMB-002 and 056~058 product authorization states do not change.
- No `game/**`, Scene, Resource, gameplay data, product image/audio, or runtime behavior changes.
- Notion Human Home visibly explains the full game loop and learning path without AI/CI metadata becoming the main content.
- Google Sheets receives no new planning changes.
- Exact-head repository checks required for the actual change class pass.
- At least five full adversarial loops complete; new blocking findings are zero after the minimum.
- PR is safely merged without bypass/force, then new `main` and Notion are re-read.
- Candidate 003 physical/audio/device/human/player gates remain explicitly `NOT_RUN` unless separately executed.

## 13. Rollback

- GitHub: revert the single current-task merge; historical r2/v4.7 evidence remains available in Git history and retained files.
- Notion: restore only the bounded Home section from the pre-change readback; child Domain pages are not deleted or reparented.
- No runtime/save migration rollback is required because runtime bytes are out of scope.

## 14. Revisit conditions

Reopen this design only if:

- Base changes the thin-adapter/domain-split/IRG owner contract materially;
- a newer user work-instruction revision supersedes r4;
- Candidate 003 physical/human evidence changes the product direction;
- the Notion Home no longer projects the current full game flow;
- 056~058 receives separate user implementation authorization.
