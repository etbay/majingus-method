class_name Board extends Node

const WIDTH = 4
const HEIGHT = 3
var _board_array: Array[Array]

func _init() -> void:
	for x in range(0, WIDTH):
		var column: Array[Die] = [null]
		_board_array.append(column)
	for array in _board_array:
		array.resize(HEIGHT)
		array.fill(Die.new(0))

func place_dice(column: int, roll: Die) -> bool:
	var placed: bool = false
	for i in range(0, HEIGHT):
		if (_board_array[column][i].get_value() == 0):
			_board_array[column][i] = roll
			placed = true
			break
	return placed

func calculate_score() -> int:
	var sum = 0
	for i in range(0, WIDTH):
		sum += calculate_column_score(i)
	return sum
	
func calculate_column_score(column: int) -> int:
	var dict: Dictionary
	for i in range(0, HEIGHT):
		var entry = _board_array[column][i].get_value()
		if dict[str(entry)] == null:
			dict[str(entry)] = 1
		else:
			dict[str(entry)] += 1
	var sum = 0
	for entry in dict:
		if dict[entry] > 0:
			sum += dict[entry] * int(entry)
	return sum

func destroy_die(x: int, y: int) -> void:
	_board_array[x][y] = null
	for i in range(y, HEIGHT - 1):
		_board_array[x][i] = _board_array[x][i + 1] # falling blocks
		
func clear_column(column: int) -> void:
	for i in range(0, HEIGHT):
		_board_array[column][i]

func clear_board() -> void:
	for arr in _board_array:
		for item in arr:
			item = null

func get_board_values() -> Array[Array]:
	return _board_array

func get_value_at(x: int, y: int) -> int:
	return _board_array[x][y].get_value()
