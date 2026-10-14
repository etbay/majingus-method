class_name CenterConsole extends Node3D

@export var player_gameboard: GameInterface
@onready var status_icon: Sprite3D = $StatusIcon
@onready var status_label: Label3D = $StatusLabel
@onready var game_display: GameDisplay = $".."

func _ready() -> void:
	status_icon.visible = false
	status_label.visible = false
	player_gameboard.status_changed.connect(_on_status_changed)
	game_display.game_over.connect(_game_over)

func _on_status_changed(status: GameInterface.TurnStatus) -> void:
	if status != GameInterface.TurnStatus.NONE:
		status_icon.visible = true
		status_label.visible = true
	if status == GameInterface.TurnStatus.ROLLING:
		status_icon.texture = TextureDictionary.rolling_status_icon
		status_label.text = "Rolling"
	elif status == GameInterface.TurnStatus.SELECTING:
		status_icon.texture = TextureDictionary.selecting_status_icon
		status_label.text = "Selecting"
	elif status == GameInterface.TurnStatus.USING_ITEM:
		status_icon.texture = TextureDictionary.shiv_icon
		status_label.text = "Using Shiv"
	elif status == GameInterface.TurnStatus.USING_LASER:
		status_icon.texture = TextureDictionary.plasmagun_icon
		status_label.text = "Using Laser"
	elif status == GameInterface.TurnStatus.WAITING_FOR_TURN:
		status_icon.texture = TextureDictionary.COLUMN_SELECT_ICON
		status_label.text = "Waiting for CPU"

func _game_over(player_score: int, cpu_score: int) -> void:
	status_icon.visible = true
	status_label.visible = true
	if player_score >= cpu_score:
		status_label.text = "YOU WON"
	else:
		status_label.text = "YOU LOST"

func center_console_off() -> void:
	status_icon.visible = false
	status_label.visible = false
