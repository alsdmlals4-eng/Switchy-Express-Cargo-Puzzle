# SX-DEC-057 Yard Labs / Mastery Implementation & Content Plan

> **For agentic workers:** REQUIRED SUB-SKILL: use superpowers:test-driven-development for runtime/content-schema code, and verification-before-completion before any PASS claim. This plan is not executable until separate SX-DEC-057 implementation/content authority is granted.

**Goal:** Build the approved 12 Yard Lab launch blueprints and optional per-chapter Mastery Spur as a content layer over current finite gameplay without changing Tutorial 1~10, 2-of-3 chapter progression, gameplay rules, rewards, or score authority.

**Architecture:** Add a validated Lab/Mastery content catalog and a small progression-state layer that reads existing tutorial/chapter clear facts. Lab map data remains ordinary finite map content. Mastery and Lab eligibility are UI/content-routing facts only. No Lab-specific gameplay controller is allowed. Builder content requiring fast/cheap track attributes stays dependency-gated until that existing Stage 8 rule has authoritative runtime representation.

## Authority constraints

- Product owner: `SX-DEC-057`.
- Exact design: `docs/superpowers/specs/2026-08-11-yard-labs-mastery-curriculum-design.md`.
- Launch blueprints: `기획서/20_시스템_콘텐츠/YARD_LAB_AND_MASTERY_CONTENT_CATALOG_V1.md`.
- Delta audit: `SX-AUD-052`.
- Tutorial order and chapter 2-of-3 rule remain `SX-DEC-034` authority.
- No implementation/content production before explicit authority.
- No gameplay power, currency, XP, leaderboard, new win condition, or solution overlay.
- Route Probe/Debrief from SX-DEC-056 is not required for Lab solvability.
- `BL-03` and `M-EXPRESS` cannot enter production until authoritative fast/cheap track-attribute runtime exists.

## Verification baseline

Custom suite:

```bash
godot --headless --path . --script res://tests/run_tests.gd
```

Final unchanged PR head requires Project Contract, GUT, Godot + live-editor Pilot, and Thin PASS. Physical/device/human remain separate gates.

---

### Task 1: Add versioned Lab/Mastery authoring schema and validator

**Planned files:**
- `game/finite/content/lab_mastery_content_definition.gd`
- `game/finite/content/lab_mastery_content_validator.gd`
- `tests/finite/content/test_lab_mastery_content_validator.gd`
- `tests/run_tests.gd`

- [ ] Write RED tests for exact launch schema fields and enum values.
- [ ] Require Lab unlock anchors exactly Stack=5, Switch=6, Builder=8.
- [ ] Require `progression_required=false`, `leaderboard_enabled=false`, `reward_class=COMPLETION_MARK_ONLY`.
- [ ] Validate Stack required-rules subset of Stage≤5 allow-list.
- [ ] Validate Switch required-rules subset of Stage≤6 allow-list and route-control count ≤3.
- [ ] Require dependency flag for FAST/CHEAP content until runtime capability reports available.
- [ ] Validate Mastery rules subset of supplied chapter-known-rules and count ≤1 per chapter.
- [ ] Run RED→GREEN and commit.

### Task 2: Add launch catalog entries for SL-01~04 / SW-01~04 / BL-01~04

**Planned files:**
- `data/content/yard_labs_v1.json` or equivalent existing content-data location chosen at implementation review
- `tests/finite/content/test_yard_lab_catalog_v1.gd`

- [ ] Write RED test requiring exactly 12 launch IDs and no duplicates.
- [ ] Encode the approved catalog metadata without player-facing exact solution data.
- [ ] Keep development-only expected encounter/failure metadata in test fixtures or non-runtime authoring source if packaging would expose it to normal presentation.
- [ ] Mark `BL-03` dependency-gated; do not fabricate a map/runtime field.
- [ ] Run validation and commit.

### Task 3: Add Lab lane eligibility/progression state

**Planned files:**
- `game/finite/progress/yard_lab_progress_state.gd`
- focused tests under `tests/finite/progress/`

Logical contract:

```text
Stage 5 clear → Stack lane unlocked
Stage 6 clear → Switch lane unlocked
Stage 8 clear → Builder lane unlocked
within lane N clear → N+1 available
all 4 clear → completion_mark=true
```

- [ ] RED: campaign/tutorial eligibility is unchanged regardless of Lab state.
- [ ] RED: unlock is monotonic once source tutorial clear exists.
- [ ] RED: Lab failure/retry does not remove unlock/clear state.
- [ ] Implement only Lab routing metadata; no power/currency/stat fields.
- [ ] Commit.

### Task 4: Author Stack Lab finite map content

**Planned production maps after authority:**
- `SL-01_REVERSE_PAIR`
- `SL-02_INTENTIONAL_SKIP`
- `SL-03_TOGGLE_WINDOW`
- `SL-04_THREE_TYPE_STACK`

- [ ] For each map, first write a content proof test using ordinary finite MapDefinition/preflight/run seams.
- [ ] Verify only Stage≤5 required rules are needed.
- [ ] Verify no switch/crossing-control required solution.
- [ ] Verify SL-02's time calibration distinguishes deliberate skip from load-everything extra-lap behavior without a new win condition.
- [ ] Verify request-only hint data stops short of complete load sequence.
- [ ] Commit each map with its focused proof rather than batching unverified content.

### Task 5: Author Switch Lab finite map content

**Planned maps:** SW-01~04 from catalog.

- [ ] RED/proof per map that preset topology is structurally valid.
- [ ] Verify route-control count and meaningful-change target.
- [ ] SW-03: prove a success path has sufficient pre-approach decision window and does not require reaction-only timing.
- [ ] SW-04: prove correct switch state alone does not bypass LIFO; existing station/TOP behavior remains authority.
- [ ] Commit per verified map.

### Task 6: Author basic Builder Lab content and keep attribute content gated

**Production-ready after authority/capability review:**
- BL-01 Blocked Detour
- BL-02 Geometry Cost Choice
- BL-04 current basic-geometry variant

**Blocked:**
- BL-03 Fast vs Cheap
- BL-04 future attribute variant

- [ ] RED/proof BL-01 has ≥2 structurally valid route choices with distinct encounter consequences.
- [ ] RED/proof BL-02 demonstrates current geometry-cost truth only.
- [ ] RED/proof BL-04 combines existing BUILD/LIFO/switch rules without requiring Stage 8 missing attribute fields.
- [ ] Add a validator test that production status for BL-03 is rejected while capability is absent.
- [ ] Do not extend TrackPiece in SX-DEC-057 merely to unblock content.
- [ ] Commit.

### Task 7: Add Mastery Spur routing and completion mark

**Planned files:**
- `game/finite/progress/mastery_progress_state.gd`
- campaign selection/presentation seam chosen after fresh implementation inspection
- focused progression tests

- [ ] RED: `core_clear_count >= 2` makes both next chapter and current Mastery available independently.
- [ ] RED: incomplete/failed/abandoned Mastery never changes next chapter eligibility.
- [ ] RED: Mastery completion only sets a completion mark.
- [ ] RED: at most one Mastery entry per chapter.
- [ ] Add M-JUNCTION/M-CARGO/M-BUDGET/M-LOOP/M-GRAND author templates; M-EXPRESS remains dependency-gated.
- [ ] Commit.

### Task 8: Add optional content UI without pressure or reward ambiguity

- [ ] UI labels Labs as practice/optional and Mastery as optional mastery.
- [ ] Next chapter action remains visible when Mastery unlocks.
- [ ] Completion marks are visual status only.
- [ ] No locked campaign message cites Lab/Mastery as a requirement.
- [ ] No leaderboard or reward power UI appears.
- [ ] Request-only hint interaction remains separate from normal objective text.
- [ ] Add presentation tests and commit.

### Task 9: Add transfer/optionality acceptance hooks

- [ ] If 057 content is in an exact acceptance build, activate existing PLAYTEST_PLAN FS-16 and FS-17 only.
- [ ] Preserve FS-01~12/HUM-01~13 and 5-person/4-of-5 thresholds.
- [ ] Record Lab-to-campaign transfer without coaching.
- [ ] Record Mastery skip/abandon → next chapter navigation.
- [ ] Do not mark human PASS from automated map/content tests.

### Task 10: Final domain-invariance/content-scope gate

- [ ] Custom suite full PASS.
- [ ] Assert Tutorial order byte/semantic registry unchanged.
- [ ] Assert chapter unlock predicate remains 2 Core clears only.
- [ ] Assert no Lab/Mastery content changes LIFO, route-control, time, scoring, save/ruleset, or finite success rules.
- [ ] Assert no power/currency/leaderboard fields in Lab/Mastery persisted schema.
- [ ] Assert dependency-gated content is not public/launch-active.
- [ ] `git diff --check` and changed-file scope review.
- [ ] Exact-head CI before merge.

## Dependency closure for 057B

`BL-03` / `M-EXPRESS` may move from blueprint to production only after fresh current code proves an approved Stage 8 owner exposes authoritative fast/cheap track attributes, including their speed/cost effects and serialization. At that point 057 consumes the fields; it does not define their gameplay formula.

## Handoff

Planning is complete enough for later implementation/content authority. Until that authority exists, do not create Lab map JSON, progression code, UI, or reward assets. The current executable Phase C first step remains SX-DEC-055 Task 1 / Step 1.1 RED.
