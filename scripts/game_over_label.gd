extends Label


func _on_game_manager_game_over(final_score: Variant) -> void:
	show()
	text = "GAME OVER \nSCORE: " + str(final_score) + "\nPress R to restart"
