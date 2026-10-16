extends Node3D

@onready var shiv3: Sprite3D = $Sprite3D3
@onready var shiv2: Sprite3D = $Sprite3D2
@onready var shiv1: Sprite3D = $Sprite3D
@onready var laser: Sprite3D = $Sprite3D4
@onready var interface: GameInterface = $"../../PlayerGameboard"

func _ready() -> void:
	_on_change(interface.cpu_ai.shivs)
	_on_change(interface.cpu_ai.has_laser)
	interface.cpu_used_shiv.connect(_on_change)
	interface.cpu_used_laser.connect(_on_laser_change)

func _on_change(_count: int) -> void:
	shiv1.texture = TextureDictionary.SHIV_STATUS_ICON_WHITE
	shiv1.modulate = Color.DIM_GRAY
	shiv2.texture = TextureDictionary.SHIV_STATUS_ICON_WHITE
	shiv2.modulate = Color.DIM_GRAY
	shiv3.texture = TextureDictionary.SHIV_STATUS_ICON_WHITE
	shiv3.modulate = Color.DIM_GRAY
	
	if _count >= 1:
		shiv1.texture = TextureDictionary.SHIV_STATUS_ICON_RED
		shiv1.modulate = Color.WHITE
	if _count >= 2:
		shiv2.texture = TextureDictionary.SHIV_STATUS_ICON_RED
		shiv2.modulate = Color.WHITE
	if _count >= 3:
		shiv3.texture = TextureDictionary.SHIV_STATUS_ICON_RED
		shiv3.modulate = Color.WHITE

func _on_laser_change(has_laser: bool):
	if has_laser:
		laser.texture = TextureDictionary.PLASMAGUN_STATUS_ICON_RED
		laser.modulate = Color.WHITE
	else:
		laser.texture = TextureDictionary.PLASMAGUN_STATUS_ICON_WHITE
		laser.modulate = Color.DIM_GRAY
