class_name PanCamera extends Camera3D

## Percentage of screen entered that causes the player to pan left or right
@export var turn_threshold: float = 10

## The speed of the camera pan
@export var turn_speed: float = 5

signal hit_trigger(dir: PoolTrigger.TriggerDirection)

@onready var area_trigger: PanCameraArea = $PanCameraArea
@onready var _screen_width: float = get_tree().root.content_scale_size.x

var enabled: bool = true

var _mouse_pos_x: float 
var pan_enabled: bool = true
var panning: bool = false

func _ready() -> void:
	_mouse_pos_x = _screen_width / 2
	area_trigger.hit_trigger.connect(func(dir: PoolTrigger.TriggerDirection): hit_trigger.emit(dir))

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pan_enabled = not pan_enabled
	
	if pan_enabled and within_right_percent_of_screen(_mouse_pos_x):
		position.x += turn_speed * delta
		panning = true
	elif pan_enabled and within_left_percent_of_screen(_mouse_pos_x):
		position.x -= turn_speed * delta
		panning = true
	else:
		panning = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_mouse_pos_x = event.global_position.x

## Returns true if the input mouse positin is within turn_threshold % of the 
## right side of the screen
func within_right_percent_of_screen(mouse_pos: float) -> bool:
	return mouse_pos >= (_screen_width - _screen_width * (turn_threshold / 100))

## Returns true if the input mouse positin is within turn_threshold % of the 
## right left of the screen
func within_left_percent_of_screen(mouse_pos: float) -> bool:
	return mouse_pos <= _screen_width * (turn_threshold / 100)
