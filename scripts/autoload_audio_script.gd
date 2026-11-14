extends Node

var audio_player = AudioStreamPlayer.new()

func _ready() -> void:
	audio_player.bus = "SFX"
	
	
	print("autoload")

func play_sound(sound):
	audio_player.play(sound)
