extends Button

@export var game_interface: GameInterface

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	game_interface.take_turn()
