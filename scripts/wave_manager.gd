extends Node

const ENEMY_PLAN = preload("res://scenes/enemy.tscn")
const ENEMY_MARGIN = 7.5
const DEF_ENEMY_PER_WAVE:int = 5
const WAVE_DURATION = 22.0
const MIN_INTERVAL = 1.0

const TEMPLATES = ["row", "row", "curve"]
var screen_w:float = 0

var wave_number:int = 0
var wave_enemy_number:int = 0
var curr_template:int = 0
var to_spawn:int = 0
var alive:int = 0
var enemy_hp:int = 0
var enemy_points:int = 0
var enemy_speed:float = 0
var is_running:bool = false

@export var enemies_container: Node

signal enemy_died(points)
signal wave_started(n)

func _ready() -> void:
	screen_w = get_viewport().get_visible_rect().size.x
	start_wave()

func stop():
	$SpawnTimer.stop()
	$WaveDelay.stop()
	is_running = false

func start_wave():
	is_running = true
	wave_number += 1
	wave_started.emit(wave_number)
	curr_template = (wave_number-1) % TEMPLATES.size()

	enemy_hp = min(2 + int((wave_number - 1) / 5.0), 12)
	enemy_speed = 50 + 40.0 * wave_number / (wave_number + 8.0)
	enemy_points = enemy_hp * 50

	wave_enemy_number = DEF_ENEMY_PER_WAVE * wave_number
	to_spawn = wave_enemy_number

	$"SpawnTimer".wait_time = max(WAVE_DURATION / wave_enemy_number, MIN_INTERVAL)
	$SpawnTimer.start()
	print("Wave: " + str(wave_number))
	print("Enemy num: " + str(wave_enemy_number))
	print("Curr template: " + str(TEMPLATES[curr_template]))


func _on_spawn_timer_timeout() -> void:
	if to_spawn <= 0:	
		match TEMPLATES[curr_template]:
			"rain":
				spawn_rain()
			"row":
				spawn_row()
			"curve":
				spawn_curve()
			_:
				spawn_rain()
				printerr("Error: Unexpected template number")
			
		to_spawn -= 1
		if to_spawn <= 0:
			$SpawnTimer.stop()

func create_enemy(position: Vector2) -> void:
	var enemy = ENEMY_PLAN.instantiate()
	enemies_container.add_child(enemy)
	enemy.global_position = position
	enemy.hp = enemy_hp
	enemy.speed = enemy_speed
	enemy.points = enemy_points

	#connecting signals
	enemy.died.connect(_on_enemy_died)
	enemy.tree_exited.connect(_on_enemy_gone)

	alive += 1

func spawn_rain():
	if is_running and to_spawn > 0:
		create_enemy(Vector2(randf_range(ENEMY_MARGIN, screen_w - ENEMY_MARGIN), -20))

func spawn_row():
	var position = Vector2(ENEMY_MARGIN, -20)
	
	while is_running and to_spawn > 0:
		create_enemy(position)
		if !(position.x > screen_w):
			print("pos: " + str(position))
			position = Vector2(position.x + ENEMY_MARGIN * 3.5, -20)
		else: 
			break
		

func spawn_curve():
	var where = ENEMY_MARGIN
	var position = 0
	
	if is_running and to_spawn > 0:
		position = Vector2(where, -20)
		create_enemy(position)

func _on_wave_delay_timeout() -> void:
	if is_running:
		start_wave()

func _on_enemy_died(points: Variant) -> void:
	enemy_died.emit(points)

func _on_enemy_gone():
	alive -= 1
	if is_running and to_spawn == 0 and $WaveDelay.is_stopped() and alive <= wave_enemy_number * 0.06:
		$WaveDelay.start()
		print("wave cleared")
