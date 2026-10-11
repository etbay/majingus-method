class_name Board extends Node

const WIDTH = 4
const HEIGHT = 3
var _board_array: Array[Array]
var _board_dict: Dictionary[String, Array] # string = face, array = dice of that type

func _init() -> void:
	for x in range(0, WIDTH):
		var column: Array[Die] = [null]
		_board_array.append(column)
	for array in _board_array:
		array.resize(HEIGHT)
		array.fill(null)

func place_dice(column: int, die: Die) -> bool:
	var placed: bool = false
	for i in range(0, HEIGHT):
		if (_board_array[column][i] == null):
			_board_array[column][i] = die
			placed = true
			die.x = column
			die.y = i
			break
	return placed

func calculate_score() -> int:
	var sum = 0
	for i in range(0, WIDTH):
		sum += calculate_column_score(i)
	# calculate money from gilded dice
	return sum

func calculate_gilded() -> int:
	var money: int = 0
	for arr in _board_array:
		for die in arr:
			if die != null and die.type == Die.DieType.GILDED and _board_dict[die.get_value()] != null:
				money += maxi(_board_dict[die.get_value()].size() - 1, 0) # add 1 money per matching die roll	
	return money

# accepts column index
func calculate_column_score(column: int) -> int:
	var column_dict: Dictionary[String, Array] = {} # arr = all values in column (not face, value)
	for entry in _board_array[column]:
		if entry != null:
			column_dict.get_or_add(str(entry.get_value()), []).append(entry)
	
	var column_total = 0
	for entry in column_dict:
		if column_dict[entry].size() > 0:
			var sum_values: int = 0
			for die in column_dict[entry]:
				sum_values += die.get_value() + die.quality
				if die.get_type() == Die.DieType.HOLLOW and _board_dict.get("empty") != null:
					sum_values += _board_dict["empty"].size()
				elif die.get_type() == Die.DieType.PLASMA:
					sum_values += _get_row_matches(die.y, die.get_value())
			column_total += sum_values * column_dict[entry].size()
	return column_total

func _get_row_matches(row: int, face: int) -> int:
	var matches: int = -1 # there will always be 1 match: the plasma die
	for i in range(0, WIDTH):
		if _board_array[i][row] != null and _board_array[i][row].get_value() == face:
			matches += 1
	return matches

func destroy_die(x: int, y: int) -> Die:
	var destroyed = _board_array[x][y]
	for i in range(y, HEIGHT - 1):
		_board_array[x][i] = _board_array[x][i + 1] # falling blocks
		_board_array[x][i].y = i
	return destroyed
	
func attack_column(col: int, die: Die) -> Array[Die]:
	var destroyed: Array[Die] = []
	
	for i in range(0, _board_array[col].size()):
		var target_die = _board_array[col][i]
		if target_die != null and target_die.get_value() == die.get_value():
			destroyed.append(target_die)
			_board_array[col][i] = null
	
	if destroyed.size() > 0:
		for i in range(0, HEIGHT - 1):
			if _board_array[col][i] == null:
				var j: int = i + 1
				while (j < (HEIGHT - 1) and _board_array[col][j] == null):
					j += 1
				if _board_array[col][j] == null:
					break
				else:
					_board_array[col][i] = _board_array[col][j]
	return destroyed

func clear_column(column: int) -> void:
	for i in range(0, HEIGHT):
		_board_array[column][i] = null

func clear_board() -> Array[Die]:
	var dice_array: Array[Die]
	for arr in _board_array:
		for item in arr:
			if (item != null):
				dice_array.append(item)
				item = null
	return dice_array

func get_dice_on_board() -> Array[Die]:
	var dice_array: Array[Die]
	for arr in _board_array:
		for item in arr:
			if (item != null):
				dice_array.append(item)
	return dice_array

func get_board_values() -> Array[Array]:
	return _board_array

func get_value_at(x: int, y: int) -> int:
	if (_board_array[x][y] != null):
		return _board_array[x][y].get_value()
	else:
		return -1

# function to return a dict of dice faces and their counts
func fill_dict() -> void:
	_board_dict = {} # string = die face, int = matching count
	for arr in _board_array:
		for die in arr:
			if die != null:
				_board_dict.get_or_add(str(die.get_value()), []).append(die)
			else: # for empty spaces, track in empty code
				_board_dict.get_or_add("empty", []).append(die)

func get_column_dict(column: int) -> Dictionary[String, int]:
	var column_dict: Dictionary[String, int] = {} # string = die face, int = matching count
	for entry in _board_array[column]:
		if entry != null:
			if (column_dict.get(str(entry.get_value())) == null):
				column_dict.get_or_add(str(entry.get_value()), 1)
			else:
				column_dict[str(entry.get_value())] += 1
			
	return column_dict
