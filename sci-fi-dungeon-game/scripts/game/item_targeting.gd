class_name ItemTargeting extends Node

signal selected(pos: Array[int])

@export var player_cells: Array[CellDisplay]
@export var cpu_cells: Array[CellDisplay]

var clickable: bool = true

func _ready() -> void:
	for cell in player_cells:
		cell.cell_clicked.connect(player_cell_selected)
	for cell in cpu_cells:
		cell.cell_clicked.connect(cpu_cell_selected)

func player_cell_selected(pos: Array[int]) -> void:
	if (clickable):
		var arr: Array[int] = []
		arr.assign(pos)
		arr.push_front(1)
		#print("Broadcasted player cell click")
		selected.emit(arr)

func cpu_cell_selected(pos: Array[int]) -> void:
	if (clickable):
		var arr: Array[int] = []
		arr.assign(pos)
		arr.push_front(0)
		#print("Broadcasted cpu cell click")
		selected.emit(arr)

func disable_cells():
	for cell in player_cells:
		cell.collision.disabled = true
	for cell in cpu_cells:
		cell.collision.disabled = true
		
func enable_cells():
	for cell in player_cells:
		cell.collision.disabled = false
	for cell in cpu_cells:
		cell.collision.disabled = false
