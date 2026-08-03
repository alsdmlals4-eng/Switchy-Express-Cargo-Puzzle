class_name MapCatalog
extends RefCounted

const MapBuildPipelineScript := preload("res://game/map/map_build_pipeline.gd")

var _catalog_revision: StringName = &""
var _by_identity: Dictionary = {}
var _layout_owner: Dictionary = {}
var _content_owner: Dictionary = {}


func load_manifest(manifest: Dictionary, pipeline: Variant = null) -> Dictionary:
	clear()
	_catalog_revision = StringName(manifest.get("catalog_revision", &""))
	var errors: Array[String] = []
	if _catalog_revision == &"":
		errors.append("catalog_revision is required")
	var entries: Variant = manifest.get("entries", null)
	if not entries is Array or entries.is_empty():
		errors.append("catalog entries are required")
		return _failed(errors)
	if pipeline == null:
		pipeline = MapBuildPipelineScript.new()

	var pending_by_identity: Dictionary = {}
	var pending_layout_owner: Dictionary = {}
	var pending_content_owner: Dictionary = {}
	for raw_entry: Variant in entries:
		if not raw_entry is Dictionary:
			errors.append("catalog entry must be a Dictionary")
			continue
		var build_result: Variant = pipeline.build_from_manifest_entry(raw_entry)
		if not build_result.success:
			errors.append("%s: %s" % [str(build_result.error_code), build_result.message])
			continue
		var definition: Variant = build_result.definition
		var identity_key: String = definition.identity_key()
		if pending_by_identity.has(identity_key):
			errors.append("duplicate map identity: %s" % identity_key)
			continue
		if pending_layout_owner.has(definition.layout_signature):
			errors.append("duplicate layout_signature: %s" % definition.layout_signature)
			continue
		if pending_content_owner.has(definition.content_signature):
			errors.append("duplicate content_signature: %s" % definition.content_signature)
			continue
		pending_by_identity[identity_key] = definition
		pending_layout_owner[definition.layout_signature] = identity_key
		pending_content_owner[definition.content_signature] = identity_key

	if not errors.is_empty():
		return _failed(errors)
	_by_identity = pending_by_identity
	_layout_owner = pending_layout_owner
	_content_owner = pending_content_owner
	return {
		"success": true,
		"errors": [],
		"accepted_count": _by_identity.size(),
		"catalog_revision": _catalog_revision,
	}


func load_json_text(json_text: String, pipeline: Variant = null) -> Dictionary:
	var parsed: Variant = JSON.parse_string(json_text)
	if not parsed is Dictionary:
		clear()
		return _failed(["catalog JSON root must be a Dictionary"])
	return load_manifest(parsed, pipeline)


func resolve(map_id: StringName, revision: int) -> Variant:
	return _by_identity.get("%s@%d" % [map_id, revision], null)


func resolve_latest(map_id: StringName) -> Variant:
	var matches: Array = []
	for definition: Variant in _by_identity.values():
		if definition.map_id == map_id:
			matches.append(definition)
	matches.sort_custom(func(first: Variant, second: Variant) -> bool:
		return first.map_revision > second.map_revision
	)
	return null if matches.is_empty() else matches[0]


func runtime_entries() -> Array:
	var entries: Array = _by_identity.values()
	entries.sort_custom(func(first: Variant, second: Variant) -> bool:
		if first.map_id == second.map_id:
			return first.map_revision < second.map_revision
		return str(first.map_id) < str(second.map_id)
	)
	return entries


func stable_map_ids() -> Array[StringName]:
	var ids: Array[StringName] = []
	for definition: Variant in runtime_entries():
		if not ids.has(definition.map_id):
			ids.append(definition.map_id)
	return ids


func unique_layout_count() -> int:
	return _layout_owner.size()


func catalog_revision() -> StringName:
	return _catalog_revision


func clear() -> void:
	_catalog_revision = &""
	_by_identity.clear()
	_layout_owner.clear()
	_content_owner.clear()


func _failed(errors: Array[String]) -> Dictionary:
	clear()
	return {
		"success": false,
		"errors": errors,
		"accepted_count": 0,
		"catalog_revision": &"",
	}
