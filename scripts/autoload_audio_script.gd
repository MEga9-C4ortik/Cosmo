extends Node

func _ready() -> void:
	#tests
	#play_sfx_sound(load("res://assets/sounds/enemyDeath.wav"))
	#play_sfx_sound(load("res://assets/sounds/newRecord.wav"))
	play_sfx_sound(load("res://assets/sounds/playerDeath.wav"))
	#play_sfx_sound(load("res://assets/sounds/playerDeath(1).wav"))

func play_sfx_sound(sound):
	var audio_player = AudioStreamPlayer.new()
	audio_player.bus = "SFX"
	audio_player.stream = sound
	audio_player.finished.connect(queue_free)
	add_child(audio_player)
	
	audio_player.play()
