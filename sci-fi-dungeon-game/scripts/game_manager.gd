class_name GameManager extends Node

var player: Board
var cpu: Board

func _process(delta: float) -> void:
	pass

func cpu_turn() -> void:
	pass
	
func player_turn() -> void:
	var die: Die
	die.roll_die()
	# tell the player their roll
	
	# await input for which column they place the die on the board
	
	# display score
