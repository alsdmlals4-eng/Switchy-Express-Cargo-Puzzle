# SX-AUD-052 · SX-DEC-057 Delta DoR Final Review

Status: `PLANNING_REVIEW_COMPLETE · 057_CONTENT_DOR_PASS · ATTRIBUTE_CONTENT_DEPENDENCY_BLOCKED · NO_IMPLEMENTATION_AUTHORITY`

Date: `2026-08-11 KST`

Decision: `SX-DEC-057`

Baseline project main: `0caa36cfe3a3beb0e9e74ea914f4b964d9abb816`

Base observation: `315c66eea9614c284b9c11c4d522141065dfa4b0 · REFERENCE_ONLY`; project pin remains `v9.4.3`.

## 1. Review question

Can the approved Yard Labs/Mastery structure be closed to content-production/implementation-ready planning without altering SX-DEC-034 tutorial/chapter progression, adding gameplay rules or rewards, or assuming runtime features that current code does not expose?

## 2. Fresh source inspection

### Product/campaign authority

`FINITE_DELIVERY_PUZZLE_BASELINE.md` confirms:

- Tutorial 1~10 exact sequence;
- Stage 5 = auto-load transition;
- Stage 6 = switch operation;
- Stage 8 = fast/cheap rail and cost;
- chapter progression = 3 simultaneous stages, clear any 2 to open next group;
- campaign handcrafted maps;
- hints request-only and no automatic solution route.

### Current finite content/runtime shape

`FiniteMapDefinition` currently supports finite map identity, board/buildable/blocked cells, station/cargo placements, time limit and fixed rail anchors.

`TrackPiece` currently supports:

```text
geometry: STRAIGHT | CURVE | SWITCH | CROSSING
rotation
switch_initial_exit
basic geometry build cost
```

Current cost truth:

```text
STRAIGHT/CURVE = 100
SWITCH/CROSSING = 200
```

Current `TrackPiece` has no authoritative fast/cheap performance-attribute field. Therefore Builder Lab planning may reference the already-approved Stage 8 product rule, but SX-DEC-057 cannot invent its runtime representation or formula.

Current code search did not identify a current 057-owned campaign/Lab progression runtime owner. The progression contract can be fully specified now but implementation remains separately authorized work.

## 3. Findings and resolutions

### F182 · Launch Lab count/schema — CLOSED

Initial content is fixed to 12 micro puzzles:

```text
SL-01~04
SW-01~04
BL-01~04
```

Each has a common authoring schema, learning target, allowed/forbidden rule set, failure observation, request-only hint ladder, 3-axis difficulty tag, progression_required=false, leaderboard=false, completion-mark-only reward and runtime dependency field.

### F183 · Tutorial insertion risk — CLOSED

Labs do not become Tutorial Stage 5.5/6.5/8.5 and do not renumber the 1~10 sequence.

They unlock as optional lanes **after** the existing Stage clear. Tutorial continuation never reads Lab completion.

### F184 · Stack Lab rule leakage — CLOSED

Stack Lab launch content may use only Stage≤5 rules. Switch/Combo/speed-attribute mechanics cannot be required.

Blueprints SL-01~04 explicitly cover:

- reverse LIFO;
- intentional manual skip/revisit;
- auto/manual window use;
- three-type mental stack.

### F185 · Switch Lab reaction-risk — CLOSED

SW-01~04 center selected direction, state persistence, revisit, occupied lock and LIFO execution.

SW-03 authoring constraint requires sufficient pre-approach decision space; success must not depend on a reflex-only switch tap window. Pause remains thinking time under existing pause/input restrictions.

### F186 · Builder current/runtime mismatch — PARTIAL DEPENDENCY, PLANNING CLOSED

BL-01 Blocked Detour, BL-02 Geometry Cost Choice and BL-04 basic variant can be authored from current finite geometry/cost/LIFO/switch truth once content authority is granted.

BL-03 Fast vs Cheap and M-EXPRESS require the existing approved Stage 8 fast/cheap track attribute to have authoritative runtime representation.

Resolution: blueprint is complete, production status remains dependency-gated. SX-DEC-057 does not extend TrackPiece to unblock itself.

### F187 · Lab progression semantics — CLOSED

```text
Stage 5 clear → Stack lane permanently unlocks
Stage 6 clear → Switch lane permanently unlocks
Stage 8 clear → Builder lane permanently unlocks
within lane: 01→02→03→04
all 4 → completion mark
```

Lab clear/failure/skip never changes Tutorial/campaign eligibility. Completion mark is metadata/UI state only.

### F188 · Mastery progression-block risk — CLOSED

Mastery unlock and next-chapter unlock share the same prerequisite but are independent results:

```text
core_clear_count >= 2
→ next chapter available
→ current Mastery available
```

Thus Mastery cannot gate the next chapter. It remains optional/replayable and has at most one entry per chapter.

### F189 · Reward ambiguity — CLOSED

Launch reward is exactly `COMPLETION_MARK_ONLY` / `MASTERY_COMPLETION_MARK` metadata.

No item, currency, XP, stat, gameplay power, leaderboard eligibility or chapter requirement. A future actual cosmetic item/asset would require separate approval.

### F190 · Difficulty scale — CLOSED

Topology / Stack Entropy / Execution Branching each use internal ordinal 0..3 with explicit authoring definitions and Lab/Core/Exam/Mastery target envelopes.

No summed difficulty score is player-facing or automatically authoritative. Human calibration may tune content but not change rule boundaries.

### F191 · Hint/solution leakage — CLOSED

Hints are max three request-only levels: rule family → relevant state/location → action class. Exact route, exact switch timeline and complete load/skip script remain forbidden.

Solution-bearing authoring metadata must not become a normal runtime answer API.

### F192 · Transfer validation — CLOSED

If 057 enters an exact acceptance build:

- FS-16 measures Yard Lab → campaign transfer;
- FS-17 measures Mastery optionality/return path;
- existing 5 analyzable / 4-of-5 threshold remains.

Automated content validation cannot substitute for human evidence.

## 4. Content catalog / implementation plan

Catalog:

`기획서/20_시스템_콘텐츠/YARD_LAB_AND_MASTERY_CONTENT_CATALOG_V1.md`

Plan:

`docs/superpowers/plans/2026-08-11-sx-dec-057-yard-labs-mastery-delta.md`

Plan tasks cover:

1. content schema/validator;
2. 12-entry catalog data;
3. Lab progression state;
4. Stack Lab maps;
5. Switch Lab maps;
6. basic Builder maps + dependency gate;
7. Mastery progression/mark;
8. optional UI;
9. human acceptance hooks;
10. final domain/progression-invariance gate.

## 5. Final authority result

```yaml
SX_DEC_057_product_direction: USER_APPROVED
content_schema: READY_PLANNING
launch_12_lab_blueprints: READY_PLANNING
stack_lab: READY_PLANNING
switch_lab: READY_PLANNING
builder_basic_geometry_content: READY_PLANNING
builder_fast_cheap_content: BLOCKED_BY_STAGE8_TRACK_ATTRIBUTE_RUNTIME
mastery_structure: READY_PLANNING
progression_contract: READY_PLANNING
runtime_content_implementation_authority: NOT_GRANTED
SX_DEC_034_tutorial_and_2of3_progression: UNCHANGED
SX_DEC_055_build_authority: SX-DEC-055_ONLY
physical_device_human: NOT_RUN
```

No new Product Decision is needed to close the 057 design. The runtime dependency is an existing-rule implementation dependency, not permission for 057 to define fast/cheap rail gameplay.

Next planning lane: `SX-DEC-058 Fixed-Seed Challenge Quality Policy` delta DoR.
