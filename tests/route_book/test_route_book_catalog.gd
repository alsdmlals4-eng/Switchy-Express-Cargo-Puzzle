extends "res://tests/test_case.gd"

const CatalogScript := preload("res://game/route_book/route_book_catalog.gd")


func run() -> void:
	assert_equal(
		CatalogScript.book_ids(),
		[&"ROUTE_BOOK_01", &"ROUTE_BOOK_02"],
		"the catalog exposes the two authored optional Route Books in order",
	)
	assert_equal(
		CatalogScript.definition_path(&"ROUTE_BOOK_01"),
		"res://data/route_book/route_book_01.json",
		"Route Book 01 definition path remains canonical",
	)
	assert_equal(
		CatalogScript.definition_path(&"ROUTE_BOOK_02"),
		"res://data/route_book/route_book_02.json",
		"Route Book 02 definition path is catalog-owned",
	)
	assert_equal(
		CatalogScript.copy_path(&"ROUTE_BOOK_02"),
		"res://data/localization/route_book_02_v1.json",
		"Route Book 02 copy path is catalog-owned",
	)
	assert_equal(CatalogScript.display_key(&"ROUTE_BOOK_02"), &"SX_RB02_STAGE_BOOK", "book label key is exact")
	assert_equal(CatalogScript.definition_path(&"UNKNOWN"), "", "unknown book has no definition path")
