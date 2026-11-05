extends Node

const ENEMY_PLAN = preload("res://scenes/enemy.tscn")
const ENEMY_MARGIN = 7.5
const DEF_ENEMY_PER_WAVE:int = 5
const WAVE_DURATION = 22.0
const MIN_INTERVAL = 1.0

var templates = ["default", "row", "circle"]
var curr_templ = 0

var wave_number:int = 0
var wave_enemy_number:int = 0
var to_spawn:int = 0
var alive:int = 0
var enemy_hp = 0
var enemy_points = 0
var enemy_speed = 0
var is_running:bool = false

@export var enemies_container: Node

signal enemy_died(points)
signal wave_started(n)

func _ready() -> void:
	start_wave()

func start_wave():
	is_running = true
	wave_number += 1
	wave_started.emit(wave_number)

	enemy_hp = 2 + int((wave_number - 1) / 5.0)
	enemy_speed = 50 + 40.0 * wave_number / (wave_number + 8.0)
	enemy_points = enemy_hp * 50

	wave_enemy_number = DEF_ENEMY_PER_WAVE * wave_number
	to_spawn = wave_enemy_number

	$"SpawnTimer".wait_time = max(WAVE_DURATION / wave_enemy_number, MIN_INTERVAL)
	$SpawnTimer.start()


func _on_spawn_timer_timeout() -> void:
	var enemy = create_enemy()

	if to_spawn == 0:
		$SpawnTimer.stop()

func create_enemy() -> Node2D:
	var enemy = ENEMY_PLAN.instantiate()
	enemies_container.add_child(enemy)
	enemy.global_position = Vector2(randf_range(ENEMY_MARGIN, 300-ENEMY_MARGIN), -20)
	enemy.hp = enemy_hp
	enemy.speed = enemy_speed
	enemy.points = enemy_points

	#connecting signals
	enemy.died.connect(_on_enemy_died)
	enemy.tree_exited.connect(_on_enemy_gone)

	to_spawn -= 1
	alive += 1

	return enemy

func _on_wave_delay_timeout() -> void:
	if is_running:
		start_wave()

func stop():
	$SpawnTimer.stop()
	$WaveDelay.stop()
	is_running = false

func _on_enemy_died(points: Variant) -> void:
	enemy_died.emit(points)

func _on_enemy_gone():
	alive -= 1
	if is_running and to_spawn == 0 and $WaveDelay.is_stopped() and alive <= wave_enemy_number * 0.06:
		$WaveDelay.start()
		print("wave cleared")
