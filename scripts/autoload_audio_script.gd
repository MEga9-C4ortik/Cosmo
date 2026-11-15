extends Node

signal on_finished()

var audio_player = AudioStreamPlayer.new()

func _ready() -> void:
	add_child(audio_player)
	audio_player.bus = "SFX"

	print("autoload")

func play_sound(sound):
	audio_player.stream = sound
	audio_player.play()
	if audio_player.finished:
		on_finished.emit()


func _on_finished():
	queue_free()
