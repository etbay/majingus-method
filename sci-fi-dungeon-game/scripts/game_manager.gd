class_name GameManager extends Node

@export var player_score: Label
@export var CPU_score: Label

@export var player_dice_roll: Label
@export var CPU_dice_roll: Label

@export var b: BoardSignalManager

@onready var player: Board = Board.new()
@onready var cpu: Board = Board.new()

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
	var die := Die.new(0)
	await(b.roll_die)
	die.roll_die()
	# tell the player their roll
	player_dice_roll.text = "Dice Roll: " + str(die.get_value())
	
	# await input for which column they place the die on the board
	var placed: bool = false
	while (!placed):
		var res = await b.coord_selected
		placed = player.place_dice(res, die)
	
	# display score
	b.display_score(player)
	turn_in_progress = false # end turn
#
#func _on_coord_selected(coords: Array) -> void:
	#pass
