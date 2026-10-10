class_name GameManager extends Node

var player: Board
var cpu: Board

@export var player_score: Label
@export var CPU_score: Label

@export var player_dice_roll: Label
@export var CPU_dice_roll: Label

@export var b: BoardSignalManager

var turn_in_progress: bool = false

func _ready() -> void:
	pass
	#b.coord_selected.connect(_on_coord_selected)

func _process(delta: float) -> void:
	if not turn_in_progress:
		player_turn()
		turn_in_progress = true

func cpu_turn() -> void:
	pass
	
func player_turn() -> void:
	var die := Die.new()
	die.roll_die()
	# tell the player their roll
	player_dice_roll.text = str(die.get_value())
	
	# await input for which column they place the die on the board
	var res = await b.coord_selected
	
	
	# display score
#
#func _on_coord_selected(coords: Array) -> void:
	#pass
