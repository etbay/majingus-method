extends Node

signal balance_changed(int)

var dice_bag: DiceBag

var shivs: int = 0
var has_laser_gun: bool = false

var balance: int = 100:
	set(value):
		if balance != value:
			balance = value
			balance_changed.emit(balance)

var has_file: bool = false
var has_wrench: bool = false
var has_screwdriver: bool = false

func _ready() -> void:
	dice_bag = DiceBag.new()

func get_dice_inventory() -> Array[Die]:
	return dice_bag.get_absolute_dice_array()

func add_next_tool() -> void:
	if not has_file:
		has_file = true
		return
	elif not has_wrench:
		has_wrench = true
		return
	elif not has_screwdriver:
		has_screwdriver = true
		return
