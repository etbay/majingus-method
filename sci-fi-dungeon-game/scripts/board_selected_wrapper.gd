class_name BoardSelectedWrapper extends Node

signal column_selected(int, Die)

var player_board: BoardDisplay
var cpu_board: BoardDisplay

func _init(player: BoardDisplay, cpu: BoardDisplay):
	player_board = player
	cpu_board = cpu
	player.column_selected.connect(_on_player_selected)
	cpu.column_selected.connect(_on_cpu_selected)

func _ready() -> void:
	pass


func _on_player_selected(col: int, die: Die) -> void:
	column_selected.emit(col, die)

func _on_cpu_selected(col: int, die: Die) -> void:
	column_selected.emit(col + 4, die)
