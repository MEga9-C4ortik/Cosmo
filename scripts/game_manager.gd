extends Node

const CFG_FILE_PATH = "user://config_file.cfg"
const CFG_SECTION = "Record"
const CFG_KEY = "record"

var config = ConfigFile.new()
var record = 0

var score: int = 0
var is_game_over:bool = false

signal score_changed(score_value)
signal game_over(is_new_record, final_score, record_value)

func _ready() -> void:
	is_game_over = false
	record = load_record()
	score_changed.emit(0)

func load_record() -> int:
	var err = config.load(CFG_FILE_PATH)
	if err != OK and err != ERR_FILE_NOT_FOUND:
		push_warning("Config unreadable: " + error_string(err))
	var value = config.get_value(CFG_SECTION, CFG_KEY, 0)
	if value is int or value is float:
		return maxi(int(value), 0)
	push_warning("Record in config is not a number, using 0")
	return 0

func change_record(new_record):
	config.set_value(CFG_SECTION, CFG_KEY, new_record)
	var err = config.save(CFG_FILE_PATH)
	if err != OK:
		push_warning("Could not save record: " + error_string(err))
	return err == OK

func _physics_process(_delta: float) -> void:
	if is_game_over and Input.is_action_just_pressed("Restart"):
		get_tree().reload_current_scene()

func _on_player_died() -> void:
	is_game_over = true
	$WaveManager.stop()
	
	var is_new_record = score > record
	if is_new_record:
		record = score
		change_record(score)
	game_over.emit(is_new_record, score, record)

func _on_wave_manager_enemy_died(points: Variant) -> void:
	if !is_game_over:
		score += points
		score_changed.emit(score)
