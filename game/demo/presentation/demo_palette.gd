class_name DemoPalette
extends RefCounted

const BACKGROUND := Color("10262b")
const BOARD := Color("f0e2bf")
const BOARD_EDGE := Color("806a4f")
const GRID := Color("d3c39e")
const BOARD_TERRAIN_TINT := Color(1.0, 1.0, 1.0, 0.72)
const BOARD_TERRAIN_VEIL := Color(0.94, 0.89, 0.75, 0.22)
const BLOCKED := Color("8b6b61")
const RAIL_BED := Color("493f37")
const RAIL_METAL := Color("d1c7ad")
const HOVER := Color("54c6b5")
const SELECTED := Color("f1b74f")
const GHOST_VALID := Color(0.33, 0.78, 0.70, 0.45)
const GHOST_INVALID := Color(0.89, 0.31, 0.28, 0.45)
const PROBLEM := Color("d94f49")
const TRAIN := Color("234e70")
const TRAIN_ACCENT := Color("f1b74f")
const ROUTE_SELECTED := Color("74df58")
const ROUTE_UNSELECTED := Color("4da3ff")
const ROUTE_LOCKED := Color("ef554d")
const ROUTE_INACTIVE := Color("807a70")
const RED_CARGO := Color("d94f49")
const BLUE_CARGO := Color("3979b7")
const TEXT_DARK := Color("243038")
const TEXT_LIGHT := Color("f7f2e8")
const CONTROL_DECK_RAISED := Color("18363c")
const CONTROL_DECK_HOVER := Color("24505a")
const CONTROL_DECK_BORDER := Color("6f806f")
const CONTROL_DECK_DISABLED := Color("536168")
const CONTROL_DECK_ACTION := Color("e9ae45")
const TUTORIAL_FOCUS := Color("9b6bdf")
const SWITCH_ACTIVE := ROUTE_SELECTED
const SWITCH_INACTIVE := ROUTE_UNSELECTED

const BOARD_PADDING := 24.0
const RAIL_WIDTH := 8.0
const RAIL_HIGHLIGHT_WIDTH := 3.0


static func cargo_color(cargo_type: StringName) -> Color:
	return RED_CARGO if cargo_type == &"RED_STAR" else BLUE_CARGO


static func cargo_label(cargo_type: StringName) -> String:
	return "A" if cargo_type == &"RED_STAR" else "B"
