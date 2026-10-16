class_name GameDisplay extends Node3D

signal game_over(player_score: int, cpu_score: int)
signal game_started

const FISH_HEAD = preload("uid://c7qh5olwjvibb")
const FROG_HEAD = preload("uid://l3jv3vj013f3")
const GOOP_GUY = preload("uid://bah5qpk5yk67k")
const JOHN_SPACE = preload("uid://mtff7wbo073p")
const RAT_GUY = preload("uid://c51aw8nwdyj0r")
const TRADER = preload("uid://btvwp5l2hy78j")
const VENT_FISH = preload("uid://sjav46uc51qo")

@onready var game_manager: GameManager = $GameManager
@onready var game: GameInterface = $PlayerGameboard
@onready var start_button_detect: StartButton = $CenterConsole/StartButton
@onready var character_sprite: Sprite3D = $LeftConsole/Portrait/CharacterSprite
@onready var center_console: CenterConsole = $CenterConsole
@export var door_character: Sprite3D
@export var door_character_env: Sprite3D

var cpu_characters: Array[CPUCharacter]
var current_cpu: int = 0

func _ready() -> void:
	cpu_characters.append(TRADER)		#1
	cpu_characters.append(FISH_HEAD)	#3
	cpu_characters.append(GOOP_GUY)		#5
	cpu_characters.append(RAT_GUY)		#7
	cpu_characters.append(FROG_HEAD)	#8
	cpu_characters.append(JOHN_SPACE)	#10
	cpu_characters.append(VENT_FISH)	#12
	
	current_cpu = PlayerInventory.current_cpu
	_update_cpu()
	
	start_button_detect.pressed.connect(start_game)
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
	
	# If the player wins, advance to the next cpu
	if game.board.calculate_score() >= game.cpu_board.calculate_score():
		current_cpu += 1
		if current_cpu == cpu_characters.size():
			current_cpu = 0
	# Otherwise, go back to the previous one
	else:
		current_cpu -= 1
		if current_cpu < 0:
			current_cpu = 0
	PlayerInventory.current_cpu = current_cpu
	_update_cpu()

func _update_cpu() -> void:
	game.set_cpu(cpu_characters[current_cpu])
	character_sprite.texture = cpu_characters[current_cpu].texture
	door_character.texture = cpu_characters[current_cpu].texture
	# TODO: Refactor environment pooling so this shit doesn't happen
	# This is caused by the deletion of the previous environment when a new one is spawned
	# when the camera pans too far left or right
	if is_instance_valid(door_character_env):
		door_character_env.texture = cpu_characters[current_cpu].texture

func _on_game_over(player_score: int, cpu_score: int) -> void:
	if player_score >= cpu_score:
		PlayerInventory.balance += 10 + (min(int(PlayerInventory.balance / 5), 10))
	else:
		PlayerInventory.balance /= 2
	PlayerInventory.balance += game.board.calculate_gilded()

func reset_board() -> void:
	game.reset_board()
	center_console.hide_status()
	game.player_die_details.display(Die.new(0))
	game.cpu_die_details.display(Die.new(0))
	start_button_detect.enabled = true
