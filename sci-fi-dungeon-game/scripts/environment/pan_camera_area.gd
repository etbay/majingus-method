class_name PanCameraArea extends Area3D

signal hit_trigger(direction: PoolTrigger.TriggerDirection)

func hit_pool_trigger(direction: PoolTrigger.TriggerDirection) -> void:
	hit_trigger.emit(direction)
