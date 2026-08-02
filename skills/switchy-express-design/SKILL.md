---
name: switchy-express-design
description: Use for Switchy Express project-specific gameplay, route, cargo-stack, compact-wagon-token, fuel, boost, station, scoring, map-generation, onboarding, result-learning, batch-merge, or visual-readability decisions and reviews.
---

# Switchy Express Design Discipline

## Read first

1. `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
2. `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
3. `기획서/50_제작_검증/TOTAL_PLANNING_AUDIT.md`
4. `기획서/50_제작_검증/GRILL_ME_BATCH_MERGE_PROTOCOL.md`
5. `docs/superpowers/specs/2026-08-02-compact-cargo-wagon-tokens-design.md`
6. `docs/superpowers/specs/2026-08-02-first-session-contextual-onboarding-design.md`
7. `docs/superpowers/plans/2026-08-02-first-session-contextual-onboarding.md`
8. `기획서/50_제작_검증/POST_VS02_ADVERSARIAL_AUDIT.md`
9. `기획서/10_경험/CORE_GAMEPLAY.md`
10. `기획서/20_시스템_콘텐츠/CORE_SYSTEMS.md`
11. `기획서/40_표현/VISUAL_DIRECTION.md`
12. `기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md`
13. `기획서/50_제작_검증/PLAYTEST_PLAN.md`

## Invariants

- Automatic train movement
- Connected 15×10 landscape rail network
- No degree-1 dead ends
- 2-state and 3-state switches
- Straight route is default A when available
- Route preview first cell equals actual next cell
- Active segment target does not change after departure
- No immediate 180-degree reversal
- LOAD-gated pickup and BOOST priority over LOAD
- LIFO unloading
- Two stations per color and at least four map pickups per color
- Deterministic bounded placement and deferred respawn recovery
- Delivery grants score and fuel
- Cargo slows train
- Boost increases speed and fuel drain
- Fuel depletion ends run
- Color plus shape encoding
- Combo equals one station arrival's matching unload-group size
- Cargo count equals compact wagon token count, 0 through 8
- Front-to-rear tokens equal CargoStack bottom-to-top; rear token is next unload
- Eight compact tokens reserve no more than three trailing rail cells
- First-session onboarding runs inside the real endless run, not a separate tutorial map
- Onboarding order is LOAD → token → switch → mixed-stack LIFO → Combo → low-fuel BOOST
- Only first LOAD and first switch may request a safe full simulation pause
- Onboarding UI and animation do not own gameplay, pause release, reward, or save outcomes
- Assisted first-run evidence is separated from standard balance evidence
- UI motion does not own gameplay or occupancy outcomes
- No input-free infinite survival

## Current implementation boundary

Implemented and headless-tested:

- Godot project, RailGraph, RailGenerator, and RailSwitch
- continuous train movement and full-cell wagon-position foundation up to eight
- cargo types, capacity-eight LIFO stack, LOAD input contract
- station placement and cargo population
- DeliveryLoop pickup, unloading, and runtime respawn recovery
- `9 cases / 6915 assertions / 0 failures`

Approved planning, not yet implemented:

- compact wagon token count/order ViewModel
- fractional compact token path following
- compressed train footprint and spawn exclusion
- speed, fuel, score, boost economy, game-over, results, restart, and records
- contextual first-run OnboardingState, assist policy, safe pause, overlay, skip, Help, preferences, and telemetry
- product RailBoardView, SwitchView, HUD, final art, audio, and haptics

Not yet directly validated:

- Android export, device performance, accessibility runtime, soak, and human playtest
- compact token shape readability at 0/1/4/8 cargo
- first-run completion, interruption, unfair-failure, and learning thresholds
- sufficient procedural variety and actual visual readability

## Planning rules

- Detailed balance, timing, compact-token geometry, and onboarding assist values begin as `RECOMMENDED_DEFAULT` or `TEST_VALUE`.
- A proposal that changes player fantasy, core choice, combo meaning, cargo/token meaning, onboarding policy, failure-learning policy, major UX, content meaning, or Vertical Slice scope is `USER_DECISION_REQUIRED`.
- Ask one material Grill Me Decision at a time after repository facts and alternatives are documented.
- Through `SX-DEC-016`, complete the current catch-up canonical merge and Sheet closure.
- Starting with `SX-DEC-017`, count approvals in `GMB-001`; do not merge the regular batch before 10 approvals unless the user explicitly orders an exception.
- During a batch, record approved Decisions on the batch branch/draft PR and Sheet as `APPROVED_PENDING_BATCH_MERGE`, never `SYNCED`.
- At the 10th approval, freeze new Decisions and run the full `SX-OPS-001` GitHub-main/PR/Issue/Goal/Plan/Gate/Registry/Sheet-12-tab adversarial pre-merge audit.
- Merge only with exact-head required checks success, unresolved review threads 0, and P0/P1 open findings 0.
- After canonical merge, update Sheet to the canonical merge commit, reread all 12 tabs, then verify and merge a Sync Closure PR before closing the batch.
- Synchronize approved Decisions to GitHub canon, Issues/Plan, and the configured Google Sheet with the same Decision ID.
- Do not promote `CODEX_GOAL_VS_03.md` from `CODEX_NOT_READY` until required planning decisions, batch closure, and acceptance criteria are closed.

## Adversarial review lenses

- distortion of user-approved meaning
- conflict between Decisions, values, terms, and authority owners
- missing consumers in canon, Issue, Goal, Plan, Gate, Skill, Registry, Adapter, or Sheet
- UI/tutorial/animation owning gameplay outcomes
- automated evidence overstated as Android or human validation
- unapproved product code, refactor, permanent balance, or 11th batch Decision
- deletion or compression of historical contracts and evidence
- GitHub/Sheet Decision, Evidence, commit, and status drift
- success criteria or telemetry missing

## Output

Every proposal must state:

- affected Decision, Evidence, Finding, and Batch IDs
- player choice, failure, recovery, and learning effect
- confirmed rules versus recommended test defaults
- current implementation and validation status
- affected canon, Issue, Plan, Sheet, code interfaces, and tests
- required runtime, Android, visual, accessibility, performance, and playtest evidence
- whether it is `AUTO_FIX_ELIGIBLE`, `USER_DECISION_REQUIRED`, or `RESEARCH_OR_TEST_REQUIRED`
- whether it is `SYNCED`, `CANON_IN_PROGRESS`, or `APPROVED_PENDING_BATCH_MERGE`
