class_name DemoEffects
extends Node

const BUILD_DURATION := 0.16
const REMOVE_DURATION := 0.12
const UNLOAD_BASE_DURATION := 0.18
const UNLOAD_STAGGER := 0.12
const SUCCESS_DURATION := 0.35
const FAILURE_DURATION := 0.25
const MAX_EFFECT_DURATION := 1.0

var _active_tweens: Array[Tween] = []
var _target_tweens: Dictionary = {}
var _reduced_motion := false
var _paused := false


func play_build(_cell: Vector2i) -> void:
	_pulse("HUD/BuildToolbar", BUILD_DURATION)


func play_remove(_cell: Vector2i) -> void:
	_pulse("HUD/BuildToolbar", REMOVE_DURATION)


func play_unload(count: int) -> void:
	if count <= 0:
		return
	var duration := minf(UNLOAD_BASE_DURATION + UNLOAD_STAGGER * float(count - 1), MAX_EFFECT_DURATION)
	_pulse("HUD/StackPanel/StackLayout/TopSummary", duration)


func play_success() -> void:
	_pulse("HUD/TopStatus/PhaseLabel", SUCCESS_DURATION)


func play_failure() -> void:
	_pulse("HUD/TopStatus/PhaseLabel", FAILURE_DURATION)


func set_reduced_motion(enabled: bool) -> void:
	_reduced_motion = enabled
	if enabled:
		cancel_all()


func set_paused(paused: bool) -> void:
	_paused = paused
	for tween: Tween in _active_tweens:
		if tween.is_valid():
			if paused:
				tween.pause()
			else:
				tween.play()


func cancel_all() -> void:
	for target: Control in _target_tweens:
		if is_instance_valid(target):
			target.modulate.a = 1.0
	for tween: Tween in _active_tweens:
		if tween.is_valid():
			tween.kill()
	_target_tweens.clear()
	_active_tweens.clear()


func maximum_effect_duration_for_test() -> float:
	return MAX_EFFECT_DURATION


func active_effect_count_for_test() -> int:
	return _active_tweens.size()


func _exit_tree() -> void:
	cancel_all()


func _pulse(path: NodePath, duration: float) -> void:
	if _reduced_motion or get_parent() == null:
		return
	var target := get_parent().get_node_or_null(path) as Control
	if target == null:
		return
	# One bounded pulse per local target; never transform the board or recolor cargo.
	if _target_tweens.has(target):
		var previous: Tween = _target_tweens[target]
		previous.kill()
		_active_tweens.erase(previous)
	target.modulate.a = 1.0
	var tween := create_tween()
	_active_tweens.append(tween)
	_target_tweens[target] = tween
	tween.tween_property(target, "modulate:a", 0.82, duration * 0.5)
	tween.tween_property(target, "modulate:a", 1.0, duration * 0.5)
	tween.finished.connect(func() -> void:
		_active_tweens.erase(tween)
		if _target_tweens.get(target) == tween:
			_target_tweens.erase(target)
	)
	if _paused:
		tween.pause()
