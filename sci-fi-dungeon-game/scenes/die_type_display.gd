class_name DieTypeDisplay extends Node3D

@onready var sprite_3d: Sprite3D = $ItemSprite
@onready var quality: Label3D = $QualityLabel
@onready var mouse_detect: MouseClickDetect = $Area3D
@onready var tooltip_label: Label3D = $TooltipLabel

var current_die: Die = null

func _ready() -> void:
	tooltip_label.visible = false
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
	tooltip_label.text = TextureDictionary.die_type_tooltip[die.get_type()]

func _mouse_entered() -> void:
	if sprite_3d.visible:
		tooltip_label.visible = true

func _mouse_exited() -> void:
	tooltip_label.visible = false
