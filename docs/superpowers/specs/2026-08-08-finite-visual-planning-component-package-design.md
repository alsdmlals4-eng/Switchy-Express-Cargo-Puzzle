# Finite Visual Planning + Component Package Design

**Decision ID:** SX-DEC-050  
**Date:** 2026-08-08 KST  
**Base authority:** `alsdmlals4-eng/Base@fa69a77a14f923a756064f6ae151d34cadb374f7`  
**Project baseline:** `main@cb6b69360f4ba865cd103573d2a2c22d5c16a1cd`  
**User approval:** `권장안대로 승인`  
**Scope mode:** `PLANNING_AND_VISUAL_EXPLORATION_ONLY`

## 1. Goal

Define the next approved planning package for the finite-delivery product without beginning runtime implementation, physical execution, or PoC validation.

This package converts the currently required-but-not-started `VIS-FINITE-01`, `VIS-FINITE-02`, and `VIS-FINITE-03` rows into a requirement-backed visual/component plan that can later be implemented in Godot or translated to Figma without inventing new product rules.

## 2. Constraints

- Actual Godot runtime implementation is deferred.
- Physical Windows/Android execution is deferred.
- Connected HiGodot authoring is deferred.
- PoC and five-person comprehension testing are deferred.
- No `.tscn`, Resource, Theme, Animation, signal wiring, `project.godot`, map data, or gameplay code changes are in scope.
- Generated images remain `GENERATED_EXPLORATION · REFERENCE_ONLY`; they are not `PROJECT_ASSET_APPROVED` and are not tracked product assets.
- Existing product authority remains `SX-DEC-027~049`; this package adds presentation planning only and must not rewrite domain rules.
- Existing `VIS-014` switch-direction control and `VIS-015` pickup-marker visibility are reused rather than visually reinvented.

## 3. Approaches considered

### A. Requirement-first three-surface package — selected

Start from player questions and the Base Visual Requirement Gate, define only the P0/P1/P2 elements needed for three surfaces, then define reusable component contracts and produce one exploration image per surface.

**Pros:** authority-safe, low waste, easy to hand off to Figma/Godot later, avoids premature asset production.  
**Cons:** does not immediately produce runtime screenshots.

### B. Image-first concept sprint — rejected

Generate many polished mockups first and infer components afterward.

**Why rejected:** encourages decorative scope creep, can accidentally imply unapproved rules, and produces weak reusable component boundaries.

### C. Figma/component-first production system — deferred

Build a full design system and high-fidelity screens immediately.

**Why deferred:** stronger long-term reuse, but premature before component priority and information contracts are frozen. It also exceeds the user's current request to postpone execution/PoC.

## 4. Surface package

### Surface A — BUILD / Route Construction (`VIS-FINITE-01`)

Player questions:

1. Where can I build?
2. What track form am I placing and how will it connect?
3. Is the current/preview layout valid?
4. What will this placement cost, and how does it compare with star/leaderboard targets?
5. Is the ghost recommendation informational rather than an answer?

Planned visual hierarchy:

- Board and authored map objects remain primary.
- Buildable/non-buildable terrain distinction is low-noise but unmistakable.
- Track-form selection and placement preview are closer to the board than optimization metadata.
- Cost information uses neutral comparison language; exceeding an optional target never looks like general run failure.
- Ghost route is visibly subordinate to actual placed rail and defaults to a non-solution-reading treatment.

### Surface B — RUN / LIFO / Switch / Combo (`VIS-FINITE-02`)

Player questions:

1. What cargo is on top now?
2. What is the next same-type unload group?
3. Am I in manual-load or auto-load mode?
4. Which switch exit is selected, and is it currently locked?
5. What just unloaded and what Combo group did that create?

Planned visual hierarchy:

- Board/switch state remains the primary action surface.
- Stack HUD is persistent and readable at 8/16/32 cargo without requiring infinite world-car rendering.
- World train strip shows only a compact recent/TOP representation plus `+N` compression.
- Existing three-direction switch arrows are reused as the interaction grammar.
- Combo feedback sits near the unload event but may not occlude the next switch/cargo decision.

### Surface C — RESULT / PROGRESS / ARCHIVE (`VIS-FINITE-03`)

Player questions:

1. Did I succeed or fail, and why?
2. What one route edit/action should I try next?
3. Which speed/cost/score stars did I earn?
4. Is the leaderboard unlocked?
5. What should I do next: retry same layout, edit route, move to campaign progress, or inspect archive records?

Planned visual hierarchy:

- Outcome and next action are first.
- One failure cause + one corrective action is visible before optional detail.
- Retry/edit-route actions are separated from chapter/archive navigation.
- Stars and leaderboard gate communicate achievement but do not expose another player's exact route or replay.

## 5. Visual Requirement Gate

The package will define twelve requirements:

| Requirement | Surface | Role | Priority | Disposition |
|---|---|---|---|---|
| VR-FINITE-BUILD-01 | BUILD | INFORMATIONAL | P0_BLOCKER | ADAPT_EXISTING |
| VR-FINITE-BUILD-02 | BUILD | FUNCTIONAL | P0_BLOCKER | CREATE_CUSTOM |
| VR-FINITE-BUILD-03 | BUILD | INFORMATIONAL | P1_CLARITY | GENERATE_EXPLORATION |
| VR-FINITE-BUILD-04 | BUILD | FEEDBACK | P0_BLOCKER | CREATE_CUSTOM |
| VR-FINITE-RUN-01 | RUN | INFORMATIONAL | P0_BLOCKER | CREATE_CUSTOM |
| VR-FINITE-RUN-02 | RUN | FUNCTIONAL | P0_BLOCKER | ADAPT_EXISTING |
| VR-FINITE-RUN-03 | RUN | FUNCTIONAL/FEEDBACK | P0_BLOCKER | REUSE_PROJECT |
| VR-FINITE-RUN-04 | RUN | FEEDBACK | P1_CLARITY | GENERATE_EXPLORATION |
| VR-FINITE-RESULT-01 | RESULT | INFORMATIONAL | P0_BLOCKER | CREATE_CUSTOM |
| VR-FINITE-RESULT-02 | RESULT | FUNCTIONAL | P0_BLOCKER | CREATE_CUSTOM |
| VR-FINITE-PROGRESS-01 | PROGRESS | INFORMATIONAL | P1_CLARITY | GENERATE_EXPLORATION |
| VR-FINITE-PROGRESS-02 | PROGRESS | FUNCTIONAL/INFORMATIONAL | P2_CONSISTENCY | GENERATE_EXPLORATION |

The detailed requirement rows live in `기획서/40_표현/FINITE_VISUAL_REQUIREMENT_PACKAGE_V1.md`.

## 6. Component architecture

Components are planning contracts, not Godot nodes yet. Each component records purpose, required states, consumed authority, output intent, accessibility equivalence, and implementation defer status.

Planned component groups:

- shared surface shell,
- BUILD track palette / placement preview / ghost route / cost HUD / preflight notice,
- RUN stack HUD / compact train strip / load mode / reused switch direction target / combo feedback,
- RESULT summary / failure insight / retry-edit actions,
- PROGRESS star gate / chapter card / archive filters.

The catalog lives in `기획서/40_표현/FINITE_UI_COMPONENT_CATALOG_V1.md`.

## 7. Image exploration contract

Create one exploration board covering three 16:9 landscape concepts:

1. BUILD construction readability,
2. RUN LIFO/switch/Combo readability,
3. RESULT/progress hierarchy.

The images must:

- preserve the current `Cute premium casual`, `Readable miniature railway`, `Color + shape redundancy`, `Cause before spectacle`, and `LIFO is visible` pillars,
- use simple placeholder/icon-like UI rather than relying on readable AI-generated text,
- avoid any recognizable commercial IP or living-artist style imitation,
- remain `REFERENCE_ONLY`,
- not be committed to tracked product asset paths,
- not imply runtime completion or visual approval.

Detailed prompts and review checks live in `기획서/40_표현/FINITE_IMAGE_EXPLORATION_BRIEF_V1.md`.

## 8. Accessibility and localization

- Critical state must never rely on color alone.
- Touch targets are planned for at least 48dp-equivalent interaction surfaces on Android; existing switch-direction automated descriptor may remain >=44 px when the current board-cell constraint applies, with final physical touch validation deferred.
- Reduced Motion, mute, and haptic-off retain equivalent information.
- Labels must tolerate approximately 140% localization expansion before implementation freeze.
- AI concept images are not evidence for localization or touch-target compliance.

## 9. Authority and deferred implementation

This package may update planning docs and the project Sheet only.

Deferred follow-up sequence:

```text
SX-DEC-050 planning package
→ optional Figma translation / component visual QA
→ Godot implementation plan
→ HiGodot-authoritative Scene/Resource/Theme authoring where required
→ automated checks
→ PoC/runtime captures
→ Windows/Android physical checks
→ human comprehension
```

No step after the planning package may be marked PASS in this work item.

## 10. Success criteria for this work item

- SX-DEC-050 exists in GitHub authority and the correct Google Sheet with the same ID.
- `VIS-FINITE-01/02/03` are no longer ambiguous `NOT_STARTED` items; each has a defined requirement and component scope.
- Twelve Visual Requirements have role/priority/disposition/validation fields.
- Component catalog defines reusable boundaries without claiming runtime existence.
- Three-surface exploration image brief exists and generated imagery is explicitly non-product evidence.
- GitHub PR is documentation/planning-only and CI/contract checks pass before merge.
- Runtime/PoC/device/human gates remain deferred/not-run.
