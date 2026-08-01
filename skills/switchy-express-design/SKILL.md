---
name: switchy-express-design
description: Use for Switchy Express project-specific gameplay, route, cargo-stack, fuel, boost, station, scoring, map-generation, or visual-readability decisions and reviews.
---

# Switchy Express Design Discipline

## Read first

1. `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
2. `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
3. `기획서/50_제작_검증/POST_VS01_ADVERSARIAL_AUDIT.md`
4. `기획서/10_경험/CORE_GAMEPLAY.md`
5. `기획서/20_시스템_콘텐츠/CORE_SYSTEMS.md`
6. `기획서/40_표현/VISUAL_DIRECTION.md`
7. `기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md`

## Invariants

- Automatic train movement
- Connected 15×10 landscape rail network
- No degree-1 dead ends
- 2-state and 3-state switches
- Straight route is default A when available
- Route preview first cell equals actual next cell
- No immediate 180-degree reversal
- LIFO unloading
- Two stations per color and at least four map pickups per color
- Delivery grants score and fuel
- Cargo slows train
- Boost increases speed and fuel drain
- Fuel depletion ends run
- Color plus shape encoding
- No input-free infinite survival

## Current implementation boundary

- Godot project, RailGraph, RailGenerator, and RailSwitch: implemented and headless-tested
- Train, wagons, cargo, stations, LIFO runtime, economy, HUD, Android, and playtest: not yet complete
- Structural graph validity does not prove sufficient procedural variety or visual readability

## Output

Every proposal must state:

- affected Decision IDs
- player choice, failure, and recovery
- confirmed rules versus recommended test defaults
- current implementation and validation status
- required runtime, Android, visual, and playtest evidence
- whether GitHub canonical docs and Google Sheets require immediate synchronization
