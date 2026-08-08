# E+D Hybrid Production Asset Pack Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the first GitHub-tracked E+D hybrid production-candidate art package for SX-DEC-051 without integrating it into Godot runtime.

**Architecture:** Generate a bounded family of source contact sheets, curate them through the approved adversarial gates, separate accepted transparent candidates, and store them under `art/production_candidates/ed_hybrid_v1/`. A machine-readable manifest records provenance and state. `.gdignore` keeps the candidate tree outside current Godot import/runtime authority.

**Tech Stack:** ChatGPT image generation, PNG/alpha assets, Python/Pillow for deterministic slicing and metadata inspection, JSON manifest, GitHub PR/Actions, Google Sheet authority mirror.

## Global Constraints

- Decision ID: `SX-DEC-051`.
- Art direction: `E+D HYBRID · NEO-ARCADE READABILITY`.
- Locomotive remains the vehicle anchor; cargo wagons target about 65–75% of locomotive visual footprint.
- Color-only identity and color-only interaction states are forbidden.
- Generated copy is not final localized UI copy.
- Candidate state: `GENERATED_PRODUCTION_CANDIDATE · PROJECT_TRACKED · NOT_RUNTIME_INTEGRATED · NOT_FINAL_ASSET_APPROVED`.
- No `.tscn`, Resource, Theme, Animation, signal wiring, gameplay code, project settings, runtime sprite hookup, POC, Windows/Android physical validation, or connected HiGodot work in this plan.
- Specific third-party IP/UI skins and identifiable living-artist/studio imitation are forbidden.

---

### Task 1: Candidate package skeleton and validation contract

**Files:**
- Create: `art/production_candidates/.gdignore`
- Create: `art/production_candidates/ed_hybrid_v1/README.md`
- Create: `art/production_candidates/ed_hybrid_v1/manifest.json`
- Create: `tools/validate_ed_hybrid_asset_pack.py`
- Create: `tests/test_ed_hybrid_asset_pack.py`

**Interfaces:**
- Consumes: approved SX-DEC-051 design.
- Produces: asset-root contract, manifest schema, validation command.

- [ ] **Step 1: Add a failing contract test**

Test must require the candidate root, `.gdignore`, manifest fields (`decision_id`, `status`, `art_direction`, `assets`), unique paths, PNG-only candidate paths, and every asset record to contain `family`, `role`, `state`, `provenance`, `runtime_integrated=false`, `final_asset_approved=false`.

- [ ] **Step 2: Run the focused test**

Run: `python -m pytest tests/test_ed_hybrid_asset_pack.py -q`

Expected before implementation: FAIL because package/validator does not exist.

- [ ] **Step 3: Add skeleton and validator**

Validator must parse `manifest.json`, confirm referenced files exist, use Pillow to confirm PNG decode/dimensions, require alpha for records marked `transparent=true`, and reject paths outside `art/production_candidates/ed_hybrid_v1/`.

- [ ] **Step 4: Run focused test**

Run: `python -m pytest tests/test_ed_hybrid_asset_pack.py -q`

Expected: PASS for an empty-but-valid manifest with declared family targets.

- [ ] **Step 5: Commit**

Commit message: `chore: scaffold E+D production asset pack`

---

### Task 2: P0 core + RUN/LIFO candidate family

**Files:**
- Create: `art/production_candidates/ed_hybrid_v1/sheets/core_run_contact_v01.png`
- Create accepted images under `core/`, `board/`, `run/`
- Modify: `art/production_candidates/ed_hybrid_v1/manifest.json`
- Modify: `tests/test_ed_hybrid_asset_pack.py`

**Interfaces:**
- Consumes: Task 1 manifest/validator.
- Produces: locomotive/wagons/stars/stations/rail/switch and first RUN/LIFO states.

- [ ] **Step 1: Generate one coherent E+D contact sheet**

Required visible families: blue locomotive, smaller red/blue/yellow cargo wagons, red/blue/yellow stars, red/blue/yellow stations, straight/curve/crossing/3-way-switch rails, LIFO TOP/next-group/+N visual states, selected/locked switch directions.

- [ ] **Step 2: Adversarial review contact sheet**

Reject if wagon hierarchy, rail connectivity, color+shape redundancy, LIFO TOP, or switch selected/locked form fails the design gates.

- [ ] **Step 3: Separate accepted candidates**

Use deterministic alpha/content bounds; keep consistent padding. File names must follow `<family>_<role>_<variant>_<state>_v01.png`.

- [ ] **Step 4: Register provenance**

Each record includes generated source sheet, crop/source bounds or direct-generation note, family/role/state, dimensions, transparent flag, `runtime_integrated=false`, `final_asset_approved=false`.

- [ ] **Step 5: Validate**

Run: `python tools/validate_ed_hybrid_asset_pack.py`

Expected: PASS and at least one accepted record for each P0 core and RUN/LIFO required family.

- [ ] **Step 6: Commit**

Commit message: `art: add E+D core and run candidates`

---

### Task 3: P0 BUILD + button/control state family

**Files:**
- Create: `art/production_candidates/ed_hybrid_v1/sheets/build_ui_contact_v01.png`
- Create accepted images under `build/` and `ui/`
- Modify: `manifest.json`
- Modify: `tests/test_ed_hybrid_asset_pack.py`

**Interfaces:**
- Consumes: shared art direction and Task 1 manifest contract.
- Produces: build ghost/state language and reusable interaction-state controls.

- [ ] **Step 1: Generate BUILD/UI source sheet**

Include valid/invalid ghost, rotate/replacement preview, port markers, dotted low-saturation recommendation rail, cost/status panel primitives, preflight markers, and normal/hover/pressed/selected/disabled/focus button states.

- [ ] **Step 2: Adversarial review**

Reject if ghost looks like committed rail, optional target miss looks like general failure, buttons differ only by hue, or decorative frame obscures reusable component boundaries.

- [ ] **Step 3: Separate and register accepted candidates**

Text-safe panel art must not rely on generated text. Icon and frame candidates are separate where practical.

- [ ] **Step 4: Validate state coverage**

Tests require all seven generic button states and both valid/invalid BUILD preview states.

- [ ] **Step 5: Run validation**

Run: `python -m pytest tests/test_ed_hybrid_asset_pack.py -q && python tools/validate_ed_hybrid_asset_pack.py`

Expected: PASS.

- [ ] **Step 6: Commit**

Commit message: `art: add E+D build and control states`

---

### Task 4: P1 VFX + shells/result/meta bounded first set

**Files:**
- Create: `art/production_candidates/ed_hybrid_v1/sheets/vfx_shell_meta_contact_v01.png`
- Create accepted images under `vfx/`, `shells/`, `meta/`
- Modify: `manifest.json`
- Modify: `tests/test_ed_hybrid_asset_pack.py`

**Interfaces:**
- Produces: first bounded non-runtime set for pickup/unload/combo/outcome and progress shells.

- [ ] **Step 1: Generate VFX/shell/meta source sheet**

Include pickup sparkle, unload pulse, combo badge/burst, success flare, small confetti, failure pulse, ROUTE_END/TIME_EXPIRED icon treatments, blank/text-safe success/failure result frames, chapter/stage states, leaderboard gate, archive filter primitives.

- [ ] **Step 2: Adversarial review**

Reject VFX that hides likely next input regions; reject result decoration that competes with primary action; reject generated copy as reusable UI source.

- [ ] **Step 3: Produce static Reduced Motion equivalents**

Pickup/combo/result meaning must remain readable without motion.

- [ ] **Step 4: Separate, register, validate**

Run manifest validator and focused tests.

- [ ] **Step 5: Commit**

Commit message: `art: add E+D feedback and shell candidates`

---

### Task 5: Authority closure, PR, and exact-head verification

**Files:**
- Create: `docs/decisions/SX_DEC_051_ED_HYBRID_PRODUCTION_ASSET_PACK.md`
- Create: `기획서/50_제작_검증/SX_AUD_036_ED_HYBRID_ASSET_CANDIDATE_PACK.md`
- Modify: `art/production_candidates/ed_hybrid_v1/README.md`
- Modify: configured Google Sheet rows for SX-DEC-051 / VIS-FINITE-01~03 / current production status.

**Interfaces:**
- Produces: auditable same-ID GitHub/Sheet closure for candidate creation only.

- [ ] **Step 1: Record counts and provenance**

Decision/audit docs must list candidate counts per family, source sheets, validator result, adversarial review disposition, and explicit runtime/POC NOT_RUN boundary.

- [ ] **Step 2: Run local/static validation available in this environment**

Run: `python tools/validate_ed_hybrid_asset_pack.py` and `python -m pytest tests/test_ed_hybrid_asset_pack.py -q`.

Expected: PASS.

- [ ] **Step 3: Open PR**

PR scope: production-candidate art + manifest/tests/docs only; no Godot runtime integration.

- [ ] **Step 4: Wait for exact-head repository checks and inspect PR diff**

Required: applicable Project Contract / asset-rights / existing regression checks must be actual success before merge. Do not infer unrun checks.

- [ ] **Step 5: Merge if checks and review pass**

Merge only candidate package. Runtime/POC remains a later decision.

- [ ] **Step 6: Synchronize configured Google Sheet**

Use the same `SX-DEC-051`; record actual merge SHA and preserve Windows/Android/HiGodot/human/cutover blockers.
