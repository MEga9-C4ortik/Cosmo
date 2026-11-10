extends Label

func _on_game_manager_score_changed(score) -> void:
	text = "Score: " + str(score)
