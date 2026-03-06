extends Area2D


func _on_body_entered(body: Node2D) -> void:
	# Make sure only the Player triggers the transition
	if body.is_in_group("Player"):
		print("You won Level 1!")
		
		# Replace the string below with the ACTUAL path to your Level 2 scene
		get_tree().change_scene_to_file("res://scenes/level2.tscn")
