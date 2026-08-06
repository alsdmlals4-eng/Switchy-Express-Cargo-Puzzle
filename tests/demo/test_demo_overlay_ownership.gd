extends "res://tests/test_case.gd"

const DemoScene := preload("res://game/demo/vertical_slice_demo.tscn")


func run() -> void:
	var tree := Engine.get_main_loop() as SceneTree
	assert_not_null(tree, "overlay ownership test requires SceneTree")
	if tree == null:
		return

	var demo: Control = DemoScene.instantiate()
	tree.root.add_child(demo)
	demo.start_demo()
	demo.begin_build()

	var product: Control = demo.gameplay_instance()
	assert_not_null(product, "gameplay instance exists")
	if product == null:
		demo.free()
		return
	var hud := product.get_node("HUD")
	assert_false(
		bool(hud.get("use_internal_overlays")),
		"Demo Shell must own pause and result overlays"
	)

	hud.apply_model({"phase": &"PAUSED"})
	demo.set_paused(true)
	assert_true(demo.get_node("PauseOverlay").visible, "Shell pause overlay is visible")
	assert_false(hud.get_node("PausePanel").visible, "embedded pause panel stays hidden")

	for path: NodePath in [
		NodePath("PauseOverlay/Panel/Content/ResumeButton"),
		NodePath("PauseOverlay/Panel/Content/ExitButton"),
		NodePath("ExitConfirmOverlay/Panel/Content/ContinueButton"),
		NodePath("ExitConfirmOverlay/Panel/Content/ConfirmButton"),
	]:
		assert_not_null(demo.get_node_or_null(path), "%s must exist" % path)

	demo.set_paused(false)
	demo.show_result({
		"outcome": &"SUCCESS",
		"completion_time": 42.5,
		"time_limit_seconds": 120.0,
	})
	assert_true(demo.get_node("ResultOverlay").visible, "Shell result overlay is visible")
	assert_false(hud.get_node("ResultPanel").visible, "embedded result panel stays hidden")
	var body := demo.get_node("ResultOverlay/Panel/Content/Body") as Label
	for marker: String in ["완료 시간", "남은 시간", "건설비", "하역"]:
		assert_true(body.text.contains(marker), "result summary must include %s" % marker)

	for path: NodePath in [
		NodePath("ResultOverlay/Panel/Content/RetryButton"),
		NodePath("ResultOverlay/Panel/Content/EditButton"),
		NodePath("ResultOverlay/Panel/Content/TitleButton"),
	]:
		assert_not_null(demo.get_node_or_null(path), "%s must exist" % path)

	demo.free()
