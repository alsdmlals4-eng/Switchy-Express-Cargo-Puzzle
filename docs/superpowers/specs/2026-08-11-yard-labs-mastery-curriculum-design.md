# SX-DEC-057 Yard Labs / Mastery Curriculum Design

Status: `USER_APPROVED_DESIGN · IMPLEMENTATION_DEFERRED`

Decision owner: `docs/decisions/SX_DEC_057_YARD_LABS_AND_MASTERY_CURRICULUM.md`

## Goal

기존 Tutorial 1~10과 본편 규칙을 바꾸지 않고, 짧은 격리 연습과 optional mastery 문제로 `이해 → 적용 → 전이`를 강화한다.

## Content architecture

```text
Tutorial 1~10 (existing order)
├─ after Stage 5: Stack Lab lane
├─ after Stage 6: Switch Lab lane
└─ after Stage 8: Builder Lab lane

Chapter N
├─ Core A
├─ Core B
├─ Core C
└─ Optional Mastery Spur

clear any 2 Core → next chapter
Mastery Spur → never required for progression
```

## Lab schema

각 Lab 문제는 다음 공통 메타데이터를 가진다.

```text
lab_type: STACK | SWITCH | BUILDER
primary_learning_target
allowed_existing_rules[]
forbidden_new_rules[]
target_duration: TEST_VALUE
difficulty_axes:
  topology
  stack_entropy
  execution_branching
progression_required: false
leaderboard_enabled: false
```

### Stack Lab

주 학습:

- LIFO/TOP
- manual/auto load
- skip/revisit consequence

설계 원칙:

- topology complexity 최소화
- switch complexity 최소화
- cargo/station 관계를 작게 유지
- 결과는 stack order 이해를 드러내야 한다.

### Switch Lab

주 학습:

- selected direction
- occupied lock
- planned visit order execution

설계 원칙:

- track layout은 미리 배치된 문제 우선
- 1~3 switch 중심
- load 복잡도는 낮게
- pause 허용
- 반사신경 요구보다 사전 판단을 우선

### Builder Lab

주 학습:

- topology
- cost/refund
- normal/fast/cheap tradeoff
- encounter order effect

설계 원칙:

- cargo/station 요구 단순화
- 한두 geometry/attribute만 중심
- 연결 가능한 route와 더 효율적인 route를 구분
- main free-build/refund contract 유지

## Mastery Spur schema

```text
chapter_id
rules_reused[]
primary_axis
secondary_axes[]
introduces_new_rule: false
required_for_progression: false
reward_class: COSMETIC_ONLY | COMPLETION_MARK
```

Mastery Spur는 core보다 높은 결합 난이도를 허용하지만 해당 chapter에서 이미 배운 규칙만 사용한다.

## Difficulty model

각 문제는 3축을 별도로 태깅한다.

### Topology Complexity

0~N internal ordinal. 정식 수치 기준은 content calibration에서 고정한다.

관찰 요소:

- blocked cells
- loop
- crossing
- branch
- revisit
- turnaround/bridge/tunnel late content

### Stack Entropy

관찰 요소:

- type alternation
- TOP block opportunity
- contiguous group design
- max expected stack depth
- skip/revisit need

### Execution Branching

관찰 요소:

- switch count
- meaningful switch decision count
- visit-order candidates
- lock-state moments

Core stage는 한 축을 주제로 한다. Exam/Mastery는 2~3축을 결합할 수 있다.

## Progression rules

- Lab completion은 chapter unlock 조건에 포함하지 않는다.
- Mastery Spur completion은 다음 chapter unlock 조건에 포함하지 않는다.
- Lab/Mastery reward는 power/progression stat을 바꾸지 않는다.
- 사용자는 Lab/Mastery를 중단하고 core progression으로 돌아갈 수 있다.

## Error/content safety

- LabDefinition이 승인되지 않은 rule ID를 참조하면 content validation fail.
- Mastery Spur가 new rule flag를 갖거나 chapter-known-rules 밖의 rule을 참조하면 fail.
- progression_required=true인 Lab/Mastery content는 fail.
- leaderboard/power reward가 Lab에 연결되면 초기 계약 위반으로 fail.

## Validation

Automated/content contracts:

1. Tutorial order exactly preserved.
2. Stack/Switch/Builder Lab unlock anchors are Stage 5/6/8.
3. Lab rules are subsets of approved core rule IDs.
4. Mastery rules are subsets of chapter-known rules.
5. Lab/Mastery are not required for progression.
6. reward class cannot grant gameplay power.

Human/level-design contracts:

- Lab 직후 campaign에서 같은 rule을 새 설명 없이 적용하는가.
- Mastery 포기 후 core progression으로 자연스럽게 복귀하는가.
- Core와 Mastery solve attempts/hint demand가 의도한 난이도 차이를 보이는가.

## Scope boundary

이 spec은 content/runtime 구현 계획이 아니다. 실제 level data, UI entry, persistence 구현 전 delta DoR가 필요하다.
