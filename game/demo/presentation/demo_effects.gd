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


func play_build(_cell: Vector2i) -> void:
	var target := _board_target()
	if target == null:
		return
	var tween := _tracked_tween()
	target.pivot_offset = target.size * 0.5
	tween.tween_property(target, "scale", Vector2(1.012, 1.012), BUILD_DURATION * 0.5)
	tween.tween_property(target, "scale", Vector2.ONE, BUILD_DURATION * 0.5)


func play_remove(_cell: Vector2i) -> void:
	var target := _board_target()
	if target == null:
		return
	var tween := _tracked_tween()
	tween.tween_property(target, "modulate", Color(1.0, 0.78, 0.72, 1.0), REMOVE_DURATION * 0.5)
	tween.tween_property(target, "modulate", Color.WHITE, REMOVE_DURATION * 0.5)


func play_unload(count: int) -> void:
	var target := _hud_target()
	if target == null or count <= 0:
		return
	var duration := minf(
		UNLOAD_BASE_DURATION + UNLOAD_STAGGER * float(maxi(count - 1, 0)),
		MAX_EFFECT_DURATION
	)
	var tween := _tracked_tween()
	tween.tween_property(target, "modulate", Color(1.0, 0.91, 0.58, 1.0), duration * 0.5)
	tween.tween_property(target, "modulate", Color.WHITE, duration * 0.5)


func play_success() -> void:
	var target := _hud_target()
	if target == null:
		return
	var tween := _tracked_tween()
	target.pivot_offset = target.size * 0.5
	tween.tween_property(target, "scale", Vector2(1.025, 1.025), SUCCESS_DURATION * 0.5)
	tween.tween_property(target, "scale", Vector2.ONE, SUCCESS_DURATION * 0.5)


func play_failure() -> void:
	var target := _hud_target()
	if target == null:
		return
	var tween := _tracked_tween()
	tween.tween_property(target, "modulate", Color(1.0, 0.72, 0.72, 1.0), FAILURE_DURATION * 0.5)
	tween.tween_property(target, "modulate", Color.WHITE, FAILURE_DURATION * 0.5)


func cancel_all() -> void:
	for tween: Tween in _active_tweens:
		if tween != null and tween.is_valid():
			tween.kill()
	_active_tweens.clear()
	_reset_target(_board_target())
	_reset_target(_hud_target())


func maximum_effect_duration_for_test() -> float:
	return MAX_EFFECT_DURATION


func active_effect_count_for_test() -> int:
	_prune_finished()
	return _active_tweens.size()


func _exit_tree() -> void:
	cancel_all()


func _tracked_tween() -> Tween:
	var tween := create_tween()
	_active_tweens.append(tween)
	tween.finished.connect(func() -> void: _active_tweens.erase(tween))
	return tween


func _prune_finished() -> void:
	var remaining: Array[Tween] = []
	for tween: Tween in _active_tweens:
		if tween != null and tween.is_valid() and tween.is_running():
			remaining.append(tween)
	_active_tweens = remaining


func _board_target() -> Control:
	return get_parent().get_node_or_null("BoardRenderer") as Control if get_parent() != null else null


func _hud_target() -> Control:
	return get_parent().get_node_or_null("HUD") as Control if get_parent() != null else null


static func _reset_target(target: Control) -> void:
	if target == null:
		return
	target.scale = Vector2.ONE
	target.modulate = Color.WHITE
