class_name GameManager extends Node

signal earned_money(int)

@export var game_display: GameDisplay

@export var player_score: Label
@export var CPU_score: Label

@export var b: BoardSignalManager
@export var cb: BoardSignalManager

@onready var cpu_ai: CPUAI = CPUAI.new(5)

@onready var player: Board = Board.new()
@onready var cpu_board: Board = Board.new()

@onready var player_dice: DiceBag = DiceBag.new()
@onready var cpu_dice: DiceBag = DiceBag.new()

var turn_in_progress: bool = false
var turn: int = 0 # 0 = nobody, 1 = player, 2 = cpu

func _ready() -> void:
	set_process(false)

func _process(delta: float) -> void:
	if not turn_in_progress and turn == 0:
		turn = 1
		turn_in_progress = true
		game_display.player_take_turn()
	elif not turn_in_progress and turn == 1:
		turn = 2
		turn_in_progress = true
		cpu_turn()

func start_game() -> void:
	set_process(true)

func cpu_turn() -> void:
	turn = 0
	turn_in_progress = false
	
func player_turn() -> void:
	turn_in_progress = false # end turn
