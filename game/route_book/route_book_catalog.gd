class_name RouteBookCatalog
extends RefCounted

const BOOKS: Array[Dictionary] = [
	{
		"book_id": &"ROUTE_BOOK_01",
		"definition_path": "res://data/route_book/route_book_01.json",
		"copy_path": "res://data/localization/route_book_01_v1.json",
		"display_key": &"SX_RB01_STAGE_BOOK",
	},
	{
		"book_id": &"ROUTE_BOOK_02",
		"definition_path": "res://data/route_book/route_book_02.json",
		"copy_path": "res://data/localization/route_book_02_v1.json",
		"display_key": &"SX_RB02_STAGE_BOOK",
	},
]


static func book_ids() -> Array[StringName]:
	var ids: Array[StringName] = []
	for entry: Dictionary in BOOKS:
		ids.append(StringName(entry.get("book_id", &"")))
	return ids


static func definition_path(book_id: StringName) -> String:
	return str(_entry(book_id).get("definition_path", ""))


static func copy_path(book_id: StringName) -> String:
	return str(_entry(book_id).get("copy_path", ""))


static func display_key(book_id: StringName) -> StringName:
	return StringName(_entry(book_id).get("display_key", &""))


static func _entry(book_id: StringName) -> Dictionary:
	for entry: Dictionary in BOOKS:
		if StringName(entry.get("book_id", &"")) == book_id:
			return entry.duplicate(true)
	return {}
