# SX-AUD-070 · r4 Authority & Planning Reconciliation

- Date: 2026-08-25 KST
- Baseline main: `cf207f29cd4dcabc5796769f0eb0ca6764c2370e`
- Current task branch: `docs/r4-authority-planning-reconciliation-20260825`
- Work mode: PLAN → BUILD → REVIEW
- Product runtime scope: **UNCHANGED / OUT OF SCOPE**
- User approval: APPROVED 2026-08-25 KST

## 1. Goal

Align the project execution authority with the user-provided v4.8 revision `2026-08-24-r4`, remove stale Candidate 001/r2 current locators, preserve GMB-002 and deferred-package boundaries, and keep Notion as the human-facing game-flow/learning surface.

## 2. RED evidence observed before correction

Fresh branch readback from baseline showed:

1. `AGENTS.md` named `2026-08-24-r2` as current.
2. `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md` named r2 as current.
3. the thin adapter still used `acceptance_candidate: SX59-ACCEPT-001`.
4. `ACTIVE_CONTEXT.md` already routed the current validation target to `SX59-POC-ACCEPT-003`.
5. `README.md`, `START_HERE.md`, `ROADMAP.md`, `DEVELOPMENT_GATES.md`, and `CURRENT_CONFIRMED_DECISIONS.md` contained current-authority r2 locators.
6. current authority tests also hard-coded r2 expectations.

This was a real cross-owner authority drift, not a hypothetical cleanup.

## 3. Fresh Base / project authority recovery

- Base current completed-main observation at task start: `ceb83c680f76fead5811956bd6503fd5e4da8577`.
- Project current main at task start: `cf207f29cd4dcabc5796769f0eb0ca6764c2370e`.
- Open project PRs at task start: none.
- Google Sheet was re-read as migration/compatibility evidence and not promoted back to active planning authority.
- Notion Human Home was re-read and already contained the intended user-facing whole-game flow and T1→T6→Capstone learning map.

## 4. Decision trade study

### A. Authority-first → Human-flow-first → validation-first — SELECTED

Player value:
- prevents stale instructions from contaminating later validation/build work;
- keeps the current first-session hypothesis intact;
- improves human understanding without adding mechanics.

Implementation/maintenance cost:
- bounded to documentation, contract tests, and Notion planning surfaces;
- no runtime/Scene/Resource/asset migration.

Rollback:
- revert this single docs/authority PR.

### B. Candidate 003 validation first, documentation later — REJECTED FOR THIS PACKAGE

Advantage: faster path to physical evidence.

Rejection reason: would run the next gate while current owner surfaces still disagree on r2/r4 and Candidate identity. The user explicitly approved planning/authority reconciliation first.

### C. Re-plan/implement 056–058 breadth now — REJECTED

Advantage: expands long-term content/meta scope.

Rejection reason: current physical/human/player evidence remains open. Adding breadth before first-session evidence closes increases content and maintenance cost and risks hiding the core planning problem.

## 5. Fresh market / benchmark evidence

Observation date: `2026-08-25`.

Popularity/review ratios are treated as exploration signals only. No causality is inferred from review scores alone.

### Railbound — ADAPT

Source: `https://store.steampowered.com/app/1967510/Railbound/`

Observed fact:
- Steam describes it as a train-connection puzzle with 240+ puzzles and a level editor.
- Overall user review state was strongly positive at observation time (about 94% positive).

Project applicability:
- authored progression can teach a compact rule set;
- connection state must be visually legible.

Disposition: `ADAPT`.

### Mini Metro — ADAPT PRINCIPLE / REJECT LOOP

Source: `https://store.steampowered.com/app/287980/Mini_Metro/`

Observed fact:
- Steam describes a small verb set: draw/redraw routes and allocate limited resources.
- English review state was overwhelmingly positive at observation time (about 95% positive).

Project applicability:
- keep player verbs small while preserving a large decision space.

Disposition:
- `ADAPT` small-verb/high-decision-space principle;
- `REJECT` endless-survival product loop because Switchy is a finite handcrafted puzzle.

### Train Valley 2 — ADAPT LATER

Source: `https://store.steampowered.com/app/602320/Train_Valley_2/`

Observed fact:
- Steam describes increasingly complex railway challenges and a progression structure that supports perfection-oriented replay.
- English review state was very positive at observation time (about 90% positive).

Project applicability:
- multiple optimization goals can support replay after core comprehension is proven.

Disposition: `ADAPT_LATER`.

### Rail Route — REFERENCE / CURRENT BREADTH REJECT

Source: `https://store.steampowered.com/app/1124180/Rail_Route/`

Observed fact:
- product scope includes construction, dispatching, upgrading, automation, and broader management/sandbox features.
- English all-time reviews were positive while the recent review window was Mixed around observation time.

Causality limit:
- this evidence does **not** prove product breadth caused the recent rating pattern.

Project applicability:
- automation/economy/management represents a different scope and maintenance envelope.

Disposition: `REFERENCE_ONLY` for breadth comparison; `REJECT_CURRENT_BREADTH` before current Human evidence closes.

## 6. Implemented repository corrections

Current branch changes include:

- `AGENTS.md` → r4 current locator + Candidate 003 evidence ceiling.
- `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md` → r4 thin adapter; r2 hash preserved only as historical provenance; r4 fresh-shell/update/shared-Godot overlay routed without copying the full Base contract.
- `README.md` → r4/current Candidate 003 route.
- `START_HERE.md` → r4/current Candidate 003 route.
- `CURRENT_CONFIRMED_DECISIONS.md` → r4 current execution authority.
- `ACTIVE_CONTEXT.md` → r4 work-instruction locator while preserving Candidate 003 exact evidence and NOT_RUN gates.
- `ROADMAP.md` → Candidate 003 Gate 0 first in the validation sequence.
- `DEVELOPMENT_GATES.md` → r4 authority and Candidate 003 physical/developer/device/human sequence.
- `tests/python/test_v48_current_authority_migration.py` → current r4/Candidate 003 assertions.
- `tests/python/test_v48_protected_canon_freshness.py` → protected-owner r4 freshness assertions.
- design and implementation-plan documents for this package.

No product runtime/code/Scene/Resource/asset file is intentionally modified by this package.

## 7. Notion human-facing reconciliation

### Home

Fresh readback showed the Human Home already contains:

- 10-second player promise;
- `Title → BUILD → Preflight → RUN → Pickup → LIFO/TOP → Switch → Result → Retry/Edit` flow;
- T1→T6→VS_DEMO_01 learning map;
- player-question tables;
- Candidate 003 evidence ceiling;
- AI/System details separated to a System page.

Therefore no duplicate Home rewrite was made. Existing good structure was preserved.

### Direction / Planning

Updated the benchmark synthesis and current validation priority:

`Candidate 003 physical visual recheck → same exact candidate developer self-run/screen QA + audio perceptual QA → acceptance build → Windows → Android → five-person comprehension`.

### Reference / Benchmark

Added a concise human-facing ADAPT/REJECT synthesis for Railbound, Mini Metro, Train Valley 2, and Rail Route while keeping the detailed reference library as the drilldown surface.

## 8. Implementation Reality Gate

### Proven/observable in this package

- repository branch mutations and branch readback;
- exact PR-head diff/checks once PR exists;
- merge and postmerge main readback once gates pass;
- Notion destination mutation + fetch/readback.

### Explicitly NOT proven by this package

```text
Candidate 003 physical appearance PASS
Developer self-run PASS
Audio perceptual QA PASS
Windows full physical runtime PASS
Android device PASS
Five-person comprehension PASS
Player experience PASS
Production cutover
```

These remain `NOT_RUN` / `BLOCKED_DEFERRED` unless separately executed.

## 9. Adversarial review log

### Pass 1 — Authority / provenance

Finding: the old r2 hash was used in fields named as if it were the current v4.8 source hash.

Correction: renamed it to historical r2 provenance and added explicit `NOT_R4_HASH` semantics. r4 is identified by revision/source role, not by an invented hash.

### Pass 2 — Stale consumer / candidate inflation

Finding: README, START_HERE, ROADMAP, DEVELOPMENT_GATES, CURRENT_CONFIRMED_DECISIONS, and canonical-freshness tests were untouched consumers of r2/current acceptance routing.

Correction: added them to the reconciliation package and routed current evidence through Candidate 003. Candidate 002 startup PASS remains historical only.

### Pass 3 — Human Home vs AI/System boundary

Finding: rewriting Home again would duplicate already-correct human-facing flow and risk turning it into another status log.

Correction: preserve Home; update Direction and Reference only where fresh benchmark/current-priority information belongs.

### Pass 4 — Benchmark causality / feature creep

Finding: review ratios could be misread as proof that broader/narrower scope causes success or failure.

Correction: explicitly separate observed facts from inference; no causal claim. Use benchmark principles as `ADAPT / REJECT / REFERENCE_ONLY`, not feature-copy authority.

### Pass 5 — Runtime leakage / long-term maintenance

Finding: r4 adds Godot update/shared-toolchain rules, which could tempt this docs package to mutate tool binaries/project settings or hard-code a new Godot version.

Correction: keep the project baseline observed state, route future update checks to r4/Base owners, and perform no Godot/runtime mutation in this package.

Initial five-pass state: `NO KNOWN BLOCKING DESIGN FINDING AFTER CORRECTIONS`.

Final clean exit remains contingent on exact PR-head checks, diff review, and postmerge readback.

## 10. Verification state

At document creation time:

```yaml
branch_mutation: DONE
local_full_repo_test_execution: BLOCKED_BY_NO_NETWORKED_LOCAL_GIT_EXECUTOR
pr_head_ci: NOT_RUN
notion_direction_update: INVOKED
notion_reference_update: INVOKED
notion_readback: PENDING
adversarial_minimum_5_passes: EXECUTED_AT_DOCUMENT_LEVEL
merge: NOT_RUN
postmerge_main_readback: NOT_RUN
```

The environment cannot clone the GitHub branch through the local container network, so repository test PASS will not be claimed from local execution. The repository's hosted PR checks will be used as the authoritative execution surface without weakening check requirements.
