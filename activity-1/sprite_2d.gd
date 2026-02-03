extends Sprite2D

var speed = 200

func _process(delta):
	# This moves the node to the right every frame
	position.x += speed * delta
	
	# Optional: Reset position if it goes off screen
	if position.x > 1200:
		position.x = 0
