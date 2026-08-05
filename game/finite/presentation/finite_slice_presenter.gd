class_name FiniteSlicePresenter
extends RefCounted

const CargoTypeScript := preload("res://game/cargo/cargo_type.gd")

var _model: Dictionary = {}
var _visual_stack: Array[StringName] = []
var _pending_unload_count: int = 0
var _unload_visual_active: bool = false


func _init() -> void:
	_reset_model()


func model() -> Dictionary:
	return _model.duplicate(true)


func show_build(
	preflight: Variant,
	current_cost: int,
	recommended_cost: int
) -> void:
	var did_pass := preflight != null and bool(preflight.passed)
	var code: StringName = &"NOT_READY"
	var detail := "Build a structurally valid route"
	var cells: Array[Vector2i] = []
	if preflight != null:
		code = StringName(preflight.primary_code)
		detail = str(preflight.message)
		for cell: Variant in preflight.problem_cells:
			cells.append(cell)

	_model["phase"] = &"BUILD"
	_model["start_enabled"] = did_pass
	_model["editing_enabled"] = true
	_model["primary_reason"] = code
	_model["status_text"] = detail
	_model["problem_cells"] = cells
	_model["current_cost"] = maxi(current_cost, 0)
	_model["recommended_cost"] = maxi(recommended_cost, 0)
	_model["switch_enabled"] = false
	_model["load_enabled"] = false
	_model["auto_enabled"] = false
	_model["auto_load_active"] = false
	_model["pause_visible"] = false
	_model["resume_visible"] = false
	_model["retry_visible"] = false
	_model["edit_visible"] = false
	_model["completion_visible"] = false
	_model["stack_tokens"] = []
	_model["unload_visual_active"] = false
	_model["time_remaining"] = 0.0


func show_run(
	run_state: Variant,
	load_order: Array[StringName],
	auto_load_active: bool,
	final_cost: int
) -> void:
	var phase: StringName = &"READY"
	var elapsed := 0.0
	var limit := 0.0
	if run_state != null:
		phase = StringName(run_state.phase())
		elapsed = float(run_state.elapsed_seconds())
		limit = float(run_state.time_limit_seconds())

	var controls_active := phase == &"RUNNING"
	var displayed_stack: Array[StringName] = (
		_visual_stack.duplicate()
		if _unload_visual_active and phase == &"UNLOADING"
		else load_order.duplicate()
	)

	_model["phase"] = phase
	_model["start_enabled"] = false
	_model["editing_enabled"] = false
	_model["primary_reason"] = &""
	_model["status_text"] = _run_status_text(phase)
	_model["problem_cells"] = []
	_model["switch_enabled"] = controls_active
	_model["load_enabled"] = controls_active
	_model["auto_enabled"] = controls_active
	_model["auto_load_active"] = auto_load_active
	_model["pause_visible"] = phase == &"RUNNING" or phase == &"UNLOADING"
	_model["resume_visible"] = phase == &"PAUSED"
	_model["retry_visible"] = false
	_model["edit_visible"] = false
	_model["completion_visible"] = false
	_model["current_cost"] = maxi(final_cost, 0)
	_model["final_cost"] = maxi(final_cost, 0)
	_model["elapsed_time"] = maxf(elapsed, 0.0)
	_model["time_limit"] = maxf(limit, 0.0)
	_model["time_remaining"] = maxf(limit - elapsed, 0.0)
	_model["stack_tokens"] = _tokens_for(displayed_stack)
	_model["unload_visual_active"] = _unload_visual_active


func begin_unload_visual(
	stack_before: Array[StringName],
	unloaded_items: Array[StringName]
) -> void:
	_visual_stack = stack_before.duplicate()
	_pending_unload_count = mini(unloaded_items.size(), _visual_stack.size())
	_unload_visual_active = _pending_unload_count > 0
	_model["stack_tokens"] = _tokens_for(_visual_stack)
	_model["unload_visual_active"] = _unload_visual_active


func apply_unload_emissions(emitted_items: Array[StringName]) -> void:
	if not _unload_visual_active:
		return
	for _cargo_type: StringName in emitted_items:
		if _pending_unload_count <= 0 or _visual_stack.is_empty():
			break
		_visual_stack.pop_back()
		_pending_unload_count -= 1
	if _pending_unload_count <= 0:
		_unload_visual_active = false
	_model["stack_tokens"] = _tokens_for(_visual_stack)
	_model["unload_visual_active"] = _unload_visual_active


func show_result(summary: Variant, final_cost: int) -> void:
	var outcome: StringName = &"FAILURE"
	var completion := 0.0
	var commit := -1.0
	var limit := 0.0
	if summary != null:
		outcome = StringName(summary.outcome)
		completion = float(summary.completion_time)
		commit = float(summary.final_delivery_commit_time)
		limit = float(summary.time_limit_seconds)

	_model["phase"] = outcome
	_model["start_enabled"] = false
	_model["editing_enabled"] = false
	_model["primary_reason"] = outcome
	_model["status_text"] = "Delivery complete" if outcome == &"SUCCESS" else "Time expired"
	_model["problem_cells"] = []
	_model["switch_enabled"] = false
	_model["load_enabled"] = false
	_model["auto_enabled"] = false
	_model["pause_visible"] = false
	_model["resume_visible"] = false
	_model["retry_visible"] = true
	_model["edit_visible"] = true
	_model["completion_visible"] = outcome == &"SUCCESS"
	_model["completion_time"] = maxf(completion, 0.0)
	_model["commit_time"] = commit
	_model["time_limit"] = maxf(limit, 0.0)
	_model["final_cost"] = maxi(final_cost, 0)
	_model["current_cost"] = maxi(final_cost, 0)
	_model["unload_visual_active"] = false


func cargo_descriptor(cargo_type: StringName) -> Dictionary:
	var color_name: StringName = CargoTypeScript.color_for(cargo_type)
	var shape_name: StringName = CargoTypeScript.shape_for(cargo_type)
	return {
		"cargo_type": cargo_type,
		"color": color_name,
		"shape": shape_name,
		"label": "%s · %s" % [str(color_name), str(shape_name)],
	}


func _reset_model() -> void:
	_model = {
		"phase": &"BUILD",
		"start_enabled": false,
		"editing_enabled": true,
		"primary_reason": &"NOT_READY",
		"status_text": "Build a structurally valid route",
		"problem_cells": [],
		"current_cost": 0,
		"recommended_cost": 0,
		"switch_enabled": false,
		"load_enabled": false,
		"auto_enabled": false,
		"auto_load_active": false,
		"pause_visible": false,
		"resume_visible": false,
		"retry_visible": false,
		"edit_visible": false,
		"completion_visible": false,
		"completion_time": 0.0,
		"commit_time": -1.0,
		"final_cost": 0,
		"elapsed_time": 0.0,
		"time_limit": 0.0,
		"time_remaining": 0.0,
		"stack_tokens": [],
		"unload_visual_active": false,
	}


func _tokens_for(load_order: Array[StringName]) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for index: int in range(load_order.size()):
		var descriptor := cargo_descriptor(load_order[index])
		descriptor["index"] = index
		descriptor["top"] = index == load_order.size() - 1
		result.append(descriptor)
	return result


static func _run_status_text(phase: StringName) -> String:
	match phase:
		&"READY":
			return "Ready"
		&"RUNNING":
			return "Train running"
		&"UNLOADING":
			return "Unloading TOP cargo"
		&"PAUSED":
			return "Paused · inspection only"
		&"SUCCESS":
			return "Delivery complete"
		&"FAILURE":
			return "Time expired"
		_:
			return str(phase)
