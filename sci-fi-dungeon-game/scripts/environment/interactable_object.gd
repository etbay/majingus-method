class_name InteractableObject extends Sprite3D

signal item_clicked

@export var hover_highlight: Color 
@export var required_tool_type: InventoryTool.ToolType
@export var highlight_target: Sprite3D
@export var this_one_is_the_shop: bool = false

@onready var click_area: Area3D = $Area3D

var _mouse_over: bool = false

func _process(_delta: float) -> void:
	if _mouse_over and Input.is_action_just_pressed("environment_interact"):
		if this_one_is_the_shop:
			GlobalSignals.switch_to_shop.emit()
		item_clicked.emit()

func _ready() -> void:
	click_area.mouse_entered.connect(_on_mouse_entered)
	click_area.mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	_mouse_over = true
	# Set highlight color
	highlight_target.modulate = hover_highlight

func _on_mouse_exited() -> void:
	_mouse_over = false
	# Reset highlight on mouse exit
	highlight_target.modulate = Color.WHITE
