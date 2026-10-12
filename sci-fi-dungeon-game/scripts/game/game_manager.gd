class_name GameManager extends Node

signal earned_money(int)

@export var game_display: GameDisplay

@export var player_score: Label
@export var CPU_score: Label

var turn_in_progress: bool = false
var turn: int = 0 # 1 = player, 0 = cpu

func _ready() -> void:
	set_process(false)
	game_display.game_over.connect(end_game)

func _process(delta: float) -> void:
	if not turn_in_progress and turn == 0:
		turn = 1
		turn_in_progress = true
		game_display.player_take_turn()
	elif not turn_in_progress and turn == 1:
		turn = 0
		turn_in_progress = true
		game_display.cpu_take_turn()

func start_game() -> void:
	set_process(true)

func end_game(x: int, y: int) -> void:
	set_process(false)
	turn_in_progress = false
	turn = 0
