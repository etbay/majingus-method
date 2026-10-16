extends Control

@onready var tooltip_label: Label = $TooltipLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignals.open_tooltip.connect(_on_open_tooltip)
	GlobalSignals.close_tooltip.connect(_on_close_tooltip)

func _on_open_tooltip(pos: Vector2, tooltip: String) -> void:
	position = pos
	position.y += 25
	tooltip_label.text = tooltip
	visible = true

func _on_close_tooltip() -> void:
	visible = false
