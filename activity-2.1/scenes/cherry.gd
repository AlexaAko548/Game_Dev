extends Area2D



func _on_body_entered(body: Node2D) -> void:
	# Check if the player touched it
	if body.is_in_group("Player"):
		GameManager.add_point()
		# 1. Turn off collision so the player can't grab it twice
		$CollisionShape2D.set_deferred("disabled", true)
		
		# 2. Make the cherry turn invisible instantly
		visible = false 
		
		# 3. Play the sound
		$pickupSound.play()
		
		# 4. Wait for the audio file to completely finish playing
		await $pickupSound.finished
		
		# 5. Now it is safe to delete the cherry
		queue_free()
