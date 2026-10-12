extends Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(func(): get_tree().change_scene_to_file("res://environment.tscn"))
