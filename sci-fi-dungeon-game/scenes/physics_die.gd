class_name PhysicsDie extends RigidBody3D

signal face_up_changed(int)

@onready var raycast_1: RayCast3D = $RayCast_1
@onready var raycast_2: RayCast3D = $RayCast_2
@onready var raycast_3: RayCast3D = $RayCast_3
@onready var raycast_4: RayCast3D = $RayCast_4
@onready var raycast_5: RayCast3D = $RayCast_5
@onready var raycast_6: RayCast3D = $RayCast_6

var face_up: int = 0:
	set(value):
		if face_up != value:
			face_up = value
			face_up_changed.emit(face_up)

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

func roll() -> void:
	_apply_random_force()
	await get_tree().create_timer(0.01).timeout
	_apply_random_force()
	await get_tree().create_timer(0.01).timeout
	_apply_random_force()

func _apply_random_force() -> void:
	var x_force: float = randf_range(0, 5)
	var z_force: float = randf_range(0, 5)
	var x_offset: float = randf_range(-0.1, 0.1)
	var z_offset: float = randf_range(-0.1, 0.1)
	apply_force(Vector3(x_force, 15, z_force), Vector3(x_offset, -0.1, z_offset))
	var x_rotation: float = randf_range(0, 360)
	var z_rotation: float = randf_range(0, 360)
	apply_torque(Vector3(x_rotation, 0, z_rotation))
