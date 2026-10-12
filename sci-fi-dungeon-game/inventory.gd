class_name InventoryDisplay extends Node3D

@export var inventory_slots: Array[InventorySlot]

var test_array: Array[Die]

func _ready() -> void:
	test_array.append(Die.new(0, Die.DieType.LOW_ROLLER))
	test_array.append(Die.new(0, Die.DieType.HOLLOW))
	test_array.append(Die.new(0, Die.DieType.PLASMA))
	test_array.append(Die.new(0, Die.DieType.WEIGHTED))
	test_array.append(Die.new(0, Die.DieType.GILDED))
	test_array.append(Die.new())
	test_array.append(Die.new())
	test_array.append(Die.new())
	test_array.append(Die.new())
	test_array.append(Die.new())
	test_array.append(Die.new())
	test_array.append(Die.new())
	
	for slot in inventory_slots:
		slot.slot_selected.connect(_on_selected)
	for i in range(12):
		#inventory_slots[i].set_die(PlayerInventory.get_dice_inventory()[i])
		inventory_slots[i].set_die(test_array[i])

func _on_selected(selected_slot: InventorySlot) -> void:
	for slot in inventory_slots:
		if slot != selected_slot:
			slot.deselect()
