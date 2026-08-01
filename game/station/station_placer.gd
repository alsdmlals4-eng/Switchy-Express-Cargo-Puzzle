class_name StationPlacer
extends RefCounted

const CargoTypeScript := preload("res://game/cargo/cargo_type.gd")
const StationScript := preload("res://game/station/station.gd")

const DEFAULT_PAIR_ATTEMPTS := 4096
const MINIMUM_SAME_TYPE_DISTANCE := 5


func place(
	graph: Variant,
	train_start: Vector2i,
	seed: int,
	max_pair_attempts: int = DEFAULT_PAIR_ATTEMPTS
) -> Dictionary:
	if max_pair_attempts <= 0:
		return _failure_result()

	var switch_set: Dictionary = {}
	for switch_cell: Vector2i in graph.switch_cells():
		switch_set[switch_cell] = true

	var candidates: Array[Vector2i] = []
	for cell: Vector2i in graph.all_cells():
		if cell == train_start or switch_set.has(cell):
			continue
		candidates.append(cell)
	_shuffle_cells(candidates, seed)

	var stations: Array = []
	var occupied: Dictionary = {}
	var pair_attempts := 0

	for cargo_type: StringName in CargoTypeScript.all_types():
		var pair := _find_pair(
			graph,
			candidates,
			occupied,
			max_pair_attempts - pair_attempts
		)
		pair_attempts += int(pair.attempts)
		if not pair.success:
			return _failure_result()

		for cell: Vector2i in pair.cells:
			occupied[cell] = true
			stations.append(StationScript.new(cell, cargo_type))

	return {
		"success": true,
		"status": &"PLACED",
		"stations": stations,
		"signature": _signature(stations),
		"attempts": pair_attempts,
	}


func _find_pair(
	graph: Variant,
	candidates: Array[Vector2i],
	occupied: Dictionary,
	attempt_budget: int
) -> Dictionary:
	var attempts := 0
	for first_index: int in range(candidates.size()):
		var first: Vector2i = candidates[first_index]
		if occupied.has(first):
			continue
		for second_index: int in range(first_index + 1, candidates.size()):
			attempts += 1
			if attempts > attempt_budget:
				return {"success": false, "cells": [], "attempts": attempts}
			var second: Vector2i = candidates[second_index]
			if occupied.has(second):
				continue
			if graph.shortest_path_distance(first, second) < MINIMUM_SAME_TYPE_DISTANCE:
				continue
			return {
				"success": true,
				"cells": [first, second],
				"attempts": attempts,
			}
	return {"success": false, "cells": [], "attempts": attempts}


func _shuffle_cells(cells: Array[Vector2i], seed: int) -> void:
	var random := RandomNumberGenerator.new()
	random.seed = seed
	for index: int in range(cells.size() - 1, 0, -1):
		var swap_index := random.randi_range(0, index)
		var temporary: Vector2i = cells[index]
		cells[index] = cells[swap_index]
		cells[swap_index] = temporary


func _signature(stations: Array) -> String:
	var parts: Array[String] = []
	for station: Variant in stations:
		parts.append("%s@%d,%d" % [station.cargo_type, station.cell.x, station.cell.y])
	parts.sort()
	return "|".join(parts)


func _failure_result() -> Dictionary:
	return {
		"success": false,
		"status": &"PLACEMENT_FAILED",
		"stations": [],
		"signature": "",
		"attempts": 0,
	}
