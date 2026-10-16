extends Node

const SHOP_BUTTONS_1_SELECTED = preload("uid://dtuwj6bxp752u")
const SHOP_BUTTONS_1_UNSELECTED = preload("uid://dlkujsgbaou0g")
const SHOP_BUTTONS_2_SELECTED = preload("uid://bx4pcftk1mis7")
const SHOP_BUTTONS_2_UNSELECTED = preload("uid://dn0j2jeqbw8e8")

const FILE = preload("uid://c2wapo1q2cnw6")
const SCREWDRIVER = preload("uid://duyav2xr2d5db")
const WRENCH = preload("uid://dlg38rsmr6vpl")
const COLUMN_SELECT_ICON = preload("uid://c6tth8a4sopmb")


var rolling_status_icon: CompressedTexture2D = preload("res://assets/icons/diceroll_status_icon.png")
const PLASMAGUN_STATUS_ICON_RED = preload("uid://do4h81bjgy15s")
const PLASMAGUN_STATUS_ICON_WHITE = preload("uid://bs4iqvcfbaal3")
var selecting_status_icon: CompressedTexture2D = preload("res://assets/icons/columnselect_status_icon.png")
const SHIV_STATUS_ICON_RED = preload("uid://crlv35ega58fd")
const SHIV_STATUS_ICON_WHITE = preload("uid://ro30cs8h5mvq")

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

var die_type_tooltip: Dictionary[Die.DieType, String] = {
	Die.DieType.NORMAL : "A regular six-sided die.",
	Die.DieType.GILDED : "Gold-plated holodice. +1 Gold per matching number on your board.",
	Die.DieType.LOW_ROLLER : "Acrylic-looking holodice of old-world Casinos. Can only roll 1’s, 2’s, and 3’s.",
	Die.DieType.HOLLOW : "The pattern reminds you of a bug’s carapace. Gives Points for every empty spot on your board.",
	Die.DieType.PLASMA : "Burning, cube-shaped motes of light. Gains Points equal to matches in its row.",
	Die.DieType.WEIGHTED : "Expensive, inlaid iron holodice. Can only roll 4’s, 5’s, and 6’s."
}

var type_color_dict: Dictionary[Die.DieType, Color] = {
	Die.DieType.NORMAL : Color.WHITE,
	Die.DieType.GILDED : Color.GOLDENROD,
	Die.DieType.LOW_ROLLER : Color.BLUE,
	Die.DieType.HOLLOW : Color.WEB_PURPLE,
	Die.DieType.PLASMA : Color.DEEP_PINK,
	Die.DieType.WEIGHTED : Color.GREEN
}

var type_mesh_dict: Dictionary[Die.DieType, Mesh] = {
	Die.DieType.NORMAL: preload("res://assets/dice_mesh/dicemodel_Cube_001.res"),
	Die.DieType.LOW_ROLLER: preload("res://assets/dice_mesh/dicemodel_lowroller_Cube_001.res"),
	Die.DieType.WEIGHTED: preload("res://assets/dice_mesh/dicemodel_weighted_Cube_003.res")
}
