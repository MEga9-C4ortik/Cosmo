extends  Area2D

const OFFSCREEN_MARGIN = 10
var speed = 50
var points = 100
var dmg = 1
var hp = 2

signal died(points)

func _physics_process(delta: float) -> void:
	position.y += speed * delta

	var screen = get_viewport_rect().size
	if global_position.y > screen.y + OFFSCREEN_MARGIN:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if is_queued_for_deletion():
		return
	hp -= area.dmg
	if hp <= 0:
		died.emit(points)
		queue_free()
	area.queue_free()
	
