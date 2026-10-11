class_name GameInterface extends Node

signal turn_finished
signal die_rolled(Die)
signal status_changed(new_status: TurnStatus)

@export var physics_die: PhysicsDie
@onready var board_display: BoardDisplay = $Board
@onready var cpu_board_display: BoardDisplay = $"../CPUGameboard/Board"
@onready var player_score_label: Label3D = $"../RightConsole/Score/ScoreNumberLabel"
@onready var cpu_score_label: Label3D = $"../LeftConsole/Background/Score/ScoreNumberLabel"
@onready var shiv_button: MouseClickDetect = $"../LeftButton/MouseClickDetect"
@onready var laser_button: MouseClickDetect = $"../RightButton/MouseClickDetect"

var cpu_board := Board.new()
var cpu_ai := CPUAI.new() # fill with challenge level

var dice_bag := DiceBag.new()
var board := Board.new()
var player_score: int = -1:
	set(value):
		if player_score != value:
			player_score = value
			player_score_label.text = "%d" % player_score

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
	board_display.column_selected.connect(_on_column_selected)
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

# Select column (player or enemy)
func select_column() -> void:
	_current_status = TurnStatus.SELECTING
	await board_display.column_selected
	board_display.display_board(board)
	turn_finished.emit()

# Use item(item type)

# Roll die
func roll_die() -> Die:
	_current_status = TurnStatus.ROLLING
	physics_die.can_roll = true
	var value = await physics_die.roll()
	var player_die = dice_bag.get_die()
	player_die.set_value(value)
	return player_die

func _on_column_selected(column: int, die: Die) -> void:
	board.place_dice(column, die)
	player_score = board.calculate_score()

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
