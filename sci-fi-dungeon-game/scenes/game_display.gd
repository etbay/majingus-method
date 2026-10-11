class_name GameDisplay extends Node3D

@onready var game_manager: GameManager = $GameManager
@onready var player_board: GameInterface = $PlayerGameboard



func start_game() -> void:
	game_manager.start_game()

func take_turn() -> void:
	player_board.take_turn()
	await player_board.turn_finished
