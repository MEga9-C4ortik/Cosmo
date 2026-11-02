extends Node

const ENEMY_PLAN = preload("res://scenes/enemy.tscn")
const ENEMY_MARGIN = 7.5
var enemy_interval = 3

@export var enemies_container: Node

signal enemy_died(points)

func _ready() -> void:
	$"SpawnTimer".wait_time = enemy_interval

func _on_spawn_timer_timeout() -> void:
	var enemy = ENEMY_PLAN.instantiate()
	enemies_container.add_child(enemy)
	enemy.global_position = Vector2(50, -20)
	enemy.died.connect(_on_enemy_died)

func _on_enemy_died(points: Variant) -> void:
	enemy_died.emit(points)

func stop() -> void:
	$SpawnTimer.stop()
