class_name DemoAudioDirector
extends Node

const MIX_RATE := 22050.0
const ONE_SHOT_BUFFER_SECONDS := 0.25
const TRAIN_BUFFER_SECONDS := 0.35
const TRAIN_FREQUENCY := 72.0
const TAU_VALUE := PI * 2.0

const CUE_SETTINGS := {
	&"button": {"frequency": 520.0, "duration": 0.055, "gain": 0.12},
	&"build": {"frequency": 690.0, "duration": 0.085, "gain": 0.14},
	&"remove": {"frequency": 250.0, "duration": 0.09, "gain": 0.13},
	&"switch": {"frequency": 430.0, "duration": 0.075, "gain": 0.13},
	&"pickup": {"frequency": 780.0, "duration": 0.08, "gain": 0.12},
	&"unload": {"frequency": 610.0, "duration": 0.12, "gain": 0.14},
	&"success": {"frequency": 880.0, "duration": 0.22, "gain": 0.16},
	&"failure": {"frequency": 180.0, "duration": 0.24, "gain": 0.15},
}

var _cue_streams: Dictionary = {}
var _one_shot_player: AudioStreamPlayer
var _train_player: AudioStreamPlayer
var _one_shot_playback: Variant
var _train_playback: Variant
var _last_cue: StringName = &""
var _train_loop_active: bool = false
var _paused_mix: bool = false
var _cue_phase: float = 0.0
var _train_phase: float = 0.0
var _cue_frames_remaining: int = 0
var _cue_frequency: float = 0.0
var _cue_gain: float = 0.0
var _train_frame_index: int = 0


func _ready() -> void:
	_ensure_players()
	set_process(true)


func play_cue(cue: StringName) -> void:
	if not CUE_SETTINGS.has(cue):
		return
	_ensure_players()
	_last_cue = cue
	var settings: Dictionary = CUE_SETTINGS[cue]
	var stream: AudioStreamGenerator = stream_for_cue_for_test(cue)
	_one_shot_player.stream = stream
	_one_shot_player.volume_db = -80.0 if _paused_mix else -12.0
	_one_shot_player.play()
	_one_shot_playback = _one_shot_player.get_stream_playback()
	_cue_phase = 0.0
	_cue_frequency = float(settings["frequency"])
	_cue_gain = float(settings["gain"])
	_cue_frames_remaining = int(round(float(settings["duration"]) * MIX_RATE))
	_fill_one_shot_buffer()


func set_train_loop_active(active: bool) -> void:
	_ensure_players()
	_train_loop_active = active
	if not active:
		_train_player.stop()
		_train_playback = null
		return
	if _train_player.playing:
		return
	var generator := AudioStreamGenerator.new()
	generator.mix_rate = MIX_RATE
	generator.buffer_length = TRAIN_BUFFER_SECONDS
	_train_player.stream = generator
	_train_player.volume_db = -80.0 if _paused_mix else -25.0
	_train_player.play()
	_train_playback = _train_player.get_stream_playback()
	_fill_train_buffer()


func set_paused(paused: bool) -> void:
	_paused_mix = paused
	if _one_shot_player != null:
		_one_shot_player.volume_db = -80.0 if paused else -12.0
	if _train_player != null:
		_train_player.volume_db = -80.0 if paused else -25.0


func stop_all() -> void:
	if _one_shot_player != null:
		_one_shot_player.stop()
	if _train_player != null:
		_train_player.stop()
	_one_shot_playback = null
	_train_playback = null
	_last_cue = &""
	_train_loop_active = false
	_cue_frames_remaining = 0


func stream_for_cue_for_test(cue: StringName) -> AudioStreamGenerator:
	if _cue_streams.has(cue):
		return _cue_streams[cue]
	if not CUE_SETTINGS.has(cue):
		return null
	var generator := AudioStreamGenerator.new()
	generator.mix_rate = MIX_RATE
	generator.buffer_length = ONE_SHOT_BUFFER_SECONDS
	_cue_streams[cue] = generator
	return generator


func last_cue_for_test() -> StringName:
	return _last_cue


func train_loop_active_for_test() -> bool:
	return _train_loop_active


func paused_for_test() -> bool:
	return _paused_mix


func _process(_delta: float) -> void:
	_fill_one_shot_buffer()
	_fill_train_buffer()


func _exit_tree() -> void:
	stop_all()


func _ensure_players() -> void:
	if _one_shot_player == null:
		_one_shot_player = AudioStreamPlayer.new()
		_one_shot_player.name = "OneShotPlayer"
		add_child(_one_shot_player)
	if _train_player == null:
		_train_player = AudioStreamPlayer.new()
		_train_player.name = "TrainLoopPlayer"
		add_child(_train_player)


func _fill_one_shot_buffer() -> void:
	if _one_shot_playback == null or _cue_frames_remaining <= 0:
		return
	var available: int = int(_one_shot_playback.get_frames_available())
	var frames_to_push := mini(available, _cue_frames_remaining)
	for index: int in range(frames_to_push):
		var normalized_remaining := float(_cue_frames_remaining - index) / maxf(
			float(_cue_frames_remaining),
			1.0
		)
		var envelope := minf(1.0, float(index + 1) / 96.0) * normalized_remaining
		var sample := sin(_cue_phase) * _cue_gain * envelope
		_one_shot_playback.push_frame(Vector2(sample, sample))
		_cue_phase = fmod(_cue_phase + TAU_VALUE * _cue_frequency / MIX_RATE, TAU_VALUE)
	_cue_frames_remaining -= frames_to_push
	if _cue_frames_remaining <= 0:
		_one_shot_player.stop()
		_one_shot_playback = null


func _fill_train_buffer() -> void:
	if not _train_loop_active or _train_playback == null:
		return
	var available: int = int(_train_playback.get_frames_available())
	for _index: int in range(available):
		var beat_position := fmod(float(_train_frame_index) / MIX_RATE, 0.42)
		var beat_envelope := maxf(0.0, 1.0 - beat_position / 0.075)
		var harmonic := sin(_train_phase) * 0.035 + sin(_train_phase * 2.03) * 0.012
		var sample := harmonic * beat_envelope
		_train_playback.push_frame(Vector2(sample, sample))
		_train_phase = fmod(_train_phase + TAU_VALUE * TRAIN_FREQUENCY / MIX_RATE, TAU_VALUE)
		_train_frame_index += 1
