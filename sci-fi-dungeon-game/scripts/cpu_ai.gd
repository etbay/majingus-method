class_name CPUAI extends Node

var dice_bag: DiceBag
var _challenge_level: int # int from 1 to 12
var _high_threshold: int = 4

func _init(challenge_level: int = 1, bag: DiceBag = null) -> void:
	clampi(challenge_level, 1, 12)
	_challenge_level = challenge_level
	_high_threshold = randi_range(3, 5)
	if (bag == null):
		dice_bag = DiceBag.new()
		var dice = dice_bag.get_absolute_dice_array()
		for i in range(0, challenge_level):
			dice[i].set_type(randi_range(1, 5))
			var quality = dice[randi_range(0, dice.size() - 1)].quality
			if quality < 5:
				dice[randi_range(0, dice.size() - 1)].quality = min(quality + randi_range(1, max(_challenge_level / 6, 1)), 5)
	else:
		dice_bag = bag
	dice_bag._refresh_dice()

func choose_column(roll: Die, player: Board, cpu: Board) -> int:
	var target_column: int = -1
	var roll_value = roll.get_value()
	
	#analyse the game state
	# if player has more points, prioritize targeting the player for destruction
	# otherwise, we check the current cpu board and find the best column to place our die
	
	var player_pts: int = player.calculate_score()
	var cpu_pts: int = cpu.calculate_score()
	var destructive: bool
	destructive = ((player_pts - cpu_pts > 20 - _challenge_level && randi() % 2 == 0)
	|| (randi() % 5 == 0 && player.get_dice_on_board().size() >= 10 - (_challenge_level / 2)))

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
			var column_sum_weight: int
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
			# no potential targets
			# if low value, prioritize putting it in an empty spot or with other low values
			potential_targets.clear()
			if roll_value < _high_threshold:
				for i in range(0, Board.WIDTH):
					var weight: int = 1
					var dict = cpu.get_column_dict(i)
					if dict.size() >= 3:
						continue
					elif dict.get(str(roll_value)) != null:
						weight += dict[str(roll_value)]
					for j in range (0, _high_threshold):
						if dict.get(str(j)) != null:
							weight += dict[str(j)]
					if dict.get(str(roll_value)) != null:
						weight *= max(1, pow(_challenge_level, dict[str(roll_value)]))
					potential_targets.append([i, weight])
			else:
				#high value
				for i in range(0, Board.WIDTH):
					var weight: int = 1
					var dict = cpu.get_column_dict(i)
					if dict.size() >= 3:
						continue
					elif dict.get(str(roll_value)) != null:
						weight += dict[str(roll_value)]
					for j in range (_high_threshold, 6):
						if dict.get(str(j)) != null:
							weight += dict[str(j)]
					if dict.get(str(roll_value)) != null:
						weight *= max(1, pow(_challenge_level, dict[str(roll_value)]))
					potential_targets.append([i, weight])
			target_column = get_weighted_choice(potential_targets)
	if target_column == -1:
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
