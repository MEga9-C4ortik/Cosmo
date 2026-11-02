extends Label

func _on_game_manager_score_changed(value: Variant) -> void:
	text = "Score: " + str(value)
