extends Control

@onready var dialogue_speech: RichTextLabel = $Dialogue_Container/Character_Speech
@onready var dialogue_container = $Dialogue_Container
@onready var dialogue_continue: TextureButton = $Dialogue_Continue
@onready var dialogue_character_name: RichTextLabel = $Dialogue_Container/Character_Name

var dialogue_data = {}

var current_lines: Array = []
var current_index := 0
var character_name := ""
var current_entry: Dictionary = {}

func load_dialogue_json(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		push_error("Dialogue JSON not found: %s" % path)
		return {}

	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		push_error("Cannot open dialogue JSON: %s" % path)
		return {}

	var json_text = file.get_as_text()
	file.close()

	var result = JSON.parse_string(json_text)
	if typeof(result) == TYPE_DICTIONARY:
		print("Loaded dialogue data from JSON successfully.")
		return result
	else:
		push_error("Failed to parse dialogue JSON (invalid structure).")
		return {}

func _ready():
	#dialogue_data = parse_raw_dialogue("res://resources/dialogue_resources/raw_text.txt")
	#var json_text = JSON.stringify(dialogue_data, "\t")
	#var output = FileAccess.open("res://resources/dialogue_resources/dialogue_data.json", FileAccess.WRITE)
	#output.store_string(json_text)
	#output.close()
	dialogue_data = load_dialogue_json("res://resources/dialogue_resources/dialogue_data.json")
	dialogue_continue.pressed.connect(_on_next_pressed)
	GlobalSignals.start_dialogue.connect(start_dialogue)



func parse_raw_dialogue(path: String) -> Dictionary:
	var dialogue_dict: Dictionary = {}

	if not FileAccess.file_exists(path):
		push_error("Dialogue file not found: %s" % path)
		return {}

	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		push_error("Cannot open file: %s" % path)
		return {}

	var character_id := ""
	var current_condition := ""

	while not file.eof_reached():
		var line = file.get_line().strip_edges()

		if line == "":
			continue

		var parts = line.split(":", false, 1)
		if parts.size() < 2:
			continue

		var key = parts[0].strip_edges()
		var value = parts[1].strip_edges()

		match key:
			"ID":
				character_id = value

				if character_id.begins_with("NPC_"):
					current_condition = "start_game"
				else:
					current_condition = ""

				if not dialogue_dict.has(character_id):
					dialogue_dict[character_id] = {}

				if current_condition != "":
					if not dialogue_dict[character_id].has(current_condition):
						dialogue_dict[character_id][current_condition] = []

			"Condition":
				if character_id == "":
					continue

				if character_id.begins_with("NPC_"):
					current_condition = "start_game"
				else:
					current_condition = value

				if not dialogue_dict[character_id].has(current_condition):
					dialogue_dict[character_id][current_condition] = []

			"Character":
				pass

			"Text":
				if character_id == "" or current_condition == "":
					continue

				dialogue_dict[character_id][current_condition].append({
					"Text": value
				})

	file.close()

	print("Parsed %d dialogue entries" % dialogue_dict.size())
	return dialogue_dict





func start_dialogue(id: String, condition: String) -> void:
	visible = true
	current_index = 0
	current_lines = []

	if not dialogue_data.has(id):
		push_warning("Dialogue ID '%s' not found." % id)
		return

	var entry: Dictionary = dialogue_data[id]

	if not entry.has(condition):
		push_warning(
			"No dialogue for '%s' with condition '%s'."
			% [id, condition]
		)
		return

	current_lines = entry[condition]

	if current_lines.is_empty():
		push_warning("Dialogue is empty for '%s'." % id)
		return

	character_name = id
	_show_current_line()




func _show_current_line() -> void:
	if current_index >= current_lines.size():
		return

	var line: Dictionary = current_lines[current_index]

	dialogue_character_name.text = character_name
	dialogue_speech.text = line.get("Text", "")



func _on_next_pressed() -> void:
	current_index += 1

	if current_index >= current_lines.size():
		visible = false
		current_index = 0
	else:
		_show_current_line()
