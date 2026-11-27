extends Node

func play_sfx_sound(sound: AudioStream):
	var audio_player = AudioStreamPlayer.new()
	audio_player.bus = "SFX"
	audio_player.stream = sound
	audio_player.finished.connect(audio_player.queue_free)
	add_child(audio_player)
	
	audio_player.play()
