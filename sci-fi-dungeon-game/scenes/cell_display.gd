class_name CellDisplay extends Area3D

@onready var die_cell: Sprite3D = $DieCell
@onready var collision: CollisionShape3D = $CollisionShape3D
var value: int = 0

func _ready() -> void:
	collision.disabled = true

func set_value(val: int) -> void:
	value = val
	die_cell.texture = TextureDictionary.die_val_dict[val]

func make_invisible() -> void:
	value = 0
	die_cell.texture = null
