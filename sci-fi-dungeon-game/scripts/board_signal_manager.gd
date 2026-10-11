class_name BoardSignalManager extends Node

signal coord_selected(int)
signal roll_die()

@export var roll_button: Button
@export var roll_label: Label

@export var button_00: Button
@export var button_10: Button
@export var button_20: Button
@export var button_30: Button

@export var button_01: Button
@export var button_11: Button
@export var button_21: Button
@export var button_31: Button

@export var button_02: Button
@export var button_12: Button
@export var button_22: Button
@export var button_32: Button

@export var player_score_text: Label
@export var column_1_score: Label
@export var column_2_score: Label
@export var column_3_score: Label
@export var column_4_score: Label

@onready var _button_arr: Array[Array] = [[button_00, button_01, button_02], [button_10, button_11, button_12], [button_20, button_21, button_22], [button_30, button_31, button_32]]
	
func _ready() -> void:
	button_00.pressed.connect(_on_column_1_pressed)
	button_01.pressed.connect(_on_column_1_pressed)
	button_02.pressed.connect(_on_column_1_pressed)
	button_10.pressed.connect(_on_column_2_pressed)
	button_11.pressed.connect(_on_column_2_pressed)
	button_12.pressed.connect(_on_column_2_pressed)
	button_20.pressed.connect(_on_column_3_pressed)
	button_21.pressed.connect(_on_column_3_pressed)
	button_22.pressed.connect(_on_column_3_pressed)
	button_30.pressed.connect(_on_column_4_pressed)
	button_31.pressed.connect(_on_column_4_pressed)
	button_32.pressed.connect(_on_column_4_pressed)
	if (roll_button != null):
		roll_button.pressed.connect(_on_roll_pressed)

#func _process(delta: float) -> void:
	#

func force_roll() -> void:
	emit_signal("roll_die")

func _on_column_1_pressed() -> void:
	emit_signal("coord_selected", 0)

func _on_column_2_pressed() -> void:
	emit_signal("coord_selected", 1)
	
func _on_column_3_pressed() -> void:
	emit_signal("coord_selected", 2)

func _on_column_4_pressed() -> void:
	emit_signal("coord_selected", 3)
	
func _on_roll_pressed() -> void:
	emit_signal("roll_die")

func display_roll(die: Die) -> void:
	roll_label.text = "Roll: %d" % die.get_value()

func display_score(board: Board) -> void:
	board.fill_dict()
	for i in range(0, board.WIDTH):
		for j in range(0, board.HEIGHT):
			var value = board.get_value_at(i,j)
			if value > -1:
				_button_arr[i][board.HEIGHT - 1 - j].text = str(value)
			else:
				_button_arr[i][board.HEIGHT - 1 - j].text = "-"
	player_score_text.text = str(board.calculate_score())
	column_1_score.text = str(board.calculate_column_score(0))
	column_2_score.text = str(board.calculate_column_score(1))
	column_3_score.text = str(board.calculate_column_score(2))
	column_4_score.text = str(board.calculate_column_score(3))
