class_name SaveDataResource extends Resource

@export var dice_bag: DiceBag
@export_range(0, 3, 1.0) var shiv_count: int = 0
@export var has_laser_gun: bool = false
@export var balance: int = 0
@export_range(0, 6, 1.0) var current_cpu: int = 0

func _init() -> void:
	dice_bag = DiceBag.new()
