extends Button

@export var pan_camera: Camera3D
@export var skarps_camera: Camera3D
@export var pan_active: bool = false

var _current_camera: Camera3D

func _ready() -> void:
	pressed.connect(_on_pressed)
	if pan_active:
		_current_camera = pan_camera
	else:
		_current_camera = skarps_camera
	_current_camera.current = true

func _on_pressed() -> void:
	pan_active = not pan_active
	_current_camera.current = false
	if pan_active:
		_current_camera = pan_camera
	else:
		_current_camera = skarps_camera
	_current_camera.current = true
