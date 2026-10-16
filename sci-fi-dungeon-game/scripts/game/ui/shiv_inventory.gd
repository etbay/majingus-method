extends Node3D

@onready var shiv1: Sprite3D = $Sprite3D3
@onready var shiv2: Sprite3D = $Sprite3D2
@onready var shiv3: Sprite3D = $Sprite3D

func _ready() -> void:
	_on_change(PlayerInventory.shivs)
	PlayerInventory.shiv_count_changed.connect(_on_change)

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
