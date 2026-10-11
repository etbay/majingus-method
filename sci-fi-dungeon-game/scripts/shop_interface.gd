class_name ShopInterface extends Node

signal bought_shiv_signal()

var shop: Shop
@export var buy_shiv: Button
@export var upgrade_1: Button
@export var upgrade_2: Button
@export var up_quality: Button
@export var reroll: Button
@export var view_dice: Button
var dice_bag: DiceBag = DiceBag.new()

@export var select_wrapper: DiceSelectWrapper
@export var possible_upgrades: Array[Upgrade]

func _ready() -> void:
	buy_shiv.pressed.connect(bought_shiv)
	view_dice.pressed.connect(display_dice)
	upgrade_1.pressed.connect(buy_upgrade_1)
	upgrade_2.pressed.connect(buy_upgrade_2)
	up_quality.pressed.connect(buy_quality)
	shop = Shop.new(2, 2, 0, possible_upgrades)
	display_shop()

func display_shop() -> void:
	buy_shiv.text = "(x%d) Shiv\n$2" % shop.num_shivs
	upgrade_1.text = "Dice Upgrade: %s\n$%d" % [shop.upgrades[0].type, shop.upgrades[0].cost]  
	upgrade_2.text = "Dice Upgrade: %s\n$%d" % [shop.upgrades[1].type, shop.upgrades[1].cost]
	up_quality.text = "Quality upgrade (+1)\n$3"

func bought_shiv() -> void:
	bought_shiv_signal.emit()

func buy_upgrade_1() -> void:
	buy_upgrade(0)

func buy_upgrade_2() -> void:
	buy_upgrade(1)

func buy_quality() -> void:
	var quality = 100
	var target: Die
	while (quality >= 5):
		target = await get_target()
		quality = target.quality
	target.quality += 1
	
func buy_upgrade(index: int) -> void:
	var target = await get_target()
	target.set_type(shop.upgrades[index].type)
	select_wrapper.display_dice(dice_bag)

func get_target() -> Die:
	var target: Array = await(select_wrapper.dice_selected)
	var die = dice_bag.get_absolute_dice_array()[target[0] + (target[1] * 4)]
	return die

func display_dice() -> void:
	select_wrapper.display_dice(dice_bag)
