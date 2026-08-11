class_name SemanticRuntimeState
extends RefCounted


static func stack_primary_state(model: Dictionary) -> StringName:
	var phase := StringName(model.get("phase", &""))
	if phase == &"PAUSED":
		return &"paused"
	if phase == &"UNLOADING" or bool(model.get("unload_visual_active", false)):
		return &"unloading"

	var tokens: Variant = model.get("stack_tokens", [])
	var count := tokens.size() if tokens is Array else 0
	if count <= 0:
		return &"empty"
	if count >= 32:
		return &"32plus"
	if count >= 16:
		return &"16plus"
	if count >= 8:
		return &"8plus"
	return &"compact"


static func contiguous_top_group_size(tokens: Array) -> int:
	if tokens.is_empty():
		return 0
	var top: Variant = tokens[tokens.size() - 1]
	if not top is Dictionary:
		return 0
	var cargo_type := StringName(top.get("cargo_type", &""))
	if cargo_type == &"":
		return 0

	var count := 0
	for index: int in range(tokens.size() - 1, -1, -1):
		var token: Variant = tokens[index]
		if not token is Dictionary:
			break
		if StringName(token.get("cargo_type", &"")) != cargo_type:
			break
		count += 1
	return count


static func manual_load_state(model: Dictionary) -> StringName:
	if StringName(model.get("phase", &"")) == &"PAUSED":
		return &"paused_disabled"
	if bool(model.get("manual_load_active", false)):
		return &"manual_held"
	return &"manual_idle"


static func auto_load_state(model: Dictionary) -> StringName:
	if StringName(model.get("phase", &"")) == &"PAUSED":
		return &"paused_disabled"
	if bool(model.get("auto_load_active", false)):
		return &"auto_on"
	return &"auto_off"


static func preflight_summary_state(model: Dictionary) -> StringName:
	if bool(model.get("passed", false)) or bool(model.get("start_enabled", false)):
		return &"clear"
	var cells: Variant = model.get("problem_cells", [])
	if cells is Array and cells.size() > 1:
		return &"multi_issue_summary"
	return &"primary_issue"


static func preflight_focus_state(model: Dictionary) -> StringName:
	var cells: Variant = model.get("problem_cells", [])
	if cells is Array and not cells.is_empty():
		return &"focused_location"
	return &""


static func placement_state(ghost: Dictionary, snapshot: Dictionary) -> StringName:
	if ghost.is_empty():
		return &""
	var phase := StringName(ghost.get("phase", snapshot.get("phase", &"")))
	if phase != &"BUILD":
		return &""
	if not bool(ghost.get("valid", false)):
		return &"invalid"

	var cell: Variant = ghost.get("cell", null)
	var pieces: Variant = snapshot.get("layout_pieces", [])
	if pieces is Array:
		for item: Variant in pieces:
			if item is Dictionary and item.get("cell", null) == cell:
				return &"replacement_preview"

	var rotation := int(ghost.get("rotation_quarters", ghost.get("selected_rotation_quarters", 0)))
	if rotation != 0:
		return &"rotate_preview"
	return &"valid"


static func route_target_state(target: Dictionary) -> StringName:
	if bool(target.get("locked", target.get("occupied_locked", false))):
		return &"occupied_locked"
	if bool(target.get("selected", false)):
		return &"selected"
	return &"unselected"


static func terminal_event(outcome: StringName, reason: StringName) -> StringName:
	if outcome == &"SUCCESS":
		return &"success"
	if outcome != &"FAILURE":
		return &""
	if reason == &"ROUTE_END":
		return &"route_end"
	if reason == &"TIME_EXPIRED":
		return &"time_expired"
	return &"failure"
