# SX-DEC-059 Implementation Plan · Amendment 02

```yaml
status: BINDING_AMENDMENT
parent_plan: 2026-08-20-sx-dec-059-first-session-vertical-slice-implementation.md
amendment_01: 2026-08-20-sx-dec-059-implementation-amendment-01.md
reason:
  - LESSON_CARD_TITLE_KEY_TYPE_CONSISTENCY
  - CTA_LOCALIZATION_OWNER
  - HUD_STAGE_VISIBILITY_MUST_SURVIVE_MODEL_UPDATES
```

Read this after Amendment 01. It overrides the specific implementation-plan details below.

## A. First-session sequence schema includes `title_key`

Every lesson record in `data/first_session/first_session_v1.json` MUST include `title_key`.

```text
T1 → SX_T1_TITLE
T2 → SX_T2_TITLE
T3 → SX_T3_TITLE
T4 → SX_T4_TITLE
T5 → SX_T5_TITLE
T6 → SX_T6_TITLE
CAPSTONE → SX_CAPSTONE_TITLE
```

The exact records otherwise retain the parent plan's approved map paths, completion evidence, feature visibility, command allow-lists, objective keys, and context keys.

`FirstSessionDefinition.create()` must reject any lesson with an empty `title_key`, `objective_key`, or map path. `context_key` may be empty when no contextual cue is required.

Add these validations to the RED test before changing production code:

```gdscript
for lesson_id: StringName in definition.lesson_ids():
    var lesson := definition.lesson(lesson_id)
    assert_false(str(lesson.get("title_key", "")).is_empty(), "%s title_key" % lesson_id)
    assert_false(str(lesson.get("objective_key", "")).is_empty(), "%s objective_key" % lesson_id)
```

## B. CTA copy owner

Task 3 consumes both:

```text
FIRST_SESSION_LOCALIZATION_COPY_MATRIX_V1.md
FIRST_SESSION_LOCALIZATION_COPY_ADDENDUM_01.md
```

The localization JSON must include:

```text
SX_ACTION_START_LESSON
SX_ACTION_START_RUN
SX_ACTION_CONTINUE
```

Use:
- T2 same-layout Lesson Card → `SX_ACTION_START_RUN`.
- T1/T3/T4/T5/T6/CAPSTONE Lesson Card → `SX_ACTION_START_LESSON`.
- `SX_ACTION_CONTINUE` only if the final UI keeps a separate explicit continue action; do not introduce an unnecessary extra click solely because the key exists.

## C. HUD StagePolicy visibility is persistent state, not a one-shot mutation

`ProductHUD.apply_model()` currently recalculates phase visibility on every model update. Therefore `apply_stage_visibility()` must not merely hide nodes once.

Minimal production shape:

```gdscript
var _stage_visible_features: Dictionary = {}
var _stage_policy_active: bool = false

func apply_stage_visibility(visible_features: Array) -> void:
    _stage_visible_features.clear()
    _stage_policy_active = true
    for raw: Variant in visible_features:
        _stage_visible_features[StringName(raw)] = true
    _apply_stage_visibility_after_phase()

func clear_stage_visibility() -> void:
    _stage_visible_features.clear()
    _stage_policy_active = false
    apply_model(_model)

func _feature_visible(feature: StringName) -> bool:
    return not _stage_policy_active or _stage_visible_features.has(feature)
```

At the **end** of every `apply_model()` call, after normal BUILD/RUN/PAUSE/RESULT phase visibility is established, call `_apply_stage_visibility_after_phase()`.

Stage visibility may only narrow existing phase-visible controls; it must never make a phase-invalid control visible.

RED regression must prove at least:

```text
T1 policy applied
→ apply_model(BUILD) again
→ Switch/Crossing/Recommend remain hidden

T5 policy applied
→ RUN model update after AUTO_TOGGLE
→ Auto remains visible, Switch remains hidden

policy cleared
→ standalone demo current controls restore
```

## D. ProductFiniteSlice policy handoff order

When first-session mode creates/reuses a ProductFiniteSlice:

```text
instantiate
→ set map_path before add_child
→ add_child / _ready initializes current map
→ set StagePolicy once HUD exists OR have ProductFiniteSlice cache the policy and apply in _ready
```

The implementation must support both timing cases safely:

```gdscript
func set_stage_policy(policy: Variant) -> void:
    _stage_policy = policy
    if is_instance_valid(_hud):
        _apply_stage_policy_to_hud()

func _ready() -> void:
    ...existing init...
    _apply_stage_policy_to_hud()
```

Do not depend on `@onready` nodes before the product scene enters the tree.

## E. T1→T2 transition must not lose policy or layout

RED test must record a layout signature immediately before T1 preflight transition and after T2 policy activation:

```text
same ProductFiniteSlice instance identity
same layout signature
T2 policy active
START now allowed
T1-only blocked START behavior no longer applies
```

This is the contract that proves the shared-map lesson seam instead of merely checking lesson IDs.
