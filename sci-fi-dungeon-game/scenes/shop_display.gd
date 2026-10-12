extends Node3D

var shop: Shop

@onready var tool_slot: ShopSlot = $ItemsForSale/ToolSlot
@onready var item_slot: ShopSlot = $ItemsForSale/ItemSlot
@onready var shop_slot_3: ShopSlot = $ItemsForSale/ShopSlot3
@onready var quality_upgrade_slot: ShopSlot = $ItemsForSale/QualityUpgradeSlot
@onready var purchase_button: ShopButton = $ShopButtons/PurchaseButton
@onready var reroll_button: ShopButton = $ShopButtons/RerollButton
@onready var error_message_label: Label3D = $Background/ErrorMessageLabel

var selected_item: ShopSlot = null
var is_item_slot_a_shiv: bool

func _ready() -> void:
	tool_slot.slot_selected.connect(func(slot: ShopSlot): selected_item = slot)
	item_slot.slot_selected.connect(func(slot: ShopSlot): selected_item = slot)
	shop_slot_3.slot_selected.connect(func(slot: ShopSlot): selected_item = slot)
	quality_upgrade_slot.slot_selected.connect(func(slot: ShopSlot): selected_item = slot)
	purchase_button.pressed.connect(_on_purchase_pressed)
	reroll_button.pressed.connect(func(): 
		if PlayerInventory.balance < selected_item.price:
			# Show error message or something
			return
		else:
			PlayerInventory.balance -= selected_item.price
		refresh_shop())
	refresh_shop()

func refresh_shop() -> void:
	if not PlayerInventory.has_file:
		tool_slot.set_data(3, "File", TextureDictionary.FILE)
	elif not PlayerInventory.has_wrench:
		tool_slot.set_data(5, "Wrench", TextureDictionary.WRENCH)
	elif not PlayerInventory.has_screwdriver:
		tool_slot.set_data(10, "Screwdriver", TextureDictionary.SCREWDRIVER)
	
	if not PlayerInventory.has_laser_gun and randi_range(0,100) < 30:
		is_item_slot_a_shiv = false
		item_slot.set_data(5, "Laser Gun", TextureDictionary.plasmagun_icon)
	else:
		is_item_slot_a_shiv = true
		item_slot.set_data(3, "Shiv", TextureDictionary.shiv_icon)

func _on_purchase_pressed() -> void:
	if selected_item == null:
		return
	
	if PlayerInventory.balance < selected_item.price:
		fail_purchase("Insufficient balance")
		return
	else:
		PlayerInventory.balance -= selected_item.price
	selected_item.empty_data()
	selected_item.deselect()
	selected_item.selectable = false
	
	if selected_item == tool_slot:
		PlayerInventory.add_next_tool()
	elif selected_item == item_slot:
		if is_item_slot_a_shiv:
			if PlayerInventory.shivs >= 3:
				fail_purchase("Max shivs reached")
			else:
				PlayerInventory.shivs += 1
		else:
			PlayerInventory.has_laser_gun = true
	
	selected_item = null

func fail_purchase(message: String) -> void:
	error_message_label.visible = true
	error_message_label.text = message
	await get_tree().create_timer(3).timeout
	error_message_label.visible = false
