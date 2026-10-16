extends Button

@onready var environment_system: EnvironmentManager = $"../.."

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	environment_system.switch_camera()
