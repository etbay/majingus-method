class_name CPUCharacter extends Resource

@export var texture: CompressedTexture2D
@export var character_name: String
@export_range(1, 12, 1.0) var difficulty: int
@export_range(0, 3) var shiv_count: int
@export var has_laser: bool
