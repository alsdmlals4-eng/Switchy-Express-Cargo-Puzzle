extends RefCounted

const GridEngineScript := preload("res://game/reuse/grid_placement_rule_engine.gd")
const SkinKitScript := preload("res://game/reuse/semantic_ui_skin_kit.gd")
const SymbolAtlasScript := preload("res://game/reuse/gameplay_symbol_atlas.gd")

const PROJECT_SKIN := {
	"build_action": {
		"normal": "build_valid",
		"invalid": "build_invalid",
		"selected": "build_selected",
		"disabled": "build_disabled",
	},
	"route_control": {
		"normal": "route_unselected",
		"selected": "route_selected",
		"locked": "route_locked",
	},
	"default": {"normal": "neutral"},
}

const PROJECT_SYMBOLS := {
	"cargo": {"shape_cue": "crate", "text_cue": "화물", "color_token": "cargo"},
	"route": {"shape_cue": "rail", "text_cue": "경로", "color_token": "route"},
	"switch": {"shape_cue": "branch", "text_cue": "분기", "color_token": "switch"},
	"unknown": {"shape_cue": "question", "text_cue": "알 수 없음", "color_token": "neutral"},
}


func resolve_ui(semantic_role: String, state: String) -> Dictionary:
	return SkinKitScript.new().resolve(semantic_role, state, PROJECT_SKIN)


func resolve_symbol(symbol_id: String) -> Dictionary:
	return SymbolAtlasScript.new().resolve(symbol_id, PROJECT_SYMBOLS)


func validate_track_footprint(
	board_size: Vector2i,
	occupied_cells: Dictionary,
	piece_footprint: Array,
	anchor: Vector2i,
	quarter_turns: int = 0,
	placement_context: Dictionary = {},
	project_predicates: Array = []
) -> Dictionary:
	return GridEngineScript.new().evaluate(
		board_size,
		occupied_cells,
		piece_footprint,
		anchor,
		quarter_turns,
		placement_context,
		project_predicates
	)
