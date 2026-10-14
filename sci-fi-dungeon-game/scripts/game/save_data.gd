class_name SaveDataResource extends Resource

@export var dice_bag: DiceBag
@export var shiv_count: int = 0
@export var has_laser_gun: bool = false
@export var balance: int = 0

func _init() -> void:
	dice_bag = DiceBag.new()
