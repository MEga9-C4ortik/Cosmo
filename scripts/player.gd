extends CharacterBody2D

const BULLET_SCENE = preload("res://scenes/player_bullet.tscn")
const MARGIN = 15
const SPEED = 220
const ACCEL = 600

var fire_cooldown: float = 0.55
var hp: int = 5
var player_dmg: float = 1
var fire_timer: float = 0

signal died()
signal hp_changed(value)

func _ready() -> void:
	if hp > 0:
		hp_changed.emit(hp)

func _physics_process(delta: float) -> void:
	handle_movement(delta)
	handle_shooting(delta)

func handle_movement(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = velocity.move_toward(direction * SPEED, ACCEL * delta)
	move_and_slide()
	
	var screen = get_viewport_rect().size
	var old_position = position
	position.x = clamp(position.x, MARGIN, screen.x - MARGIN)
	position.y = clamp(position.y, MARGIN, screen.y - MARGIN)
	
	if position.x !=  old_position.x:
		velocity.x = 0
	if position.y !=  old_position.y:
		velocity.y = 0

func handle_shooting(delta: float) -> void:
	fire_timer -=  delta
	
	if Input.is_action_pressed("shoot") and fire_timer <= 0:
			var bullet = BULLET_SCENE.instantiate()
			get_parent().add_child(bullet)
			bullet.global_position = $Muzzle.global_position
			bullet.dmg = player_dmg
			fire_timer = fire_cooldown


func _on_hit_box_area_entered(area: Area2D) -> void:
	if is_queued_for_deletion():
		return
	hp -= area.dmg
	if hp > 0:
		hp_changed.emit(hp)
	else:
		hp_changed.emit(0)
		died.emit()
		queue_free()
