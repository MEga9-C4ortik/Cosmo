extends Label

func _on_player_hp_changed(value: Variant) -> void:
	text = "HP: " + str(value)
