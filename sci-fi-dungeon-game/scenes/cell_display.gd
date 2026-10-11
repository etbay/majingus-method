class_name CellDisplay extends Area3D

@onready var die_cell: Sprite3D = $DieCell
var value: int = 0

func set_value(val: int) -> void:
	value = val
	die_cell.texture = TextureDictionary.die_val_dict[val]
