class_name Shop extends Node

var num_upgrades: int = 2
var num_shivs: int = 2
var num_lasers: int = 0

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
func _init(n_num_upgrades: int, n_num_shivs: int, n_num_lasers: int,
	possible_upgrades: Array[Upgrade]):
	self.num_upgrades = n_num_upgrades
	self.num_shivs = n_num_shivs
	self.num_lasers = n_num_lasers
	_possible_upgrades = possible_upgrades
	#_possible_consumables = possible_consumables
	generate_shop()

func generate_shop() -> void:
	#populate upgrades array
	upgrades = []
	for i in range(0, num_upgrades):
		upgrades.append(_possible_upgrades[randi_range(0,_possible_upgrades.size() - 1)])

func reroll() -> void:
	generate_shop()
	reroll_counter += 1

func get_reroll_cost() -> int:
	return pow(2, reroll_counter)
