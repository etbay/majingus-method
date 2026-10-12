class_name EnvironmentManager extends Node3D

signal done_transitioning

@onready var env_camera: Camera3D = $EnvironmentCamera
@onready var game_camera: Camera3D = $Skarps/GameCamera
@onready var shop_camera: Camera3D = $Shop/ShopCamera
@onready var game_ui: GameUI = $CanvasLayer
@onready var exit_to_environment: MouseClickDetectUI = $CanvasLayer/DownArrow

@onready var fade_overlay: ColorRect = $CanvasLayer/ColorRect
@onready var environment_gameboard: EnvironmentGameboard = $Environment/EnvironmentGameboard
@onready var shop_interactable: InteractableObject = $Environment/Shop
@onready var skarps_board: GameDisplay = $Skarps/SkarpsBoard
@onready var shop: ShopDisplay = $Shop

@export var current_camera: Camera3D


var fading_black: bool = false
var fading_in: bool = false
var game_ended: bool = false

func _ready() -> void:
	game_ui.switch_to_environment()
	current_camera.current = true
	GlobalSignals.switch_to_shop.connect(func(): 
		switch_camera(shop_camera)
		MusicMan.play_music(AudioDictionary.music["RatTheme"])
		game_ui.switch_to_shop())
	GlobalSignals.switch_to_game.connect(func(): 
		switch_camera(game_camera)
		MusicMan.play_music(AudioDictionary.music["DiceTheme"])
		game_ui.switch_to_game())
	exit_to_environment.mouse_clicked.connect(func():
		switch_camera(env_camera)
		MusicMan.play_music(AudioDictionary.music["MainTheme"])
		game_ui.switch_to_environment()
		if game_ended:
			skarps_board.reset_board())
	skarps_board.game_started.connect(_on_game_start)
	skarps_board.game_over.connect(_on_game_over)

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
	done_transitioning.emit()
	fade_overlay.visible = false

func _on_game_start() -> void:
	exit_to_environment.visible = false

func _on_game_over(_x: int, _y: int) -> void:
	exit_to_environment.visible = true
	game_ended = true
	shop.refresh_shop()
