extends RefCounted


static func capture_branch_targets(graph: Variant) -> Dictionary:
	var result: Dictionary = {}
	if graph == null or not graph.has_method("route_control_states"):
		return result
	for state: Dictionary in graph.route_control_states():
		if StringName(state.get("kind", &"")) != &"SWITCH":
			continue
		var cell: Vector2i = state.get("cell", Vector2i(-1, -1))
		var approach: Vector2i = state.get("approach_port", Vector2i.ZERO)
		var selected: Vector2i = state.get("selected_exit", Vector2i.ZERO)
		if selected == approach:
			for port: Vector2i in state.get("available_exits", []):
				if port != approach:
					selected = port
					break
		if cell != Vector2i(-1, -1) and selected != Vector2i.ZERO:
			result[cell] = selected
	return result


static func prepare_next_switch(session: Variant, branch_targets: Dictionary) -> void:
	if session == null or session.graph == null or session.train == null:
		return
	var target: Vector2i = session.train.target_cell()
	var piece: Variant = session.graph.piece_at(target)
	if piece == null or piece.geometry != &"SWITCH":
		return
	var incoming_port: Vector2i = session.train.current_cell() - target
	var approach: Vector2i = piece.approach_port()
	var desired: Vector2i = approach
	if incoming_port == approach:
		desired = branch_targets.get(target, piece.switch_initial_exit)
	session.graph.select_switch_exit(target, desired)


static func select_for_trace(
	graph: Variant,
	previous: Vector2i,
	current: Vector2i,
	branch_targets: Dictionary
) -> void:
	if graph == null:
		return
	var piece: Variant = graph.piece_at(current)
	if piece == null or piece.geometry != &"SWITCH":
		return
	var incoming_port := previous - current
	var approach: Vector2i = piece.approach_port()
	var desired: Vector2i = approach
	if incoming_port == approach:
		desired = branch_targets.get(current, piece.switch_initial_exit)
	graph.select_switch_exit(current, desired)
