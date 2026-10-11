class_name DiceSelectWrapper extends Node

signal dice_selected(x: int, y: int)

@export var button_00: Button
@export var button_10: Button
@export var button_20: Button
@export var button_30: Button

@export var button_01: Button
@export var button_11: Button
@export var button_21: Button
@export var button_31: Button

@export var button_02: Button
@export var button_12: Button
@export var button_22: Button
@export var button_32: Button

var button_arr: Array[Button] = []

func _ready() -> void:
	button_00.pressed.connect(_button_00_p)
	button_01.pressed.connect(_button_01_p)
	button_02.pressed.connect(_button_02_p)
	button_10.pressed.connect(_button_10_p)
	button_11.pressed.connect(_button_11_p)
	button_12.pressed.connect(_button_12_p)
	button_20.pressed.connect(_button_20_p)
	button_21.pressed.connect(_button_21_p)
	button_22.pressed.connect(_button_22_p)
	button_30.pressed.connect(_button_30_p)
	button_31.pressed.connect(_button_31_p)
	button_32.pressed.connect(_button_32_p)
	
	button_arr.append(button_00)
	button_arr.append(button_10)
	button_arr.append(button_20)
	button_arr.append(button_30)
	button_arr.append(button_01)
	button_arr.append(button_11)
	button_arr.append(button_21)
	button_arr.append(button_31)
	button_arr.append(button_02)
	button_arr.append(button_12)
	button_arr.append(button_22)
	button_arr.append(button_32)

func display_dice(bag: DiceBag) -> void:
	var dice_arr: Array[Die] = bag.get_absolute_dice_array()
	for i in range(0, dice_arr.size()):
		button_arr[i].text = "Type: " + str(dice_arr[i].get_type()) + "\nQuality: +" + str(dice_arr[i].quality)

func _button_00_p():
	dice_selected.emit(0, 0)

func _button_01_p():
	dice_selected.emit(0, 1)

func _button_02_p():
	dice_selected.emit(0, 2)

func _button_10_p():
	dice_selected.emit(1, 0)

func _button_11_p():
	dice_selected.emit(1, 1)

func _button_12_p():
	dice_selected.emit(1, 2)

func _button_20_p():
	dice_selected.emit(2, 0)

func _button_21_p():
	dice_selected.emit(2, 1)

func _button_22_p():
	dice_selected.emit(2, 2)
	
func _button_30_p():
	dice_selected.emit(3, 0)

func _button_31_p():
	dice_selected.emit(3, 1)

func _button_32_p():
	dice_selected.emit(3, 2)
