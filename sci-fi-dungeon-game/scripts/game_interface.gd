class_name GameInterface extends Node

signal turn_finished
signal die_rolled(int)

@export var physics_die: PhysicsDie
@onready var board_display: BoardDisplay = $Board

func _ready() -> void:
	pass

func take_turn() -> void:
	var die_value: int = await roll_die()
	physics_die.can_roll = false
	die_rolled.emit(die_value)
	print("die has been rolled")

# Select column (player or enemy)
func select_column() -> void:
	await board_display.column_selected
# Use item(item type)

# Roll die
func roll_die() -> int:
	physics_die.can_roll = true
	return await physics_die.roll()
