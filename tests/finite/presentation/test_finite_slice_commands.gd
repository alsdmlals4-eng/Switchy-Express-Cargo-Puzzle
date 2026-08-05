extends "res://tests/test_case.gd"

const MAIN_SCENE_PATH := "res://game/finite/main/finite_slice.tscn"


func run() -> void:
	var packed: PackedScene = load(MAIN_SCENE_PATH)
	assert_not_null(packed, "finite slice command scene must load")
	if packed == null:
		return

	var instance: Control = packed.instantiate()
	var tree := Engine.get_main_loop() as SceneTree
	assert_not_null(tree, "command test requires the active SceneTree")
	if tree == null:
		instance.free()
		return
	tree.root.add_child(instance)

	var view: Control = instance.get_node("View")
	assert_true(view.has_method("request_board_cell"), "view must expose a board-cell command boundary")
	assert_true(view.has_method("board_cell_from_local"), "view must map board touch positions to grid cells")
	if not view.has_method("request_board_cell") or not view.has_method("board_cell_from_local"):
		instance.queue_free()
		return

	var mapped: Vector2i = view.board_cell_from_local(Vector2(50.0, 50.0), Vector2(110.0, 90.0), Vector2i(11, 9))
	assert_equal(mapped, Vector2i(5, 5), "board touch mapping must use the configured grid")
	assert_equal(
		view.board_cell_from_local(Vector2(-1.0, 20.0), Vector2(110.0, 90.0), Vector2i(11, 9)),
		Vector2i(-1, -1),
		"touches outside the board must be rejected"
	)

	view.request_board_cell(Vector2i(3, 4))
	assert_equal(instance.last_command(), &"BOARD_CELL", "board cell requests must reach the finite slice adapter")
	assert_equal(instance.last_payload(), Vector2i(3, 4), "board cell payload must remain exact")

	var straight: Button = view.get_node("BuildTools/StraightButton")
	straight.pressed.emit()
	assert_equal(instance.last_command(), &"BUILD_TOOL", "build tool selection must reach the adapter")
	assert_equal(instance.last_payload(), &"STRAIGHT", "build tool payload must preserve geometry")

	var load_button: Button = view.get_node("RunTools/LoadButton")
	load_button.button_down.emit()
	assert_equal(instance.last_command(), &"LOAD_ACTIVE", "load press must reach the adapter")
	assert_equal(instance.last_payload(), true, "load press payload must be true")
	load_button.button_up.emit()
	assert_equal(instance.last_payload(), false, "load release payload must be false")

	var retry: Button = view.get_node("ResultPanel/RetryButton")
	retry.pressed.emit()
	assert_equal(instance.last_command(), &"RETRY_SAME_LAYOUT", "retry command must reach the adapter")

	instance.queue_free()
