class_name MapFixture
extends RefCounted


static func manifest_entry(
	map_id: StringName = &"map.sx.0001",
	seed: int = 1
) -> Dictionary:
	return {
		"map_id": str(map_id),
		"map_revision": 1,
		"map_seed": seed,
		"generator_version": "railgen_v1",
		"ruleset_version": "standard_v1",
		"validation_status": "VALIDATED",
		"start_cell": [0, 0],
		"incoming_cell": [0, 1],
	}


static func manifest_data() -> Dictionary:
	return {
		"catalog_revision": "vs03-target3-r1",
		"entries": [
			manifest_entry(&"map.sx.0001", 1),
			manifest_entry(&"map.sx.0002", 2),
			manifest_entry(&"map.sx.0003", 5),
		],
	}


static func definition_data() -> Dictionary:
	var data := manifest_entry()
	data["graph_signature"] = "graph-a"
	data["station_signature"] = "stations-a"
	data["initial_pickup_signature"] = "pickups-a"
	data["layout_signature"] = "layout-a"
	data["content_signature"] = "content-a"
	return data
