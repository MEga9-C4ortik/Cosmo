extends Area2D

const SPEED: float = 400
const OFFSCREEN_MARGIN: int = 10
var dmg = 1

func _physics_process(delta: float) -> void:
	position.y += SPEED * delta

	var screen = get_viewport_rect().size
	if global_position.y > screen.y + OFFSCREEN_MARGIN:
		queue_free()
	
	
