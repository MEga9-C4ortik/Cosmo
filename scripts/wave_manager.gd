extends Node

const ENEMY_PLAN = preload("res://scenes/enemy.tscn")
const ENEMY_MARGIN = 7.5
const DEF_ENEMY_PER_WAVE = 5
const ENEMY_INTERVAL = 4.0
var wave_number = 0
var wave_enemy_number = 0
var interval = ENEMY_INTERVAL
var to_spawn = 0
var alive = 0
var is_running = false

@export var enemies_container: Node

signal enemy_died(points)
signal wave_started(n)

func _ready() -> void:
	start_wave()

func start_wave():
	is_running = true
	wave_number += 1
	wave_enemy_number = DEF_ENEMY_PER_WAVE * wave_number
	wave_started.emit(wave_number)
	to_spawn = wave_enemy_number
	interval = ENEMY_INTERVAL / wave_enemy_number
	$"SpawnTimer".wait_time = interval if interval >= 0.8 else 0.8
	$SpawnTimer.start()

func _on_spawn_timer_timeout() -> void:
	#creating enemy nad adding to the scene
	var enemy = ENEMY_PLAN.instantiate()
	enemies_container.add_child(enemy)
	enemy.global_position = Vector2(randf_range(ENEMY_MARGIN, 300+ENEMY_MARGIN), -20)

	#connecting signals
	enemy.died.connect(_on_enemy_died)
	enemy.tree_exited.connect(_on_enemy_gone)

	#Logic vars
	to_spawn -= 1
	alive += 1

	if to_spawn == 0:
		$SpawnTimer.stop()

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
	if is_running and to_spawn == 0 and $WaveDelay.is_stopped() and alive <= wave_enemy_number * 0.10:
		$WaveDelay.start()
