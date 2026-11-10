extends Label


func _on_game_manager_game_over(is_new_record, score, record) -> void:
	show()
	if is_new_record and score >= 0:
		text = "GAME OVER \nNEW RECORD!: " + str(score) + "\nPress R to restart"
	else:
		text = "GAME OVER \nSCORE: " + str(score) + "\nRECORD: " + str(record) + "\nPress R to restart"
