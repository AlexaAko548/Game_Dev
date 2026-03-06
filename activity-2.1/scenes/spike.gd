extends Area2D
@onready var timer: Timer = $Timer


func _on_body_entered(body: Node2D) -> void:
	# This uses the "body" parameter, which removes the warning!
	# It also makes sure ONLY the player triggers the trap.
	if body.is_in_group("Player"):
		print("You died!")
		timer.start()


func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
