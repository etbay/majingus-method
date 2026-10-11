class_name GameInterface extends Node

signal turn_finished
signal die_rolled(Die)
signal status_changed(new_status: TurnStatus)

@export var physics_die: PhysicsDie
@onready var board_display: BoardDisplay = $Board
@onready var player_score_label: Label3D = $"../RightConsole/Score/ScoreNumberLabel"
@onready var shiv_button: MouseClickDetect = $"../LeftButton/MouseClickDetect"
@onready var laser_button: MouseClickDetect = $"../RightButton/MouseClickDetect"

@export var cpu_physics_die: PhysicsDie
@onready var cpu_board_display: BoardDisplay = $"../CPUGameboard/Board"
@onready var cpu_score_label: Label3D = $"../LeftConsole/Background/Score/ScoreNumberLabel"

@onready var board_display_wrapper: BoardSelectedWrapper = BoardSelectedWrapper.new(board_display, cpu_board_display)


var cpu_board := Board.new()
var cpu_ai := CPUAI.new() # fill with challenge level

var dice_bag := DiceBag.new()
var board := Board.new()
var player_score: int = -1:
	set(value):
		if player_score != value:
			player_score = value
			player_score_label.text = "%d" % player_score

var cpu_score: int = -1:
	set(value):
		if cpu_score != value:
			cpu_score = value
			cpu_score_label.text = "%d" % cpu_score

var shiv_count: int = 3
var laser_count: int = 1

enum TurnStatus
{
	WAITING_FOR_TURN,
	ROLLING,
	SELECTING,
	USING_ITEM
}

var _current_status := TurnStatus.WAITING_FOR_TURN:
	set(value):
		if _current_status != value:
			_current_status = value
			status_changed.emit(_current_status)

func _ready() -> void:
	board_display_wrapper.column_selected.connect(_on_column_selected)
	shiv_button.mouse_clicked.connect(_on_shiv_selected)
	laser_button.mouse_clicked.connect(_on_laser_selected)
	start_game()

func start_game() -> void:
	player_score = 0

func take_turn() -> void:
	die_rolled.emit(await roll_die())
	physics_die.can_roll = false
	print("die has been rolled")
	await select_column()

func take_cpu_turn() -> void:
	_current_status = TurnStatus.WAITING_FOR_TURN
	cpu_physics_die.can_roll = true
	var value = await cpu_physics_die.force_roll()
	var cpu_die = cpu_ai.dice_bag.get_die()
	cpu_die.set_value(value)
	var cpu_col = cpu_ai.choose_column(cpu_die, board, cpu_board)
	if (cpu_col < 4):
		# on cpu board
		cpu_board.place_dice(cpu_col, cpu_die)
		cpu_score = cpu_board.calculate_score()
		cpu_board_display.display_board(cpu_board)
	else:
		# attacking player
		board.attack_column(cpu_col - 4, cpu_die)
		player_score = board.calculate_score()
		board_display.display_board(board)


# Select column (player or enemy)
func select_column() -> void:
	_current_status = TurnStatus.SELECTING
	var res = await board_display_wrapper.column_selected
	if (res[0] < 4):
		board_display.display_board(board)
	else:
		cpu_board_display.display_board(cpu_board)
	turn_finished.emit()

# Roll die
func roll_die() -> Die:
	_current_status = TurnStatus.ROLLING
	physics_die.can_roll = true
	var value = await physics_die.roll()
	var player_die = dice_bag.get_die()
	player_die.set_value(value)
	return player_die

func _on_column_selected(column: int, die: Die) -> void:
	if (column < 4):
		#player side
		board.place_dice(column, die)
		player_score = board.calculate_score()
	else:
		#attacking
		cpu_board.attack_column(column - 4, die)
		cpu_score = cpu_board.calculate_score()

func _on_shiv_selected() -> void:
	print("shiv selected")
	if (_current_status != TurnStatus.WAITING_FOR_TURN and shiv_count > 0):
		_current_status = TurnStatus.USING_ITEM
		# spawn visual indicator / change display
		# wait for player to select enemy die

func _on_laser_selected() -> void:
	print("laser selected")
	if (_current_status != TurnStatus.WAITING_FOR_TURN and laser_count > 0):
		_current_status = TurnStatus.USING_ITEM
		# spawn visual indicator / change display
		# wait for player to select enemy row
