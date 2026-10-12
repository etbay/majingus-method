class_name PhysicsDie extends RigidBody3D

signal die_clicked
signal roll_started
signal face_up_changed(int)
signal roll_finished

@export var reset_location: Node3D

@onready var raycast_1: DieFaceRaycast = $RayCast_1
@onready var raycast_2: DieFaceRaycast = $RayCast_2
@onready var raycast_3: DieFaceRaycast = $RayCast_3
@onready var raycast_4: DieFaceRaycast = $RayCast_4
@onready var raycast_5: DieFaceRaycast = $RayCast_5
@onready var raycast_6: DieFaceRaycast = $RayCast_6
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
	match_current_die(Die.new(0))

func _process(_delta: float) -> void:
	if raycast_1.get_collider() is DieFaceDetect:
		face_up = raycast_1.face_value
	elif raycast_2.get_collider() is DieFaceDetect:
		face_up = raycast_2.face_value
	elif raycast_3.get_collider() is DieFaceDetect:
		face_up = raycast_3.face_value
	elif raycast_4.get_collider() is DieFaceDetect:
		face_up = raycast_4.face_value
	elif raycast_5.get_collider() is DieFaceDetect:
		face_up = raycast_5.face_value
	elif raycast_6.get_collider() is DieFaceDetect:
		face_up = raycast_6.face_value
	
	if _rolling and _move_timer.is_stopped():
		_rolling = false
	
	if linear_velocity != Vector3.ZERO or angular_velocity != Vector3.ZERO:
		_move_timer.start(0.05)

func roll() -> int:
	await die_clicked
	MusicMan.play_sound(AudioDictionary.sfx["Dice"])
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
	MusicMan.play_sound(AudioDictionary.sfx["Dice"])
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
	_check_type(die)
	mat.albedo_color = TextureDictionary.type_color_dict[die.get_type()]
	mat.emission_enabled = true
	mat.emission = mat.albedo_color
	mesh.set_surface_override_material(0, mat)
	var mat2 = StandardMaterial3D.new()
	mat2.albedo_color = Color.BLACK
	mesh.set_surface_override_material(1, mat2)
	
	if (die.get_type() == Die.DieType.WEIGHTED || die.get_type() == Die.DieType.LOW_ROLLER):
		mesh.set_surface_override_material(0, mat2)
		mesh.set_surface_override_material(1, mat)

func _check_type(die: Die) -> void:
	if (die.get_type() == Die.DieType.WEIGHTED):
		_set_weighted()
	elif (die.get_type() == Die.DieType.LOW_ROLLER):
		_set_low_roller()
	else:
		_set_normal()

func _set_normal() -> void:
	mesh.mesh = TextureDictionary.type_mesh_dict[Die.DieType.NORMAL]
	raycast_1.face_value = 1
	raycast_2.face_value = 2
	raycast_3.face_value = 3
	raycast_4.face_value = 4
	raycast_5.face_value = 5
	raycast_6.face_value = 6

func _set_weighted() -> void:
	mesh.mesh = TextureDictionary.type_mesh_dict[Die.DieType.WEIGHTED]
	raycast_1.face_value = 4
	raycast_2.face_value = 4
	raycast_3.face_value = 5
	raycast_4.face_value = 5
	raycast_5.face_value = 6
	raycast_6.face_value = 6

func _set_low_roller() -> void:
	mesh.mesh = TextureDictionary.type_mesh_dict[Die.DieType.LOW_ROLLER]
	raycast_1.face_value = 3
	raycast_2.face_value = 2
	raycast_3.face_value = 1
	raycast_4.face_value = 2
	raycast_5.face_value = 3
	raycast_6.face_value = 1
