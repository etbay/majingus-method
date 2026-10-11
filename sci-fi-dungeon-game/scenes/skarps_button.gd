extends Node3D

@onready var click_area: Area3D = $Area3D

var _mouse_over: bool = false

func _ready() -> void:
	click_area.mouse_entered.connect(_on_mouse_entered)
	click_area.mouse_exited.connect(_on_mouse_exited)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("skarps_interact"):
		pass

func _on_mouse_entered() -> void:
	_mouse_over = true

func _on_mouse_exited() -> void:
	_mouse_over = false
