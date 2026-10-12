class_name GameDisplay extends Node3D

signal game_over(player_score: int, cpu_score: int)
signal game_started

@onready var game_manager: GameManager = $GameManager
@onready var game: GameInterface = $PlayerGameboard
@onready var start_button_detect: MouseClickDetect = $RightButton/MouseClickDetect

func _ready() -> void:
	start_button_detect.mouse_clicked.connect(start_game)
	game_over.connect(_on_game_over)

func start_game() -> void:
	if game._current_status == game.TurnStatus.NONE:
		game_manager.start_game()
		game_started.emit()

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
	game._current_status = game.TurnStatus.NONE
	game.cleanup_dice()
	print("Game Over")
	game_over.emit(game.board.calculate_score(), game.cpu_board.calculate_score()) # left = players score, right = cpu's
	pass
	# all necessary game over / cleanup steps

func _on_game_over(player_score: int, cpu_score: int) -> void:
	if player_score >= cpu_score:
		PlayerInventory.balance += 5
	PlayerInventory.balance += game.board.calculate_gilded()

func reset_board() -> void:
	game.reset_board()
