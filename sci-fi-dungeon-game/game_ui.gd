class_name GameUI extends CanvasLayer

@onready var left_arrow: TextureRect = $LeftArrow
@onready var right_arrow: TextureRect = $RightArrow
@onready var environment_camera: PanCamera = $"../EnvironmentCamera"
@onready var down_arrow: MouseClickDetectUI = $DownArrow

func switch_to_shop() -> void:
	left_arrow.visible = false
	right_arrow.visible = false
	environment_camera.enabled = false
	down_arrow.visible = true

func switch_to_game() -> void:
	left_arrow.visible = false
	right_arrow.visible = false
	environment_camera.enabled = false
	down_arrow.visible = true

func switch_to_environment() -> void:
	left_arrow.visible = true
	right_arrow.visible = true
	environment_camera.enabled = true
	down_arrow.visible = false
