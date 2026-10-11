class_name GameManager extends Node

signal earned_money(int)

@export var player_score: Label
@export var CPU_score: Label

@export var player_dice_roll: Label
@export var CPU_dice_roll: Label

@export var b: BoardSignalManager

@onready var player: Board = Board.new()
@onready var cpu: Board = Board.new()

@onready var player_dice: DiceBag
@onready var cpu_dice: DiceBag

var turn_in_progress: bool = false
var turn: int = 0 # 0 = nobody, 1 = player, 2 = cpu

func _process(delta: float) -> void:
	if not turn_in_progress and turn == 0:
		turn = 1
		turn_in_progress = true
		player_turn()
	elif not turn_in_progress and turn == 1:
		turn = 2
		turn_in_progress = true
		cpu_turn()

func cpu_turn() -> void:
	
	turn = 0
	turn_in_progress = false
	
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
