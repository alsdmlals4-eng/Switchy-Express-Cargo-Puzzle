class_name RunIdFactory
extends RefCounted

var _sequence: Array[String] = []
var _sequence_index: int = 0
var _counter: int = 0


func configure_sequence(ids: Array) -> void:
	_sequence.clear()
	for raw_id: Variant in ids:
		var run_id := str(raw_id)
		assert(not run_id.is_empty(), "configured run id cannot be empty")
		_sequence.append(run_id)
	_sequence_index = 0


func next_id() -> String:
	if _sequence_index < _sequence.size():
		var configured_id: String = _sequence[_sequence_index]
		_sequence_index += 1
		return configured_id

	_counter += 1
	var entropy := Crypto.new().generate_random_bytes(12).hex_encode()
	return "run-%d-%d-%s" % [Time.get_ticks_usec(), _counter, entropy]
