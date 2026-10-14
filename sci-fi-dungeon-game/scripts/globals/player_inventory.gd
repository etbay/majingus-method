extends Node

signal balance_changed(int)
signal shiv_count_changed(int)
signal laser_changed

var dice_bag: DiceBag

var shivs: int = 3:
	set(value):
		if shivs != value:
			shivs = value
			shiv_count_changed.emit(shivs)

var has_laser_gun: bool = true:
	set(boolean):
		if has_laser_gun != boolean:
			has_laser_gun = boolean
			laser_changed.emit()

var balance: int = 0:
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
	if not has_wrench:
		has_wrench = true
		return
	elif not has_screwdriver:
		has_screwdriver = true
		return

func set_die(index: int, die: Die) -> void:
	dice_bag.set_die(index, die)
	for d: Die in dice_bag.get_absolute_dice_array():
		print(d.get_type())
