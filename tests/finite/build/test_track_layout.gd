extends "res://tests/test_case.gd"

const PIECE_PATH := "res://game/finite/build/track_piece.gd"
const LAYOUT_PATH := "res://game/finite/build/track_layout.gd"
const EMPTY_SHA256 := "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"


class FakePiece:
	extends RefCounted
	var cell: Vector2i = Vector2i(6, 2)

	func duplicate_piece() -> Variant:
		return self

	func build_cost() -> int:
		return 1


func run() -> void:
	var piece_exists := ResourceLoader.exists(PIECE_PATH, "Script")
	var layout_exists := ResourceLoader.exists(LAYOUT_PATH, "Script")
	assert_true(piece_exists, "finite track piece must exist")
	assert_true(layout_exists, "finite track layout must exist")
	if not piece_exists or not layout_exists:
		return

	var piece_script: Script = load(PIECE_PATH)
	var layout_script: Script = load(LAYOUT_PATH)
	var empty: Variant = layout_script.new()
	assert_equal(empty.layout_signature(), EMPTY_SHA256, "empty layout must have canonical SHA-256 identity")
	assert_false(empty.put_piece(FakePiece.new()), "layout must reject TrackPiece impostors")

	var straight: Variant = piece_script.create(Vector2i(2, 2), &"STRAIGHT", 0, Vector2i.ZERO)
	var curve: Variant = piece_script.create(Vector2i(3, 2), &"CURVE", 1, Vector2i.ZERO)
	var switch_piece: Variant = piece_script.create(Vector2i(4, 2), &"SWITCH", 0, Vector2i.RIGHT)
	var crossing: Variant = piece_script.create(Vector2i(5, 2), &"CROSSING", 0, Vector2i.ZERO)

	assert_not_null(straight, "straight piece must be valid")
	assert_not_null(curve, "curve piece must be valid")
	assert_not_null(switch_piece, "switch piece must be valid")
	assert_not_null(crossing, "crossing piece must be valid")
	assert_equal(straight.ports(), [Vector2i.LEFT, Vector2i.RIGHT], "straight rotation 0 ports must match")
	assert_equal(curve.ports(), [Vector2i.RIGHT, Vector2i.DOWN], "curve rotation 1 must rotate clockwise")
	assert_equal(switch_piece.approach_port(), Vector2i.LEFT, "switch approach must be left at rotation 0")
	assert_equal(switch_piece.switch_exits(), [Vector2i.RIGHT, Vector2i.UP], "switch exits must match rotation 0")

	var first: Variant = layout_script.new()
	assert_true(first.put_piece(switch_piece), "switch must be accepted")
	assert_true(first.put_piece(straight), "straight must be accepted")
	assert_true(first.put_piece(curve), "curve must be accepted")
	assert_true(first.put_piece(crossing), "crossing must be accepted")
	assert_equal(first.build_cost(), 600, "100+100+200+200 test values must sum")

	var second: Variant = layout_script.new()
	second.put_piece(crossing)
	second.put_piece(curve)
	second.put_piece(straight)
	second.put_piece(switch_piece)
	assert_equal(first.layout_signature(), second.layout_signature(), "installation order must not affect identity")

	var changed: Variant = second.duplicate_layout()
	changed.put_piece(piece_script.create(Vector2i(3, 2), &"CURVE", 2, Vector2i.ZERO))
	assert_not_equal(first.layout_signature(), changed.layout_signature(), "rotation must affect identity")
	assert_equal(first.piece_at(Vector2i(2, 2)).geometry, &"STRAIGHT", "piece lookup must return placed piece")
	assert_equal(first.pieces().size(), 4, "layout must expose all pieces")

	var expected_signature: String = first.layout_signature()
	for index: int in range(100):
		var repeated: Variant = layout_script.new()
		if index % 2 == 0:
			repeated.put_piece(straight)
			repeated.put_piece(curve)
			repeated.put_piece(switch_piece)
			repeated.put_piece(crossing)
		else:
			repeated.put_piece(crossing)
			repeated.put_piece(switch_piece)
			repeated.put_piece(curve)
			repeated.put_piece(straight)
		assert_equal(repeated.layout_signature(), expected_signature, "signature must be deterministic")
