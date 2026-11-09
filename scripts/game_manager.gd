extends Node

var record = 0
var score: int = 0
var is_game_over:bool = false

signal score_changed(value)
signal game_over(condition, f_score, record)

func _ready() -> void:
	is_game_over = false
	score_changed.emit(0)

func _physics_process(delta: float) -> void:
	if is_game_over and Input.is_action_just_pressed("Restart"):
		get_tree().reload_current_scene()

func _on_player_died() -> void:
	is_game_over = true
	$WaveManager.stop()
	var is_new_record = false
	if score > record:
		is_new_record = true
	game_over.emit(is_new_record, score, record)

func _on_wave_manager_enemy_died(points: Variant) -> void:
	if !is_game_over:
		score += points
		score_changed.emit(score)
