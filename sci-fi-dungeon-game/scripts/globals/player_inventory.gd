extends Node

signal balance_changed(int)
signal shiv_count_changed(int)
signal laser_gun_changed(bool)
signal dice_bag_changed

var dice_bag: DiceBag

var shivs: int = 3:
	set(value):
		if shivs != value:
			shivs = value
			shiv_count_changed.emit(shivs)
			save_inventory()

var has_laser_gun: bool = false:
	set(value):
		if has_laser_gun != value:
			has_laser_gun = value
			laser_gun_changed.emit(has_laser_gun)
			save_inventory()

var balance: int = 0:
	set(value):
		if balance != value:
			balance = value
			balance_changed.emit(balance)
			save_inventory()

var has_file: bool = false
var has_wrench: bool = false
var has_screwdriver: bool = false

var save_to_disk: bool = false

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
	save_inventory()
	dice_bag_changed.emit()

func save_inventory() -> void:
	if not save_to_disk:
		return
	
	var save_data := SaveDataResource.new()
	save_data.dice_bag = dice_bag
	save_data.shiv_count = shivs
	save_data.has_laser_gun = has_laser_gun
	save_data.balance = balance
	var error: Error = ResourceSaver.save(save_data, "user://majingus_save.tres")
	if error != OK:
		push_error("Error saving resource")

func load_inventory(save_data: SaveDataResource = null) -> void:
	var loaded_save
	if save_data != null:
		loaded_save = save_data
	else:
		if not ResourceLoader.exists("user://majingus_save.tres"):
			loaded_save = SaveDataResource.new()
		else:
			loaded_save = ResourceLoader.load("user://majingus_save.tres")
	
	if loaded_save is SaveDataResource:
		dice_bag = loaded_save.dice_bag
		shivs = loaded_save.shiv_count
		has_laser_gun = loaded_save.has_laser_gun
		balance = loaded_save.balance
		dice_bag_changed.emit()

func reset_save_data() -> void:
	var save_data := SaveDataResource.new()
	var error: Error = ResourceSaver.save(save_data, "user://majingus_save.tres")
	if error != OK:
		push_error("Error resetting save data")
	load_inventory()
