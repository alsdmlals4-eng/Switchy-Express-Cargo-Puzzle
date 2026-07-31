---
name: switchy-express-design
description: Use for Switchy Express project-specific gameplay, route, cargo-stack, fuel, boost, station, scoring, map-generation, or visual-readability decisions and reviews.
---

# Switchy Express Design Discipline

## Read first

1. `[기획서]/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
2. `[기획서]/10_경험/CORE_GAMEPLAY.md`
3. `[기획서]/20_시스템_콘텐츠/CORE_SYSTEMS.md`
4. `[기획서]/40_표현/VISUAL_DIRECTION.md`
5. `[기획서]/50_제작_검증/VERTICAL_SLICE_CONTRACT.md`

## Invariants

- Automatic train movement
- Connected 15×10 landscape rail network
- 2-way and 3-way switches
- LIFO unloading
- Delivery grants score and fuel
- Cargo slows train
- Boost increases speed and fuel drain
- Fuel depletion ends run
- Color plus shape encoding
- No input-free infinite survival

## Output

Every proposal must state affected Decision IDs, player choice, failure and recovery, initial test values versus confirmed rules, and required runtime/playtest evidence.
