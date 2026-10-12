extends Label3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "$%d" % PlayerInventory.balance
	PlayerInventory.balance_changed.connect(func(val: int): text = "$%d" % val)
