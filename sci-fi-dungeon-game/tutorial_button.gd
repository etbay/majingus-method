extends Button

@onready var color_rect_2: ColorRect = $"../ColorRect2"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(func(): color_rect_2.visible = not color_rect_2.visible)
