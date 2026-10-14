extends Node3D

@onready var gun: Sprite3D = $Sprite3D

func _ready() -> void:
	PlayerInventory.laser_changed.connect(_on_change)
	_on_change()

func _on_change() -> void:
	if PlayerInventory.has_laser_gun:
		gun.visible = true
	else:
		gun.visible = false
