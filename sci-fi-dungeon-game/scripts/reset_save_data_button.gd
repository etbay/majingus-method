extends Button

func _ready() -> void:
	visible = OS.is_debug_build()
	pressed.connect(func(): PlayerInventory.reset_save_data())
