class_name GameInterface extends Node

signal turn_finished
signal die_rolled(int)
signal status_changed(new_status: TurnStatus)

@export var physics_die: PhysicsDie
@onready var board_display: BoardDisplay = $Board
@onready var player_score_label: Label3D = $"../RightConsole/Score/ScoreNumberLabel"

var board := Board.new()
var player_score: int = -1:
	set(value):
		if player_score != value:
			player_score = value
			player_score_label.text = "%d" % player_score

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
	start_game()

func start_game() -> void:
	player_score = 0

func take_turn() -> void:
	var die_value: int = await roll_die()
	physics_die.can_roll = false
	die_rolled.emit(die_value)
	print("die has been rolled")
	await select_column()

# Select column (player or enemy)
func select_column() -> void:
	_current_status = TurnStatus.SELECTING
	await board_display.column_selected
	turn_finished.emit()

# Use item(item type)

# Roll die
func roll_die() -> int:
	_current_status = TurnStatus.ROLLING
	physics_die.can_roll = true
	return await physics_die.roll()

func _on_column_selected(column: int, die: Die) -> void:
	board.place_dice(column, die)
	player_score = board.calculate_score()
