extends Node

var audio_player = AudioStreamPlayer.new()

func _ready() -> void:
	add_child(audio_player)
	audio_player.bus = "SFX"
	
	#tests
	print(play_sound(""))

func _process(delta: float) -> void:
	if !(audio_player.playing):
		audio_player.queue_free()

func play_sound(sound):
	audio_player.stream = sound
	audio_player.play()
