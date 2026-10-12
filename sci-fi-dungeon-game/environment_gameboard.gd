class_name EnvironmentGameboard extends Node3D

@onready var mouse_detect: MouseClickDetect = $Area3D
@onready var highlight_outline: MeshInstance3D = $MeshInstance3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	highlight_outline.visible = false
	mouse_detect.mouse_clicked.connect(func(): GlobalSignals.switch_to_game.emit())

func _process(_delta: float) -> void:
	if mouse_detect.mouse_hovered and not highlight_outline.visible:
		highlight_outline.visible = true
	elif not mouse_detect.mouse_hovered and highlight_outline.visible:
		highlight_outline.visible = false
