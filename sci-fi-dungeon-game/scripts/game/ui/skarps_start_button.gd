class_name StartButton extends Node3D

signal pressed

@onready var click_area: MouseClickDetect = $MouseClickDetect
@onready var label_3d: Label3D = $Label3D
@onready var game_display: GameDisplay = $"../.."

var _mouse_over: bool = false
var enabled: bool = true:
	set(boolean):
		if boolean:
			label_3d.visible = true
			click_area.visible = true
		else:
			label_3d.visible = false
			click_area.visible = false

func _ready() -> void:
	click_area.mouse_entered.connect(_on_mouse_entered)
	click_area.mouse_exited.connect(_on_mouse_exited)
	game_display.game_started.connect(func(): 
		enabled = false
		label_3d.modulate = Color.from_rgba8(196, 32, 33, 255))
	game_display.game_over.connect(func(_player_score: int, _cpu_score: int): enabled = false)

func _process(_delta: float) -> void:
	if enabled and _mouse_over and Input.is_action_just_pressed("skarps_interact"):
		pressed.emit()

func _on_mouse_entered() -> void:
	if enabled:
		_mouse_over = true
		label_3d.modulate = Color.GOLDENROD

func _on_mouse_exited() -> void:
	if enabled:
		_mouse_over = false
		label_3d.modulate = Color.from_rgba8(196, 32, 33, 255)
