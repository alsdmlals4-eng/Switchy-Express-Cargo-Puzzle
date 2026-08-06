extends "res://tests/test_case.gd"

const ProductScene := preload("res://game/demo/product_finite_slice.tscn")


func run() -> void:
	var tree := Engine.get_main_loop() as SceneTree
	assert_not_null(tree, "secondary remove test requires SceneTree")
	if tree == null:
		return

	var product: Control = ProductScene.instantiate()
	tree.root.add_child(product)
	var controller: RefCounted = product.session_controller()
	var renderer := product.get_node("BoardRenderer") as Control
	var target := Vector2i(5, 4)

	product.request_command_for_test(&"BUILD_TOOL", &"STRAIGHT")
	product.request_command_for_test(&"BOARD_CELL", target)
	assert_true(_has_piece(controller.render_snapshot(), target), "primary placement creates a piece")

	var local: Vector2 = _local_for_cell(renderer, target, Vector2i(15, 11))
	renderer.request_secondary_at(local)
	assert_equal(controller.last_command(), &"REMOVE", "secondary click ends on the existing remove command")
	assert_false(_has_piece(controller.render_snapshot(), target), "secondary click removes the exact piece")
	assert_equal(
		controller.render_snapshot().get("selected_geometry", &"BROKEN"),
		&"",
		"secondary removal clears the active build tool before selecting the cell"
	)

	product.free()


func _has_piece(snapshot: Dictionary, cell: Vector2i) -> bool:
	for value: Variant in snapshot.get("layout_pieces", []):
		if value.get("cell", Vector2i(-1, -1)) == cell:
			return true
	return false


func _local_for_cell(renderer: Control, cell: Vector2i, board_size: Vector2i) -> Vector2:
	const PADDING := 24.0
	var available := renderer.size - Vector2(PADDING * 2.0, PADDING * 2.0)
	var cell_size := Vector2(
		available.x / float(board_size.x),
		available.y / float(board_size.y)
	)
	return Vector2(PADDING, PADDING) + (Vector2(cell) + Vector2(0.5, 0.5)) * cell_size
