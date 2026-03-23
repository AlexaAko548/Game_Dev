extends Area2D
# Using an export variable means you can click on the spike or fire in the Inspector
# and change how much damage it does without opening the script again!
@export var damage_amount: int = 1 

func _on_body_entered(body: Node2D) -> void:
	# Check if the thing that touched the trap is the Player
	if body.is_in_group("Player"):
		
		# Check if the Player actually has the take_damage function
		if body.has_method("take_damage"):
			
			# Apply the damage!
			body.take_damage(damage_amount, global_position.x)
