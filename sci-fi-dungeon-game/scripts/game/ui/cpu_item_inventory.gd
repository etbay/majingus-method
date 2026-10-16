extends Node3D

@onready var shiv3: Sprite3D = $Sprite3D3
@onready var shiv2: Sprite3D = $Sprite3D2
@onready var shiv1: Sprite3D = $Sprite3D
@onready var laser: Sprite3D = $Sprite3D4
@onready var interface: GameInterface = $"../../PlayerGameboard"

func _ready() -> void:
	interface.cpu_used_shiv.connect(_on_change)
	interface.cpu_used_laser.connect(_on_laser_change)

func _on_change(_count: int) -> void:
	#print("Received Signal")
	shiv1.visible = _count >= 1
	shiv2.visible = _count >= 2
	shiv3.visible = _count >= 3

func _on_laser_change(has_laser: bool):
	#print("Received Laser")
	laser.visible = has_laser
