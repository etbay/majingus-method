extends Node

var music_player: AudioStreamPlayer


func play_sound(audio: AudioStream) -> void:
	var player: AudioStreamPlayer = AudioStreamPlayer.new()
	player.stream = audio
	get_tree().root.add_child(player)
	player.play()
	await player.finished
	player.queue_free()

func play_music(audio: AudioStream) -> void:
	if (music_player == null):
		music_player = AudioStreamPlayer.new()
		get_tree().root.add_child(music_player)
	music_player.stream = audio
	music_player.play()
