class_name MapShuffleBag
extends RefCounted

var _all_ids: Array[StringName] = []
var _remaining: Array[StringName] = []
var _rng := RandomNumberGenerator.new()


func configure(ids: Array, seed: int) -> void:
	_all_ids.clear()
	for raw_id: Variant in ids:
		var map_id := StringName(raw_id)
		if map_id != &"" and not _all_ids.has(map_id):
			_all_ids.append(map_id)
	_all_ids.sort()
	_rng.seed = seed
	refill()


func refill() -> void:
	_remaining = _all_ids.duplicate()
	for index: int in range(_remaining.size() - 1, 0, -1):
		var swap_index := _rng.randi_range(0, index)
		var value: StringName = _remaining[index]
		_remaining[index] = _remaining[swap_index]
		_remaining[swap_index] = value


func peek(exclusions: Array) -> StringName:
	if _remaining.is_empty():
		return &""
	for map_id: StringName in _remaining:
		if not exclusions.has(map_id):
			return map_id
	return _remaining[0]


func consume(map_id: StringName) -> bool:
	var index := _remaining.find(map_id)
	if index < 0:
		return false
	_remaining.remove_at(index)
	return true


func remaining_count() -> int:
	return _remaining.size()


func remaining_ids() -> Array[StringName]:
	return _remaining.duplicate()
