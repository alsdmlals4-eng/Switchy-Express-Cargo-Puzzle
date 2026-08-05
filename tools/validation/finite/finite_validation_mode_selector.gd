class_name FiniteValidationModeSelector
extends Control

signal mode_requested(mode: StringName)

const MODE_PROOF: StringName = &"PROOF"
const MODE_STACK_8: StringName = &"STACK_8"
const MODE_STACK_16: StringName = &"STACK_16"
const MODE_STACK_32: StringName = &"STACK_32"

@onready var _proof_button := get_node("Panel/Margin/Modes/ProofButton") as Button
@onready var _stack_8_button := get_node("Panel/Margin/Modes/Stack8Button") as Button
@onready var _stack_16_button := get_node("Panel/Margin/Modes/Stack16Button") as Button
@onready var _stack_32_button := get_node("Panel/Margin/Modes/Stack32Button") as Button


func _ready() -> void:
	_proof_button.pressed.connect(_emit_mode.bind(MODE_PROOF))
	_stack_8_button.pressed.connect(_emit_mode.bind(MODE_STACK_8))
	_stack_16_button.pressed.connect(_emit_mode.bind(MODE_STACK_16))
	_stack_32_button.pressed.connect(_emit_mode.bind(MODE_STACK_32))
	show_selector()


func show_selector() -> void:
	visible = true
	mouse_filter = Control.MOUSE_FILTER_STOP


func hide_selector() -> void:
	visible = false
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func is_selector_visible() -> bool:
	return visible


func _emit_mode(mode: StringName) -> void:
	mode_requested.emit(mode)
