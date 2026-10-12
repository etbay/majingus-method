class_name ShopSlot extends Node3D

signal slot_selected(ShopSlot)

const DICE_INVENTORY_UNSELECTED = preload("uid://ogcdvy05vtha")
const DICE_INVENTORY_SELECTED = preload("uid://cil1f84ato5ue")

@onready var slot_sprite: Sprite3D = $SlotSprite
@onready var item_sprite: Sprite3D = $SlotSprite/ItemSprite
@onready var mouse_detect: MouseClickDetect = $MouseDetect
@onready var item_price: Label3D = $ItemPrice
@onready var item_label: Label3D = $ItemLabel
@onready var quality_label: Label3D = $SlotSprite/QualityLabel
	
var price: int = 0:
	set(value):
		if price != value:
			price = value
			item_price.text = "$%d" % price

var description: String = "":
	set(value):
		if description != value:
			description = value
			item_label.text = description

var selectable: bool = false
var selected: bool = false
var die: Die = null

func _ready() -> void:
	item_sprite.visible = false
	item_price.visible = false
	quality_label.visible = false
	item_label.visible = false
	
	mouse_detect.mouse_entered.connect(func(): 
		if selectable:
			slot_sprite.texture = DICE_INVENTORY_SELECTED)
	mouse_detect.mouse_exited.connect(func(): 
		if selectable and not selected:
			slot_sprite.texture = DICE_INVENTORY_UNSELECTED
	)
	mouse_detect.mouse_clicked.connect(func(): 
		if selectable:
			if selected:
				deselect()
			else:
				select()
			slot_selected.emit(self)
	)

func empty_data() -> void:
	item_price.visible = false
	item_label.visible = false
	quality_label.visible = false
	item_sprite.visible = false

func _make_data_visible() -> void:
	item_sprite.visible = true
	item_price.visible = true
	item_label.visible = true

func set_data(cost: int, desc: String, sprite: CompressedTexture2D, die_quality: int = -1) -> void:
	price = cost
	description = desc
	item_sprite.texture = sprite
	quality_label.visible = false
	selectable = true
	_make_data_visible()
	if die_quality != -1:
		quality_label.visible = true
		quality_label.text = "+%d" % die_quality

func set_die(cost: int, desc: String, new_die: Die) -> void:
	price = cost
	description = desc
	die = new_die
	item_sprite.texture = TextureDictionary.die_type_dict[die.get_type()]
	quality_label.visible = false
	selectable = true
	_make_data_visible()

func select() -> void:
	slot_sprite.texture = DICE_INVENTORY_SELECTED
	selected = true

func deselect() -> void:
	slot_sprite.texture = DICE_INVENTORY_UNSELECTED
	selected = false
