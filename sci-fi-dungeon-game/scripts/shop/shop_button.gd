class_name ShopButton extends Node3D

signal pressed

@export var top_button: bool = false

@onready var button_sprite: Sprite3D = $ButtonSprite
@onready var mouse_detect: MouseClickDetect = $Area3D

func _ready() -> void:
	if top_button:
		button_sprite.texture = TextureDictionary.SHOP_BUTTONS_1_UNSELECTED
	mouse_detect.mouse_entered.connect(func(): 
		if top_button:
			button_sprite.texture = TextureDictionary.SHOP_BUTTONS_1_SELECTED
		else:
			button_sprite.texture = TextureDictionary.SHOP_BUTTONS_2_SELECTED
	)
	mouse_detect.mouse_exited.connect(func(): 
		if top_button:
			button_sprite.texture = TextureDictionary.SHOP_BUTTONS_1_UNSELECTED
		else:
			button_sprite.texture = TextureDictionary.SHOP_BUTTONS_2_UNSELECTED
	)
	mouse_detect.mouse_clicked.connect(func(): 
		pressed.emit()
	)
