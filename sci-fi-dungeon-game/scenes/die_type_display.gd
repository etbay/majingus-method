class_name DieTypeDisplay extends Node3D

@onready var sprite_3d: Sprite3D = $Sprite3D
@onready var quality: Label3D = $ScoreLabel

func _ready() -> void:
	sprite_3d.visible = false
	quality.visible = false
	
func display(die: Die) -> void:
	sprite_3d.visible = true
	quality.visible = true
	sprite_3d.texture = TextureDictionary.die_type_dict[die.get_type()]
	quality.text = "+%d" % die.quality
