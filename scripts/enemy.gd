extends  Area2D

const SPEED = 50
const OFFSCREEN_MARGIN = 10
const POINTS = 100
var dmg = 2
var hp = 2

signal died(points)

func _physics_process(delta: float) -> void:
	position.y += SPEED * delta

	var screen = get_viewport_rect().size
	if global_position.y > screen.y + OFFSCREEN_MARGIN:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if is_queued_for_deletion():
		return
	hp -= area.dmg
	if hp <= 0:
		died.emit(POINTS)
		queue_free()
	area.queue_free()
	
