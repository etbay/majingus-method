class_name PoolTrigger extends Area3D

enum TriggerDirection
{
	LEFT,
	RIGHT
}

@export var trigger_direction: TriggerDirection

var _entered_from_left: bool = false

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _on_area_entered(area: Node3D) -> void:
	if area is PanCameraArea:
		_entered_from_left = area.global_position.x < global_position.x

func _on_area_exited(area: Node3D) -> void:
	if area is PanCameraArea:
		var exited_left := area.global_position.x < global_position.x
		if exited_left == _entered_from_left:
			return
		area.hit_pool_trigger(trigger_direction)
