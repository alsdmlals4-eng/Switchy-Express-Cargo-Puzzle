extends "res://tests/test_case.gd"

const Loader := preload("res://game/finite/map/finite_map_loader.gd")
const Build := preload("res://game/finite/build/finite_build_session.gd")
const Factory := preload("res://game/finite/run/finite_run_session_factory.gd")
const Piece := preload("res://game/finite/build/track_piece.gd")
const FIXTURE_PATH := "res://tests/fixtures/route_book/route_book_03_witnesses.gd"
const IDS: Array[StringName] = [
	&"RB13_FOUR_SIDES", &"RB14_MANIFEST_MIRROR", &"RB15_MANUAL_GAP",
	&"RB16_CAUTION_LEDGER", &"RB17_CLEARANCE_YARD", &"RB18_SWITCHBOARD_NIGHT",
]
var results: Array[Dictionary] = []


func run() -> void:
	results.clear()
	for stage_id: StringName in IDS:
		run_stage(stage_id)
	assert_equal(results.size(), 6, "six complete positive/negative witnesses, not merely six maps")


func run_stage(stage_id: StringName) -> void:
	var definition: Variant = Loader.load_from_path("res://data/maps/route_book/" + str(stage_id).to_lower() + ".json")
	assert_not_null(definition, str(stage_id) + " authored map exists and validates")
	if definition == null:
		return
	assert_equal(definition.map_id, stage_id, "exact authored identity")
	assert_true(ResourceLoader.exists(FIXTURE_PATH), "authored test-only witness fixture exists")
	if not ResourceLoader.exists(FIXTURE_PATH):
		return
	var fixture: Script = load(FIXTURE_PATH)
	var positive := _exercise(stage_id, definition, fixture, false)
	var negative := _exercise(stage_id, definition, fixture, true)
	assert_equal(positive.get("phase"), &"SUCCESS", str(stage_id) + " actual positive success")
	assert_equal(negative.get("phase"), &"PREFLIGHT_REJECTED" if stage_id == &"RB13_FOUR_SIDES" else &"FAILURE", str(stage_id) + " exact negative outcome")
	var expected_pickups: Array = [&"BLUE_DIAMOND", &"RED_STAR"]
	var expected_unloads: Array = [&"RED_STAR", &"BLUE_DIAMOND"]
	match stage_id:
		&"RB14_MANIFEST_MIRROR":
			expected_pickups = [&"BLUE_DIAMOND", &"RED_STAR", &"RED_STAR"]
			expected_unloads = [&"RED_STAR", &"RED_STAR", &"BLUE_DIAMOND"]
			assert_equal(positive.get("groups"), [2, 1], "RB14 contiguous red TOP group")
			assert_equal(negative.get("pickups"), [&"RED_STAR", &"BLUE_DIAMOND", &"RED_STAR"], "RB14 negative changes actual pickup order")
		&"RB15_MANUAL_GAP":
			assert_equal(positive.get("revisit_pickups"), [false, true], "RB15 skip first red contact, load second")
			assert_equal(negative.get("pickups"), [&"RED_STAR", &"BLUE_DIAMOND"], "RB15 Auto negative first-contact order")
		&"RB16_CAUTION_LEDGER":
			assert_true(positive.get("lock_rejected", false), "RB16 occupied switch rejects change")
			assert_true(negative.get("lock_rejected", false), "RB16 wrong exit cannot change while occupied")
			assert_true(positive.get("selected_unchanged", false), "RB16 positive selected UP unchanged")
			assert_true(negative.get("selected_unchanged", false), "RB16 negative selected EAST unchanged")
		&"RB17_CLEARANCE_YARD":
			expected_pickups = [&"WASTE_CRATE", &"WASTE_CRATE", &"RED_STAR"]
			expected_unloads = [&"RED_STAR", &"WASTE_CRATE", &"WASTE_CRATE"]
			assert_equal(positive.get("groups"), [1, 2], "RB17 two-waste disposal group")
			assert_equal(negative.get("pickups"), [&"RED_STAR", &"WASTE_CRATE", &"WASTE_CRATE"], "RB17 negative loads red before waste")
		&"RB18_SWITCHBOARD_NIGHT":
			expected_pickups = [&"WASTE_CRATE", &"WASTE_CRATE", &"BLUE_DIAMOND", &"RED_STAR"]
			expected_unloads = [&"RED_STAR", &"BLUE_DIAMOND", &"WASTE_CRATE", &"WASTE_CRATE"]
			assert_equal(positive.get("groups"), [1, 1, 2], "RB18 waste group follows both ordinary deliveries")
			assert_equal(positive.get("revisit_pickups"), [false, true], "RB18 first red skip and second manual pickup")
			assert_true(positive.get("auto_transition", false), "RB18 actual Auto ON then OFF")
			assert_true(positive.get("lock_rejected", false), "RB18 exact switch [6,5] rejects occupied change")
			assert_true(positive.get("selected_unchanged", false), "RB18 switch remains UP")
			assert_equal(negative.get("pickups"), [&"WASTE_CRATE", &"WASTE_CRATE", &"RED_STAR", &"BLUE_DIAMOND"], "RB18 Auto negative contacts all four")
	assert_equal(positive.get("pickups"), expected_pickups, str(stage_id) + " exact pickup sequence")
	assert_equal(positive.get("unloads"), expected_unloads, str(stage_id) + " exact unload sequence")
	if stage_id != &"RB13_FOUR_SIDES":
		var negative_unloads: Array = [&"BLUE_DIAMOND"]
		var remaining: Array = [&"RED_STAR"]
		match stage_id:
			&"RB14_MANIFEST_MIRROR": negative_unloads = [&"RED_STAR", &"BLUE_DIAMOND"]
			&"RB16_CAUTION_LEDGER":
				negative_unloads = []
				remaining = [&"BLUE_DIAMOND", &"RED_STAR"]
				assert_equal(negative.get("last_cell"), Vector2i(9, 5), "RB16 negative ends at EAST spur")
			&"RB17_CLEARANCE_YARD":
				negative_unloads = [&"WASTE_CRATE", &"WASTE_CRATE"]
				assert_equal(negative.get("groups"), [2], "RB17 negative still disposes waste pair")
			&"RB18_SWITCHBOARD_NIGHT": remaining = [&"WASTE_CRATE", &"WASTE_CRATE", &"RED_STAR"]
		assert_equal(negative.get("failure_reason"), &"ROUTE_END", "negative is authored route end, not timeout")
		assert_equal(negative.get("unloads"), negative_unloads, "negative exact unload sequence")
		assert_equal(negative.get("remaining_stack"), remaining, "negative exact remaining stack")
		assert_equal(negative.get("remaining_map_cargo"), 0, "negative contacts all required map cargo")
	results.append({"stage": str(stage_id), "positive": positive, "negative": negative})
	print("BOOK03_RESULT " + JSON.stringify(results.back()))


func _exercise(stage_id: StringName, definition: Variant, fixture: Script, negative: bool) -> Dictionary:
	var build: Variant = Build.new(definition)
	var pieces: Array = fixture.pieces(stage_id, negative)
	assert_false(pieces.is_empty(), str(stage_id) + " nonempty authored rail layout")
	for piece: Variant in pieces:
		assert_not_null(piece, "valid encoded piece")
		if piece == null:
			return {}
		var placement: Variant = build.place_piece(piece)
		assert_true(placement.success, "%s placement %s %s" % [stage_id, piece.cell, placement.code])
		if not placement.success:
			return {}
	if stage_id == &"RB13_FOUR_SIDES":
		var footprint: Variant = build.place_piece(Piece.create(Vector2i(6, 2), &"STRAIGHT", 0, Vector2i.ZERO))
		assert_false(footprint.success, "RB13 station footprint cannot become player track")
	var preflight: Variant = build.begin_run()
	if negative and stage_id == &"RB13_FOUR_SIDES":
		assert_false(preflight.passed, "RB13 diagonal-only service rejected before RUN")
		assert_equal(preflight.primary_code, &"UNREACHABLE_STATION_SERVICE", "RB13 exact service error; cargo reachability is checked earlier")
		assert_equal(preflight.problem_cells, [Vector2i(6, 2)], "only red service is unreachable; blue service is valid")
		return {"phase": &"PREFLIGHT_REJECTED" if not preflight.passed else &"UNEXPECTED_PREFLIGHT_PASS", "code": str(preflight.primary_code)}
	assert_true(preflight.passed, "%s preflight %s" % [stage_id, preflight.primary_code])
	if not preflight.passed:
		return {}
	var factory: Variant = Factory.new()
	assert_true(factory.configure(definition, build.sealed_snapshot(), 2.0), "existing factory accepts authored layout")
	var attempt: Dictionary = factory.create_attempt(1)
	assert_true(attempt.get("success", false), "fresh actual attempt created")
	var session: Variant = attempt.get("session")
	if session == null:
		return {}
	var history: Array = []
	session.delivery_loop.delivery_event_created.connect(func(event: Variant) -> void: history.append(event))
	var initial: Dictionary = fixture.drive(stage_id, history, session, negative)
	var switch_cell: Vector2i = initial.get("switch_cell", Vector2i(-1, -1))
	var desired_exit: Vector2i = initial.get("desired_exit", Vector2i.ZERO)
	if desired_exit != Vector2i.ZERO:
		assert_true(session.graph.select_switch_exit(switch_cell, desired_exit), "preselect authored switch before train occupancy")
	assert_true(session.run_controller.start(), "real RUN starts")
	var observed := {"lock_rejected": false, "selected_unchanged": false, "auto_transition": false}
	var auto_seen := false
	for _step: int in range(5000):
		if session.run_controller.run_state().phase() in [&"SUCCESS", &"FAILURE"]:
			break
		var command: Dictionary = fixture.drive(stage_id, history, session, negative)
		session.input_state.set_manual_load_active(command.get("manual", false))
		var auto_requested: bool = command.get("auto", false)
		if auto_requested != session.input_state.is_auto_load_enabled():
			session.input_state.toggle_auto_load()
		if auto_requested:
			auto_seen = true
		elif auto_seen:
			observed.auto_transition = true
		if desired_exit != Vector2i.ZERO and session.train.current_cell() == switch_cell and not observed.lock_rejected:
			var before: Vector2i = _selected(session.graph, switch_cell)
			var other := Vector2i.RIGHT if desired_exit == Vector2i.UP else Vector2i.UP
			observed.lock_rejected = not session.graph.select_switch_exit(switch_cell, other)
			observed.selected_unchanged = before == desired_exit and _selected(session.graph, switch_cell) == before
		session.run_controller.advance_time(0.05)
	var pickups: Array = []
	var unloads: Array = []
	var groups: Array = []
	var revisits: Array = []
	var revisit_cell := Vector2i(5, 4) if stage_id == &"RB15_MANUAL_GAP" else Vector2i(7, 4)
	for event: Variant in history:
		if event.picked_up:
			pickups.append(event.pickup_type)
		if event.unload_count > 0:
			unloads.append_array(event.unloaded_items)
			groups.append(event.unload_count)
		if event.cell == revisit_cell:
			revisits.append(event.picked_up)
	observed.merge({"phase": session.run_controller.run_state().phase(), "pickups": pickups,
		"unloads": unloads, "groups": groups, "revisit_pickups": revisits,
		"elapsed_seconds": session.run_controller.run_state().elapsed_seconds()})
	var summary: Variant = session.run_controller.summary()
	assert_not_null(summary, str(stage_id) + " bounded run reaches real terminal summary")
	if summary != null:
		observed["stack_size"] = summary.stack_size
		observed["remaining_map_cargo"] = summary.remaining_map_cargo
		observed["failure_reason"] = summary.failure_reason
		observed["remaining_stack"] = session.cargo_stack.load_order()
		observed["last_cell"] = session.train.current_cell()
		if negative:
			assert_true(summary.stack_size + summary.remaining_map_cargo > 0, "negative failure retains unresolved cargo")
		else:
			assert_equal(summary.stack_size + summary.remaining_map_cargo, 0, "positive leaves no unresolved cargo")
	return observed


func _selected(graph: Variant, cell: Vector2i) -> Vector2i:
	for state: Dictionary in graph.route_control_states():
		if state.get("cell") == cell:
			return state.get("selected_exit", Vector2i.ZERO)
	return Vector2i.ZERO
