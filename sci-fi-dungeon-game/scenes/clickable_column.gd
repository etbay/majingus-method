class_name DisplayColumn extends Area3D

signal selected(Die)

@onready var select_sprite: Sprite3D = $SelectSprite
@export var player_gameboard: GameInterface

@export var cells: Array[CellDisplay]
var hoverable: bool = false
var mouse_hovered: bool = false
var is_full: bool:
	get:
		for cell in cells:
			if cell.value == 0:
				return false
		return true
var last_roll_value: int = 0

var die: Die = null

func _ready() -> void:
	select_sprite.visible = false
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	player_gameboard.die_rolled.connect(_on_die_rolled)
	player_gameboard.turn_finished.connect(_on_turn_finished)

func _process(_delta: float) -> void:
	if hoverable and mouse_hovered and Input.is_action_just_pressed("skarps_interact"):
		_select()

func _select() -> void:
	if is_full:
		return
	
	hoverable = false
	select_sprite.visible = false
	selected.emit(die)
	#for cell in cells:
		#if cell.value == 0:
			#cell.set_value(last_roll_value)
			#die = Die.new(last_roll_value)
			#selected.emit(die)
	return

func _on_die_rolled(die_val: Die) -> void:
	last_roll_value = die_val.get_value()
	die = die_val
	hoverable = true
	if mouse_hovered:
		select_sprite.visible = true

func _on_turn_finished() -> void:
	hoverable = false

func _on_mouse_entered() -> void:
	mouse_hovered = true
	if hoverable:
		select_sprite.visible = true

func _on_mouse_exited() -> void:
	mouse_hovered = false
	if hoverable:
		select_sprite.visible = false

func display(arr: Array[Die]) -> void:
	for i in range(0, Board.HEIGHT):
		if (arr[i] != null and arr[i].get_value() != 0):
			cells[i].set_value(arr[i].get_value())
