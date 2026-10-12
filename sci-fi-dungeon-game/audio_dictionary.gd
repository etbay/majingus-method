extends Node

var sfx: Dictionary[String, AudioStream] = {
	"FootOut" = preload("res://assets/sound/Foot-out.ogg"),
	"FootIn" = preload("res://assets/sound/Foot-in.ogg"),
	"FishIn" = preload("res://assets/sound/Water_flowing_in_fish.ogg"),
	"Success" = preload("res://assets/sound/Interact_good.ogg"),
	"Fail" = preload("res://assets/sound/Interact_bad.ogg"),
	"Laser" = preload("res://assets/sound/Laser Gun.ogg"),
	"Dice" = preload("res://assets/sound/dice.ogg"),
	"Explosion" = preload("res://assets/sound/Explosion.ogg"),
	"ToiletUnlock" = preload("res://assets/sound/scifi wrench and toilet.ogg"),
	"Slash" = preload("res://assets/sound/shing.ogg"),
}

var music: Dictionary[String, AudioStream] = {
	"MainTheme" = preload("res://assets/sound/TheEarthIsARobot.ogg"),
	"DiceTheme" = preload("res://assets/sound/Oh goodness look how late it is!.ogg"),
	"RatTheme" = preload("res://assets/sound/Toilet Rat.ogg"),
}
