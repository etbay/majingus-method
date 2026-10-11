extends Node3D

@export var player_gameboard: GameInterface
@onready var status_icon: Sprite3D = $StatusIcon
@onready var status_label: Label3D = $StatusLabel

func _ready() -> void:
	player_gameboard.status_changed.connect(_on_status_changed)

func _on_status_changed(status: GameInterface.TurnStatus) -> void:
	if status == GameInterface.TurnStatus.ROLLING:
		status_icon.texture = TextureDictionary.rolling_status_icon
		status_label.text = "Rolling"
	elif status == GameInterface.TurnStatus.SELECTING:
		status_icon.texture = TextureDictionary.selecting_status_icon
		status_label.text = "Selecting"
