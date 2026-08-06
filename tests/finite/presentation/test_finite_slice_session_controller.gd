extends "res://tests/test_case.gd"

const ControllerScript := preload(
	"res://game/finite/main/finite_slice_session_controller.gd"
)


func run() -> void:
	var controller: RefCounted = ControllerScript.new()
	assert_true(
		controller.initialize("res://data/maps/fp_core_proof_01.json"),
		"controller must initialize the proof map"
	)
	assert_true(controller.domain_ready(), "controller must expose domain readiness")
	assert_equal(controller.phase(), &"BUILD", "controller must boot BUILD")
	assert_equal(controller.model()["phase"], &"BUILD", "model must boot BUILD")

	var snapshot: Dictionary = controller.render_snapshot()
	assert_equal(snapshot["map_id"], &"FP_CORE_PROOF_01", "snapshot keeps map identity")
	assert_equal(snapshot["map_revision"], 1, "snapshot keeps map revision")
	assert_equal(snapshot["board_size"], Vector2i(11, 9), "snapshot exposes board size")
	assert_equal(snapshot["start_cell"], Vector2i(1, 4), "snapshot exposes start cell")
	assert_equal(snapshot["incoming_cell"], Vector2i(0, 4), "snapshot exposes incoming cell")
	assert_true(snapshot["layout_pieces"] is Array, "snapshot exposes immutable pieces")
	assert_equal(snapshot["layout_pieces"].size(), 0, "new build session starts empty")

	var model_copy: Dictionary = controller.model()
	model_copy["phase"] = &"BROKEN"
	assert_equal(controller.phase(), &"BUILD", "model copies cannot mutate controller state")

	var snapshot_copy: Dictionary = controller.render_snapshot()
	snapshot_copy["map_id"] = &"BROKEN"
	assert_equal(
		controller.render_snapshot()["map_id"],
		&"FP_CORE_PROOF_01",
		"snapshot copies cannot mutate controller state"
	)
