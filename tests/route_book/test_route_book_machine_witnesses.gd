extends "res://tests/test_case.gd"

const LoaderScript := preload("res://game/finite/map/finite_map_loader.gd")
const BuildSessionScript := preload("res://game/finite/build/finite_build_session.gd")
const FactoryScript := preload("res://game/finite/run/finite_run_session_factory.gd")
const FixtureScript := preload("res://tests/fixtures/route_book/route_book_witnesses.gd")

const PATHS := {
	&"RB01_SERVICE_SIDINGS": "res://data/maps/route_book/rb01_service_sidings.json",
	&"RB02_REVERSE_ORDER": "res://data/maps/route_book/rb02_reverse_order.json",
	&"RB03_RETURN_MANIFEST": "res://data/maps/route_book/rb03_return_manifest.json",
	&"RB04_LOAD_WINDOW": "res://data/maps/route_book/rb04_load_window.json",
	&"RB05_FORK_LOCK": "res://data/maps/route_book/rb05_fork_lock.json",
	&"RB06_PORT_CIRCUIT": "res://data/maps/route_book/rb06_port_circuit.json",
	&"RB07_FOREST_RELAY": "res://data/maps/route_book/rb07_forest_relay.json",
	&"RB08_CAUTION_CUT": "res://data/maps/route_book/rb08_caution_cut.json",
	&"RB09_SALVAGE_SIDING": "res://data/maps/route_book/rb09_salvage_siding.json",
	&"RB10_CLEAN_BREAK": "res://data/maps/route_book/rb10_clean_break.json",
	&"RB11_TURNOUT_UNDER_LOAD": "res://data/maps/route_book/rb11_turnout_under_load.json",
	&"RB12_LANTERN_LOOP": "res://data/maps/route_book/rb12_lantern_loop.json",
}


func run() -> void:
	var fixture: Script = FixtureScript

	var rb01 := _run_manual(fixture.pieces(&"RB01_SERVICE_SIDINGS"), PATHS[&"RB01_SERVICE_SIDINGS"])
	assert_equal(rb01.get("phase"), &"SUCCESS", "RB01 cardinal service witness succeeds")
	assert_equal(rb01.get("unload_cells"), [Vector2i(6, 3), Vector2i(7, 4)], "RB01 unloads only at legal adjacent cells")

	var rb02 := _run_manual(fixture.pieces(&"RB02_REVERSE_ORDER"), PATHS[&"RB02_REVERSE_ORDER"])
	assert_equal(rb02.get("phase"), &"SUCCESS", "RB02 reverse-order witness succeeds")
	assert_equal(rb02.get("pickups"), [&"BLUE_DIAMOND", &"RED_STAR"], "RB02 loads in reverse order")
	assert_equal(rb02.get("unloads"), [&"RED_STAR", &"BLUE_DIAMOND"], "RB02 unloads TOP order")
	assert_equal(
		_run_manual(
			fixture.pieces(&"RB02_REVERSE_ORDER"),
			PATHS[&"RB02_REVERSE_ORDER"],
			func(target: Vector2i, _history: Array, input: Variant, _session: Variant) -> void:
				input.set_manual_load_active(target == Vector2i(3, 3)),
		).get("phase"),
		&"FAILURE",
		"RB02 rejects a Blue-on-TOP forward delivery attempt",
	)

	var rb03 := _run_manual(
		fixture.pieces(&"RB03_RETURN_MANIFEST"),
		PATHS[&"RB03_RETURN_MANIFEST"],
		func(target: Vector2i, history: Array, input: Variant, _session: Variant) -> void:
			var blue_visits := history.filter(
				func(event: Variant) -> bool: return event.cell == Vector2i(5, 4)
			).size()
			input.set_manual_load_active(target == Vector2i(4, 4) or (target == Vector2i(5, 4) and blue_visits > 0)),
	)
	assert_equal(rb03.get("phase"), &"SUCCESS", "RB03 revisit witness succeeds")
	assert_true(bool(rb03.get("first_blue_skipped", false)), "RB03 skips Blue on first contact")
	assert_true(bool(rb03.get("blue_loaded_on_revisit", false)), "RB03 loads Blue on return")
	assert_equal(
		_run_manual(fixture.pieces(&"RB03_RETURN_MANIFEST"), PATHS[&"RB03_RETURN_MANIFEST"]).get("phase"),
		&"FAILURE",
		"RB03 rejects loading every cargo on first contact",
	)

	var rb04 := _run_rb04(fixture)
	assert_equal(rb04.get("phase"), &"SUCCESS", "RB04 deliberate Auto window succeeds")
	assert_equal(rb04.get("auto_red_pickups"), 2, "RB04 Auto loads the safe Red pair")
	assert_true(bool(rb04.get("auto_disabled_before_blue", false)), "RB04 turns Auto off before Blue")
	assert_true(bool(rb04.get("manual_blue_pickup", false)), "RB04 manually loads Blue later")
	assert_equal(
		_run_manual(
			fixture.pieces(&"RB04_LOAD_WINDOW"),
			PATHS[&"RB04_LOAD_WINDOW"],
			func(_target: Vector2i, _history: Array, input: Variant, _session: Variant) -> void:
				if not input.is_auto_load_enabled():
					input.toggle_auto_load(),
		).get("phase"),
		&"FAILURE",
		"RB04 rejects Auto Load left on for every contact",
	)

	var rb05 := _run_rb05(fixture, true)
	assert_equal(rb05.get("phase"), &"SUCCESS", "RB05 preselected branch succeeds")
	assert_true(bool(rb05.get("occupied_lock_rejected", false)), "RB05 rejects switch change while occupied")
	assert_equal(
		_run_rb05(fixture, false).get("phase"),
		&"FAILURE",
		"RB05 wrong initial branch does not auto-correct",
	)

	var rb06 := _run_rb06(fixture, true)
	assert_equal(rb06.get("phase"), &"SUCCESS", "RB06 composite witness succeeds")
	assert_true(bool(rb06.get("auto_transition", false)), "RB06 uses an Auto on/off transition")
	assert_true(bool(rb06.get("occupied_lock_rejected", false)), "RB06 observes the persistent occupied switch lock")
	assert_equal(
		_run_rb06(fixture, false).get("phase"),
		&"FAILURE",
		"RB06 wrong branch remains a factual finite failure",
	)

	var rb07 := _run_manual(fixture.pieces(&"RB07_FOREST_RELAY"), PATHS[&"RB07_FOREST_RELAY"])
	assert_equal(rb07.get("phase"), &"SUCCESS", "RB07 decorated forest relay witness succeeds")
	assert_equal(
		_run_manual(
			fixture.pieces(&"RB07_FOREST_RELAY"),
			PATHS[&"RB07_FOREST_RELAY"],
			func(target: Vector2i, _history: Array, input: Variant, _session: Variant) -> void:
				input.set_manual_load_active(target == Vector2i(4, 4)),
		).get("phase"),
		&"FAILURE",
		"RB07 leaves the first normal cargo unresolved when its relay order is ignored",
	)

	var rb08 := _run_manual(fixture.pieces(&"RB08_CAUTION_CUT"), PATHS[&"RB08_CAUTION_CUT"])
	assert_equal(rb08.get("phase"), &"SUCCESS", "RB08 caution-track witness succeeds")
	assert_equal(
		_run_manual(
			fixture.pieces(&"RB08_CAUTION_CUT"),
			PATHS[&"RB08_CAUTION_CUT"],
			func(target: Vector2i, _history: Array, input: Variant, _session: Variant) -> void:
				input.set_manual_load_active(target == Vector2i(3, 3)),
		).get("phase"),
		&"FAILURE",
		"RB08 still rejects a missing reverse-order cargo after the caution segment",
	)

	var rb09 := _run_manual(fixture.pieces(&"RB09_SALVAGE_SIDING"), PATHS[&"RB09_SALVAGE_SIDING"])
	assert_equal(rb09.get("phase"), &"SUCCESS", "RB09 disposal-yard witness succeeds")
	assert_equal(rb09.get("unloads"), [&"RED_STAR", &"WASTE_CRATE"], "RB09 clears waste only after normal cargo")
	assert_equal(
		_run_manual(
			fixture.pieces(&"RB09_SALVAGE_SIDING"),
			PATHS[&"RB09_SALVAGE_SIDING"],
			func(target: Vector2i, _history: Array, input: Variant, _session: Variant) -> void:
				input.set_manual_load_active(target == Vector2i(3, 3)),
		).get("phase"),
		&"FAILURE",
		"RB09 rejects reaching ordinary service without the normal cargo",
	)

	var rb10 := _run_manual(
		fixture.pieces(&"RB10_CLEAN_BREAK"),
		PATHS[&"RB10_CLEAN_BREAK"],
		func(target: Vector2i, history: Array, input: Variant, _session: Variant) -> void:
			var waste_visits := history.filter(
				func(event: Variant) -> bool: return event.cell == Vector2i(5, 4)
			).size()
			input.set_manual_load_active(target == Vector2i(4, 4) or (target == Vector2i(5, 4) and waste_visits > 0))
	)
	assert_equal(rb10.get("phase"), &"SUCCESS", "RB10 clean-break revisit witness succeeds")
	assert_equal(
		_run_manual(fixture.pieces(&"RB10_CLEAN_BREAK"), PATHS[&"RB10_CLEAN_BREAK"]).get("phase"),
		&"FAILURE",
		"RB10 rejects loading waste before its normal-delivery return",
	)

	var rb11 := _run_rb05(
		fixture,
		true,
		&"RB11_TURNOUT_UNDER_LOAD",
		PATHS[&"RB11_TURNOUT_UNDER_LOAD"],
	)
	assert_equal(rb11.get("phase"), &"SUCCESS", "RB11 disposal turnout witness succeeds")
	assert_true(bool(rb11.get("occupied_lock_rejected", false)), "RB11 keeps its occupied switch lock")
	assert_equal(
		_run_rb05(
			fixture,
			false,
			&"RB11_TURNOUT_UNDER_LOAD",
			PATHS[&"RB11_TURNOUT_UNDER_LOAD"],
		).get("phase"),
		&"FAILURE",
		"RB11 wrong turnout selection remains a factual failure",
	)

	var rb12 := _run_rb06(
		fixture,
		true,
		&"RB12_LANTERN_LOOP",
		PATHS[&"RB12_LANTERN_LOOP"],
	)
	assert_equal(rb12.get("phase"), &"SUCCESS", "RB12 composite wayside witness succeeds")
	assert_true(bool(rb12.get("auto_transition", false)), "RB12 retains a deliberate Auto transition")
	assert_true(bool(rb12.get("occupied_lock_rejected", false)), "RB12 keeps its occupied switch lock")
	assert_equal(
		_run_rb06(
			fixture,
			false,
			&"RB12_LANTERN_LOOP",
			PATHS[&"RB12_LANTERN_LOOP"],
		).get("phase"),
		&"FAILURE",
		"RB12 wrong turnout selection remains a factual failure",
	)


func _run_rb04(fixture: Script) -> Dictionary:
	var metrics := {"auto_red_pickups": 0, "auto_disabled_before_blue": false, "manual_blue_pickup": false}
	var session: Variant = _create_session(fixture.pieces(&"RB04_LOAD_WINDOW"), PATHS[&"RB04_LOAD_WINDOW"])
	if session == null:
		return {}
	var history: Array = []
	# Keep the signal callback independent from the RefCounted session.  Capturing
	# the session here would form a reference cycle through delivery_loop's signal.
	var input_state: Variant = session.input_state
	session.delivery_loop.delivery_event_created.connect(func(event: Variant) -> void:
		history.append(event)
		if event.picked_up and [Vector2i(3, 4), Vector2i(4, 4)].has(event.cell) and input_state.is_auto_load_enabled():
			metrics["auto_red_pickups"] = int(metrics["auto_red_pickups"]) + 1
		if event.picked_up and event.cell == Vector2i(6, 4) and not input_state.is_auto_load_enabled():
			metrics["manual_blue_pickup"] = true
	)
	session.run_controller.start()
	for _step: int in range(4000):
		if _terminal(session):
			break
		var target: Vector2i = session.train.target_cell()
		var blue_visits := history.filter(func(event: Variant) -> bool: return event.cell == Vector2i(6, 4)).size()
		if [Vector2i(3, 4), Vector2i(4, 4)].has(target) and not session.input_state.is_auto_load_enabled():
			session.input_state.toggle_auto_load()
		elif target == Vector2i(6, 4) and blue_visits == 0:
			if session.input_state.is_auto_load_enabled():
				session.input_state.toggle_auto_load()
				metrics["auto_disabled_before_blue"] = true
			session.input_state.set_manual_load_active(false)
		elif target == Vector2i(6, 4) and blue_visits > 0:
			session.input_state.set_manual_load_active(true)
		session.run_controller.advance_time(0.05)
	metrics["phase"] = session.run_controller.run_state().phase()
	return metrics


func _run_rb05(
	fixture: Script,
	select_delivery_branch: bool,
	stage_id: StringName = &"RB05_FORK_LOCK",
	map_path: String = PATHS[&"RB05_FORK_LOCK"],
) -> Dictionary:
	var session: Variant = _create_session(fixture.pieces(stage_id), map_path)
	if session == null:
		return {}
	var switch_cell := Vector2i(6, 4)
	if select_delivery_branch:
		session.graph.select_switch_exit(switch_cell, Vector2i.RIGHT)
	session.input_state.set_manual_load_active(true)
	session.run_controller.start()
	var lock_rejected := false
	for _step: int in range(4000):
		if _terminal(session):
			break
		if session.train.current_cell() == switch_cell:
			lock_rejected = not session.graph.select_switch_exit(switch_cell, Vector2i.UP)
		session.run_controller.advance_time(0.05)
	return {"phase": session.run_controller.run_state().phase(), "occupied_lock_rejected": lock_rejected}


func _run_rb06(
	fixture: Script,
	select_delivery_branch: bool,
	stage_id: StringName = &"RB06_PORT_CIRCUIT",
	map_path: String = PATHS[&"RB06_PORT_CIRCUIT"],
) -> Dictionary:
	var session: Variant = _create_session(fixture.pieces(stage_id), map_path)
	if session == null:
		return {}
	var switch_cell := Vector2i(6, 5)
	if select_delivery_branch:
		session.graph.select_switch_exit(switch_cell, Vector2i.UP)
	session.run_controller.start()
	var auto_transition := false
	var lock_rejected := false
	for _step: int in range(5000):
		if _terminal(session):
			break
		var target: Vector2i = session.train.target_cell()
		if target == Vector2i(4, 5) and not session.input_state.is_auto_load_enabled():
			session.input_state.toggle_auto_load()
		elif target == Vector2i(7, 4):
			if session.input_state.is_auto_load_enabled():
				session.input_state.toggle_auto_load()
				auto_transition = true
			session.input_state.set_manual_load_active(true)
		elif target == Vector2i(9, 7):
			session.input_state.set_manual_load_active(true)
		if session.train.current_cell() == switch_cell:
			lock_rejected = not session.graph.select_switch_exit(switch_cell, Vector2i.RIGHT)
		session.run_controller.advance_time(0.05)
	return {
		"phase": session.run_controller.run_state().phase(),
		"auto_transition": auto_transition,
		"occupied_lock_rejected": lock_rejected,
	}


func _run_manual(pieces: Array, path: String, driver: Callable = Callable()) -> Dictionary:
	var session: Variant = _create_session(pieces, path)
	if session == null:
		return {}
	var history: Array = []
	session.delivery_loop.delivery_event_created.connect(func(event: Variant) -> void: history.append(event))
	session.run_controller.start()
	for _step: int in range(4000):
		if _terminal(session):
			break
		var target: Vector2i = session.train.target_cell()
		if driver.is_valid():
			driver.call(target, history, session.input_state, session)
		else:
			session.input_state.set_manual_load_active(true)
		session.run_controller.advance_time(0.05)
	var pickups: Array[StringName] = []
	var unloads: Array[StringName] = []
	var unload_cells: Array[Vector2i] = []
	var blue_events: Array = history.filter(func(event: Variant) -> bool: return event.cell == Vector2i(5, 4))
	for event: Variant in history:
		if event.picked_up:
			pickups.append(event.pickup_type)
		if event.unload_count > 0:
			unloads.append_array(event.unloaded_items)
			unload_cells.append(event.cell)
	return {
		"phase": session.run_controller.run_state().phase(),
		"pickups": pickups,
		"unloads": unloads,
		"unload_cells": unload_cells,
		"first_blue_skipped": blue_events.size() >= 2 and not blue_events[0].picked_up,
		"blue_loaded_on_revisit": blue_events.size() >= 2 and blue_events[1].picked_up,
	}


func _create_session(pieces: Array, path: String) -> Variant:
	var definition: Variant = LoaderScript.load_from_path(path)
	if definition == null:
		return null
	var build: Variant = BuildSessionScript.new(definition)
	for piece: Variant in pieces:
		var placement: Variant = build.place_piece(piece)
		if placement == null or not placement.success:
			push_error("Route Book witness placement failed at %s: %s" % [piece.cell, placement.code if placement != null else "NULL"])
			return null
	var preflight: Variant = build.begin_run()
	if preflight == null or not preflight.passed:
		push_error("Route Book witness preflight failed: %s" % [preflight.primary_code if preflight != null else "NULL"])
		return null
	var factory: Variant = FactoryScript.new()
	if not factory.configure(definition, build.sealed_snapshot(), 4.0):
		push_error("Route Book witness factory configuration failed")
		return null
	var attempt: Dictionary = factory.create_attempt(1)
	return attempt.get("session") if bool(attempt.get("success", false)) else null


func _terminal(session: Variant) -> bool:
	var phase: StringName = session.run_controller.run_state().phase()
	return phase == &"SUCCESS" or phase == &"FAILURE"
