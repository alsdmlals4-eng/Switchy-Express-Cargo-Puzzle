# Switchy Express r4 Authority & Planning Reconciliation Design

## Status

- User approval: 2026-08-25 KST
- Work mode: PLAN → BUILD → REVIEW
- Scope: documentation / authority / human-facing planning only
- Product runtime changes: FORBIDDEN in this package
- Baseline: `main` `cf207f29cd4dcabc5796769f0eb0ca6764c2370e`

## Problem

The project already has a coherent finite-delivery product baseline and an implemented SX-DEC-059 first-session vertical slice. The current delivery bottleneck is not missing feature breadth: Candidate 003 still requires physical visual recheck, developer self-run/screen QA, audio perceptual QA, Windows/Android device validation, and five-person first-contact comprehension.

However, project authority surfaces have drifted:

1. the user-provided current execution contract is v4.8 revision `2026-08-24-r4`;
2. project `AGENTS.md` and the Switchy thin adapter still identify v4.8 `2026-08-24-r2` as the current work-instruction revision;
3. the thin adapter still contains stale acceptance-candidate state predating Candidate 003;
4. `ACTIVE_CONTEXT.md` is fresher and correctly routes current validation through `SX59-POC-ACCEPT-003`;
5. Google Sheets remains compatibility/migration evidence, not a new planning workspace;
6. the Notion Human Home already separates user-facing game flow from AI/system details and should be refined rather than replaced.

This drift risks future AI/Codex work selecting stale gates even though actual implementation evidence has advanced.

## Product baseline protected by this package

The package MUST preserve GMB-002 and the current first-session meaning:

```text
track construction / encounter ordering
→ manual/auto pickup decisions
→ unlimited LIFO/TOP planning
→ run-time branch/switch execution
→ finite success/failure result
→ same-layout fresh Retry or Edit
```

Current first-session:

```text
T1 Track Connection
→ T2 Cargo/Station + manual pickup prerequisite
→ T3 LIFO/TOP reverse planning
→ T4 selective non-load + revisit
→ T5 Auto ON safe / OFF decision
→ T6 switch execution
→ VS_DEMO_01 Capstone
→ Result / Retry / Edit
```

No 056A/056B/057/058 implementation is authorized here. No endless/fuel/BOOST/capacity-8/cargo-slowdown/pickup-respawn/switch-auto-reset behavior may be reintroduced.

## Chosen approach

### Option A — Authority-first → Human-flow-first → validation-first — SELECTED

Reconcile r4 authority and current Candidate 003 state first, then improve the human-facing planning projection in Notion, then preserve the exact existing physical/human validation route.

Why selected:

- lowest long-term rework risk;
- prevents stale authority from contaminating later work;
- improves player/product understanding without inventing features;
- keeps Notion/GitHub domain split intact;
- supports the current Implementation Reality Gate instead of bypassing it.

### Option B — Validate Candidate 003 first, docs later — REJECTED FOR THIS PACKAGE

Useful for evidence speed, but leaves r2/r4 and Candidate-state drift in place during execution and conflicts with the approved planning-first goal.

### Option C — Re-plan deferred breadth now — REJECTED

Would expand campaign/meta/challenge scope before current physical/human evidence exists. This violates the current evidence ceiling and adds content/maintenance cost before the first-session product hypothesis is validated.

## Fresh benchmark trade study

Observed 2026-08-25 from public Steam/store/developer-facing material:

### Railbound — ADAPT

- Steam presents it as a train-connection puzzle with 240+ puzzles and a level editor.
- All-time Steam reviews remain strongly positive (about 94% positive at observation time).
- Applicable principle: teach a compact rule set through authored puzzle progression and make connection state legible.
- Do NOT copy its exact puzzle grammar or presentation.

Source: https://store.steampowered.com/app/1967510/Railbound/

### Mini Metro — ADAPT PRINCIPLE / REJECT PRODUCT LOOP

- Uses a small number of clear actions (connect, redraw, allocate limited resources) to produce a large decision space.
- Steam English reviews remain overwhelmingly positive (about 95% positive at observation time).
- Applicable principle: preserve a small player verb set and high information clarity.
- Reject its endless-survival loop because Switchy is explicitly a finite handcrafted puzzle.

Source: https://store.steampowered.com/app/287980/Mini_Metro/

### Train Valley 2 — ADAPT LATER

- Builds progressively more complex railway challenges and rewards perfection-oriented replay.
- English Steam reviews remain very positive (about 90% positive at observation time).
- Applicable principle: multiple optimization goals can support replay after core comprehension is proven.
- Do not overload the first-session slice with mastery/meta systems.

Source: https://store.steampowered.com/app/602320/Train_Valley_2/

### Rail Route — REFERENCE / REJECT CURRENT BREADTH

- Its product scope includes construction, dispatching, upgrading, automation, maps, and broader management/sandbox features.
- English all-time Steam reviews are positive, while recent reviews were Mixed around the observation window.
- This does not prove breadth caused the recent rating pattern; causality is not claimed.
- Applicable lesson: broad automation/economy/management is a different product-cost envelope and should not be absorbed before Switchy's first-session evidence closes.

Source: https://store.steampowered.com/app/1124180/Rail_Route/

## Repository changes

### 1. `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md`

Make it a current r4 thin adapter without copying the full user contract.

Required changes:

- revision locator: `2026-08-24-r4`;
- explicitly identify the uploaded/user-provided r4 as the current project execution contract revision;
- preserve the existing r2 source hash only as provenance where relevant; do not falsely label it as the r4 hash;
- route r4-specific fresh-shell/update/shared-toolchain behavior to the current Base owners rather than duplicating the entire contract;
- update current evidence ceiling to Candidate 003 and its exact known state;
- keep physical/human/player evidence fail-closed;
- preserve deferred-package boundaries.

### 2. `AGENTS.md`

Apply the smallest current-authority correction:

- current work-instruction revision becomes r4;
- source/hash wording must not pretend the old r2 hash identifies r4;
- current validation route must resolve through Candidate 003 / Active Context;
- keep root-level rules concise and progressive-load detailed owners.

### 3. `ACTIVE_CONTEXT.md`

Only freshness corrections required by this package:

- update work-instruction locator from r2 to r4;
- preserve live-main refresh policy and current Candidate 003 state;
- add this reconciliation package as authority/planning work only after merge/readback is actually known.

Do not rewrite runtime evidence.

### 4. New benchmark/planning evidence owner

Create a repository planning evidence note for this decision, preserving:

- source date;
- source class;
- observed fact vs inference;
- ADOPT / ADAPT / TEST / REJECT / REFERENCE_ONLY disposition;
- explicit causality limits;
- conclusion: feedback/evidence-first, no deferred breadth expansion before human evidence.

## Notion changes

Human Home remains the player/product learning surface, not an AI status board.

### Home projection

Keep/strengthen:

1. **What game is this?** — one-sentence player promise.
2. **Whole game flow** — Title → Build → Preflight → Run → Result → Retry/Edit.
3. **First-session learning flow** — T1→T6→VS_DEMO_01.
4. **Why the loop is interesting** — route planning + pickup order/LIFO + execution-time switching + redesign from feedback.
5. **Evidence ladder** — automated/package ≠ physical ≠ human comprehension ≠ player experience.
6. **Detailed domains** — Direction / Puzzle Systems / Visual / Production / Reference.

Do not put CI logs, SHA inventories, prompt/debug metadata, or long task logs on Human Home.

### Direction / Benchmark projection

Record the benchmark conclusion as human-facing rationale, while raw/source details remain in the Reference/Benchmark domain and GitHub evidence owner.

## Implementation Reality Gate

This package can prove:

```text
GitHub file mutation
→ branch readback
→ PR exact-head diff/checks
→ merge
→ new-main readback
→ Notion destination update/readback
```

This package CANNOT prove:

```text
Candidate 003 physical appearance PASS
Windows full physical runtime PASS
Android device PASS
five-person comprehension PASS
player experience PASS
```

Those remain NOT_RUN unless separately executed with the exact acceptance candidate/build.

## Verification

### RED

Before correction, project contract checks/readback must demonstrate at least these stale facts:

- project AGENTS/thin adapter current revision still says r2;
- thin adapter acceptance state predates Candidate 003.

### GREEN

After correction:

- all current locator surfaces agree on r4;
- all current validation locator surfaces resolve through Active Context / Candidate 003;
- no deferred package is authorized by accident;
- no product runtime file changes exist;
- Notion Human Home remains human-facing and System detail remains separated.

## Adversarial review minimum

At least five whole-state passes after mutation:

1. authority/provenance drift;
2. stale evidence/candidate inflation;
3. Notion human-vs-system boundary;
4. benchmark causality/feature-creep pressure;
5. implementation/runtime scope leakage and untouched consumers.

Any valid finding is corrected and rechecked before merge.

## Completion

Completion candidate requires:

- exact branch/PR HEAD reviewed;
- repository required checks observed and satisfied for this change class;
- blocking review finding = 0 after minimum five passes;
- merge completed without bypass/force;
- new `main` readback confirms r4/current-candidate alignment;
- Notion destination readback confirms the human-facing projection;
- remaining Candidate 003 physical/human/player gates are still clearly marked NOT_RUN.
