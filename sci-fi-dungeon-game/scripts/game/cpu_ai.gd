class_name CPUAI extends Node

var dice_bag: DiceBag
var _challenge_level: int # int from 1 to 12
var _high_threshold: int = 4
var shivs: int = 3:
	set (value):
		shivs = min(max(0, value), 3)
var has_laser: bool = true

func _init(challenge_level: int = 1, bag: DiceBag = null, shiv_count: int = 1, laser: bool = false) -> void:
	clampi(challenge_level, 1, 12)
	_challenge_level = challenge_level
	_high_threshold = randi_range(4, 5)
	shivs = shiv_count
	has_laser = laser
	if (bag == null):
		dice_bag = DiceBag.new()
		var dice = dice_bag.get_absolute_dice_array()
		for i in range(0, challenge_level):
			var possible_types = [1, 2, 3, 4, 5]
			dice[randi_range(0, dice.size() - 1)].set_type(possible_types[randi_range(0, possible_types.size() - 1)])
			var quality = dice[randi_range(0, dice.size() - 1)].quality
			if quality < 5:
				dice[randi_range(0, dice.size() - 1)].quality = min(quality + 1, 5)
	else:
		dice_bag = bag
	dice_bag.refresh_dice()

func choose_column(roll: Die, player: Board, cpu: Board) -> int:
	var target_column: int = -1
	var roll_value = roll.get_value()
	
	#analyse the game state
	# if player has more points, prioritize targeting the player for destruction
	# otherwise, we check the current cpu board and find the best column to place our die
	
	var player_pts: int = player.calculate_score()
	var cpu_pts: int = cpu.calculate_score()
	var destructive: bool
	destructive = ((player_pts - cpu_pts > 12 - _challenge_level && randi() % 2 == 0)
	|| (randi() % 3 == 0 && player.get_dice_on_board().size() >= 6 - (_challenge_level / 2.0)))
	
	if (destructive):
		var player_board_array = player.get_board_values()
		var potential_targets: Array[Array] = [] # targets stores columns that matter in the form [column, weight]
		for i in range(0, player_board_array.size()):
			var column_sum_weight: int = 0
			var full_count = 0
			for die in player_board_array[i]:
				if die != null:
					full_count += 1
					if(die.get_value() == roll_value):
						#potential targets add!
						if (column_sum_weight != 0):
							column_sum_weight *= _challenge_level # if there are two matching dice in the row, weight for the row skyrockets
						column_sum_weight += 1 + die.get_type() + (die.quality * _challenge_level)
			if full_count < 3 and column_sum_weight > 0:
				potential_targets.append([i, column_sum_weight])
		
		if potential_targets.size() > 0:
			var total_weight = 0
			for arr in potential_targets:
				total_weight += arr[1]
			var target_weight = randi_range(0, total_weight)
			for arr in potential_targets:
				# check for when you pass the target weight
				if target_weight > arr[1]:
					target_weight -= arr[1]
				else:
					target_column = arr[0] + Board.WIDTH # attacking columns are 4 more than the play field (5-8)
					break
	
	if (target_column == -1):
		# not destructive or destructive did not lead to any matches
		# plays on their own board
		# similar logic for finding matches
		var cpu_board_array = cpu.get_board_values()
		var potential_targets: Array[Array] = [] # targets stores columns that matter in the form [column, weight]
		for i in range(0, cpu_board_array.size()):
			var column_sum_weight: int = 1
			var full_count = 0
			for die in cpu_board_array[i]:
				if die != null:
					full_count += 1
					if(die.get_value() == roll_value):
						#potential targets add!
						if (column_sum_weight != 0):
							column_sum_weight *= _challenge_level # if there are two matching dice in the row, weight for the row skyrockets
						column_sum_weight += die.get_type() + (die.quality * _challenge_level)
			if full_count < 3 and column_sum_weight > 0:
				potential_targets.append([i, column_sum_weight])
		
		if potential_targets.size() > 0:
			target_column = get_weighted_choice(potential_targets)
			
		else:
			# no potential targets for attacking
			# if low value, prioritize putting it with other low values
			potential_targets.clear()
			if roll_value < _high_threshold:
				for i in range(0, Board.WIDTH):
					var weight: int = 1
					
					if cpu.is_column_full(i):
						continue
					else:
						var dict = cpu.get_column_dict(i)
						# ai doesnt want to put low values in open spots most of the time
						if dict.size() == 0 and roll.get_type() == Die.DieType.LOW_ROLLER:
							weight += 1
						else:
							for j in range (0, _high_threshold):
								if dict.get(str(j)) != null:
									weight += dict[str(j)]
						if dict.get(str(roll_value)) != null:
							weight *= max(1, pow(_challenge_level, dict[str(roll_value)]))
					potential_targets.append([i, weight])
			else:
				#high value - prioritize empty spots or matching spots
				for i in range(0, Board.WIDTH):
					var weight: int = 1
					if cpu.is_column_full(i):
						continue
					else:
						var dict = cpu.get_column_dict(i)
						if dict.size() == 0:
							weight += 1
						elif dict.get(str(roll_value)) != null:
							weight += roll_value
							weight *= max(1, pow(_challenge_level, dict[str(roll_value)]))
						potential_targets.append([i, weight])
			target_column = get_weighted_choice(potential_targets)
	while target_column == -1 || (target_column < 4 && cpu.get_column_count(target_column) >= 3) || (target_column >= 4 && player.get_column_count(target_column - 4) >= 3):
		#catch all incorrect spot errors with pure randomness
		target_column = randi_range(0, Board.WIDTH - 1)
	return target_column

func get_weighted_choice(potential_targets: Array[Array]) -> int:
	var target_column = 3 # default to last column in case somethign breaks
	var total_weight = 0
	for arr in potential_targets:
		total_weight += arr[1]
	var target_weight = randi_range(0, total_weight)
	for arr in potential_targets:
		# check for when you pass the target weight
		if target_weight > arr[1]:
			target_weight -= arr[1]
		else:
			target_column = arr[0]
			break
	return target_column

# calculates where the best possible spot for a shiv would be, or returns null if no great shiv spot exists
# output: [player board or cpu board, x position, y position]
func use_shiv(die: Die, player: Board, cpu: Board) -> Array[int]:	
	# determine greatest single point loss on player's board
	var player_target: Array[int] = [0,0,0]
	var player_target_worth = 0
	for array in player.get_board_values():
		for item: Die in array:
			
			if (item == null or item.get_value() == 0):
				break
			
			var worth: float = item.get_value() + item.quality
			if (item.get_type() != Die.DieType.NORMAL and item.get_type() != Die.DieType.GILDED):
				# bonus worth for special dice that are non-standard scales with challenge (good ais will target non-standard dice more)
				worth += _challenge_level / 4.0
			
			# mult worth by matches in column
			var col_dict = player.get_column_dict(item.x)
			worth *= col_dict[str(item.get_value())]
			
			if (col_dict[str(item.get_value())] == 3 and die.get_value() == item.get_value()):
				# determine if they can destroy one item to make a column empty (greatest value column they can remove)
				worth *= _challenge_level / 4.0
			
			if worth > player_target_worth:
				player_target_worth = worth
				player_target[1] = item.x
				player_target[2] = item.y
	
	# can a shiv on self board be valuable with current die
	var cpu_target_worth: int = 0
	var cpu_target: Array[int] = [1,0,0]
	for array in cpu.get_board_values():
		for item: Die in array:
			if (item == null or item.get_value() == 0):
				break
			var worth: float = 0
			if (item.get_type() != Die.DieType.NORMAL and item.get_type() != Die.DieType.GILDED):
				# do not target own special dice
				worth -= _challenge_level
			if cpu.is_column_full(item.x):
				if cpu.get_column_dict(item.x).get(str(item.get_value())) == 2:
					worth += die.get_value() + die.quality
			if worth > cpu_target_worth:
				cpu_target_worth = worth
				cpu_target[1] = item.x
				cpu_target[2] = item.y
			
	# find out which option is the most valuable play
	if player_target_worth != 0 and player_target_worth >= cpu_target_worth:
		return player_target
	elif cpu_target_worth != 0:
		return cpu_target
	else:
		return []

func use_laser(roll: Die, player: Board) -> int:
	# determine which column contains the highest value
	var highest_value: int = -1
	var target_row: int = -1
	var player_cells = player.get_board_values()
	for y in range(0, Board.HEIGHT):
		var value: int = -1
		for x in range(0, Board.WIDTH):
			if (player_cells[x][y] != null):
				value += player_cells[x][y].get_value() + player_cells[x][y].quality
				if player_cells[x][y].get_type() != Die.DieType.NORMAL and player_cells[x][y].get_type() != Die.DieType.GILDED:
					value += _challenge_level
		if value > highest_value:
			highest_value = value
			target_row = y
	return target_row
