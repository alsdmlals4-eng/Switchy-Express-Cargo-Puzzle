# SX-DEC-057 Yard Labs / Mastery Curriculum Design

Status: `USER_APPROVED_DESIGN · DELTA_DOR_REVIEWED · IMPLEMENTATION_NOT_AUTHORIZED`

Decision owner: `docs/decisions/SX_DEC_057_YARD_LABS_AND_MASTERY_CURRICULUM.md`

Content catalog: `기획서/20_시스템_콘텐츠/YARD_LAB_AND_MASTERY_CONTENT_CATALOG_V1.md`

Delta review: `기획서/50_제작_검증/SX_AUD_052_SX_DEC_057_DELTA_DOR_FINAL_REVIEW.md`

Implementation/content plan: `docs/superpowers/plans/2026-08-11-sx-dec-057-yard-labs-mastery-delta.md`

## Goal

기존 Tutorial 1~10과 본편 규칙을 바꾸지 않고, 짧은 격리 연습과 optional mastery 문제로 `이해 → 적용 → 전이`를 강화한다. Lab/Mastery는 별도 arcade ruleset이 아니라 current finite gameplay를 다른 학습 밀도로 authoring하는 content layer다.

## 1. Content architecture

```text
Tutorial 1~10 (SX-DEC-034 exact order)
├─ Stage 5 clear  → Stack Lab: SL-01 → SL-02 → SL-03 → SL-04
├─ Stage 6 clear  → Switch Lab: SW-01 → SW-02 → SW-03 → SW-04
└─ Stage 8 clear  → Builder Lab: BL-01 → BL-02 → BL-03 → BL-04

Chapter N
├─ Core A
├─ Core B
├─ Core C
└─ Mastery Spur · initially locked

clear any 2 Core
├─ next chapter unlocks immediately
└─ current chapter Mastery Spur unlocks simultaneously
```

No Lab/Mastery clear enters the core progression predicate.

## 2. Authoring schema

Planned content metadata owner is a data/catalog layer, not a new gameplay domain.

```text
content_schema_version
content_id
content_kind: LAB | MASTERY
lab_type: STACK | SWITCH | BUILDER | NONE
sequence_index
unlock_anchor
primary_learning_target
transfer_target
required_existing_rules[]
allowed_existing_rules[]
forbidden_rules[]
track_policy: PRESET | PLAYER_BUILD
cargo_types[]
expected_encounter_pattern
common_failure_observation
hint_ladder[]
target_duration_min_seconds
target_duration_max_seconds
difficulty_topology: 0..3
difficulty_stack_entropy: 0..3
difficulty_execution_branching: 0..3
progression_required: false
leaderboard_enabled: false
reward_class: COMPLETION_MARK_ONLY
runtime_dependency: NONE | <authority key>
```

Validation metadata such as `expected_encounter_pattern` is not shipped as a normal answer overlay. If runtime packaging includes authoring metadata, solution-bearing fields must remain development-only or excluded from player presentation APIs.

## 3. Rule availability matrix

### Through Stage 5 · Stack Lab allow-list

Allowed:

- fixed/preset finite route traversal;
- cargo pickup;
- station auto unload;
- LIFO/TOP;
- manual load hold;
- auto load toggle;
- skip and later revisit on a preset loop;
- existing time limit/failure/retry/pause.

Forbidden as required solution mechanic:

- switch/crossing route-control manipulation;
- Combo optimization;
- speed/cheap track attributes;
- turnaround/bridge/tunnel;
- new objective types.

### Through Stage 6 · Switch Lab allow-list

Adds:

- SWITCH selected state;
- route-control persistence;
- occupied lock;
- planned revisit/change timing.

Constraints:

- preset track by default;
- at most 3 route controls, initial set at 1~2 for launch content;
- load/stack complexity subordinate to switch learning;
- no reaction-only timing window.

### Through Stage 8 · Builder Lab allow-list

Adds approved Stage 8 concepts:

- player BUILD;
- geometry cost/refund;
- blocked cells;
- fast/cheap track attribute tradeoff once authoritative runtime exists.

Current runtime note:

`TrackPiece` currently represents only `STRAIGHT/CURVE/SWITCH/CROSSING`, rotation, switch initial exit and geometry cost. Therefore fast/cheap attribute content is dependency-gated rather than invented by 057.

## 4. Lab progression state

Logical state model:

```text
LabLaneState
- unlocked: bool
- puzzle_clears: bitset/ids
- completion_mark: bool

Lab unlock predicate:
- STACK   = tutorial_stage_5_clear
- SWITCH  = tutorial_stage_6_clear
- BUILDER = tutorial_stage_8_clear

Within lane:
- puzzle 01 available when lane unlocks
- puzzle N+1 available when puzzle N clear
- exiting lane never changes campaign eligibility
- all four clear → completion_mark=true
```

`completion_mark` is display metadata only. It is not currency, power, XP, star requirement, chapter requirement or leaderboard eligibility.

## 5. Mastery progression state

```text
MasteryState
- unlocked: bool
- clear: bool
- completion_mark: bool

unlock = chapter_core_clear_count >= 2
next_chapter_unlock = chapter_core_clear_count >= 2
```

Both predicates trigger from the same core count, independently. Mastery cannot delay the next chapter.

Mastery remains replayable after clear and after later chapters unlock.

## 6. Difficulty rubric

Each axis is integer `0..3`; it is an internal author/review rubric, not a displayed composite score.

### Topology Complexity

- 0: linear/preset simple loop, no meaningful alternate path.
- 1: one simple branch, detour, blocked obstacle or revisit.
- 2: two+ route choices or interacting loop/crossing/revisit elements.
- 3: three+ interacting route choices or late special topology plus multi-revisit.

### Stack Entropy

- 0: one cargo type or no meaningful stack decision.
- 1: two types, expected depth ≤2, one direct reverse-order relation.
- 2: 2~3 types, expected depth 3~4 or one meaningful skip/revisit/grouping decision.
- 3: three types, expected depth ≥4 and 2+ interacting TOP-block/grouping/skip decisions.

### Execution Branching

- 0: no route control.
- 1: one control and ≤1 meaningful change/single visit choice.
- 2: 1~2 controls and 2~3 meaningful changes, or one explicit occupied-lock planning moment.
- 3: 2~3 controls and 4+ meaningful changes or multiple interacting visit-order/lock moments.

Target envelopes:

```text
Lab 01: primary=1; others 0~1
Lab 02: primary=2; others 0~1
Lab 03: primary=2; others 0~1
Lab 04: primary=2; one secondary may reach 2
Core: one primary axis
Exam: two axes may combine
Mastery: primary 2~3 + at least one secondary 1~2
```

Human calibration overrides numeric authoring assumptions but cannot introduce an unapproved rule.

## 7. Hint contract

Yard Labs inherit request-only hint behavior. Maximum ladder:

1. rule family;
2. relevant cell/state;
3. action class.

Example:

```text
TOP 순서를 확인해 보세요
→ 첫 RED 역에 도착할 때 TOP을 보세요
→ BLUE를 지금 싣지 않고 나중에 만나는 방법도 있습니다
```

Forbidden:

- full route;
- exact switch timeline;
- exact load/skip script;
- auto solve.

## 8. Mastery archetype library

- `M-JUNCTION`: execution branching primary, low stack entropy.
- `M-CARGO`: stack entropy primary, alternating cargo/TOP blocks/revisit.
- `M-BUDGET`: topology + current geometry-cost tradeoff.
- `M-EXPRESS`: fast/cheap attribute dependency-gated.
- `M-LOOP`: topology + stack revisit.
- `M-GRAND`: 2~3 already-known axes, no new rule.

One chapter chooses at most one archetype.

## 9. Runtime/content dependency split

```yaml
manual_auto_load_runtime: PRESENT
switch_route_control_runtime: PRESENT
basic_geometry_cost_runtime: PRESENT
fast_cheap_track_attribute_runtime: NOT_PRESENT_AS_AUTHORITATIVE_TRACKPIECE_FIELD
campaign_lab_progress_store: NOT_CURRENTLY_IMPLEMENTED_AS_057_OWNER
057_content_blueprints: COMPLETE_PLANNING
057_stack_switch_basic_builder: READY_PLANNING
057_fast_cheap_builder: BLOCKED_BY_STAGE8_TRACK_ATTRIBUTE_RUNTIME
057_runtime_implementation: NOT_AUTHORIZED
```

The content catalog may specify BL-03/M-EXPRESS now, but production map/runtime work for those items cannot begin until the Stage 8 attribute owner exists.

## 10. Automated/content validation

Required contracts:

1. Tutorial order equals approved 1~10 list.
2. Lab lane anchors exactly 5/6/8.
3. lane has exactly four launch blueprints with ids `01..04`.
4. Stack Lab required rules subset of Stage≤5 allow-list.
5. Switch Lab required rules subset of Stage≤6 allow-list and route-control count ≤3.
6. Builder dependency fields truthfully reflect runtime capability.
7. Lab/Mastery progression_required always false.
8. reward class only completion mark; no gameplay/currency/stat payload.
9. leaderboard disabled initially.
10. Mastery rules subset of chapter-known rules.
11. Mastery count ≤1 per chapter.
12. next-chapter predicate has no Mastery/Lab dependency.
13. solution-bearing authoring metadata is inaccessible from normal player presentation.

## 11. Human validation

When 057 content is included in an exact acceptance build:

- enable `PLAYTEST_PLAN` FS-16 for Lab transfer;
- enable FS-17 for Mastery optionality;
- preserve minimum 5 analyzable first-contact sessions and 4/5 threshold;
- evaluate Lab → next campaign application without fresh explanation;
- evaluate skip/abandon Mastery → next chapter path without friction or misunderstanding.

30~90 second Lab target is TEST_VALUE and may be recalibrated from observation.

## 12. Scope boundary

- no actual map JSON, campaign UI, progress store or runtime code in this planning package;
- no change to SX-DEC-034 order/progression;
- no gameplay power/reward economy;
- no leaderboard;
- no dependency on SX-DEC-056 Route Probe for solvability;
- no invented fast/cheap runtime field;
- implementation still needs explicit authority after delta DoR.
