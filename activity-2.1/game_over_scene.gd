extends CanvasLayer

func _on_button_pressed() -> void:
	# 1. Reset the points back to whatever they were at the start of the level
	GameManager.reset_level_score()
	
	# 2. Reload the level
	get_tree().reload_current_scene()
	
	# 3. Delete this Game Over screen so it doesn't stay stuck on the screen
	queue_free()
