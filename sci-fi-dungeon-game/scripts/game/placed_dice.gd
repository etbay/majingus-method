class_name Die extends Node

enum DieType {
	NORMAL,
	GILDED,
	LOW_ROLLER,
	HOLLOW,
	PLASMA,
	WEIGHTED
}

var _value: int = 1
var _faces: Array = [1, 2, 3, 4, 5, 6]
var x: int = 0
var y: int = 0

# Modifications
var _type: DieType
var quality: int = 0

func _init(value: int = 0, type: DieType = DieType.NORMAL, qual: int = 0):
	_value = value
	_type = type
	quality = qual
	
func get_value() -> int:
	return _value

func set_value(value: int) -> void:
	_value = value

func roll_die() -> int:
	_value = _faces[randi_range(0, _faces.size() - 1)]
	return _value

func set_type(new_type: DieType) -> void:
	_type = new_type
	if (_type == DieType.NORMAL):
		_faces = [1, 2, 3, 4, 5, 6]
	elif (_type == DieType.WEIGHTED):
		_faces = [4, 5, 6]
	elif (_type == DieType.LOW_ROLLER):
		_faces = [1, 2, 3]

func get_type() -> DieType:
	return _type
