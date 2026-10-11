extends Button

@export var physics_die: PhysicsDie

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	physics_die.roll()
