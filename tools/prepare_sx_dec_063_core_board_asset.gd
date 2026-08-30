extends SceneTree


func _init() -> void:
	var options := _read_options(OS.get_cmdline_user_args())
	if options.is_empty():
		_fail("Usage: --input <png> --output <png> --width <positive integer> --height <positive integer>")
		return

	var width := _positive_integer(options["width"])
	var height := _positive_integer(options["height"])
	if width <= 0 or height <= 0:
		_fail("Width and height must be positive integers")
		return

	var source := Image.load_from_file(options["input"])
	if source == null or source.is_empty():
		_fail("Could not load input image: %s" % options["input"])
		return

	source.resize(width, height, Image.INTERPOLATE_LANCZOS)
	var save_error := source.save_png(options["output"])
	if save_error != OK:
		_fail("Could not save output PNG: %s" % options["output"])
		return

	var written := Image.load_from_file(options["output"])
	if written == null or written.is_empty() or written.get_width() != width or written.get_height() != height:
		_fail("Output PNG dimensions do not match the requested dimensions")
		return

	quit(0)


func _read_options(arguments: PackedStringArray) -> Dictionary:
	var options := {}
	var index := 0
	while index < arguments.size():
		var key := arguments[index]
		if key not in ["--input", "--output", "--width", "--height"] or index + 1 >= arguments.size():
			return {}
		options[key.trim_prefix("--")] = arguments[index + 1]
		index += 2
	for required_key in ["input", "output", "width", "height"]:
		if not options.has(required_key) or String(options[required_key]).is_empty():
			return {}
	return options


func _positive_integer(value: String) -> int:
	if not value.is_valid_int():
		return -1
	return value.to_int()


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
