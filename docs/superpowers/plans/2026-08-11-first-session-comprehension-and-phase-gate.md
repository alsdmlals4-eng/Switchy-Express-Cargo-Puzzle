# First-Session Comprehension + Phase Gate Implementation Plan

> **For agentic workers:** This is a Phase A documentation/authority plan. Do not execute Godot/GDScript/Codex BUILD tasks from the separate SX-DEC-055 implementation plan until the explicit v4.5 user planning-complete gate and Phase B final review have both passed.

**Goal:** Make the current project owners, human-playtest contract, roadmap, audit evidence, and Google Sheet agree on the post-SX-DEC-055 acceptance-build sequence and become ready for the explicit user planning-complete gate.

**Architecture:** Reuse existing decision and implementation authority. Add `SX-AUD-044` for the validation/planning audit, rewrite current-owner sequencing to v4.5, convert `PLAYTEST_PLAN.md` from old-APK-bound human execution to a post-POC exact-build behavior-first contract, and synchronize Sheet current surfaces. Preserve the old Android validation runbook/template and old APK hash as historical/diagnostic evidence.

**Tech Stack:** Markdown, JSON registry, Google Sheets, GitHub PR/Actions. No Godot/GDScript/runtime implementation.

## Global Constraints

- Baseline main: `398be2f12c6d279c83001bf36bfdd3ecb7f72a08`.
- Base reference main: `315c66eea9614c284b9c11c4d522141065dfa4b0`; project pin stays `v9.4.3`.
- Product Decisions remain `SX-DEC-027~055`; no new product Decision ID.
- New validation audit ID: `SX-AUD-044`.
- `SX-DEC-055` remains `USER_DEFERRED_AFTER_DOR · IMPLEMENTATION_NOT_STARTED · runtime_integrated=false`.
- Keep 73 product PNGs and all manifests unchanged.
- Keep Android validation-harness runbook/template fixed-hash contract unchanged in this package.
- Do not perform PowerShell/Codex/Godot BUILD.
- User has approved the recommended Phase A direction, but has **not** yet issued the explicit v4.5 `기획 완료` Gate.
- Physical Windows/Android, connected editor, and human gates remain `NOT_RUN`.

---

### Task 1: Canonicalize the v4.5 current-owner execution sequence

**Files:**
- Modify: `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
- Modify: `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`

**Produces:** one current execution sequence with no direct `resume → RED` shortcut.

- [ ] Update `ACTIVE_CONTEXT.md` date/current merge anchors through PR #140/main `398be2f1...`.
- [ ] Preserve SX-DEC-055 approval and `USER_DEFERRED_AFTER_DOR` state.
- [ ] Replace `ready_next` and `resume` direct-RED wording with:

```text
continue Phase A first-session/function/dependency/validation planning
→ Phase A planning package reviewed/merged/synced
→ explicit user "기획 완료"
→ Phase B final planning review
→ only after Phase B: SX-DEC-055 Task 1 / Step 1.1 RED
```

- [ ] Update `CURRENT_CONFIRMED_DECISIONS.md` Current Execution Authority with the same v4.5 gate while leaving the existing Decision registry unchanged.
- [ ] Keep all physical/device/human `NOT_RUN` ceilings.
- [ ] Focused search: no active current-owner sentence may say explicit resume alone authorizes RED.

### Task 2: Rewrite the human-playtest owner around post-POC acceptance identity

**Files:**
- Modify: `기획서/50_제작_검증/PLAYTEST_PLAN.md`

**Produces:** behavior-first first-session contract without claiming a future artifact exists.

- [ ] Preserve the historical APK SHA `eb49225a...759ea` in a clearly historical section so existing historical evidence and contract consumers remain valid.
- [ ] Remove the old APK as the active required human-comprehension build.
- [ ] Add explicit `acceptance_build_state: UNASSIGNED_UNTIL_AUTHORIZED_IMPLEMENTATION_MERGE` and `NOT_RUN` fields.
- [ ] Keep the Five-person Comprehension gate name and minimum five analyzable first-contact sessions.
- [ ] Add `recruit_target: 6 · TEST_VALUE`, with all valid sessions analyzed.
- [ ] Add the `RULE → NEED → DISCOVER → FEEL → PROVE → TRANSFER` mapping.
- [ ] Add FS-01~FS-12 observed-behavior evidence targets.
- [ ] Rework HUM criteria around behavior/prediction/transfer and `ceil(N × 0.8)` for N>5.
- [ ] Add neutral moderator prompts and intervention contamination rules.
- [ ] Add P0/P1/P2/P3 severity.
- [ ] Require the same exact acceptance build identity for reviewed physical smoke and each comprehension round.
- [ ] Explicitly state that PC-only evidence does not replace the Android-oriented human gate.
- [ ] Keep participant privacy/minimal aliases.
- [ ] Do not claim any human result was run.

### Task 3: Separate historical Android harness from future product acceptance chain

**Files:**
- Modify: `기획서/00_프로젝트_허브/ROADMAP.md`
- Modify: `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md`

**Produces:** an explicit distinction between the old validation-harness APK lane and future post-POC acceptance evidence.

- [ ] Preserve old canonical APK export/hash as historical packaging evidence.
- [ ] Preserve `ANDROID_DEVICE_SMOKE_RUNBOOK.md` / evidence template as the fixed-hash validation-harness lane; do not rewrite those files.
- [ ] Add/describe `POST_POC_ACCEPTANCE_BUILD_PHYSICAL_SMOKE` as `NOT_READY · BLOCKED_BY_AUTHORIZED_SX_DEC_055_IMPLEMENTATION`.
- [ ] Make Five-person Comprehension depend on the post-POC acceptance physical gate, not silently on the pre-POC APK.
- [ ] Add v4.5 Phase A → user gate → Phase B before M5 implementation.
- [ ] Keep Windows/Android/human/cutover unpassed.

### Task 4: Record the distinct planning/validation audit

**Files:**
- Create: `기획서/50_제작_검증/SX_AUD_044_FIRST_SESSION_COMPREHENSION_AND_PHASE_GATE.md`

**Produces:** durable reasoning/evidence record without a new product Decision.

- [ ] Record baseline main/open PR/Base/Sheet readback.
- [ ] Record conflicts A/B/C from the design spec.
- [ ] Record existing-solution-first verdict.
- [ ] Record external evidence disposition:
  - Games User Research professional practice → `ADAPT`;
  - Xbox Accessibility Guidelines → `ADOPT_AS_VALIDATION_LENS`;
  - competitor puzzle framing → `REFERENCE_ONLY`.
- [ ] Record the selected Approach C and rejected A/B.
- [ ] Record that existing SX-DEC-055 tasks already satisfy implementation function/dependency/protection planning.
- [ ] Record all evidence ceilings as NOT_RUN and no-build gate.
- [ ] Before merge, append exact-head workflow evidence; after merge, update same Sheet audit row rather than inventing another audit ID.

### Task 5: Establish a Phase A planning-completion gate matrix

**Files:**
- Create: `기획서/50_제작_검증/PHASE_A_PLANNING_COMPLETION_GATE.md`

**Produces:** one auditable checklist showing whether planning is ready for the user's explicit Gate.

- [ ] Include these planning criteria:
  1. current Base/project/Sheet authority refreshed;
  2. product core/decisions stable;
  3. function decomposition exists;
  4. dependency map/interfaces exist;
  5. protected areas and forbidden changes exist;
  6. RED/GREEN implementation blueprint exists;
  7. automated/physical/human validation sequence exists;
  8. first-session comprehension acceptance contract exists;
  9. current owners share v4.5 sequence;
  10. Sheet/GitHub same-ID sync;
  11. adversarial review P0/P1 planning conflicts = 0;
  12. exact-head PR verification/merge/readback complete.
- [ ] Link function/dependency/protection criteria to the existing SX-DEC-055 plan instead of duplicating code tasks.
- [ ] State status as `IN_PROGRESS` until the planning PR merges and readback/sync close.
- [ ] After merge/sync, it may become `READY_FOR_USER_PLANNING_COMPLETE_GATE`; never set `USER_GATE_GRANTED` without the user's explicit declaration.

### Task 6: Register and route planning documents

**Files:**
- Modify: `기획서/00_프로젝트_허브/DESIGN_DOCUMENT_REGISTRY.json`

**Produces:** discoverable current planning owners.

- [ ] Keep `SX-PLAYTEST` source as `PLAYTEST_PLAN.md`.
- [ ] Add `SX-PHASE-A-PLANNING-GATE` pointing to `PHASE_A_PLANNING_COMPLETION_GATE.md`, status `CURRENT`.
- [ ] Do not change old Android runbook registry IDs/status in this package.
- [ ] Parse JSON / contract checks must remain valid.

### Task 7: Synchronize configured Google Sheet current surfaces

**Ranges:**
- `00_프로젝트_허브`
- `01_작업순서`
- `02_현재_확정결정` existing SX-DEC-055 row, same Decision ID
- `04_누락_충돌_감사` new SX-AUD-044 row
- `05_GDD_요약` current module metadata
- `50_제작_검증` add/update current first-session/Phase A row

- [ ] Add `CURRENT-12` or equivalent current work-order row for Phase A first-session comprehension/gate package.
- [ ] Preserve `SX-DEC-055`; only refresh its next-action/validation sequencing, no product decision change.
- [ ] Add `SX-AUD-044` row with current branch/PR state and `PLANNING_ONLY` evidence ceiling.
- [ ] Update GDD-CURRENT-07 next step to the acceptance/comprehension planning Gate.
- [ ] Add production/validation current row for `FIRST_SESSION_COMPREHENSION_PLANNING`.
- [ ] Re-read exact touched ranges after writes.

### Task 8: Adversarial review, PR, exact-head CI, merge

**Scope:** docs/planning only.

- [ ] Compare branch against `398be2f1...` and reject runtime/product/asset/workflow changes.
- [ ] Attack specifically for:
  - direct resume→RED shortcut;
  - old APK still active human build;
  - invented future SHA/build evidence;
  - Five-person gate accidentally changed into a six-person requirement;
  - questionnaire-only PASS;
  - moderator leading/coaching;
  - color-only acceptance;
  - physical/human PASS inflation;
  - new gameplay/domain rule;
  - Base repin;
  - duplicate implementation plan.
- [ ] Open PR with `SX-AUD-044`, no new Decision ID, external-evidence disposition, and Sheet sync notes.
- [ ] Require fresh exact-head Project Contract, GUT, Godot, Thin Adapter and any other actually-triggered required checks.
- [ ] Require review threads 0 and mergeability true.
- [ ] If CI exposes a registered compatibility anchor, debug root cause and preserve the consumer unless the consumer itself is proven stale under authority.
- [ ] Merge with expected-head protection only on unchanged verified head.

### Task 9: Post-merge Phase A readiness closure

**Files / Sheet:** same owners, same IDs.

- [ ] Re-read new main, open PRs, Base current, current owner docs, registry, and Sheet current surfaces.
- [ ] Update `SX-AUD-044` Sheet row with exact-head and merge evidence.
- [ ] Update `PHASE_A_PLANNING_COMPLETION_GATE.md` only if a docs-only closure PR is required to record final merge evidence; otherwise current-owner/Sheet readback may carry closure evidence without self-SHA loops.
- [ ] Final planning verdict:
  - `READY_FOR_USER_PLANNING_COMPLETE_GATE`, or
  - `PLANNING_GAP_REMAINS`, or
  - `USER_DECISION_REQUIRED`, or
  - `BLOCKED_UNVERIFIED`.
- [ ] If ready, stop before BUILD and request/await only the explicit user v4.5 `기획 완료` Gate. Do not interpret prior approval/continuous-work language as that Gate.
