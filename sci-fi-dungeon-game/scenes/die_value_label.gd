extends Label3D

@export var physics_die: PhysicsDie

func _ready() -> void:
	physics_die.face_up_changed.connect(_on_face_up_changed)

func _on_face_up_changed(new_face: int) -> void:
	text = "%d" % new_face
