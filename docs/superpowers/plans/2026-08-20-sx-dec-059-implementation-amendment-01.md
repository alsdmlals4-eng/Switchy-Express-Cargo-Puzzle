# SX-DEC-059 Implementation Plan · Amendment 01

```yaml
status: BINDING_AMENDMENT
supersedes:
  - implementation_plan_execution_preflight_repo_path_assignment
  - Task_1_Step_4_illustrative_pass_blocks
reason:
  - LOCATION_FIRST_MUST_NOT_GUESS_LOCAL_PATH
  - WRITING_PLAN_MUST_NOT_CONTAIN_IMPLEMENTATION_PLACEHOLDERS
```

This amendment is read **after** `2026-08-20-sx-dec-059-first-session-vertical-slice-implementation.md` and overrides the specific items below. All other tasks remain unchanged.

## A. Execution preflight repo path override

Do **not** use the example fixed `$Repo` assignment from the parent plan. Resolve the checkout by Git remote identity using `SX_DEC_059_CODEX_HANDOFF_PACKAGE.md`.

If zero or multiple matching checkouts are found, block. Do not clone a new copy, guess a path, reset another branch, or switch the PR #154 worktree in place.

## B. Exact `FirstSessionDefinition` implementation contract

The parent plan's `pass` lines are API sketches only and must not appear in production. Implement the minimal loader below after the RED test fails for the expected missing-owner reason.

```gdscript
class_name FirstSessionDefinition
extends RefCounted

const SELF_SCRIPT_PATH := "res://game/first_session/first_session_definition.gd"
const SCHEMA_VERSION := 1
const REQUIRED_IDS: Array[StringName] = [
    &"T1", &"T2", &"T3", &"T4", &"T5", &"T6", &"CAPSTONE",
]

var _lesson_ids: Array[StringName] = []
var _lessons: Dictionary = {}


static func load_from_path(path: String) -> Variant:
    if not FileAccess.file_exists(path):
        return null
    var file := FileAccess.open(path, FileAccess.READ)
    if file == null:
        return null
    var parsed: Variant = JSON.parse_string(file.get_as_text())
    if not parsed is Dictionary:
        return null
    return create(parsed)


static func create(data: Dictionary) -> Variant:
    if int(data.get("schema_version", 0)) != SCHEMA_VERSION:
        return null
    if str(data.get("sequence_id", "")) != "FIRST_SESSION_V1":
        return null
    var raw_lessons: Variant = data.get("lessons", [])
    if not raw_lessons is Array or raw_lessons.size() != REQUIRED_IDS.size():
        return null

    var value: Variant = load(SELF_SCRIPT_PATH).new()
    for index: int in range(REQUIRED_IDS.size()):
        var raw: Variant = raw_lessons[index]
        if not raw is Dictionary:
            return null
        var lesson: Dictionary = raw
        var lesson_id := StringName(lesson.get("lesson_id", &""))
        if lesson_id != REQUIRED_IDS[index] or value._lessons.has(lesson_id):
            return null
        if str(lesson.get("map_path", "")) == "":
            return null
        if not lesson.get("visible_features", []) is Array:
            return null
        if not lesson.get("allowed_build_tools", []) is Array:
            return null
        if not lesson.get("allowed_build_commands", []) is Array:
            return null
        if not lesson.get("allowed_run_commands", []) is Array:
            return null
        value._lesson_ids.append(lesson_id)
        value._lessons[lesson_id] = lesson.duplicate(true)

    if (
        str(value._lessons[&"T1"].get("map_path", ""))
        != str(value._lessons[&"T2"].get("map_path", ""))
    ):
        return null
    if str(value._lessons[&"CAPSTONE"].get("map_path", "")) != "res://data/maps/vs_demo_01.json":
        return null
    return value


func lesson_ids() -> Array[StringName]:
    return _lesson_ids.duplicate()


func lesson(lesson_id: StringName) -> Dictionary:
    if not _lessons.has(lesson_id):
        return {}
    return (_lessons[lesson_id] as Dictionary).duplicate(true)
```

Do not generalize this into a campaign/progression framework in SX-DEC-059.

## C. Exact StagePolicy minimum implementation shape

After the StagePolicy RED test, implement the smallest policy owner with these semantics:

```gdscript
class_name FirstSessionStagePolicy
extends RefCounted

const SELF_SCRIPT_PATH := "res://game/first_session/first_session_stage_policy.gd"

var _visible: Dictionary = {}
var _build_tools: Dictionary = {}
var _build_commands: Dictionary = {}
var _run_commands: Dictionary = {}
var _context_key: StringName = &""


static func create(lesson: Dictionary) -> Variant:
    if lesson.is_empty():
        return null
    var value: Variant = load(SELF_SCRIPT_PATH).new()
    for raw: Variant in lesson.get("visible_features", []):
        value._visible[StringName(raw)] = true
    for raw: Variant in lesson.get("allowed_build_tools", []):
        value._build_tools[StringName(raw)] = true
    for raw: Variant in lesson.get("allowed_build_commands", []):
        value._build_commands[StringName(raw)] = true
    for raw: Variant in lesson.get("allowed_run_commands", []):
        value._run_commands[StringName(raw)] = true
    value._context_key = StringName(lesson.get("context_key", &""))
    return value


func allows_command(command: StringName, phase: StringName, payload: Variant = null) -> bool:
    if phase == &"BUILD":
        if not _build_commands.has(command):
            return false
        if command == &"BUILD_TOOL":
            return _build_tools.has(StringName(payload))
        return true
    if phase == &"RUNNING" or phase == &"UNLOADING":
        return _run_commands.has(command)
    if phase == &"PAUSED":
        return command == &"RESUME" and _run_commands.has(&"RESUME")
    return false


func feature_visible(feature: StringName) -> bool:
    return _visible.has(feature)


func visible_features() -> Array[StringName]:
    var result: Array[StringName] = []
    for key: Variant in _visible.keys():
        result.append(StringName(key))
    return result


func context_key() -> StringName:
    return _context_key
```

The exact class may add defensive validation required by tests, but it must not gain gameplay/domain authority.

## D. Tutorial map authoring is deliberately RED-derived, not a missing design placeholder

The parent plan does not predeclare every track cell because `FIRST_SESSION_STAGE_CONTENT_SPEC_V1.md` explicitly assigns exact map bytes to BUILD-time deterministic validation.

For every tutorial map task, the required action is concrete:

```text
1. write the stated structural + behavioral RED test
2. confirm it fails because the map/private witness is absent or violates that exact contract
3. author the smallest handcrafted map + private witness
4. run until the exact contract is GREEN
5. keep the committed JSON bytes as the resulting authored content
```

Changing finite-domain rules to make a candidate map pass is forbidden. If no small authored map can satisfy the approved contract using current rules, stop that map task and report the design/implementation conflict.

## E. Handoff read order amendment

At actual Codex execution, read this amendment immediately after the parent implementation plan and before editing production files.
