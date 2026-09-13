extends "res://tools/validation/verify_exported_runtime_json.gd"


func _initialize() -> void:
	# Corrupt the real FileAccess consumer through a tiny overlay, never the checkout.
	# A failed pack operation cannot be mistaken for the expected semantic rejection.
	var overlay := "user://route-book-negative-export-fixture.pck"
	var packer := PCKPacker.new()
	if packer.pck_start(overlay) != OK or packer.add_file(
		"res://data/route_book/route_book_01.json",
		"res://tests/fixtures/route_book/invalid_export_book.json"
	) != OK or packer.flush() != OK:
		printerr("NEGATIVE_FIXTURE_SETUP_FAILED")
		quit(3)
		return
	if not ProjectSettings.load_resource_pack(overlay, true):
		printerr("NEGATIVE_FIXTURE_MOUNT_FAILED")
		quit(3)
		return
	super._initialize()
