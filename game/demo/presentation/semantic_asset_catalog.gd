class_name SemanticAssetCatalog
extends RefCounted

const BASE_MANIFEST_PATH := "res://art/product_assets/ed_hybrid_v1/manifest.json"
const RUN_MANIFEST_PATH := "res://art/product_assets/ed_hybrid_v1/semantic_manifest_sx_dec_054.json"
const BUILD_MANIFEST_PATH := "res://art/product_assets/ed_hybrid_v1/semantic_manifest_sx_dec_054_build_2b.json"
const VFX_MANIFEST_PATH := "res://art/product_assets/ed_hybrid_v1/semantic_manifest_sx_dec_054_vfx_2c.json"

var _ready: bool = false
var _errors: Array[String] = []
var _composition_index: Dictionary = {}
var _vfx_index: Dictionary = {}
var _base_path_index: Dictionary = {}
var _base_slice_index: Dictionary = {}


func load_default() -> bool:
	_reset()

	var base_manifest := _load_json(BASE_MANIFEST_PATH)
	var run_manifest := _load_json(RUN_MANIFEST_PATH)
	var build_manifest := _load_json(BUILD_MANIFEST_PATH)
	var vfx_manifest := _load_json(VFX_MANIFEST_PATH)
	if not _errors.is_empty():
		return false

	_validate_identity(base_manifest, &"SX-DEC-053", &"")
	_validate_identity(run_manifest, &"SX-DEC-054", &"RUN_2A")
	_validate_identity(build_manifest, &"SX-DEC-054", &"BUILD_2B")
	_validate_identity(vfx_manifest, &"SX-DEC-054", &"VFX_2C")
	if not _errors.is_empty():
		return false

	_index_base_assets(base_manifest)
	_index_compositions(run_manifest)
	_index_compositions(build_manifest)
	_index_vfx(vfx_manifest)
	_ready = _errors.is_empty()
	return _ready


func is_ready() -> bool:
	return _ready


func errors() -> Array[String]:
	var result: Array[String] = []
	result.assign(_errors)
	return result


func composition(component: StringName, state: StringName) -> Dictionary:
	var record: Variant = _composition_index.get(_key(component, state), {})
	if not record is Dictionary:
		return {}
	return record.duplicate(true)


func vfx_composition(event: StringName, reduced_motion: bool) -> Dictionary:
	var mode := &"reduced_motion" if reduced_motion else &"standard"
	var record: Variant = _vfx_index.get(_key(event, mode), {})
	if not record is Dictionary:
		return {}
	return record.duplicate(true)


func base_asset_by_authoritative_slice(slice_name: StringName) -> Dictionary:
	var record: Variant = _base_slice_index.get(str(slice_name), {})
	if not record is Dictionary:
		return {}
	return record.duplicate(true)


func textures_for(record: Dictionary) -> Array[Texture2D]:
	var result: Array[Texture2D] = []
	var inputs: Variant = record.get("inputs", [])
	if not inputs is Array:
		return result

	for input_path: Variant in inputs:
		var resource_path := _resource_path(str(input_path))
		if not ResourceLoader.exists(resource_path):
			return []
		var texture := load(resource_path) as Texture2D
		if texture == null:
			return []
		result.append(texture)
	return result


func _reset() -> void:
	_ready = false
	_errors.clear()
	_composition_index.clear()
	_vfx_index.clear()
	_base_path_index.clear()
	_base_slice_index.clear()


func _load_json(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		_errors.append("missing manifest: %s" % path)
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		_errors.append("unable to open manifest: %s" % path)
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	if not parsed is Dictionary:
		_errors.append("manifest must contain a JSON object: %s" % path)
		return {}
	return parsed


func _validate_identity(manifest: Dictionary, decision_id: StringName, batch: StringName) -> void:
	if StringName(manifest.get("decision_id", &"")) != decision_id:
		_errors.append("unexpected decision_id for %s" % str(decision_id))
	if batch != &"" and StringName(manifest.get("batch", &"")) != batch:
		_errors.append("unexpected batch for %s" % str(batch))


func _index_base_assets(manifest: Dictionary) -> void:
	var assets: Variant = manifest.get("assets", [])
	if not assets is Array:
		_errors.append("SX-DEC-053 assets must be an array")
		return
	for item: Variant in assets:
		if not item is Dictionary:
			continue
		var path := str(item.get("path", ""))
		if path != "":
			_base_path_index[path] = item.duplicate(true)
		var slice_name := str(item.get("authoritative_slice_name", ""))
		if slice_name != "":
			_base_slice_index[slice_name] = item.duplicate(true)


func _index_compositions(manifest: Dictionary) -> void:
	var records: Variant = manifest.get("semantic_compositions", [])
	if not records is Array:
		_errors.append("semantic_compositions must be an array")
		return
	for item: Variant in records:
		if not item is Dictionary:
			continue
		var component := StringName(item.get("component", &""))
		var state := StringName(item.get("state", &""))
		if component == &"" or state == &"":
			continue
		_composition_index[_key(component, state)] = item.duplicate(true)


func _index_vfx(manifest: Dictionary) -> void:
	var records: Variant = manifest.get("semantic_compositions", [])
	if not records is Array:
		_errors.append("VFX semantic_compositions must be an array")
		return
	for item: Variant in records:
		if not item is Dictionary:
			continue
		var event := StringName(item.get("event", &""))
		var mode := StringName(item.get("presentation_mode", &""))
		if event == &"" or mode == &"":
			continue
		_vfx_index[_key(event, mode)] = item.duplicate(true)


func _key(first: StringName, second: StringName) -> String:
	return "%s|%s" % [str(first), str(second)]


func _resource_path(path: String) -> String:
	if path.begins_with("res://"):
		return path
	if path.begins_with("art/"):
		return "res://%s" % path
	return path
