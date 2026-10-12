class_name GameDisplay extends Node3D

signal game_over(player_score: int, cpu_score: int)

@onready var game_manager: GameManager = $GameManager
@onready var game: GameInterface = $PlayerGameboard

@export var start_button: Button

func _ready() -> void:
	start_button.pressed.connect(start_game)

func start_game() -> void:
	game_manager.start_game()

func player_take_turn() -> void:
	game.take_turn()
	await game.turn_finished
	if game.game_over_check():
		game_over_func()
	game_manager.turn_in_progress = false

func cpu_take_turn() -> void:
	game.take_cpu_turn()
	await game.turn_finished
	if game.game_over_check():
		game_over_func()
	game_manager.turn_in_progress = false

func game_over_func():
	game.cleanup_dice()
	print("Game Over")
	game_over.emit(game.board.calculate_score(), game.cpu_board.calculate_score()) # left = players score, right = cpu's
	pass
	# all necessary game over / cleanup steps
