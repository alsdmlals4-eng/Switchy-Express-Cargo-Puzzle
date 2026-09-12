extends Control

const Controller := preload("res://game/finite/main/finite_slice_session_controller.gd")
const Renderer := preload("res://game/demo/presentation/product_board_renderer.gd")
const Palette := preload("res://game/demo/presentation/demo_palette.gd")

var _board: Control
var _board_size := Vector2i.ZERO

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	clip_contents = true
	_board = Renderer.new()
	_board.name = "Board"
	_board.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_board)
	resized.connect(_fit_board)

func show_map(path: String) -> bool:
	_board_size = Vector2i.ZERO
	_board.apply_snapshot({})
	visible = false
	if path.is_empty() or not FileAccess.file_exists(path):
		return false
	# Build a detached initial-state snapshot only. No RUN session, input connections,
	# witness layout, timer advancement or active gameplay node belongs in this view.
	var controller := Controller.new()
	if not controller.initialize(path):
		return false
	var snapshot: Dictionary = controller.render_snapshot()
	_board_size = snapshot.get("board_size", Vector2i.ZERO)
	# An unbuilt map is a planning surface, not a player validation error.
	snapshot["problem_cells"] = []
	_board.apply_snapshot(snapshot)
	visible = true
	_fit_board()
	return true

func _fit_board() -> void:
	if not is_instance_valid(_board) or _board_size.x <= 0 or _board_size.y <= 0:
		return
	var padding := Palette.BOARD_PADDING * 2.0
	var available := (size - Vector2.ONE * padding).max(Vector2.ZERO)
	var cell := minf(available.x / float(_board_size.x), available.y / float(_board_size.y))
	_board.size = Vector2(_board_size) * cell + Vector2.ONE * padding
	_board.position = (size - _board.size) * 0.5
