class_name GameDisplay extends Node3D

@onready var game_manager: GameManager = $GameManager
@onready var player_board: GameInterface = $PlayerGameboard



func start_game() -> void:
	game_manager.start_game()

func player_take_turn() -> void:
	player_board.take_turn()
	await player_board.turn_finished
	game_manager.turn_in_progress = false
	print("turn finished")
