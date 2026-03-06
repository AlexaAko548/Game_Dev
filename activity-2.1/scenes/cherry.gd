extends Area2D
@onready var game_manager: Node = %GameManager



func _on_body_entered(body: Node2D) -> void:
	# 2. Check if the thing collecting the cherry is the Player
	if body.is_in_group("Player"):
		
		# 3. Tell the Game Manager to run the add_point function!
		game_manager.add_point()
		
		# 4. Delete the cherry from the level so it can't be collected again
		queue_free()
