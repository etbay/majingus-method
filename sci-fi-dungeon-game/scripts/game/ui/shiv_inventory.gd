extends Node3D

@onready var shiv1: Sprite3D = $Sprite3D3
@onready var shiv2: Sprite3D = $Sprite3D2
@onready var shiv3: Sprite3D = $Sprite3D

func _ready() -> void:
	_on_change(1)
	PlayerInventory.shiv_count_changed.connect(_on_change)

func _on_change(_count: int) -> void:
	shiv1.visible = PlayerInventory.shivs >= 1
	shiv2.visible = PlayerInventory.shivs >= 2
	shiv3.visible = PlayerInventory.shivs >= 3
