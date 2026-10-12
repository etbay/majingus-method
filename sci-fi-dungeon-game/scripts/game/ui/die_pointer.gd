extends Sprite3D

@export var die: PhysicsDie

func _ready() -> void:
	die.roll_started.connect(_on_roll_started)

func _process(_delta: float) -> void:
	if die.can_roll and not visible:
		visible = true
	elif not die.can_roll and visible:
		visible = false
	if visible:
		global_position = die.global_position + Vector3(0, 0.2, 0)

func _on_roll_started() -> void:
	visible = false
