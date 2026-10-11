class_name BoardDisplay extends StaticBody3D

signal column_selected(int, Die)

@onready var col_0: DisplayColumn = $Column0
@onready var col_1: DisplayColumn = $Column1
@onready var col_2: DisplayColumn = $Column2
@onready var col_3: DisplayColumn = $Column3

func _ready() -> void:
	col_0.selected.connect(func(die: Die): column_selected.emit(0, die))
	col_1.selected.connect(func(die: Die): column_selected.emit(1, die))
	col_2.selected.connect(func(die: Die): column_selected.emit(2, die))
	col_3.selected.connect(func(die: Die): column_selected.emit(3, die))

func display_board(board: Board) -> void:
	var arr = board.get_board_values()
	col_0.display(arr[0])
	col_1.display(arr[1])
	col_2.display(arr[2])
	col_3.display(arr[3])
