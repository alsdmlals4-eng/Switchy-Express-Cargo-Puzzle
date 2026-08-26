extends "res://tests/test_case.gd"

const ControllerScript := preload(
	"res://game/finite/main/finite_slice_session_controller.gd"
)
const AlphaScript := preload("res://tests/fixtures/finite/fp_core_solution_alpha.gd")


func run() -> void:
	var controller: RefCounted = ControllerScript.new()
	assert_true(
		controller.initialize("res://data/maps/fp_core_proof_01.json"),
		"controller must initialize the proof map"
	)
	assert_true(controller.domain_ready(), "controller must expose domain readiness")
	assert_equal(controller.phase(), &"BUILD", "controller must boot BUILD")
	assert_equal(controller.model()["phase"], &"BUILD", "model must boot BUILD")
	assert_true(controller.model().has("manual_load_active"), "controller model must expose manual-load presentation truth")
	assert_false(controller.model()["manual_load_active"], "BUILD must start with manual-load false")

	var snapshot: Dictionary = controller.render_snapshot()
	assert_equal(snapshot["map_id"], &"FP_CORE_PROOF_01", "snapshot keeps map identity")
	assert_equal(snapshot["map_revision"], 2, "snapshot keeps map revision")
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

	assert_true(controller.install_layout_for_test(AlphaScript.pieces()), "alpha layout must install for manual-load projection proof")
	assert_true(controller.model()["start_enabled"], "alpha layout must pass preflight")
	controller.request_command(&"START")
	assert_equal(controller.phase(), &"RUNNING", "manual-load projection proof must enter RUNNING")
	controller.request_command(&"LOAD_ACTIVE", true)
	assert_true(
		controller.active_run_session_for_test().input_state.is_manual_load_active(),
		"domain input state must accept manual hold"
	)
	assert_true(
		controller.model()["manual_load_active"],
		"controller must project the existing manual-load getter into presenter model"
	)
	controller.request_command(&"PAUSE")
	assert_equal(controller.phase(), &"PAUSED", "pause must still use existing run-state authority")
	assert_false(
		controller.active_run_session_for_test().input_state.is_manual_load_active(),
		"existing input state clears manual hold on pause"
	)
	assert_false(controller.model()["manual_load_active"], "paused presenter model must project cleared manual hold")

	var rotation_controller: RefCounted = ControllerScript.new()
	assert_true(
		rotation_controller.initialize("res://data/maps/vs_demo_01.json"),
		"rotation proof must initialize the demo map"
	)
	rotation_controller.request_command(&"BUILD_TOOL", &"CURVE")
	assert_equal(
		rotation_controller.render_snapshot()["selected_rotation_quarters"],
		0,
		"newly selected build tools start at rotation zero"
	)
	rotation_controller.request_command(&"ROTATE")
	assert_equal(
		rotation_controller.render_snapshot()["selected_rotation_quarters"],
		1,
		"ROTATE must turn the active build tool before placement"
	)
	rotation_controller.request_command(&"BOARD_CELL", Vector2i(2, 2))
	var placed: Array = rotation_controller.render_snapshot()["layout_pieces"]
	assert_equal(placed.size(), 1, "rotated tool must place one piece")
	assert_equal(placed[0]["geometry"], &"CURVE", "placed piece keeps selected geometry")
	assert_equal(
		placed[0]["rotation_quarters"],
		1,
		"placed piece must keep the active tool rotation"
	)
