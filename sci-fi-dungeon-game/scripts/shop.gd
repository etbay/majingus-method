class_name Shop extends Node

var _num_upgrades: int = 2
var _num_shivs: int = 2
var _num_lasers: int = 0

var _possible_upgrades: Array[Upgrade] = []
#var _possible_consumables: Array[Consumable] = []

var upgrades: Array[Upgrade] = []
#var consumables: Array[Consumable] = []

var reroll_counter: int = 1 # reroll cost = 2^counter

# shops need to support: 
# -  quality upgrade { simple interactible then select the dice in your bag
# -  dice type mod { randomly select from a list of possible items }
# -  consumables
# -  rerolls

# max displayed upgrades, max consumables, special upgrades, special consumables
func _init(num_upgrades: int = 2, num_shivs: int = 2, num_lasers: int = 2,
	possible_upgrades = []):
	_num_upgrades = num_upgrades
	_num_shivs = num_shivs
	_num_lasers = num_lasers
	_possible_upgrades = possible_upgrades
	#_possible_consumables = possible_consumables

func generate_shop() -> void:
	#populate upgrades array
	for i in range(0, _num_upgrades):
		upgrades.append(_possible_upgrades[randi_range(0,_possible_upgrades.size())])
	
	#populate items
	#for i in range(0, _num_consumables):
		#consumables.append(_possible_consumables[randi_range(0,_possible_consumables.size())])

func reroll() -> void:
	generate_shop()
	reroll_counter += 1

func get_reroll_cost() -> int:
	return pow(2, reroll_counter)
