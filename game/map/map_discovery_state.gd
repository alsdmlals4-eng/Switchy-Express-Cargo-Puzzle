class_name MapDiscoveryState
extends RefCounted

const MapShuffleBagScript := preload("res://game/map/map_shuffle_bag.gd")
const MAX_RECENT := 3

var _all_ids: Array[StringName] = []
var _discovered: Dictionary = {}
var _play_counts: Dictionary = {}
var _recent: Array[StringName] = []
var _committed_receipts: Dictionary = {}
var _undiscovered_bag: Variant
var _replay_bag: Variant


func configure(ids: Array, seed: int) -> void:
	_all_ids.clear()
	for raw_id: Variant in ids:
		var map_id := StringName(raw_id)
		if map_id != &"" and not _all_ids.has(map_id):
			_all_ids.append(map_id)
	_all_ids.sort()
	_discovered.clear()
	_play_counts.clear()
	_recent.clear()
	_committed_receipts.clear()
	_undiscovered_bag = MapShuffleBagScript.new()
	_undiscovered_bag.configure(_all_ids, seed)
	_replay_bag = MapShuffleBagScript.new()
	_replay_bag.configure(_all_ids, seed + 1)


func peek_undiscovered() -> StringName:
	if _undiscovered_bag == null:
		return &""
	var exclusions: Array = discovered_ids()
	return _undiscovered_bag.peek(exclusions)


func peek_replay() -> StringName:
	if _replay_bag == null:
		return &""
	if _replay_bag.remaining_count() == 0:
		_replay_bag.refill()
	var exclusions: Array = []
	if not _recent.is_empty():
		exclusions.append(_recent[0])
	return _replay_bag.peek(exclusions)


func commit_receipt(receipt: Variant) -> bool:
	if receipt == null or receipt.receipt_id.is_empty():
		return false
	if _committed_receipts.has(receipt.receipt_id):
		return false
	if not _all_ids.has(receipt.map_id):
		return false

	match receipt.selection_phase:
		&"UNDISCOVERED":
			if is_discovered(receipt.map_id):
				return false
			if not _undiscovered_bag.consume(receipt.map_id):
				return false
		&"REPLAY":
			if not is_discovered(receipt.map_id):
				return false
			if not _replay_bag.consume(receipt.map_id):
				return false
		&"MANUAL", &"RESTART":
			if not is_discovered(receipt.map_id):
				return false
		_:
			return false

	_committed_receipts[receipt.receipt_id] = true
	_discovered[receipt.map_id] = true
	_play_counts[receipt.map_id] = play_count(receipt.map_id) + 1
	_recent.erase(receipt.map_id)
	_recent.push_front(receipt.map_id)
	if _recent.size() > MAX_RECENT:
		_recent.resize(MAX_RECENT)
	return true


func is_discovered(map_id: StringName) -> bool:
	return bool(_discovered.get(map_id, false))


func discovered_ids() -> Array[StringName]:
	var ids: Array[StringName] = []
	for raw_id: Variant in _discovered.keys():
		if bool(_discovered[raw_id]):
			ids.append(StringName(raw_id))
	ids.sort()
	return ids


func undiscovered_remaining_count() -> int:
	return _all_ids.size() - discovered_ids().size()


func play_count(map_id: StringName) -> int:
	return int(_play_counts.get(map_id, 0))


func total_play_count() -> int:
	var total := 0
	for value: Variant in _play_counts.values():
		total += int(value)
	return total


func recent_ids() -> Array[StringName]:
	return _recent.duplicate()


func is_receipt_committed(receipt_id: String) -> bool:
	return _committed_receipts.has(receipt_id)
