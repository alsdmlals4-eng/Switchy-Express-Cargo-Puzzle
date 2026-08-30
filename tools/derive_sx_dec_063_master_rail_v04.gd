extends SceneTree


const SOURCE_PATH := "res://art/product_assets/ed_hybrid_v2/source/core_rail_network_master_v03.png"
const OUTPUTS := {
	"core_rail_straight_normal_v04.png": Rect2i(650, 803, 256, 256),
	"core_rail_curve_normal_v04.png": Rect2i(394, 803, 256, 256),
	"core_rail_crossing_normal_v04.png": Rect2i(388, 300, 256, 256),
	"core_rail_switch_three_way_normal_v04.png": Rect2i(855, 300, 256, 256),
}
const OUTPUT_DIRECTORY := "res://art/product_assets/ed_hybrid_v2/core"
const OUTPUT_SIZE := Vector2i(64, 64)


func _init() -> void:
	var source := Image.load_from_file(SOURCE_PATH)
	if source == null or source.is_empty():
		_fail("Could not load approved rail master: %s" % SOURCE_PATH)
		return
	var verify_only := "--verify" in OS.get_cmdline_user_args()
	for filename: String in OUTPUTS:
		var crop: Rect2i = OUTPUTS[filename]
		if crop.position.x < 0 or crop.position.y < 0 or crop.end.x > source.get_width() or crop.end.y > source.get_height():
			_fail("Crop is outside the approved rail master: %s" % filename)
			return
		var derived := source.get_region(crop)
		derived.resize(OUTPUT_SIZE.x, OUTPUT_SIZE.y, Image.INTERPOLATE_LANCZOS)
		if verify_only:
			var expected_png := derived.save_png_to_buffer()
			var existing_path := "%s/%s" % [OUTPUT_DIRECTORY, filename]
			var existing_png := FileAccess.get_file_as_bytes(existing_path)
			if expected_png != existing_png:
				_fail("Derived bytes do not match the tracked rail output: %s" % filename)
				return
			continue
		var save_error := derived.save_png("%s/%s" % [OUTPUT_DIRECTORY, filename])
		if save_error != OK:
			_fail("Could not write derived rail: %s" % filename)
			return
	if verify_only:
		print("SX_DEC_063_MASTER_RAIL_V04_DERIVATION: PASS")
	quit(0)


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
