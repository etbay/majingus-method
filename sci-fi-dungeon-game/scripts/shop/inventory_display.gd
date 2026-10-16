class_name InventoryDisplay extends Node3D

signal slot_selected(InventorySlot)

@export var inventory_slots: Array[InventorySlot]

var test_array: Array[Die]

func _ready() -> void:
	for slot in inventory_slots:
		slot.slot_selected.connect(_on_selected)
	PlayerInventory.dice_bag_changed.connect(initialize_inventory)
	initialize_inventory()

func initialize_inventory() -> void:
	for i in range(12):
		inventory_slots[i].set_die(PlayerInventory.get_dice_inventory()[i])

func _on_selected(selected_slot: InventorySlot) -> void:
	slot_selected.emit(selected_slot)
	for slot in inventory_slots:
		if slot != selected_slot:
			slot.deselect()
