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
@export var possible_upgrades: Array[DieUpgrade]

func _ready() -> void:
	buy_shiv.pressed.connect(bought_shiv)
	view_dice.pressed.connect(display_dice)
	upgrade_1.pressed.connect(buy_upgrade_1)
	upgrade_2.pressed.connect(buy_upgrade_2)
	up_quality.pressed.connect(buy_quality)
	reroll.pressed.connect(reroll_shop)
	shop = Shop.new(2, 2, 0, possible_upgrades)
	display_shop()

func display_shop() -> void:
	buy_shiv.text = "(x%d) Shiv\n$2" % shop.num_shivs
	upgrade_1.text = "Dice Upgrade: %s\n$%d" % [shop.upgrades[0].type, shop.upgrades[0].cost]  
	upgrade_2.text = "Dice Upgrade: %s\n$%d" % [shop.upgrades[1].type, shop.upgrades[1].cost]
	up_quality.text = "Quality upgrade (+1)\n$3"
	reroll.text = "Reroll: $%d" % shop.get_reroll_cost()

func bought_shiv() -> void:
	if (Money.money >= 2):
		Money.money -= 2
		bought_shiv_signal.emit()

func reroll_shop() -> void:
	if (Money.money >= shop.get_reroll_cost()):
		Money.money -= shop.get_reroll_cost()
		shop.reroll()
		display_shop()

func buy_upgrade_1() -> void:
	buy_upgrade(0)

func buy_upgrade_2() -> void:
	buy_upgrade(1)

func buy_quality() -> void:
	if (Money.money >= 3):
		Money.money -= 3
		var quality = 100
		var target: Die
		while (quality >= 5):
			target = await get_target()
			quality = target.quality
		target.quality += 1
		display_dice()
		
func buy_upgrade(index: int) -> void:
	if (Money.money >= shop.upgrades[index].cost):
		Money.money -= shop.upgrades[index].cost
		var target = await get_target()
		target.set_type(shop.upgrades[index].type)
		display_dice()

func get_target() -> Die:
	var target: Array = await(select_wrapper.dice_selected)
	var die = dice_bag.get_absolute_dice_array()[target[0] + (target[1] * 4)]
	return die

func display_dice() -> void:
	select_wrapper.display_dice(dice_bag)
