extends Node3D

@onready var gun: Sprite3D = $Sprite3D

func _ready() -> void:
	_on_change()

func _on_change() -> void:
	gun.visible = false
