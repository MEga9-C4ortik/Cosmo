extends Node



func _ready() -> void:
	var audio_player = AudioStreamPlayer.new()
	audio_player.bus = "SFX"
	add_child(audio_player)
	
	audio_player.finished.connect(on_finished)

func play_sound(audio_player, sound):
	audio_player.stream = sound
	audio_player.play()

func on_finished(audio_player):
	audio_player.stop()
	audio_player.queue_free()
