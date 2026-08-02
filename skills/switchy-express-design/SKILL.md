---
name: switchy-express-design
description: Use for Switchy Express project-specific gameplay, route, cargo-stack, fuel, boost, station, scoring, map-generation, onboarding, or visual-readability decisions and reviews.
---

# Switchy Express Design Discipline

## Read first

1. `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
2. `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
3. `기획서/50_제작_검증/TOTAL_PLANNING_AUDIT.md`
4. `기획서/50_제작_검증/POST_VS02_ADVERSARIAL_AUDIT.md`
5. `기획서/10_경험/CORE_GAMEPLAY.md`
6. `기획서/20_시스템_콘텐츠/CORE_SYSTEMS.md`
7. `기획서/40_표현/VISUAL_DIRECTION.md`
8. `기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md`
9. `기획서/50_제작_검증/PLAYTEST_PLAN.md`

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
- UI motion does not own gameplay outcomes
- No input-free infinite survival

## Current implementation boundary

Implemented and headless-tested:

- Godot project, RailGraph, RailGenerator, and RailSwitch
- continuous train movement and up to eight wagons
- cargo types, capacity-eight LIFO stack, LOAD input contract
- station placement and cargo population
- DeliveryLoop pickup, unloading, and runtime respawn recovery
- `9 cases / 6915 assertions / 0 failures`

Not yet implemented or directly validated:

- speed, fuel, score, boost economy, game-over, results, restart, and records
- product RailBoardView, SwitchView, HUD, final art, audio, and haptics
- Android export, device performance, accessibility runtime, soak, and human playtest
- sufficient procedural variety and actual visual readability

## Planning rules

- Detailed balance and timing values begin as `RECOMMENDED_DEFAULT` or `TEST_VALUE`.
- A proposal that changes player fantasy, core choice, combo meaning, cargo/wagon meaning, onboarding policy, major UX, content meaning, or Vertical Slice scope is `USER_DECISION_REQUIRED`.
- Ask one material Grill Me Decision at a time after repository facts and alternatives are documented.
- Synchronize approved Decisions to GitHub canon, Issues/Plan, and the configured Google Sheet with the same Decision ID.
- Do not promote `CODEX_GOAL_VS_03.md` from `CODEX_NOT_READY` until required planning decisions and acceptance criteria are closed.

## Output

Every proposal must state:

- affected Decision and Finding IDs
- player choice, failure, recovery, and learning effect
- confirmed rules versus recommended test defaults
- current implementation and validation status
- affected canon, Issue, Plan, Sheet, code interfaces, and tests
- required runtime, Android, visual, accessibility, performance, and playtest evidence
- whether it is `AUTO_FIX_ELIGIBLE`, `USER_DECISION_REQUIRED`, or `RESEARCH_OR_TEST_REQUIRED`
