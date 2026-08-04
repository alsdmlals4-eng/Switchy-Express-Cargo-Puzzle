class_name UnloadSequence
extends RefCounted

const MIN_DURATION_SECONDS := 0.12
const PER_ITEM_SECONDS := 0.08
const MAX_DURATION_SECONDS := 1.0
const TIME_EPSILON := 0.000001

var _items: Array[StringName] = []
var _elapsed_seconds: float = 0.0
var _total_duration: float = 0.0
var _emitted_count: int = 0


func _init(sequence_items: Array[StringName] = []) -> void:
	_items = sequence_items.duplicate()
	if not _items.is_empty():
		_total_duration = minf(
			MAX_DURATION_SECONDS,
			maxf(MIN_DURATION_SECONDS, PER_ITEM_SECONDS * float(_items.size()))
		)


func advance_time(delta_seconds: float) -> Array[StringName]:
	var emitted: Array[StringName] = []
	if delta_seconds <= 0.0 or is_complete():
		return emitted

	_elapsed_seconds = minf(_elapsed_seconds + delta_seconds, _total_duration)
	var target_count := _target_emitted_count()
	while _emitted_count < target_count:
		emitted.append(_items[_emitted_count])
		_emitted_count += 1
	return emitted


func total_duration() -> float:
	return _total_duration


func remaining_seconds() -> float:
	return maxf(_total_duration - _elapsed_seconds, 0.0)


func pending_count() -> int:
	return _items.size() - _emitted_count


func is_complete() -> bool:
	return _items.is_empty() or _emitted_count >= _items.size()


func items() -> Array[StringName]:
	return _items.duplicate()


func _target_emitted_count() -> int:
	if _items.is_empty():
		return 0
	if _elapsed_seconds >= _total_duration - TIME_EPSILON:
		return _items.size()
	var progress := _elapsed_seconds / _total_duration
	return clampi(int(floor(progress * float(_items.size()) + TIME_EPSILON)), 0, _items.size())
