extends Area2D
@export var next_level_path: String
@onready var color_rect = $CanvasLayer/ColorRect


func _on_body_entered(body: Node2D) -> void:
	# Make sure only the Player triggers the transition
	if body.is_in_group("Player"):
		$CollisionShape2D.set_deferred("disabled", true)
		
		# Create a Tween to animate the fade
		var tween = get_tree().create_tween()
		
		# Tell the tween to animate the ColorRect's "color:a" (Alpha) property to 1.0 (fully opaque) over 1 second
		tween.tween_property(color_rect, "color:a", 1.0, 1.0)
		
		# Wait for the tween animation to finish
		await tween.finished
		
		# Then change the scene!
		if next_level_path != "":
			get_tree().change_scene_to_file(next_level_path)
