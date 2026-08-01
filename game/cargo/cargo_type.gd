class_name CargoType
extends RefCounted

const RED_STAR: StringName = &"RED_STAR"
const BLUE_DIAMOND: StringName = &"BLUE_DIAMOND"
const YELLOW_TRIANGLE: StringName = &"YELLOW_TRIANGLE"


static func all_types() -> Array[StringName]:
	return [RED_STAR, BLUE_DIAMOND, YELLOW_TRIANGLE]


static func is_valid(cargo_type: StringName) -> bool:
	return all_types().has(cargo_type)


static func color_for(cargo_type: StringName) -> StringName:
	match cargo_type:
		RED_STAR:
			return &"RED"
		BLUE_DIAMOND:
			return &"BLUE"
		YELLOW_TRIANGLE:
			return &"YELLOW"
		_:
			return &""


static func shape_for(cargo_type: StringName) -> StringName:
	match cargo_type:
		RED_STAR:
			return &"STAR"
		BLUE_DIAMOND:
			return &"DIAMOND"
		YELLOW_TRIANGLE:
			return &"TRIANGLE"
		_:
			return &""
