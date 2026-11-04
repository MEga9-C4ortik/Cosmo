extends Label

func _on_wave_manager_wave_started(n: Variant) -> void:
	show()
	text = "Wave " + str(n)
	await get_tree().create_timer(2.0).timeout
	hide()
