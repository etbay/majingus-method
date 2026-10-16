extends Node

@export var background_image: CompressedTexture2D
@export var environment_spawn: Node3D
@export var active_environment: Node3D
@export var pan_camera: PanCamera

var texture_width: float
var world_width: float
var _instance_left: Node3D
var _instance_right: Node3D
var _between_repeats: bool = false

func _ready() -> void:
	texture_width = background_image.get_width()
	world_width = texture_width * 0.01
	pan_camera.hit_trigger.connect(_on_camera_hit_trigger)

func _on_camera_hit_trigger(dir: PoolTrigger.TriggerDirection) -> void:
	if not _between_repeats:
		if dir == PoolTrigger.TriggerDirection.LEFT:
			_create_instance_left()
		else:
			_create_instance_right()
		_between_repeats = true
	else:
		if dir == PoolTrigger.TriggerDirection.LEFT:
			_delete_instance_left()
		else:
			_delete_instance_right()
		_between_repeats = false

func _create_instance_left() -> void:
	var new_environment: Node3D = active_environment.duplicate()
	new_environment.position.x -= world_width
	environment_spawn.add_child(new_environment)
	_instance_right = active_environment
	_instance_left = new_environment
	active_environment = _instance_left

func _create_instance_right() -> void:
	var new_environment: Node3D = active_environment.duplicate()
	new_environment.position.x += world_width
	environment_spawn.add_child(new_environment)
	_instance_left = active_environment
	_instance_right = new_environment
	active_environment = _instance_right

func _delete_instance_right() -> void:
	_instance_right.queue_free()
	_instance_right = null
	active_environment = _instance_left

func _delete_instance_left() -> void:
	_instance_left.queue_free()
	_instance_left = null
	active_environment = _instance_right
