extends "res://tests/test_case.gd"

const LoaderScript := preload("res://game/finite/map/finite_map_loader.gd")
const BuildSessionScript := preload("res://game/finite/build/finite_build_session.gd")
const FactoryScript := preload("res://game/finite/run/finite_run_session_factory.gd")
const StarterLayouts := preload("res://game/first_session/first_session_starter_layouts.gd")

const B_CELL := Vector2i(6, 4)
const T4_A_CELL := Vector2i(5, 4)
const T5_A_CELLS: Array[Vector2i] = [Vector2i(4, 4), Vector2i(5, 4)]


func run() -> void:
	var t4: Dictionary = _run_t4()
	assert_equal(t4.get("phase"), &"SUCCESS", "T4 scaffold route succeeds")
	assert_true(bool(t4.get("first_b_skipped", false)), "T4 skips B on first encounter")
	assert_true(bool(t4.get("b_loaded_on_revisit", false)), "T4 loads B on revisit")
	assert_false(bool(t4.get("auto_used", true)), "T4 succeeds with manual load only")
	assert_equal(
		_run_naive_load_all(
			"res://data/maps/tutorial/tut_04_selective_load.json", &"TUT_04", false
		),
		&"FAILURE",
		"T4 must reject the naive load-everything strategy",
	)

	var t5: Dictionary = _run_t5()
	assert_equal(t5.get("phase"), &"SUCCESS", "T5 scaffold route succeeds")
	assert_equal(int(t5.get("auto_pickups", 0)), 2, "T5 auto-loads two safe cargos")
	assert_true(bool(t5.get("auto_turned_off", false)), "T5 turns Auto off before B")
	assert_true(bool(t5.get("manual_b_pickup", false)), "T5 uses manual load for decision cargo")
	assert_equal(
		_run_naive_load_all(
			"res://data/maps/tutorial/tut_05_auto_load.json", &"TUT_05", true
		),
		&"FAILURE",
		"T5 must reject leaving Auto enabled for every cargo",
	)
	assert_equal(
		_run_t5_manual_only(),
		&"SUCCESS",
		"T5 remains solvable with deliberate manual loading only",
	)


func _run_t4() -> Dictionary:
	var session: Variant = _create_session(
		"res://data/maps/tutorial/tut_04_selective_load.json", &"TUT_04"
	)
	if session == null:
		return {}
	var history: Array = []
	session.delivery_loop.delivery_event_created.connect(func(event: Variant) -> void: history.append(event))
	session.run_controller.start()
	for _step: int in range(3000):
		var phase: StringName = session.run_controller.run_state().phase()
		if phase == &"SUCCESS" or phase == &"FAILURE":
			break
		var target: Vector2i = session.train.target_cell()
		if target == B_CELL:
			var b_visits: int = history.filter(
				func(event: Variant) -> bool: return event.cell == B_CELL
			).size()
			session.input_state.set_manual_load_active(b_visits > 0)
		elif target == T4_A_CELL:
			session.input_state.set_manual_load_active(true)
		session.run_controller.advance_time(0.05)
	var b_events: Array = history.filter(func(event: Variant) -> bool: return event.cell == B_CELL)
	return {
		"phase": session.run_controller.run_state().phase(),
		"first_b_skipped": b_events.size() >= 2 and not b_events[0].picked_up,
		"b_loaded_on_revisit": b_events.size() >= 2 and b_events[1].picked_up,
		"auto_used": session.input_state.is_auto_load_enabled(),
	}


func _run_t5() -> Dictionary:
	var session: Variant = _create_session(
		"res://data/maps/tutorial/tut_05_auto_load.json", &"TUT_05"
	)
	if session == null:
		return {}
	var metrics := {
		"auto_pickups": 0,
		"auto_turned_off": false,
		"manual_b_pickup": false,
		"b_visits": 0,
	}
	var input_state: Variant = session.input_state
	session.delivery_loop.delivery_event_created.connect(func(event: Variant) -> void:
		if event.picked_up and T5_A_CELLS.has(event.cell) and input_state.is_auto_load_enabled():
			metrics["auto_pickups"] = int(metrics["auto_pickups"]) + 1
		if event.picked_up and event.cell == B_CELL and not input_state.is_auto_load_enabled():
			metrics["manual_b_pickup"] = true
		if event.cell == B_CELL:
			metrics["b_visits"] = int(metrics["b_visits"]) + 1
	)
	session.run_controller.start()
	for _step: int in range(3000):
		var phase: StringName = session.run_controller.run_state().phase()
		if phase == &"SUCCESS" or phase == &"FAILURE":
			break
		var target: Vector2i = session.train.target_cell()
		if T5_A_CELLS.has(target) and not session.input_state.is_auto_load_enabled():
			session.input_state.toggle_auto_load()
		elif target == B_CELL and int(metrics["b_visits"]) == 0:
			if session.input_state.is_auto_load_enabled():
				session.input_state.toggle_auto_load()
				metrics["auto_turned_off"] = true
			session.input_state.set_manual_load_active(false)
		elif target == B_CELL and int(metrics["b_visits"]) > 0:
			session.input_state.set_manual_load_active(true)
		session.run_controller.advance_time(0.05)
	return {
		"phase": session.run_controller.run_state().phase(),
		"auto_pickups": metrics["auto_pickups"],
		"auto_turned_off": metrics["auto_turned_off"],
		"manual_b_pickup": metrics["manual_b_pickup"],
	}


func _run_naive_load_all(path: String, layout_id: StringName, use_auto: bool) -> StringName:
	var session: Variant = _create_session(path, layout_id)
	if session == null:
		return &"INVALID"
	if use_auto:
		session.input_state.toggle_auto_load()
	else:
		session.input_state.set_manual_load_active(true)
	session.run_controller.start()
	_advance_until_terminal(session)
	return session.run_controller.run_state().phase()


func _run_t5_manual_only() -> StringName:
	var session: Variant = _create_session(
		"res://data/maps/tutorial/tut_05_auto_load.json", &"TUT_05"
	)
	if session == null:
		return &"INVALID"
	var metrics := {"b_visits": 0}
	session.delivery_loop.delivery_event_created.connect(func(event: Variant) -> void:
		if event.cell == B_CELL:
			metrics["b_visits"] = int(metrics["b_visits"]) + 1
	)
	session.run_controller.start()
	for _step: int in range(3000):
		var phase: StringName = session.run_controller.run_state().phase()
		if phase == &"SUCCESS" or phase == &"FAILURE":
			break
		var target: Vector2i = session.train.target_cell()
		session.input_state.set_manual_load_active(
			T5_A_CELLS.has(target)
			or (target == B_CELL and int(metrics["b_visits"]) > 0)
		)
		session.run_controller.advance_time(0.05)
	return session.run_controller.run_state().phase()


func _advance_until_terminal(session: Variant) -> void:
	for _step: int in range(3000):
		var phase: StringName = session.run_controller.run_state().phase()
		if phase == &"SUCCESS" or phase == &"FAILURE":
			return
		session.run_controller.advance_time(0.05)


func _create_session(path: String, layout_id: StringName) -> Variant:
	var definition: Variant = LoaderScript.load_from_path(path)
	if definition == null:
		return null
	var build: Variant = BuildSessionScript.new(definition)
	for piece: Variant in StarterLayouts.pieces(layout_id):
		var result: Variant = build.place_piece(piece)
		if result == null or not result.success:
			return null
	var preflight: Variant = build.begin_run()
	if preflight == null or not preflight.passed:
		return null
	var factory: Variant = FactoryScript.new()
	if not factory.configure(definition, build.sealed_snapshot(), 4.0):
		return null
	var attempt: Dictionary = factory.create_attempt(1)
	return attempt.get("session") if bool(attempt.get("success", false)) else null
