# Finite Visual Planning + Component Package Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Convert VIS-FINITE-01/02/03 into an approved, requirement-backed planning package containing reusable UI/component contracts and exploration-only image briefs, while deferring runtime implementation and PoC.

**Architecture:** Planning authority remains in GitHub docs plus the configured Google Sheet. The package defines Visual Requirement Gate rows first, then component contracts, then exploration image directions. No gameplay/domain authority or tracked product asset is modified.

**Tech Stack:** Markdown authority docs, GitHub PR/Actions, Google Sheets authority mirror, ChatGPT image exploration.

## Global Constraints

- Decision ID: `SX-DEC-050`.
- Baseline: `main@cb6b69360f4ba865cd103573d2a2c22d5c16a1cd`.
- Base authority: `fa69a77a14f923a756064f6ae151d34cadb374f7`.
- Actual Godot runtime implementation: deferred.
- PoC/runtime capture: deferred.
- Physical Windows/Android execution: deferred.
- Connected HiGodot authoring: deferred.
- No `.tscn`, Resource, Theme, Animation, signal wiring, `project.godot`, gameplay code, or map-data edits.
- Generated imagery stays `GENERATED_EXPLORATION · REFERENCE_ONLY` and is not committed as a product asset.
- Existing `VIS-014` and `VIS-015` are reused where applicable.

---

### Task 1: Freeze the Visual Requirement package

**Files:**
- Create: `기획서/40_표현/FINITE_VISUAL_REQUIREMENT_PACKAGE_V1.md`

**Interfaces:**
- Consumes: `VISUAL_DIRECTION.md`, `CORE_SYSTEMS.md`, `SX-DEC-028~036`, `VIS-FINITE-01~03`.
- Produces: twelve requirement rows with role, priority, disposition, states, accessibility, and deferred validation.

- [ ] **Step 1:** Write all twelve requirement rows with no TBD/TODO values.
- [ ] **Step 2:** Verify every requirement has a concrete player question and Delete Test.
- [ ] **Step 3:** Verify only P0/P1 and one bounded P2 navigation requirement are active; no decorative P3 production is introduced.
- [ ] **Step 4:** Verify all runtime/physical validations are explicitly `DEFERRED_NOT_RUN`.
- [ ] **Step 5:** Commit the requirement package.

### Task 2: Define reusable component contracts

**Files:**
- Create: `기획서/40_표현/FINITE_UI_COMPONENT_CATALOG_V1.md`

**Interfaces:**
- Consumes: Task 1 requirement IDs.
- Produces: component IDs grouped by Shared/BUILD/RUN/RESULT/PROGRESS.

- [ ] **Step 1:** Define each component's purpose, authority consumed, visual states, interaction states, accessibility equivalent, and future handoff.
- [ ] **Step 2:** Mark `CMP-RUN-SWITCH-DIRECTION` as `REUSE_PROJECT` linked to VIS-014 rather than duplicating it.
- [ ] **Step 3:** Mark cargo pickup marker behavior as existing VIS-015 state and not a new component.
- [ ] **Step 4:** Keep components as planning contracts only; do not name them as Godot Nodes/Scenes/Resources yet.
- [ ] **Step 5:** Commit the component catalog.

### Task 3: Define the exploration image brief

**Files:**
- Create: `기획서/40_표현/FINITE_IMAGE_EXPLORATION_BRIEF_V1.md`

**Interfaces:**
- Consumes: selected requirement IDs and component IDs.
- Produces: one three-panel concept-board brief for BUILD, RUN, RESULT/PROGRESS.

- [ ] **Step 1:** Define art-direction constants from the current Visual Pillars.
- [ ] **Step 2:** Define panel-specific information hierarchy and forbidden implications.
- [ ] **Step 3:** Require icon-like placeholders instead of relying on AI-rendered readable text.
- [ ] **Step 4:** Define review checks for hierarchy, color+shape redundancy, LIFO visibility, ghost-route subordination, Combo occlusion, and result action priority.
- [ ] **Step 5:** Mark output `GENERATED_EXPLORATION · REFERENCE_ONLY · NOT_PRODUCT_ASSET`.
- [ ] **Step 6:** Commit the image brief.

### Task 4: Register SX-DEC-050 in GitHub authority

**Files:**
- Modify: `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`

**Interfaces:**
- Consumes: approved design and Tasks 1-3.
- Produces: same Decision ID authority record for planning-only scope.

- [ ] **Step 1:** Add `SX-DEC-050` to the current decision registry.
- [ ] **Step 2:** State that execution/PoC/runtime/device/human validation is deferred and must not be inferred.
- [ ] **Step 3:** Link the spec, requirement package, component catalog, and image brief.
- [ ] **Step 4:** Preserve all earlier product decisions unchanged.
- [ ] **Step 5:** Commit the authority update.

### Task 5: Synchronize the configured Google Sheet

**Targets:**
- `00_프로젝트_허브`
- `02_현재_확정결정`
- `06_시각_작업면`
- `50_제작_검증`

**Interfaces:**
- Consumes: GitHub branch head and same Decision ID.
- Produces: Sheet rows showing planning package status without runtime claims.

- [ ] **Step 1:** Re-read metadata and target cells immediately before writing.
- [ ] **Step 2:** Add one `SX-DEC-050` decision row.
- [ ] **Step 3:** Update VIS-FINITE-01/02/03 to `PLANNING_PACKAGE_DEFINED · COMPONENT_SCOPE_DEFINED · IMAGE_EXPLORATION_READY` without marking runtime PASS.
- [ ] **Step 4:** Add a new production/current-work row for the planning package.
- [ ] **Step 5:** Keep Windows physical, Android device, connected HiGodot, PoC/runtime, and human gates as deferred/not-run.
- [ ] **Step 6:** Re-read edited cells and verify formatting/wrap remains consistent.

### Task 6: PR, exact-head verification, and merge

**Files:**
- All planning files above only.

**Verification:**

- [ ] **Step 1:** Compare branch to baseline and verify no runtime/product code, Scene, Resource, Theme, project, map, or binary-asset changes.
- [ ] **Step 2:** Open PR with explicit planning-only scope.
- [ ] **Step 3:** Wait for exact-head Project Contract / GUT / Godot / Thin Adapter checks that trigger for the docs change and read their actual conclusions.
- [ ] **Step 4:** Merge only if required checks succeed and the PR remains docs/planning-only.
- [ ] **Step 5:** Re-read merged main SHA and open PR count.
- [ ] **Step 6:** Update Sheet with the final merge SHA if it differs from the branch head.

### Task 7: Generate the exploration concept board

**Output:**
- ChatGPT-generated image only; no tracked repo product asset.

- [ ] **Step 1:** Generate one landscape three-panel concept board showing BUILD, RUN, and RESULT/PROGRESS directions.
- [ ] **Step 2:** Keep the image explicitly exploratory; do not promote it to `PROJECT_ASSET_APPROVED`.
- [ ] **Step 3:** Do not treat the image as runtime, PoC, device, touch-target, or localization evidence.
