class_name Die extends Node

var _value: int = 1
var _faces: Array = [1, 2, 3, 4, 5, 6]
var position: Array = [0, 0]

func _init(value: int):
	_value = value

func get_value() -> int:
	return _value

func roll_die() -> int:
	_value = _faces[randi_range(0, _faces.size() - 1)]
	return _value
