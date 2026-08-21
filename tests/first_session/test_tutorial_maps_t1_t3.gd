extends "res://tests/test_case.gd"

const LoaderScript := preload("res://game/finite/map/finite_map_loader.gd")
const BuildSessionScript := preload("res://game/finite/build/finite_build_session.gd")
const FactoryScript := preload("res://game/finite/run/finite_run_session_factory.gd")
const T12Solution := preload("res://tests/fixtures/first_session/tut_01_02_solution.gd")
const T3Solution := preload("res://tests/fixtures/first_session/tut_03_solution.gd")


func run() -> void:
	var t12: Dictionary = _run_map(
		"res://data/maps/tutorial/tut_01_02.json", T12Solution.pieces()
	)
	assert_true(bool(t12.get("preflight", false)), "T1/T2 witness passes preflight")
	assert_equal(t12.get("phase"), &"SUCCESS", "T1/T2 manual witness succeeds")
	assert_equal(t12.get("pickups"), [&"RED_STAR"], "T1/T2 has one matching cargo")
	var has_curve: bool = false
	for piece: Variant in T12Solution.pieces():
		has_curve = has_curve or piece.geometry == &"CURVE"
	assert_true(has_curve, "T1/T2 witness teaches at least one curve")

	var t3: Dictionary = _run_map(
		"res://data/maps/tutorial/tut_03_lifo.json", T3Solution.pieces()
	)
	assert_true(bool(t3.get("preflight", false)), "T3 witness passes preflight")
	assert_equal(t3.get("phase"), &"SUCCESS", "T3 LIFO witness succeeds")
	assert_equal(
		t3.get("pickups"),
		[&"BLUE_DIAMOND", &"RED_STAR"],
		"T3 requires reverse pickup order"
	)
	assert_equal(t3.get("unloads"), [&"RED_STAR", &"BLUE_DIAMOND"], "T3 unloads TOP order")


func _run_map(path: String, pieces: Array) -> Dictionary:
	var definition: Variant = LoaderScript.load_from_path(path)
	if definition == null:
		return {}
	var build: Variant = BuildSessionScript.new(definition)
	for piece: Variant in pieces:
		var placement: Variant = build.place_piece(piece)
		if not placement.success:
			return {"placement_error": placement.code, "cell": piece.cell}
	var preflight: Variant = build.begin_run()
	if preflight == null or not preflight.passed:
		return {"preflight": false, "reason": preflight.primary_code if preflight != null else &"NULL"}
	var factory: Variant = FactoryScript.new()
	if not factory.configure(definition, build.sealed_snapshot(), 4.0):
		return {"preflight": true, "factory": false}
	var attempt: Dictionary = factory.create_attempt(1)
	if not bool(attempt.get("success", false)):
		return {"preflight": true, "factory": false}
	var session: Variant = attempt["session"]
	var history: Array = []
	session.delivery_loop.delivery_event_created.connect(func(event: Variant) -> void: history.append(event))
	session.input_state.set_manual_load_active(true)
	session.run_controller.start()
	for _step: int in range(2000):
		var phase: StringName = session.run_controller.run_state().phase()
		if phase == &"SUCCESS" or phase == &"FAILURE":
			break
		session.run_controller.advance_time(0.05)
	var pickups: Array[StringName] = []
	var unloads: Array[StringName] = []
	for event: Variant in history:
		if event.picked_up:
			pickups.append(event.pickup_type)
		if int(event.unload_count) > 0:
			unloads.append(event.unloaded_items[0])
	return {
		"preflight": true,
		"phase": session.run_controller.run_state().phase(),
		"pickups": pickups,
		"unloads": unloads,
	}
