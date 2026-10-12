class_name PhysicsDie extends RigidBody3D

signal die_clicked
signal roll_started
signal face_up_changed(int)
signal roll_finished

@export var reset_location: Node3D

@onready var raycast_1: RayCast3D = $RayCast_1
@onready var raycast_2: RayCast3D = $RayCast_2
@onready var raycast_3: RayCast3D = $RayCast_3
@onready var raycast_4: RayCast3D = $RayCast_4
@onready var raycast_5: RayCast3D = $RayCast_5
@onready var raycast_6: RayCast3D = $RayCast_6
@onready var mouse_detect: MouseClickDetect = $MouseDetect
@export var mesh: MeshInstance3D

var can_roll: bool = false:
	set(value):
		if can_roll != value:
			can_roll = value
			# Hide or show icon

var face_up: int = 0:
	set(value):
		if face_up != value:
			face_up = value
			face_up_changed.emit(face_up)

var _rolling: bool = false:
	set(value):
		if _rolling != value:
			_rolling = value
			if _rolling == false:
				roll_finished.emit()

var _move_timer: Timer = Timer.new()

func _ready() -> void:
	_move_timer.one_shot = true
	add_child(_move_timer)
	mouse_detect.mouse_clicked.connect(func(): die_clicked.emit())

func _process(_delta: float) -> void:
	if raycast_1.get_collider() is DieFaceDetect:
		face_up = 1
	elif raycast_2.get_collider() is DieFaceDetect:
		face_up = 2
	elif raycast_3.get_collider() is DieFaceDetect:
		face_up = 3
	elif raycast_4.get_collider() is DieFaceDetect:
		face_up = 4
	elif raycast_5.get_collider() is DieFaceDetect:
		face_up = 5
	elif raycast_6.get_collider() is DieFaceDetect:
		face_up = 6
	
	if _rolling and _move_timer.is_stopped():
		_rolling = false
	
	if linear_velocity != Vector3.ZERO and angular_velocity != Vector3.ZERO:
		_move_timer.start(0.05)

func roll() -> int:
	await die_clicked
	can_roll = false
	roll_started.emit()
	_move_timer.start(0.05)
	_rolling = true
	_apply_random_force()
	await get_tree().create_timer(0.2).timeout
	_apply_random_force()
	await get_tree().create_timer(0.2).timeout
	_apply_random_force()
	await roll_finished
	global_position = reset_location.global_position
	rotation.y = 0
	return face_up

func force_roll():
	can_roll = false
	roll_started.emit()
	_move_timer.start(0.05)
	_rolling = true
	_apply_random_force()
	await get_tree().create_timer(0.2).timeout
	_apply_random_force()
	await get_tree().create_timer(0.2).timeout
	_apply_random_force()
	await roll_finished
	global_position = reset_location.global_position
	rotation.y = 0
	return face_up

func _apply_random_force() -> void:
	var x_force: float = randf_range(0, 5)
	var z_force: float = randf_range(0, 5)
	var x_offset: float = randf_range(-0.1, 0.1)
	var z_offset: float = randf_range(-0.1, 0.1)
	apply_force(Vector3(x_force, 15, z_force), Vector3(x_offset, -0.1, z_offset))
	var x_rotation: float = randf_range(0, 360)
	var z_rotation: float = randf_range(0, 360)
	apply_torque(Vector3(x_rotation, 0, z_rotation))

func match_current_die(die: Die) -> void:
	var mat = StandardMaterial3D.new()
	mat.albedo_color = TextureDictionary.type_color_dict[die.get_type()]
	mat.emission_enabled = true
	mat.emission = mat.albedo_color
	mat.emission_intensity = 1.0
	mesh.set_surface_override_material(0, mat)
