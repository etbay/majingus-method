class_name GameInterface extends Node

signal turn_finished
signal die_rolled(Die)
signal status_changed(new_status: TurnStatus)

@export var physics_die: PhysicsDie
@onready var board_display: BoardDisplay = $Board
@onready var player_score_label: Label3D = $"../RightConsole/Score/ScoreNumberLabel"
@onready var shiv_button: MouseClickDetect = $"../LeftButton/MouseClickDetect"
@onready var laser_button: MouseClickDetect = $"../RightButton/MouseClickDetect"
@onready var player_die_details: DieTypeDisplay = $Board/DieTypeDisplay

@export var cpu_physics_die: PhysicsDie
@export var cpu_board_display: BoardDisplay
@onready var cpu_die_details: DieTypeDisplay = $"../CPUGameboard/Board/DieTypeDisplay"
@onready var cpu_score_label: Label3D = $"../LeftConsole/Background/Score/ScoreNumberLabel"

@onready var board_display_wrapper: BoardSelectedWrapper = BoardSelectedWrapper.new(board_display, cpu_board_display)

@onready var item_targeting: ItemTargeting = $"ItemTargeting"

var cpu_board := Board.new()
var cpu_ai := CPUAI.new(1) # fill with challenge level

var board := Board.new()
var player_score: int = -1:
	set(value):
		if player_score != value:
			player_score = value
			player_score_label.text = "%d" % player_score

var cpu_score: int = -1:
	set(value):
		if cpu_score != value:
			cpu_score = value
			cpu_score_label.text = "%d" % cpu_score

enum TurnStatus
{
	NONE,
	WAITING_FOR_TURN,
	ROLLING,
	SELECTING,
	USING_ITEM,
	USING_LASER
}

var _current_status := TurnStatus.NONE:
	set(value):
		if _current_status != value:
			_current_status = value
			status_changed.emit(_current_status)

var _prev_status := TurnStatus.NONE

func _ready() -> void:
	board_display_wrapper.column_selected.connect(_on_column_selected)
	shiv_button.mouse_clicked.connect(_on_shiv_selected)
	laser_button.mouse_clicked.connect(_on_laser_selected)

	start_game()

func set_cpu(character: CPUCharacter) -> void:
	cpu_ai = CPUAI.new(character.difficulty)

func start_game() -> void:
	player_score = 0
	cpu_score = 0

func take_turn() -> void:
	die_rolled.emit(await roll_die())
	physics_die.can_roll = false
	#print("die has been rolled")
	await select_column()

func take_cpu_turn() -> void:
	_current_status = TurnStatus.WAITING_FOR_TURN
	cpu_physics_die.can_roll = true
	var cpu_die = cpu_ai.dice_bag.get_die()
	if cpu_die == null:
		cpu_ai.dice_bag.refresh_dice()
		cpu_die = cpu_ai.dice_bag.get_die()
	cpu_die_details.display(cpu_die)
	cpu_physics_die.match_current_die(cpu_die)
	var value = await cpu_physics_die.force_roll()
	await get_tree().create_timer(0).timeout
	cpu_die.set_value(value)
	
	var cpu_col = cpu_ai.choose_column(cpu_die, board, cpu_board)
	
	if (cpu_col < 4):
		# on cpu board
		cpu_board.place_dice(cpu_col, cpu_die)
		cpu_score = cpu_board.calculate_score()
		cpu_board_display.display_board(cpu_board)
		MusicMan.play_sound(AudioDictionary.sfx["Success"])
	else:
		# attacking player
		var destroyed = board.attack_column(cpu_col - 4, cpu_die)
		player_score = board.calculate_score()
		board_display.display_board(board)
		MusicMan.play_sound(AudioDictionary.sfx["Laser"])
		for dead_die in destroyed:
			PlayerInventory.dice_bag.return_dice(dead_die)
		cpu_ai.dice_bag.return_dice(cpu_die)
	turn_finished.emit()


# Select column (player or enemy)
func select_column() -> void:
	_current_status = TurnStatus.SELECTING
	_enable_columns()
	await board_display_wrapper.column_selected

# Roll die
func roll_die() -> Die:
	_current_status = TurnStatus.ROLLING
	physics_die.can_roll = true
	var player_die = PlayerInventory.dice_bag.get_die()
	if player_die == null:
		print("ERROR: Player Bag NULL!")
	player_die_details.display(player_die)
	physics_die.match_current_die(player_die)
	var value = await physics_die.roll()
	player_die.set_value(value)
	return player_die

func _on_column_selected(column: int, die: Die) -> void:
	if (column < 4):
		#player side
		board.place_dice(column, die)
		player_score = board.calculate_score()
		board_display.display_board(board)
	else:
		#attacking
		var destroyed = cpu_board.attack_column(column - 4, die)
		cpu_score = cpu_board.calculate_score()
		cpu_board_display.display_board(cpu_board)
		MusicMan.play_sound(AudioDictionary.sfx["Laser"])
		for dead_die in destroyed:
			cpu_ai.dice_bag.return_dice(dead_die)
		PlayerInventory.dice_bag.return_dice(die)
	turn_finished.emit()

func _on_shiv_selected() -> void:
	# If structure: if the prev status is not empty, that means the current status is using, and you should cancel whatever use action
	if (_prev_status != TurnStatus.NONE):
		_current_status = _prev_status
		_prev_status = TurnStatus.NONE
		_enable_columns()
		MusicMan.play_sound(AudioDictionary.sfx["Success"])
		
	elif ((_current_status == TurnStatus.ROLLING or _current_status == TurnStatus.SELECTING) and PlayerInventory.shivs > 0):
		_prev_status = _current_status
		_current_status = TurnStatus.USING_ITEM
		MusicMan.play_sound(AudioDictionary.sfx["Select"])
		_enable_cells()
		item_targeting.clickable = true
		# wait for player to select enemy die
		var pos = await item_targeting.selected
		if (_current_status != TurnStatus.USING_ITEM):
			return
		var destroyed: Die
		#print("Targeting: [%d, %d, %d]" % [pos[0], pos[1], pos[2]])
		if pos[0] == 1:
			#player board
			destroyed = board.destroy_die(pos[1], pos[2])
			if (destroyed == null):
				_current_status = _prev_status
				_enable_columns()
				_prev_status = TurnStatus.NONE
				return
			MusicMan.play_sound(AudioDictionary.sfx["Slash"])
			player_score = board.calculate_score()
			board_display.display_board(board)
			PlayerInventory.dice_bag.return_dice(destroyed)
		elif pos[0] == 0:
			#cpu board
			destroyed = cpu_board.destroy_die(pos[1], pos[2])
			if (destroyed == null):
				_current_status = _prev_status
				_enable_columns()
				_prev_status = TurnStatus.NONE
				return
			MusicMan.play_sound(AudioDictionary.sfx["Slash"])
			cpu_score = cpu_board.calculate_score()
			cpu_board_display.display_board(cpu_board)
			cpu_ai.dice_bag.return_dice(destroyed)
			
		#else: cancel strike
		PlayerInventory.shivs -= 1
		item_targeting.clickable = false
		cpu_board_display.enable_columns()
		board_display.enable_columns()
		_current_status = _prev_status
		# spawn visual indicator / change display
		_enable_columns()
		_prev_status = TurnStatus.NONE
	else:
		MusicMan.play_sound(AudioDictionary.sfx["Fail"])

func _on_laser_selected() -> void:
	if (_prev_status != TurnStatus.NONE):
		_current_status = _prev_status
		_prev_status = TurnStatus.NONE
		_enable_columns()
		MusicMan.play_sound(AudioDictionary.sfx["Success"])
		
	elif ((_current_status == TurnStatus.ROLLING or _current_status == TurnStatus.SELECTING) and PlayerInventory.has_laser_gun):
		_prev_status = _current_status
		_current_status = TurnStatus.USING_LASER
		MusicMan.play_sound(AudioDictionary.sfx["Select"])
		_enable_cells()
		item_targeting.clickable = true
		var pos = await item_targeting.selected
		# If they cancel the function, this must be restored
		if (_current_status != TurnStatus.USING_LASER):
			return
		var destroyed: Array[Die]
		if pos[0] == 1:
			#player board
			destroyed = board.clear_row(pos[2])
			if (destroyed == null or destroyed.size() == 0):
				_current_status = _prev_status
				_enable_columns()
				_prev_status = TurnStatus.NONE
				return
			MusicMan.play_sound(AudioDictionary.sfx["Laser"])
			player_score = board.calculate_score()
			board_display.display_board(board)
			PlayerInventory.dice_bag.return_dice_array(destroyed)
		elif pos[0] == 0:
			#cpu board
			destroyed = cpu_board.clear_row(pos[2])
			if (destroyed == null or destroyed.size() == 0):
				_current_status = _prev_status
				_enable_columns()
				_prev_status = TurnStatus.NONE
				return
			MusicMan.play_sound(AudioDictionary.sfx["Laser"])
			cpu_score = cpu_board.calculate_score()
			cpu_board_display.display_board(cpu_board)
			cpu_ai.dice_bag.return_dice_array(destroyed)
			
		#else: cancel strike
		PlayerInventory.has_laser_gun = false
		item_targeting.clickable = false
		cpu_board_display.enable_columns()
		board_display.enable_columns()
		_current_status = _prev_status
		_prev_status = TurnStatus.NONE
		# spawn visual indicator / change display
		# wait for player to select enemy die
		_enable_columns()
	else:
		MusicMan.play_sound(AudioDictionary.sfx["Fail"])

func _enable_columns():
	cpu_board_display.enable_columns()
	board_display.enable_columns()
	item_targeting.disable_cells()

func _enable_cells():
	cpu_board_display.disable_columns()
	board_display.disable_columns()
	item_targeting.enable_cells()

func cleanup_dice():
	PlayerInventory.dice_bag.refresh_dice()
	cpu_ai.dice_bag.refresh_dice()

func game_over_check() -> bool:
	var player_board_full: bool = true
	var cpu_board_full: bool = true
	for arr in board.get_board_values():
		for die in arr:
			if die == null || die.get_value() == 0:
				player_board_full = false
	for arr in cpu_board.get_board_values():
		for die in arr:
			if die == null || die.get_value() == 0:
				cpu_board_full = false
	return player_board_full || cpu_board_full

func reset_board() -> void:
	cpu_board = Board.new()
	cpu_ai = CPUAI.new(cpu_ai._challenge_level + 1) # fill with challenge level
	board = Board.new()
	player_score = 0
	cpu_score = 0
	_current_status = TurnStatus.ROLLING
	_current_status = TurnStatus.NONE
	cpu_board_display.display_board(cpu_board)
	board_display.display_board(board)
	physics_die.match_current_die(Die.new(0))
	cpu_physics_die.match_current_die(Die.new(0))
