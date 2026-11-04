extends Node

var score: int = 0
var is_game_over = false
var screen_size = 0

signal score_changed(value)
signal game_over(final_score)

func _ready() -> void:
	screen_size = get_viewport().get_visible_rect()
	is_game_over = false
	score_changed.emit(0)

func _physics_process(delta: float) -> void:
	if is_game_over and Input.is_action_just_pressed("Restart"):
		get_tree().reload_current_scene()

func _on_player_died() -> void:
	is_game_over = true
	$WaveManager.stop()
	game_over.emit(score)

func _on_wave_manager_enemy_died(points: Variant) -> void:
	if !is_game_over:
		score += points
		score_changed.emit(score)
