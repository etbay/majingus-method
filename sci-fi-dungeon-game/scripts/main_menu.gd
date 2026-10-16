class_name MainMenu extends Control

@export var save_data_override: SaveDataResource
@onready var start_button: Button = $StartButton

func _ready() -> void:
	start_button.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/environment.tscn"))
	_load_saved_data()

func _load_saved_data() -> void:
	if save_data_override != null and OS.is_debug_build():
		# Pushes error if the number of die is not 12 or if any die are null
		if save_data_override.dice_bag.get_absolute_dice_array().size() == 12 and not save_data_override.dice_bag.get_absolute_dice_array().has(null):
			PlayerInventory.load_inventory(save_data_override)
		else:
			push_error("Save data override property dice_bag does not contain the correct number of die (12)")
	else:
		PlayerInventory.load_inventory()
