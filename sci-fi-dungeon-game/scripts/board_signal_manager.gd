class_name BoardSignalManager extends Node

signal coord_selected(int)

@export var button_00: Button
@export var button_10: Button
@export var button_20: Button
@export var button_30: Button

@export var button_01: Button
@export var button_11: Button
@export var button_21: Button
@export var button_31: Button

@export var button_02: Button
@export var button_12: Button
@export var button_22: Button
@export var button_32: Button

func _process(delta: float) -> void:
	button_00.pressed.connect(_on_column_0_pressed)

func _on_column_0_pressed() -> void:
	emit_signal("coord_selected", 1)
	pass
