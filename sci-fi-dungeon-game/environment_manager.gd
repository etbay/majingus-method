class_name EnvironmentManager extends Node3D

@onready var env_camera: Camera3D = $EnvironmentCamera
@onready var game_camera: Camera3D = $Skarps/GameCamera
@onready var shop_camera: Camera3D = $Shop/ShopCamera
@onready var game_ui: GameUI = $CanvasLayer
@onready var exit_to_environment: MouseClickDetectUI = $CanvasLayer/DownArrow

@onready var fade_overlay: ColorRect = $CanvasLayer/ColorRect
@onready var environment_gameboard: EnvironmentGameboard = $Environment/EnvironmentGameboard
@onready var shop_interactable: InteractableObject = $Environment/Shop

@export var current_camera: Camera3D

var fading_black: bool = false
var fading_in: bool = false

func _ready() -> void:
	game_ui.switch_to_environment()
	current_camera.current = true
	shop_interactable.item_clicked.connect(func(): 
		switch_camera(shop_camera)
		game_ui.switch_to_shop())
	environment_gameboard.gameboard_clicked.connect(func(): 
		switch_camera(game_camera)
		game_ui.switch_to_game())
	exit_to_environment.mouse_clicked.connect(func():
		switch_camera(env_camera)
		game_ui.switch_to_environment())

func switch_camera(camera: Camera3D) -> void:
	fading_black = true
	fade_overlay.visible = true
	var tween := create_tween()
	tween.tween_property(fade_overlay, "color:a", 1.0, 0.5)
	await tween.finished
	
	current_camera.current = false
	current_camera = camera
	current_camera.current = true
	
	tween = create_tween()
	tween.tween_property(fade_overlay, "color:a", 0.0, 0.5)
	await tween.finished
	fade_overlay.visible = false
