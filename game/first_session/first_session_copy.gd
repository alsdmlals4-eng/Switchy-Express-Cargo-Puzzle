class_name FirstSessionCopy
extends RefCounted

const DEFAULT_PATH := "res://data/localization/first_session_v1.json"
const SCHEMA_VERSION := 1
const REQUIRED_LOCALES: Array[String] = ["ko", "en", "ja", "zh-Hans"]

var _strings: Dictionary = {}


func load_default() -> bool:
	return load_from_path(DEFAULT_PATH)


func load_from_path(path: String) -> bool:
	_strings.clear()
	if not FileAccess.file_exists(path):
		return false
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return false
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary or int(parsed.get("schema_version", -1)) != SCHEMA_VERSION:
		return false
	var locales: Variant = parsed.get("locales", [])
	var strings: Variant = parsed.get("strings", {})
	if not locales is Array or not strings is Dictionary:
		return false
	for locale: String in REQUIRED_LOCALES:
		if not locales.has(locale):
			return false
	for key: Variant in strings.keys():
		var record: Variant = strings[key]
		if not record is Dictionary:
			return false
		for locale: String in REQUIRED_LOCALES:
			if str(record.get(locale, "")).is_empty():
				return false
		_strings[StringName(key)] = record.duplicate(true)
	return not _strings.is_empty()


func text(key: StringName, locale: String = "") -> String:
	var record: Variant = _strings.get(key)
	if not record is Dictionary:
		return ""
	var normalized := _normalize_locale(locale)
	var value := str(record.get(normalized, ""))
	if value.is_empty():
		value = str(record.get("en", ""))
	if value.is_empty():
		value = str(record.get("ko", ""))
	return value


func format(key: StringName, values: Dictionary, locale: String = "") -> String:
	var result := text(key, locale)
	for name: Variant in values.keys():
		result = result.replace("{%s}" % str(name), str(values[name]))
	return result


static func _normalize_locale(locale: String) -> String:
	var value := locale.strip_edges().replace("_", "-")
	if value.is_empty():
		value = TranslationServer.get_locale().replace("_", "-")
	if value == "zh" or value.begins_with("zh-CN") or value.begins_with("zh-Hans"):
		return "zh-Hans"
	for supported: String in REQUIRED_LOCALES:
		if value == supported or value.begins_with(supported + "-"):
			return supported
	return "en"
