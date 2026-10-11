class_name GameDisplay extends Node3D

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
	game_manager.turn_in_progress = false
	print("turn finished")

func cpu_take_turn() -> void:
	game.take_cpu_turn()
	await game.turn_finished
	game_manager.turn_in_progress = false
	print("cpu finished")
