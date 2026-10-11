class_name GameSystem extends Node

@export var manager: GameManager

var player_money: int = 0

func _ready() -> void:
	manager.earned_money.connect(_on_earned_money)

func _on_earned_money(money: int) -> void:
	player_money += money
