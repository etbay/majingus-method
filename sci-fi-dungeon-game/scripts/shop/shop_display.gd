class_name ShopDisplay extends Node3D

var shop: Shop

@export var possible_upgrades: Array[DieUpgrade] = []

@onready var tool_slot: ShopSlot = $ItemsForSale/ToolSlot
@onready var item_slot: ShopSlot = $ItemsForSale/ItemSlot
@onready var die_upgrade_slot: ShopSlot = $ItemsForSale/ShopSlot3
@onready var quality_upgrade_slot: ShopSlot = $ItemsForSale/QualityUpgradeSlot
@onready var purchase_button: ShopButton = $ShopButtons/PurchaseButton
@onready var reroll_button: ShopButton = $ShopButtons/RerollButton
@onready var error_message_label: Label3D = $Background/ErrorMessageLabel
@onready var inventory: InventoryDisplay = $Inventory

var is_quality_slot_empty: bool = false
var shop_slots: Array[ShopSlot]
var selected_item: ShopSlot = null
var selected_inventory_slot: InventorySlot = null
var is_item_slot_a_shiv: bool
@onready var error_timer: Timer = $Timer

func _ready() -> void:
	quality_upgrade_slot.set_data(2, "Quality Upgrade", TextureDictionary.normal_die_icon, 1)
	inventory.slot_selected.connect(_on_inventory_slot_selected)
	shop_slots.append_array([tool_slot, item_slot, die_upgrade_slot, quality_upgrade_slot])
	error_message_label.visible = false
	tool_slot.slot_selected.connect(_on_selected)
	item_slot.slot_selected.connect(_on_selected)
	die_upgrade_slot.slot_selected.connect(_on_selected)
	quality_upgrade_slot.slot_selected.connect(_on_selected)
	purchase_button.pressed.connect(_on_purchase_pressed)
	reroll_button.pressed.connect(func():
		if PlayerInventory.balance < 2:
			fail_purchase("Insufficient balance")
			return
		else:
			PlayerInventory.balance -= 2
		refresh_shop())
	refresh_shop()

func refresh_shop() -> void:
	#if not PlayerInventory.has_wrench:
	#	tool_slot.set_data(5, "Wrench", TextureDictionary.WRENCH)
	#elif not PlayerInventory.has_screwdriver:
	#	tool_slot.set_data(10, "Screwdriver", TextureDictionary.SCREWDRIVER)
	tool_slot.set_data(8, "Laser Gun", TextureDictionary.PLASMAGUN_STATUS_ICON_RED)
	
	#if not PlayerInventory.has_laser_gun and randi_range(0,100) < 30:
	#	is_item_slot_a_shiv = false
	#	item_slot.set_data(8, "Laser Gun", TextureDictionary.PLASMAGUN_STATUS_ICON_RED)
	#else:
	#	is_item_slot_a_shiv = true
	item_slot.set_data(4, "Shiv", TextureDictionary.SHIV_STATUS_ICON_RED)
	
	if selected_inventory_slot == null:
		quality_upgrade_slot.set_data(4, "Quality Upgrade", TextureDictionary.normal_die_icon, 1)
	else:
		_populate_quality_slot(selected_inventory_slot)
	
	var upgrade: DieUpgrade = possible_upgrades.pick_random()
	die_upgrade_slot.set_die(upgrade.cost, upgrade.name, Die.new(0, upgrade.type, 0))

func _on_purchase_pressed() -> void:
	if selected_item == null:
		fail_purchase("No shop item selected")
		return
	
	var can_purchase = PlayerInventory.balance >= selected_item.price
	
	if not can_purchase:
		fail_purchase("Insufficient balance")
		return
	
	if selected_item == tool_slot:
		if PlayerInventory.has_laser_gun:
			fail_purchase("Max laser guns reached")
			return
		else:
			PlayerInventory.has_laser_gun = true
	elif selected_item == item_slot:
		if PlayerInventory.shivs >= 3:
			fail_purchase("Max shivs reached")
			return
		else:
			PlayerInventory.shivs += 1
	
	if selected_item == quality_upgrade_slot:
		if selected_inventory_slot == null:
			fail_purchase("No inventory die selected")
			return
		else:
			var old_die: Die = selected_inventory_slot.die
			var new_die := Die.new(0, old_die.get_type(), old_die.quality + 1)
			PlayerInventory.set_die(selected_inventory_slot.index, new_die)
			# is_quality_slot_empty = true
			inventory.initialize_inventory()
	
	if selected_item == die_upgrade_slot:
		if selected_inventory_slot == null:
			fail_purchase("No inventory die selected")
			return
		else:
			var old_die: Die = selected_inventory_slot.die
			var new_die := Die.new(0, old_die.get_type(), old_die.quality)
			new_die.set_type(selected_item.die.get_type())
			PlayerInventory.set_die(selected_inventory_slot.index, new_die)
			inventory.initialize_inventory()
	
	PlayerInventory.balance -= selected_item.price
	if selected_item != quality_upgrade_slot:
		selected_item.deselect()
		selected_item.empty_data()
		selected_item.selectable = false
		selected_item = null
	else:
		_populate_quality_slot(selected_inventory_slot)

func fail_purchase(message: String) -> void:
	error_message_label.visible = true
	error_message_label.text = message
	error_timer.start(3)
	await error_timer.timeout
	error_message_label.visible = false

func _on_selected(selected_slot: ShopSlot) -> void:
	selected_item = selected_slot
	for slot in shop_slots:
		if slot != selected_slot:
			slot.deselect()

func _on_inventory_slot_selected(selected_slot: InventorySlot) -> void:
	selected_inventory_slot = selected_slot
	if is_quality_slot_empty:
		return
	_populate_quality_slot(selected_slot)

func _populate_quality_slot(slot: InventorySlot) -> void:
	is_quality_slot_empty = false
	var price: int = 4
	if slot.die.quality != 0:
		price = (slot.die.quality + 2)**2
	quality_upgrade_slot.set_data(price, "Quality Upgrade", slot.die_type_sprite.texture, slot.die.quality + 1)
