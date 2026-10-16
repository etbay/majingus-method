class_name PauseMenuCustom extends Control

@onready var reset_save_data_button: Button = $VBoxContainer/ResetSaveDataButton
@onready var save_to_disk_button: CheckButton = $VBoxContainer/SaveToDiskButton

func pause() -> void:
	visible = not visible
	reset_save_data_button.visible = OS.is_debug_build()
	save_to_disk_button.visible = OS.is_debug_build()
