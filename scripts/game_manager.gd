extends Node

var config = ConfigFile.new()

var record = 0
var score: int = 0
var is_game_over:bool = false

signal score_changed(score_value)
signal game_over(condition, final_score, record_value)

func _ready() -> void:
	if config.load("user://config_file.cfg") == OK and config.get_value("Record", "record"):
		record = config.get_value("Record", "record")
		print("Condig load OK")
	else:
		change_record(0)
		print("No config found")
		
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
		change_record(score)
	game_over.emit(is_new_record, score, record)

func _on_wave_manager_enemy_died(points: Variant) -> void:
	if !is_game_over:
		score += points
		score_changed.emit(score)


func change_record(new_record):
	config.set_value("Record", "record", new_record)
	if config.save("user://config_file.cfg") == OK:
		print("Config is saved")
	else:
		print("Config isnt saved")
