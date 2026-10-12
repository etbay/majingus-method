extends Node

const SHOP_BUTTONS_1_SELECTED = preload("uid://dtuwj6bxp752u")
const SHOP_BUTTONS_1_UNSELECTED = preload("uid://dlkujsgbaou0g")
const SHOP_BUTTONS_2_SELECTED = preload("uid://bx4pcftk1mis7")
const SHOP_BUTTONS_2_UNSELECTED = preload("uid://dn0j2jeqbw8e8")

const FILE = preload("uid://c2wapo1q2cnw6")
const SCREWDRIVER = preload("uid://duyav2xr2d5db")
const WRENCH = preload("uid://dlg38rsmr6vpl")


var rolling_status_icon: CompressedTexture2D = preload("res://assets/icons/diceroll_status_icon.png")
var plasmagun_icon: CompressedTexture2D = preload("res://assets/icons/plasmagun_status_icon.png")
var selecting_status_icon: CompressedTexture2D = preload("res://assets/icons/columnselect_status_icon.png")
var shiv_icon: CompressedTexture2D = preload("res://assets/icons/shiv_status_icon_1.png")

var normal_die_icon: CompressedTexture2D = preload("res://assets/icons/die_types/normal_icon.png")
var gilded_die_icon: CompressedTexture2D = preload("res://assets/icons/die_types/gilded_icon.png")
var hollow_die_icon: CompressedTexture2D = preload("res://assets/icons/die_types/hollow_icon.png")
var low_roller_die_icon: CompressedTexture2D = preload("res://assets/icons/die_types/low_roller_icon.png")
var plasma_die_icon: CompressedTexture2D = preload("res://assets/icons/die_types/plasma_icon.png")
var weighted_die_icon: CompressedTexture2D = preload("res://assets/icons/die_types/weighted_icon.png")

var die_type_dict: Dictionary[Die.DieType, CompressedTexture2D] = {
	Die.DieType.NORMAL : normal_die_icon,
	Die.DieType.GILDED : gilded_die_icon,
	Die.DieType.LOW_ROLLER : low_roller_die_icon,
	Die.DieType.HOLLOW : hollow_die_icon,
	Die.DieType.PLASMA : plasma_die_icon,
	Die.DieType.WEIGHTED : weighted_die_icon
}

var die_face_1: CompressedTexture2D = preload("res://assets/icons/face_1.png")
var die_face_2: CompressedTexture2D = preload("res://assets/icons/face_2.png")
var die_face_3: CompressedTexture2D = preload("res://assets/icons/face_3.png")
var die_face_4: CompressedTexture2D = preload("res://assets/icons/face_4.png")
var die_face_5: CompressedTexture2D = preload("res://assets/icons/face_5.png")
var die_face_6: CompressedTexture2D = preload("res://assets/icons/face_6.png")

var die_val_dict: Dictionary[int, CompressedTexture2D] = {
	1 : die_face_1,
	2 : die_face_2,
	3 : die_face_3,
	4 : die_face_4,
	5 : die_face_5,
	6 : die_face_6,

}

var type_color_dict: Dictionary[Die.DieType, Color] = {
	Die.DieType.NORMAL : Color.WHITE,
	Die.DieType.GILDED : Color.GOLDENROD,
	Die.DieType.LOW_ROLLER : Color.BLUE,
	Die.DieType.HOLLOW : Color.WEB_PURPLE,
	Die.DieType.PLASMA : Color.DEEP_PINK,
	Die.DieType.WEIGHTED : Color.GREEN
}
