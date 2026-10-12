class_name DiceBag extends Node

var _dice_array: Array[Die] = []# Contains the current list of dice
var _total_dice_array: Array[Die] = []# Contains the absolute list of dice

func _init() -> void:
	for i in range(0, 12):
		_dice_array.append(Die.new(0))
		_total_dice_array.append(Die.new(0))

func get_die() -> Die:
	shuffle()
	var die = _dice_array.pop_front()
	return die

func return_dice(die: Die) -> void:
	_dice_array.append(die) 

func get_absolute_dice_array() -> Array[Die]:
	return _total_dice_array

func set_absolute_dice_array(arr: Array[Die]) -> void:
	_total_dice_array = arr
	_refresh_dice()

func shuffle() -> void:
	_dice_array.shuffle()

func set_die(index: int, die: Die) -> void:
	_total_dice_array[index] = die

# function to update the current dice list with the absolute dice list
func _refresh_dice() -> void:
	_dice_array.assign(_total_dice_array)
