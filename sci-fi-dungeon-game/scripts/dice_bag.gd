class_name DiceBag extends Node

var _dice_array: Array[Die] # Contains the current list of dice
var _total_dice_array: Array[Die] # Contains the absolute list of dice

func _ready() -> void:
	_dice_array.resize(12)
	_dice_array.fill(Die.new(0))
	_total_dice_array.resize(12)
	_total_dice_array.fill(Die.new(0))

func get_dice() -> Die:
	shuffle()
	var die = _dice_array.pop_front()
	return die

func return_dice(die: Die) -> void:
	_dice_array.append(die)

func get_absolute_dice_array() -> Array[Die]:
	_total_dice_array.sort()
	return _total_dice_array

func shuffle() -> void:
	_dice_array.shuffle()

# function to update the current dice list with the absolute dice list
func _refresh_dice() -> void:
	_dice_array = _total_dice_array
