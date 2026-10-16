class_name DieTypeDisplay extends Node3D

@onready var sprite_3d: Sprite3D = $ItemSprite
@onready var quality: Label3D = $QualityLabel
@export var mouse_detect: MouseClickDetect

var current_die: Die = null

func _ready() -> void:
	sprite_3d.visible = false
	quality.visible = false
	mouse_detect.mouse_entered.connect(_mouse_entered)
	mouse_detect.mouse_exited.connect(_mouse_exited)

func display(die: Die) -> void:
	current_die = die
	sprite_3d.visible = true
	quality.visible = true
	sprite_3d.texture = TextureDictionary.die_type_dict[die.get_type()]
	quality.text = "+%d" % die.quality

func _mouse_entered() -> void:
	if sprite_3d.visible:
		GlobalSignals.open_tooltip.emit(get_viewport().get_mouse_position(), 
			TextureDictionary.die_type_tooltip[current_die.get_type()])

func _mouse_exited() -> void:
	GlobalSignals.close_tooltip.emit()
