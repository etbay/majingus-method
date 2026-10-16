extends Label3D

@export var physics_die: PhysicsDie
@export var game_interface: GameInterface

func _ready() -> void:
	visible = false
	physics_die.roll_started.connect(_on_roll_started)
	physics_die.face_up_changed.connect(_on_face_up_changed)
	game_interface.turn_finished.connect(_on_turn_finished)

func _on_face_up_changed(new_face: int) -> void:
	text = "%d" % new_face

func _on_roll_started() -> void:
	visible = true

func _on_turn_finished() -> void:
	visible = false
