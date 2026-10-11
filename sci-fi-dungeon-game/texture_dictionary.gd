extends Node

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
