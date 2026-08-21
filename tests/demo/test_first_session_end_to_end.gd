extends "res://tests/test_case.gd"

const MainScene := preload("res://game/main/main.tscn")
const T12 := preload("res://tests/fixtures/first_session/tut_01_02_solution.gd")
const T3 := preload("res://tests/fixtures/first_session/tut_03_solution.gd")
const T6 := preload("res://tests/fixtures/first_session/tut_06_solution_driver.gd")

const B_CELL := Vector2i(6, 4)
const T4_A_CELL := Vector2i(5, 4)
const T5_A_CELLS: Array[Vector2i] = [Vector2i(4, 4), Vector2i(5, 4)]
const T6_SWITCH := Vector2i(3, 3)


func run() -> void:
	var tree := Engine.get_main_loop() as SceneTree
	var main: Control = MainScene.instantiate()
	tree.root.add_child(main)
	var flow := main.get_node("VerticalSliceDemo")
	assert_equal(flow.current_lesson_id_for_test(), &"T1", "F5 product boots T1")
	flow.start_demo()
	flow.begin_build()
	var t1_product: Control = flow.gameplay_instance()
	t1_product.request_command_for_test(&"START")
	assert_equal(t1_product.session_controller().phase(), &"BUILD", "T1 policy blocks START")
	assert_true(t1_product.install_layout_for_test(T12.pieces()), "T1 proof layout installs")
	assert_equal(flow.current_lesson_id_for_test(), &"T2", "preflight advances T1 to T2")
	assert_true(flow.gameplay_instance() == t1_product, "T1/T2 preserve gameplay identity")

	flow.begin_build()
	_run_static_load(flow.gameplay_instance())
	assert_equal(flow.current_lesson_id_for_test(), &"T3", "T2 success advances T3")
	assert_true(flow.gameplay_instance() == null, "T3 receives a fresh gameplay instance")

	flow.begin_build()
	assert_equal(_map_id(flow), &"TUT_03_LIFO", "T3 loads LIFO map")
	var t3_product: Control = flow.gameplay_instance()
	assert_true(t3_product.install_layout_for_test(T3.pieces()), "T3 proof layout installs")
	_run_static_load(t3_product)
	assert_equal(flow.current_lesson_id_for_test(), &"T4", "T3 success advances T4")

	flow.begin_build()
	assert_equal(_map_id(flow), &"TUT_04_SELECTIVE_LOAD", "T4 loads selective map")
	_run_selective(flow.gameplay_instance())
	assert_equal(flow.current_lesson_id_for_test(), &"T5", "T4 success advances T5")

	flow.begin_build()
	assert_equal(_map_id(flow), &"TUT_05_AUTO_LOAD", "T5 loads auto map")
	_run_auto(flow.gameplay_instance())
	assert_equal(flow.current_lesson_id_for_test(), &"T6", "T5 success advances T6")

	flow.begin_build()
	assert_equal(_map_id(flow), &"TUT_06_SWITCH", "T6 loads switch map")
	var t6_product: Control = flow.gameplay_instance()
	assert_true(t6_product.install_layout_for_test(T6.pieces()), "T6 proof layout installs")
	t6_product.request_command_for_test(&"START")
	t6_product.request_command_for_test(&"BOARD_CELL", T6_SWITCH)
	t6_product.request_command_for_test(&"LOAD_ACTIVE", true)
	_advance_until_replaced(flow, t6_product)
	assert_equal(flow.current_lesson_id_for_test(), &"CAPSTONE", "T6 success advances capstone")

	flow.begin_build()
	assert_equal(_map_id(flow), &"VS_DEMO_01", "capstone reuses VS_DEMO_01")
	main.free()


func _run_static_load(product: Control) -> void:
	product.request_command_for_test(&"START")
	product.request_command_for_test(&"LOAD_ACTIVE", true)
	var flow := product.get_parent().get_parent()
	_advance_until_replaced(flow, product)


func _run_selective(product: Control) -> void:
	product.request_command_for_test(&"START")
	var flow := product.get_parent().get_parent()
	for _step: int in range(3000):
		if flow.gameplay_instance() != product:
			break
		var controller: RefCounted = product.session_controller()
		var runtime: Variant = controller.active_run_session_for_test()
		var target: Vector2i = runtime.train.target_cell()
		if target == B_CELL:
			var visits: int = controller.delivery_history().filter(
				func(event: Variant) -> bool: return event.cell == B_CELL
			).size()
			product.request_command_for_test(&"LOAD_ACTIVE", visits > 0)
		elif target == T4_A_CELL:
			product.request_command_for_test(&"LOAD_ACTIVE", true)
		product.advance_time(0.05)


func _run_auto(product: Control) -> void:
	product.request_command_for_test(&"START")
	var flow := product.get_parent().get_parent()
	for _step: int in range(3000):
		if flow.gameplay_instance() != product:
			break
		var controller: RefCounted = product.session_controller()
		var runtime: Variant = controller.active_run_session_for_test()
		var target: Vector2i = runtime.train.target_cell()
		var visits: int = controller.delivery_history().filter(
			func(event: Variant) -> bool: return event.cell == B_CELL
		).size()
		if T5_A_CELLS.has(target) and not runtime.input_state.is_auto_load_enabled():
			product.request_command_for_test(&"AUTO_TOGGLE")
		elif target == B_CELL and visits == 0:
			if runtime.input_state.is_auto_load_enabled():
				product.request_command_for_test(&"AUTO_TOGGLE")
			product.request_command_for_test(&"LOAD_ACTIVE", false)
		elif target == B_CELL and visits > 0:
			product.request_command_for_test(&"LOAD_ACTIVE", true)
		product.advance_time(0.05)


func _advance_until_replaced(flow: Control, product: Control) -> void:
	for _step: int in range(3000):
		if flow.gameplay_instance() != product:
			break
		product.advance_time(0.05)


func _map_id(flow: Control) -> StringName:
	var product: Control = flow.gameplay_instance()
	return StringName(product.session_controller().render_snapshot().get("map_id", &""))
