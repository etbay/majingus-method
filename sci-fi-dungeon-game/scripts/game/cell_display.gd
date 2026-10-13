class_name CellDisplay extends MouseClickDetect

signal cell_clicked (pos: Array[int])

@onready var die_cell: Sprite3D = $DieCell
@onready var die_quality: Label3D = $DieQuality
@onready var collision: CollisionShape3D = $CollisionShape3D
var value: int = 0

@export var coords: Array[int] = []

func _ready() -> void:
	super._ready()
	die_quality.text = ""

func _process(_delta: float) -> void:
	if mouse_hovered and Input.is_action_just_pressed("skarps_interact"):
		cell_clicked.emit(coords)

func set_value(die: Die) -> void:
	value = die.get_value()
	die_cell.texture = TextureDictionary.die_val_dict[value]
	die_cell.modulate = TextureDictionary.type_color_dict[die.get_type()]
	if (die.quality > 0):
		die_quality.text = "+%s" % die.quality
	else:
		die_quality.text = ""

func make_invisible() -> void:
	value = 0
	die_cell.texture = null
	die_quality.text = ""
