extends CheckButton

func _ready() -> void:
	visible = OS.is_debug_build()
	pressed.connect(func(): PlayerInventory.save_to_disk = button_pressed)
	if OS.is_debug_build():
		button_pressed = false
		PlayerInventory.save_to_disk = false
	else:
		PlayerInventory.save_to_disk = true
