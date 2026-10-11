extends Area3D

var mouse_hovered: bool = false

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _process(delta: float) -> void:
	if mouse_hovered and Input.is_action_just_pressed("skarps_interact"):
		pass

func _on_mouse_entered() -> void:
	mouse_hovered = true

func _on_mouse_exited() -> void:
	mouse_hovered = false
