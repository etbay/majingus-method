class_name InventorySlot extends Node3D

signal slot_selected(InventorySlot)

const DICE_INVENTORY_UNSELECTED = preload("uid://ogcdvy05vtha")
const DICE_INVENTORY_SELECTED = preload("uid://cil1f84ato5ue")

@onready var quality_label: Label3D = $PanelSprite/QualityLabel
@onready var mouse_detect: MouseClickDetect = $Area3D
@onready var slot_sprite: Sprite3D = $PanelSprite
@onready var die_type_sprite: Sprite3D = $PanelSprite/DieTypeSprite

var selected: bool = false
var die: Die = null

func _ready() -> void:
	mouse_detect.mouse_entered.connect(func(): slot_sprite.texture = DICE_INVENTORY_SELECTED)
	mouse_detect.mouse_exited.connect(func(): 
		if not selected:
			slot_sprite.texture = DICE_INVENTORY_UNSELECTED
	)
	mouse_detect.mouse_clicked.connect(func(): 
		if selected:
			deselect()
		else:
			select()
		slot_selected.emit(self)
	)

func set_die(new_die: Die) -> void:
	die = new_die
	die_type_sprite.texture = TextureDictionary.die_type_dict[die.get_type()]
	if die.quality == 0:
		quality_label.text = ""
	else:
		quality_label.text = "+%d" % die.quality

func select() -> void:
	slot_sprite.texture = DICE_INVENTORY_SELECTED
	selected = true

func deselect() -> void:
	slot_sprite.texture = DICE_INVENTORY_UNSELECTED
	selected = false
