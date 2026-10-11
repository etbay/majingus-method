class_name EnvironmentManager extends Node3D

@onready var env_camera: Camera3D = $EnvironmentCamera
@onready var game_camera: Camera3D = $Skarps/GameCamera
@onready var fade_overlay: ColorRect = $CanvasLayer/ColorRect
@onready var environment_gameboard: EnvironmentGameboard = $Environment/EnvironmentGameboard


@export var current_camera: Camera3D

var fading_black: bool = false
var fading_in: bool = false

func _ready() -> void:
	current_camera.current = true
	environment_gameboard.gameboard_clicked.connect(switch_camera)

func switch_camera() -> void:
	fading_black = true
	fade_overlay.visible = true
	var tween := create_tween()
	tween.tween_property(fade_overlay, "color:a", 1.0, 0.5)
	await tween.finished
	
	current_camera.current = false
	if current_camera == env_camera:
		current_camera = game_camera
	else:
		current_camera = env_camera
	current_camera.current = true
	
	tween = create_tween()
	tween.tween_property(fade_overlay, "color:a", 0.0, 0.5)
	await tween.finished
	fade_overlay.visible = false
