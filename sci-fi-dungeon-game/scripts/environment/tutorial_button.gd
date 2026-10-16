extends Button

@onready var tutorial_text: ColorRect = $"../TutorialText"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(func(): tutorial_text.visible = not tutorial_text.visible)
